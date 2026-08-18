Spec PASS

# B41-A — Console Refresh remounts missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B41-A Console Refresh remounts a missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B41-A-console-refresh-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B41-A-console-refresh-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B41-A-console-refresh-onhide.diff` (B41-A-only exclusive-pair packet; live `Console.lua` / `test_console.lua` also carry earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`Refresh` ~1138–1165 / `wireConsoleOnHide` ~533–541 / create-path wire after create-time Hide ~555–556 / `Hide` ~1175–1180 / `Show` ~1167–1173 / `Init` ~1128–1136 / `rememberSpecial` ~521–527 / `OpenRite` ~1532–1575 / `SaveNote`), and `tests/test_console.lua` (isolation wrap, nested `runB41A()` inside `runB8E()` after `runB40A()`, B40-A Refresh keep-string ~5932–5941); then ran `lua tests/test_console.lua` (**3045 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC closes a **named** frame on `UISpecialFrames` (`FRAME_NAME` is `ChurchOfBeefConsoleFrame`); glue `Runtime:EndEvent` Refreshs the desk, so a niled OnHide stayed idle until Hide while Refresh remounted `rememberSpecial` only; Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock Director Console; no parchment); Bible §18.1 leftover highlight; B31-A keep (QUIET Refresh still nils Recommend; does not reset selection / pair); B39-A keep (do not refuse empty OpenRite Gora); B40-A leftover (Refresh skip of `wireConsoleOnHide` was pinned). Live existing-frame `Refresh` remounts a missing OnHide (`wireConsoleOnHide`), then `rememberSpecial(FRAME_NAME)`. OnHide remounts `rememberSpecial`. Existing script is not replaced. Selection / pair stay. Live-event Recommend stays; QUIET Refresh still nils Recommend. Empty OpenRite Gora still opens. `SaveNote` nil. No SUMMON. Show has no direct `wireConsoleOnHide` (Show already Refreshs). B40-A Refresh keep-string now requires `wireConsoleOnHide` before `rememberSpecial`. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit glue, Dock, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Refresh still skips `wireConsoleOnHide` | **Pass. Verified.** Live `Refresh` (~1138–1165) is `if not self.frame then return end`, then `wireConsoleOnHide(self.frame)`, then `rememberSpecial(FRAME_NAME)`, then paint. Helper (~533–541) wires only when `GetScript("OnHide")` is nil. Nested source pin: `wireConsoleOnHide` before `rememberSpecial(FRAME_NAME)`. Nested wrap: wipe list, nil OnHide, Refresh restores OnHide and lists `ChurchOfBeefConsoleFrame` once. Reviewer probe: niled handler stays nil across Init; `Console:Refresh()` restores it, including while already hidden. Nil-frame Refresh still returns and does not touch the old widget. After remount, wipe + widget `Hide()` (not `Console:Hide`) re-lists the name once. |
| Existing OnHide replaced | **Pass. Verified.** Helper is `if existing then return`. Nested: second Refresh and third Refresh keep the restored identity; third Refresh still lists the name once. Create-path identity is not inlined (`SetScript("OnHide"` absent from `buildFrame`). Reviewer spy: a sentinel OnHide survives `Console:Refresh` / a third Refresh and still fires once on the shown→hidden transition. |
| Selection / pair / Recommend reset | **Pass. Verified.** Live `Refresh` / `wireConsoleOnHide` do not assign `selectedFighterA` / `B` or `selectedHumanId`. Nested: after SelectFighters / SelectHuman / Recommend, wipe + nil OnHide + Refresh keeps A / B / human and the painted Recommend text; third Refresh still keeps A / B / human. `Runtime:EndEvent` then Refresh still nils Recommend (B31-A) and keeps A / B. Reviewer probe matches, including human after QUIET Refresh. |
| Empty OpenRite Gora refused | **Pass. Verified.** Live Gora branch still uses selected A/B, else live `GetSanctioned` only. No `GetLastSanctioned`. No `return nil, "a Gora needs"` inside `OpenRite`. Nested: `reset` + StartEvent + `OpenRite("Gora")` with empty desk pair opens `RITE` / `Gora`. Reviewer probe matches. |
| `SaveNote` / SUMMON / parchment | **Pass.** `Console.SaveNote` is nil before and after the nested block. Source has no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `Parchment`, no `PanelTabButtonTemplate`. Nested chrome pins stay. Reviewer probe: no SUMMON button after the remount sequence. |
| `PlaySound` | **Pass.** Live `Console.lua` has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Nested wrap: `PlaySound` / `PlaySoundFile` / `PlaySoundKitID` stay **0** across remount Refresh and third Refresh. Reviewer spy matches. No `IG_CHARACTER_INFO_*`. No OnShow re-wire. |
| B40-A keep-string not updated | **Pass.** B40-A Refresh source pin (~5932–5941) now requires `wireConsoleOnHide` before `rememberSpecial(FRAME_NAME)`. The old `Refresh does not remount OnHide` forbid is gone. Show source pin stays without a direct call (`Show has no direct wireConsoleOnHide`). B40-A Show runtime now expects remount via Refresh, then re-niles OnHide so Hide remount still runs. |
| Not nested after `runB40A()` | **Pass.** `runB41A()` is a nested `local function` inside `runB8E()` after the `runB40A()` call (`test_console.lua` ~6105 / ~6118–6372). Packet adds no main-chunk `local`. Header comment only at file top. `luac -l -p`: main chunk **186** slots (cap 200). |
| Isolated suite not exit 0 | **Pass. Verified.** 3045 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**17** nil pins). `runB41A()` re-pins 4 of them plus `COB.Popes`. Packet is the two named files. Sibling dirt vs HEAD is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, Dock, MainFrame; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| Existing-frame Refresh: remount missing OnHide (`wireConsoleOnHide`), then `rememberSpecial(FRAME_NAME)` | **Pass.** Named-risk check. Live `Refresh` ~1138–1165. Nested source pin: that order. |
| Never replace an existing script | **Pass.** Named-risk check. Brief vs `Console.lua` ~533–541. |
| Do not reset selection / pair / Recommend (QUIET Refresh still nils Recommend — B31-A keep) | **Pass.** Named-risk check. |
| No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. Wrapped `CreateFrame` **0**. Same frame pointer. |
| Show may stay without a direct call (Show already Refreshs) | **Pass.** Show body has `self:Refresh()` and no `wireConsoleOnHide`. |
| B40-A keep-string updated in this exclusive test file | **Pass.** Named-risk check. |
| Do not refuse empty OpenRite Gora | **Pass.** Named-risk check. |
| `SaveNote` stays nil. No SUMMON. No parchment. No tabs | **Pass.** Named-risk check. |
| Nest `runB41A()` after `runB40A()` inside `runB8E()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **3045 / 0.** Wrap **17**. |

Wiki ESC holds on the exclusive pair: a missing OnHide is remounted on `Console:Refresh` so a later ESC Hide can re-list `ChurchOfBeefConsoleFrame`. Law 6 / §19.4 hold: no panel whoosh. Law 10 / §19.3 hold: stock desk, no parchment / tabs / SUMMON. License 4 holds: `SaveNote` stays nil. B40-A Hide remount stays. B29-A Hide `rememberSpecial` remount stays. B28-A Show / Refresh remount stay. B27-A Init remount stays. B31-A QUIET Recommend drop stays. B39-A empty OpenRite Gora still opens. B14-D scan-then-append stays.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Init remount still skips a niled OnHide | **On contract.** Brief asked Refresh remount and no OnShow re-wire. Nested pins: Init early-return does not call `wireConsoleOnHide`. |
| Widget Hide / ESC does not remount a niled OnHide | **On contract.** Brief scoped `Console:Refresh` remount. The missing handler cannot remount itself. Reviewer probe: niled OnHide + widget Hide leaves the wiped list empty. |
| Show has no direct `wireConsoleOnHide` | **On contract.** Brief allowed that keep. Remount on Show is via `self:Refresh()`. |
| No client smoke. Real ESC vs `CloseSpecialWindows` on Anniversary is unproven | **Not a miss.** Brief asked the isolated suite. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. A dropped handler is simulated by `SetScript("OnHide", nil)`. Glue `Runtime:EndEvent` Refresh is not invoked here; the suite calls `Console:Refresh` directly. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Refresh()` is a direct call, not a real ESC key and not glue EndEvent | **On contract.** Script identity, membership counts, and selection / pair / Recommend persist are pinned; the client's special-frame walk is not. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B40 leftover (`Refresh` remounted `rememberSpecial` only and pinned no `wireConsoleOnHide`, so glue `Runtime:EndEvent` Refresh left a niled OnHide idle until Hide) is this lane's spec. It is closed on the exclusive pair for the `Console:Refresh` path.

---

## Isolation / remount / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Dock, glue, UI shell, Net, DB, Roster, or Confession. Standalone wrap is still **17** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Nested B41-A re-pins Archive / UI / Toasts / Confession / Popes after restore.

**Remount — Pass.** `wireConsoleOnHide` no-ops when a script exists and writes `rememberSpecial(FRAME_NAME)` only when OnHide is nil. Existing-frame Refresh remounts the missing handler, then remounts `rememberSpecial`, then paints. Hide remount stays (B40-A). Show remounts OnHide only because Show already Refreshs. Init still remounts `rememberSpecial` and does not remount OnHide. Reviewer spy: wipe + widget Hide after remount lists the name once; niled handler + widget Hide does not; already-hidden `Console:Refresh()` still restores the handler. Same frame pointer. Wrapped `CreateFrame` **0**.

**Keep — Pass.** B40-A Hide remount stays. B29-A Hide `rememberSpecial` remount stays. B28-A Show / Refresh remount stay. B27-A Init remount stays. B14-D scan-then-append stays. B31-A QUIET leftover drop stays; live-event Recommend stays. B39-A OpenRite Gora live `GetSanctioned` fallback stays; empty pair still opens; `GetLastSanctioned` fallback stays gone. Selection / pair stay across Refresh. `SaveNote` nil. No SUMMON / parchment / tabs / `PlaySound`. `FRAME_NAME` stays `ChurchOfBeefConsoleFrame`. Show has no direct `wireConsoleOnHide`.

---

## Strengths

- The delta is the brief: one `wireConsoleOnHide(self.frame)` on existing-frame Refresh, then the B28-A `rememberSpecial` remount. An existing script is not replaced. Hide / Init / OpenRite were left alone. Show stayed without a direct call.
- B40's leftover (glue EndEvent Refresh left a niled OnHide idle until Hide) is closed on the `Console:Refresh` path, not a second register helper. Third-Refresh identity sits next to the wipe remount, so a replace-every-Refresh helper would fail.
- Selection / pair keeps, the B31-A QUIET Recommend drop, and the empty OpenRite Gora keep sit next to the remount, so a blanket desk reset or a new empty-pair refuse would fail.
- The B40-A Refresh keep-string was updated in this exclusive test file. `runB41A()` sits after `runB40A()` inside `runB8E()`. Isolation wrap stays **17**. No new main-chunk locals. Writer-reported **3045 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **Widget Hide / ESC does not remount a niled OnHide.** The missing handler cannot remount itself. `CloseSpecialWindows` / `frame:Hide()` still bypass `Console:Hide` and `Console:Refresh`. A dropped OnHide that never hits Refresh / Hide / Show still leaves a wiped list idle until one of those paths. Brief scoped the `Console:Refresh` remount.

2. **Init remount still skips a niled OnHide.** Brief asked Refresh remount and no OnShow re-wire. A niled handler that only hits existing-frame Init stays idle until Refresh / Hide / Show.

### Nit

1. **Wipe + Refresh re-list-once is also the B28-A Refresh remount.** Nested pin proves OnHide is restored and the name is not duplicated. OnHide's own `rememberSpecial` after a post-Refresh wipe is a reviewer widget-Hide probe, not an in-lane behavioral pin.

2. **Recommend keep is painted text after Refresh**, not a direct `lastRecommendation` field read (that binding is a Console file local). The paint match still fails if Refresh niled the leftover during a live event.

3. **Already-hidden `Console:Refresh()` remount is a reviewer probe**, not a nested pin. Show remount is pinned in B40-A runtime after the keep-string update, not as a direct `wireConsoleOnHide` on Show.

4. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B41-A-only Refresh remount + nested pins + B40-A keep-string update. Report already says this.

5. **Isolation wrap is load-only.** Seventeen pins under the first `if standalone then`. Nested B41-A re-pins four of them plus Popes. Brief said the wrap stays; it did.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **3045 / 0** was re-run here. Live ESC vs `CloseSpecialWindows` after a dropped OnHide, and glue `Runtime:EndEvent` Refresh, are unproven on Anniversary.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: existing-frame Refresh remounts missing OnHide (`wireConsoleOnHide`), then `rememberSpecial(FRAME_NAME)`; never replace; do not reset selection / pair / Recommend (QUIET Refresh still nils Recommend); no OnShow re-wire; no rebuild; no `PlaySound`; Show may stay without a direct call; update the B40-A Refresh keep-string; do not refuse empty OpenRite Gora; `SaveNote` nil. Live `Refresh` ~1138–1165 and `wireConsoleOnHide` ~533–541 match. Brief test pins sit in `runB41A()` after `runB40A()` inside `runB8E()`.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftovers: widget Hide / ESC still cannot remount a niled OnHide (brief scoped `Console:Refresh`); Init still skips a niled OnHide (Refresh remount). Nits listed above.

**3. Isolation count:** **3045 passed, 0 failed.** Isolation wrap: **17**.

**4. Law:** Wiki ESC holds. After `Console:Refresh` remounts a missing OnHide, a later ESC Hide can re-list `ChurchOfBeefConsoleFrame`. Law 6 / §19.4 hold: no panel whoosh. Law 10 / §19.3 hold: stock Event Mode desk; no parchment / tabs / SUMMON. License 4 holds: `SaveNote` stays nil. B40-A / B29-A / B28-A / B27-A remounts stay. B31-A QUIET Recommend drop stays. B39-A empty OpenRite Gora still opens.

**Leftovers:**
- Widget Hide / ESC does not remount a niled OnHide (Important, not must-fix; brief scoped `Console:Refresh`).
- Init remount still skips a niled OnHide (Refresh remount).
- Wipe + Refresh re-list-once is also Refresh remount (reviewer widget-Hide probe closed OnHide remount).
- Recommend keep is painted text after Refresh.
- Already-hidden remount is a reviewer probe.
- Exclusive-pair packet is not a vs-HEAD Console delta.
- Isolation wrap is load-only.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

Existing-frame `Refresh` remounts a missing OnHide, then `rememberSpecial(FRAME_NAME)`. An existing OnHide is not replaced. Selection / pair stay. Live-event Recommend stays; QUIET Refresh still nils it. Empty OpenRite Gora still opens. `SaveNote` stays nil. No SUMMON. No parchment. No `PlaySound`. B40-A keep-string was updated. `runB41A()` is nested inside `runB8E()` after `runB40A()`. Isolated `lua tests/test_console.lua` **3045 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
