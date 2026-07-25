# Virtual Coordinates & UI Scale

**Track:** [43-ui-scale-pixel-perfection](README.md)

---

## The 768-tall model

WoW does not lay out UI in raw framebuffer pixels. Screen units treat the visible height as **768** and the width as aspect-dependent ([Warcraft Wiki — UI scaling](https://warcraft.wiki.gg/wiki/UI_scaling)):

| Aspect | Virtual width | Virtual height |
|--------|---------------|----------------|
| 4:3 | 1024 | 768 |
| 5:4 | 960 | 768 |
| 16:9 | ~1365.3 | 768 |
| 16:10 | 1228.8 | 768 |
| 21:9 | ~1843 | 768 |

Widget lengths use **region units** that fold in effective scale:

```text
region:GetEffectiveScale() * physicalScreenHeight / 768
```

Implication: a frame sized `200×40` is “200 virtual units,” not “200 monitor pixels.” On a high-res display without a matching UI scale, 1px borders shimmer between 1 and 2 real pixels depending on position ([Wowpedia — UI Scale](https://wowpedia.fandom.com/wiki/UI_Scale)).

---

## Pixel-perfect scale formula

Canonical community formula ([Warcraft Wiki — UI scaling](https://warcraft.wiki.gg/wiki/UI_scaling); [SDPhantom on WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=57848)):

```text
pixelPerfectScale = 768 / physicalHeight
```

Examples:

| Physical height | `768 / h` | Notes |
|-----------------|-----------|--------|
| 1080 | ≈ 0.711 | Fits in CVar slider (≥ 0.64) |
| 1200 | 0.64 | CVar floor — last height the slider can express exactly |
| 1440 | ≈ 0.533 | **Below** CVar floor; needs `UIParent:SetScale` (or an addon) |
| 2160 (4K) | ≈ 0.356 | Far below floor; pure CVar path impossible |

---

## Classic vs Retail default scales

With **Use UI Scale** unchecked, the client picks different defaults by flavor ([Warcraft Wiki — UI scaling](https://warcraft.wiki.gg/wiki/UI_scaling)):

| Resolution | Retail (scale off) | Classic (scale off) |
|------------|--------------------|---------------------|
| 2560×1440 | 0.64 | **0.90** |
| 1920×1080 | 1.00 | 1.00 |
| 1280×1024 | 0.79 | 0.90 |
| 1024×768 | 1.00 | 1.00 |

Wowpedia’s older “UI Scale” page also notes Classic’s auto range sits roughly **0.90–1.00**, while Retail can drop toward **0.64** ([Wowpedia — UI Scale](https://wowpedia.fandom.com/wiki/UI_Scale)). Community observation from Classic launch: Retail already sat near pixel-perfect at 1080p (`768/1080`), while Classic defaulted near **~0.9** ([r/WowUI](https://www.reddit.com/r/WowUI/comments/cz6rkm/ui_wow_classic_ui_scaling_isnt_pixelperfect_by/)).

**Beef takeaway:** Anniversary guildmates on 1440p with stock Classic settings see a **larger** UI than a Retail pixel-perfect setup at the same resolution. Toast defaults should assume Classic’s chunkier auto-scale first, then still read when someone forces `768/h`.

---

## CVar floor and the `UIParent:SetScale` escape hatch

- Enabled slider minimum is **0.64** ([Wowpedia — UI Scale](https://wowpedia.fandom.com/wiki/UI_Scale)).
- Above ~1200p vertical, pixel-perfect requires `UIParent:SetScale(768/height)` after load; that override is **not** persisted by the Video Options alone — hence UIScale / PixelPerfectUIScale-style addons ([Warcraft Wiki — UI scaling](https://warcraft.wiki.gg/wiki/UI_scaling)).
- Changing scale mid-combat can hit protected paths; serious scale addons defer until out of combat ([PixelPerfectUIScale](https://www.curseforge.com/wow/addons/pixelperfectuiscale)).

---

## Sources

- [Warcraft Wiki — UI scaling](https://warcraft.wiki.gg/wiki/UI_scaling)
- [Wowpedia — UI Scale](https://wowpedia.fandom.com/wiki/UI_Scale)
- [WoWInterface — Pixel Perfect UIScale](https://www.wowinterface.com/forums/showthread.php?t=57848)
- [r/WowUI — Classic default scale](https://www.reddit.com/r/WowUI/comments/cz6rkm/ui_wow_classic_ui_scaling_isnt_pixelperfect_by/)
