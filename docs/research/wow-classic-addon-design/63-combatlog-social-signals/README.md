# Track 63 — Combat log / CLEU for social scoring signals

**Track id:** `63-combatlog-social-signals`  
**Last updated:** 2026-07-25  
**Client focus:** TBC Classic Anniversary (`Interface` **20506**), with Classic-family CLEU caveats that Anniversary inherits.  
**Scope:** Whether `COMBAT_LOG_EVENT_UNFILTERED` (CLEU) is ever appropriate for **guild social scoring** signals; cost vs party/roster/combat-flag events; Classic Anniversary CLEU caveats; Beef V1 recommendation.  
**Out of scope (do not rebuild here):** Combat HUD UX ([08](../08-combat-hud-alerts/)); instance/encounter reliability matrix ([15](../15-instance-completion-events/)); guildmate co-play presence APIs (own track [59](../59-coplay-guildmate-detection/)). No addon code in this folder.

## Spec anchors

Church of Beef V1 ([design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)):

| Spec bit | Relevance |
|----------|-----------|
| §1–2 Product: social ladder, not combat assist | CLEU is the combat-addon hot path — wrong default dependency |
| §7.1 Shared instance drip + completion bonus | Needs presence + instance + finish signals — not damage parsers |
| §7.2 Anti-AFK (combat during bucket) | Needs *entered combat*, not CLEU subevent forensics |
| §7.2 Instance types only | Open-world CLEU range drama is mostly irrelevant if scoring stays instanced |

## Docs in this track

| Note | Contents |
|------|----------|
| [beef-v1-recommendation.md](beef-v1-recommendation.md) | **Start here for implementers** — decide/avoid synthesis + strong-justification bar |
| [cleu-vs-roster-signals.md](cleu-vs-roster-signals.md) | When CLEU fits (rarely) vs `GROUP_ROSTER_*` / regen / instance events |
| [classic-anniversary-cleu-caveats.md](classic-anniversary-cleu-caveats.md) | Range, spellId, payload API, Advanced Logging, Retail contrast |
| [performance-cost.md](performance-cost.md) | Why always-on CLEU fails Beef’s FPS budgets |
| [annotated-urls.md](annotated-urls.md) | Annotated primary URLs |
| [`.raw/`](.raw/) | Parallel search/extract provenance |

## Top insights for Beef (read this first)

1. **V1 should not register CLEU.** Social scoring needs three cheap facts — *in qualifying instance*, *≥1 guildmate in group*, *saw combat this bucket* — all available without the combat log. CLEU answers *what ability hit whom for how much*, which is meter/boss-mod territory ([COMBAT_LOG_EVENT](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT); sibling [15](../15-instance-completion-events/), [08](../08-combat-hud-alerts/)).

2. **Party/roster events own co-play presence; regen owns anti-AFK.** `GROUP_ROSTER_UPDATE` fires on form/disband/join/leave ([GROUP_ROSTER_UPDATE](https://warcraft.wiki.gg/wiki/GROUP_ROSTER_UPDATE)). `PLAYER_REGEN_DISABLED` fires when the player enters combat (hate list or PvP action) ([PLAYER_REGEN_DISABLED](https://wowpedia.fandom.com/wiki/PLAYER_REGEN_DISABLED)). Neither requires parsing hundreds of CLEU lines per second.

3. **CLEU is always-on volume in the exact moments Beef must stay invisible.** Raid combat with boss mods already burns FPS on CLEU ([04](../04-toc-api-performance/) deep notes; [54](../54-memory-fps-budgets/good-looks-like-social.md)). A social addon that registers CLEU “just in case” competes with DBM/WeakAuras for the same hot path.

4. **Classic Anniversary inherits Classic CLEU quirks, not Retail Midnight’s CLEU removal.** Open world ≈50 yd; dungeons/raids unrestricted after 2020-06-22; TBC Classic restored `spellId` in **2.5.1**; modern clients read payloads via `CombatLogGetCurrentEventInfo()` ([wiki Classic patch notes](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT); [CombatLogGetCurrentEventInfo](https://warcraft.wiki.gg/wiki/API_CombatLogGetCurrentEventInfo)). Retail Midnight CLEU lockdown is a **portability warning** only — do not design V1 around it, and do not use it as an excuse to half-implement CLEU “for later.”

5. **If a future phase ever needed combat *detail*, prefer first-class events first.** Boss progress → `ENCOUNTER_END` / `BOSS_KILL` ([15](../15-instance-completion-events/)). BG finish → `GetBattlefieldWinner`. CLEU `UNIT_DIED` NPC tables remain **explicitly rejected** for Beef grants in the instance matrix.

## Recommended V1 policy (research conclusion)

| Signal | Prefer | CLEU? |
|--------|--------|-------|
| Guildmate in party/raid | Group APIs + `GROUP_ROSTER_UPDATE` ([59](../59-coplay-guildmate-detection/)) | **No** |
| Qualifying instance | `PLAYER_ENTERING_WORLD` + `IsInInstance` / `GetInstanceInfo` ([15](../15-instance-completion-events/)) | **No** |
| Anti-AFK combat flag | `PLAYER_REGEN_DISABLED` sticky flag (± `UnitAffectingCombat`) ([15](../15-instance-completion-events/)) | **No** |
| Completion / progress | BG winner; optional `ENCOUNTER_END`/`BOSS_KILL` ([15](../15-instance-completion-events/)) | **No** |
| Damage / heal / kill attribution | Out of product scope | **Never for V1** |
| Full combat log dump | Privacy + noise ([39 instrumentation](../39-guild-calendar-events/beef-guild-night-instrumentation.md)) | **Never** |

**Ship stance:** **Avoid CLEU for Beef V1** unless a future change clears the strong-justification bar in [beef-v1-recommendation.md](beef-v1-recommendation.md) (none of those conditions hold today). Do not leave a dormant `RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")` behind a feature flag — that still pays dispatch cost whenever registered.

## Boundary with sibling tracks

| This track (63) | Sibling owns |
|-----------------|--------------|
| CLEU yes/no for *social scoring* | [08](../08-combat-hud-alerts/) — HUD atlas, toast discipline, non-goals |
| CLEU vs `UNIT_DIED` / encounter grants | [15](../15-instance-completion-events/) — reliability matrix |
| Idle/combat CPU budgets | [54](../54-memory-fps-budgets/) |
| Guildmate detection recipes | [59](../59-coplay-guildmate-detection/) |
| Bucket clocks (not CLEU timestamps) | [50](../50-time-timezones-resets/) |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Warcraft Wiki / Wowpedia / Blizzard hotfix posts over bot-forum CLEU snippets.
