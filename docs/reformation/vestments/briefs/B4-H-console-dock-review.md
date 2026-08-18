Spec PASS

# B4-H — Event-only Director Console dock (review)

**Quality:** Approved-with-nits

**Lane:** B4-H Event-only Director Console dock
**Brief:** `docs/reformation/vestments/briefs/B4-H-console-dock.md`
**Writer report:** `docs/reformation/vestments/briefs/B4-H-console-dock-report.md`
**Diff:** `docs/reformation/vestments/briefs/B4-H-console-dock.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, `UI/ConsoleDock.lua`, and `tests/test_console_dock.lua`; then ran `lua tests/test_console_dock.lua` (exit 0; **156 passed, 0 failed**). Named-risk checks: title pin, Quiet ∧ Pope gate, SANCTION / Expand forwards, no Quiet chrome, no WHISPER ALL, isolated green. Did not mutate addon code. Did not commit. Did not sign the lane.

Law cited: Bible §18.1 (collapsible), §19.1; Law 6, Law 10; Batch 4 critique (dock titled **DIRECTOR CONSOLE**, live event + Pope screen only).

---

## Named risks

| Risk | Verdict |
|---|---|
| Title exactly `DIRECTOR CONSOLE` | **Pass.** Module constant `TITLE`. `TitleText:SetText(TITLE)` at build. `GetView().title` is always that string. Suite pins widget, view, and painted title. No `CHURCH OF BEEF` title (the Batch 4 illegal variant). |
| Shown only when not `QUIET` **and** `Sender:IsRegisteredPope` | **Pass.** `mayShow()` is `runtimeState() ~= "QUIET"` and `Sender:IsRegisteredPope(local) == true`. Missing Runtime / non-string state → `QUIET`. Missing Sender, missing name, or a non-`true` Pope return → Hide. `Show()` refuses and paints false. Suite: Quiet hide; StartEvent + Pope show; Pope false hide; Pope + Quiet hide; ASSEMBLY / RITE / CONSEQUENCE stay; EndEvent hide; Sender nil / Runtime nil / `return 1` / nil `UnitName` hide. |
| `SANCTION` → `Console:Sanction` | **Pass.** Stock `UIPanelButtonTemplate` label `SANCTION`. OnClick is `callConsole("Sanction")` → `Console:Sanction(Console)` when present. No `Gora:Sanction`. Suite spies one increment; missing Console does not invent a verb. |
| `Expand` → `Console:Show` | **Pass.** Stock button label `Expand`. OnClick is `callConsole("Show")`. Suite spies `Console:Show` and not a second Sanction. |
| No Quiet chrome | **Pass.** Event Mode (`MODE = "Event"`). Quiet Init / Show stay hidden. Pope + Quiet Refresh stays hidden. No sound, toast, favor bar, StatusBar, or EditBox. Hidden named frame after Init is not congregation chrome. |
| No WHISPER ALL | **Pass.** Source has no `WHISPER ALL`, `WhisperAll`, or `SendChatMessage`. Module has no `WhisperAll`. Suite finds no such button. |
| Isolated green | **Pass.** Load list is wow_ui_stub + Common + Runtime + ConsoleDock. Sender / Console are stubs. Isolation cluster (24 pins) stays under `if standalone then`. This review re-ran `lua tests/test_console_dock.lua`: **156 passed, 0 failed**, exit 0. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no TOC / `run.lua` / Console.lua / Hud / Toasts / commit | **Pass.** Packet is `UI/ConsoleDock.lua` + `tests/test_console_dock.lua`. Provided diff is those two hunks. Current TOC does not list `ConsoleDock.lua`. Current `tests/run.lua` does not list `test_console_dock`. |
| API: `Init` / `Refresh` / `Show` / `Hide` / `GetView` / `ResetForTests` | **Pass.** `GetView` is a `deepcopy`. Out-of-harness `ResetForTests` returns false and does not hide. Harness reset nils the widget. |
| Title string exactly `DIRECTOR CONSOLE` | **Pass.** Named-risk check. |
| Show only when Runtime ≠ `QUIET` and local `IsRegisteredPope`; else Hide | **Pass.** Named-risk check. Fail-closed. |
| Two stock buttons: `SANCTION` → `Console:Sanction()`; `Expand` → `Console:Show()` | **Pass.** Named-risk check. Do not reimplement Gora. |
| No WHISPER ALL; no Quiet presence; no sound; no toasts; no favor bar | **Pass.** Source greps plus Quiet / toast-trap / `sounds == 0` pins. |
| Isolated suite + isolation wrap; `lua tests/test_console_dock.lua` exit 0 | **Pass.** Re-run verified. |
| Stock functional chrome; no custom media; **POLISH:CANDIDATE** at most | **Pass.** `BasicFrameTemplate` + `UIPanelButtonTemplate`. No `Media\`, `.tga`, `.blp`, `.ttf`. Writer claimed that ceiling. |

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload` smoke; not in the TOC | **Not a spec miss.** Brief forbade TOC / bootstrap. **POLISH:CANDIDATE** is the ceiling. |
| `#8` stays fail-closed until a Pope name is listed | **Not a miss.** Brief said fail-closed if the predicate is missing. |
| `SANCTION` forwards with no fighter args; an unopened desk may refuse | **Not a miss.** Brief said call `Console:Sanction()` and do not reimplement Gora. |
| `BOTTOMLEFT (16, 80)` is a Batch 4 composition default, not saved | **Not a miss.** Brief did not ask for SV. Exclusive lane cannot touch DB. |
| `BasicFrameTemplate` CloseButton still exists, hidden | **Nit.** Chrome the player sees is SANCTION + Expand. See Issues. |

---

## Strengths

- The Quiet contract is a gate, not a comment. `Show()` cannot paint a SANCTION dock over QUIET. Congregation (`popeFlag` false) cannot paint it over a live event.
- `IsRegisteredPope(...) == true` matches Console / Hud. Truthy `1` is Hide. Missing Sender / name / Runtime is Hide.
- The dock is a display-and-forward terminal. It does not write Gora, toast, chat, or play a cue. Expand opens the existing desk.
- Isolation stayed gated. Named brief tests sit in the shared body (Quiet, title, Pope false, SANCTION spy) plus Expand, fail-closed, GetView copy, and toast trap.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **`BasicFrameTemplate` CloseButton is hidden, not removed.** Suite allows the widget if `IsShown()` is false. Live `BasicFrameTemplate` still ships the X. Brief asked for two stock buttons. Player-facing chrome matches; template chrome remains.

2. **No Runtime listener.** `Refresh` / `Show` / `Hide` are the only paints. Until the integrator calls them on transitions, a TOC-listed dock stays dead (fail-closed, not a Quiet leak). Expected leftover.

3. **Dock `SANCTION` does not carry a pair.** `Console:Sanction()` with no args reads the desk selection. An unopened desk is a no-op at Gora. Brief forbade reimplementing sanction. The minimized one-click plate will often do nothing until the Pope has already loaded a bout.

4. **`localSender` adds `Net:PlayerName` between Group and `UnitName`.** Console and Hud do not. Brief allowed any of the three. If Group is missing and Net disagrees with `UnitName`, this surface can hide while the desk would show, or the reverse. Suite pins the `UnitName` / `"Beefina"` path only.

5. **Position is not saved.** Movable and clamped. `wow-ui-taint-lockdown` prefers `ChurchOfBeefDB.ui`. Brief forbade DB. Unsmoked on Anniversary.

6. **Expand does not hide the dock.** Both surfaces can sit up at once. Brief did not ask for a collapse pairing.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **156 / 0** was re-run here. That does not prove the client path.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

This is the B4-H vestment contract: stock Event-only Pope dock, title exactly `DIRECTOR CONSOLE`, visible only when Runtime is not `QUIET` and `Sender:IsRegisteredPope(local)` is true, `SANCTION` → `Console:Sanction`, `Expand` → `Console:Show`, no WHISPER ALL, no Quiet chrome. Isolated suite is green. Named risks are clean. Nits are leftover template CloseButton, integrator Refresh glue, and SANCTION-without-selection — not trust-breakers.

Expected leftover (not a miss): integrator lists `UI\ConsoleDock.lua` in the TOC and `test_console_dock` in `tests/run.lua`, then calls `Refresh` on Runtime transitions.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
