# B24-C — Quiet shell Init early-return re-registers ESC (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** B23-C leftover on the Quiet shell (`UI:Init` returned the existing frame and skipped `rememberSpecial`; a wiped `UISpecialFrames` never got `ChurchOfBeefFrame` back); wiki ESC via `UISpecialFrames`; Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / Bible §19.3 (functional Quiet shell stays stock `BasicFrameTemplate`); brief `docs/reformation/vestments/briefs/B24-C-shell-special.md`. B15-C uniqueness stays. No `PlaySound` / `IG_CHARACTER_INFO_*`. Exclusive files only. No commit. Lane is not signed.

`UI:Init` early-return (`if self.frame then`) now calls `rememberSpecial(FRAME_NAME)` then returns the frame. It does not rebuild. It does not re-wire OnShow / OnHide. Create-path uniqueness still dedupes. First-create / rebuild uniqueness pins stay.

**Isolated count:** 507 passed, 0 failed (`lua tests/test_ui.lua`). **11** isolation pins under the first `if standalone then`; **4** re-pins in `runB12D()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Nested B24-C pins inside `runB12D()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pin: early-return body has `rememberSpecial(FRAME_NAME)` and no `SetScript` / `OnShow` / `OnHide` / `buildFrame`. `UI:Init`, wipe `UISpecialFrames` to `{}`, second `Init`: `ChurchOfBeefFrame` listed exactly once. Frame identity and OnShow / OnHide function identity stay. First-create / rebuild uniqueness pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/MainFrame.lua` | Early-return calls `rememberSpecial(FRAME_NAME)` then returns the frame. Does not rebuild. Does not re-wire OnShow / OnHide. No new main-chunk locals. B15-C `rememberSpecial` uniqueness stays. |
| `docs/reformation/vestments/briefs/B24-C-shell-special-report.md` | This file |
| `docs/reformation/vestments/briefs/B24-C-shell-special.diff` | B24-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Toasts, Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `PlaySound` / `IG_CHARACTER_INFO_*`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier Quiet-shell / toast batches (working tree already dirty). The brief diff is the B24-C-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Init` early-return | `rememberSpecial(FRAME_NAME)` then return the existing frame. |
| Early-return OnShow / OnHide | Not re-wired. This path does not `SetScript`. |
| Create path | Unchanged. Builds once; then `rememberSpecial(FRAME_NAME)`. |
| Wipe remount | `UISpecialFrames = {}` then second Init lists `ChurchOfBeefFrame` exactly once. |
| B15-C uniqueness | Scan-then-append stays. Forced rebuild still lists the name once. |
| Sound | None. Source has no `PlaySound` / `IG_CHARACTER_INFO`. |
| Template | Stays `BasicFrameTemplate`. |

### Unchanged

- Existing Init pin `UISpecialFrames[1] == "ChurchOfBeefFrame"`.
- B15-C Quiet-shell `rememberSpecial` / forced-rebuild uniqueness pins.
- B12-D Proclaim / ESC / UISpecialFrames pins.
- B18-C HideAll / `theaterGen` pins.
- B19-B / B20-D / B21-C / B23-C small-toast pins.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_ui.lua` first (pins nested in `runB12D()`: early-return source has `rememberSpecial(FRAME_NAME)`; Init, wipe `UISpecialFrames` to `{}`, second Init lists the name once; frame / OnShow / OnHide identity stay). Isolation wrap and first-create / rebuild uniqueness pins untouched.
2. Red: `lua tests/test_ui.lua` — **504 passed, 3 failed**.
3. Early-return calls `rememberSpecial(FRAME_NAME)` then returns the frame.
4. Green: `lua tests/test_ui.lua` — **507 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 507 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | **507 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 original isolation asserts stay under `if standalone then`. `runB12D()` re-pins Console / Hud / Records Book / Gora.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Toasts / Console / glue / TOC were not edited.
- Early-return re-registers `ChurchOfBeefFrame` and does not rebuild or re-wire OnShow / OnHide.
- Wipe-to-empty then second Init lists the name exactly once. Third Init still once.
- B15-C uniqueness stays. No `PlaySound`. No new main-chunk locals.
- New test locals are inside `runB12D()`. Isolation wrap stays.

## Leftovers

- **Decree `ensureFrame` still skips `rememberSpecial` on early-return.** Same leftover, B24-D exclusive pair. Not this lane.
- **Parked Console leftover** (overview): selected-pair inherit of Core `namedOpponent`. Later Console batch.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` order (`ChurchOfBeefFrame`, `ChurchOfBeefProclaim`, `ChurchOfBeefToast` share the list) is unproven on Anniversary. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` is a direct call**, not a real ESC key. Membership counts are pinned; the client's special-frame walk is not.
- **Early-return never re-wires OnShow / OnHide**, even if a remounted frame had lost the scripts. Law asked: do not re-wire.

## Status

**DONE_WITH_CONCERNS.** Isolated **507 / 0**. Not signed.
