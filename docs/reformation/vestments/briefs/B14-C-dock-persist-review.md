Spec PASS

# B14-C — ConsoleDock drag persist (review)

**Quality:** Approved-with-nits

**Lane:** B14-C ConsoleDock drag persist
**Brief:** `docs/reformation/vestments/briefs/B14-C-dock-persist.md`
**Writer report:** `docs/reformation/vestments/briefs/B14-C-dock-persist-report.md`
**Diff:** `docs/reformation/vestments/briefs/B14-C-dock-persist.diff` (exclusive-pair packet: `UI/ConsoleDock.lua` + `tests/test_console_dock.lua`)
**Exclusive files:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/ConsoleDock.lua` (`ANCHORS` / `uiDb` / `savePoint` / `restorePoint` / TitleBar `OnDragStop` / `build` / `ResetForTests` / `mayShow`), and `tests/test_console_dock.lua` (TitleBar drag persist, `dofile` restore, invalid fallback, Quiet hide, missing-DB no-op, isolation wrap); then ran `lua tests/test_console_dock.lua` (**207 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §18.1 (collapsible movable Director Console); Law 6 / §19.1 (Quiet hide stays); Law 10 / §19.3 (functional / stock templates); HUD `savePoint` / `restorePoint` in `addon/ChurchOfBeef/UI/Hud.lua`; CONTINUE 2026-08-18 license 4 (stock only). Did not mutate `ConsoleDock.lua` or `test_console_dock.lua`. Did not commit. Did not edit Console.lua, Hud.lua, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Exclusive file breach (Console / Hud / glue) | **Pass.** Provided diff is two `diff --git` hunks: `UI/ConsoleDock.lua` and `tests/test_console_dock.lua`. Live persist sites match that slice (`consoleDock` keyed HUD helpers; TitleBar drop saves the dock widget; `restorePoint` in `build()`). `Console.lua` / `Hud.lua` have no `consoleDock` string. Sibling dirt in this workspace (Console, Hud, TOC, glue, `tests/run.lua`) is other lanes. |
| `ANCHORS` whitelist | **Pass. Verified.** Nine HUD anchors. Restore requires `ANCHORS[p.point]` and `ANCHORS[relative]` plus numeric `x` / `y`. Pin: `MIDDLE-OF-NOWHERE` falls back `BOTTOMLEFT` / `UIParent` / `16` / `80`. Reviewer probe: invalid `relativePoint` with a valid `point` also falls back; string `x` falls back; missing `relativePoint` uses `point`. |
| Missing `ChurchOfBeefDB` no-op | **Pass. Verified.** Pin: `ChurchOfBeefDB = nil` then `dofile` + `Init` restores default; TitleBar drop leaves the global nil. `uiDb()` returns nil and does not create the global. |
| `dofile` restore pin | **Pass. Verified.** After TitleBar drop of `TOPLEFT` / `24` / `90`, `dofile` + `Init` restores `TOPLEFT`, parent `UIParent`, relative `TOPLEFT`, x `24`, y `90`. |
| Quiet Init with a saved point still hides | **Pass. Verified.** After `ResetForTests` leaves SV, Quiet `Init` keeps `IsShown() == false` and still restores the saved point onto `UIParent`. Title / SANCTION / Expand / hidden CloseButton stay. Reviewer probe: live event + non-Pope still hides and still restores. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Console.lua, Hud, glue; no commit | **Pass.** Named-risk check. |
| Persist `ChurchOfBeefDB.ui.consoleDock` flat `{ point, relativePoint, x, y }` HUD pattern | **Pass.** `savePoint` writes those four keys only. `GetPoint(1)` discards `relativeTo` with `_`. Reviewer probe: saved table keys are exactly `point,relativePoint,x,y`. |
| Save on TitleBar `OnDragStop` after `StopMovingOrSizing`; restore in `build()` | **Pass.** Handler is `widget:StopMovingOrSizing()` then `savePoint(widget)` (dock, not title bar). Root `OnDragStop` is nil. `restorePoint(widget)` replaced the hardcoded default `SetPoint` in `build()`. |
| Invalid / missing saved point → `BOTTOMLEFT`, `UIParent`, `16`, `80` | **Pass.** Named-risk check. Missing global takes the same else branch. |
| Never store `relativeTo`; source has no `relativeTo` string | **Pass.** Pin `saved.relativeTo == nil`. Source pin `src:find("relativeTo") == nil`. Restore always parents to `UIParent`. |
| Quiet hide stays; Event-only `mayShow` | **Pass.** `mayShow` is still live event + registered Pope. Quiet Init / Quiet Show / EndEvent pins stay. Persist Quiet pin is named-risk. |
| Stock `BasicFrameTemplate`; title exactly `DIRECTOR CONSOLE`; CloseButton hidden | **Pass.** Existing pins plus persist-path re-pins. |
| No `PlaySound`; no custom media; no `OnUpdate` | **Pass.** Source pins and `sounds == 0` through the persist block. Drop leaves no animator. |
| `ResetForTests` must not wipe SV | **Pass.** `ResetForTests` nils widget / view under `_IN_TEST` only. Pin: saved `TOPLEFT` survives `reset()`. |
| Isolation wrap stays; `lua tests/test_console_dock.lua` exit 0 | **Pass. Verified.** **207 / 0.** Writer-reported count matches. Wrap is still **24** pins under `if standalone then`. |

Bible §18.1 (movable Director Console), Law 6 (Quiet chrome stays off), and Law 10 / license 4 (stock `BasicFrameTemplate`, no custom media, no `PlaySound`) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; harness `GetPoint` / `SetPoint` is a stub | **Not a spec miss.** Brief asked isolated `tests/test_console_dock.lua`. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| Real `StopMovingOrSizing` may rewrite the widget point before save | **Not a miss.** Brief asked save after `StopMovingOrSizing`. Tests pin the stub: `SetPoint` then TitleBar drop stores that point. HUD has the same leftover. |
| `uiDb()` creates `ChurchOfBeefDB.ui` when the global exists but `ui` is missing | **On contract.** HUD pattern. Brief no-ops only a missing global. Reviewer probe: `ChurchOfBeefDB = {}` then drop creates `ui.consoleDock`. |
| Gate W / Gate V stay OPEN; lane not signed | **On contract.** This review does not sign either. |

---

## Isolation / persist / Quiet

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + ConsoleDock. **24** nil-module / no-slash pins under `if standalone then` (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Decree, slash). Wrap was not rewritten. Persist `dofile` reloads ConsoleDock only.

**Persist — Pass.** TitleBar drag, not root. `StopMovingOrSizing` then `savePoint` on the dock. Flat four-field table, no frame. `dofile` + `Init` restores parented to `UIParent`. Invalid point / invalid relative / non-number `x` fall back to `BOTTOMLEFT` `16`,`80`. Missing global: default restore; save no-ops.

**Quiet / Event-only — Pass.** Saved point does not punch a Quiet hole. `mayShow` is unchanged. Congregation during a live event still hides.

---

## Strengths

- HUD persist copied onto the stock dock without pulling Hud.lua or Console.lua into the lane. Title stays `DIRECTOR CONSOLE`. CloseButton stays hidden. No `PlaySound`, no `OnUpdate`, no custom media.
- Save is on the TitleBar drop and reads the **dock** widget, which is the brief's difference from HUD (HUD drags the root).
- `ResetForTests` still only nils widget / view. Missing `ChurchOfBeefDB` does not mint the global.
- Writer-reported **207 / 0** and **24** isolation pins matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

None that this exclusive pair opened. Client `/reload` drag persist remains unproven; that is the writer's own ceiling, not a brief miss.

### Minor

1. **Harness `StopMovingOrSizing` does not rewrite `GetPoint`.** The suite `SetPoint`s then fires TitleBar `OnDragStop`. Anniversary may emit a different relative / offset after the stop. HUD leftover. **POLISH:CANDIDATE** only.

2. **Invalid-relative and non-number `x` are code-true, not suite-pinned.** The suite only plants `MIDDLE-OF-NOWHERE` as `point`. Reviewer probe: invalid `relativePoint` and string `x` fall back.

3. **Isolation wrap is load-time only.** Persist `dofile` does not re-assert the 24 nil-module pins. Wrap text is unchanged; the cluster still sits before Quiet Init.

4. **`uiDb()` will create `ChurchOfBeefDB.ui` when the global exists without `ui`.** HUD same. Brief only named a missing global.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **207 / 0** was re-run here. Sibling dirt in Console / Hud / glue / TOC / `run.lua` is other lanes.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** `lua tests/test_console_dock.lua` **207 passed, 0 failed**, exit 0. Isolation wrap **24**.

Title-bar drop writes flat `{ point, relativePoint, x, y }` to `ChurchOfBeefDB.ui.consoleDock` with no `relativeTo`. `dofile` + `Init` restores parented to `UIParent`. Invalid / missing saved point falls back `BOTTOMLEFT` `16`,`80`. Missing `ChurchOfBeefDB` save no-ops. Quiet Init with a saved point still hides. `ResetForTests` does not wipe SV. Dock stays stock `BasicFrameTemplate`, titled `DIRECTOR CONSOLE`, CloseButton hidden, no `PlaySound`, no custom media, no `OnUpdate`. Event-only `mayShow` unchanged.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
