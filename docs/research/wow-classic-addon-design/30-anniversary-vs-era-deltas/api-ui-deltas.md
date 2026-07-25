# API and UI deltas (Anniversary vs Era and neighbors)

**Last updated:** 2026-07-25  
**Scope:** Product-relevant differences in UI surface and game APIs — not a full FrameXML changelog.  
**Related tracks:** [15-instance-completion-events/](../15-instance-completion-events/), [14-addon-messaging-beefnet/](../14-addon-messaging-beefnet/), [16-guild-roster-officer-edges/](../16-guild-roster-officer-edges/).

---

## 1. Shared UI code ≠ shared content

Official stance (Kaivax, Jul 2026): **all versions of WoW Classic share code with modern World of Warcraft**. Anniversary patch 2.5.5 pulled raid-frame lineage from The War Within; patch 2.5.6 aligned further toward Midnight-style nameplates/raid frames. Classic Era / SoD / Hardcore received analogous updates in **1.15.9**, and Blizzard explicitly told authors that **the addon API in 1.15.9 very closely matches 2.5.6** — use Anniversary 2.5.6 as a prep environment for Era UI breakage ([User Interface Updates in Classic](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408); [Patch 2.5.6/API changes](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes); [Blizzard Watch summary](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)).

**Beef UI implication:** “Plain Classic frames” still means *Classic-native relative to ElvUI*, not 2007 pixel freeze. Prefer ordinary frames + LibDBIcon; do not assume Addon Compartment or retail-only chrome. Avoid building visual identity on raid-frame/nameplate art that Blizzard is actively restyling.

---

## 2. Delta matrix (product / API surface)

| Area | Classic Era / SoD / HC | TBC Anniversary | Beef relevance |
|------|------------------------|-----------------|----------------|
| Client root | `_classic_era_` | `_anniversary_` | Install/docs only |
| Game type | `vanilla` | `tbc` | TOC / AllowLoadGameType |
| Interface family | `115xx` | `205xx` (`20506` @ 2.5.6) | Packaging |
| Max level / zones | 60 Azeroth (+ SoD seasons) | 70 Outland + TBC dungeons/raids | Instance co-play scoring must know TBC instance set |
| Attunements / heroics | Minimal Era attune culture | Heavy keys, heroics, Kara/raid chains | Cousin addons (Attune) dominate attention; Beef stays non-combat |
| Focus frame / TBC unit UI | Era baseline simpler | TBC-era focus and party expectations | Do not hard-require focus APIs for V1 ladder |
| Flying / Outland systems | N/A | Present mid-expansion | Irrelevant to ladder; don’t key scoring on flying |
| Guild roster / officer ranks | Same modern guild API family | Same family | Officer+ gate portable if roster APIs stay aligned |
| Addon messaging (`GUILD`) | Classic CHANNEL ban history | Same Classic messaging culture | BeefNet stays `GUILD` + prefix (track 14) |
| Default nameplates / raid frames | Modernized with 1.15.9 wave | Modernized 2.5.5→2.5.6 | Coexistence: stay off combat HUD |
| Edit Mode | Arriving/arrived with modern Classic UI push | Present with Anniversary modern UI | Players may move Blizzard frames; Beef should use its own frame + slash |

---

## 3. What is *not* a safe “same API” assumption

Kaivax’s “1.15.9 ≈ 2.5.6” advice is about **shared UI code / addon API shape**, not about expansion content tables.

Still isolate (spec §12 portability seams):

1. **TOC / Interface / game type** — always flavor-specific.
2. **Instance detection** — dungeon/raid/BG IDs and completion events differ by expansion; Anniversary has heroics and TBC raid IDs Era lacks (feeds standing from shared instance presence).
3. **Addon message APIs** — currently same Classic family; re-verify on any Classic+ or Midnight clamp.

Do **not** call Retail / Dragonflight-only APIs on either client (hard project rule).

---

## 4. Content-driven API expectations players feel as “addon differences”

Even when Lua APIs look similar, Anniversary players expect tools that encode TBC data:

- Attune / AtlasLoot **TBC** databases ([Attune CurseForge](https://www.curseforge.com/wow/addons/attune); [MMOJUGG Phase 1 stack](https://www.mmojugg.com/news/essential-addons-for-tbc-classic-anniversary-2026-dominate-outland.html))
- WeakAuras / DBM packs labeled for TBC Anniversary
- Calendar/reset tools extended for TBC raids ([ClassicCalender_TBC](https://www.curseforge.com/wow/addons/classiccalender-tbc))

Beef should:

- Ship **TBC Anniversary** as the named platform in Title/Notes.
- Keep machine canon (ranks, thresholds) expansion-agnostic.
- Gate any future Era port behind instance-ID tables and Interface, not behind rewriting ladder IA.

---

## 5. Cross-flavor UI modernization checklist for Beef

From Jul 2026 Classic UI update ([forum](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408), [Blizzard Watch](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)):

- Nameplate/raid-frame **default art drifts** — third-party combat HUDs broke until authors updated; social edge UIs were less exposed but should not parent to raid frames.
- CVars such as `nameplateShowClassColor`, `nameplateShowFriendlyClassColor`, `raidFramesDispelIndicatorOverlay` are player-facing toggles — Beef must not fight them.
- Edit Mode exists in this Classic generation — expect players to rearrange Blizzard chrome; keep Beef frames independently movable or centered on `/beef`.

---

## Sources

- [User Interface Updates in Classic — Kaivax](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408) (Jul 2026)
- [Patch 2.5.6/API changes](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes)
- [Blizzard Watch — modernized Classic/Anniversary UI](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/) (Jul 2026)
- [TOC format — game types](https://warcraft.wiki.gg/wiki/TOC_format)
- Design spec §2, §12
