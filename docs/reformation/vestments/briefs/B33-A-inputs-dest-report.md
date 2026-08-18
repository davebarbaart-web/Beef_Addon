# B33-A — SetInputTarget trims the whisper dest (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** License 2 / §13.1 (favor / petition / confess / catchup whisper to the injected dest). Brief `docs/reformation/vestments/briefs/B33-A-inputs-dest.md`. B23-D leftover: `SetInputTarget` stored any non-empty string, including `" "`, so `Names.Same("Host", " ")` was false and dest-same omit failed. `Names.Trim` already exists (`Common.lua`). Opponent / player trim stay. `readyToSend` / Petition / Catchup / Confess keep. No Pope-name lookup. No auto snapshot. No realm compare invent. Exclusive files only. No commit. Lane is not signed.

`SetInputTarget` now calls `Names.Trim(name)` when that function exists, else `^%s+` / `%s+$`. Empty after trim is nil (no target). `GetView().target` after `SetInputTarget("  Host  ")` is `"Host"`; Petition / Catchup / Confess whisper `"Host"`. `SetInputTarget("   ")` and `SetInputTarget(" ")` are no target; the three verbs return `"no target"` and do not send. Existing opponent / player trim pins stay. Isolation wrap stays. Dress stays stock. HEIGHT 72 stays.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_inputs.lua` | TDD first. Nested `runB33A()` after `runB23D()` inside `runB21D()` / `runB18A()` (no new main-chunk locals). `SetInputTarget("  Host  ")` stores `"Host"` and the three verbs whisper `"Host"`. `SetInputTarget("   ")` / `" "` are no target; Petition / Catchup / Confess return `"no target"` and do not send. Opponent / player trim keep pins (whitespace omit, padded Chuckroast, dest-same, player-same, empty / whitespace player). Source pin: `SetInputTarget` body names `Names.Trim` plus fallback `gsub`. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Inputs.lua` | `SetInputTarget` trims via `Names.Trim` with fallback `^%s+` / `%s+$`. Empty after trim is nil. `readyToSend` / Petition / Catchup / Confess unchanged. Opponent / player `gsub` trim unchanged. No Pope lookup. |
| `docs/reformation/vestments/briefs/B33-A-inputs-dest-report.md` | This file |
| `docs/reformation/vestments/briefs/B33-A-inputs-dest.diff` | B33-A-only unified diff of the exclusive files vs the pre-lane working tree |

Did not edit BeefNet, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Inputs batches (working tree already dirty / untracked). The brief diff is the B33-A-only delta.

## Contract

### Whisper dest (B33-A)

| `SetInputTarget` | Stored dest |
|------------------|--------------|
| `"  Host  "` | `"Host"` |
| `"Host"` | `"Host"` (unchanged) |
| `"   "` / `" "` / `""` / nil / non-string | nil (no target) |

| Verb | Whitespace dest | Trimmed `"Host"` |
|------|-----------------|------------------|
| Petition | `false, "no target"`. No send. | Whisper `"Host"`. Opponent trim stays. |
| Catchup | `false, "no target"`. No send. | Whisper `"Host"`. |
| Confess | `false, "no target"`. No send. | Whisper `"Host"`. |
| Quiet | Unchanged. Hidden. Verbs false. No send. |

`readyToSend` still refuses `type(inputTarget) ~= "string" or inputTarget == ""`. Catchup still has its own empty-dest check. No Pope-name lookup. No auto snapshot. No realm compare.

### Opponent / player trim (intact)

| UnitName | Field |
|----------|-------|
| target `"   "` | opponent omitted |
| target `"  Chuckroast  "` | opponent `"Chuckroast"` |
| target `"  Host  "` (dest `"Host"`) | dest-same omit |
| target `"  Beefina  "` (player `"Beefina"`) | player-same omit |
| player `""` / `"   "` | opponent omitted; dest stays |

## TDD

1. Extended `test_inputs.lua` first (source pin `Names.Trim` plus fallback `gsub` inside `SetInputTarget`; nested `runB33A()` after `runB23D()` inside `runB21D()`: padded Host stores / whispers `"Host"`; whitespace dest is no target and does not send; opponent / player trim pins kept; isolation wrap).
2. Red: `lua tests/test_inputs.lua` — **820 passed, 28 failed** (padded dest stored `"  Host  "`; whitespace dest still sent; `Names.Trim` missing from `SetInputTarget`).
3. `SetInputTarget` trims via `Names.Trim` with fallback `^%s+` / `%s+$`. Empty after trim is nil. `readyToSend` / Petition / Catchup / Confess / opponent trim unchanged.
4. Green: `lua tests/test_inputs.lua` — **848 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_inputs.lua   # 848 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_inputs.lua` standalone | **848 passed, 0 failed.** Lua 5.1.5. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**848 passed, 0 failed.**

Isolation wrap (unchanged, still under `if standalone then`): **23** nil-module pins — Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Gora, Store, RecordsBook, Decree, DecreeBanner, Popes, Sound, FighterCard, Confession.

## Self-review

- Exclusive implementation files only. BeefNet, glue, TOC not edited.
- `readyToSend` / Petition / Catchup / Confess refuse and send paths unchanged except they now see a trimmed dest.
- Opponent `targetName` / `playerName` `gsub` trim unchanged.
- No Pope lookup. No `IsRegisteredPope`. No `TargetUnit`. No `PlaySound`.
- Fallback `gsub` lives in `SetInputTarget` when `Names.Trim` is missing. The isolated suite loads Common, so the fallback is source-pinned, not behaviorally pinned.
- HEIGHT 72, TitleBar 12, confess box, ESC ClearFocus stay. Not on `UISpecialFrames`.
- Isolation asserts stay under `if standalone then`. New pins are nested in `runB33A()` after `runB23D()` inside `runB21D()`. No new main-chunk locals.

## Leftovers

- **No client smoke.** Dest trim is Event Mode whisper. Harness proves `SetInputTarget` + Petition / Catchup / Confess spies. Two-client `/reload` with a padded injected dest was not run.
- **Glue still injects dest.** This lane does not look up a Pope name. Whoever calls `SetInputTarget` (glue / later lane) still owns the name. B33-D BeefNet dest refuse is a sibling exclusive.
- **Fallback path is source-only.** Isolated suite always loads `Common.lua`, so `Names.Trim` is present. Missing-Trim `gsub` is pinned in the `SetInputTarget` body, not exercised at runtime.
- Full `lua tests/run.lua` was not run.

## Status

**DONE_WITH_CONCERNS.** Isolated **848 / 0**. Isolation wrap **23**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
