package com.pasteferry.app

import android.app.Application
import android.content.ClipData
import android.content.Intent
import android.provider.MediaStore
import androidx.core.content.FileProvider
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config
import org.robolectric.shadows.ShadowContentResolver
import java.io.File

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [28, 33, 36], application = Application::class)
class BatchPickerTest {
    private val app: Application get() = RuntimeEnvironment.getApplication()
    private val picker get() = BatchPicker(app)

    @Before
    fun registerProvider() {
        val authority = "${app.packageName}.files"
        val info = app.packageManager.resolveContentProvider(authority, android.content.pm.PackageManager.GET_META_DATA)!!
        val provider = FileProvider()
        provider.attachInfo(app, info)
        ShadowContentResolver.registerProviderInternal(authority, provider)
    }

    private fun source(name: String, text: String): android.net.Uri {
        val file = File(app.cacheDir, "source/$name").apply { parentFile!!.mkdirs(); writeText(text) }
        return FileProvider.getUriForFile(app, "${app.packageName}.files", file)
    }

    @Test
    fun documentsRequestMultipleItemsWithNoTypeRestriction() {
        val intent = picker.intent(false)
        assertEquals(Intent.ACTION_OPEN_DOCUMENT, intent.action)
        assertEquals("*/*", intent.type)
        assertTrue(intent.getBooleanExtra(Intent.EXTRA_ALLOW_MULTIPLE, false))
        assertTrue(intent.hasCategory(Intent.CATEGORY_OPENABLE))
    }

    @Test
    fun photosRequestBatchOnNewAndOldAndroid() {
        val intent = picker.intent(true)
        assertEquals("image/*", intent.type)
        if (android.os.Build.VERSION.SDK_INT >= 33) {
            assertEquals(MediaStore.ACTION_PICK_IMAGES, intent.action)
            assertTrue(intent.getIntExtra(MediaStore.EXTRA_PICK_IMAGES_MAX, 1) > 1)
        } else {
            assertEquals(Intent.ACTION_OPEN_DOCUMENT, intent.action)
            assertTrue(intent.getBooleanExtra(Intent.EXTRA_ALLOW_MULTIPLE, false))
        }
    }

    @Test
    fun importsWholeBatchWhenProviderAlsoReturnsSingleData() {
        val a = source("photo.jpg", "photo bytes")
        val b = source("note.txt", "note bytes")
        val clips = ClipData.newRawUri("files", a).apply {
            addItem(ClipData.Item(b))
            addItem(ClipData.Item(a))
        }
        val files = picker.importFiles(Intent().apply { data = a; clipData = clips })
        assertEquals(listOf(a.toString(), b.toString()), files.map { it["id"] })
        assertEquals(listOf("photo.jpg", "note.txt"), files.map { it["name"] })
        assertEquals(listOf("photo bytes", "note bytes"), files.map { File(it["path"] as String).readText() })
        assertEquals(listOf(11L, 10L), files.map { it["size"] })
        // Re-selecting the same URI creates a new cache file but preserves identity.
        val again = picker.importFiles(Intent().setData(a)).single()
        assertEquals(files.first()["id"], again["id"])
        assertNotEquals(files.first()["path"], again["path"])
    }

    @Test
    fun emptyResultHasNoFiles() {
        assertTrue(picker.importFiles(Intent()).isEmpty())
    }
}
