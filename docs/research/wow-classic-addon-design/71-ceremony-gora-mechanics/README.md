# Track 71 — Ceremony & Gora ritual mechanics

**Track id:** `71-ceremony-gora-mechanics`  
**Last updated:** 2026-07-25  
**Sole focus:** Anniversary V1 **ritual state machines** for thin Ceremony start/close and Beef Gora challenge → recorded outcome — theatrical score fuel, not PvP automation or match theater.  
**Out of scope:** HC `/makgora` naming & death stakes ([60](../60-hardcore-doomhowl-edges/beef-scoring-ceremony-hc-rules.md) R2/H5 — **do not restate here**); wagering/EULA framing ([24](../24-policy-tos-compliance/)); calendar/RSVP products ([39](../39-guild-calendar-events/)); guild-night facilitator ops ([51](../51-guild-night-playbook/)); V3 wrestling-show packaging (spec §3.2). No addon implementation in this folder.

## Product truth (from V1 design spec)

| Locked | Value |
|--------|-------|
| Ceremony | Officer starts; attendees credited **when it closes** — medium flat grant ([§7.1](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Beef Gora | Challenge issued → outcome recorded (win / loss / draw); **losses pay** ([§7.1](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| V1 UI | Thin stubs only: Gora “record result,” Ceremony “start/close” ([§10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Mid-ceremony disconnect | No credit until officer closes cleanly or grants manual credit ([§11](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Deferred | Full ceremony dashboard; deep Gora match theater / favor meter ([§3.2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Anti-automation | Addon must not play the game ([§2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)); human click for score-relevant rites |

## Index

| Note | Covers |
|------|--------|
| [thin-v1-ceremony-stubs.md](thin-v1-ceremony-stubs.md) | Ceremony open/close state machine, attendance mark, UI budget |
| [gora-challenge-flows.md](gora-challenge-flows.md) | Challenge → outcome flows; theatrical vs PvP-automation line |
| [officer-close-patterns.md](officer-close-patterns.md) | Who may close, confirm friction, abort / manual credit |
| [cousin-ritual-addons.md](cousin-ritual-addons.md) | Duel logs, loot decisions, attendance, immersion cousins |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Boundary with sibling tracks

| This track (71) | Elsewhere |
|-----------------|-----------|
| Ritual *mechanics* (states, who clicks, when points fire) | [26](../26-ladders-points-gamification/) — weights, DR, losses-pay doctrine |
| Ceremony as guild-night *block* | [51](../51-guild-night-playbook/) — timing & facilitators |
| Cadence / seasons / calendars | [39](../39-guild-calendar-events/) — Discord owns RSVP |
| Confirm dialog chrome for nuclear officer acts | [58](../58-staticpopup-confirms/) — demote/Prophet; ceremony close is lighter |
| Flavor copy for stubs | [32](../32-microcopy-tone-voice/) · [53](../53-beef-lore-ui-bible/) |
| HC Mak’gora lexicography & “do not auto-score death duels” | [60](../60-hardcore-doomhowl-edges/) — cite only |
| Wagering / automation ToS | [24](../24-policy-tos-compliance/) |

## Top insights for Beef (read this first)

1. **V1 rites are two short state machines, not products.** Ceremony = `Idle → Open → Closed(+attendance)`. Gora = `Idle → Challenged → Recorded(win\|loss\|draw)`. Each ends with a **human officer (or designated recorder) click** that grants standing. Anything beyond that is V2/V3 theater.

2. **World of Warcraft duel APIs are optional theater cues — never score authority.** Clients can `StartDuel` / `AcceptDuel` and hear `DUEL_FINISHED` ([AcceptDuel](https://warcraft.wiki.gg/wiki/API_AcceptDuel); [DUEL_FINISHED](https://warcraft.wiki.gg/wiki/DUEL_FINISHED); [StartDuel](https://wowpedia.fandom.com/wiki/API_StartDuel)), but Beef standing must not auto-fire from those events. Auto-accept, auto-start, or “CLEU saw a win → +points” crosses the §2 “must not play the game” line and invites farm rings ([26 anti-farm](../26-ladders-points-gamification/anti-farm-incentives.md)).

3. **Officer close is the attendance gate — same pattern as loot ML awards.** Cousins that feel right: Gargul’s human decision + short note ([13 steal/avoid](../13-cousin-addon-teardowns/steal-avoid-for-beef.md)); Guild Raid Attendance’s *admin edits then save* sheet ([GRA](https://www.curseforge.com/wow/addons/guild-raid-attendance)). Cousins that feel wrong for V1: GRA’s full EPGP/CSV stack, Group Calendar RSVP as credit ([39](../39-guild-calendar-events/)).

4. **Skip-friendly liturgy beats staged religion.** Immersion / Dialogue UI teach officers to finish a rite in seconds ([07](../07-immersion-roleplay-flavor/)). Ceremony chrome that demands cutscenes or multi-page scripture will not get run on guild night ([51](../51-guild-night-playbook/) ~5–10 min block).

5. **Personal duel ledgers are cousins, not competitors.** [DuelBook](https://www.curseforge.com/wow/addons/duelbook) and demand threads for W/L logs ([EU forums](https://eu.forums.blizzard.com/en/wow/t/duel-logs-addon/154534)) prove rivalry memory is wanted. Beef should steal **challenge → outcome labels** and optional per-opponent history on My Standing — not Elo hero UIs or silent auto-logging as official ladder fuel.

## Recommended V1 mechanics (one line)

**Officer Start/Close ceremony with explicit attendance mark; human Record Gora result (win/loss/draw) with losses paying; duel client APIs may prefill UI hints only; never auto-score; no match theater.**

## Provenance

| Dump | Contents |
|------|----------|
| [`.raw/search-duel-apis.json`](.raw/search-duel-apis.json) | Duel APIs, DuelBook, policy threads |
| [`.raw/search-wiki-duel.json`](.raw/search-wiki-duel.json) | Wiki StartDuel / AcceptDuel / DUEL_FINISHED |
| [`.raw/extract-duel-wiki.json`](.raw/extract-duel-wiki.json) | AcceptDuel extract (sibling wiki pages 403 during research pass) |
| [`.raw/search-ritual-cousins.json`](.raw/search-ritual-cousins.json) | GRA, calendars, Immersion-adjacent, RCL vs Gargul |

Prefer design spec for product truth; wiki + cousin CurseForge for ecosystem norms. URL annotations: [annotated-urls.md](annotated-urls.md). Naming caution for Mak’gora lives only in [60](../60-hardcore-doomhowl-edges/).
