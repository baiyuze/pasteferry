package com.pasteferry.app

import android.app.Application
import android.content.ClipData
import android.content.ContentProvider
import android.content.ContentValues
import android.content.Intent
import android.content.pm.ProviderInfo
import android.database.Cursor
import android.database.MatrixCursor
import android.net.Uri
import android.os.ParcelFileDescriptor
import android.provider.OpenableColumns
import org.json.JSONObject
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
@Config(sdk = [28, 29, 33, 36], application = Application::class)
class IncomingShareTest {
    private val app: Application get() = RuntimeEnvironment.getApplication()
    private val root get() = File(app.filesDir, "pasteferry")
    private lateinit var provider: Source

    class Source : ContentProvider() {
        val files = mutableMapOf<Uri, File>()
        var beforeOpen: (() -> Unit)? = null
        override fun onCreate() = true
        override fun getType(uri: Uri) = "application/octet-stream"
        override fun query(uri: Uri, projection: Array<out String>?, selection: String?, args: Array<out String>?, order: String?): Cursor =
            MatrixCursor(arrayOf(OpenableColumns.DISPLAY_NAME, OpenableColumns.SIZE)).apply {
                val file = files[uri]!!
                addRow(arrayOf(file.name, file.length()))
            }
        override fun openFile(uri: Uri, mode: String): ParcelFileDescriptor {
            beforeOpen?.invoke()
            return ParcelFileDescriptor.open(files[uri]!!, ParcelFileDescriptor.MODE_READ_ONLY)
        }
        override fun insert(uri: Uri, values: ContentValues?): Uri? = null
        override fun delete(uri: Uri, selection: String?, args: Array<out String>?) = 0
        override fun update(uri: Uri, values: ContentValues?, selection: String?, args: Array<out String>?) = 0
    }

    @Before fun setup() {
        root.deleteRecursively()
        provider = Source()
        provider.attachInfo(app, ProviderInfo().apply { authority = "sharing.test.source"; exported = true })
        ShadowContentResolver.registerProviderInternal("sharing.test.source", provider)
    }

    private fun source(name: String, text: String): Uri {
        val file = File(app.cacheDir, "source/$name").apply { parentFile!!.mkdirs(); writeText(text) }
        return Uri.parse("content://sharing.test.source/${provider.files.size}").also { provider.files[it] = file }
    }
    private fun batch(): JSONObject = JSONObject(File(root, "share-inbox").listFiles()!!.single { it.extension == "json" }.readText())

    @Test fun extraStreamsAndClipDataFormOneDeduplicatedBatch() {
        val first = source("中文 'one%.txt", "one")
        val second = source("two.txt", "two")
        val intent = Intent(Intent.ACTION_SEND_MULTIPLE).putParcelableArrayListExtra(Intent.EXTRA_STREAM, arrayListOf(first, second))
        intent.clipData = ClipData.newRawUri("one", first)
        assertEquals(listOf(first, second), IncomingShare(app).uris(intent))
        IncomingShare(app).receive(intent)
        val paths = batch().getJSONArray("paths")
        assertEquals(2, paths.length())
        assertEquals("one", File(paths.getString(0)).readText())
        assertTrue(paths.getString(0).startsWith(File(root, "share-staging").path))
        assertEquals("two", File(paths.getString(1)).readText())
        assertFalse(File(root, "share-inbox").listFiles()!!.any { it.name.endsWith(".importing") })
    }

    @Test fun singleStreamUsesTypedParcelableCompatibility() {
        val file = source("single.txt", "single")
        val intent = Intent(Intent.ACTION_SEND).putExtra(Intent.EXTRA_STREAM, file)
        IncomingShare(app).receive(intent)
        assertEquals(1, batch().getJSONArray("paths").length())
    }

    @Test fun textOnlyIsRejectedWithAnActionableResult() {
        IncomingShare(app).receive(Intent(Intent.ACTION_SEND).putExtra(Intent.EXTRA_TEXT, "private text"))
        assertEquals("files_only", batch().getString("error"))
        assertEquals(0, batch().getJSONArray("paths").length())
    }

    @Test fun ownProviderAndFileUrisCannotImportPrivateAppData() {
        val intent = Intent(Intent.ACTION_SEND).putExtra(Intent.EXTRA_STREAM, Uri.parse("content://${app.packageName}.files/data/daemon.json"))
        IncomingShare(app).receive(intent)
        assertEquals(0, batch().getJSONArray("paths").length())
        assertFalse(batch().getString("error").isEmpty())
    }

    @Test fun cancellingImportRemovesOnlyItsStagingFiles() {
        val file = source("cancel.txt", "cancel")
        provider.beforeOpen = { File(root, "share-inbox").listFiles()!!.filter { it.name.endsWith(".importing") }.forEach { it.delete() } }
        IncomingShare(app).receive(Intent(Intent.ACTION_SEND).putExtra(Intent.EXTRA_STREAM, file))
        assertFalse(File(root, "share-inbox").listFiles()!!.any { it.extension == "json" })
        assertTrue(provider.files[file]!!.exists())
    }

    @Test fun interruptedProcessLeavesAVisibleRetryResult() {
        val id = "interrupted-0001"
        File(root, "share-inbox/$id.importing").apply { parentFile!!.mkdirs(); writeText("") }
        val copy = File(root, "share-staging/$id/file.txt").apply { parentFile!!.mkdirs(); writeText("incomplete") }
        IncomingShare(app).recoverInterrupted()
        assertTrue(batch().getString("error").contains("interrupted"))
        assertFalse(copy.exists())
    }
}
