# Let AI design your theme

[简体中文](ai-themes.zh-CN.md) · [Back to README](../README.md)

PasteFerry themes can be made by AI. Ask for "a cyberpunk theme" or "use this photo as the background and match the colors", and the AI reads the theme format, picks the colors, checks that text stays readable, saves the theme and switches to it. It connects through `pasteferry-cli mcp`, which ships with the desktop app, and works with Claude Desktop, Claude Code, Cursor and other MCP clients.

**Themes only**: the AI can read, change and delete themes and background images, nothing else. It cannot see your clipboard history, devices or friends. Your AI client asks you before it saves, applies or deletes a theme.

## Before you start

1. Install the PasteFerry desktop app and open it (the background service must be running).
2. Find `pasteferry-cli`:

| System | Path |
|---|---|
| Mac | `/Applications/PasteFerry.app/Contents/Helpers/pasteferry-cli` (with Homebrew you can write just `pasteferry-cli`) |
| Windows | `%LOCALAPPDATA%\Programs\PasteFerry\pasteferry-cli.exe`; write the full path in configuration files, for example `C:\Users\you\AppData\Local\Programs\PasteFerry\pasteferry-cli.exe` |
| Linux | `/usr/bin/pasteferry-cli` from the deb package; `PasteFerry/pasteferry-cli` inside the extracted tar.gz |

The examples below use the Mac path; replace it with yours.

## Claude Desktop

Open Settings → Developer → Edit Config and add this to `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "pasteferry": {
      "command": "/Applications/PasteFerry.app/Contents/Helpers/pasteferry-cli",
      "args": ["mcp"]
    }
  }
}
```

On Windows, double the backslashes: `"C:\\Users\\you\\AppData\\Local\\Programs\\PasteFerry\\pasteferry-cli.exe"`. Restart Claude Desktop afterwards.

## Claude Code

```bash
claude mcp add pasteferry -- /Applications/PasteFerry.app/Contents/Helpers/pasteferry-cli mcp
```

## Cursor

Add this to `~/.cursor/mcp.json` (all projects) or `.cursor/mcp.json` in a project:

```json
{
  "mcpServers": {
    "pasteferry": {
      "command": "/Applications/PasteFerry.app/Contents/Helpers/pasteferry-cli",
      "args": ["mcp"]
    }
  }
}
```

## Things to ask

- "Which PasteFerry themes do I have? Switch to the pixel theme in dark mode."
- "Make a matcha green theme based on the default one, light and dark, with readable text."
- "Change the pixel theme's accent to coral, save it as a new theme and use it."
- "Use ~/Pictures/beach.jpg as the background and match the colors to the photo."
- "Replace the pixel theme's header landscape with ~/Pictures/mountains.png and put ~/Pictures/cat.png at the bottom of the sidebar."
- "The background is too busy: blur it a little and make the panels less see-through."
- "Delete the theme you just made."

Themes made by AI appear in Settings → Appearance next to the built-in ones, so you can switch back at any time.

## Questions

**The AI says it cannot reach PasteFerry**
Open PasteFerry (or check in Settings that the background service is running), then ask the AI to try again. You don't need to restart the AI client.

**The AI reports low contrast**
PasteFerry checks that body and secondary text reach 4.5:1 against the background, hint text 3:1, and button text 4.5:1 against the button. Ask the AI to adjust those colors. The theme saves anyway, but that text may be hard to read.

**Background image or scenery?**
A background image (`background`) fills the whole window, and the sidebar and lists become translucent so it shows through. Scenery (`scene`) only replaces the wide picture at the top of pages and the small one at the bottom of the sidebar, where the pixel theme draws its landscape and camp; nothing else changes. Scenery is hidden while a background image shows. You can change both yourself in Settings → Appearance, without AI.

**Will text stay readable on my picture?**
Yes. PasteFerry works out how strong the scrim over the picture must be for the theme's text colors and never shows it lighter; the AI or you can only make it stronger. Dark pictures with dark mode, and light pictures with light mode, let more of the picture show.

**Can I use an image from the web?**
Not by URL. Download the image first, then give the AI the file. The image is re-encoded on import, so location data from photos is not kept.

**Several computers**
Themes are stored on this computer only and are not synced. Set up the AI client on the other computer too, or have the AI save the theme there again.

Technical details: [MCP design](../design/mcp.md) and [theme format](../design/themes.md).
