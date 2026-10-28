package com.pasteferry.app

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.net.Uri
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.util.Log
import androidx.core.content.FileProvider
import com.pasteferry.core.mobile.Host
import com.pasteferry.core.mobile.Mobile
import java.io.File
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

/**
 * App 进程里唯一的 Go 核心（design/phone-sync.md 3.3.1 节）。
 *
 * 界面（MainActivity）和前台服务（SyncService）都经它启停；Flutter 界面经本机 gRPC 连进 Go 核心，
 * 端口与 token 在数据目录的 daemon.json 里。
 */
object Core : Host {
    private const val TAG = "PasteFerry"

    private lateinit var app: Context
    private val main = Handler(Looper.getMainLooper())
    private var multicast: WifiManager.MulticastLock? = null

    /** 常驻通知的内容：在线设备名、最近收到的一条的来源与类型 */
    @Volatile var online: List<String> = emptyList(); private set
    @Volatile var lastFrom = ""; private set
    @Volatile var lastKind = ""; private set

    /** 状态变了，在主线程调用。SyncService 据此更新常驻通知 */
    var onStatus: (() -> Unit)? = null

    fun init(context: Context) {
        app = context.applicationContext
    }

    /** Go 核心的数据目录：App 私有目录，别的 App 读不到；FileProvider 也只开放这里（res/xml/file_paths.xml） */
    fun dataDir(context: Context = app): File = File(context.filesDir, "pasteferry")

    val running: Boolean get() = Mobile.running()

    @Synchronized
    fun start() {
        if (Mobile.running()) return
        // 没有它 Android 会丢掉组播包，mDNS 发现不了局域网里的电脑
        val wifi = app.getSystemService(WifiManager::class.java)
        multicast = wifi?.createMulticastLock("pasteferry")?.apply {
            setReferenceCounted(false)
            acquire()
        }
        Mobile.start(dataDir().path, deviceName(), versionName(), this)
        Log.i(TAG, "Go 核心已启动")
    }

    @Synchronized
    fun stop() {
        if (!Mobile.running()) return
        Mobile.stop()
        multicast?.release()
        multicast = null
        online = emptyList()
        Log.i(TAG, "Go 核心已停止")
    }

    /** 第一次运行时的设备名：用户在系统设置里起的名字，没有时用型号 */
    private fun deviceName(): String =
        Settings.Global.getString(app.contentResolver, Settings.Global.DEVICE_NAME)?.takeIf { it.isNotBlank() }
            ?: Build.MODEL

    private fun versionName(): String =
        app.packageManager.getPackageInfo(app.packageName, 0).versionName ?: "dev"

    fun uriFor(path: String): Uri =
        FileProvider.getUriForFile(app, "${app.packageName}.files", File(path))

    // ─────────────── Host：Go 核心回调 ───────────────

    /** Android 写剪贴板不需要焦点，App 在后台也能写；但要在主线程调用，这里等它写完再返回结果给 Go */
    override fun writeClipboard(kind: String, text: String, html: String, paths: String) {
        val clip = when (kind) {
            "text" -> ClipData.newPlainText(label(), text)
            "html" -> ClipData.newHtmlText(label(), text, html)
            "image", "files" -> {
                val uris = paths.split('\n').filter { it.isNotEmpty() }.map(::uriFor)
                require(uris.isNotEmpty()) { "没有文件" }
                val cr = app.contentResolver
                ClipData.newUri(cr, label(), uris.first()).apply {
                    for (u in uris.drop(1)) addItem(cr, ClipData.Item(u))
                }
            }
            else -> throw IllegalArgumentException("不支持的类型 $kind")
        }
        onMain { app.getSystemService(ClipboardManager::class.java).setPrimaryClip(clip) }
    }

    override fun statusChanged(online: String, lastFrom: String, lastKind: String) {
        this.online = online.split('\n').filter { it.isNotEmpty() }
        this.lastFrom = lastFrom
        this.lastKind = lastKind
        main.post { onStatus?.invoke() }
    }

    private fun label(): String = app.getString(R.string.app_name)

    private fun onMain(block: () -> Unit) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            block()
            return
        }
        var error: Throwable? = null
        val done = CountDownLatch(1)
        main.post {
            try {
                block()
            } catch (t: Throwable) {
                error = t
            } finally {
                done.countDown()
            }
        }
        if (!done.await(5, TimeUnit.SECONDS)) throw IllegalStateException("写剪贴板超时")
        error?.let { throw it }
    }
}
