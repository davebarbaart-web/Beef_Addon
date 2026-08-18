Spec PASS

# B40-A — Console Hide remounts missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B40-A Console Hide remounts a missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B40-A-console-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B40-A-console-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B40-A-console-onhide.diff` (B40-A-only exclusive-pair packet; live `Console.lua` / `test_console.lua` also carry earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`Hide` ~1173–1178 / `wireConsoleOnHide` ~532–540 / create-path wire after create-time Hide ~552–555 / `Show` ~1165–1171 / `Init` ~1127–1135 / `Refresh` ~1137–1139 / `rememberSpecial` ~520–526 / `OpenRite` ~1530–1573 / `SaveNote`), and `tests/test_console.lua` (isolation wrap, nested `runB40A()` inside `runB8E()` after `runB39A()`); then ran `lua tests/test_console.lua` (**2930 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC closes a **named** frame on `UISpecialFrames` (`FRAME_NAME` is `ChurchOfBeefConsoleFrame`); ESC / `CloseSpecialWindows` bypass `Console:Hide`; Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock Director Console; no parchment); Bible §18.1 leftover highlight; B29-A leftover (`Hide` remounted `rememberSpecial` then `frame:Hide()` only; no OnHide, so a wiped list stayed idle until Show / Init / Refresh / Hide); B39-A keep (do not refuse empty OpenRite Gora). Live existing-frame `Hide` remounts a missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `self.frame:Hide()`. OnHide remounts `rememberSpecial`. Existing script is not replaced. Selection / pair / Recommend stay. Empty OpenRite Gora still opens. `SaveNote` nil. No SUMMON. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit glue, Dock, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Hide still has no OnHide remount | **Pass. Verified.** Live `Hide` (~1173–1178) is `wireConsoleOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)` then `self.frame:Hide()`. Helper (~532–540) wires only when `GetScript("OnHide")` is nil. Nested source pin: `wireConsoleOnHide` before `rememberSpecial` before `self.frame:Hide()`. Nested wrap: wipe list, nil OnHide, Show (handler stays nil), Hide restores OnHide and lists `ChurchOfBeefConsoleFrame` once. Reviewer probe: niled handler stays nil across Show / Init / Refresh; `Console:Hide()` restores it, including while already hidden. After remount, wipe + widget `Hide()` (not `Console:Hide`) re-lists the name once. Hide with `Console.frame` nil still returns. |
| Existing OnHide replaced | **Pass. Verified.** Helper is `if existing then return`. Nested: second Hide and third Hide keep the restored identity; third Hide still lists the name once. Create-path identity is not inlined (`SetScript("OnHide"` absent from `buildFrame`). Reviewer spy: a sentinel OnHide survives `Console:Hide` / a third Hide and still fires once on the shown→hidden transition. |
| Selection / pair / Recommend reset | **Pass. Verified.** Live `Hide` / `wireConsoleOnHide` do not assign `selectedFighterA` / `B`, `selectedHumanId`, or `lastRecommendation`. Nested: after SelectFighters / SelectHuman / Recommend, wipe + nil OnHide + Show + Hide keeps A / B / human; Show after Hide keeps the painted Recommend text; third Hide still keeps A / B / human. Reviewer probe matches. Hide does not call `Refresh`. |
| Empty OpenRite Gora refused | **Pass. Verified.** Live Gora branch still uses selected A/B, else live `GetSanctioned` only. No `GetLastSanctioned`. No `return nil, "a Gora needs"`. Nested: `reset` + StartEvent + `OpenRite("Gora")` with empty desk pair opens `RITE` / `Gora`. Reviewer probe matches. |
| `SaveNote` / SUMMON / parchment | **Pass.** `Console.SaveNote` is nil before and after the nested block. Source has no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `Parchment`, no `PanelTabButtonTemplate`. Nested chrome pins stay. Reviewer probe: no SUMMON button after the remount sequence. |
| `PlaySound` | **Pass.** Live `Console.lua` has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Nested wrap: `PlaySound` / `PlaySoundFile` / `PlaySoundKitID` stay **0** across remount Hide and third Hide. Reviewer spy matches. No `IG_CHARACTER_INFO_*`. No OnShow re-wire. |
| Not nested after `runB39A()` | **Pass.** `runB40A()` is a nested `local function` inside `runB8E()` after the `runB39A()` call (`test_console.lua` ~5795 / ~5809–6099). Packet adds no main-chunk `local`. Header comment only at file top. `luac -l -p`: main chunk **186** slots (cap 200). New `wireConsoleOnHide` is the required Console helper. |
| Isolated suite not exit 0 | **Pass. Verified.** 2930 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**17** nil pins). `runB40A()` re-pins 4 of them plus `COB.Popes`. Packet is the two named files. Sibling dirt vs HEAD is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, Dock, MainFrame; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| Extract `wireConsoleOnHide` (never replace an existing script) | **Pass.** Named-risk check. Brief vs `Console.lua` ~532–540. |
| Existing-frame Hide: remount missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `frame:Hide()` | **Pass.** Named-risk check. Live `Hide` ~1173–1178. Nested source pin: that order. |
| OnHide remounts `rememberSpecial` so ESC still re-lists | **Pass.** Handler is `rememberSpecial(FRAME_NAME)`. Nested wipe + Show + Hide lists the name once. Reviewer probe: after remount, wipe + widget Hide re-lists once. |
| Do not reset selection / pair / Recommend | **Pass.** Named-risk check. |
| No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. Wrapped `CreateFrame` **0**. Same frame pointer. |
| Do not refuse empty OpenRite Gora | **Pass.** Named-risk check. |
| `SaveNote` stays nil. No SUMMON. No parchment. No tabs | **Pass.** Named-risk check. |
| Nest `runB40A()` after `runB39A()` inside `runB8E()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **2930 / 0.** Wrap **17**. |

Wiki ESC holds on the exclusive pair: a missing OnHide is remounted on `Console:Hide` so a later ESC Hide can re-list `ChurchOfBeefConsoleFrame`. Law 6 / §19.4 hold: no panel whoosh. Law 10 / §19.3 hold: stock desk, no parchment / tabs / SUMMON. License 4 holds: `SaveNote` stays nil. B29-A Hide `rememberSpecial` remount stays. B28-A Show / Refresh remount stay. B27-A Init remount stays. B39-A empty OpenRite Gora still opens. B14-D scan-then-append stays.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Widget Hide / ESC does not remount a niled OnHide | **On contract.** Brief scoped `Console:Hide` remount. The missing handler cannot remount itself. Reviewer probe: niled OnHide + widget Hide leaves the wiped list empty. |
| Show / Init / Refresh remount still skip a niled OnHide | **On contract.** Brief asked Hide-only remount and no OnShow re-wire. Nested pins: Show / Init / Refresh do not call `wireConsoleOnHide`. |
| No client smoke. Real ESC vs `CloseSpecialWindows` on Anniversary is unproven | **Not a miss.** Brief asked the isolated suite. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. A dropped handler is simulated by `SetScript("OnHide", nil)`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key | **On contract.** Script identity, membership counts, and selection / pair / Recommend persist are pinned; the client's special-frame walk is not. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B29 leftover (`Hide` remounted `rememberSpecial` then `frame:Hide()` only; ESC bypassed `Console:Hide` and there was no OnHide, so a wiped list stayed idle until Show / Init / Refresh / Hide) is this lane's spec. It is closed on the exclusive pair for the `Console:Hide` path.

---

## Isolation / remount / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Dock, glue, UI shell, Net, DB, Roster, or Confession. Standalone wrap is still **17** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Nested B40-A re-pins Archive / UI / Toasts / Confession / Popes after restore.

**Remount — Pass.** `wireConsoleOnHide` no-ops when a script exists and writes `rememberSpecial(FRAME_NAME)` only when OnHide is nil. Existing-frame Hide remounts the missing handler, then remounts `rememberSpecial`, then hides. Create-path calls the helper after create-time `frame:Hide()` so mint Hide does not fire the remount. Show / Init / Refresh still remount `rememberSpecial` and do not remount OnHide. Reviewer spy: wipe + widget Hide after remount lists the name once; niled handler + widget Hide does not; already-hidden `Console:Hide()` still restores the handler; Toggle remounts because Toggle calls Hide. Same frame pointer. Wrapped `CreateFrame` **0**.

**Keep — Pass.** B29-A Hide `rememberSpecial` remount stays. B28-A Show / Refresh remount stay. B27-A Init remount stays. B14-D scan-then-append stays. B39-A OpenRite Gora live `GetSanctioned` fallback stays; empty pair still opens; `GetLastSanctioned` fallback stays gone. Selection / pair / Recommend stay across Hide. `SaveNote` nil. No SUMMON / parchment / tabs / `PlaySound`. `FRAME_NAME` stays `ChurchOfBeefConsoleFrame`.

---

## Strengths

- The delta is the brief: extract `wireConsoleOnHide`, remount a missing handler on existing-frame Hide, then keep the B29-A `rememberSpecial` remount. An existing script is not replaced. Show / Init / Refresh / OpenRite were left alone.
- B29's leftover (ESC Hide with no OnHide left a wiped list idle until Show / Init / Refresh / Hide) is closed on the `Console:Hide` path, not a second register helper. Third-Hide identity sits next to the wipe remount, so a replace-every-Hide helper would fail.
- Selection / pair / Recommend keeps and the empty OpenRite Gora keep sit next to the remount, so a blanket desk reset or a new empty-pair refuse would fail.
- `runB40A()` sits after `runB39A()` inside `runB8E()`. Isolation wrap stays **17**. No new main-chunk locals. Writer-reported **2930 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **Widget Hide / ESC does not remount a niled OnHide.** The missing handler cannot remount itself. `CloseSpecialWindows` / `frame:Hide()` still bypass `Console:Hide`. A dropped OnHide that never hits `Console:Hide` still leaves a wiped list idle until Show / Init / Refresh / Hide. Brief scoped the `Console:Hide` remount.

2. **Show / Init / Refresh still skip a niled OnHide.** Brief asked Hide-only remount and no OnShow re-wire. A niled handler that only hits Show / Init / Refresh stays idle until Hide.

### Nit

1. **Wipe + Show + Hide re-list-once is also the B28-A Show remount.** Nested pin proves OnHide is restored and the name is not duplicated. OnHide's own `rememberSpecial` after a post-Show wipe is a reviewer widget-Hide probe, not an in-lane behavioral pin.

2. **Recommend keep is painted text after Show / Refresh**, not a direct `lastRecommendation` field read (that binding is a Console file local). Hide does not call Refresh; the paint match still fails if Hide niled the leftover.

3. **Toggle remount and already-hidden `Console:Hide()` remount are reviewer probes**, not nested pins. Toggle remounts only because Toggle calls Hide.

4. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B40-A-only helper + Hide remount + nested pins. Report already says this.

5. **Isolation wrap is load-only.** Seventeen pins under the first `if standalone then`. Nested B40-A re-pins four of them plus Popes. Brief said the wrap stays; it did.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **2930 / 0** was re-run here. Live ESC vs `CloseSpecialWindows` after a dropped OnHide is unproven on Anniversary.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: extract `wireConsoleOnHide` (never replace); existing-frame Hide remounts missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `frame:Hide()`; OnHide remounts `rememberSpecial`; do not reset selection / pair / Recommend; no OnShow re-wire; no rebuild; no `PlaySound`; do not refuse empty OpenRite Gora; `SaveNote` nil. Live `Hide` ~1173–1178 and `wireConsoleOnHide` ~532–540 match. Brief test pins sit in `runB40A()` after `runB39A()` inside `runB8E()`.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftovers: widget Hide / ESC still cannot remount a niled OnHide (brief scoped `Console:Hide`); Show / Init / Refresh skip a niled OnHide (Hide-only remount). Nits listed above.

**3. Isolation count:** **2930 passed, 0 failed.** Isolation wrap: **17**.

**4. Law:** Wiki ESC holds. After `Console:Hide` remounts a missing OnHide, a later ESC Hide can re-list `ChurchOfBeefConsoleFrame`. Law 6 / §19.4 hold: no panel whoosh. Law 10 / §19.3 hold: stock Event Mode desk; no parchment / tabs / SUMMON. License 4 holds: `SaveNote` stays nil. B29-A / B28-A / B27-A remounts stay. B39-A empty OpenRite Gora still opens.

**Leftovers:**
- Widget Hide / ESC does not remount a niled OnHide (Important, not must-fix; brief scoped `Console:Hide`).
- Show / Init / Refresh still skip a niled OnHide (Hide-only remount).
- Wipe + Show + Hide re-list-once is also Show remount (reviewer widget-Hide probe closed OnHide remount).
- Recommend keep is painted text after Show / Refresh.
- Toggle / already-hidden remount are reviewer probes.
- Exclusive-pair packet is not a vs-HEAD Console delta.
- Isolation wrap is load-only.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

Existing-frame `Hide` remounts a missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `frame:Hide()`. An existing OnHide is not replaced. Selection / pair / Recommend stay. Empty OpenRite Gora still opens. `SaveNote` stays nil. No SUMMON. No parchment. No `PlaySound`. `runB40A()` is nested inside `runB8E()` after `runB39A()`. Isolated `lua tests/test_console.lua` **2930 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
