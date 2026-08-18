# B20-A — Confession inbox click + called token (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §9 (queue + call the next participant); §13.4 (text stays on the Pope desk); §18.1; brief `docs/reformation/vestments/briefs/B20-A-confession-click.md`. Core already stores `called`. The desk now paints via `paintRowButtons` on `ConfessionChild`; click `SelectCharacter` then Refresh. `confessionLine` appends mute `"  called"` when `row.called == true`. No "DEMANDED" / "CALLED FORWARD" / oratory. No new Dismiss plate (`Console:Dismiss` stays Gora). No fan-out. No Sound / Toasts / SendChatMessage on CallForward. `SaveNote` stays nil. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 1514 passed, 0 failed (`lua tests/test_console.lua`). Isolation wrap stays under `if standalone then` at file load (**17** nil pins). Nested `runB20A()` inside `runB8E()` after `runB19A()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB20A()` inside `runB8E()` after `runB19A()` (Lua 5.1 200-local cap; no new main-chunk locals). Init seeds `ConfessionRows`. Empty stays `"No confessions."` on the shown FontString. Stub queue with one row: row button exists; click sets `selectedCharacterId`. After CallForward + Refresh, painted line contains `"  called"`. One Dismiss plate. No Sound / Toasts / chat on click or CallForward. Source pins: `ConfessionRows = {}`, `onConfessionClick`, `row.called == true`, `line = line .. "  called"`. No CALLED FORWARD / DEMANDED / SaveNote / SUMMON / parchment / tabs. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Console.lua` | `ConfessionRows = {}` on build. `onConfessionClick` `SelectCharacter(row.characterId)` then Refresh. `paintConfessions` mirrors Presence / Petition / Knighting: hide `ConfessionList` and `paintRowButtons` on `ConfessionChild` when `#rows > 0`; empty shows `"No confessions."`. `confessionLine` appends mute `"  called"` when `row.called == true`. No new Dismiss. CallForward path unchanged (Pope gate, Refresh on ok, no sound). |
| `docs/reformation/vestments/briefs/B20-A-confession-click-report.md` | This file |
| `docs/reformation/vestments/briefs/B20-A-confession-click.diff` | B20-A-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Confession.lua, Gora, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not invent "DEMANDED" or "CALLED FORWARD". Did not define `SaveNote`. Did not add a second Dismiss. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Console batches (working tree already dirty). The brief diff is the B20-A-only delta.

## Contract

| Surface | Role |
|---------|------|
| `confessionLine` | Name + text. Appends `"  called"` only when `row.called == true`. Same mechanical token style as `"  needs Knighting"`. |
| `paintConfessions` | FontString `SetText` via `confessionLine`. Empty: show list, `"No confessions."`. Rows: hide list, `paintRowButtons` on `ConfessionChild`. |
| `onConfessionClick` | `SelectCharacter(row.characterId)` then Refresh. |
| `CallForward` | Unchanged. Pope gate. Marks Core. Refresh on ok. No Sound / Toasts / chat. |
| `Dismiss` | Stays Gora. One plate. |
| `SaveNote` | Stays nil. |

### Unchanged

- Stock desk. No parchment. No tabs. No SUMMON.
- Isolation wrap. No new main-chunk locals in `test_console.lua`.
- Existing CallForward pins (Pope refuse, no sound, no chat).
- No confession fan-out.

## TDD

1. Extended `tests/test_console.lua` first (`runB20A()` nested in `runB8E()` after `runB19A()`: ConfessionRows on build; empty `"No confessions."`; stub queue row button; click `selectedCharacterId`; CallForward paints `"  called"`; one Dismiss; no fan-out; source / SaveNote / isolation). Isolation wrap untouched except the new nested pin block.
2. Red: `lua tests/test_console.lua` — **1497 passed, 17 failed** (no ConfessionRows, no row button, click did not select, no `"  called"` after CallForward, source pins missing). Empty copy, Dismiss count, and negative source pins already green.
3. `confessionLine` / `onConfessionClick` / `paintConfessions` / `ConfessionRows = {}` landed. CallForward and Dismiss untouched.
4. Green: `lua tests/test_console.lua` — **1514 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 1514 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | **1514 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 1514 passed, 0 failed. Isolation wrap stays (17 nil pins at file load). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Confession.lua / Gora / glue / TOC not edited.
- Confession rows click `SelectCharacter`. Mute `"  called"` when `called == true`.
- No new Dismiss. No fan-out. No Sound on CallForward. `SaveNote` nil.
- `runB20A()` is nested inside `runB8E()` after `runB19A()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **No client smoke.** Live confession-row click vs `SelectCharacter` vs Refresh `"> "` prefix is unproven on Anniversary. Harness `OnClick` is a stub fire.
- **Confession is stubbed.** This suite does not load `Confession.lua`. `called` is marked on the stub queue; the real Core store is unproven here.
- **`ConfessionList` is Hidden when rows exist.** `SetText` still runs via `confessionLine` before Hide. Visible paint is the row button.
- **`GetConfessions` is data, not the painted string.** The `"  called"` token lives on the row button / FontString. Rows keep `called`.
- **CallForward still needs the Pope gate.** Click only selects. The Call Forward furniture marks Core.

## Status

**DONE_WITH_CONCERNS.** Not signed. No Gate / **POLISH:PASS** claim.
