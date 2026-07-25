# 4K & Ultrawide on Classic

**Track:** [43-ui-scale-pixel-perfection](README.md)

---

## Why high-DPI Classic feels “wrong” by default

1. **Virtual height stays 768** while physical height grows → without lowering scale, UI elements cover more real pixels and look soft/chunky ([Wowpedia — UI Scale](https://wowpedia.fandom.com/wiki/UI_Scale)).
2. **Classic auto-scale stays high** (~0.90 at 1440p vs Retail’s 0.64) → stock Classic is *larger*, not sharper ([Warcraft Wiki — UI scaling](https://warcraft.wiki.gg/wiki/UI_scaling)).
3. **CVar floor 0.64** blocks true pixel-perfect via the settings slider past 1200p vertical — players install scale addons or run `UIParent:SetScale(768/h)` ([Wowpedia — UI Scale](https://wowpedia.fandom.com/wiki/UI_Scale)).
4. **Pure pixel-perfect at 4K** (`768/2160 ≈ 0.356`) makes Blizzard frames tiny; packs then re-scale individual frames (AtrocityUI + [ZoxeTweaks](https://github.com/geek0x23/ZoxeTweaks)) or apply a **modifier** on top of perfect scale ([PixelPerfectUIScale](https://www.curseforge.com/wow/addons/pixelperfectuiscale)).

---

## Ultrawide (21:9 / 32:9) geometry

Virtual width expands with aspect ([Warcraft Wiki — UI scaling](https://warcraft.wiki.gg/wiki/UI_scaling)):

| Aspect | Approx. virtual width @ height 768 |
|--------|-------------------------------------|
| 16:9 | ~1365 |
| 21:9 | ~1843 |

Effects for addons:

- **Center-anchored** toasts stay visually centered on the game world — good.
- **Corner-anchored** frames sit farther from the action on ultrawide; players drag them inward (spec’s movable + saved position matters more here).
- ElvUI optionally **narrows** its private parent (`IsUltrawide` maps 3440×1440 toward a 2560-wide layout) so UI doesn’t stretch edge-to-edge ([ElvUI PixelPerfect.lua](https://github.com/tukui-org/ElvUI/blob/main/ElvUI/Game/Shared/General/PixelPerfect.lua)). ZoxeTweaks exists specifically for **3440×1440** AtrocityUI tuning ([ZoxeTweaks](https://github.com/geek0x23/ZoxeTweaks)).

Beef V1 does not need eyefinity logic; it needs **clamp-to-screen** so saved points cannot leave the visible UIParent rect on extreme aspects.

---

## OS / client DPI traps (especially Mac + 4K)

Retail-era forum reports (still relevant as “client can lie about resolution”) show fullscreen + **macOS “looks like 1440p”** scaling breaking WoW’s notion of resolution above 1440p; windowed mode or matching OS scale to native 4K restored sanity ([EU forums — UI Scaling Broken](https://eu.forums.blizzard.com/en/wow/t/ui-scaling-broken/525386)). Config.wtf can claim `3840x2160` while the in-game menu shows 1440p.

**QA note for Beef:** when a bug report says “toast tiny on 4K,” ask for OS display scaling + whether they run PixelPerfect/ElvUI — not just the monitor model.

---

## Representative physical setups (Anniversary guild)

| Setup | Physical | Typical player scale story | Beef risk |
|-------|----------|----------------------------|-----------|
| 1080p laptop | 1920×1080 | Often ~1.0 / near perfect | Baseline |
| 1440p 16:9 | 2560×1440 | Classic auto ~0.90 **or** ElvUI ~0.53 | Most common “big UI” vs “tiny crisp UI” split |
| 1440p ultrawide | 3440×1440 | Same height math as 1440p; wider clamp box | Corner anchors feel far; save position |
| 4K | 3840×2160 | Perfect scale tiny → modifier 1.25–1.5 common | Don’t assume readability from virtual font size alone |
| Steam Deck / portable | varies | Physical size API for profile switching | Use `GetPhysicalScreenSize`, not `GetScreenWidth` ([forum](https://eu.forums.blizzard.com/en/wow/t/accurately-determine-the-selected-screen-resolution/431926)) |

---

## Sources

- [Warcraft Wiki — UI scaling](https://warcraft.wiki.gg/wiki/UI_scaling) (includes 21:9 width)
- [PixelPerfectUIScale](https://www.curseforge.com/wow/addons/pixelperfectuiscale) (4K modifier)
- [ElvUI PixelPerfect.lua](https://github.com/tukui-org/ElvUI/blob/main/ElvUI/Game/Shared/General/PixelPerfect.lua)
- [ZoxeTweaks](https://github.com/geek0x23/ZoxeTweaks)
- [EU forums — UI Scaling Broken](https://eu.forums.blizzard.com/en/wow/t/ui-scaling-broken/525386)
