# B27-B — Decree Hide blanks leftover paint when the line is gone (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Law 6 / §19.4 (Quiet silent); Law 10 / Bible §19.3 / §14.1 (theatrical parchment; header copy / QuestBG stay); B26 leftover (wipe is on empty `Show` only; `Decree:Clear()` then `DecreeBanner:Hide()` still leaves Goldshire on the FontStrings); brief `docs/reformation/vestments/briefs/B27-B-decree-hide.md`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Anniversary `FontString:SetText` accepts `""`. No deputy. No custom media. No sound. Exclusive files only. No commit. Lane is not signed.

`Hide()` now: if `getDecree()` is nil and a frame exists, `wipePaint(self.frame)` then Hide. If a Decree is still active, just Hide (next Show paints). Does not invent a line. Does not Show. B26-C empty Show wipe stays. Quiet stays silent.

**Isolated count:** 328 passed, 0 failed (`lua tests/test_decree_ui.lua`). **18** isolation pins under the first `if standalone then`. Nested `runB27B()` inside `runB25B()` after `runB26C()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_decree_ui.lua` | TDD first. Source pin: Hide body checks `getDecree()`, `wipePaint(self.frame)` (or `wipePaint(frame)` / `LineText:SetText("")`), then Hide; no `paint(` / `:Show()` / `PlaySound` / invented Goldshire. Nested `runB27B()` inside `runB25B()` after `runB26C()`: Set Goldshire + flavor, Show, `Decree:Clear()`, `Hide()` (not Show) is true, `IsShown` false, `LineText` / `FlavorText` are `""`, flavor hidden, no sound. Hide while a Decree is still set just Hides; next Show paints Goldshire. B26-C uniqueness / empty-Show wipe stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Decree.lua` | `Hide()`: if a frame exists and `getDecree()` is nil, `wipePaint(self.frame)` then Hide. If a Decree is still active, just Hide. Does not Show. Does not invent a line. No `PlaySound`. B26-C empty Show wipe / `wipePaint` / `LINE_FONT` unchanged. |
| `docs/reformation/vestments/briefs/B27-B-decree-hide-report.md` | This file |
| `docs/reformation/vestments/briefs/B27-B-decree-hide.diff` | B27-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Toasts, Records, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add deputy. Did not add sound. Did not add custom media. Did not change `LINE_FONT`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Decree vestment batches (working tree already dirty). The brief diff is the B27-B-only delta.

## Contract

| Surface | Role |
|---------|------|
| `DecreeBanner:Hide` (Get nil) | If a frame exists, `wipePaint(self.frame)` then Hide. Return true. No `paint(`. No banner Show. No invented line. |
| `DecreeBanner:Hide` (Decree set) | Just Hide. Next Show paints. No wipe pin required. |
| `wipePaint` | Unchanged. `LineText:SetText("")`. `FlavorText:SetText("")` then Hide. Used by empty Show (B26-C) and now by empty Hide. |
| `DecreeBanner:Show` (empty Get) | Unchanged. `ensureFrame()`, `wipePaint(frame)`, Hide, return false. |
| Quiet | Silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. |

### Unchanged

- B26-C empty Show wipe. B25-B wipe + Show-only uniqueness. B24-D Init uniqueness.
- Existing Set / Show / Quiet hide / persist / already-seen-is-not-SV pins.
- Morpheus / FRIZQT / `SetFontObject` source pins.
- Isolation wrap (wow_ui_stub + Common + Decree + Decree UI + Minimap).
- Header copy / QuestBG. No deputy.

## TDD

1. Extended `tests/test_decree_ui.lua` first (Hide source blanks leftover line/flavor when Get is nil; nested `runB27B()` after `runB26C()`: Set Goldshire, Show, Clear, Hide not Show is hidden with `""` line/flavor; Hide while a Decree is still set, next Show paints; B26-C remount / empty-Show wipe stay). Isolation wrap and Set / Show / Quiet hide / persist / Morpheus pins untouched.
2. Red: `lua tests/test_decree_ui.lua` — **323 passed, 5 failed** (Hide missing `getDecree` / wipe; leftover Goldshire / flavor still on `LineText` / `FlavorText` after Clear + Hide; flavor still shown). Hide-while-set / next-Show paint pins and B26-C uniqueness / empty-Show wipe stayed green.
3. `Hide()` calls `wipePaint(self.frame)` when `getDecree()` is nil, then Hide. Active Decree path just Hides.
4. Green: `lua tests/test_decree_ui.lua` — **328 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_decree_ui.lua   # 328 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_decree_ui.lua` standalone | **328 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 18 isolation asserts stay under `if standalone then` (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Toasts / Records / glue / TOC were not edited.
- Hide after Clear blanks leftover line/flavor on the hidden widget. Does not Show. Does not invent a line.
- Hide while a Decree is still set just Hides; next Show paints. B26-C empty Show wipe stays green.
- Quiet stays silent. No `PlaySound`. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`. Header copy / QuestBG stay. No deputy.
- `runB27B()` is nested inside `runB25B()` after `runB26C()`. No new main-chunk locals. Isolation wrap stays.

## Leftovers

- **Core `Decree:Clear()` still does not wipe the banner.** A parchment left visible after Clear with no follow-up Hide or empty Show can still display Goldshire until something calls Hide or empty Show.
- **No client smoke.** Live leftover paint after Pope Clear + Close / ESC Hide is unproven on Anniversary.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` is a direct call**, not a real ESC key. Close-button Hide after Clear now wipes via the same path; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **328 / 0**. Isolation wrap **18**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
