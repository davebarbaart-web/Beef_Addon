# Pixel-Perfect Libraries & Patterns

**Track:** [43-ui-scale-pixel-perfection](README.md)

---

## What “pixel perfect” means in WoW

Not “retina assets.” It means choosing a UI scale so that **one virtual unit maps cleanly onto integer monitor pixels**, killing 1px border shimmer ([Wowpedia — UI Scale](https://wowpedia.fandom.com/wiki/UI_Scale); [Warcraft Wiki — UI scaling](https://warcraft.wiki.gg/wiki/UI_scaling)).

Two complementary techniques appear in the ecosystem:

1. **Global scale** — force `768 / physicalHeight` on UIParent (or via CVars when ≥ 0.64).
2. **Local mult / snap** — keep whatever scale the user chose, but round sizes/offsets to a computed pixel multiple (`E.mult`, `pmult`, Blizzard `PixelUtil`).

---

## Standalone scale enforcers

### PixelPerfectUIScale (CurseForge, multi-flavor including Classic TBC)

- Formula: **`768 / screenHeight`**, reapplied on login / display / UI scale / Edit Mode events ([CurseForge — PixelPerfectUIScale](https://www.curseforge.com/wow/addons/pixelperfectuiscale)).
- Origin: conversion of potat0nerd’s WeakAura “[Pixel perfect ui scale](https://wago.io/_F7SrQJMS).”
- **Modifier** slash (`/ppscale modifier 1.5`) — multiplies base perfect scale for 4K/ultrawide where pure `768/h` makes everything unreadably small.
- Defers scale writes out of combat (Midnight-safe pattern; still relevant for Classic protected calls).

### Older UIScale downloadables

Wiki still points at classic UIScale helpers for the `UIParent:SetScale` path above 1200p ([Warcraft Wiki — UI scaling](https://warcraft.wiki.gg/wiki/UI_scaling) → wowinterface `info16878`).

### Manual one-liner (author folklore)

p3lim’s 1440p recipe ([WoWInterface — 2560×1440 pixel perfect](https://wowinterface.com/forums/archive/index.php/t-56862.html)):

```lua
SetCVar('useuiscale', 1)
SetCVar('uiscale', 1)
local _, height = GetPhysicalScreenSize()
UIParent:SetScale(768 / height)
```

Then optionally scale individual Blizzard frames up so dialogs stay readable — the same tradeoff ZoxeTweaks automates for AtrocityUI packs ([ZoxeTweaks](https://github.com/geek0x23/ZoxeTweaks)).

---

## ElvUI `PixelPerfect.lua` (reference implementation)

ElvUI is the de facto “how serious UIs do this” source ([tukui-org/ElvUI PixelPerfect.lua](https://github.com/tukui-org/ElvUI/blob/main/ElvUI/Game/Shared/General/PixelPerfect.lua)):

| Piece | Behavior |
|-------|----------|
| `E.perfect` | `768 / physicalHeight` on `UI_SCALE_CHANGED` |
| `E.mult` | `E.perfect / E.global.general.UIScale` — local pixel multiple |
| `E:Scale(x)` | Snaps lengths to `E.mult` grid |
| `E:UIScale()` | Sets `UIParent:SetScale(E.global.general.UIScale)`; combat-deferred |
| `E.UIParent` | Separate parent sized for **eyefinity / ultrawide** (narrowed logical width) |
| `IsUltrawide` / `IsEyefinity` | Maps ultra-wide / multi-monitor widths down to a “design width” (e.g. 3440×1440 → treat as 2560-wide layout) |

Forum consensus: prefer a **private parent** (`ElvUIParent`-style) over mutating global `UIParent` when you only need your own frames crisp — mutating UIParent affects every addon ([WoWInterface — Achieving pixel perfection](https://www.wowinterface.com/forums/showthread.php?t=56898)).

---

## Blizzard `PixelUtil`

FrameXML exposes **PixelUtil** helpers for snapping without owning global scale ([SDPhantom citing PixelUtil.lua](https://www.wowinterface.com/forums/showthread.php?t=57848); [tomrus88 BlizzardInterfaceCode PixelUtil.lua](https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/SharedXML/PixelUtil.lua)). Prefer checking Classic Anniversary availability before depending on it; if missing, ElvUI-style `mult` math is the portable fallback.

---

## Local `pmult` without changing UIParent

d87’s approach when global scale stays user-controlled ([WoWInterface — Achieving pixel perfection](https://www.wowinterface.com/forums/showthread.php?t=56898)):

```lua
pmult = (768 / h) / UIParent:GetScale()
-- then SetSize / SetPoint offsets *= pmult (or round to pmult)
```

Useful for 1px borders on a social addon that must not fight ElvUI’s scale ownership.

---

## What Beef should adopt vs skip

| Pattern | Beef V1 stance |
|---------|----------------|
| Embed / depend on PixelPerfectUIScale | **No** — scale ownership is a UI-suite concern |
| Mutate `UIParent` scale | **No** — breaks raiders’ WA/ElvUI contracts |
| Own `BeefParent` with SetAllPoints + optional snap | Optional later; not required for plain Classic frames |
| Size/position in UIParent units; clamp to screen | **Yes** (spec §10) |
| Round decorative 1px borders with a tiny `mult` helper | Nice-to-have if borders shimmer in QA |
| Assume ElvUI is present | **No** — coexist, don’t require |

---

## Sources

- [CurseForge — PixelPerfectUIScale](https://www.curseforge.com/wow/addons/pixelperfectuiscale)
- [ElvUI PixelPerfect.lua](https://github.com/tukui-org/ElvUI/blob/main/ElvUI/Game/Shared/General/PixelPerfect.lua)
- [WoWInterface — Achieving pixel perfection](https://www.wowinterface.com/forums/showthread.php?t=56898)
- [WoWInterface — Pixel Perfect UIScale](https://www.wowinterface.com/forums/showthread.php?t=57848)
- [ZoxeTweaks](https://github.com/geek0x23/ZoxeTweaks)
