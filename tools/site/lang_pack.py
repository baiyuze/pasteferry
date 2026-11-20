"""Tools for website languages that live in one file each (see content/packs.py).

    python3 tools/site/lang_pack.py template [out.py]   English template with every key, to translate
    python3 tools/site/lang_pack.py check <code>         compare content/<code>.py with English

The check makes sure the pack has the same keys and shape as English, keeps every placeholder
({start}, {version}, {key}…), HTML tag and URL, and leaves no English sentence untranslated by accident
(strings identical to English are listed so you can confirm they are names, commands or addresses).
"""

import pprint
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))

from content.features import localized as features_copy  # noqa: E402
from content.tour import COPY as TOUR_COPY, UI as TOUR_UI, CHAPTERS as TOUR_CHAPTERS, LANGUAGES as TOUR_LANGS  # noqa: E402
from content.themes import COPY as THEMES_COPY  # noqa: E402
from content.official import COPY as OFFICIAL_COPY  # noqa: E402
from content.privacy import COPY as PRIVACY_COPY  # noqa: E402
from content.feedback import COPY as FEEDBACK_COPY  # noqa: E402


def english() -> dict:
    import importlib.util
    spec = importlib.util.spec_from_file_location("content_en", HERE / "content" / "en.py")
    en = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(en)
    col = TOUR_LANGS.index("en")
    feedback = dict(FEEDBACK_COPY["en"])
    return {
        "C": en.C,
        "FEATURES": features_copy("en"),
        "TOUR": {k: v[col] for k, v in TOUR_COPY.items()},
        "TOUR_UI": {k: v[col] for k, v in TOUR_UI.items()},
        "TOUR_CHAPTERS": [row[col] for row in TOUR_CHAPTERS],
        "THEMES": THEMES_COPY["en"],
        "OFFICIAL": OFFICIAL_COPY["en"],
        "PRIVACY": PRIVACY_COPY["en"],
        "FEEDBACK": feedback,
    }


def template(out: Path | None) -> None:
    parts = ['"""Website copy: LANGUAGE. Translated from the English template; see content/packs.py."""\n']
    for name, value in english().items():
        parts.append(f"{name} = " + pprint.pformat(value, width=110, sort_dicts=False) + "\n")
    text = "\n".join(parts)
    if out:
        out.write_text(text, encoding="utf-8")
        print("wrote", out)
    else:
        print(text)


PLACEHOLDER = re.compile(r"\{[a-z_]+\}")
TAG = re.compile(r"</?([a-z0-9]+)")
URL = re.compile(r"https?://[^\s\"'<>)]+")


def walk(a, b, path, problems, same):
    if isinstance(a, dict):
        if not isinstance(b, dict):
            problems.append(f"{path}: expected a dict")
            return
        for k in a:
            if k not in b:
                problems.append(f"{path}.{k}: missing")
            else:
                walk(a[k], b[k], f"{path}.{k}", problems, same)
        for k in b:
            if k not in a:
                problems.append(f"{path}.{k}: not in English")
    elif isinstance(a, (list, tuple)):
        if not isinstance(b, (list, tuple)) or len(a) != len(b):
            problems.append(f"{path}: expected {len(a)} items, got {len(b) if isinstance(b, (list, tuple)) else type(b).__name__}")
            return
        for i, (x, y) in enumerate(zip(a, b)):
            walk(x, y, f"{path}[{i}]", problems, same)
    elif isinstance(a, str):
        if not isinstance(b, str):
            problems.append(f"{path}: expected a string")
            return
        if not b.strip() and a.strip():
            problems.append(f"{path}: empty")
        if sorted(PLACEHOLDER.findall(a)) != sorted(PLACEHOLDER.findall(b)):
            problems.append(f"{path}: placeholders {PLACEHOLDER.findall(a)} → {PLACEHOLDER.findall(b)}")
        if re.findall(r"<[^>]+>", a) != re.findall(r"<[^>]+>", b):
            problems.append(f"{path}: HTML tags or attributes changed")
        if sorted(URL.findall(a)) != sorted(URL.findall(b)):
            problems.append(f"{path}: URLs changed")
        if a == b and re.search(r"[a-z]{3,} [a-z]{3,} [a-z]{3,}", a):
            same.append(path)
    elif a != b:
        problems.append(f"{path}: {a!r} → {b!r}")


def check(code: str) -> int:
    from content.packs import pack
    p = pack(code)
    problems: list = []
    same: list = []
    for name, value in english().items():
        if not hasattr(p, name):
            problems.append(f"{name}: missing")
            continue
        walk(value, getattr(p, name), name, problems, same)
    for line in problems:
        print("✗", line)
    if same:
        print(f"{len(same)} strings are the same as English (fine for names, commands and addresses):")
        for line in same[:40]:
            print("  =", line)
    print("✓ OK" if not problems else f"{len(problems)} problems")
    return 1 if problems else 0


if __name__ == "__main__":
    if len(sys.argv) >= 2 and sys.argv[1] == "template":
        template(Path(sys.argv[2]) if len(sys.argv) > 2 else None)
    elif len(sys.argv) == 3 and sys.argv[1] == "check":
        sys.exit(check(sys.argv[2]))
    else:
        print(__doc__)
        sys.exit(2)
