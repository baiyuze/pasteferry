"""Release-note coverage and compatibility checks; no signing keys required."""
import copy
import re
import unittest
from unittest.mock import patch

import manifest


class ReleaseNotesTests(unittest.TestCase):
    def test_latest_has_all_18_translations(self):
        release = manifest.RELEASES[0]
        result = manifest.release_entry(release)
        self.assertEqual(set(result["notes"]), set(manifest.ALL_LANGS))
        self.assertEqual(len(result["notes"]), 18)
        for notes in result["notes"].values():
            for category in ("changes", "fixes"):
                self.assertEqual(len(notes.get(category, [])), len(release[category]))

    def test_languages_match_client_interface(self):
        source = (manifest.ROOT / "client-core/internal/lang/lang.go").read_text()
        codes = re.search(r"var Supported = \[\]string\{(.*?)\}", source, re.S)
        self.assertIsNotNone(codes)
        self.assertEqual(set(re.findall(r'"([^"]+)"', codes[1])), set(manifest.ALL_LANGS))

    def test_historical_release_keeps_original_five(self):
        result = manifest.release_entry(manifest.RELEASES[1])
        self.assertEqual(set(result["notes"]), set(manifest.LANGS))

    def test_missing_language_is_rejected(self):
        extra = copy.deepcopy(manifest.EXTRA_NOTES)
        del extra[manifest.RELEASES[0]["version"]]["fr"]
        with patch.object(manifest, "EXTRA_NOTES", extra), self.assertRaises(SystemExit):
            manifest.release_entry(manifest.RELEASES[0])

    def test_empty_or_misaligned_translation_is_rejected(self):
        for broken in ([""], ["one item"], None):
            with self.subTest(broken=broken):
                extra = copy.deepcopy(manifest.EXTRA_NOTES)
                extra[manifest.RELEASES[0]["version"]]["fr"]["changes"] = broken
                with patch.object(manifest, "EXTRA_NOTES", extra), self.assertRaises(SystemExit):
                    manifest.release_entry(manifest.RELEASES[0])


if __name__ == "__main__":
    unittest.main()
