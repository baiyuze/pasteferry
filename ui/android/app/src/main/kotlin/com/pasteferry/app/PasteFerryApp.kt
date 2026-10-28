package com.pasteferry.app

import android.app.Application
import android.content.Context

class PasteFerryApp : Application() {
    override fun onCreate() {
        super.onCreate()
        Core.init(this)
    }
}

/** 「后台保持连接」开关（design/phone-sync.md 3.2.5 节），默认开。存在宿主这边：Go 核心没启动时也要读它 */
object Prefs {
    private const val FILE = "pasteferry"
    private const val KEEP_ALIVE = "keep_alive"

    fun keepAlive(c: Context): Boolean =
        c.getSharedPreferences(FILE, Context.MODE_PRIVATE).getBoolean(KEEP_ALIVE, true)

    fun setKeepAlive(c: Context, on: Boolean) {
        c.getSharedPreferences(FILE, Context.MODE_PRIVATE).edit().putBoolean(KEEP_ALIVE, on).apply()
    }
}
