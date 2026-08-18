# B30-B — Fighter card Hide remounts a missing OnHide (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC / UIHANDLER OnHide (do **not** PlaySound `IG_CHARACTER_INFO_*`); Bible §10.6 (mute tape), §10.7 (persist through the verdict beat); Law 6 / §19.1 (Quiet Mode hides Event chrome); Law 10 / §19.3 (theatrical card, no close ✕); brief `docs/reformation/vestments/briefs/B30-B-card-hide-onhide.md`. B29 leftover: `Hide` skipped a niled OnHide when the frame already existed. Glue that only Hide()s would drop ESC lastView sync. `wireCardOnHide` already exists. Init / Show / Refresh already call it. B10-C lastPair until QUIET stays. B20-C `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. Exclusive files only. No commit. Lane is not signed.

When the frame exists, `Hide` calls `wireCardOnHide(frame)` before `paintHidden`. An existing script is not replaced. The widget is not rebuilt. Show / Refresh / Init remount stay.

**Isolated count:** 613 passed, 0 failed (`lua tests/test_fighter_card.lua`). **17** isolation pins under `if standalone then`. Nested `runB30B()` inside `runB28D()` after `runB29C()` (Lua 5.1 200-local nest; no new main-chunk locals).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_fighter_card.lua` | TDD first. Nested `runB30B()` inside `runB28D()` after `runB29C()`. Source: Hide exists-path calls `wireCardOnHide` then `paintHidden` and does not `SetScript` inline. Nil the OnHide, Hide restores; third Hide keeps identity; CreateFrame stays 0; restored fire still sets `lastView.shown` false and Refresh paints lastPair. Existing persist / health-nil / Morpheus / B28-D Init / B29-C Show/Refresh pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/FighterCard.lua` | When `frame` exists, `Hide` calls `wireCardOnHide(frame)` before `paintHidden`. Existing script is not replaced. Widget is not rebuilt. Show / Refresh / Init remount stay. No `UnitHealth`. No close button. No `PlaySound`. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. lastPair until QUIET stays. |
| `docs/reformation/vestments/briefs/B30-B-card-hide-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B30-B-card-hide-onhide.diff` | B30-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Hud, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add a close button. Did not add `UnitHealth`. Did not commit.

`git diff HEAD` on these two files also includes earlier fighter-card batches (working tree already dirty). The brief diff is the B30-B-only delta.

## Contract

```lua
FighterCard:Init()      -- builds once; wireCardOnHide; rememberSpecial; Refresh
FighterCard:Show()      -- if frame exists, wireCardOnHide; then live pair / subjects / lastPair
FighterCard:Hide()      -- if frame exists, wireCardOnHide; then paintHidden; does not forget lastPair
frame:Hide() / OnHide   -- lastView.shown = false; lastPair remains
FighterCard:Refresh()   -- if frame exists, wireCardOnHide; may restore while the event is live
FighterCard:GetView()   -- copy
FighterCard:ResetForTests()
```

Mode Event. Quiet / Hide / EndEvent still Hide. `health` stays nil.

| Surface | Role |
|---------|------|
| `Init` | If `frame` is nil, `build()`. Then `wireCardOnHide(frame)`, `rememberSpecial`, `Refresh`. Unchanged. |
| `Show` | If `frame` is nil, `Init()`. Then `wireCardOnHide(frame)`. Does not replace an existing script. Does not rebuild. Unchanged. |
| `Refresh` | If `frame` is nil, `Init()` and return. Else `wireCardOnHide(frame)`. Does not replace an existing script. Does not rebuild. Unchanged. |
| `Hide` | If `frame` exists, `wireCardOnHide(frame)` then `paintHidden`. Does not replace an existing script. Does not rebuild. Does not `Init` a missing frame. |
| `wireCardOnHide` | If `GetScript("OnHide")` is nil, wire `lastView = hiddenView()` then `paintHidden` unless `hiding`. Do not replace an existing script. |
| Missing OnHide remount | `SetScript("OnHide", nil)` then Hide restores; third Hide keeps identity. No `CreateFrame`. |
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
- B29-C Show / Refresh remount.
- `NAME_FONT` `Fonts\\MORPHEUS.ttf`. No `MORPHEUS_CYR`.
- No `UnitHealth`. No close button. No `PlaySound`.
- Isolation wrap. New test locals live in `runB30B()` inside `runB28D()` after `runB29C()`.

## TDD

1. Extended `tests/test_fighter_card.lua` first (`runB30B()` nested inside `runB28D()` after `runB29C()`: Hide exists-path calls `wireCardOnHide` then `paintHidden`; nil OnHide then Hide restores; third Hide identity stays; restored fire still syncs `lastView` and Refresh paints lastPair). Isolation wrap and existing persist / health-nil / Morpheus / B28-D Init / B29-C Show/Refresh pins untouched.
2. Red: `lua tests/test_fighter_card.lua` — **610 passed, 3 failed** (Hide exists-path missing `wireCardOnHide`; niled OnHide stayed nil after Hide; fire false). Existing persist / health-nil / Morpheus / B28-D Init / B29-C Show/Refresh / isolation pins stayed green.
3. `Hide` calls `wireCardOnHide(frame)` when the frame exists, then `paintHidden`. Existing script is not replaced. Widget is not rebuilt. Show / Refresh / Init remount kept.
4. Green: `lua tests/test_fighter_card.lua` — **613 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_fighter_card.lua   # 613 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_fighter_card.lua` standalone | **613 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 613 passed, 0 failed. Isolation wrap stays (**17** nil pins at file load). Wrap pattern unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Hud / glue / TOC not edited.
- Hide restores a missing OnHide via the same helper as Init / Show / Refresh / `build()`. An existing script is not replaced. No rebuild.
- Restored OnHide still syncs `lastView` without `forgetPersist`. Refresh while the event is live still paints Chuckroast / Tendermage. `health` stays nil.
- `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. No `PlaySound`. No close button. No `UnitHealth`.
- `runB30B()` is nested inside `runB28D()` after `runB29C()`. Isolation wrap stays.

## Leftovers

- **No client smoke.** A live remount that dropped the handler is simulated by `SetScript("OnHide", nil)`. Anniversary ESC vs `CloseSpecialWindows` order is unproven.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` / `stub.fire` is a direct call**, not a real ESC key. Script identity and lastView sync are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **613 / 0**. Isolation wrap **17**. Not signed. No Gate / **POLISH:PASS** claim.
