"""Write native macOS Services names before the application is signed."""
import json
from pathlib import Path
import sys

NAMES = {
    'en': 'Send with PasteFerry',
    'zh-Hans': '通过 PasteFerry 发送',
    'zh-Hant': '透過 PasteFerry 傳送',
    'zh-HK': '透過 PasteFerry 傳送',
    'ja': 'PasteFerry で送信',
    'ko': 'PasteFerry로 보내기',
    'ar': 'إرسال عبر PasteFerry',
    'de': 'Mit PasteFerry senden',
    'fr': 'Envoyer avec PasteFerry',
    'es': 'Enviar con PasteFerry',
    'pt-BR': 'Enviar com PasteFerry',
    'it': 'Invia con PasteFerry',
    'ru': 'Отправить через PasteFerry',
    'uk': 'Надіслати через PasteFerry',
    'pl': 'Wyślij przez PasteFerry',
    'tr': 'PasteFerry ile gönder',
    'vi': 'Gửi bằng PasteFerry',
    'id': 'Kirim dengan PasteFerry',
}

def main():
    resources = Path(sys.argv[1])
    for language, name in NAMES.items():
        directory = resources / f'{language}.lproj'
        directory.mkdir(parents=True, exist_ok=True)
        (directory / 'ServicesMenu.strings').write_text(
            json.dumps('Send with PasteFerry') + ' = ' + json.dumps(name, ensure_ascii=False) + ';\n',
            encoding='utf-8')

if __name__ == '__main__':
    main()
