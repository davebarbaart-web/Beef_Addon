# B39-B — FighterCard Show / Refresh remount rememberSpecial (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); Bible §10.6 (mute tape), §10.7 (persist through the verdict beat); Law 6 / §19.1 (Quiet Mode hides Event chrome); Law 10 / §19.3 (theatrical card, no close ✕); brief `docs/reformation/vestments/briefs/B39-B-card-remember.md`. B37 leftover: Hide remounts `rememberSpecial`; Show / Refresh remounted `wireCardOnHide` only. A wiped list then Show-only or Refresh-only left ESC idle until Init or Hide. `FRAME_NAME` is `ChurchOfBeefFighterCard`. lastPair until QUIET stays. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. Exclusive files only. No commit. Lane is not signed.

Existing-frame `FighterCard:Show` and `FighterCard:Refresh` now: `rememberSpecial(FRAME_NAME)` then existing `wireCardOnHide(frame)`. Existing OnHide is not replaced. OnShow is not re-wired. Does not rebuild. Does not `PlaySound`. Does not reset `lastPair`. Hide remount (B37-C) and Init remount stay.

**Isolated count:** 731 passed, 0 failed (`lua tests/test_fighter_card.lua`). **17** isolation pins under `if standalone then` at load. Nested `runB39B()` inside `runB28D()` after `runB37C()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_fighter_card.lua` | TDD first. Nested `runB39B()` inside `runB28D()` after `runB37C()`. Source pin: Show / Refresh exists-paths call `rememberSpecial(FRAME_NAME)` before `wireCardOnHide`. No inline `SetScript`; no OnShow re-wire; no rebuild / `CreateFrame` / `PlaySound` / `IG_CHARACTER_INFO_*`. Wipe `UISpecialFrames`, Show: `ChurchOfBeefFighterCard` re-listed once. Wipe again, Refresh: re-listed once. Existing OnHide identity stays. lastPair persist / health-nil / Morpheus / B28-D Init / B29-C OnHide remount / B37-C Hide remount stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/FighterCard.lua` | When `frame` exists, `Show` and `Refresh` call `rememberSpecial(FRAME_NAME)` before the existing OnHide remount. Do not replace an existing OnHide. No OnShow re-wire. No rebuild. Hide remount / Init remount / create-path / `wireCardOnHide` / `NAME_FONT` unchanged. No `PlaySound`. lastPair until QUIET stays. |
| `docs/reformation/vestments/briefs/B39-B-card-remember-report.md` | This file |
| `docs/reformation/vestments/briefs/B39-B-card-remember.diff` | B39-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Hud, glue, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `PlaySound`. Did not add a close button. Did not add `UnitHealth`. Did not reset lastPair on remount. Did not commit.

`git diff` vs HEAD on these two files also includes earlier fighter-card vestment batches (working tree already dirty). The brief diff is the B39-B-only delta.

## Contract

```lua
FighterCard:Init()      -- builds once; wireCardOnHide; rememberSpecial; Refresh
FighterCard:Show()      -- if frame exists, rememberSpecial then wireCardOnHide; then live pair / subjects / lastPair
FighterCard:Hide()      -- if frame exists, rememberSpecial then wireCardOnHide then paintHidden
frame:Hide() / OnHide   -- lastView.shown = false; lastPair remains
FighterCard:Refresh()   -- if frame exists, rememberSpecial then wireCardOnHide; may restore while the event is live
FighterCard:GetView()   -- copy
FighterCard:ResetForTests()
```

Mode Event. Quiet / Hide / EndEvent still Hide. `health` stays nil.

| Surface | Role |
|---------|------|
| `Show` (frame exists) | `rememberSpecial(FRAME_NAME)` then `wireCardOnHide(frame)` then live pair / subjects / lastPair. Same frame pointer. Does not replace an existing OnHide. Does not re-wire OnShow. Does not rebuild. |
| `Refresh` (frame exists) | `rememberSpecial(FRAME_NAME)` then `wireCardOnHide(frame)` then paint. Same frame pointer. Does not replace an existing OnHide. Does not re-wire OnShow. Does not rebuild. |
| `Show` / `Refresh` (no frame) | Unchanged. `Init()` first (Init already remounts). |
| `wireCardOnHide` | Unchanged. If `GetScript("OnHide")` is nil, wire `lastView = hiddenView()` then `paintHidden` unless `hiding`. Do not replace an existing script. |
| `rememberSpecial` | Unchanged. Scan-then-append `FRAME_NAME` (`ChurchOfBeefFighterCard`). Init and Hide still call it. Show / Refresh now call it too. |
| `Init` remount | Unchanged (B28-D). Existing-frame Init still remounts OnHide then `rememberSpecial`. |
| `Hide` remount | Unchanged (B37-C). Still `rememberSpecial` then `wireCardOnHide` then `paintHidden`. |
| Wipe remount | `UISpecialFrames = {}` then Show lists `ChurchOfBeefFighterCard` exactly once. Wipe again, Refresh lists it once. |
| Frame identity | Show and Refresh keep the same frame. No rebuild. Existing OnHide identity stays. |
| Persist | lastPair until QUIET. Show / Refresh remount do not reset lastPair. |
| Names | `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. |
| Health | nil. No `UnitHealth`. |
| Sound | None. Source has no `PlaySound` / `IG_CHARACTER_INFO_*`. |
| Close | No close button. No ✕. |

### Unchanged

- lastPair until QUIET. ASSEMBLY after QUIET does not revive.
- OnHide lastView sync / `hiding` guard (B13-B).
- B28-D Init remount. Create-path still `wireCardOnHide`.
- B29-C Show / Refresh OnHide remount. B30-B Hide OnHide remount. B37-C Hide `rememberSpecial` remount.
- `NAME_FONT` `Fonts\\MORPHEUS.ttf`. No `MORPHEUS_CYR`.
- No `UnitHealth`. No close button. No `PlaySound`.
- Isolation wrap. New test locals live in `runB39B()` inside `runB28D()` after `runB37C()`.

## TDD

1. Extended `tests/test_fighter_card.lua` first (`runB39B()` nested inside `runB28D()` after `runB37C()`: Show / Refresh exists-paths call `rememberSpecial(FRAME_NAME)` before `wireCardOnHide`; wipe `UISpecialFrames`, Show lists `ChurchOfBeefFighterCard` once; wipe again, Refresh lists once; existing OnHide identity stays; lastPair persist / health-nil / Morpheus / B28-D Init / B37-C Hide remount stay). Isolation wrap and existing persist / health-nil / Morpheus / B28-D Init / B29-C Show/Refresh OnHide / B37-C Hide remount pins untouched.
2. Red: `lua tests/test_fighter_card.lua` — **723 passed, 8 failed** (Show / Refresh exists-paths missing `rememberSpecial(FRAME_NAME)`; remount-before-wire pins; wiped list stayed 0 after Show / Refresh / second Show / third Refresh). Existing OnHide identity / no rebuild / no OnShow / lastPair persist / B37-C Hide remount stay pins stayed green.
3. Existing-frame `Show` and `Refresh` call `rememberSpecial(FRAME_NAME)` then `wireCardOnHide(frame)`. Existing script is not replaced. No OnShow re-wire. lastPair is not reset. Init / Hide remounts kept.
4. Green: `lua tests/test_fighter_card.lua` — **731 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_fighter_card.lua   # 731 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_fighter_card.lua` standalone | **731 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 731 passed, 0 failed. Isolation wrap stays (**17** nil pins at file load). Wrap pattern unchanged. Nest re-pins Hud / UI / Toasts under standalone.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Hud / glue / TOC / MainFrame not edited.
- Existing-frame `Show` / `Refresh` re-register `ChurchOfBeefFighterCard` and do not rebuild. Existing OnHide identity stays. OnShow is not wired.
- Wipe-to-empty then Show lists the name exactly once. Wipe again, Refresh lists once. Second Show / third Refresh still once.
- Remount does not `forgetPersist`. Refresh while the event is live still paints Chuckroast / Tendermage. `health` stays nil.
- `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. No `PlaySound`. No close button. No `UnitHealth`.
- `runB39B()` is nested inside `runB28D()` after `runB37C()`. Isolation wrap stays.

## Leftovers

- **Widget Hide / ESC does not remount `rememberSpecial`.** `CloseSpecialWindows` / `frame:Hide()` bypass `FighterCard:Show` / `Refresh` / `Hide`. A wiped list that never hits those entry points stays idle.
- **`ResetForTests` still calls `paintHidden()`** and does not remount. Harness-only; production `Show` / `Refresh` remount.
- **`UISpecialFrames = nil` still no-ops `rememberSpecial`.** Brief asked wipe-to-empty uniqueness, not a missing table.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` on `ChurchOfBeefFighterCard` is unproven on Anniversary. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Show()` / `Refresh()` are direct calls**, not a real ESC key. Membership counts are pinned; the client's special-frame walk is not. Stub `CreateFrame` does not mint `_G["ChurchOfBeefFighterCard"]`.

## Status

**DONE_WITH_CONCERNS.** Isolated **731 / 0**. Isolation wrap **17**. Not signed. No Gate W / Gate V / **POLISH:PASS** claim.
