# B8-A — Store derived CountDefenses (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** OPEN_QUESTIONS #9; Bible §10.4, §10.6, §10.7, §10.9; Law 7; brief `docs/reformation/vestments/briefs/B8-A-defenses.md`.

`Store:CountDefenses` is a derived read: victories (`won == true`) on that character at or after the linked human's `elevationAt`. Not a stored counter. Not a title-defense system. Snapshot / Restore unchanged; `gora.defenses` stays stripped. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 450 passed, 0 failed (`lua tests/test_store.lua`). **12** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_store.lua` | TDD first. Nested `runCountDefenses` (Lua 5.1 200-local cap). Lord + two post-elevation wins → 2. Pre-elevation win, void, free, and `won == false` not counted. Cowardice on the Lord (`won == true`) counted. Unlinked / unknown / name / nil → 0. Leaving Lord keeps the derive. Existing `gora.defenses == nil` pins kept. Isolation wrap unchanged. |
| `addon/ChurchOfBeef/Core/Store.lua` | `Store:CountDefenses`. Walk `gora.results`. Never writes `gora.defenses` or `defenseCount`. |
| `docs/reformation/vestments/briefs/B8-A-defenses-report.md` | This file |
| `docs/reformation/vestments/briefs/B8-A-defenses.diff` | B8-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Gora.lua, RecordsBook, HUD, FighterCard, TOC, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

```lua
n = Store:CountDefenses(characterId)
```

- Unknown / invalid id → `0` (cheap UI paint; not `nil, err`).
- No linked human, or human has no numeric `elevationAt` → `0`.
- Walk that character's `gora.results`. Count a row when `result.at >= elevationAt` and `result.won == true`.
- Void and free are excluded (`won` is nil on live writes; ruling is also refused).
- Do not require current `rankId == 4`. Leaving Lord does not delete `elevationAt` (Law 7).
- Do not invent notable / famousUpset coupling.
- Snapshot / Restore unchanged. `gora.defenses` / `gora.defenseCount` stay stripped on write.

## TDD

1. Extended `tests/test_store.lua` first (API pin, two post-elevation wins, pre-elevation / void / free / loss refuse, cowardice count, unlinked / invalid → 0, leave-Lord keep, existing nil pins, isolation wrap stays).
2. Implemented `Store:CountDefenses`.
3. Green: `lua tests/test_store.lua` — **450 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_store.lua   # 450 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_store.lua` standalone | **450 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 12 pins under `if standalone then` at file load (Gora, UI, Net, DB, Console, Archive, RecordsBook, Officer, Recognition, Popes, Sender, Runtime). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run. Gora.lua, RecordsBook, HUD, and FighterCard were not edited.

## Self-review

- Exclusive implementation files only. CountDefenses returns a number; it does not expose live tables.
- `RecordGoraResult` / `ensureCharacter` still nil `gora.defenses` and `gora.defenseCount`. CountDefenses never assigns those fields.
- Existing `gora.defenses == nil` pins remain (create, copy-mutate, victory, cowardice-as-loss, void, Snapshot).
- Isolation asserts stay under `if standalone then`.
- Source does not increment a defense field, couple to `notable` / `famousUpset`, or require sitting Lord.

## Isolated count

**450 passed, 0 failed.** Isolation wrap: **12**.

## Concerns

- **`>=` vs “after.”** The brief walks `result.at >= elevationAt`. OPEN_QUESTIONS #9 says “fought after their elevation.” A bout stamped at the same wall time as `elevationAt` counts. No same-timestamp pin; the two counted wins sit later (8200 / 8210 vs 8100).
- **Void / free ruling guard is extra.** Live writes already leave `won == nil` on void and free. The method also skips `ruling == "void"` / `"free"` so a crafted Restore with `won == true` on those rulings would not count. That crafted case is unpinned.
- **Unknown id is `0`, not `nil, err`.** Brief preferred this so UI paint is cheap. Callers cannot tell unknown from “no defenses.”
- **Nested test function.** New pins live in `runCountDefenses()` because the suite already has ~124 file-scope locals (Lua 5.1 200-local cap). Isolation wrap was not moved.
- **No client smoke / full harness.** Memory-only Core. B8-B / B8-C / B8-D own Records Book, Fighter Card, and HUD paint.

## Status

**DONE_WITH_CONCERNS.** Isolated **450 / 0**. Isolation wrap **12**. Not signed.
