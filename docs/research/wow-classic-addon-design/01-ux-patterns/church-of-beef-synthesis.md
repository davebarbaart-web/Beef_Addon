# Church of Beef — UX Patterns Synthesis (Track 01)

**Last updated:** 2026-07-25  
**Lane:** Synthesis (fills the Track 01 gap: surface briefs → product decisions)  
**Maps to:** [V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §§1–2, 3.1, 4, 6.3, 10, 13–14  
**Evidence base:** notes in this folder · cross-check [library synthesis](../00-church-of-beef-implications.md) · [combat HUD implications](../08-combat-hud-alerts/church-of-beef-implications.md) · [guild social implications](../09-guild-social-community/implications-for-church-of-beef.md)

This document maps the Track 01 surface inventory onto Church of Beef V1. The per-surface notes stay thin on purpose; **this file is the Beef decision layer**.

---

## Verdict

Church of Beef is an **edge social tool**: slash + minimap entry, attentive panel for ladder / standing / officer work, glanceable toasts, and one throttled guild-chat line. It is **not** a combat HUD, raid frame, nameplate mod, or WeakAuras pack. Steal **information architecture** from loot-council / Attune / guild tools; steal **manners** (brief → clear, movable, clamp) from bar movers and WA culture — never their screen real estate.

---

## Top insights (actionable)

1. **Social gravity lives at the edges.** Critical combat info clusters center-lower ([action-bars](action-bars.md), [unit-frames](unit-frames.md), [weakauras-overlays](weakauras-overlays.md)); chat, minimap, meters, and guild tools stay peripheral ([README](README.md) mental model). Beef’s defaults must land in that peripheral band — never the WA/DBM fovea.

2. **Ladder ≠ raid frames.** Compact heal grids (Cell / VuhDo / Clique) own mid-screen during combat ([raid-frames](raid-frames.md)). The Beef ladder is a **scannable seven-rank roster**, not a health grid, click-cast surface, or standing-as-HP bar ([unit-frames](unit-frames.md)).

3. **Officer tab ≈ loot council, not Gargul density.** Pending suggestion → approve/reject with a short standing breakdown is the RCLC/Gargul *session* pattern ([loot](loot.md)). Do not ship auction-density columns ([auction](auction.md)) or full loot tables for comedy ranks.

4. **Attune is the co-play coordination cousin.** Progress tree ↔ ladder, guild survey ↔ BeefNet occupants, soft dependency without soft-lock ([quest-helpers](quest-helpers.md)). Questie-style pin spam is what ranks must never become on the minimap ([minimap](minimap.md)).

5. **Toasts steal WA manners, not WA placement.** Brief, high-contrast, then clear — for suggestion / rank / Gora / ceremony credit ([weakauras-overlays](weakauras-overlays.md); spec §10). No center yells, screen flash, or persistent proc icons. No WeakAuras dependency.

6. **Minimap button is the launcher; slash is the fallback.** Spec requires both to toggle the same frame ([minimap](minimap.md); §10). Prefer LibDBIcon-compatible behavior; hide-button pref later; `/beef` must always suffice.

7. **Guild chat is the V1 spectacle channel.** One throttled plain-text promote/demote line from the approving officer, readable without the addon ([chat](chat.md); success criterion §13.11). Chat pings; the frame is the system of record.

8. **Steal mover UX, never bar real estate.** Movable + clamp-to-screen + saved position from Bartender/Dominos/ElvUI culture ([action-bars](action-bars.md)). Do not occupy action bars, bind combat keys, or compete with OmniCC/proc glows.

9. **No plate / bag / AH surfaces in V1.** Nameplates ([nameplates](nameplates.md)), bags ([bags](bags.md)), and auction tables ([auction](auction.md)) are wrong layers — treat as awareness-only or anti-pattern references.

10. **Plain frames first; pageantry later.** Spec §10 already allows plain Classic chrome. Theatrical gothic pass is V2+ ([library synthesis](../00-church-of-beef-implications.md) §2).

---

## Surface → V1 mapping

| Surface note | Steal | Avoid / non-goal | V1 product surface |
|--------------|-------|------------------|--------------------|
| [action-bars](action-bars.md) | Movable, clamp, saved position; optional later fade | Bar slots, keybinds, cooldown text, proc glows | Main frame chrome behavior |
| [unit-frames](unit-frames.md) | Sparse “this is you” highlight; light class-color on names | Fake health/power bars for standing; aura density | Ladder local-player highlight |
| [raid-frames](raid-frames.md) | Per-row status badges (pending / online / approved metaphor) | Heal grids, click-cast, aggro glow, combat center | Officer queue **list**, not grid |
| [nameplates](nameplates.md) | — (awareness: default plates modernized 2026) | Any plate integration | None |
| [bags](bags.md) | Simple list if V2+ “relics” ever appear | Item spreadsheet / bag grid | None in V1 |
| [minimap](minimap.md) | LibDBIcon-style button; hide pref; collectors coexist | Rank pins fighting Questie/GatherMate | Minimap toggle = `/beef` |
| [weakauras-overlays](weakauras-overlays.md) | Brief → fade toast choreography; progressive disclosure | Center HUD, WA dependency, rotation packs | Toasts only (V2 may borrow spotlight) |
| [chat](chat.md) | Single-sender throttled guild announce; plain stream-readable text | Color spam; ladder-only-in-chat; announce storms | Promotion/demotion line (§10) |
| [loot](loot.md) | Officer pending queue + context + approve/reject | Dense raid-loot tables; autopilot award | Officer tab |
| [auction](auction.md) | — | Sortable economy density for standing | Anti-pattern for My Standing history |
| [quest-helpers](quest-helpers.md) | Attune: clear progress + optional guild visibility + no soft-lock | Questie pin spam for ranks; RestedXP arrows | Ladder + BeefNet degrade path |

---

## Spec §10 checklist (Track 01 lens)

| Spec item | UX-pattern guidance |
|-----------|---------------------|
| `/beef` opens real frame | Social entry; must not be chat-only ([README](README.md) + onboarding track) |
| Minimap button same toggle | LibDBIcon norms; slash remains enough |
| Ladder tab (7 ranks) | Roster board — **not** raid/unit frames |
| My Standing tab | Short event list — **not** AH/meter tables |
| Officer tab (Officer+ only) | Loot-council queue IA; confirm on demote / Prophet / wipe |
| Thin Gora / ceremony stubs | Feed scores; do not dominate chrome |
| Toasts (suggestion, rank, credit) | Peripheral, brief, non-combat-red, fade |
| Guild-chat promote/demote | Officer-only sender; throttle; no-addon readable |
| Movable + saved position | Bar-mover expectation; dodge WA layouts |
| Missing media fallbacks | Same reliability bar as tools players trust |

---

## Explicit non-goals (reinforced by this track)

Do **not** ship in V1 (or likely ever for these layers):

- Action-bar / cooldown / proc managers  
- Unit-frame or raid-frame replacements  
- Nameplate mods or title-on-plate experiments  
- WeakAuras (or any combat-overlay) dependency  
- Minimap rank pins or quest-helper overlays  
- Auction-density standing browsers  
- Bag/bank or item-grid “relic” UIs  

These compete with the Anniversary “must-have” stack and violate the hard “social, not combat assistance” line (spec §§1–2).

---

## Phase hints

| Phase | UX upgrade suggested by Track 01 |
|-------|----------------------------------|
| **V1** | Edge entry + ladder/standing/officer + peripheral toasts + guild announce |
| **V2** | Ceremonial dashboard; WA-style “spotlight N seconds then clear” — still out of boss-bar lane |
| **V3** | Gora match theater (session spectacle), still not a combat HUD |
| **Later** | Theatrical chrome / gothic skin; still movable and clamp-safe |

---

## Design tests (UX, not unit)

1. With a typical Anniversary layout (ElvUI or Bartender + WA + Plater + Cell), default Beef frame and toasts **do not cover** center-lower combat cluster.  
2. Opening `/beef` mid-raid feels like opening Gargul/Attune — attentive social — not like a new heal grid.  
3. Officer can clear a suggestion queue without learning a spreadsheet UI.  
4. A promotion produces **one** toast + **one** guild line; no spam from peers.  
5. Someone without the addon understands the guild-chat sentence.  
6. Ladder never presents standing as a health bar or raid-style click target.

---

## Sources

Synthesized from this track’s surface notes and:

- [Design spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)  
- [Overgear — TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)  
- [LibDBIcon-1.0](https://www.wowace.com/projects/libdbicon-1-0)  
- Peer syntheses: [00](../00-church-of-beef-implications.md), [08](../08-combat-hud-alerts/church-of-beef-implications.md), [09](../09-guild-social-community/implications-for-church-of-beef.md)
