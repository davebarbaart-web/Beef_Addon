# B35-B — Confess trims optional text (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §13.4 / §9 (confession text is optional player-typed free text for the Pope console). Brief `docs/reformation/vestments/briefs/B35-B-confess-trim.md`. B33-A leftover: `SetInputTarget` already `Names.Trim`s dest; `Confess` (~302–318) assigned `fields.text` raw, so `"  forgive me  "` went on the whisper. Text is optional — empty after trim omits `fields.text` and still sends. Dest / `readyToSend` stay. Opponent trim stays. No Pope-name lookup. No fan-out. Exclusive files only. No commit. Lane is not signed.

`Confess` now calls `Names.Trim(text)` when that function exists, else `^%s+` / `%s+$` (same fallback as `SetInputTarget`). Empty after trim is nil and `fields.text` is omitted; dest and `readyToSend` still decide whether the whisper goes. `Confess("  forgive me  ")` spies `"forgive me"`. `Confess("   ")` and box-only whitespace omit `fields.text` and still send when dest is set. Existing dest / opponent pins stay. Isolation wrap stays. Dress stays stock. HEIGHT 72 stays.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_inputs.lua` | TDD first. Nested `runB35B()` after `runB33A()` inside `runB21D()` / `runB18A()` (no new main-chunk locals). `Confess("  forgive me  ")` spies `"forgive me"`. `Confess("   ")` / box-only whitespace omit `fields.text` and still send. Dest / opponent keep pins (padded dest Host, whitespace dest refuse, opponent omit / padded Chuckroast / dest-same, whitespace player). Source pin: `Confess` body names `Names.Trim` plus fallback `gsub`. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Inputs.lua` | `Confess` trims via `Names.Trim` with fallback `^%s+` / `%s+$`. Empty after trim omits `fields.text` and still sends. `readyToSend` / dest / opponent trim unchanged. No Pope lookup. |
| `docs/reformation/vestments/briefs/B35-B-confess-trim-report.md` | This file |
| `docs/reformation/vestments/briefs/B35-B-confess-trim.diff` | B35-B-only unified diff of the exclusive files vs the pre-lane working tree |

Did not edit BeefNet, Confession, Codec, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Inputs batches (working tree already dirty / untracked). The brief diff is the B35-B-only delta.

## Contract

### Confess text (B35-B)

| `Confess` | `fields.text` | Send |
|-----------|---------------|------|
| `"  forgive me  "` | `"forgive me"` | Yes (dest set) |
| `"forgive me"` | `"forgive me"` | Yes (dest set) |
| `"   "` | omitted | Yes (dest set) |
| box `"   "` / `Confess()` | omitted | Yes (dest set) |
| box `"  typed in the box  "` / `Confess()` | `"typed in the box"` | Yes (dest set) |
| any text, dest `"   "` | — | No (`false, "no target"`) |
| Quiet | — | No |

`readyToSend` still refuses missing dest / character / Quiet. Catchup still has its own empty-dest check. No Pope-name lookup. No auto snapshot. No fan-out.

### Dest / opponent (intact)

| Pin | Stays |
|-----|-------|
| `SetInputTarget("  Host  ")` | dest `"Host"` |
| `SetInputTarget("   ")` | no target; Confess refuses |
| target `"   "` | opponent omitted |
| target `"  Chuckroast  "` | opponent `"Chuckroast"` |
| target `"  Host  "` (dest `"Host"`) | dest-same omit |
| player `"   "` | opponent omitted; dest stays |

## TDD

1. Extended `test_inputs.lua` first (source pin `Names.Trim` plus fallback `gsub` inside `Confess`; nested `runB35B()` after `runB33A()` inside `runB21D()`: padded text spies `"forgive me"`; whitespace / box-only whitespace omit `fields.text` and still send; dest / opponent keep pins; isolation wrap).
2. Red: `lua tests/test_inputs.lua` — **930 passed, 7 failed** (padded text stayed `"  forgive me  "`; whitespace text still set `fields.text`; `Names.Trim` missing from `Confess` body).
3. `Confess` trims via `Names.Trim` with fallback `^%s+` / `%s+$`. Empty after trim omits `fields.text`. `readyToSend` / dest / opponent trim unchanged.
4. Green: `lua tests/test_inputs.lua` — **937 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_inputs.lua   # 937 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_inputs.lua` standalone | **937 passed, 0 failed.** Lua 5.1.5. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**937 passed, 0 failed.**

Isolation wrap (unchanged, still under `if standalone then`): **23** nil-module pins — Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Gora, Store, RecordsBook, Decree, DecreeBanner, Popes, Sound, FighterCard, Confession.

## Self-review

- Exclusive implementation files only. BeefNet, Confession, Codec, glue, TOC not edited.
- `readyToSend` / dest / opponent `gsub` refuse and send paths unchanged. Text trim does not refuse.
- No Pope lookup. No `IsRegisteredPope`. No `TargetUnit`. No `PlaySound`. No fan-out.
- Fallback `gsub` lives in `Confess` when `Names.Trim` is missing. The isolated suite loads Common, so the fallback is source-pinned, not behaviorally pinned.
- HEIGHT 72, TitleBar 12, confess box, ESC ClearFocus stay. Not on `UISpecialFrames`.
- Isolation asserts stay under `if standalone then`. New pins are nested in `runB35B()` after `runB33A()` inside `runB21D()`. No new main-chunk locals.

## Leftovers

- **No client smoke.** Text trim is Event Mode whisper. Harness proves `Confess` + SendConfession spies. Two-client `/reload` with padded or whitespace confession text was not run.
- **Fallback path is source-only.** Isolated suite always loads `Common.lua`, so `Names.Trim` is present. Missing-Trim `gsub` is pinned in the `Confess` body, not exercised at runtime.
- **Trim block is copied.** `SetInputTarget` and `Confess` each own a `Names.Trim` / fallback pair. Brief asked for the same pattern; no shared helper was extracted.
- Full `lua tests/run.lua` was not run.

## Status

**DONE_WITH_CONCERNS.** Isolated **937 / 0**. Isolation wrap **23**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
