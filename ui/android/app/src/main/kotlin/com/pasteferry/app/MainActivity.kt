package com.pasteferry.app

import android.Manifest
import android.annotation.SuppressLint
import android.content.Intent
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import android.util.Log
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

/**
 * Flutter 界面。和 Dart 之间只有一个平台通道 pasteferry/host：启停 Go 核心、后台开关、保存与分享、权限。
 * 其余的（记录、发送、配对、设置）都由 Dart 经 gRPC 直接和 Go 核心说。
 */
class MainActivity : FlutterActivity() {
    private val io = Executors.newSingleThreadExecutor()
    private var pendingNotification: MethodChannel.Result? = null
    private var pendingSave: Pair<List<String>, MethodChannel.Result>? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pasteferry/host")
            .setMethodCallHandler(::handle)
    }

    override fun onStart() {
        super.onStart()
        startCore()
    }

    override fun onStop() {
        super.onStop()
        // 关了「后台保持连接」：离开前台就断开，回来再连（3.2.5 节）
        if (!Prefs.keepAlive(this) && !isChangingConfigurations) Core.stop()
    }

    override fun onDestroy() {
        io.shutdown()
        super.onDestroy()
    }

    private fun startCore() {
        if (Prefs.keepAlive(this)) SyncService.start(this)
        // 前台服务的启动是异步的：界面这边先把核心拉起来，Dart 马上就能连
        Core.start()
    }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "start" -> background(result) {
                startCore()
                mapOf("dataDir" to Core.dataDir().path)
            }
            "keepAlive" -> result.success(Prefs.keepAlive(this))
            "setKeepAlive" -> {
                val on = call.arguments as Boolean
                Prefs.setKeepAlive(this, on)
                if (on) SyncService.start(this) else SyncService.stop(this)
                result.success(on)
            }
            "save" -> save(call.argument<List<String>>("paths")!!, result)
            "share" -> {
                try {
                    val send = MediaSharing(this).intent(call.argument<List<String>>("paths")!!)
                    startActivity(Intent.createChooser(send, getString(R.string.share_title)))
                    result.success(null)
                } catch (e: Exception) {
                    Log.w("PasteFerry", "Cannot share selected files", e)
                    result.error("share_failed", getString(R.string.media_share_failed), null)
                }
            }
            "notifications" -> result.success(notificationState())
            "requestNotifications" -> requestNotifications(result)
            "batteryUnrestricted" -> result.success(batteryUnrestricted())
            "requestBatteryUnrestricted" -> {
                requestBatteryUnrestricted()
                result.success(null)
            }
            "onLan" -> result.success(onLan())
            "openUrl" -> {
                val url = call.argument<String>("url") ?: ""
                if (url.isEmpty()) {
                    result.success(false)
                } else {
                    try {
                        startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
                        result.success(true)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun background(result: MethodChannel.Result, work: () -> Any?) {
        io.execute {
            try {
                val value = work()
                runOnUiThread { result.success(value) }
            } catch (e: Exception) {
                runOnUiThread { result.error("failed", e.message ?: e.toString(), null) }
            }
        }
    }

    // ─────────────── 保存与分享（3.3.3 节） ───────────────

    /** Android 9 只在用户点击保存时申请存储权限；新系统不申请。 */
    private fun save(paths: List<String>, result: MethodChannel.Result) {
        if (FileSaver(this).needsStoragePermission()) {
            if (pendingSave != null) {
                result.error("busy", getString(R.string.save_permission_pending), null)
                return
            }
            pendingSave = paths to result
            requestPermissions(arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE), REQUEST_STORAGE)
        } else {
            background(result) { FileSaver(this).save(paths) }
        }
    }

    // ─────────────── 权限与系统设置 ───────────────

    /** granted、denied（可以再请求）或 blocked（只能去系统设置里打开） */
    private fun notificationState(): String {
        if (NotificationManagerCompat.from(this).areNotificationsEnabled()) return "granted"
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return "blocked"
        return if (getSharedPreferences("pasteferry", MODE_PRIVATE).getBoolean("asked_notifications", false) &&
            !shouldShowRequestPermissionRationale(Manifest.permission.POST_NOTIFICATIONS)
        ) "blocked" else "denied"
    }

    private fun requestNotifications(result: MethodChannel.Result) {
        val state = notificationState()
        if (state == "granted") return result.success(state)
        if (state == "blocked" || Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            startActivity(
                Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).putExtra(Settings.EXTRA_APP_PACKAGE, packageName),
            )
            return result.success(state)
        }
        pendingNotification?.success(state)
        pendingNotification = result
        getSharedPreferences("pasteferry", MODE_PRIVATE).edit().putBoolean("asked_notifications", true).apply()
        requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), REQUEST_NOTIFICATIONS)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_STORAGE) {
            val save = pendingSave ?: return
            pendingSave = null
            if (grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED) {
                background(save.second) { FileSaver(this).save(save.first) }
            } else {
                save.second.error("permission_denied", getString(R.string.save_storage_permission), null)
            }
            return
        }
        if (requestCode != REQUEST_NOTIFICATIONS) return
        pendingNotification?.success(notificationState())
        pendingNotification = null
        // 授权之后常驻通知才显示出来：重新发一次
        if (Prefs.keepAlive(this) && grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED) SyncService.start(this)
    }

    private fun batteryUnrestricted(): Boolean =
        getSystemService(PowerManager::class.java).isIgnoringBatteryOptimizations(packageName)

    @SuppressLint("BatteryLife")
    private fun requestBatteryUnrestricted() {
        // App 不经 Google Play 分发，可以直接弹出系统的确认框；有的国内系统不认这个动作，退回设置列表
        try {
            startActivity(Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS, Uri.parse("package:$packageName")))
        } catch (_: Exception) {
            startActivity(Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS))
        }
    }

    /** 当前网络是 Wi-Fi 或有线网：一期只在局域网里同步，不在时界面上提示 */
    private fun onLan(): Boolean {
        val cm = getSystemService(ConnectivityManager::class.java)
        val caps = cm.getNetworkCapabilities(cm.activeNetwork) ?: return false
        return caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) ||
            caps.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET)
    }

    companion object {
        private const val REQUEST_NOTIFICATIONS = 1
        private const val REQUEST_STORAGE = 2
    }
}
