# Fonts and non-Latin locales

**Last updated:** 2026-07-25  
**Primaries:** [LibSharedMedia issue #6 — Russian base fonts](https://www.wowace.com/projects/libsharedmedia-3-0/issues/6) · [WoWInterface — fonts for foreign languages](https://www.wowinterface.com/forums/showthread.php?t=44593) · [SharedMedia: No Asian Fonts](https://www.wowinterface.com/downloads/info21961-SharedMediaNoAsianFonts.html) · Spec §10 media fallback ([design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md))

---

## The failure mode: missing glyphs

If an addon forces a **Latin-only** `.ttf` (decorative “gothic,” pixel, or meme fonts), clients that need Cyrillic, Hangul, or CJK ideographs render **question marks, boxes, or blank tofu**. Blizzard ships **locale-specific font files** as counterparts to the familiar English faces.

Documented Russian (ruRU) examples from [LSM issue #6](https://www.wowace.com/projects/libsharedmedia-3-0/issues/6) (Phanx, 2012; still the mental model):

| English (Latin) face | Cyrillic counterpart |
|----------------------|----------------------|
| `FRIZQT__.ttf` | `FRIZQT___CYR.TTF` |
| `MORPHEUS.TTF` | `MORPHEUS_CYR.TTF` |
| `SKURRI.TTF` | `SKURRI_CYR.TTF` |

Korean / Chinese clients use other Blizzard files (e.g. discussion of `Fonts\\2002.TTF`, `ARHei.ttf`, `ARKai_T.ttf` on [WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=44593)). Exact FrameXML mapping varies by expansion; the durable rule is: **do not assume English Friz/Morpheus paths work for every locale**.

---

## Why default UI fonts are the safe V1 choice

Blizzard’s `GameFontNormal`, `GameFontHighlight`, etc. already resolve to the correct locale font face for the running client. Spec §10 / §11 for Church of Beef already require: missing custom media → **fallback to default UI fonts** and keep loading.

Implications:

- V1 ladder/toasts/slash output should use **inherited GameFont\*** (or unset font → default), not a shipped Latin-only Church face.
- A later Scarlet/gothic font pass is a **brand risk for non-Latin** unless:
  - the font includes needed scripts, or
  - the addon switches face by `GetLocale()`, or
  - English-only guild policy is explicit and documented.

---

## LibSharedMedia interaction (V2+ only for Beef)

LibSharedMedia registers named fonts for ElvUI/options menus. Historical issues:

- LSM must register **locale-correct Blizzard paths** or Russian users see `???` for Friz/Morpheus/Skurri ([issue #6](https://www.wowace.com/projects/libsharedmedia-3-0/issues/6)).
- East Asian fonts in shared menus clutter Western users; community even ships “[SharedMedia: No Asian Fonts](https://www.wowinterface.com/downloads/info21961-SharedMediaNoAsianFonts.html)” to strip them — evidence that font locale is a **UX** issue, not just a glyph issue.
- Decorative SharedMedia packs ([Classical Fonts](https://www.curseforge.com/wow/addons/sharedmedia-classicalfonts), etc.) are almost all Latin display faces — fine for English RP chrome, hostile to ru/ko/zh body text.

Beef V1: **do not require LSM**. If V2 registers a Church font, gate it behind English (or test glyph coverage) and keep GameFont fallbacks.

---

## Player names and mixed scripts

Even on an English client, guildmates can have characters with non-ASCII names depending on realm rules and history. Body UI that shows **player names** should use fonts that can render those glyphs — another reason default UI fonts beat ornamental faces for ladder rows.

---

## Beef checklist

| Rule | V1 | Later |
|------|----|-------|
| Use GameFont\* / defaults | Required | Keep as fallback |
| Ship custom Latin Church font | Avoid | Optional; never as sole face |
| Locale-switch font paths | N/A | If custom fonts ship |
| Depend on LSM for readability | No | Soft-optional only |
