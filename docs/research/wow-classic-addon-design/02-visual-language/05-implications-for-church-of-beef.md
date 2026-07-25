# Implications for Church of Beef

**Last updated:** 2026-07-25  
**Inputs:** This track’s roster + axes docs; design spec §1, §3.3, §4, §10.

---

## Verdict

Top Classic UI overhauls split into **nostalgia-native tool windows** (Questie, AtlasLoot, Auctionator, default chrome) and **clean modern Classic systems** (ElvUI, Plater, WA packs, Details skins). Church of Beef is a **social institution UI**, not a raid HUD. V1 should read as a **small Classic tool window** with absurd copy; later art should dress that window like a ridiculous cathedral — not like ElvUI and not like a WeakAuras pack.

---

## Top visual-design insights (actionable)

1. **Inherit Blizzard chrome in V1.** Spec §10 already allows plain Classic frames. That matches the winning pattern of AtlasLoot / Auctionator / Questie: add data, don’t invent a third UI religion on day one.

2. **Do not brand as ElvUI-flat.** ElvUI is the clean-modern pole ([Tukui screenshots](https://tukui.org/elvui)). Beef brand wants Scarlet / cathedral / steak pageantry (spec §3.3). Flat grey = invisible among ElvUI users *and* off-brand.

3. **Tabbed tool window > dashboard.** Ladder / My Standing / Officer ≈ Auctionator tabs + AtlasLoot list scanning. Reject Details!-meter density and Cell-like grids.

4. **Hard edges, high opacity, no glass.** Streamer-event adjacency (spec §1) needs contrast. Translucent retail glass reads “wrong church” on Classic clients already arguing about Blizzard’s 2026 UI modernization ([Blizzard Watch](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)).

5. **Default fonts until art exists.** Condensed/pixel LSM fonts are ElvUI/WA culture. Spec requires fallback if media missing — make fallback the V1 path.

6. **One toast, then silence.** Steal WA/Plater *timing*, not persistence. Guild-chat promotion line is the V1 spectacle that non-addon members see (spec §10).

7. **Rank escalation is heraldry, not HP bars.** Progressive bone → gold → scarlet devices for Fresh Beef … Beef Prophet (see [03-steal-adapt-matrix.md](03-steal-adapt-matrix.md)). Never fake unit-frame health for standing.

8. **Coexist with ElvUI or fail socially.** Unique frame, saved position, collector-friendly minimap button; no global skinning; don’t assume chat frame indices.

9. **Council / Prophet must look scarce.** Spec §4.1 seat limits and unique Prophet are gameplay — reinforce visually later so the top of the ladder never looks like another grind row.

10. **Motion is ceremony, not combat.** Constant pulses = retail raid HUD. Rare motion = church calendar. Reserve animation budget for promotion / demotion / Prophet bestowal.

---

## V1 vs later art pass

| Concern | V1 | Later |
|---------|----|-------|
| Frame chrome | Default Classic dialog / simple backdrop | Cathedral / Scarlet-inspired borders, seals |
| Fonts | Default UI fonts | Optional display face for titles; still fallback-safe |
| Color | Default + mild player highlight | Bone / candle-gold / scarlet ladder escalation |
| Toasts | Single plain toast | Ornate one-shot card |
| Spectacle | Guild chat line | Toast + chat; optional spotlight |
| Dependencies | None for look | Still avoid hard LSM requirement |

---

## Anti-patterns checklist

- [ ] Ladder looks like Details! or Cell  
- [ ] Translucent grey panels on stream  
- [ ] Persistent center-screen WA energy  
- [ ] Class-color rainbow instead of Beef heraldry  
- [ ] Fighting ElvUI bags/chat/minimap  
- [ ] Requiring retail Edit Mode  
- [ ] Inventing non-canon clergy rank names in UI copy  

---

## Open questions (visual only)

- Exact post-V1 texture source strategy (packaged TGA vs optional media pack).  
- How loud Prophet chrome can be before it clips under ElvUI nameplates/WA.  
- Whether Alliance Dreamscythe vs Horde Doomhowl guilds want faction-tinted accents (separate ladders per spec §5 — accents optional).

---

## Related docs

- [01-classic-native-vs-retail.md](01-classic-native-vs-retail.md)  
- [02-addon-roster.md](02-addon-roster.md)  
- [03-steal-adapt-matrix.md](03-steal-adapt-matrix.md)  
- [04-annotated-references.md](04-annotated-references.md)  
- Design spec: `docs/superpowers/specs/2026-07-25-church-of-beef-design.md`
