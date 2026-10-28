package com.pasteferry.app

import android.content.ClipData
import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.core.content.FileProvider
import java.io.File
import java.io.FileNotFoundException

/** 复制和系统分享共用的 URI 与只读授权。支持 Go 数据和文件选择器的私有缓存。 */
internal class MediaSharing(private val context: Context) {
    fun uriFor(path: String): Uri {
        val file = File(path)
        if (!file.isFile || !file.canRead()) throw FileNotFoundException(file.name)
        return FileProvider.getUriForFile(context, "${context.packageName}.files", file)
    }

    fun clip(paths: List<String>): ClipData {
        require(paths.isNotEmpty()) { "No files" }
        val uris = paths.map(::uriFor)
        return ClipData.newUri(context.contentResolver, context.getString(R.string.app_name), uris.first()).apply {
            for (uri in uris.drop(1)) addItem(context.contentResolver, ClipData.Item(uri))
        }
    }

    fun intent(paths: List<String>): Intent {
        val files = paths.map(::File).flatMap {
            if (it.isDirectory) it.walkTopDown().filter(File::isFile).toList() else listOf(it)
        }
        require(files.isNotEmpty()) { "No files" }
        val clip = clip(files.map { it.path })
        val uris = ArrayList((0 until clip.itemCount).map { clip.getItemAt(it).uri })
        val mimes = files.map { FileSaver.mimeOf(it) }.distinct()
        val mime = mimes.singleOrNull() ?: if (mimes.all { it.startsWith("image/") }) "image/*" else "*/*"
        return (if (uris.size == 1) {
            Intent(Intent.ACTION_SEND).putExtra(Intent.EXTRA_STREAM, uris.first())
        } else {
            Intent(Intent.ACTION_SEND_MULTIPLE).putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris)
        }).apply {
            type = mime
            clipData = clip
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
    }
}
