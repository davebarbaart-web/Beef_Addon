# B7-A — Store Canonize + Famous Upset flag (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §16, §10.9; Law 4, Law 7; brief `docs/reformation/vestments/briefs/B7-A-store-chronicle.md`.

MARK is live; CANONIZE is cold, Pope-authored text. Software stores the scripture string; it never writes it. Famous Upsets are a Pope flag on the latest matching victory, never computed from levels or records. Snapshot / Restore keep `scripture` and the flagged result. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 416 passed, 0 failed (`lua tests/test_store.lua`). **12** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_store.lua` | TDD first. Replaced `Store.Canonize == nil`. FlagMoment → CanonizeMoment paints trimmed scripture. Newline / empty / unknown refuse. FlagFamousUpset after a victor; latest of two wins; loss / void refuse; notable stays unset. Snapshot / Restore keep scripture and the flagged latest win. Isolation wrap added under `if standalone then`. |
| `addon/ChurchOfBeef/Core/Store.lua` | `Store:CanonizeMoment` and `Store:FlagFamousUpset`. No generated prose. Moments are never deleted. |
| `docs/reformation/vestments/briefs/B7-A-store-chronicle-report.md` | This file |
| `docs/reformation/vestments/briefs/B7-A-store-chronicle.diff` | B7-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Gora.lua, Console, Archive.lua, RecordsBook, TOC, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

```lua
Store:CanonizeMoment(momentId, text)
Store:FlagFamousUpset(characterId, opponentId)
```

### `CanonizeMoment`

- `momentId` is a marked-moment store integer. Unknown / non-id → refuse. Empty / missing / non-string `text` → refuse. Embedded `"\n"` → refuse.
- `text` is trimmed. Sets `scripture` on that row. Returns a copy.
- Does not invent location, narration, canon, or flavor. Does not delete the moment (Law 7).

### `FlagFamousUpset`

- Walk `characterId.gora.results` from the end. Flag the latest row whose `opponentId` matches and `won == true` with `famousUpset = true`.
- No match (loss, void, free, missing pairing) → refuse.
- Does not compute an upset from levels or records. Does not append `notableVictims` or set `notable`.

### Snapshot / Restore

Existing deepcopy keeps `markedMoments[].scripture` and `gora.results[].famousUpset`. No Restore schema change.

`Store.Canonize` stays nil. The Phase 2 pin is replaced by `type(Store.CanonizeMoment) == "function"`.

## TDD

1. Extended `tests/test_store.lua` first (API pins, scripture paint / refuse, Famous Upset latest-win / loss / void, snapshot keep, isolation wrap).
2. Red: `lua tests/test_store.lua` — `CanonizeMoment` / `FlagFamousUpset` nil.
3. Implemented the two Store verbs.
4. Green: `lua tests/test_store.lua` — **416 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_store.lua   # 416 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_store.lua` standalone | **416 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 12 pins under `if standalone then` at file load (Gora, UI, Net, DB, Console, Archive, RecordsBook, Officer, Recognition, Popes, Sender, Runtime).

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run. Gora.lua was not edited; its “Famous Upsets are not computed” pin is unchanged.

## Self-review

- Exclusive implementation files only. Getters still return copies. Expected failures are `nil, err`.
- `FlagMoment` still writes `{ id, at, location? }` only. Scripture appears only after `CanonizeMoment`.
- `FlagFamousUpset` matches `opponentId` + `won == true`. It does not read `level`, wins, or streak.
- `notableVictims` is untouched unless a prior `RecordGoraResult(..., notable = true)` already set it.
- Source has no scripture generator, `on this day`, `ordained`, `SweepDeparted`, `Prune`, or `Delete*`.
- Isolation asserts stay under `if standalone then`.

## Isolated count

**416 passed, 0 failed.** Isolation wrap: **12**.

## Concerns

- **Isolation wrap is new.** The suite previously isolated by load list only (Common + Ranks + Store) plus the standalone runner. This lane added 12 `if standalone then` nil-module pins so the vestment wrap exists and stays gated.
- **Recanonize overwrites.** A second `CanonizeMoment` on the same id replaces `scripture`. The brief said set, not refuse-if-present. The moment row is never deleted.
- **Sequential flags can leave more than one row flagged.** One call after two wins flags only the latest. If the Pope flags after the first win and again after the rematch, both rows stay `famousUpset == true`. The verb does not unflag earlier rows.
- **Non-string scripture uses `scripture text required`.** Same string as empty / missing. Newline is `invalid text`. Callers that want `text must be text` will not see that exact wording.
- **Opponent existence is not a separate check.** A non-id opponent is refused as `opponent must be a character id`. An unused integer with no matching win is `no matching victory`.
- **No client smoke / full harness.** Memory-only Core. B7-B / B7-C own Console and Records Book paint.

## Status

**DONE_WITH_CONCERNS.** Isolated **416 / 0**. Isolation wrap **12**. Not signed.
