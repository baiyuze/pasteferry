package com.pasteferry.app

import android.Manifest
import android.content.ContentValues
import android.content.Context
import android.content.pm.PackageManager
import android.media.MediaScannerConnection
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.webkit.MimeTypeMap
import androidx.annotation.RequiresApi
import java.io.File
import java.io.IOException

/** Android 9 使用按需授权的公共目录；Android 10+ 使用无需存储权限的 MediaStore。 */
internal class FileSaver(private val context: Context) {
    fun needsStoragePermission(): Boolean =
        Build.VERSION.SDK_INT < Build.VERSION_CODES.Q &&
            context.checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED

    fun save(paths: List<String>): Int {
        var n = 0
        for (path in paths) {
            val f = File(path)
            val files = if (f.isDirectory) f.walkTopDown().filter { it.isFile }.toList() else listOf(f)
            for (file in files) {
                val sub = if (f.isDirectory) file.parentFile!!.relativeTo(f.parentFile!!).path else ""
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) saveScoped(file, sub)
                else saveLegacy(file, sub)
                n++
            }
        }
        return n
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    private fun saveScoped(file: File, sub: String) {
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
        val resolver = context.contentResolver
        val uri = resolver.insert(collection, values) ?: throw IOException("Cannot save ${file.name}")
        try {
            val out = resolver.openOutputStream(uri) ?: throw IOException("Cannot open ${file.name}")
            out.use { file.inputStream().use { input -> input.copyTo(it) } }
            resolver.update(uri, ContentValues().apply { put(MediaStore.MediaColumns.IS_PENDING, 0) }, null, null)
        } catch (e: Exception) {
            resolver.delete(uri, null, null)
            throw e
        }
    }

    @Suppress("DEPRECATION")
    private fun saveLegacy(file: File, sub: String) {
        // 即使宿主忘记授权，也不能绕过用户选择去写公共目录。
        if (needsStoragePermission()) throw SecurityException(context.getString(R.string.save_storage_permission))
        val mime = mimeOf(file)
        val collection = if (mime.startsWith("image/")) Environment.DIRECTORY_PICTURES else Environment.DIRECTORY_DOWNLOADS
        val root = File(Environment.getExternalStoragePublicDirectory(collection), "PasteFerry")
        val dir = if (sub.isEmpty()) root else File(root, sub)
        if (!dir.mkdirs() && !dir.isDirectory) throw IOException("Cannot create ${dir.path}")
        var output = File(dir, file.name)
        var suffix = 1
        while (!output.createNewFile()) {
            val ext = file.extension.let { if (it.isEmpty()) "" else ".$it" }
            output = File(dir, "${file.nameWithoutExtension} (${suffix++})$ext")
        }
        try {
            output.outputStream().use { out -> file.inputStream().use { it.copyTo(out) } }
            MediaScannerConnection.scanFile(context, arrayOf(output.absolutePath), arrayOf(mime), null)
        } catch (e: Exception) {
            output.delete()
            throw e
        }
    }

    companion object {
        fun mimeOf(f: File): String =
            MimeTypeMap.getSingleton().getMimeTypeFromExtension(f.extension.lowercase()) ?: "application/octet-stream"
    }
}
