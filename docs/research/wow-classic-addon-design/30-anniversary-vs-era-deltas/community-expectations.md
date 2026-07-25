# Community expectations (Anniversary vs Era)

**Last updated:** 2026-07-25  
**Scope:** What players and guilds assume about addons on TBC Anniversary vs Era-line clients — and how that shapes Church of Beef positioning.

---

## 1. Anniversary is a “fresh stack” culture (early 2026)

At TBC pre-patch / launch, players repeatedly hit:

- Separate Anniversary client → reinstall or copy AddOns/WTF ([Blizzard forums](https://us.forums.blizzard.com/en/wow/t/the-burning-crusadeaddons/2226408)).
- CurseForge missing **BCC Anniversary** tab until the Anniversary `Interface/AddOns` tree exists or the client is launched ([Sportskeeda](https://www.sportskeeda.com/mmo/best-wow-tbc-anniversary-addons-set)).
- Confusion between “Classic Anniversary” (20th / Era-era branding in older posts) and **TBC Classic Anniversary**.

**Beef onboarding must use the phrase “TBC Classic Anniversary (`_anniversary_` folder)”** — not “Classic” alone.

Realm transfer history also trained players that Anniversary and Era are divergent lives: free Anniversary → Era transfers closed when Anniversary went to TBC pre-patch ([Update Schedule for Anniversary Realms — Kaivax](https://us.forums.blizzard.com/en/wow/t/update-schedule-for-anniversary-realms/2223745)). Characters that stayed became TBC Anniversary characters; Era remains a separate product.

---

## 2. Dominant Anniversary addon expectations

Community “must-have” lists for TBC Anniversary cluster around:

| Job | Typical picks (guides) |
|-----|------------------------|
| Leveling / map | Questie, RestedXP, Leatrix Maps |
| Attunements | Attune (guild progress views) |
| Combat | DBM or BigWigs, Details!, Plater, WeakAuras |
| Loot / AH | AtlasLoot, Auctionator / TSM-class tools |
| Full UI | ElvUI or Bartender/Dominos + collectors |

Sources: [Overgear TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/), [MMOJUGG essentials](https://www.mmojugg.com/news/essential-addons-for-tbc-classic-anniversary-2026-dominate-outland.html), [Playhub best addons](https://playhub.com/blog/wow-anniversary/best-addons-873130), [Warperia TBC addons](https://warperia.com/tbc-addons/).

**Expectation gap Beef fills:** almost none of these lists include guild *institution* / ceremonial rank tools. That is good (open niche) and dangerous (players may misfile Beef as “another combat helper” if Notes/Title sound like DPS QoL).

**Positioning:** Title/Notes/README should read as social/guild spectacle. Stay off the center combat HUD so coexistence with DBM/WA/Plater matches Classic gravity norms (see library UX tracks).

---

## 3. Era / SoD / Hardcore expectations (contrast)

| Audience | Addon posture | Beef note |
|----------|---------------|-----------|
| Classic Era | Questie-centric; no TBC attune trees; often same UI modernizations post-1.15.9 | Not V1; would need Era Interface + instance tables |
| Season of Discovery | Heavy WeakAuras / seasonal systems | Different product surface; do not claim support |
| Hardcore | Death-aware tooling, risk UX; some players transferred off HC Anniversary before TBC | Spec brand mentions HC content historically; V1 ladder still Anniversary-only |

Attune’s own description spans Era and TBC/Wrath attunement cultures ([Attune on CurseForge](https://www.curseforge.com/wow/addons/attune)) — a reminder that multi-flavor cousins ship **data packs per expansion**, not one blob. Beef’s machine canon should stay expansion-agnostic; instance scoring tables should not.

---

## 4. Guild / streamer expectations for Church of Beef

From design context (Dreamscythe Alliance / Doomhowl Horde, stream spectacle):

- Members may dual-box or keep Era alts — they will ask “does Beef work on Era?” → answer: **V1 Anniversary only**; do not soft-claim Era via `_Classic.toc`.
- Officers expect tools to survive **addon-manager tab confusion** — document CurseForge BCC Anniversary + manual `_anniversary_` path.
- Stream overlays care about readable edge UI (track 17) more than Expansion fidelity; Anniversary vs Era does not change that, but wrong-client installs will create “it works on my PC” support noise.

---

## 5. Support FAQ snippets (copy-ready)

**Q: I installed Beef but don’t see it.**  
A: Confirm you are launching **TBC Classic Anniversary**, and the folder is `World of Warcraft/_anniversary_/Interface/AddOns/ChurchOfBeef` — not `_classic_era_`.

**Q: Can I copy my Era AddOns folder?**  
A: You can copy *files*, but Era Interface numbers and TBC-specific addons differ. For Beef, install the Anniversary build into `_anniversary_` only.

**Q: CurseForge has no Anniversary tab.**  
A: Launch Anniversary once (or seed any addon into `_anniversary_/Interface/AddOns`), reload CurseForge, select **BCC Anniversary** / TBC Anniversary ([Sportskeeda](https://www.sportskeeda.com/mmo/best-wow-tbc-anniversary-addons-set)).

**Q: Will my ladder sync to my Era alt?**  
A: No. Per-character SavedVariables are per client tree; V1 is Anniversary-only; Dreamscythe and Doomhowl are separate guild ladders anyway.

---

## Sources

- [Blizzard — Update Schedule for Anniversary Realms](https://us.forums.blizzard.com/en/wow/t/update-schedule-for-anniversary-realms/2223745) (Jan 2026)
- [Blizzard — The burning crusade/addons](https://us.forums.blizzard.com/en/wow/t/the-burning-crusadeaddons/2226408) (Jan 2026)
- [Sportskeeda — CurseForge BCC Anniversary setup](https://www.sportskeeda.com/mmo/best-wow-tbc-anniversary-addons-set) (Jan 2026)
- [Overgear — TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)
- [MMOJUGG — Must-have TBC Anniversary addons](https://www.mmojugg.com/news/essential-addons-for-tbc-classic-anniversary-2026-dominate-outland.html) (Feb 2026)
- [Attune — CurseForge](https://www.curseforge.com/wow/addons/attune)
