# Android batch selection and toast validation

Date: 2026-10-30

## Context

Recovered VS Code Copilot chat: `14974a9b-6ee7-43f9-9fad-11b0e247484b`.
Its SDK event history is `9f68d87f-b7bd-4ddd-bfc4-eba2b2affdba`.
The unfinished work concerned Android file selection and transfer speed.
The user confirmed approximately 10 MB/s on the same Wi-Fi; the earlier
approximately 10 KB/s observation occurred across different Wi-Fi networks.
These are user measurements, not emulator results or evidence of a
compression bottleneck.

## Behavior

Both Android Send and Send Files use the same batch selection flow:

1. Choose Photos or Files.
2. Select multiple items in one system picker invocation.
3. Review the entire batch and confirm before submitting it.
4. Optionally add another selection, including a different source type.

Android 13 and later use `ACTION_PICK_IMAGES` with
`EXTRA_PICK_IMAGES_MAX` set to the system limit. Earlier Android releases use
`ACTION_OPEN_DOCUMENT` with `EXTRA_ALLOW_MULTIPLE`. Documents use the latter
on every supported Android version. Devices without a photo picker also
fall back to the document picker.

The system photo picker imposes its own batch limit; Add More can append
another batch. In DocumentsUI, long-press one item to start selecting, then
tap additional items and Select. A third-party document provider may impose
its own restrictions; use the system storage roots (such as Downloads or
Images) or the dedicated Photos entry when that provider only allows one item.

Selected URIs are copied on the Android I/O executor into separate cache
subdirectories, preserving same-named files. The whole result is returned to
Flutter. When both a single URI and ClipData are present, ClipData takes
precedence. Source URI identity prevents re-adding a file just because a new
cache copy has a different path. Import failures abort the batch and remove
its partial cache directory.

Canceling the initial selection submits nothing. Canceling an additional
selection returns to the existing confirmation sheet. Canceling that sheet
submits nothing. Both entry buttons stay disabled during selection and import.

Android and phone-web top toasts shrink to content, cap their width at 320
logical pixels, and remain horizontally centered. They use the existing
neutral dark toast colors and 10-pixel theme radius, with a smaller shadow.
Long messages wrap within the available space. The Android toast remains in
the top safe area, including with the keyboard or a dialog open.

## Validation

| Check | Result |
| --- | --- |
| Flutter static analysis | No issues |
| Entire Flutter suite | 222 tests passed |
| New batch flow widget tests | Both entry points; photos and files; complete paths submitted as one batch; explicit confirmation; mixed append; duplicate URI; initial cancel; append cancel |
| Android JVM tests | 24 tests passed, including 12 picker cases across API 28, 33 and 36 |
| Native picker tests | Batch intents, all ClipData items, single-data plus ClipData precedence, URI deduplication, imported bytes and sizes, stable source identity, empty result |
| Toast widget tests | Short content width and horizontal center; 320-pixel viewport at 2x text size; light and dark themes; keyboard, dialog, replacement, dismissal and click-through |
| Go tests | `./mobile ./internal/pack ./internal/send ./internal/webshare` passed |
| Phone web | TypeScript check and production Vite build passed; embedded web assets regenerated |
| APK | Device AAR and arm64 APK built; APK signature verified against the existing 2.8.0 release signer |

Android 16 / API 36 emulator checks used an emulator-only ARM translation
build, separate from the signed device APK:

- Photos: selected three images in a single system photo picker invocation;
  the picker displayed Add (3); the App confirmation listed all three items.
  Submitting produced a three-item outgoing record and the centered toast.
- Files: long-pressed one file and selected two more in a single DocumentsUI
  invocation; the picker displayed 3 selected; the App confirmation listed
  all three original file names.

The emulator had no paired computer. Its outgoing record demonstrates
selection, import and RPC submission, not network delivery to a computer.
The Send Files destination and full batch are also covered by widget tests
with a recording AppState, while transfer correctness is covered by Go tests.

### Physical device

The signed APK was installed as an in-place update on an OPPO K9 5G
(PEXM00, Android 13 / API 33) through paired wireless ADB. Existing app data
and the pairing with the Mac were retained. The following checks used only
three generated test images and three generated TXT documents:

| Entry and source | System selection | Mac result |
| --- | --- | --- |
| Send — Photos | Add (3) in one photo picker invocation; confirmation contains all three | Ready clipboard record; all three file SHA-256 hashes match the source images |
| Send — Files | Long-press and select three TXT files in one DocumentsUI invocation | Ready clipboard record; all three file SHA-256 hashes match |
| Send Files — Files | Select three TXT files in one DocumentsUI invocation | Transfer `c519b6cb5f7d2d0973e811269fe48fbc` completed, 3 files / 80 bytes; all SHA-256 hashes match the files saved to the Mac |
| Send Files — Photos | Add (3) in one photo picker invocation; confirmation contains all three | Transfer `76abd2e0d6bcfb69359c4ec8c8108610` completed, 3 files / 2,739 bytes; all SHA-256 hashes match the source images |

The native Photos provider assigns numeric `.jpg` display names to the test
images; their received bytes still match the original PNG fixtures exactly.
The compact centered top success toast was observed on the physical device.
Wireless ADB briefly disconnected during the final check and reconnected via
the existing paired mDNS service. All four physical-device paths completed.
The final photo transfer encountered existing destination names and safely
received numbered copies; their bytes still matched all three fixtures.

These small fixtures validate batch completeness and content integrity, not
throughput. The approximately 10 MB/s same-Wi-Fi rate remains the user's
measurement.

Screenshots and the signed device APK are saved under
`ui/build/validation/2026-10-30/` (ignored build artifacts).

Physical-device confirmation screenshots and `physical-*.json` integrity
results are saved beside the APK. Picker gallery screenshots are excluded
from the final physical-device artifacts to avoid including personal media.
