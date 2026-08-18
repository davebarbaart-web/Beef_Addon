# B16-B — Inputs TitleBar drag handle (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §13.1 / §18.5 (congregation input; inputs never trigger public theater); Law 6 / §19.1 (Event chrome; Quiet hide is Runtime); Law 10 / §19.3 (Inputs stay stock; no title string); ConsoleDock TitleBar drag persist (`addon/ChurchOfBeef/UI/ConsoleDock.lua`); brief `docs/reformation/vestments/briefs/B16-B-inputs-handle.md`. CONTINUE 2026-08-18 license 4 (stock only). No Pope-name lookup. No SUMMON. No `PlaySound`. Do not register Inputs on `UISpecialFrames`. WIDTH 328 / HEIGHT 72 stay. B14-B `OnEscapePressed` ClearFocus and `SetMultiLine(true)` stay. Persist key stays `ChurchOfBeefDB.ui.inputs`.

Moved drag off the root onto a thin `TitleBar` child (height 12, TOPLEFT/TOPRIGHT, `EnableMouse`, `RegisterForDrag("LeftButton")`). TitleBar `OnDragStart` `StartMoving`s the **root**. TitleBar `OnDragStop` calls `StopMovingOrSizing` then `savePoint` on the root (`GetPoint(1)`). Root `RegisterForDrag` and root drag scripts are gone. Root stays `SetMovable` + `SetClampedToScreen`. No title string. Flat `{ point, relativePoint, x, y }` still writes to `ChurchOfBeefDB.ui.inputs`. Quiet hide / ESC ClearFocus / isolation wrap unchanged. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 419 passed, 0 failed (`lua tests/test_inputs.lua`). **24** isolation pins under the first `if standalone then`; **6** re-pins in `runB14B()`; **6** B15-A re-pins and **6** B16-B re-pins in `runB15A()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_inputs.lua` | TDD first. Persist pins fire **TitleBar** `OnDragStop` (dock pattern), not root. TitleBar exists; height 12–14; TOPLEFT/TOPRIGHT; no title FontString. Root `OnDragStart` / `OnDragStop` nil. `rawget` for `TitleBar` (stub capital-key guard). Quiet hide, ESC ClearFocus, not on `UISpecialFrames`, isolation wrap stay. |
| `addon/ChurchOfBeef/UI/Inputs.lua` | TitleBar child height 12, TOPLEFT/TOPRIGHT, `EnableMouse`, `RegisterForDrag("LeftButton")`. StartMoving / savePoint on the root. Root `RegisterForDrag` removed. Root stays `SetMovable` + `SetClampedToScreen`. No title string. Persist key `ui.inputs` unchanged. |
| `docs/reformation/vestments/briefs/B16-B-inputs-handle-report.md` | This file |
| `docs/reformation/vestments/briefs/B16-B-inputs-handle.diff` | B16-B-only unified diff of the exclusive implementation files vs the pre-lane baseline |

Did not edit Net, Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Inputs to `UISpecialFrames`. Did not look up a Pope name. Did not add `PlaySound`. Did not commit.

## Contract

| Surface | Role |
|---------|------|
| `ChurchOfBeefDB.ui.inputs` | Flat `{ point, relativePoint, x, y }`. Never a frame. Unchanged key. |
| TitleBar `OnDragStop` | `StopMovingOrSizing` on the root, then `savePoint(widget)`. `GetPoint(1)` is the root. |
| Root | `SetMovable` + `SetClampedToScreen`. No `RegisterForDrag`. No `OnDragStart` / `OnDragStop`. |
| TitleBar | Height 12. TOPLEFT/TOPRIGHT. `EnableMouse`. `RegisterForDrag("LeftButton")`. No title string. |
| `restorePoint` | Unchanged. `ANCHORS` whitelist. Else `BOTTOM` / `UIParent` / `0` / `80`. |
| Missing `ChurchOfBeefDB` | Restore default. Save no-ops. Does not create the global. |
| `ResetForTests` | Nils the widget / view under `_IN_TEST`. Does not wipe SV. |
| Show / hide | Unchanged. Quiet Init hides even with a saved point. ESC ClearFocus only. |

### Unchanged

- Stock `InputBoxTemplate` / `UIPanelButtonTemplate`. Petition / Confess / Catch up verbs.
- WIDTH 328 / HEIGHT 72. B14-B `SetMultiLine(true)` and `OnEscapePressed` → `ClearFocus`.
- Not on `UISpecialFrames`. No Pope-name lookup. No SUMMON. No `PlaySound`.
- Isolation wrap. Event-only show.

## TDD

1. Extended `tests/test_inputs.lua` first (`runB15A()` persist pins fire TitleBar, not root; TitleBar exists / height / TOPLEFT/TOPRIGHT; root drag scripts nil; Quiet hide; ESC; `UISpecialFrames`; isolation re-pins). Isolation wrap untouched.
2. Red: `lua tests/test_inputs.lua` — **383 passed, 26 failed**.
3. Implemented TitleBar handle; removed root `RegisterForDrag` and root drag scripts; TitleBar drop saves the root widget.
4. Green: `lua tests/test_inputs.lua` — **419 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_inputs.lua   # 419 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_inputs.lua` standalone | **419 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 24 original isolation asserts stay under `if standalone then`. `runB14B()` re-pins Console / Popes / Sender / Sound / Hud / slash. `runB15A()` re-pins the same six for B15-A and again for B16-B.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Net / Console / glue / TOC not edited.
- Save fires on TitleBar `OnDragStop` after `StopMovingOrSizing`. `GetPoint(1)` is the root.
- Root has no `OnDragStart` / `OnDragStop` / `RegisterForDrag`. Root stays `SetMovable` + `SetClampedToScreen`.
- TitleBar height 12 (inside 12–14). TOPLEFT/TOPRIGHT. No title string. No `CreateFontString`.
- Saved table has point / relativePoint / x / y and no `relativeTo`. Persist key stays `ui.inputs`.
- `dofile` + Init restores TOPLEFT 24, 90 parented to `UIParent`. Invalid `MIDDLE-OF-NOWHERE` falls back BOTTOM 0, 80.
- Quiet Init with a valid saved point still hides. ESC ClearFocus still does not Hide. Not on `UISpecialFrames`.
- Missing `ChurchOfBeefDB` restores default; drag save leaves the global nil.
- `ResetForTests` leaves `ChurchOfBeefDB.ui.inputs`. No `PlaySound`. No `OnUpdate`. No custom media. WIDTH 328 / HEIGHT 72 stay.

## Concerns

- **No client smoke.** TitleBar drag on Anniversary after `/reload` is unproven. Harness `GetPoint` / `SetPoint` is a stub. **POLISH:CANDIDATE** only.
- **Confess box overlap.** Box stays `TOP` / `-8` / height 22. TitleBar is 12px at the top and is created before the box, so the box can eat the lower 4px of the handle in the center. Exclusive grab is the top 8px plus the 12px side margins. HEIGHT was not grown; box Y was not moved.
- **`StopMovingOrSizing` on the real client** may rewrite the widget point (different relative / offsets) before save. Tests pin the stub: `SetPoint` then TitleBar drop stores that point.
- **`rawget(frame, "TitleBar")` in tests** avoids the stub’s capital-key missing-method error when the field is absent. After implement, assignment still lands on the widget.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Not signed. No Gate / **POLISH:PASS** claim.
