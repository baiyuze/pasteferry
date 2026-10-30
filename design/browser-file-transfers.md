# Browser file transfers

Added in 2.8.1 (2026-10-30).

The phone web page has an independent Send Files tab. Uploads go to the
computer's configured receive directory without creating clipboard records
or calling SubmitLocal. Computers select files from the registered browser
row in Devices. The host snapshots these explicit selections before making
them available to that browser.

The existing authenticated, encrypted web-share session and chunk transport
protect metadata and file contents. A browser supplies transfer IDs and item
indices, never host paths. Records and download snapshots are session-scoped;
the database key includes both session and transfer ID. Removing or expiring
a browser session invalidates access and removes its snapshots. Deleting an
upload record retains the files already received on the computer.

Limits: 64 files per batch, 100 records per browser, 4 GiB per uploaded file,
and 200 MiB per downloaded file. The page must remain open on the computer's
network. Downloads are assembled in browser memory and require an explicit
Save action. The resulting status means handed to the browser, not proof of
a completed disk write. Interrupted uploads must be selected again. Completed
records and queued downloads survive page reloads and host restarts.

Finalizing an upload uses an idempotent batch ID so a lost response can be
retried without creating duplicate files. Same-named files are preserved in
separate snapshot directories and safely renamed in the receive directory.

## Validation

- Go tests cover encrypted chunk reads, empty and same-named files, snapshot
  independence, restart persistence, session isolation, colliding batch IDs,
  idempotent finalization, staging cleanup, and clipboard independence.
- Race tests passed for webshare, store and RPC; the full Go suite passed.
- Browser UI selected three generated files in one chooser invocation,
  confirmed the batch, sent it, and retained the record after reload. All
  received bytes matched, including a zero-byte file.
- Browser UI downloaded a generated file through the encrypted chunk flow
  and explicit Save link. The saved 86 bytes matched the source exactly.
- TypeScript checking and the production Vite build passed. Generated assets
  are embedded with the backend source in the same commit.
- The transfer tab uses the same Fluent Arrow Swap regular/filled glyphs as
  Android. History keeps title, device, size and status compact, with controls on the right;
  a multi-file download opens a flat list in a sheet.
- Flutter: 229 tests passed, including seven mobile transfer layout cases at
  320 logical pixels and 2x text size across light/dark themes and statuses.
