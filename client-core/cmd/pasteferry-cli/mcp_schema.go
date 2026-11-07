package main

import "github.com/baiyuze/pasteferry/client-core/internal/theme"

// themeSchema 是主题格式的 JSON Schema（design/themes.md 第 3 节），给 AI 看：
// 每个颜色角色写清楚用在界面哪里、要和谁达到多少对比度。取值范围与后台服务的校验一致
// （client-core/internal/theme/theme.go 的 validate）。

// roleDocs 与 theme.Roles 一一对应；测试会检查没有漏
var roleDocs = map[string]string{
	"accent":       "Brand/accent color. Filled primary buttons, the selected-item bar, links, progress, focus outlines, small highlights. Use sparingly. onAccent must reach 4.5:1 on it.",
	"background":   "Main content area behind every page (the largest area). text and textDim need 4.5:1 on it, textFaint 3:1.",
	"sidebar":      "Left navigation column. Usually one step darker than background in dark mode, or a slightly tinted/darker tone in light mode.",
	"surface":      "Panels, grouped lists, cards, dialogs, menus — sits on background. text and textDim need 4.5:1 on it, textFaint 3:1.",
	"border":       "Low-contrast outline of panels and cards. Should be subtle: a little different from surface/background.",
	"borderStrong": "Outline of interactive controls (buttons, inputs, segmented controls, switches) and floating layers (dialogs, menus, previews). More visible than border. If omitted it equals border.",
	"separator":    "Lines between rows inside a panel; subtler than border.",
	"text":         "Primary text and titles.",
	"textDim":      "Secondary text: descriptions, metadata (time, size, source device), inactive icons.",
	"textFaint":    "Least important text: placeholders, hints, counters, disabled labels.",
	"selection":    "Background of the selected sidebar item; in the pixel corner style also the face of raised buttons and the selected segment.",
	"hover":        "Overlay drawn on hovered rows and buttons. Use a translucent color in #AARRGGBB, e.g. #0A000000 on light themes or #0FFFFFFF on dark ones.",
	"fill":         "Recessed areas: segmented-control track, input fields (pixel style), progress-bar track, code blocks.",
	"online":       "Status color for connected/success; shown as a small dot and as text on background.",
	"warning":      "Status color for warnings; shown as a dot and as text on background.",
	"danger":       "Errors and destructive actions; shown as text, dots and icons on background.",
	"onAccent":     "Text and icons drawn on accent (primary buttons, badges). Must reach 4.5:1 against accent — dark text for light accents, white for dark accents.",
	"inverse":      "Background of toasts and tooltips (inverted from the theme, e.g. near-black on a light theme).",
	"onInverse":    "Text on inverse.",
	"bevelLight":   "Pixel corner style only: 2px highlight on the top/left inner edge of raised controls (bottom/right of sunken ones). Translucent white, e.g. #14FFFFFF. Fully transparent disables it.",
	"bevelDark":    "Pixel corner style only: 2px shade on the bottom/right inner edge of raised controls (top/left of sunken ones). Translucent black, e.g. #59000000.",
	"shadow":       "Color of the hard offset shadow under floating layers when shape.shadow is \"hard\". Usually translucent black.",
}

func themeSchema() map[string]any {
	color := func(desc string) map[string]any {
		return map[string]any{
			"type":        "string",
			"pattern":     "^#([0-9A-Fa-f]{6}|[0-9A-Fa-f]{8})$",
			"description": desc + " Format #RRGGBB, or #AARRGGBB with alpha first.",
		}
	}
	roles := map[string]any{}
	for _, r := range theme.Roles {
		roles[r] = color(roleDocs[r])
	}
	palette := map[string]any{
		"type":                 "object",
		"description":          "Colors for one mode. Every role is optional: omitted roles are taken from the base theme.",
		"properties":           roles,
		"additionalProperties": false,
	}
	num := func(lo, hi float64, desc string) map[string]any {
		return map[string]any{"type": "number", "minimum": lo, "maximum": hi, "description": desc}
	}
	enum := func(desc string, values ...string) map[string]any {
		return map[string]any{"type": "string", "enum": values, "description": desc}
	}
	strictObj := func(desc string, props map[string]any) map[string]any {
		return map[string]any{"type": "object", "description": desc, "properties": props, "additionalProperties": false}
	}
	return map[string]any{
		"$schema":              "https://json-schema.org/draft/2020-12/schema",
		"$id":                  schemaURI,
		"title":                "PasteFerry theme",
		"description":          "A PasteFerry theme. Only schema and id are required; everything else falls back to the base theme, so a theme can be as small as one accent color. Contrast rules checked on save: text and textDim ≥ 4.5:1 on background and surface, textFaint ≥ 3:1, onAccent ≥ 4.5:1 on accent. Built-in themes: \"default\" (quiet macOS-like, rounded, soft shadows) and \"pixel\" (pixel font, cut corners with 2px borders, bevels, hard shadows, stepped motion).",
		"type":                 "object",
		"required":             []string{"schema", "id"},
		"additionalProperties": false,
		"properties": map[string]any{
			"schema": map[string]any{"const": theme.Schema, "description": "Format version. Always 1."},
			"id": map[string]any{
				"type": "string", "pattern": "^[a-z0-9-]{1,40}$",
				"description": "Unique id: lowercase letters, digits and hyphens, at most 40. Cannot be \"default\" or \"pixel\". Saving with an existing custom id replaces that theme.",
			},
			"name": map[string]any{
				"type":                 "object",
				"description":          "Display name per UI language, 1–40 characters each. Keys: zh-Hans, zh-Hant-TW, zh-Hant-HK, en, ja.",
				"additionalProperties": map[string]any{"type": "string", "minLength": 1, "maxLength": 40},
			},
			"base": map[string]any{
				"type":        "string",
				"description": "Theme to inherit from: \"default\", \"pixel\" or a custom theme id (at most 2 levels of custom themes). Default \"default\". Pick the base whose shapes and fonts you want, then override colors.",
			},
			"modes": strictObj("Colors for light and dark mode. The user picks light, dark or follow-system, so provide both when you change colors.", map[string]any{
				"light": palette,
				"dark":  palette,
			}),
			"typography": strictObj("Fonts. Only fonts bundled with PasteFerry are allowed.", map[string]any{
				"family": enum("Body font: system (the platform UI font) or FusionPixel (12px bitmap pixel font with Chinese and Japanese).", "system", "FusionPixel"),
				"mono":   enum("Monospace font for codes and fingerprints: system or FusionPixelMono.", "system", "FusionPixelMono"),
				"sizes": map[string]any{
					"type": "array", "maxItems": 6, "items": num(8, 48, "Font size in logical pixels."),
					"description": "Allowed font sizes; every text snaps to the nearest one. Use [12, 24] with FusionPixel so the pixels stay crisp; [] means any size.",
				},
			}),
			"shape": strictObj("Corners, borders and shadows.", map[string]any{
				"radius": strictObj("Corner radii for round corners.", map[string]any{
					"sm": num(0, 32, "Controls (buttons, inputs). Default theme: 6."),
					"md": num(0, 32, "Panels and cards. Default theme: 10."),
					"lg": num(0, 32, "Dialogs and large panels. Default theme: 14."),
				}),
				"corner":      enum("round: rounded corners. pixel: square corners with one notched pixel, 2px borders, bevels on controls.", "round", "pixel"),
				"borderWidth": num(0, 4, "Border width of panels, buttons and inputs. Default 1, pixel 2."),
				"unit":        num(1, 8, "Size of one pixel step for the pixel corner style (notch, bevel, hard shadow offset). Default 2."),
				"shadow":      enum("soft: blurred shadows. hard: solid offset shadows under floating layers only (pixel look). none: flat.", "soft", "hard", "none"),
			}),
			"motion":  enum("Animation style: smooth transitions, stepped (frame-by-frame, pixel look) or reduced (no animation).", "smooth", "stepped", "reduced"),
			"icons":   enum("Icon set: system (macOS/Fluent style) or pixel (Pixelarticons).", "system", "pixel"),
			"scenery": map[string]any{"type": "boolean", "description": "Scenery on/off: the strip behind the page header and the picture at the bottom of the sidebar. With the pixel corner style it is pixel art (a landscape and a small camp) unless scene replaces it; set false for a plainer look. Always hidden while a background image shows."},
			"scene": strictObj("Replace the scenery with your own pictures (any corner style). Import images with background_import first. Wide images suit the header (about 900×180 visible, cropped to fill; the bottom fades into the page and the page title sits on it, so a scrim is added automatically); the sidebar picture is 200×96 at the bottom of the sidebar, its top fades into the sidebar.", map[string]any{
				"header":      map[string]any{"type": "string", "pattern": "^user:[0-9a-f]{64}$", "description": "\"user:<sha256>\" shown behind the page header."},
				"headerDark":  map[string]any{"type": "string", "pattern": "^user:[0-9a-f]{64}$", "description": "Different header picture for dark mode; omit to use header in both modes."},
				"sidebar":     map[string]any{"type": "string", "pattern": "^user:[0-9a-f]{64}$", "description": "\"user:<sha256>\" shown at the bottom of the sidebar."},
				"sidebarDark": map[string]any{"type": "string", "pattern": "^user:[0-9a-f]{64}$", "description": "Different sidebar picture for dark mode; omit to use sidebar in both modes."},
			}),
			"background": strictObj("Optional background image filling the window behind the sidebar and pages (desktop main window and the phone app by default). Import images with background_import first. While it shows, the page background is transparent, a scrim keeps text readable and panels become translucent.", map[string]any{
				"image":     map[string]any{"type": "string", "pattern": "^user:[0-9a-f]{64}$", "description": "\"user:<sha256>\" from background_import."},
				"imageDark": map[string]any{"type": "string", "pattern": "^user:[0-9a-f]{64}$", "description": "Different image for dark mode; omit to use image in both modes."},
				"fit":       enum("How the image fills the window. tile repeats it (for small pixel-art patterns).", "cover", "contain", "tile"),
				"align":     enum("Which part stays visible when cropped.", "center", "top", "bottom", "left", "right", "topLeft", "topRight", "bottomLeft", "bottomRight"),
				"blur":      num(0, 40, "Blur, 0 to 40 (0 = sharp, 20 or more = fully blurred); higher keeps text more readable over busy photos."),
				"scrim": strictObj("Color laid over the image so text stays readable. Defaults to the theme's background color. The app never shows it lighter than the theme's text and textDim need for 4.5:1 over this image (it measures that itself; the analysis' min_scrim_dark / min_scrim_light are the minimums for pure white / black text).", map[string]any{
					"color":   color("Scrim color: usually black for dark themes and white for light ones."),
					"opacity": num(0, 1, "Scrim opacity. Default: the minimum the text needs; set higher for a calmer look."),
				}),
				"surfaceOpacity":  num(0.6, 1, "Opacity of the sidebar and panels over the image; lower shows more of the image. Default 0.85. Raise it when the image is busy (high luminance_spread)."),
				"scope":           map[string]any{"type": "array", "items": enum("Where to show the image.", "main", "picker", "mobile"), "description": "Windows that show the image; default main and mobile."},
				"accentFromImage": map[string]any{"type": "boolean", "description": "Use the image's main color as accent (onAccent becomes black or white, whichever reads better)."},
			}),
		},
	}
}
