"""Languages added after the first five (zh, zh-tw, zh-hk, en, ja).

The first five keep their copy spread over the shared modules (features.py, tour.py, themes.py, …),
one column per language. Each language added later has everything in one file, content/<code>.py:

    C          the site copy, same keys as en.py
    FEATURES   features.py, one string per key
    TOUR, TOUR_UI, TOUR_CHAPTERS   tour.py
    THEMES     themes.py COPY[...]
    OFFICIAL   official.py COPY[...]
    PRIVACY    (title, [(heading, text), ...]) including the discussion-and-feedback section
    FEEDBACK   feedback.py COPY[...]

Start a new one from the English template (python3 tools/site/lang_pack.py template) and check it with
python3 tools/site/lang_pack.py check <code>.
"""

import importlib.util
from pathlib import Path

# Order of the language menu after the first five
PACKS = ("ko", "de", "fr", "es")

_cache: dict = {}


def pack(code: str):
    if code not in _cache:
        path = Path(__file__).parent / f"{code}.py"
        spec = importlib.util.spec_from_file_location(f"content_{code}", path)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        _cache[code] = module
    return _cache[code]
