# Built-in visual themes

The canonical definitions live in `client-core/internal/theme/builtin/`.
After editing one of the seven design themes, run:

```sh
python3 tools/themes/generate.py
python3 tools/themes/generate.py --check
```

The generator writes the Flutter constants and localized display names to
`ui/lib/style_themes.dart`. Flutter's built-in-theme tests compare the complete
definitions with the daemon JSON. The daemon tests cover contrast, editing,
and inheritance of display fonts, artwork and control shapes.

`artwork` selects a deterministic illustration in `ui/lib/theme_artwork.dart`.
It follows the scenery toggle and yields to user-supplied scenery or backgrounds.
The original Default and Pixel themes are unchanged.

## Bundled fonts

These fonts are distributed under the SIL Open Font License 1.1. Their complete
licenses are alongside the font files in `ui/assets/fonts/`. They were retrieved
from the [Google Fonts repository](https://github.com/google/fonts/tree/main/ofl)
on November 14, 2026. No runtime font downloads are required.

| File | Source path | SHA-256 |
| --- | --- | --- |
| BarlowCondensed-Bold.ttf | `ofl/barlowcondensed/BarlowCondensed-Bold.ttf` | `e476562ec9c1e16cf16475895b511f08c804f438cc9a9f80a44ea50a0eeb5b65` |
| SpaceGrotesk.ttf | `ofl/spacegrotesk/SpaceGrotesk[wght].ttf` | `acad6de1fc93436f5c0f1f4137751ef04f1aea3063e7036535970ffcfbd79f72` |
| ArchivoBlack-Regular.ttf | `ofl/archivoblack/ArchivoBlack-Regular.ttf` | `dd9a89a019b4849f66ab75455fe7bdf931311042cbb0f0f97acc061539703180` |
