package com.pasteferry.app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat
import androidx.core.content.ContextCompat

/**
 * 后台保持连接（design/phone-sync.md 3.3.3 节）：connectedDevice 类型的前台服务，持有 Go 核心与一条常驻通知。
 * 没有 dataSync 那样每天限时的规定。通知只写连接状态和最近一条的来源与类型，不写正文。
 */
class SyncService : Service() {
    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        createChannel()
        ServiceCompat.startForeground(
            this, NOTIFICATION_ID, build(), ServiceInfo.FOREGROUND_SERVICE_TYPE_CONNECTED_DEVICE,
        )
        try {
            Core.start()
        } catch (e: Exception) {
            Log.e("PasteFerry", "后台服务启动 Go 核心失败", e)
        }
        Core.onStatus = { update() }
        return START_STICKY
    }

    override fun onDestroy() {
        Core.onStatus = null
        super.onDestroy()
    }

    private fun update() {
        getSystemService(NotificationManager::class.java).notify(NOTIFICATION_ID, build())
    }

    private fun build(): Notification {
        val online = Core.online
        val title = if (online.isEmpty()) getString(R.string.notif_none)
        else getString(R.string.notif_online, online.joinToString("、"))
        val from = Core.lastFrom
        val text = if (from.isEmpty()) null else when (Core.lastKind) {
            "image" -> getString(R.string.notif_last_image, from)
            "file" -> getString(R.string.notif_last_file, from)
            else -> getString(R.string.notif_last_text, from)
        }
        val open = PendingIntent.getActivity(
            this, 0,
            Intent(this, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
        return NotificationCompat.Builder(this, CHANNEL)
            .setSmallIcon(R.drawable.ic_notification)
            .setContentTitle(title)
            .setContentText(text)
            .setContentIntent(open)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setShowWhen(false)
            .setSilent(true)
            .setForegroundServiceBehavior(NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE)
            .build()
    }

    private fun createChannel() {
        val channel = NotificationChannel(CHANNEL, getString(R.string.channel_sync), NotificationManager.IMPORTANCE_LOW)
        channel.description = getString(R.string.channel_sync_desc)
        channel.setShowBadge(false)
        getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
    }

    companion object {
        private const val CHANNEL = "sync"
        private const val NOTIFICATION_ID = 1

        fun start(c: Context) {
            ContextCompat.startForegroundService(c, Intent(c, SyncService::class.java))
        }

        fun stop(c: Context) {
            c.stopService(Intent(c, SyncService::class.java))
        }
    }
}
