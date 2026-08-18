Spec PASS

# B15-A — Inputs drag persist (review)

**Quality:** Approved-with-nits

**Lane:** B15-A Inputs drag persist
**Brief:** `docs/reformation/vestments/briefs/B15-A-inputs-persist.md`
**Writer report:** `docs/reformation/vestments/briefs/B15-A-inputs-persist-report.md`
**Diff:** `docs/reformation/vestments/briefs/B15-A-inputs-persist.diff` (exclusive-pair packet: `UI/Inputs.lua` + `tests/test_inputs.lua`)
**Exclusive files:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Inputs.lua` (`ANCHORS` / `uiDb` / `savePoint` / `restorePoint` / root `OnDragStop` / `build` / `ResetForTests` / Quiet hide / B14-B ESC), and `tests/test_inputs.lua` (`runB15A()` root drag persist, `dofile` restore, invalid fallback, Quiet hide, missing-DB no-op, ESC / `UISpecialFrames` re-pins, isolation wrap); then ran `lua tests/test_inputs.lua` (**386 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: persist `ChurchOfBeefDB.ui.inputs` HUD pattern; not `UISpecialFrames`; ESC `ClearFocus` stays; Quiet hide; no Pope lookup; WIDTH 328 / HEIGHT 72 unchanged. Bible §13.1 / §18.5 (congregation input; inputs never trigger public theater); Law 6 / §19.1 (Event chrome; Quiet hide is Runtime); Law 10 / §19.3 (Inputs stay stock); HUD `savePoint` / `restorePoint` in `addon/ChurchOfBeef/UI/Hud.lua`; CONTINUE 2026-08-18 license 4 (stock only). Did not mutate `Inputs.lua` or `test_inputs.lua`. Did not commit. Did not edit Net, Console, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Exclusive file breach (Net / Console / glue) | **Pass.** Provided diff is two `diff --git` hunks: `UI/Inputs.lua` and `tests/test_inputs.lua`. Live persist sites match that slice (`inputs` keyed HUD helpers; root drop saves the root widget; `restorePoint` in `build()`). Sibling dirt in this workspace (Console, Hud, TOC, glue, `tests/run.lua`) is other lanes. |
| Persist is HUD `savePoint` / `restorePoint`, keyed `ChurchOfBeefDB.ui.inputs`, no frame | **Pass. Verified.** Nine HUD anchors. `GetPoint(1)` discards `relativeTo` with `_`. Save writes `{ point, relativePoint, x, y }` only. Pin: after root drop of `TOPLEFT` / `24` / `90`, `saved.relativeTo == nil`. Reviewer probe: saved keys are exactly `point,relativePoint,x,y`; a planted `junk` / `relativeTo` is replaced on the next drop. |
| `ANCHORS` whitelist / invalid fallback | **Pass. Verified.** Restore requires `ANCHORS[p.point]` and `ANCHORS[relative]` plus numeric `x` / `y`. Pin: `MIDDLE-OF-NOWHERE` falls back `BOTTOM` / `UIParent` / `0` / `80`. Reviewer probe: invalid `relativePoint` with a valid `point` also falls back; string `x` falls back; missing `relativePoint` uses `point`; empty `{}` falls back. |
| Missing `ChurchOfBeefDB` no-op | **Pass. Verified.** Pin: `ChurchOfBeefDB = nil` then `dofile` + `Init` restores `BOTTOM` / `0` / `80`; root drop leaves the global nil. `uiDb()` returns nil and does not create the global. |
| `dofile` restore pin | **Pass. Verified.** After root drop of `TOPLEFT` / `24` / `90`, `dofile` + `Init` restores `TOPLEFT`, parent `UIParent`, relative `TOPLEFT`, x `24`, y `90`. |
| Quiet Init with a saved point still hides | **Pass. Verified.** After `ResetForTests` leaves SV, Quiet `Init` keeps `IsShown() == false` and still restores the saved point onto `UIParent`. Reviewer probe: same. |
| ESC `ClearFocus` stays; not on `UISpecialFrames`; WIDTH / HEIGHT unchanged | **Pass. Verified.** Persist-path re-pins: box ESC still `ClearFocus`s and does not Hide; `ChurchOfBeefInputs` is not listed; frame stays 328×72. Source still has `SetMultiLine(true)` / `OnEscapePressed`. No `PlaySound`, no `OnUpdate`, no `BackdropTemplate`, no `SUMMON`, no `Popes` / `IsRegisteredPope`. |
| Isolated suite not exit 0 | **Pass. Verified.** 386 passed, 0 failed. Writer-reported count matches. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Net, Console, glue; no commit | **Pass.** Named-risk check. |
| Persist `ChurchOfBeefDB.ui.inputs` flat `{ point, relativePoint, x, y }` HUD pattern | **Pass.** `savePoint` writes those four keys only. Restore always parents to `UIParent`. |
| `SetMovable(true)`, `RegisterForDrag("LeftButton")` on the **root**; save on root `OnDragStop` after `StopMovingOrSizing` | **Pass.** Handlers are on the root widget. `OnDragStop` is `StopMovingOrSizing` then `savePoint(self)`. `GetPoint(1)` is the root. |
| Restore in `build()` before the default `SetPoint`; invalid / missing → `BOTTOM`, `UIParent`, `0`, `80` | **Pass.** `restorePoint(widget)` replaced the hardcoded default `SetPoint` in `build()`. Else branch is `DEFAULT_POINT` / `DEFAULT_X` / `DEFAULT_Y` (`BOTTOM` / `0` / `80`). |
| Never store `relativeTo`; source has no `relativeTo` string | **Pass.** Named-risk check. |
| Missing `ChurchOfBeefDB` → default restore; save no-ops | **Pass.** Named-risk check. |
| `ResetForTests` must not wipe SavedVariables | **Pass.** Hatch still only nils target / id / view / widget under `_IN_TEST`. Pin: saved `TOPLEFT` survives `reset()`. |
| Quiet hide unchanged | **Pass.** Named-risk check. Event Show after persist still paints. |
| Not on `UISpecialFrames`; ESC still `ClearFocus` only | **Pass.** Named-risk check. Hide stays Runtime Quiet, not box ESC. |
| No Pope-name lookup; no SUMMON; no `PlaySound`; Inputs stay stock | **Pass.** Source pins and `sounds == 0` through the persist block. `InputBoxTemplate` / `UIPanelButtonTemplate` stay. No custom media. |
| WIDTH 328 HEIGHT 72 unchanged | **Pass.** Constants and persist-path pins. Reviewer probe: source still `328, 72`. |
| No `OnUpdate`; no `BackdropTemplate` requirement | **Pass.** Source has neither. Drop leaves no animator. |
| Isolation wrap stays; `lua tests/test_inputs.lua` exit 0 | **Pass. Verified.** **386 / 0.** Wrap is still **24** pins under the first `if standalone then`. `runB14B()` re-pins 6; `runB15A()` re-pins the same six. |

Bible §13.1 / §18.5 (injected whisper target; inputs never trigger public theater), Law 6 (Quiet chrome stays off), and Law 10 / license 4 (stock Event chrome, no custom media, no `PlaySound`) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; harness `GetPoint` / `SetPoint` is a stub | **Not a spec miss.** Brief asked isolated `tests/test_inputs.lua`. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| Real `StopMovingOrSizing` may rewrite the widget point before save | **Not a miss.** Brief asked save after `StopMovingOrSizing`. Tests pin the stub: `SetPoint` then root drop stores that point. HUD / B14-C leftover. |
| `uiDb()` creates `ChurchOfBeefDB.ui` when the global exists but `ui` is missing | **On contract.** HUD pattern. Brief no-ops only a missing global. Reviewer probe: `ChurchOfBeefDB = {}` then drop creates `ui.inputs`. |
| Gate W / Gate V stay OPEN; lane not signed | **On contract.** This review does not sign either. |

---

## Isolation / persist / Quiet / ESC

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + Inputs. **24** nil-module / no-slash pins under the first `if standalone then`. Wrap was not rewritten. Persist `dofile` reloads Inputs only. End-of-`runB15A` re-pins Console / Popes / Sender / Sound / Hud / slash. Reviewer probe after persist `dofile`: Console / Hud / Popes / Net / UI / DB stay nil.

**Persist — Pass.** Root drag, not a title bar (Inputs has none). `StopMovingOrSizing` then `savePoint` on the root. Flat four-field table, no frame. `dofile` + `Init` restores parented to `UIParent`. Invalid point / invalid relative / non-number `x` fall back to `BOTTOM` `0`,`80`. Missing global: default restore; save no-ops. Empty `ui.inputs` / empty `{}` take the same else branch.

**Quiet / ESC — Pass.** Saved point does not punch a Quiet hole. Box ESC still `ClearFocus`s and does not Hide. Not on `UISpecialFrames`. WIDTH / HEIGHT stay 328×72.

---

## Strengths

- HUD persist copied onto the stock Inputs root without pulling Hud.lua, Console, or Net into the lane. B14-B ESC / `SetMultiLine(true)` stay. No `PlaySound`, no `OnUpdate`, no `BackdropTemplate`, no custom media, no Pope lookup.
- Save is on the **root** drop and reads the root widget, which is the brief's difference from the dock (dock drags the TitleBar).
- `ResetForTests` still only nils widget / view. Missing `ChurchOfBeefDB` does not mint the global.
- Writer-reported **386 / 0** and **24** isolation pins matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

None that this exclusive pair opened. Client `/reload` drag persist remains unproven; that is the writer's own ceiling, not a brief miss.

### Nit

1. **Harness `StopMovingOrSizing` does not rewrite `GetPoint`.** The suite `SetPoint`s then fires root `OnDragStop`. Anniversary may emit a different relative / offset after the stop. HUD / B14-C leftover. **POLISH:CANDIDATE** only.

2. **Invalid-relative and non-number `x` are code-true, not suite-pinned.** The suite only plants `MIDDLE-OF-NOWHERE` as `point`. Reviewer probe: invalid `relativePoint` and string `x` fall back; missing `relativePoint` uses `point`.

3. **Isolation wrap is load-time only.** Persist `dofile` re-asserts six modules, not the original 24. Wrap text is unchanged; the cluster still sits before Quiet Init.

4. **`uiDb()` will create `ChurchOfBeefDB.ui` when the global exists without `ui`.** HUD same. Brief only named a missing global.

5. **`Init` is idempotent and will not re-apply a mutated SV point onto a live frame.** `restorePoint` runs only inside `build()`. `/reload` rebuilds. HUD same.

6. **Stock 328×72 chrome leaves a thin root-drag strip.** Box + three `EnableMouse` buttons occupy most of the bar; the brief locked HEIGHT and named the **root**, not a handle. In-game drag is unproven. See leftover.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **386 / 0** was re-run here. Sibling dirt in Console / Hud / glue / TOC / `run.lua` is other lanes.

---

## Leftovers

- **Client Anniversary drag after `/reload`.** Harness `GetPoint` / `SetPoint` / `StopMovingOrSizing` are stubs. Writer already flagged this. Not a spec miss.
- **`Core/DB.lua` `defaultUi()` still names `point` / `shown` / `announce` only.** `applyDefaults` does not delete unknown future fields (`ui.inputs` survives `DB:Init` / `DB:Save`). Exclusive pair is Inputs + suite; this is documentation leftover, same as `ui.hud` / `ui.consoleDock`.
- Gate W stays OPEN. Gate V stays OPEN.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** `lua tests/test_inputs.lua` **386 passed, 0 failed**, exit 0. Isolation wrap **24**.

Root drop writes flat `{ point, relativePoint, x, y }` to `ChurchOfBeefDB.ui.inputs` with no `relativeTo`. `dofile` + `Init` restores parented to `UIParent`. Invalid / missing saved point falls back `BOTTOM` `0`,`80`. Missing `ChurchOfBeefDB` save no-ops. Quiet Init with a saved point still hides. ESC still `ClearFocus` only. Not on `UISpecialFrames`. WIDTH 328 / HEIGHT 72 stay. `ResetForTests` does not wipe SV. Inputs stay stock Event chrome: no Pope lookup, no SUMMON, no `PlaySound`, no custom media, no `OnUpdate`.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
