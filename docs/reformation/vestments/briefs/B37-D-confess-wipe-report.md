# B37-D — Quiet Hide blanks leftover confess text (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §13.4 / §9 leftover player-typed text. Anniversary `EditBox:SetText(text)`. Brief `docs/reformation/vestments/briefs/B37-D-confess-wipe.md`. `paintHidden` (~80–83) only `frame:Hide()`. `Confess` still reads `confessBox:GetText()`. Only `ResetForTests` blanked the box. Quiet Hide then a new Event `Show` + `Confess()` would send leftover text. Dest persist stays. No Pope lookup. Exclusive files only. No commit. Lane is not signed.

`paintHidden` now blanks `confessBox` with `SetText("")` if the box is present. Dest / `inputTarget` persist. Width / ESC ClearFocus stay. `Hide()` already calls `paintHidden` (no fan-out). Leftover `"leftover line"` is `""` after Quiet Hide. New Event `Show` + `Confess()` without a new arg omits `fields.text`. Isolation wrap stays.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_inputs.lua` | TDD first. Nested `runB37D()` after `runB35B()` inside `runB21D()` / `runB18A()` (no new main-chunk locals). Type leftover text, Quiet Hide, box `GetText()` is `""`. New Event Show + `Confess()` without a new arg omits leftover (nil / empty). Dest stays Host. WIDTH / ESC ClearFocus keep pins. Source pin: `paintHidden` body names `SetText("")` and does not clear `inputTarget`. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Inputs.lua` | `paintHidden` blanks `confessBox` (`SetText("")` if present) then `frame:Hide()`. Dest / `inputTarget` unchanged. `Hide` / `Confess` / dest / ESC unchanged. No Pope lookup. |
| `docs/reformation/vestments/briefs/B37-D-confess-wipe-report.md` | This file |
| `docs/reformation/vestments/briefs/B37-D-confess-wipe.diff` | B37-D-only unified diff of the exclusive files vs the pre-lane working tree |

Did not edit BeefNet, Confession, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Inputs batches (working tree already dirty / untracked). The brief diff is the B37-D-only delta.

## Contract

### Quiet Hide leftover (B37-D)

| Step | Box `GetText()` | Dest | Send |
|------|-----------------|------|------|
| Type `"leftover line"` in Event | `"leftover line"` | `"Host"` | — |
| Quiet Hide (`paintHidden` via Hide) | `""` | `"Host"` | — |
| New Event Show | `""` | `"Host"` | — |
| `Confess()` (no arg) | `""` | `"Host"` | Yes; `fields.text` omitted (or empty) |

`Hide()` still only calls `paintHidden`. Dest / `inputTarget` are not cleared. WIDTH 328 / HEIGHT 72 stay. ESC still `ClearFocus` and does not Hide. No Pope-name lookup. No fan-out.

### Unchanged

- `Confess` still reads `confessBox:GetText()` when no string arg (B35-B trim stays).
- `SetInputTarget` dest trim (B33-A).
- Opponent / player trim pins.
- TitleBar drag persist. Not on `UISpecialFrames`.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `test_inputs.lua` first (nested `runB37D()` after `runB35B()` inside `runB21D()`: leftover `"leftover line"`, Quiet Hide blanks the box, dest stays Host, new Event Show + `Confess()` without arg omits leftover; source pin `SetText("")` inside `paintHidden`; isolation wrap).
2. Red: `lua tests/test_inputs.lua` — **990 passed, 5 failed** (box still `"leftover line"` after Hide and after new Event Show; `Confess()` sent leftover; `paintHidden` lacked `SetText("")`).
3. `paintHidden` blanks `confessBox` with `SetText("")` if present, then `frame:Hide()`. Dest / `inputTarget` unchanged.
4. Green: `lua tests/test_inputs.lua` — **995 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_inputs.lua   # 995 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_inputs.lua` standalone | **995 passed, 0 failed.** Lua 5.1.5. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**995 passed, 0 failed.**

Isolation wrap (unchanged, still under `if standalone then`): **23** nil-module pins — Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Gora, Store, RecordsBook, Decree, DecreeBanner, Popes, Sound, FighterCard, Confession.

## Self-review

- Exclusive implementation files only. BeefNet, Confession, glue, TOC not edited.
- `paintHidden` only. `Hide` / `Confess` / dest / ESC / WIDTH unchanged. No fan-out.
- Dest / `inputTarget` persist across Quiet Hide and the next Event Show.
- `SetText("")` is type-guarded (`box and box.SetText`). Missing box is a no-op.
- No Pope lookup. No `IsRegisteredPope`. No `TargetUnit`. No `PlaySound`.
- HEIGHT 72, TitleBar 12, confess box, ESC ClearFocus stay. Not on `UISpecialFrames`.
- Isolation asserts stay under `if standalone then`. New pins are nested in `runB37D()` after `runB35B()` inside `runB21D()`. No new main-chunk locals.

## Leftovers

- **No client smoke.** Leftover wipe is Event Quiet Hide. Harness proves `SetText("")` + `Confess()` spies. Two-client `/reload` with leftover typed text was not run.
- **`paintHidden` is shared.** Quiet `Init` / `Refresh` / `Show` / `readyToSend` also wipe the box because they already call `paintHidden`. Brief asked for no fan-out; Hide already went through that path.
- **`ResetForTests` still blanks the box.** Duplicate `SetText("")` on the harness hatch. Brief left that hatch alone.
- Full `lua tests/run.lua` was not run.

## Status

**DONE_WITH_CONCERNS.** Isolated **995 / 0**. Isolation wrap **23**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
