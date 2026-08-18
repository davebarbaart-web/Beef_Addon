# B5-B — Candidate / fighter raid marks (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §8, Appendix A items 5–6; Law 5, Law 6; brief `docs/reformation/vestments/briefs/B5-B-markers.md`.

Event Mode target + raid marks on the Pope's client. `TargetUnit` / `SetRaidTarget` / `GetRaidTargetIndex` are `type()`-guarded and pcalled. Quiet refuses every verb. Unlisted Pope → `false, "not a registered pope"`. Ungrouped Mark* / Clear → `false, "not in a group"`. Missing APIs fail-closed (false, no throw). No Sound, Toasts, Net, GuildPromote, or combat automation. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 251 passed, 0 failed (`lua tests/test_markers.lua`). **27** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_markers.lua` | Isolated suite. wow_ui_stub + Common + Runtime + Markers. Stub SetRaidTarget / TargetUnit / Sender / UnitName. Quiet refuse; unlisted Pope; ungrouped; StartEvent + Pope + raid → MarkCandidate spies `SetRaidTarget("raid2", 1)`; MarkFighters 2/3; Clear 0; missing API fail-closed; GetView copy; ResetForTests. Isolation under `if standalone then`. |
| `addon/ChurchOfBeef/UI/Markers.lua` | `COB.Markers`. Target / MarkCandidate / MarkFighters / Clear / GetView / ResetForTests. `MODE = "Event"`. |
| `docs/reformation/vestments/briefs/B5-B-markers-report.md` | This file |
| `docs/reformation/vestments/briefs/B5-B-markers.diff` | B5-B-only unified diff of the exclusive implementation files |

Did not edit TOC, `tests/run.lua`, Knighting, Gora, Console, bootstrap, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

```lua
Markers:Target(name)                 -- pcall TargetUnit(name, true)
Markers:MarkCandidate(name)          -- raid mark index 1 (star) on a matching raid/party unit
Markers:MarkFighters(nameA, nameB)   -- indices 2 and 3
Markers:Clear(name)                  -- SetRaidTarget(unit, 0)
Markers:GetView()                    -- copy of last attempt
Markers:ResetForTests()
```

- `MODE = "Event"`. Runtime `QUIET` or missing → every verb returns `false, "quiet"` (Law 6).
- Pope-gated: `Sender:IsRegisteredPope(local)` must be exactly `true`. Local name is `Group.PlayerName` → `UnitName("player")`. Missing Sender / name / a non-`true` return → `false, "not a registered pope"`.
- Mark* / Clear require a group API (`IsInRaid` / `IsInGroup` / `GetNumGroupMembers` > 0). Else `false, "not in a group"`.
- Unit tokens are scanned `raid1..N` or `party1..N` via `GetNumGroupMembers`. Names match through `Names.Same`. No invented tokens. Unresolved → `false, "unit not found"`.
- `Target` is name-based desk assist. It does not require a group.
- Missing `TargetUnit` / `SetRaidTarget` / group APIs → `false`, no throw. Missing `GetRaidTargetIndex` still marks.

`GetView()` is a copy of the last attempt: `{ mode, verb, ok, err, name, unit, index, nameA, nameB, unitA, unitB, indexA, indexB }`. `ResetForTests` no-ops unless `COB._IN_TEST`.

## TDD

1. Wrote `tests/test_markers.lua` first (API, isolation, source greps, Quiet refuse, Pope gate, grouped spy, missing API, GetView copy).
2. Implemented `Markers.lua`.
3. Green: `lua tests/test_markers.lua` — **251 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_markers.lua   # 251 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_markers.lua` standalone | 251 passed, 0 failed. Lua 5.1.5. Exit 0. |

**Isolated count:** 27 pins under `if standalone then` (Quiet shell, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Core Decree, slash).

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive files only. Isolation asserts stay under `if standalone then`.
- Anniversary catalog has `TargetUnit`, `SetRaidTarget`, `GetRaidTargetIndex`. `GetNumGroupMembers` / `IsInRaid` / `IsInGroup` are absent from the catalog; they are `type() == "function"` guarded the same way as `Core/Common.lua` Group.
- Source has no `CreateFrame`, `PlaySound`, `Toasts`, `COB.Net`, `SendChatMessage`, `GuildPromote`, `StartAttack`, `AttackTarget`, `AssistUnit`, `CastSpell`, or custom Media.
- `SetRaidTarget` is only called with scanned `raidN` / `partyN` tokens, never a character name.
- `GetView` is a copy. `ResetForTests` is harness-gated.

## Concerns

- **Integrator glue is still required.** TOC and `tests/run.lua` were not edited. Console / Knighting do not call this module.
- **`#8` stays fail-closed** on a live client until `Sender:IsRegisteredPope(local)` is true.
- **Party scan cannot mark the local player.** `party1..N` excludes the player; `raid1..N` includes them. Brief forbids inventing a `player` token.
- **`SetRaidTarget` still needs raid leader/assist** (Appendix A item 5). A Pope who is not assist gets a silent fail-closed `false`; Target remains the fallback.
- **`TargetUnit` may be protected in combat** (Appendix A item 6). The pcall swallows the error; this lane does not mint a secure button.
- **MarkFighters is resolve-atomic, not apply-atomic.** Both units must resolve before either mark; if the second `SetRaidTarget` throws, the first mark may remain.
- Client `/reload` was not run. No Quiet chrome to smoke.

## Status

**DONE_WITH_CONCERNS.** Not signed.
