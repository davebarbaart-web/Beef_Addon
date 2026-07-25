# GetScreenWidth / GetScreenHeight Quirks

**Track:** [43-ui-scale-pixel-perfection](README.md)

---

## What `GetScreenWidth` actually returns

Canonical wiki wording ([Warcraft Wiki — GetScreenWidth](https://warcraft.wiki.gg/wiki/API_GetScreenWidth)):

> Returns the width of the window measured at **UIParent scale** (effectively the same as `UIParent:GetWidth()`).

It is **not** the Video Options resolution string. The return is a dimension that shares the **aspect ratio** of the real window, expressed in the scaled coordinate system. Multiplying by effective scale reconstructs a “normalized” size that still may not equal the graphics-menu resolution:

```lua
(GetScreenWidth() * UIParent:GetEffectiveScale())
  .. "x" ..
(GetScreenHeight() * UIParent:GetEffectiveScale())
```

Classic archive example: real **1280×1024** can print as **960×768** — same 5:4 aspect, different numbers ([WoWWiki archive](https://wowwiki-archive.fandom.com/wiki/API_GetScreenWidth); [AddOn Studio — GetScreenHeight](https://addonstudio.org/wiki/WoW:API_GetScreenHeight)).

---

## Field failure: 1440p → “2133×1200”

A 2023 Blizzard UI-macro thread reports that even at 100% UI/render scale, flooring `GetScreenWidth/Height` on a native **2560×1440** display printed **2133×1200** ([EU forums — Accurately determine selected screen resolution](https://eu.forums.blizzard.com/en/wow/t/accurately-determine-the-selected-screen-resolution/431926)).

**Fix used in that thread:** `GetPhysicalScreenSize()` — returns the true display size as set in the graphics menu ([Warcraft Wiki — GetPhysicalScreenSize](https://warcraft.wiki.gg/wiki/API_GetPhysicalScreenSize); added 7.1.0 / Classic 1.13.2).

| API | Use for |
|-----|---------|
| `GetPhysicalScreenSize()` | Pixel-perfect formula (`768/h`), resolution-named profiles, “am I on 4K?” |
| `GetScreenWidth/Height()` | Layout inside the **current** UIParent coordinate space (clamp, center, % of screen) |
| `UIParent:GetEffectiveScale()` | Convert cursor / cross-scale math; never assume scale is 1 |

---

## Do not do this

| Antipattern | Why it fails |
|-------------|--------------|
| `if GetScreenWidth() > 2000 then …` “detect 1440p” | Returns virtual/scaled width; 1440p can look like ~2133 or other values |
| Persist “resolution” from `GetScreenWidth×Height` in SavedVariables as a monitor id | Changes when the player moves the UI scale slider |
| Size textures assuming 1 unit = 1 framebuffer pixel | Only true after pixel-perfect scale is applied |
| Parse `gxWindowedResolution` alone without physical size | Windowed / OS DPI / Mac scaled desktops can disagree with the drawing surface ([EU forums — UI Scaling Broken](https://eu.forums.blizzard.com/en/wow/t/ui-scaling-broken/525386)) |

---

## Correct split for Beef

1. **Layout / clamp / toast anchor math** → `UIParent` + `GetScreenWidth/Height` (same space the frame lives in).
2. **Diagnostics / “physical pixels” / optional future per-monitor defaults** → `GetPhysicalScreenSize()`.
3. **Never** treat the two as interchangeable when writing QA notes (“test on 1440p” means physical, not GetScreen*).

---

## Sources

- [Warcraft Wiki — GetScreenWidth](https://warcraft.wiki.gg/wiki/API_GetScreenWidth)
- [Warcraft Wiki — GetPhysicalScreenSize](https://warcraft.wiki.gg/wiki/API_GetPhysicalScreenSize)
- [EU forums — Accurately determine selected screen resolution](https://eu.forums.blizzard.com/en/wow/t/accurately-determine-the-selected-screen-resolution/431926) (2023)
- [WoWWiki archive — GetScreenWidth](https://wowwiki-archive.fandom.com/wiki/API_GetScreenWidth)
