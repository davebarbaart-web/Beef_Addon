Spec PASS

# B40-D — already-hidden Quiet-shell Hide still persists shown = false (review)

**Quality:** Approved-with-nits

**Lane:** B40-D already-hidden Quiet-shell Hide still persists `shown = false`
**Brief:** `docs/reformation/vestments/briefs/B40-D-shell-hidden-persist.md`
**Writer report:** `docs/reformation/vestments/briefs/B40-D-shell-hidden-persist-report.md`
**Diff:** `docs/reformation/vestments/briefs/B40-D-shell-hidden-persist.diff` (B40-D-only exclusive-pair packet; live `MainFrame.lua` / `test_ui.lua` also carry earlier Quiet-shell / toast / HideAll / B15-C / B19-B / B20-D / B21-C / B23-C / B24-C / B26-B / B27-C / B29-D / B31-C / B35-D / B39-C batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/MainFrame.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/MainFrame.lua` (`UI:Hide` exists-path ~602–610: `wireShellOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)` then `self:_StopSizing()` then `self.frame:Hide()` then `local ui = uiDb()` / `if ui then ui.shown = false end`; `uiDb` ~76–80; `wireShellOnHide` ~481–492 still returns when `GetScript("OnHide")` is set and writes `_StopSizing` + `ui.shown = false` only on a missing script; Show remount ~593–600; Init early-return ~498–503; create-path wire after OnShow ~535; `rememberSpecial` ~471–477; `FRAME_NAME` `"ChurchOfBeefFrame"` ~17), and `tests/test_ui.lua` (isolation wrap, `runB12D()` ~742–1479 with B35-D remount + persist immediately above, then nested B40-D source + already-hidden + niled OnHide + stale `shown = true` + remount + persist + second-Hide identity + Inputs-off pins ~1418–1471; reused `hideBody` / `hideWireAt` / `hideRememberAt` / `hideOnShow` / `existingHideShell` / `cuesHideRestore` / `restoredHideOnHide`); then ran `lua tests/test_ui.lua` (**642 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames` (do **not** PlaySound `IG_CHARACTER_INFO_*`); B35-D leftover (already-hidden `frame:Hide()` does not fire OnHide, so stale `ChurchOfBeefDB.ui.shown = true` stayed); Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / Bible §19.3 (functional Quiet shell stays stock `BasicFrameTemplate`). Did not mutate `MainFrame.lua` or `test_ui.lua`. Did not commit. Did not edit Toasts.lua, RecordsBook, Decree, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| already-hidden Hide still leaves `shown` true | **Pass. Verified.** Live exists-path writes `ui.shown = false` via the same `uiDb()` as OnHide after remount + `_StopSizing` + `frame:Hide()`. Nested: shell already hidden, OnHide niled, `shown = true`, `UI:Hide()` leaves `ChurchOfBeefDB.ui.shown == false`. Reviewer spy: remounted OnHide fire count **0** (stub / client only fire on shown→hidden); persist still false. Same persist with the existing OnHide left in place (body write is the only writer). Second already-hidden Hide keeps `shown == false`. |
| OnHide remount dropped | **Pass. Verified.** Exists-path still calls `wireShellOnHide(self.frame)` before remember / `_StopSizing` / `frame:Hide()` / the body write. Helper still wires only when `GetScript("OnHide")` is nil. Nested: already-hidden + niled OnHide restores a script. B35-D shown→hidden remount pin stays immediately above. Reviewer spy: niled already-hidden Hide `SetScript` named `OnHide` **1** time; shown→hidden Hide still remounts and the remounted handler **does** fire; Show / Init remount source stays. |
| existing OnHide replaced | **Pass. Verified.** Helper is still `if existing then return`. Nested: second already-hidden Hide keeps `restoredHideOnHide`. Reviewer spy: second already-hidden `SetScript` OnHide **0**; already-hidden Hide with the create-path script **0**; sentinel OnHide kept across a shown Hide. |
| `PlaySound` | **Pass.** Live `MainFrame.lua` has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Hide body has none. Nested `#played` unchanged on already-hidden Hide. Reviewer spy: `PlaySound` count **0** across the leftover sequence. |
| Inputs added to `UISpecialFrames` | **Pass.** Hide only `rememberSpecial(FRAME_NAME)`. `FRAME_NAME` stays `"ChurchOfBeefFrame"`. Nested: `countSpecial("ChurchOfBeefInputs") == 0` after already-hidden Hide. Live `Inputs.lua` still has no `UISpecialFrames` / `rememberSpecial`. Isolation suite does not load Inputs. |
| `Toasts.lua` edited | **Pass.** Exclusive-pair packet is two unified hunks (exists-path body write + header comment + nested B40-D pins). Packet has no `Toasts.lua`. `runB12D()` still *reads* Toasts.lua for prior B12-D / B26-B / B29-D pins; the writer did not edit that file this lane. Sibling dirt vs HEAD on Toasts is other toast batches. Reviewer did not edit `Toasts.lua`. |
| Isolated suite not exit 0 | **Pass. Verified.** 642 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the load-time `if standalone then` (**11** nil pins). `runB12D()` re-pins 4 of them. `luac -l -p`: main chunk **75** locals (cap 200); `runB12D()` **56**. Packet adds no main-chunk `local`. Nest is after the B35-D `UISpecialFrames = savedSpecial` restore inside `runB12D()`. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, Toasts.lua, RecordsBook; no commit; no `PlaySound` | **Pass.** Named-risk check. Reviewer did not commit. |
| Existing-frame Hide: after remount, write `shown = false` on the ui slot (same `uiDb()` as OnHide) even when the widget is already hidden | **Pass.** Named-risk check. Brief vs `MainFrame.lua` ~608–609. Nested already-hidden wrap + reviewer OnHide-fire spy. |
| Keep OnHide remount for ESC | **Pass.** Named-risk check. B35-D remount pins stay above this block. |
| Do not replace an existing OnHide. Do not rebuild. No OnShow re-wire | **Pass.** Named-risk check. Nested identity / OnShow keep / no inline `SetScript` / no `buildFrame`. Reviewer spy: `CreateFrame` delta **0**; niled OnShow stays nil. |
| Inputs stay off `UISpecialFrames`. No `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. |
| Nest after the B35-D block inside `runB12D()`. Already-hidden Hide: `shown` becomes false even if OnHide does not fire again. No new main-chunk locals | **Pass.** Named-risk check. `runB12D()` ~1418–1471 after B35-D. Reused B35-D locals. |
| Isolation wrap stays; `lua tests/test_ui.lua` exit 0 | **Pass.** **642 / 0.** Wrap **11**. |

B35 leftover (already-hidden Hide remounted OnHide but left stale `shown = true` because the stub and the client only fire OnHide on a shown→hidden transition) is this lane's spec. It is closed on the exclusive pair: exists-path Hide writes the ui slot after remount even when `frame:Hide()` does not fire OnHide. Law 6 / §19.4 hold: no panel whoosh. Law 10 / §19.3 hold: stock `BasicFrameTemplate`. Wiki ESC via `UISpecialFrames` still remounts `wireShellOnHide` for the closer that bypasses `UI:Hide`. Inputs stay off the list.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Hide / Show / Init still do not restore a missing OnShow | **On contract.** Brief forbids OnShow re-wire. Reviewer probe: niled OnShow stays nil after already-hidden Hide. |
| B35-D persist pin no longer exclusively exercises remounted OnHide | **On contract leftover.** Hide body now writes `shown = false`, so the B35-D "Hide remount persists shown = false" pin passes even if the remounted handler forgot that write. ESC persist still depends on the remounted handler. The already-hidden pin is the body-write proof. |
| Source pin does not lock persist after `frame:Hide` vs before | **On contract.** Pin requires `uiDb()` after remount / `rememberSpecial`. Live order is remount then `_StopSizing` then `frame:Hide()` then the write. Reviewer capture matches that live order. |
| No client smoke; harness `Hide()` is a direct call, not a real ESC key | **Not a miss.** Brief asked isolated green + already-hidden persist. `CloseSpecialWindows` order is unproven on Anniversary. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Isolation wrap is load-only | **On contract.** Brief said the wrap stays; it did. |
| Inputs-off pin does not load Inputs | **On contract.** Pin still fails if Hide listed `"ChurchOfBeefInputs"`. Live Inputs file has no special-frame register. |
| `UISpecialFrames = nil` and stub `_G["ChurchOfBeefFrame"]` stay unpinned | **On contract.** Not this brief. |
| Exclusive-pair diff is not a vs-HEAD MainFrame delta | **On contract.** Report already says this. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / clear / keep

**Isolation wrap — Pass.** Load-time standalone block is still **11** nils (Console, Hud, RecordsBook, Gora, Knighting, Runtime, Sound, Codec, Sender, Archive, Recognition). Runtime / Sound are dofiled later for Quiet / cue pins; wrap is load-time only (unchanged). `runB12D()` re-pins Console / Hud / Records Book / Gora (**4**). No `dofile` of Console / Hud / Records / Gora / Knighting / Net / Inputs. New asserts sit in `runB12D()` so Lua 5.1's 200-local cap does not fire. Writer's load-time standalone is the wrap (not the first helper `if standalone then`). Count is still 11.

**Persist — Pass.** After remount, exists-path Hide writes `shown = false` on the ui slot even when the widget is already hidden and OnHide does not fire. Nested wrap: already hidden, niled OnHide, stale `shown = true`, then `UI:Hide()` leaves `shown == false` and remounts the handler. Reviewer spy: remounted OnHide fire count **0** on that path; persist still false. Already-hidden Hide with the existing script also persists and does not `SetScript`. Second already-hidden Hide keeps `shown == false`.

**Keep — Pass.** OnHide remount stays (`wireShellOnHide` before remember / Hide / body write). An existing script is not replaced. The widget is not rebuilt. OnShow is not re-wired. Show remount (B31-C) and Init remount (B27-C) stay. `FRAME_NAME` stays `"ChurchOfBeefFrame"`. Inputs stay off the list. No `PlaySound`. Template stays `BasicFrameTemplate`. B35-D shown→hidden remount + persist pins stay immediately above.

---

## Strengths

- The delta is one exists-path write after the B35-D remount: `uiDb()` / `ui.shown = false`. An existing script is not replaced. The widget is not rebuilt. Show / Init remounts stay. `FRAME_NAME` stays `"ChurchOfBeefFrame"`.
- B35 leftover (already-hidden Hide remounted OnHide but left stale `shown`) is closed with a body write, not by forcing OnHide to fire. Reviewer spy: remounted handler fire count 0 and persist still false.
- Remount, second-Hide identity, Inputs-off, no-rebuild, and no-sound sit next to the persist pins, so a dropped remount, a replace-every-Hide helper, or a whoosh would fail.
- New asserts reuse B35-D locals inside `runB12D()` after the B35-D block. Isolation wrap stays **11**. No new main-chunk locals. `Toasts.lua` was not edited.
- Writer-reported **642 / 0** matched the re-run. Writer-reported red (**636 / 6**) matches the missing body `uiDb()` / `shown = false` + already-hidden leftover-`shown` cluster that pre-B40-D Hide would fail.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **B35-D persist pin no longer exclusively exercises remounted OnHide.** Hide body now writes `shown = false`, so the B35-D "Hide remount persists shown = false" pin passes even if the remounted handler forgot that write. ESC persist still depends on the remounted handler (`CloseSpecialWindows` bypasses `UI:Hide`). The already-hidden pin is the body-write proof.

2. **Hide / Show / Init still do not restore a missing OnShow.** Reviewer probe: niled OnShow stays nil after already-hidden Hide. Brief forbids OnShow re-wire. A remount that dropped OnShow would skip `shown = true` and the roster kick. Outside this brief.

3. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the Quiet shell, Proclaim, and the small toast together. Harness `Hide()` is a direct call, not a real ESC key.

### Nit

1. **Already-hidden nest does not spy OnHide fire count.** Persist + already-hidden + stub (no OnHide unless shown→hidden) is the proof. Reviewer spy closed fire count **0**. A later stub that fired OnHide on a no-op Hide would make the remounted handler look sufficient.

2. **Source pin does not lock persist after `frame:Hide` vs before.** It requires `uiDb()` after remount / `rememberSpecial`. Live order is remount then `_StopSizing` then `frame:Hide()` then the write.

3. **Second-Hide identity is vacuous if remount failed.** `nil == nil` would pass on a niled leftover. The remount pin fails first; the identity pin is a keep after that.

4. **B40-D re-pins no-OnShow / no-inline-SetScript / no-rebuild / no-PlaySound already on the B35-D `hideBody`.** Necessary keep language; not a new lock.

5. **Isolation wrap is load-only.** Eleven pins under the load-time `if standalone then` (not the first helper `if standalone then`). `runB12D()` re-pins four. Brief said the wrap stays; it did.

6. **Exclusive-pair diff is not a vs-HEAD MainFrame delta.** Packet is the B40-D-only persist write + nested pins. `git diff HEAD` on the two files still includes earlier Quiet-shell / toast / HideAll batches. Report already says this.

7. **Inputs-off pin does not load Inputs.** Isolation never `dofile`s `Inputs.lua`. The pin still fails if Hide listed `"ChurchOfBeefInputs"`. Live Inputs file has no special-frame register.

8. **`UISpecialFrames = nil` and stub `_G["ChurchOfBeefFrame"]` stay unpinned.** `rememberSpecial` no-ops when the global is not a table. Stub `CreateFrame` still does not mint `_G.ChurchOfBeefFrame`.

9. **No full `lua tests/run.lua`.** Isolated **642 / 0** was re-run here. Live already-hidden Hide persist is unproven on Anniversary.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: existing-frame Hide writes `shown = false` via `uiDb()` after remount even when the widget is already hidden; keep OnHide remount; do not replace an existing OnHide; do not rebuild; no OnShow re-wire; Inputs stay off `UISpecialFrames`; no `PlaySound` / `IG_CHARACTER_INFO_*`. Live `UI:Hide` ~602–610 matches. Brief test pins sit after B35-D inside `runB12D()`.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftovers: B35-D persist pin is no longer exclusive to remounted OnHide (ESC still depends on the helper); missing OnShow restore is forbidden by the brief; no Anniversary ESC smoke. Nits listed above.

**3. Isolation count:** **642 passed, 0 failed.** Isolation wrap: **11**. `runB12D()` re-pins: **4**. Main-chunk locals: **75 / 200**. `runB12D()` locals: **56 / 200**.

**4. Law:** Law 6 / §19.4 hold: Quiet Hide stays silent; no panel whoosh. Law 10 / Bible §19.3 hold: functional Quiet shell stays stock `BasicFrameTemplate`. Wiki ESC via `UISpecialFrames` still remounts `wireShellOnHide` for the closer that bypasses `UI:Hide`. B35 leftover is closed on the exclusive pair: already-hidden Hide persists `shown = false` even when OnHide does not fire. Inputs stay off the list.

**Leftovers:**
- B35-D persist pin no longer exclusively exercises remounted OnHide (Important, not must-fix; ESC still depends on the helper).
- Hide / Show / Init still do not restore a missing OnShow (brief forbids OnShow re-wire).
- No Anniversary ESC / `CloseSpecialWindows` smoke; harness `Hide()` is not a real ESC key.
- Already-hidden nest does not spy OnHide fire count (reviewer probe: 0).
- Source pin does not lock persist after `frame:Hide` vs before.
- Isolation wrap is load-only.
- Exclusive-pair packet is not a vs-HEAD MainFrame delta.
- Inputs-off pin does not load Inputs.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

Exists-path `UI:Hide` still remounts OnHide for ESC, then writes `shown = false` via `uiDb()` so an already-hidden widget does not leave a stale `shown = true`. An existing script is not replaced. The widget is not rebuilt. OnShow is not re-wired. No `PlaySound`. Inputs stay off the list. `runB12D()` nests the pins after B35-D. Isolated `lua tests/test_ui.lua` **642 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
