# Annotated sources — instance completion & encounter events

**Track:** [15-instance-completion-events](README.md)  
**Last updated:** 2026-07-25  
**Rule:** Only URLs that informed this track’s claims. Steal/adapt notes are Beef-specific.

Provenance JSON under [`.raw/`](.raw/).

---

## Primary API / event docs

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| `PLAYER_ENTERING_WORLD` | https://warcraft.wiki.gg/wiki/PLAYER_ENTERING_WORLD | Loading-screen zoning; `isInitialLogin` / `isReloadingUi` | Re-evaluate instance session on every PEW; never treat PEW alone as completion |
| `IsInInstance` | https://warcraft.wiki.gg/wiki/API_IsInInstance | `party` / `raid` / `pvp` / `arena` / `scenario`; correct on PEW; Classic patch tag **1.11.0 / 1.13.2** | Primary gate for §7 instance types |
| `GetInstanceInfo` | https://warcraft.wiki.gg/wiki/API_GetInstanceInfo | name, instanceType, difficulty, maxPlayers, instanceID | Label standing events; allowlist key for optional final-boss complete |
| `BOSS_KILL` | https://warcraft.wiki.gg/wiki/BOSS_KILL | Payload; open-world **or** instance bosses; added **6.1.0 / 1.13.2** | Corroborate kills inside instances only; ignore outdoors |
| `ENCOUNTER_START` | https://warcraft.wiki.gg/wiki/ENCOUNTER_START | Start payload (id, name, difficulty, groupSize) | Optional “in pull” context — not a point grant |
| `ENCOUNTER_END` (Wowpedia) | https://wowpedia.fandom.com/wiki/ENCOUNTER_END | End payload + **`success` 1/0**; EJ id mismatch; added **5.4.7** | Prefer `success` + `encounterID`; never name-match |
| `ENCOUNTER_END` (wiki.gg) | https://warcraft.wiki.gg/wiki/ENCOUNTER_END | Same event on current wiki | Cross-check if wiki.gg extract flakes |
| `PLAYER_REGEN_DISABLED` | https://warcraft.wiki.gg/wiki/PLAYER_REGEN_DISABLED | Enter combat / hate list / PvP action | Sticky anti-AFK flag for buckets |
| `GetBattlefieldWinner` | https://warcraft.wiki.gg/wiki/API_GetBattlefieldWinner | `nil` / `0` Horde / `1` Alliance / `255` draw | Best Classic “completion” signal for BGs |
| `RequestRaidInfo` | https://wowpedia.fandom.com/wiki/API_RequestRaidInfo | Async lockout query → `UPDATE_INSTANCE_INFO` | Debug / enrichment only |
| `UPDATE_INSTANCE_INFO` | https://wowpedia.fandom.com/wiki/UPDATE_INSTANCE_INFO | Lockout data ready | Pair with GetSavedInstanceInfo |
| `GetSavedInstanceInfo` | https://wowpedia.fandom.com/wiki/API_GetSavedInstanceInfo | Lockout fields; added **1.11.0**; encounterProgress etc. | “Saved to X” display — not finish toast |
| `ResetInstances` | https://warcraft.wiki.gg/wiki/API_ResetInstances | Player resets instance lockouts | Anti-farm awareness; never a grant |
| `ZONE_CHANGED_NEW_AREA` | https://wowpedia.fandom.com/wiki/ZONE_CHANGED_NEW_AREA | New zone / channel set | **Do not** use as instance enter detector |
| Events index | https://warcraft.wiki.gg/wiki/Events | `/etrace`, RegisterEvent tutorial | Playtest tooling for Anniversary checklist |
| `INSTANCE_ENCOUNTER_ENGAGE_UNIT` | https://wowpedia.fandom.com/wiki/INSTANCE_ENCOUNTER_ENGAGE_UNIT | Engage unit event exists | Skip for V1 scoring |

---

## Classic reliability / bug reports

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| ENCOUNTER_END locale payload bug (Classic, 2020) | https://us.forums.blizzard.com/en/wow/t/encounterend-payload-issue/439290 | zhCN `encounterName` = `"*"`; ruRU suspected; enUS/enGB OK | Key only on `encounterID` + `success` |
| ZONE_CHANGED unreliable for instances | https://wowinterface.com/forums/showthread.php?t=19130 | ZONE_* miss instance zoning; keep PEW registered | Matches plan Task 11 PEW approach |
| Events/P archive (PEW / map coords) | https://wowwiki-archive.fandom.com/wiki/Events/P | Mid-transition map coords `0,0` | Prefer `IsInInstance` over map hacks |
| Vanilla `IsInInstance` archive | https://vanilla-wow-archive.fandom.com/wiki/API_IsInInstance | Historical signature continuity | Confidence that instance typing is ancient/stable |

---

## Ecosystem context (secondary)

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| SavedInstances (GitHub) | https://github.com/SavedInstances/SavedInstances | How real addons consume lockouts | Pattern: RequestRaidInfo + saved info — **display**, not Beef auto-promote |
| SavedInstances (CurseForge) | https://www.curseforge.com/wow/addons/saved_instances | Product framing: lockouts across alts | Beef is not a lockout tracker; don’t scope-creep |
| BigWigs (CurseForge) | https://www.curseforge.com/wow/addons/big-wigs | Encounter addon exists for Classic TBC flavor | Beef must not become a boss mod; no CLEU dependency |
| BigWigs_Classic pack | https://www.curseforge.com/wow/addons/bigwigs_classic | Classic/TBC content packs ship | Confirms encounter scripting culture on Classic clients |
| Reddit: detect dungeon boss engage | https://www.reddit.com/r/wowaddons/comments/7xefah/whats_the_best_way_to_detect_when_the_player/ | Community tradeoffs (IEEU vs combat vs ID tables) | Reinforces: no single clean API |

---

## Internal repo anchors

| Source | Path | Use for |
|--------|------|---------|
| Design spec §7 / §16.4 | [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Completion bonus + flaky-detection fallback |
| Plan Task 11 | [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) | `Core/Instance.lua` intended hooks |
| Implications §7 / next research #1 | [`docs/research/wow-classic-addon-design/00-church-of-beef-implications.md`](../00-church-of-beef-implications.md) | This track answers that open research item |

---

## Deliberately not relied on

- Listicle “top Classic addons” pages — irrelevant to event payloads.
- Retail Midnight messaging restriction writeups — messaging, not detection (see track 00).
- Combat-log boss timers / DBM internals — out of scope for a social ladder tool.
