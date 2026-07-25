# LibSharedMedia-3.0

**Last updated:** 2026-07-25  
**Primary sources:** [WowAce LibSharedMedia-3.0](https://www.wowace.com/projects/libsharedmedia-3-0), [API Documentation](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation), [CurseForge LibSharedMedia-3.0](https://www.curseforge.com/wow/addons/libsharedmedia-3-0).

---

## 1. Role

[LibSharedMedia-3.0](https://www.wowace.com/projects/libsharedmedia-3-0) (Elkano; maintained with Funkeh) is a **shared registry** so addons can publish and consume named media handles — fonts, statusbars, borders, backgrounds, sounds — without hard-coding each other’s file paths ([project overview](https://www.wowace.com/projects/libsharedmedia-3-0)).

Classic / Classic TBC flavors are published on CurseForge alongside Retail ([CurseForge flavors](https://www.curseforge.com/wow/addons/libsharedmedia-3-0)); releases continue into mid-2026 (e.g. v12.0.3, Jul 2026).

Companion packaging:

- **SharedMedia** packs *insert* extra media into the registry (Elkano’s SharedMedia and forks such as [SharedMedia Extended](https://www.curseforge.com/wow/addons/sharedmediax)).
- **AceGUI-3.0-SharedMediaWidgets** supplies dropdown widgets for the five basic types ([API docs](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation)).

---

## 2. Media types

Official constants ([API Documentation](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation)):

| Constant | Value | Used for |
|----------|-------|----------|
| `MediaType.BACKGROUND` | `background` | Panel / backdrop textures |
| `MediaType.BORDER` | `border` | Border textures |
| `MediaType.FONT` | `font` | Fonts (`.ttf`) |
| `MediaType.STATUSBAR` | `statusbar` | StatusBar textures |
| `MediaType.SOUND` | `sound` | Sound files |

Font registration may include locale bitmasks (`LOCALE_BIT_koKR`, `zhCN`, `zhTW`, `western`); Western is assumed if omitted ([API docs](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation)).

---

## 3. API surface (design-relevant)

From the [official API page](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation):

| Method | Purpose |
|--------|---------|
| `Register(mediatype, key, data [, langmask])` | Publish a handle → path |
| `Fetch(mediatype, key [, noDefault])` | Resolve path (or default / nil) |
| `IsValid(mediatype [, key])` | Validity check |
| `HashTable(mediatype)` / `List(mediatype)` | Enumerate for options UIs |
| `GetGlobal` / `SetGlobal` | Global override handle for a type |
| `GetDefault` / `SetDefault` | Default when a key is missing |

Callbacks:

- `LibSharedMedia_Registered` — new handle registered
- `LibSharedMedia_SetGlobal` — global override set/cleared

Naming conventions from the same docs: don’t invent prefixes as “namespaces”; for fonts, use the **true face name** from the TTF as the handle.

---

## 4. Built-in Blizzard handles (always available)

LSM ships predefined handles so authors need not re-register Blizzard art ([API Documentation — Predefined data](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation)):

**Fonts:** Arial Narrow, Friz Quadrata TT, Morpheus, Skurri (`Fonts\ARIALN.TTF`, `FRIZQT__.TTF`, `MORPHEUS.TTF`, `SKURRI.TTF`).

**Statusbars:** Blizzard (`UI-StatusBar`), Blizzard Character Skills Bar.

**Borders:** None, Blizzard Dialog / Dialog Gold, Tooltip, Party, Achievement Wood, Chat Bubble.

**Backgrounds:** Dialog backgrounds, Marble, Rock, Parchment variants, Tooltip, Solid (`WHITE8X8`), etc.

For Church of Beef V1, these four fonts + dialog/tooltip borders are enough to look “Classic” without shipping files.

---

## 5. How brandable systems use LSM

| Pattern | Who | Behavior |
|---------|-----|----------|
| **Register on load** | SharedMedia packs, ElvUI media modules | Add named textures/fonts into the global pool |
| **Fetch in UI code** | Unit frames, bars, WA, meters | Options store the *key*; runtime `Fetch` resolves path |
| **Soft absence** | Mature addons | If LibStub fails or `Fetch` returns nil → hard-coded Blizzard path |

ElvUI’s Classic forks register blank/glow media into LSM from inside the addon tree (example: [ElvUI-TBC sharedmedia.lua](https://github.com/ElvUI-TBC/ElvUI/blob/master/ElvUI/media/sharedmedia.lua) — `ElvUI Blank`, `ElvUI GlowBorder`, etc.). That is the “ship media inside yourself, still speak LSM” pattern.

---

## 6. Implications for Church of Beef

| Phase | Stance |
|-------|--------|
| **V1** | Do **not** require LSM. Use default UI fonts; obey spec §10 / §11 missing-media fallback. Matches [04-ace3-and-libraries.md](../04-ace3-and-libraries.md) §4. |
| **V2 theatrical** | Optionally *embed* a few Church fonts/statusbars/backgrounds and **Register** them if LSM is present — so ElvUI/WeakAuras users can pick “Church of Beef” in their own dropdowns. Never make Register/Fetch mandatory for ladder readability. |
| **Sounds** | LSM SOUND exists; V1 guild-chat announcement is enough spectacle. Ceremonial stingers are V2+ and should stay optional/opt-in. |

---

## 7. Sources

- [LibSharedMedia-3.0 — WowAce](https://www.wowace.com/projects/libsharedmedia-3-0)
- [API Documentation](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation)
- [LibSharedMedia-3.0 — CurseForge](https://www.curseforge.com/wow/addons/libsharedmedia-3-0)
- [SharedMedia Extended — CurseForge](https://www.curseforge.com/wow/addons/sharedmediax)
- [ElvUI-TBC media sharedmedia.lua](https://github.com/ElvUI-TBC/ElvUI/blob/master/ElvUI/media/sharedmedia.lua)
