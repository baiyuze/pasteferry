"""Keep the OS sharing entries and in-app confirmation in the same language set."""
import importlib.util
import json
from pathlib import Path
import plistlib
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('native_sharing', ROOT / 'tools/mac-services.py')
sharing = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sharing)


class SharingLanguagesTest(unittest.TestCase):
    def test_native_catalog_matches_the_interface_and_mac_bundle(self):
        declared = plistlib.loads((ROOT / 'ui/macos/Runner/Info.plist').read_bytes())['CFBundleLocalizations']
        self.assertEqual(set(declared), set(sharing.NAMES))
        self.assertEqual(len(declared), 18)
        self.assertEqual(sharing.NAMES['zh-Hans'], '通过隔空贴发送')
        self.assertEqual(sharing.NAMES['zh-Hant'], '透過隔空貼傳送')
        required = ['shareConfirmTitle', 'shareChooseDevice', 'shareImporting', 'shareFilesOnly',
                    'shareMenuTitle', 'shareMenuDescription', 'shareInstallMenu', 'shareRemoveMenu',
                    'shareMenuDone']
        for language in sharing.NAMES:
            strings = sharing.interface_strings(language)
            for key in required:
                self.assertTrue(strings.get(key), (language, key))
                if language != 'en':
                    self.assertNotEqual(strings[key], sharing.interface_strings('en')[key], (language, key))

    def test_mac_services_include_localized_menu_and_error(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            for language, title in sharing.NAMES.items():
                output = sharing.service_strings(language, title)
                path = root / f'{language}.lproj/ServicesMenu.strings'
                sharing.write_or_check(path, output, False)
                sharing.write_or_check(path, output, True)
                self.assertIn(json.dumps(title, ensure_ascii=False), path.read_text())
                self.assertIn(json.dumps(sharing.interface_strings(language)['shareFilesOnly'], ensure_ascii=False), output)

    def test_windows_sources_are_generated_from_the_same_catalog(self):
        header = ROOT / 'ui/windows/runner/share_menu_names.h'
        installer = ROOT / 'tools/installer/share_menu_i18n.iss'
        self.assertEqual(header.read_text(), sharing.windows_header())
        self.assertEqual(installer.read_text(encoding='utf-8'), sharing.installer_include())
        for language in sharing.NAMES:
            self.assertIn(language.replace('-', '_') + '[]', header.read_text())


if __name__ == '__main__':
    unittest.main()
