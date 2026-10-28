package com.pasteferry.app

import android.app.Application
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import androidx.core.content.FileProvider
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.shadows.ShadowContentResolver
import org.robolectric.annotation.Config
import java.io.File

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [28, 36], application = Application::class)
class MediaSharingTest {
    private val app: Application get() = RuntimeEnvironment.getApplication()
    private val sharing get() = MediaSharing(app)

    @Before
    fun registerProvider() {
        // Robolectric 每个用例更换 dataDir；重新 attach 以清除 FileProvider 的静态根目录缓存。
        val authority = "${app.packageName}.files"
        val info = app.packageManager.resolveContentProvider(authority, android.content.pm.PackageManager.GET_META_DATA)!!
        val provider = FileProvider()
        provider.attachInfo(app, info)
        ShadowContentResolver.registerProviderInternal(authority, provider)
    }

    private fun picked(name: String): File = File(app.cacheDir, "a5e383bc/screenshot/$name").apply {
        parentFile!!.mkdirs()
        writeBytes(byteArrayOf(1, 2, 3, 4))
    }

    @Test
    fun pickedImageCanBeCopiedAndReadFromClipboardUri() {
        val file = picked("截图.jpg")
        val clip = sharing.clip(listOf(file.path))
        val clipboard = app.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        clipboard.setPrimaryClip(clip)
        val uri = clipboard.primaryClip!!.getItemAt(0).uri
        assertEquals("content", uri.scheme)
        assertTrue(clip.description.hasMimeType("image/jpeg"))
        assertArrayEquals(file.readBytes(), app.contentResolver.openInputStream(uri)!!.use { it.readBytes() })
    }

    @Test
    fun pickedImageShareHasStreamClipDataMimeAndReadGrant() {
        val file = picked("photo.jpg")
        val intent = sharing.intent(listOf(file.path))
        assertEquals(Intent.ACTION_SEND, intent.action)
        assertEquals("image/jpeg", intent.type)
        assertTrue(intent.flags and Intent.FLAG_GRANT_READ_URI_PERMISSION != 0)
        assertEquals(intent.clipData!!.getItemAt(0).uri,
            intent.getParcelableExtra<android.net.Uri>(Intent.EXTRA_STREAM))
        val chooser = Intent.createChooser(intent, "Share")
        assertTrue(chooser.flags and Intent.FLAG_GRANT_READ_URI_PERMISSION != 0)
        assertNotNull(chooser.clipData)
    }

    @Test
    fun multipleFilesAndCoreDataAreSupported() {
        val image = picked("photo.png")
        val core = File(app.filesDir, "pasteferry/cache/record/note.txt").apply {
            parentFile!!.mkdirs(); writeText("hello")
        }
        val intent = sharing.intent(listOf(image.path, core.path))
        assertEquals(Intent.ACTION_SEND_MULTIPLE, intent.action)
        assertEquals("*/*", intent.type)
        assertEquals(2, intent.clipData!!.itemCount)
        assertEquals(2, sharing.clip(listOf(image.path, core.path)).itemCount)
    }

    @Test
    fun missingFilesAndUnconfiguredPrivatePathsAreRejected() {
        assertThrows(java.io.FileNotFoundException::class.java) {
            sharing.clip(listOf(File(app.cacheDir, "missing.jpg").path))
        }
        val privateFile = File(app.filesDir, "private.txt").apply { writeText("not shared") }
        assertThrows(IllegalArgumentException::class.java) { sharing.uriFor(privateFile.path) }
        assertThrows(IllegalArgumentException::class.java) { sharing.intent(emptyList()) }
    }
}
