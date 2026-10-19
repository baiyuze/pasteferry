# Automatic updates

Since 2.3.0 PasteFerry checks for new versions, shows the release notes in the
interface language and, after the user confirms, downloads, verifies and
installs the new version and reopens itself. Versions before 2.3.0 have no
updater; their users install 2.3.0 once by hand.

## Update list

The source of truth is `updates/latest.json` in the GitHub repository. Gitee
mirrors it (`scripts/gitee-mirror.sh`). The app reads both at the same time:

- `https://raw.githubusercontent.com/baiyuze/pasteferry/main/updates/latest.json`
- `https://gitee.com/baiyuze/pasteferry/raw/main/updates/latest.json`

Each list has a detached signature next to it (`latest.json.sig`, base64
Ed25519 over the exact bytes). The app keeps the first valid list, waits two
more seconds for the other source, and uses the newer of the two. A list with
a wrong signature is ignored.

```json
{
  "schema": 1,
  "latest": "2.3.0",
  "date": "2026-10-20",
  "mirrors": [
    { "source": "gitee",  "base": "https://gitee.com/baiyuze/pasteferry/releases/download/v2.3.0/" },
    { "source": "github", "base": "https://github.com/baiyuze/pasteferry/releases/download/v2.3.0/" }
  ],
  "assets": {
    "mac-arm64": { "name": "PasteFerry-mac-apple-silicon.dmg", "size": 24536429, "sha256": "…" }
  },
  "releases": [
    { "version": "2.3.0", "date": "2026-10-20",
      "notes": { "en": { "changes": ["…"], "fixes": ["…"] }, "zh-Hans": {}, "zh-Hant-TW": {}, "zh-Hant-HK": {}, "ja": {} } }
  ]
}
```

- Asset keys: `mac-arm64`, `mac-x64`, `mac-universal`, `windows-setup`,
  `windows-portable`, `linux-{amd64,arm64}-{deb,tar}`.
- `releases` keeps the newest 10 versions so a user several versions behind
  sees every change since their version. Missing languages fall back
  zh-Hant-HK → zh-Hant-TW → zh-Hans → en.
- Release notes are written in `tools/release/notes.py`, five languages per
  item. `tools/release/manifest.py X.Y.Z` checks that every language is present
  and every file matches `release/SHA256SUMS`, writes the list and signs it.

## Signing key

`client-core/cmd/updatesign -genkey` created the key on 2026-10-19. The private
key exists only in the login keychain of the release Mac (generic password,
service `pasteferry-update-signing-key`); the public key is compiled into
`client-core/internal/update/keys.go`. Without the private key no version can
be shipped through the updater, so keep an offline backup: in Keychain Access,
open the item, show the password and store it with the other recovery
material. To rotate, add the new public key next to the old one, ship a
release signed with the old key, and drop the old key later.

## Check, download, install

The background service does the network work, so a download continues if the
window is closed, and Go's standard library provides HTTP, SHA-256 and
Ed25519.

1. Check one minute after start, then every 24 hours, unless "Check for
   updates automatically" is off. The request carries no identifier
   (`User-Agent: PasteFerry`). A found version that is not skipped is put in
   `Status.update_available`; the sidebar shows a hint.
2. Download the asset for this install into `<data>/updates/<version>/`,
   first from the mirror that served the list, then from the other. The file is
   kept only if its size and SHA-256 match the signed list.
3. Prepare while the UI is still open, so errors can still be shown:
   - macOS: mount the DMG, copy the app next to the installed one (same volume)
     as `.PasteFerry-<version>.app`, check version, bundle ID and
     `codesign --verify --deep --strict`.
   - Windows portable / Linux tar.gz: extract next to the installed folder as
     `.PasteFerry-update-<version>/PasteFerry`, check the main files exist.
4. Start the updater: a copy of the daemon named `pasteferry-updater`, which
   starts a second, detached copy of itself and exits. The Windows installer
   stops `pasteferryd.exe` by name and by process tree; the renamed, detached
   updater survives both.
5. The UI quits. The updater waits for it, then:
   - macOS: renames the old app aside and the new one into place, restarts the
     LaunchAgent with `launchctl kickstart -k` if it points into this app, and
     reopens the app with `open --env HOME=…`.
   - Windows installer: runs `PasteFerry-Setup.exe /VERYSILENT /SUPPRESSMSGBOXES
     /NORESTART /NOCANCEL /LOG=…`; the installer stops the old processes and
     starts the background service. The updater reopens the UI.
   - Windows portable / Linux tar.gz: stops the old background service and its
     supervisor (only processes whose executable is in the app folder), swaps
     the folders, starts `pasteferryd -supervise` and the UI.
   - Linux .deb: `pkexec dpkg -i` (the system asks for the password because
     `/opt` needs root), then restarts the background service and the UI.
6. The result goes to `<data>/updates/result.json`; the new background service
   reads it once and the UI says "Updated to X". On failure the old version
   stays and is reopened.

An install that cannot replace itself (development build, macOS app running
from the DMG or a translocated path, unwritable folder, no package for this
platform) still shows the release notes and offers the download page instead.

## Testing

A file `update-sources.json` in the data directory replaces the two list URLs
(`[{"name": "test", "manifest": "http://…/latest.json"}]`). The list still has
to carry a valid signature, so this cannot change what gets installed.

Validation for 2.3.0 (2026-10-19): CI built a 2.3.0 base and a 2.3.1 test
version from branches that differed only in the version number. The Mac served
a list signed with the release key and the packages over the Parallels
network. Each install started at 2.3.0 and was updated through the background
service's API, the same calls the window makes.

| Install | Machine | Result |
| --- | --- | --- |
| macOS app | Mac (Apple silicon), separate `HOME` | App swapped in 0.6 s, reopened, the 2.3.1 service reported "Updated to 2.3.1" |
| Windows installer | Windows 11 VM | Silent install in 3.5 s, window reopened, pairings kept |
| Windows portable | Windows 11 VM | Folder swapped 50 ms after the old service stopped; service and window reopened |
| Linux .deb | Ubuntu 24.04 VM (x64), from the window | polkit asked for the password; window reopened with "Updated to 2.3.1" |
| Linux tar.gz | Ubuntu 24.04 VM (x64), window open | Folder swapped 0.2 s after the window quit; service and window reopened |

Problems found and fixed during the validation:

- The supervisor restarted the old service while its folder was being
  replaced. The updater now stops the supervisor first and retries the rename
  for 15 seconds.
- On Windows the updater's working directory was inside the folder it
  replaced, which blocks the rename. It now runs in its own folder.
- A failed install that did not restart the service (polkit denied) was never
  shown. The service rereads `result.json` when it changes.
- macOS `open` could activate another running copy with the same bundle ID
  instead of the replaced app; it now uses `open -n`.
- The service waited for the window's event stream before exiting, so
  restarting it with the window open left the old process holding the
  single-instance lock (seen on Linux). It now waits at most two seconds.

Notes for repeating the test: `pkexec` only shows a password prompt for a
process in the graphical session, so on Linux start the service with
`systemd-run --user --scope`, not from an SSH shell. On Windows, start test
processes with `Win32_Process.Create`; `prlctl exec` waits for every child.
