# B15-A — Inputs drag persist (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §13.1 / §18.5 (congregation input; inputs never trigger public theater); Law 6 / §19.1 (Event chrome; Quiet hide is Runtime); Law 10 / §19.3 (Inputs stay stock); HUD `savePoint` / `restorePoint` in `addon/ChurchOfBeef/UI/Hud.lua`; brief `docs/reformation/vestments/briefs/B15-A-inputs-persist.md`. CONTINUE 2026-08-18 license 4 (stock only). No Pope-name lookup. No SUMMON. No `PlaySound`. Do not register Inputs on `UISpecialFrames`. WIDTH 328 / HEIGHT 72 stay. B14-B `OnEscapePressed` ClearFocus and `SetMultiLine(true)` stay.

Copied the HUD persist pattern onto the stock Inputs root. Root `OnDragStop` calls `StopMovingOrSizing` then `savePoint` on the **root widget** (`GetPoint(1)`). Flat `{ point, relativePoint, x, y }` writes to `ChurchOfBeefDB.ui.inputs`. Never stores a frame. `restorePoint` runs in `build()`. Invalid / missing saved point falls back to `BOTTOM`, `UIParent`, `0`, `80`. Missing `ChurchOfBeefDB` → default restore; save no-ops. `ResetForTests` does not wipe SavedVariables. Quiet hide unchanged. ESC still ClearFocus only. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 386 passed, 0 failed (`lua tests/test_inputs.lua`). **24** isolation pins under the first `if standalone then`; **6** re-pins in `runB14B()`; **6** re-pins in `runB15A()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_inputs.lua` | TDD first. Root `OnDragStop`. `DB={ui={}}`; Init; StartEvent; Show; drag; `SetPoint TOPLEFT UIParent TOPLEFT 24 90`; saved point TOPLEFT x 24 y 90, `relativeTo` nil. `dofile` + Init restores parented `UIParent`. Invalid `MIDDLE-OF-NOWHERE` falls back BOTTOM x 0 y 80. Quiet Init with a valid saved point still hides. `ResetForTests` leaves SV. Missing `ChurchOfBeefDB` restores default; save no-ops. Not on `UISpecialFrames`. ESC ClearFocus still does not Hide. Existing Confess pins pass. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Inputs.lua` | HUD `ANCHORS` + `uiDb` + `savePoint` / `restorePoint` keyed `inputs`. `restorePoint` in `build()` (replaces the hardcoded default `SetPoint`). Root `SetMovable(true)` and `RegisterForDrag("LeftButton")`. Root `OnDragStop` saves after `StopMovingOrSizing`. `GetPoint(1)` is on the root widget. No `relativeTo` in source. `ResetForTests` still only nils the widget / view. |
| `docs/reformation/vestments/briefs/B15-A-inputs-persist-report.md` | This file |
| `docs/reformation/vestments/briefs/B15-A-inputs-persist.diff` | B15-A-only unified diff of the exclusive implementation files vs the pre-lane baseline |

Did not edit Net, Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Inputs to `UISpecialFrames`. Did not look up a Pope name. Did not add `PlaySound`. Did not commit.

The exclusive pair already existed. The brief diff is the B15-A-only delta vs the pre-lane text.

## Contract

| Surface | Role |
|---------|------|
| `ChurchOfBeefDB.ui.inputs` | Flat `{ point, relativePoint, x, y }`. Never a frame. |
| Root `OnDragStop` | `StopMovingOrSizing` on the root, then `savePoint(self)`. `GetPoint(1)` is the root. |
| `restorePoint` | In `build()`. `ANCHORS` whitelist on point and relative. Else `BOTTOM` / `UIParent` / `0` / `80`. |
| Missing `ChurchOfBeefDB` | Restore default. Save no-ops. Does not create the global. |
| `ResetForTests` | Nils the widget / view under `_IN_TEST`. Does not wipe SV. |
| Show / hide | Unchanged. Quiet Init hides even with a saved point. ESC ClearFocus only. |

### Unchanged

- Stock `InputBoxTemplate` / `UIPanelButtonTemplate`. Petition / Confess / Catch up verbs.
- WIDTH 328 / HEIGHT 72. B14-B `SetMultiLine(true)` and `OnEscapePressed` → `ClearFocus`.
- Not on `UISpecialFrames`. No Pope-name lookup. No SUMMON. No `PlaySound`.
- Isolation wrap. Event-only show.

## TDD

1. Extended `tests/test_inputs.lua` first (`runB15A()`: root drag persist, `dofile` restore, invalid fallback, Quiet hide, ResetForTests leaves SV, missing-DB no-op, ESC / Confess / `UISpecialFrames` pins, isolation re-pins). Isolation wrap untouched.
2. Red: `lua tests/test_inputs.lua` — **362 passed, 24 failed**.
3. Implemented HUD-style `savePoint` / `restorePoint` keyed `inputs`; root drop saves the widget; `restorePoint` in `build()`.
4. Green: `lua tests/test_inputs.lua` — **386 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_inputs.lua   # 386 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_inputs.lua` standalone | **386 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 24 original isolation asserts stay under `if standalone then`. `runB14B()` re-pins Console / Popes / Sender / Sound / Hud / slash. `runB15A()` re-pins the same six.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Net / Console / glue / TOC not edited.
- Save fires on root `OnDragStop` after `StopMovingOrSizing`. `GetPoint(1)` is the root.
- Saved table has point / relativePoint / x / y and no `relativeTo`. Source has no `relativeTo` string.
- `dofile` + Init restores TOPLEFT 24, 90 parented to `UIParent`. Invalid `MIDDLE-OF-NOWHERE` falls back BOTTOM 0, 80.
- Quiet Init with a valid saved point still hides. ESC ClearFocus still does not Hide. Not on `UISpecialFrames`.
- Missing `ChurchOfBeefDB` restores default; drag save leaves the global nil.
- `ResetForTests` leaves `ChurchOfBeefDB.ui.inputs`. No `PlaySound`. No `OnUpdate`. No custom media. WIDTH 328 / HEIGHT 72 stay.

## Concerns

- **No client smoke.** Root drag persist on Anniversary after `/reload` is unproven. Harness `GetPoint` / `SetPoint` is a stub. **POLISH:CANDIDATE** only.
- **`StopMovingOrSizing` on the real client** may rewrite the widget point (different relative / offsets) before save. Tests pin the stub: `SetPoint` then root drop stores that point.
- **`uiDb()` creates `ChurchOfBeefDB.ui` when the global exists but `ui` is missing** (HUD pattern). A missing global still no-ops save and does not create `ChurchOfBeefDB`.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Not signed. No Gate / **POLISH:PASS** claim.
