# Browser transfer history validation — 2.8.2

The 2.8.1 browser file endpoint saved files and session-scoped web records, but never wrote the `transfers` table read by the desktop. Native Android transfers already use that table and were not affected.

The browser now commits its web record and desktop record in one SQLite transaction. Desktop IDs contain the session and browser batch ID. A persisted link prevents acknowledgement retries or startup migration from restoring desktop history that the user deleted. Desktop seen state and the original finish time survive updates. Queued downloads retain original source paths separately from private snapshots.

The desktop receives transfer-change events after commit and uses its existing list, seen, reveal and history-deletion APIs. Browser download completion means handoff to the browser, not proof of a disk write. Cancellation deletes only private download snapshots. Browser record deletion and device revocation preserve received files. Native startup recovery and maintenance leave browser queues to webshare.

Validation on 2026-10-30:

- Browser encrypted HTTP upload → desktop RPC Received: bytes, name, paths, completion, present flags and change event match.
- Desktop RPC send → browser batch: Sent record exists immediately; all files must be acknowledged before completion.
- Duplicate browser batch IDs in different sessions remain isolated.
- Retained 2.8.1 records migrate once; retries and repeated startup do not duplicate history or restore deleted rows.
- Desktop cancellation, browser deletion, session revocation and expiry cancel waiting rows and remove snapshots without deleting source or received files.
- A failed browser metadata insert rolls back desktop history.
- Native recovery and stale-record maintenance do not interrupt or expire browser queues.
- Client and server Go suites passed; webshare/store/rpc/send race tests passed.
- Flutter: 229 tests passed; analyzer reported no issues.
- Browser production bundle passed TypeScript checking and Vite build.

The transfer regression tests use real local HTTP and encryption with the production web endpoints, and the production desktop RPC methods. No new physical Android test was needed for this desktop/browser history change.
