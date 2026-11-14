package com.pasteferry.app

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.provider.OpenableColumns
import java.io.File
import java.util.UUID

/** System pickers request a batch; URI identity survives repeated cache imports. */
class BatchPicker(private val context: Context) {
    fun intent(photos: Boolean): Intent {
        if (photos && Build.VERSION.SDK_INT >= 33) {
            return Intent(MediaStore.ACTION_PICK_IMAGES).apply {
                type = "image/*"
                putExtra(MediaStore.EXTRA_PICK_IMAGES_MAX, MediaStore.getPickImagesMaxLimit())
            }
        }
        return documentIntent(photos)
    }

    fun documentIntent(photos: Boolean): Intent =
        Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = if (photos) "image/*" else "*/*"
            putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
        }

    fun importFiles(data: Intent): List<Map<String, Any>> {
        // Some providers supply both data and ClipData. Prefer the complete batch.
        val uris = data.clipData?.let { clip ->
            (0 until clip.itemCount).map { clip.getItemAt(it).uri }
        } ?: listOfNotNull(data.data)
        return importUris(uris, File(context.cacheDir, "picked/${UUID.randomUUID()}"))
    }

    fun importUris(uris: List<Uri>, directory: File, cancelled: () -> Boolean = { false }): List<Map<String, Any>> {
        try {
            return uris.distinct().mapIndexed { index, uri ->
                val name = displayName(uri)
                val target = File(directory, "$index/$name")
                check(target.parentFile!!.mkdirs())
                context.contentResolver.openInputStream(uri).use { input ->
                    requireNotNull(input) { "Cannot read selected file" }
                    target.outputStream().use { output ->
                        val buffer = ByteArray(1024 * 1024)
                        while (true) {
                            if (cancelled()) throw java.util.concurrent.CancellationException()
                            val count = input.read(buffer)
                            if (count < 0) break
                            check(directory.usableSpace > 32L * 1024 * 1024) { "Not enough free space to import shared files" }
                            output.write(buffer, 0, count)
                        }
                    }
                }
                mapOf("path" to target.path, "name" to name, "size" to target.length(), "id" to uri.toString())
            }
        } catch (e: Exception) {
            directory.deleteRecursively()
            throw e
        }
    }

    private fun displayName(uri: Uri): String {
        val name = context.contentResolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)?.use {
            if (it.moveToFirst()) it.getString(0) else null
        } ?: uri.lastPathSegment ?: "file"
        return name.replace('/', '_').replace('\\', '_').takeIf { it.isNotBlank() && it != "." && it != ".." } ?: "file"
    }
}
