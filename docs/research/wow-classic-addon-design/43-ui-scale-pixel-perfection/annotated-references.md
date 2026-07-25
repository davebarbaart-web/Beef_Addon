# Annotated URLs — UI Scale & Pixel Perfection

Primary sources for track 43. Prefer these over UI-pack marketing when deciding layout policy.

## Core model (virtual coords / scale)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/UI_scaling | Canonical: 768-tall screen units, aspect widths (incl. 21:9), Classic vs Retail default scales, pixel-perfect `768/vRes`, CVar floor → `UIParent:SetScale` escape hatch. |
| https://wowpedia.fandom.com/wiki/UI_scaling | Mirror of UI scaling article (screen/region units, examples). |
| https://wowpedia.fandom.com/wiki/UI_Scale | Older “UI Scale” explainer: texture oversize table, Classic auto range ~0.90–1.00, 0.64 floor, shimmering 1px borders. |

## Screen APIs

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/API_GetScreenWidth | Returns width at **UIParent scale**, not Video Options resolution; aspect-ratio note + effective-scale example. |
| https://warcraft.wiki.gg/wiki/API_GetPhysicalScreenSize | True graphics-menu width/height; added 7.1.0 / Classic 1.13.2 — use for `768/h` and physical QA. |
| https://wowwiki-archive.fandom.com/wiki/API_GetScreenWidth | Archive example: 1280×1024 → printed 960×768 (same aspect). |
| https://addonstudio.org/wiki/WoW:API_GetScreenHeight | Parallel height docs + same aspect caveat. |
| https://eu.forums.blizzard.com/en/wow/t/accurately-determine-the-selected-screen-resolution/431926 | Field proof: 2560×1440 → `GetScreen*` prints 2133×1200; fix = `GetPhysicalScreenSize()`. |

## Pixel-perfect tooling & author practice

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.curseforge.com/wow/addons/pixelperfectuiscale | Modern multi-flavor enforcer (`768/height` + modifier for 4K/UW); event list; combat deferral — **steal patterns, don’t embed**. |
| https://wago.io/_F7SrQJMS | Original “Pixel perfect ui scale” WeakAura (potat0nerd) that PixelPerfectUIScale preserves. |
| https://github.com/tukui-org/ElvUI/blob/main/ElvUI/Game/Shared/General/PixelPerfect.lua | Reference: `E.perfect`, `E.mult`, `E:Scale`, private parent, ultrawide/eyefinity narrowing, combat-safe `UIParent:SetScale`. |
| https://www.wowinterface.com/forums/showthread.php?t=56898 | Author thread: virtual pixels, `pmult`, CVar vs UIParent for >1080p, ElvUIParent advice. |
| https://www.wowinterface.com/forums/showthread.php?t=57848 | SDPhantom: formula `768/select(2,GetPhysicalScreenSize())` + Blizzard PixelUtil pointer; myrroddin ≥1200 height branch. |
| https://wowinterface.com/forums/archive/index.php/t-56862.html | p3lim 1440p recipe: CVars + `UIParent:SetScale(768/height)` then upscale individual frames. |
| https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/SharedXML/PixelUtil.lua | Upstream PixelUtil source (availability on Anniversary must be verified at implement time). |
| https://github.com/geek0x23/ZoxeTweaks | Real-world 1440p + **3440×1440** pack: scale Blizzard frames *without* breaking WA pixel-perfect UIParent scale. |

## Classic / OS edge cases

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.reddit.com/r/WowUI/comments/cz6rkm/ui_wow_classic_ui_scaling_isnt_pixelperfect_by/ | Classic launch: Retail ~0.711@1080p vs Classic default nearer ~0.9. |
| https://eu.forums.blizzard.com/en/wow/t/ui-scaling-broken/525386 | MacOS UI scaling vs fullscreen 4K; client can disagree with Config.wtf — QA interview tip. |

## Scale widget semantics (footguns)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://wowwiki-archive.fandom.com/wiki/API_Frame_SetScale | Child scale is relative to parent; stacks into effective scale. |
| https://us.forums.blizzard.com/en/wow/t/setscale-on-dialog/1191980 | Nil/wrong parent → “double size” dialogs; always parent toasts to a real `UIParent` hierarchy. |

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10 | Movable clamped frame, toasts, media fallback. |
| [`../17-stream-overlay-readability/`](../17-stream-overlay-readability/) | Viewer-facing type/safe zones/duration — complementary to this track’s client scale math. |
| [`beef-guidance.md`](beef-guidance.md) | Condensed V1 decisions from this research. |

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-pixel-perfect.json`](.raw/search-pixel-perfect.json) | Parallel search: PixelPerfect libs, ultrawide, scale addons |
| [`.raw/search-screen-apis.json`](.raw/search-screen-apis.json) | Parallel search: GetScreenWidth, ElvUI PixelPerfect, pmult |
| [`.raw/search-toast-scale.json`](.raw/search-toast-scale.json) | Parallel search: UI Scale / SetScale / toast-related |
| [`.raw/extract-apis.json`](.raw/extract-apis.json) | Extract: GetScreenWidth, GetPhysicalScreenSize, WoWInterface 56862 |
| [`.raw/extract-pixelperfect.json`](.raw/extract-pixelperfect.json) | Extract: PixelPerfectUIScale, ZoxeTweaks |
| [`.raw/extract-ui-scaling.json`](.raw/extract-ui-scaling.json) | Extract: UI_scaling wiki, ElvUI PixelPerfect.lua, resolution forum |
