package com.pasteferry.app

import android.Manifest
import android.annotation.SuppressLint
import android.content.ContentValues
import android.content.Intent
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.MediaStore
import android.provider.Settings
import android.webkit.MimeTypeMap
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.Executors

/**
 * Flutter 界面。和 Dart 之间只有一个平台通道 pasteferry/host：启停 Go 核心、后台开关、保存与分享、权限。
 * 其余的（记录、发送、配对、设置）都由 Dart 经 gRPC 直接和 Go 核心说。
 */
class MainActivity : FlutterActivity() {
    private val io = Executors.newSingleThreadExecutor()
    private var pendingNotification: MethodChannel.Result? = null

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
            "save" -> background(result) { save(call.argument<List<String>>("paths")!!) }
            "share" -> {
                share(call.argument<List<String>>("paths")!!)
                result.success(null)
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

    /** 图片存进相册的 Pictures/PasteFerry，其他文件存进「下载」的 PasteFerry 文件夹。Android 10 起不需要存储权限。返回存下的个数 */
    private fun save(paths: List<String>): Int {
        var n = 0
        for (path in paths) {
            val f = File(path)
            val files = if (f.isDirectory) f.walkTopDown().filter { it.isFile }.toList() else listOf(f)
            for (file in files) {
                val sub = if (f.isDirectory) file.parentFile!!.relativeTo(f.parentFile!!).path else ""
                saveOne(file, sub)
                n++
            }
        }
        return n
    }

    private fun saveOne(file: File, sub: String) {
        val mime = mimeOf(file)
        val image = mime.startsWith("image/")
        val collection = if (image) MediaStore.Images.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
        else MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
        val dir = (if (image) "Pictures/PasteFerry" else "Download/PasteFerry") + (if (sub.isEmpty()) "" else "/$sub")
        val values = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, file.name)
            put(MediaStore.MediaColumns.MIME_TYPE, mime)
            put(MediaStore.MediaColumns.RELATIVE_PATH, dir)
            put(MediaStore.MediaColumns.IS_PENDING, 1)
        }
        val uri = contentResolver.insert(collection, values) ?: throw IllegalStateException("无法保存 ${file.name}")
        try {
            contentResolver.openOutputStream(uri)!!.use { out -> file.inputStream().use { it.copyTo(out) } }
            contentResolver.update(uri, ContentValues().apply { put(MediaStore.MediaColumns.IS_PENDING, 0) }, null, null)
        } catch (e: Exception) {
            contentResolver.delete(uri, null, null)
            throw e
        }
    }

    private fun share(paths: List<String>) {
        val files = paths.map(::File).flatMap { if (it.isDirectory) it.walkTopDown().filter(File::isFile).toList() else listOf(it) }
        if (files.isEmpty()) return
        val uris = ArrayList<Uri>(files.map { Core.uriFor(it.path) })
        val mimes = files.map(::mimeOf).distinct()
        val type = mimes.singleOrNull() ?: if (mimes.all { it.startsWith("image/") }) "image/*" else "*/*"
        val send = if (uris.size == 1) {
            Intent(Intent.ACTION_SEND).putExtra(Intent.EXTRA_STREAM, uris.first())
        } else {
            Intent(Intent.ACTION_SEND_MULTIPLE).putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris)
        }
        send.setType(type).addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        startActivity(Intent.createChooser(send, getString(R.string.share_title)))
    }

    private fun mimeOf(f: File): String =
        MimeTypeMap.getSingleton().getMimeTypeFromExtension(f.extension.lowercase()) ?: "application/octet-stream"

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
    }
}
