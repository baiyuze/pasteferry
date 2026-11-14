package com.pasteferry.app

import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.core.content.IntentCompat
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.util.UUID
import java.util.concurrent.CancellationException
import java.util.concurrent.ConcurrentHashMap

/** URI grants are temporary. Import while the receiving Activity owns them,
 * then retain private files until the transfer is complete or cancelled. */
class IncomingShare(private val context: Context) {
    companion object {
        private val active = ConcurrentHashMap.newKeySet<String>()
    }
    private val root = File(context.filesDir, "pasteferry")
    private val inbox = File(root, "share-inbox")

    fun receive(intent: Intent) {
        val id = UUID.randomUUID().toString()
        val marker = File(inbox, "$id.importing")
        val directory = File(root, "share-staging/$id")
        active.add(id)
        try {
            check(inbox.mkdirs() || inbox.isDirectory)
            marker.writeText("")
            val uris = uris(intent)
            require(uris.isNotEmpty()) { "files_only" }
            require(uris.size <= 10000) { "Too many shared files" }
            require(uris.all { it.scheme == "content" && it.authority != "${context.packageName}.files" }) {
                "Only granted content URIs from other apps can be shared"
            }
            val files = BatchPicker(context).importUris(uris, directory) { !marker.exists() }
            publish(id, files.map { it["path"] as String }, directory.path)
        } catch (_: CancellationException) {
            directory.deleteRecursively()
        } catch (e: Exception) {
            directory.deleteRecursively()
            publish(id, emptyList(), error = e.message ?: "Cannot import shared files")
        } finally {
            marker.delete()
            active.remove(id)
        }
    }

    fun recoverInterrupted() {
        inbox.listFiles()?.filter { it.name.endsWith(".importing") }?.forEach { marker ->
            val id = marker.name.removeSuffix(".importing")
            if (!active.contains(id) && id.matches(Regex("[a-zA-Z0-9-]{8,64}"))) {
                File(root, "share-staging/$id").deleteRecursively()
                publish(id, emptyList(), error = "File import was interrupted. Share the files again.")
                marker.delete()
            }
        }
    }

    private fun publish(id: String, paths: List<String>, owned: String = "", error: String = "") {
        check(inbox.mkdirs() || inbox.isDirectory)
        val json = JSONObject().put("id", id).put("paths", JSONArray(paths))
            .put("createdAt", System.currentTimeMillis()).put("ownedDirectory", owned).put("error", error)
        val temp = File(inbox, "$id.tmp")
        temp.writeText(json.toString())
        check(temp.renameTo(File(inbox, "$id.json"))) { "Cannot queue shared files" }
    }

    fun uris(intent: Intent): List<Uri> {
        val streams = if (intent.action == Intent.ACTION_SEND_MULTIPLE)
            IntentCompat.getParcelableArrayListExtra(intent, Intent.EXTRA_STREAM, Uri::class.java).orEmpty()
        else listOfNotNull(IntentCompat.getParcelableExtra(intent, Intent.EXTRA_STREAM, Uri::class.java))
        val clips = intent.clipData?.let { data ->
            (0 until data.itemCount).mapNotNull { data.getItemAt(it).uri }
        }.orEmpty()
        return (streams + clips).distinct()
    }
}
