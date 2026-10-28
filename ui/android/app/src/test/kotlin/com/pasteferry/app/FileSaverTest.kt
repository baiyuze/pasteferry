package com.pasteferry.app

import android.Manifest
import android.app.Application
import android.os.Environment
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.Shadows.shadowOf
import org.robolectric.annotation.Config
import org.robolectric.shadows.ShadowEnvironment
import java.io.File

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [28], application = Application::class)
class FileSaverTest {
    private val app: Application get() = RuntimeEnvironment.getApplication()
    private val saver get() = FileSaver(app)

    @Before
    fun mountedStorage() {
        ShadowEnvironment.setExternalStorageState(Environment.MEDIA_MOUNTED)
    }

    @Test
    fun android9NeedsPermissionAndDoesNotWriteWhenDenied() {
        shadowOf(app).denyPermissions(Manifest.permission.WRITE_EXTERNAL_STORAGE)
        assertTrue(saver.needsStoragePermission())
        val source = File(app.cacheDir, "denied.txt").apply { writeText("private") }
        assertThrows(SecurityException::class.java) { saver.save(listOf(source.path)) }
        assertFalse(File(downloads(), "denied.txt").exists())
        shadowOf(app).grantPermissions(Manifest.permission.WRITE_EXTERNAL_STORAGE)
        assertFalse(saver.needsStoragePermission())
    }

    @Test
    fun android9SavesFilesAndKeepsExistingFiles() {
        shadowOf(app).grantPermissions(Manifest.permission.WRITE_EXTERNAL_STORAGE)
        val source = File(app.cacheDir, "note.txt").apply { writeText("first") }
        assertEquals(1, saver.save(listOf(source.path)))
        source.writeText("second")
        assertEquals(1, saver.save(listOf(source.path)))
        assertEquals("first", File(downloads(), "note.txt").readText())
        assertEquals("second", File(downloads(), "note (1).txt").readText())
    }

    @Test
    fun android9SavesImagesInPicturesAndPreservesFolderStructure() {
        shadowOf(app).grantPermissions(Manifest.permission.WRITE_EXTERNAL_STORAGE)
        val folder = File(app.cacheDir, "trip")
        val photo = File(folder, "photos/photo.png").apply { parentFile!!.mkdirs(); writeBytes(byteArrayOf(1, 2, 3)) }
        val note = File(folder, "notes/readme.txt").apply { parentFile!!.mkdirs(); writeText("hello") }
        assertEquals(2, saver.save(listOf(folder.path)))
        val pictures = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
        assertArrayEquals(photo.readBytes(), File(pictures, "PasteFerry/trip/photos/photo.png").readBytes())
        assertEquals(note.readText(), File(downloads(), "trip/notes/readme.txt").readText())
    }

    @Test
    @Config(sdk = [29])
    fun android10DoesNotAskForLegacyStoragePermission() {
        shadowOf(app).denyPermissions(Manifest.permission.WRITE_EXTERNAL_STORAGE)
        assertFalse(saver.needsStoragePermission())
    }

    @Suppress("DEPRECATION")
    private fun downloads(): File =
        File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS), "PasteFerry")
}
