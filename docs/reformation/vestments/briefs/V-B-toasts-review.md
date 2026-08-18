# V-B — Sanction proclamation + verdict seals (review)

**Spec:** PASS
**Quality:** Approved

**Lane:** V-B Sanction proclamation + verdict seals (stock textures only)
**Brief:** `docs/reformation/vestments/briefs/V-B-toasts.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/V-B-toasts-report.md`
**Diff:** `docs/reformation/vestments/briefs/V-B-toasts.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, CONTINUE V-B / license 4, Batch 2 §C / §F, the writer report, and the provided diff once; then checked `Toasts.lua` (`theaterAllowed`, `clericalCopy`, `Proclaim`, `Celebrate`, `HideAll`) and the V-B block in `test_ui.lua` for the named risks. Did not mutate the working tree except this review file. Did not re-run git or the suite. Writer-reported **237 / 0** is a claim — do not treat it as verified.

This review does not sign the lane.

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Console / Decree / Records / HUD / Sound.lua / Core / TOC / bootstrap / `run.lua` / OPEN_QUESTIONS / REFORMATION_LOG / commit | **Pass.** Provided diff touches only the two exclusive files. Suite `dofile`s Runtime and Sound for the Quiet / cue pins, as the brief allows. |
| No custom media; stock `QuestBG` / `WHITE8X8` / tooltip border only | **Pass.** Backdrop `bgFile` is `Interface\QuestFrame\QuestBG`; edge is `UI-Tooltip-Border`; dim and tint use `SetColorTexture` or `WHITE8X8`. No `Media\` paths. |
| Kinds: `sanction` / `verdict` / `cowardice` via `Proclaim`; unknown kinds mint no copy | **Pass.** `THEATER_KINDS` gate. `sermon` returns `false, "invalid"` and does not show. |
| Quiet / missing Runtime refuse theater kinds (`return false`); no frame show | **Pass.** Named risk. `theaterAllowed` refuses missing Runtime, nil snapshot, and `state == "QUIET"`. Suite pins Quiet sanction and missing-Runtime cowardice; overlay stays hidden. |
| `system` / `debug` stay as today | **Pass.** Named risk. Existing Push / Celebrate / MainFrame pins are intact. Post-theater `Push({ kind = "system" })` still queues. Theater kinds are not `KINDS`. |
| Clerical copy only; fill names from fields; no oratory | **Pass.** Named risk. Fixed sentences only. Stipulation printed as-is. Source greps refuse `"Their third meeting"` and `"Let it be known"`. |
| Sanction: `A Beef Gora is Sanctioned` + two names + optional VS + optional Pope stipulation | **Pass.** Both names required or the call is `invalid`. VS is always inserted when both names exist (brief called VS optional; see Minor). |
| Victor / void / free / cowardice sentences exactly as specified | **Pass.** `Victor declared: {name}.` / `Void.` / Pope `text` or `Free ruling.` / `Cowardice recorded: {name}. So ruled by the Beef Pope.` Suite pins each. |
| Dim ≤ 0.5; panel center third (or ≤ 420 if parent width unknown); world stays visible | **Pass.** Named risk. `DIM_ALPHA = 0.45`. Panel width is `floor(parentW / 3)` or 420. Root is full-screen dim only; panel is centered. `EnableMouse(false)`. |
| No close button; no permanent `OnUpdate`; timed hide via `C_Timer.After` | **Pass.** No Button children. Theater root has no `OnUpdate`. Hide uses existing `after()` → `C_Timer.After` (exists on 20506) with a generation guard. |
| No `SendChatMessage`; optional `DEFAULT_CHAT_FRAME:AddMessage` may repeat the same clerical line | **Pass.** Named risk. Source has no `SendChatMessage(`. Suite pins `#stub.chat == 0`. AddMessage, when it fires, must equal the painted copy. |
| `Sound:Play("sanction"\|"verdict"\|"cowardice")` when the kind shows and Sound exists; missing Sound still shows | **Pass.** `pcall` into `Sound:Play(kind)`. Quiet never reaches Play (already refused). Missing Sound still Shows. Cue names stay inside the §19.4 five. |
| Gold = victory; oxblood = cowardice; no blood spatter | **Pass.** `tintFor` returns GOLD for victor, OXBLOOD for cowardice, IRON otherwise. No spatter textures. |
| Do not wire Console / Gora; tests Push / Proclaim directly | **Pass.** Named risk. No `COB.Console` / `COB.Gora` in Toasts.lua. Isolation asserts stay under `if standalone then`. |
| Keep existing system / debug / MainFrame pins; isolation wrap if used | **Pass.** Standalone wrap added. Isolation cluster is gated. Shell / toast / status pins remain above the V-B block. |

CONTINUE V-B (center third, dim ≤ 50%, congregation visible, timed §19.4 cues, clerical chat) and license 4 (stock textures only this wave) are met. Batch 2 §C / §F scale and voice are met; the brief’s ban on `"Their third meeting"` correctly overrides Batch 2 §C’s generated H2H line (Law 4).

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Integrator must wrap Console / Gora later | **Not a miss.** Brief forbade that wiring. |
| `theater.dimAlpha` is a recorded field | **Test indirection, not a contract miss.** Source applies `0.45` via `SetColorTexture` / `SetVertexColor`. See Minor. |
| VS is always printed | **Acceptable.** Brief said “optional VS”; including it is allowed. No omit path. See Minor. |
| No client `/reload` smoke | **Expected.** POLISH:CANDIDATE only. |

---

## Named risks

| Risk | Verdict |
|---|---|
| Quiet refuse | **Clean.** Shared `theaterAllowed` gate before copy, show, chat, or Sound. Quiet and missing Runtime both return `false` (`"quiet"`) and do not show. |
| Clerical copy only (no oratory) | **Clean.** No generated sermons, H2H lines, or flavor. Free ruling prints Pope `text` or `Free ruling.` |
| Dim ≤ 0.5 | **Clean in source** (`0.45`). Suite reads `theater.dimAlpha`, which Proclaim writes after applying that constant. |
| No `SendChatMessage` | **Clean.** Chat path is `DEFAULT_CHAT_FRAME:AddMessage` only. |
| No Console / Gora edits | **Clean.** Exclusive pair only. |
| System / debug still work | **Clean.** Pre-existing pins plus a post-theater system Push. `Celebrate("sanction")` with no fields now refuses via Proclaim instead of minting a system toast that says `"sanction"` — that matches the brief, it does not break system / debug. |

---

## Strengths

- Quiet is a real refuse, not a comment. Runtime missing and `QUIET` share one gate; Sound is never asked to paper over a Quiet show.
- Copy builders are tables of fixed lines plus field fills. Stipulation and free-ruling text are printed, not rewritten.
- Overlay geometry matches the brief: full-screen dim at 45%, panel at one-third (or 420), no close chrome, no `UISpecialFrames`, no permanent `OnUpdate`.
- `Celebrate` routes theater kind names into `Proclaim` so `"sanction"` cannot fall through to a system toast. Unknown / excised kinds still mint nothing.
- `HideAll` / `ResetForTests` bump `theaterGen` so a pending `C_Timer.After` cannot re-show a dismissed beat.
- Suite work matches the brief’s list and keeps the MainFrame / system / debug body. Isolation was not pulled out of `if standalone then`.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Dim pin is a field Toasts writes, not a widget read.** `wow_ui_stub` exposes `SetColorTexture` but the suite does not assert the texture’s stored alpha. An implementer could paint 0.9 and still pass by setting `dimAlpha = 0.45`. Source is 0.45; the pin is weaker than the brief’s wording.

2. **VS is unconditional** once both sanction names exist. The brief called VS optional. There is no omit path. Not a voice violation.

3. **Quiet + verdict / Quiet + cowardice share the gate but are not each pinned.** The Quiet case uses sanction; missing Runtime uses cowardice. The function is the same.

4. **Gold / oxblood tints are implemented, not asserted.** Victor and cowardice cues and copy are pinned; the tint vertex color is not.

5. **`SetTexture` / `WHITE8X8` are not `pcall`’d.** V-stock asked for `pcall` then a blank fill. The lane brief names those paths explicitly. `SetColorTexture` exists on 20506 (`SimpleTextureBaseAPI`); the WHITE8X8 tint bar is the weaker stand-in.

6. **`CreateFrame(..., "BackdropTemplate")` is not wrapped in `pcall`.** Same pattern as the existing system toast frame. If the template errors rather than returning nil, `InitTheater` would throw instead of taking the QuestBG texture fallback.

7. **Sanction `AddMessage` is the multiline panel string.** Allowed as “the same clerical line.” Chat will see embedded newlines.

8. **Client `/reload` smoke was not run.** QuestBG stretched into a center-third panel at 45% dim needs a human eye against Batch 2 §C / §F. Stock-wave stand-in (tint bar, not a wax stamp) is **POLISH:CANDIDATE** only.

---

## Assessment

**Spec PASS. Quality: Approved.** Gate PASS for this lane’s contract. Do not sign.

The exclusive pair does what the brief asked: Event Mode `Proclaim` for sanction / verdict / cowardice, Quiet refuse, clerical copy only, dim 0.45, center-third panel, no `SendChatMessage`, no Console / Gora wiring, system / debug unchanged. Named risks are clean. Minors are test indirection, VS-always, V-stock `pcall` hygiene, and unsmoked client paint — not trust-breakers.

Writer-reported isolated `tests/test_ui.lua` **237 / 0** was **not** re-run here. Do not treat that count as verified. Do not claim **POLISH:PASS**. Do not claim V1 / MVP complete.
