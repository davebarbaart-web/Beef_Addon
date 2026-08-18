# B37-C — FighterCard Hide remounts UISpecialFrames membership (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); Bible §10.6 (mute tape), §10.7 (persist through the verdict beat); Law 6 / §19.1 (Quiet Mode hides Event chrome); Law 10 / §19.3 (theatrical card, no close ✕); brief `docs/reformation/vestments/briefs/B37-C-card-special.md`. B30 leftover: `Hide` remounted `wireCardOnHide` only. `rememberSpecial` was Init-only. A wiped `UISpecialFrames` + Hide-only left ESC idle until Init. `FRAME_NAME` is `ChurchOfBeefFighterCard`. lastPair until QUIET stays. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. Exclusive files only. No commit. Lane is not signed.

Existing-frame `FighterCard:Hide` now: `rememberSpecial(FRAME_NAME)` then existing `wireCardOnHide(frame)` then `paintHidden()`. Existing OnHide is not replaced. OnShow is not re-wired. Does not rebuild. Does not `PlaySound`. Init remount stays.

**Isolated count:** 660 passed, 0 failed (`lua tests/test_fighter_card.lua`). **17** isolation pins under `if standalone then`. Nested `runB37C()` inside `runB28D()` after `runB30B()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_fighter_card.lua` | TDD first. Nested `runB37C()` inside `runB28D()` after `runB30B()`. Source pin: Hide body calls `rememberSpecial(FRAME_NAME)` before OnHide remount + `paintHidden()`. No inline `SetScript`; no OnShow re-wire; no rebuild / `CreateFrame` / `PlaySound` / `IG_CHARACTER_INFO_*` / `forgetPersist`. Wipe `UISpecialFrames`, Hide: `ChurchOfBeefFighterCard` re-listed once. Third Hide does not duplicate. Existing OnHide identity stays. lastPair persist / health-nil / Morpheus / B28-D Init / B30-B OnHide remount stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/FighterCard.lua` | When `frame` exists, `Hide` calls `rememberSpecial(FRAME_NAME)` before the existing OnHide remount + `paintHidden()`. Does not replace an existing OnHide. No OnShow re-wire. No rebuild. Init remount / create-path / Show / Refresh / `wireCardOnHide` / `NAME_FONT` unchanged. No `PlaySound`. lastPair until QUIET stays. |
| `docs/reformation/vestments/briefs/B37-C-card-special-report.md` | This file |
| `docs/reformation/vestments/briefs/B37-C-card-special.diff` | B37-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Hud, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `PlaySound`. Did not add a close button. Did not add `UnitHealth`. Did not change lastPair-until-QUIET. Did not commit.

`git diff` vs HEAD on these two files also includes earlier fighter-card vestment batches (working tree already dirty). The brief diff is the B37-C-only delta.

## Contract

```lua
FighterCard:Init()      -- builds once; wireCardOnHide; rememberSpecial; Refresh
FighterCard:Show()      -- if frame exists, wireCardOnHide; then live pair / subjects / lastPair
FighterCard:Hide()      -- if frame exists, rememberSpecial then wireCardOnHide then paintHidden
frame:Hide() / OnHide   -- lastView.shown = false; lastPair remains
FighterCard:Refresh()   -- if frame exists, wireCardOnHide; may restore while the event is live
FighterCard:GetView()   -- copy
FighterCard:ResetForTests()
```

Mode Event. Quiet / Hide / EndEvent still Hide. `health` stays nil.

| Surface | Role |
|---------|------|
| `Hide` (frame exists) | `rememberSpecial(FRAME_NAME)` then `wireCardOnHide(frame)` then `paintHidden`. Same frame pointer. Does not replace an existing OnHide. Does not re-wire OnShow. Does not rebuild. |
| `Hide` (no frame) | Unchanged. `paintHidden()` only. |
| `wireCardOnHide` | Unchanged. If `GetScript("OnHide")` is nil, wire `lastView = hiddenView()` then `paintHidden` unless `hiding`. Do not replace an existing script. |
| `rememberSpecial` | Unchanged. Scan-then-append `FRAME_NAME` (`ChurchOfBeefFighterCard`). Init still calls it. Hide now calls it too. |
| `Init` remount | Unchanged (B28-D). Existing-frame Init still remounts OnHide then `rememberSpecial`. |
| `Show` / `Refresh` | Unchanged (B29-C). Still remount OnHide only. Do not `rememberSpecial`. |
| Wipe remount | `UISpecialFrames = {}` then Hide lists `ChurchOfBeefFighterCard` exactly once. Third Hide still once. |
| Frame identity | Hide keeps the same frame. No rebuild. Existing OnHide identity stays. |
| Persist | lastPair until QUIET. Hide does not `forgetPersist`. |
| Names | `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. |
| Health | nil. No `UnitHealth`. |
| Sound | None. Source has no `PlaySound` / `IG_CHARACTER_INFO_*`. |
| Close | No close button. No ✕. |

### Unchanged

- lastPair until QUIET. ASSEMBLY after QUIET does not revive.
- OnHide lastView sync / `hiding` guard (B13-B).
- B28-D Init remount. Create-path still `wireCardOnHide`.
- B29-C Show / Refresh remount. B30-B Hide OnHide remount.
- `NAME_FONT` `Fonts\\MORPHEUS.ttf`. No `MORPHEUS_CYR`.
- No `UnitHealth`. No close button. No `PlaySound`.
- Isolation wrap. New test locals live in `runB37C()` inside `runB28D()` after `runB30B()`.

## TDD

1. Extended `tests/test_fighter_card.lua` first (`runB37C()` nested inside `runB28D()` after `runB30B()`: Hide body calls `rememberSpecial(FRAME_NAME)` before `paintHidden`; wipe `UISpecialFrames`, Hide lists `ChurchOfBeefFighterCard` once; third Hide does not duplicate; existing OnHide identity stays; lastPair persist / health-nil / Morpheus / B28-D Init / B30-B OnHide remount stay). Isolation wrap and existing persist / health-nil / Morpheus / B28-D Init / B29-C Show/Refresh / B30-B Hide OnHide pins untouched.
2. Red: `lua tests/test_fighter_card.lua` — **654 passed, 6 failed** (Hide remount body missing `rememberSpecial(FRAME_NAME)`; remount-before-paint / remount-before-wire pins; wiped list stayed 0 after Hide / second Hide / third Hide). Existing OnHide identity / no rebuild / no OnShow / lastPair persist / B30-B remount stay pins stayed green.
3. Existing-frame `Hide` calls `rememberSpecial(FRAME_NAME)` then `wireCardOnHide(frame)` then `paintHidden()`. Existing script is not replaced. No OnShow re-wire. Init remount kept.
4. Green: `lua tests/test_fighter_card.lua` — **660 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_fighter_card.lua   # 660 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_fighter_card.lua` standalone | **660 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 660 passed, 0 failed. Isolation wrap stays (**17** nil pins at file load). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Hud / glue / TOC not edited.
- Existing-frame `Hide` re-registers `ChurchOfBeefFighterCard` and does not rebuild. Existing OnHide identity stays. OnShow is not wired.
- Wipe-to-empty then Hide lists the name exactly once. Third Hide still once.
- Restored membership still syncs via the existing OnHide remount. Hide does not `forgetPersist`. Refresh while the event is live still paints Chuckroast / Tendermage. `health` stays nil.
- `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. No `PlaySound`. No close button. No `UnitHealth`.
- `runB37C()` is nested inside `runB28D()` after `runB30B()`. Isolation wrap stays.

## Leftovers

- **Widget Hide / ESC does not remount `rememberSpecial`.** `CloseSpecialWindows` / `frame:Hide()` bypass `FighterCard:Hide`. A wiped list that never hits Hide / Show / Refresh / Init stays idle.
- **Show / Refresh still skip `rememberSpecial`.** Brief asked Hide remount only. A wipe then Show-only or Refresh-only still leaves ESC idle until Init or Hide.
- **`ResetForTests` still calls `paintHidden()`** and does not remount. Harness-only; production `FighterCard:Hide` remounts.
- **`UISpecialFrames = nil` still no-ops `rememberSpecial`.** Brief asked wipe-to-empty uniqueness, not a missing table.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` on `ChurchOfBeefFighterCard` is unproven on Anniversary. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` is a direct call**, not a real ESC key. Membership counts are pinned; the client's special-frame walk is not. Stub `CreateFrame` does not mint `_G["ChurchOfBeefFighterCard"]`.

## Status

**DONE_WITH_CONCERNS.** Isolated **660 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim.
