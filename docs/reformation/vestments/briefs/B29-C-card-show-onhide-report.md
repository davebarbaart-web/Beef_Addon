# B29-C — Fighter card Show / Refresh restore a missing OnHide (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC / UIHANDLER OnHide (do **not** PlaySound `IG_CHARACTER_INFO_*`); Bible §10.6 (mute tape), §10.7 (persist through the verdict beat); Law 6 / §19.1 (Quiet Mode hides Event chrome); Law 10 / §19.3 (theatrical card, no close ✕); brief `docs/reformation/vestments/briefs/B29-C-card-show-onhide.md`. B28 leftover: `Show` / `Refresh` skipped a niled OnHide when the frame already existed. Glue that remounts only via Show / Refresh would drop ESC lastView sync. `wireCardOnHide` already exists. Init already calls it. B10-C lastPair until QUIET stays. B20-C `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. Exclusive files only. No commit. Lane is not signed.

When the frame exists, `Show` and `Refresh` call `wireCardOnHide(frame)`. An existing script is not replaced. The widget is not rebuilt. Init remount stays.

**Isolated count:** 574 passed, 0 failed (`lua tests/test_fighter_card.lua`). **17** isolation pins under `if standalone then`. Nested `runB29C()` inside `runB28D()` after the B28-D pins (Lua 5.1 200-local nest; no new main-chunk locals).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_fighter_card.lua` | TDD first. Nested `runB29C()` inside `runB28D()` after the B28-D pins. Source: Show / Refresh exists-paths call `wireCardOnHide` and do not `SetScript` inline. Nil the OnHide, Show restores; nil again, Refresh restores; third Show keeps identity; CreateFrame stays 0; restored fire still sets `lastView.shown` false and Refresh paints lastPair. Existing persist / health-nil / Morpheus / B28-D Init pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/FighterCard.lua` | When `frame` exists, `Show` and `Refresh` call `wireCardOnHide(frame)`. Existing script is not replaced. Widget is not rebuilt. Init remount stays. No `UnitHealth`. No close button. No `PlaySound`. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. lastPair until QUIET stays. |
| `docs/reformation/vestments/briefs/B29-C-card-show-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B29-C-card-show-onhide.diff` | B29-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Hud, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add a close button. Did not add `UnitHealth`. Did not commit.

`git diff HEAD` on these two files also includes earlier fighter-card batches (working tree already dirty). The brief diff is the B29-C-only delta.

## Contract

```lua
FighterCard:Init()      -- builds once; wireCardOnHide; rememberSpecial; Refresh
FighterCard:Show()      -- if frame exists, wireCardOnHide; then live pair / subjects / lastPair
FighterCard:Hide()      -- paintHidden; does not forget lastPair
frame:Hide() / OnHide   -- lastView.shown = false; lastPair remains
FighterCard:Refresh()   -- if frame exists, wireCardOnHide; may restore while the event is live
FighterCard:GetView()   -- copy
FighterCard:ResetForTests()
```

Mode Event. Quiet / Hide / EndEvent still Hide. `health` stays nil.

| Surface | Role |
|---------|------|
| `Init` | If `frame` is nil, `build()`. Then `wireCardOnHide(frame)`, `rememberSpecial`, `Refresh`. Unchanged. |
| `Show` | If `frame` is nil, `Init()`. Then `wireCardOnHide(frame)`. Does not replace an existing script. Does not rebuild. |
| `Refresh` | If `frame` is nil, `Init()` and return. Else `wireCardOnHide(frame)`. Does not replace an existing script. Does not rebuild. |
| `wireCardOnHide` | If `GetScript("OnHide")` is nil, wire `lastView = hiddenView()` then `paintHidden` unless `hiding`. Do not replace an existing script. |
| Missing OnHide remount | `SetScript("OnHide", nil)` then Show restores; nil again, Refresh restores; third Show keeps identity. No `CreateFrame`. |
| Restored OnHide | Still sets `lastView.shown` false. Still does not forget `lastPair`. Refresh while the event is live still paints. |
| Persist | lastPair until QUIET. |
| Names | `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. |
| Health | nil. No `UnitHealth`. |
| Sound | None. Source has no `PlaySound`. |
| Close | No close button. No ✕. |

### Unchanged

- lastPair until QUIET. ASSEMBLY after QUIET does not revive.
- OnHide lastView sync / `hiding` guard (B13-B).
- B28-D Init remount. Create-path still `wireCardOnHide`.
- `NAME_FONT` `Fonts\\MORPHEUS.ttf`. No `MORPHEUS_CYR`.
- No `UnitHealth`. No close button. No `PlaySound`.
- Isolation wrap. New test locals live in `runB29C()` inside `runB28D()`.

## TDD

1. Extended `tests/test_fighter_card.lua` first (`runB29C()` nested inside `runB28D()` after the B28-D pins: Show / Refresh exists-paths call `wireCardOnHide`; nil OnHide then Show restores; nil again, Refresh restores; third Show identity stays; restored fire still syncs `lastView` and Refresh paints lastPair). Isolation wrap and existing persist / health-nil / Morpheus / B28-D Init pins untouched.
2. Red: `lua tests/test_fighter_card.lua` — **568 passed, 6 failed** (Show / Refresh exists-paths missing `wireCardOnHide`; niled OnHide stayed nil after Show and after Refresh; fire false; lastView stayed shown). Existing persist / health-nil / Morpheus / B28-D Init / isolation pins stayed green.
3. `Show` and `Refresh` call `wireCardOnHide(frame)` when the frame exists. Existing script is not replaced. Widget is not rebuilt. Init remount kept.
4. Green: `lua tests/test_fighter_card.lua` — **574 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_fighter_card.lua   # 574 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_fighter_card.lua` standalone | **574 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 574 passed, 0 failed. Isolation wrap stays (**17** nil pins at file load). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Hud / glue / TOC not edited.
- Show / Refresh restore a missing OnHide via the same helper as Init / `build()`. An existing script is not replaced. No rebuild.
- Restored OnHide still syncs `lastView` without `forgetPersist`. Refresh while the event is live still paints Chuckroast / Tendermage. `health` stays nil.
- `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. No `PlaySound`. No close button. No `UnitHealth`.
- `runB29C()` is nested inside `runB28D()` after the B28-D pins. Isolation wrap stays.

## Leftovers

- **No client smoke.** A live remount that dropped the handler is simulated by `SetScript("OnHide", nil)`. Anniversary ESC vs `CloseSpecialWindows` order is unproven.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` / `stub.fire` is a direct call**, not a real ESC key. Script identity and lastView sync are pinned; the client's special-frame walk is not.
- **`Hide` still does not remount OnHide.** Init / Show / Refresh do. Glue that only Hide()s a niled script would still drop ESC lastView sync until the next Show / Refresh / Init.

## Status

**DONE_WITH_CONCERNS.** Isolated **574 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
