# Phase 5 Lane B — Adversarial Review

**Lane:** Decree banner + minimap replay
**Exclusive files:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`, `addon/ChurchOfBeef/UI/Minimap.lua`, `tests/test_minimap.lua`, `docs/reformation/phase-5/reports/P5-B-decree-ui.md`
**Lane report:** `docs/reformation/phase-5/reports/P5-B-decree-ui.md`
**Cited law:** Ten Laws 6, 10; Bible §14.1, §14.2, §19.3; `.cursor/rules/quiet-event-modes.mdc`; `.cursor/rules/ui-juice-standards.mdc`; brief `docs/reformation/phase-5/briefs/P5-B-decree-ui.md`
**Writer:** [Banner](a252dd60-bba4-46bb-af45-a14d41c56669)

**Spec:** PASS
**Quality:** Approved

Quiet Mode theatrical parchment. `DecreeBanner.MODE = "QUIET"`. Header is UI copy **A GATHERING HAS BEEN DECREED**. Paints `Get().line` and optional `Get().flavor`. `COB.DecreeBanner` does not clobber Core `COB.Decree`. Session flag is module-local; not SavedVariables. Minimap left-click replays when `Get()` is set and keeps `UI:Toggle` when unset. Isolated `test_decree_ui.lua`: **218 passed, 0 failed**. Isolated `test_minimap.lua`: **92 passed, 0 failed**. Writer stayed inside exclusive files. `OPEN_QUESTIONS.md` #5 and #8 unchanged. No calendar / RSVP / SUMMON / slash / sound / pip / toast. No commit. This review did not invent deputy UX, a wire kind, or media, and did not edit the writer’s files.

## Verdict

Refutation of Law 6, Law 10, Bible §14.1 / §19.3, and “no deputy / calendar / RSVP / slash / sound / already-seen / Core clobber / broken no-Decree Toggle” **fails** for this lane’s exclusive files.

Law 6 is intact. The surface declares Quiet Mode. Unbidden chrome is the login parchment when `Get()` is set, plus minimap presence. `Init` with a nil `Get()` builds a hidden frame and does not show it. `Show()` with a nil `Get()` hides and returns `false`. No `PlaySound`, no toast, no pip, no StatusBar, no Event host. Tooltip names the Decree when one is active — presence only.

Law 10 / §19.3 is intact on the terms the brief set. The banner is not `BasicFrameTemplate`. Dark iron, muted gold edge, aged parchment, ecclesiastical header. Close copy is “Close.” The UI does not joke. Custom media paths are referenced; no `.ttf` / seal / parchment files were added; `applyFont` `pcall`s `SetFont` and falls back to `GameFont*`. File load does not touch media.

§14.1 is intact. One proclamation. Header is UI copy, not stored. `GetView` has `shown`, `header`, `line`, `flavor` — no `title`, `deputy`, or `postedAt`. “Once per login” is `loginRevealDone` in the module. `/reload` (fresh `dofile` of `UI/Decree.lua`) may show again. Thereafter left-click replays. Hard bound holds.

Core `Set` / `Get` / `Clear` / `Snapshot` / `Restore` still work after the UI file loads. Banner drag may write `ChurchOfBeefDB.ui.decree.point` only when `ui` already exists — position, not an already-seen key. Root `ChurchOfBeefDB.decree` is untouched.

This review did not invent deputy UX, a Decree wire, SUMMON, `#8`, or media, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| Quiet Mode only; no Event chrome, sound, pip, toast, or empty parchment when `Get()` is nil | **Yes.** `MODE = "QUIET"`. Source has no `PlaySound`, `ShowUIPanel`, `StatusBar`, `COB.Toasts`, `COB.Hud`, `COB.Console`, `COB.RecordsBook`. Suite: `Init` / refused `Show` / close / replay keep `sounds == 0`. `petitionPip` is nil. Hidden frame when unset; `Show()` after `Clear` hides. |
| Header is UI copy; paints `Get().line` and optional `Get().flavor`; no title / deputy / `postedAt` | **Yes.** `HEADER` is the Bible line. Paint never reads a stored title. Suite: stored `title` / `deputy` do not become view fields. `GetView` has no those keys. Core still drops extras. |
| `Init` from `Minimap:Init`; auto-show once per session; flag is not SV; `/reload` may show again | **Yes.** `Minimap:Init` calls `DecreeBanner:Init`. Same-session `Init` after dismiss stays hidden. `dofile` of the UI file resets the local and may show. Suite + reviewer: no `decreeSeen` / `alreadySeen` / `shownThisSession` on `ui` or root. |
| Minimap left-click: replay when active; `UI:Toggle` when unset; no right-click / second button / new slash | **Yes.** Both suites: unset click increments Toggle and does not show parchment. Set click shows the banner and leaves Toggle at 0. `RegisterForClicks("LeftButtonUp")` only. Reviewer: `RightButton` is a no-op. No `SLASH_` in exclusive Lua. `/beef minimap` hide/show still green after replay. |
| `COB.DecreeBanner` does not clobber `COB.Decree`; Core Set/Get still work | **Yes.** UI assigns `COB.DecreeBanner` only. Suite: `Banner ~= Decree`; `type(Decree.Get) == "function"`. Reviewer: Set/Get/Snapshot/Restore after UI load; extras still dropped. `Core/Decree.lua` mtime 07:42 (Lane A). |
| Missing `Media/*.ttf` / seal / parchment does not fail load | **Yes.** No `Media/` dir; no addon `.ttf` / seal / parchment files. Module load does not `CreateFrame`. `applyFont` `pcall`s `SetFont`. `Init` with the stub (missing files) still builds. |
| Isolation asserts in `if standalone then`; `test_minimap` `/beef minimap` still green | **Yes.** 16 standalone-only `COB.*` / MainFrame asserts. Isolated minimap suite **92 / 0**, including hide/show after replay. |
| No calendar, RSVP, SUMMON, `#8`, Console/HUD/Records host, Grant/standing, narration | **Yes.** No those methods on the banner. Source comments refuse them; no picker chrome. Flavor is painted from Core, not generated. `OPEN_QUESTIONS.md` 07:23; writer files 07:53–07:54. |

## Attack results

| Attack | Result |
|---|---|
| Law 6 — `Init` / `Show` with nil `Get()` paints an empty parchment? | **No.** Frame stays hidden. `Show()` returns `false` and hides. |
| Law 6 — login reveal is a toast, pip, sound, or second Quiet surface? | **No.** One parchment + minimap. `sounds == 0`. No pip. Tooltip is presence. |
| Law 6 — Event chrome / Console / HUD / Records hosted from this file? | **No.** `MODE = "QUIET"`. Source has no those `COB.*` hosts. |
| Law 4 / §14.1 — header / flavor / title / deputy invented or stored? | **No.** Header is the fixed UI copy. Flavor is `Get().flavor`. `GetView.title` / `.deputy` / `.postedAt` are nil even when Core `Set` is passed those extras. |
| Law 6 — `loginRevealDone` persisted as already-seen? | **No.** Module local. SV checks clean. Drag writes `ui.decree.point` only. Root `decree` untouched. |
| Law 6 — mid-session `Set` after a silent `Init` auto-pops a second unbidden banner? | **No.** Reviewer: second `Init` stays hidden. `Show` / minimap click still replay. No watcher invented. |
| Minimap — unset left-click no longer Toggles? | **No.** Both suites: Toggle increments; no parchment. |
| Minimap — right-click menu, second button, or new slash? | **No.** Left only. One button. Exclusive files register no slash. |
| Core clobber — `UI/Decree.lua` overwrites `COB.Decree`? | **No.** Separate table. Core verbs still function. |
| Missing media fails load? | **No.** No media on disk. Load defines the table. `Init` still returns a frame. |
| Isolation asserts run under the full harness and poison it? | **No.** The 16 are inside `if standalone then`. |
| Writer edited TOC / bootstrap / `run.lua` / MainFrame / Console / HUD / Records / Status / Toasts / Store / Runtime / Net / Core Decree / DB, added media, or committed? | **No.** Exclusive mtimes 07:53–07:54. Forbidden paths are older. No media. No commit. |
| Full harness is green, so the lane listed itself? | **No.** `test_decree_ui` is unlisted. `UI\Decree.lua` is not on the TOC. Integrator leftover — not a writer miss. |

Refutation of Law 6 (Quiet: minimap + Decree only; silent; no empty parchment), Law 10 / §19.3 (theatrical parchment; no jokes; missing media must not fail load), Bible §14.1 (one proclamation; header is UI copy; once per login; thereafter minimap; hard bound), and “Core stays `COB.Decree` / no already-seen / unset click still Toggles” **fails** for the exclusive files.

## Isolated rerun

```
lua tests/test_decree_ui.lua
Tests finished: 218 passed, 0 failed

lua tests/test_minimap.lua
Tests finished: 92 passed, 0 failed
```

Lua 5.1.5. Both exit 0. Writer counts match. Isolation asserts (standalone only): **16**.

Reviewer probes (throwaway; suite not edited): Core Set/Get/Snapshot/Restore after UI load; extras still dropped; mid-session Set + `Init` does not auto-show; `GetView` has no title/deputy/`postedAt`; SV already-seen keys absent; drag slot is `point` only; unset Toggle / set replay; `RightButton` no-op; `sounds == 0`; `Show` after `Clear` refuses. The one probe miss was `pairs()` on a nil `flavor` key — Lua omits nil fields; not a stored title.

## Leftovers (other lanes — expected; not fixed)

### Integrator (listing has not landed)

- `ChurchOfBeef.toc` does not list `UI\Decree.lua`. Interface stays `20506`. Writer did not edit TOC. Until it is listed, `PLAYER_LOGIN` never loads the banner; minimap guards fall through to `UI:Toggle`.
- `tests/run.lua` does not list `test_decree_ui`. Writer did not edit it. Do not treat an unlisted-suite runner note as a `Decree.lua` defect.

### Open questions (do not invent here)

- **#5** deputy UX is not coded. Bible §14.1 names a designated deputy; this lane paints one proclamation.
- **#8** registered-Pope / congregation-vs-Pope persist policy is not coded. This lane paints `Decree:Get()` on whatever client has it.

### Other surfaces

- Console Post, Decree wire kind, and SUMMON were not invented.
- Calendar / RSVP / reminders / recurrence / attendance were not invented.
- Custom media paths (`Media/DecreeTitle.ttf`, `decree-seal`, `decree-parchment`) are not shipped. Fallbacks keep load alive.
- `/beef` still opens the Quiet shell. Minimap left-click is Decree replay only while a Decree is active.
- **POLISH:CANDIDATE** only. `UI/Decree.lua` is not in the TOC, so it was not installed and not `/reload` smoked. A human signs `POLISH:PASS`. Do not claim V1 / MVP complete (Bible §22.3).

### Out of scope (do not invent here)

- Deputy picker, Decree wire / STATE field, SUMMON, `#8`, Grant/standing, narration, a new slash, a right-click menu, a second minimap button, a pip, a countdown, sound, Console/HUD/Records hosting, a SavedVariables already-seen key.

## Findings

### Critical

None. No one-line Law 6, Law 10, §14.1, Core-clobber, already-seen, empty-parchment, or no-Decree-Toggle breach in the exclusive files. This review did not revert or edit the writer’s files.

### Important

1. **Listing is not load.** TOC / `run.lua` do not name the banner file. Until the integrator lists them, the client never loads `UI/Decree.lua` and the full harness treats `test_decree_ui.lua` as unlisted. Correct for this lane.

2. **Congregation paint is local `Get()`.** Theatrical render remains Pope-originated (later Net). This lane does not invent that gate. `#8` stays open.

### Nit

1. **Isolation MainFrame assert is stub-poisoned.** The suite replaces `COB.UI` with a Toggle stub *before* `assert_eq(type(COB.UI.Init), "nil")`. The dofile list still does not load MainFrame. Coverage gap only.

2. **`fill()` always color-fills parchment after `SetTexture`.** If media is shipped later, the leaf will not show on clients with `SetColorTexture`. Missing media still does not fail load. Do not ship art in review.

3. **Seal `SetTexture` has no color fallback.** A missing file is historically a blank/green texel, not a Lua error. Not a load fail.

4. **Suite does not lock** mid-session `Set` after a silent `Init`, or `RightButton`. Reviewer probes confirm both. Correct refusals.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated stub + Common + Decree + Decree UI + Minimap; standalone wrap | Met (218 / 0). Transcript: suite, then `UI/Decree.lua`, then Minimap + `test_minimap`. |
| Quiet Mode theatrical parchment; no sound | Met |
| Header UI copy; paint `line` + optional `flavor`; no title field | Met |
| `Init` from `Minimap:Init`; once per session; not SV; `/reload` may show | Met |
| Nil `Get()` stays silent — no empty parchment | Met |
| Left-click replay when set; `UI:Toggle` when unset; no right-click / second button / slash | Met |
| `COB.DecreeBanner` does not clobber `COB.Decree` | Met |
| Missing media does not fail load | Met |
| Isolation asserts in `if standalone then` | Met (16) |
| `test_minimap` `/beef minimap` hide/show still green | Met (92 / 0) |
| No calendar / RSVP / SUMMON / `#8` / Console/HUD/Records / Grant / narration | Met |
| Do not edit TOC / bootstrap / `run.lua` / MainFrame / Console / HUD / Records / Status / Toasts / Store / Runtime / Net / Core Decree / DB | Met |
| Isolated suites must pass | Met (218 / 0, 92 / 0) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- Brief `docs/reformation/phase-5/briefs/P5-B-decree-ui.md`
- Writer report `docs/reformation/phase-5/reports/P5-B-decree-ui.md`
- `addon/ChurchOfBeef/UI/Decree.lua`
- `addon/ChurchOfBeef/UI/Minimap.lua`
- `tests/test_decree_ui.lua` (isolated run: 218 / 0)
- `tests/test_minimap.lua` (isolated run: 92 / 0)
- `addon/ChurchOfBeef/Core/Decree.lua` (read only; mtime 07:42)
- `.cursor/rules/ten-laws.mdc` Laws 6, 10
- `.cursor/rules/quiet-event-modes.mdc`
- `.cursor/rules/ui-juice-standards.mdc`
- Bible §14.1 / §19.3 (`docs/design/Game_Design_Bible_v1.1.1.md`)
- Writer transcript ([Banner](a252dd60-bba4-46bb-af45-a14d41c56669)) — exclusive Writes only
- `ChurchOfBeef.toc` / `tests/run.lua` / `ChurchOfBeef.lua` (writer did not edit; banner unlisted)
- `docs/design/OPEN_QUESTIONS.md` (writer did not edit; #5 and #8 unanswered)
- Reviewer probes (throwaway; suite not edited): Core verbs after UI load; no already-seen keys; drag slot is `point` only; mid-session Set does not auto-show; RightButton no-op; no extra public banner keys; no media files
