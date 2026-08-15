# Phase 1 Lane E — Adversarial Review

**Lane:** Standing tab, grant toasts, minimap pip  
**Exclusive files:** `addon/ChurchOfBeef/UI/StandingTab.lua`, `tests/test_standing_ui.lua` (delete); `UI/Toasts.lua`, `UI/Minimap.lua`, `tests/test_minimap.lua` (edit)  
**Lane report:** `docs/reformation/phase-1/reports/P1-E-quiet-ui.md`  
**Cited law:** Ten Laws Law 6; Bible §4.8, §19.1; Audit V8, V9; `quiet-event-modes.mdc`

**Spec:** PASS  
**Quality:** Approved

Standing tab is gone, not renamed. Grant-driven toast kinds (`suggest`, `credit`, `demote`, `excommunicate`) are gone from `KINDS` and from `Celebrate` copy builders. The toast engine remains with leftover `promote` / `rite` / `system` / `debug` only — no Event Mode kinds invented. Minimap button remains; grant/petition pip, gold border tint, and standing glance are gone. Writer did not invent a Director Console, Decree, Event theater, or Quiet ambient feed. StandingTab was not restored.

## Verdict

Lane E removed the three Quiet-Mode ambient surfaces Audit V8/V9 named: the Standing tab, grant-driven toast kinds (including demote/excommunicate spectacle), and the minimap grant/petition pip. Exclusive-file work is deletion and strip, not a rebuild under another name. Law 6 / Bible §4.8 / §19.1 hold for this lane’s exclusive files. Residual BeefNet `Celebrate("suggest")` call sites and shell `Minimap:Refresh` are expected other-lane leftovers — they do not mint standing copy and they do not paint a pip.

## Confirmations

| Check | Result |
|---|---|
| `UI/StandingTab.lua` gone | **Yes.** `ls`: no such file. Repo-wide glob: 0 `StandingTab.lua`. Git: `D`. Attic has none. |
| `tests/test_standing_ui.lua` gone | **Yes.** Not on disk. Not among `tests/test_*.lua`. Not in `git log --all` (never a committed suite on this line). |
| Toasts.lua has no grant-driven kinds | **Yes.** `KINDS` is `promote`, `rite`, `system`, `debug` only. No `suggest` / `credit` / `demote` / `excommunicate`. No `record` / `favor` / `grant` kinds. |
| Toast engine kept; no invented Event kinds | **Yes.** Queue, priority, interrupt, dedupe, motion remain. Leftover kinds are the pre-existing non-grant set. Phase 4 kinds not added. |
| Minimap button remains; pip and glance gone | **Yes.** Button, drag, show/hide, `/beef minimap` remain. No `petitionPip`, no `StandingGlanceLines`, no gold `SetVertexColor` tint, no badge/count/unread. |
| `test_minimap.lua` is presence/button only | **Yes.** Ring placement, drag, slash toggle, plus negative locks that pip/glance are nil. Isolated suite completes without abort. |
| TOC no longer lists `StandingTab.lua` | **Yes.** `ChurchOfBeef.toc` has no `Standing` string. |
| `tests/run.lua` no longer lists `test_standing_ui` | **Yes.** Suite list has `test_minimap`, not `test_standing_ui`. |
| Writer did not invent Director Console / Decree / Event theater / Quiet ambient feed | **Yes.** Exclusive files add none of those surfaces. Minimap click is still `UI:Toggle`. Hover copy is presence only (`Church of Beef` + `Left-click: /beef`). |

Writer brief forbade MainFrame / LadderTab / OfficerTab / TOC / bootstrap / `run.lua` edits. Integrator owns TOC and `tests/run.lua` (`docs/REFORMATION_LOG.md`). Exclusive diff is `Toasts.lua`, `Minimap.lua`, and `StandingTab.lua` delete. Writer report’s “TOC / run.lua still list Standing” lines are stale against the current tree; the live tree matches the review contract.

## Attack results

| Attack | Result |
|---|---|
| Standing tab moved / renamed instead of deleted? | **No.** Zero `StandingTab.lua` anywhere. UI tree is MainFrame, Minimap, Status, Toasts. MainFrame tab plumbing ships with no registered tabs (Lane F). `test_ui.lua` asserts no `My Standing` button and `ShowTab("standing")` is nil. Research docs under `docs/research/` are not product surfaces. |
| Pip rebuilt as glow / badge / count / unread? | **No.** No pip texture, no gold border tint, no unread count, no glow script. Stock MiniMap highlight is hover chrome, not a grant cue. `Refresh` only repaints the presence tooltip if it is already shown. |
| Grant kinds renamed (`record`, `favor`, …) but still fire as standing toasts? | **No.** No new kind names. `Celebrate("suggest" / "credit" / "demote" / "excommunicate")` without explicit `text`/`detail` returns `false, "invalid"` and mints nothing — including the old standing-delta and attendee-credit builders. `rite` no longer mints `"%s: %d standing"`. |
| Quiet Mode still has a feed, pip, or ambient surface (exclusive files)? | **No.** Engine can still present if a caller supplies `text` (or `detail` after unknown-kind remap to `system`). That is the leftover engine path the brief allowed. No exclusive-file caller fires it. Minimap is presence only. |
| Writer edited MainFrame / LadderTab / OfficerTab / TOC / bootstrap / `run.lua`? | **No** for this lane’s exclusive work. Those files are dirty on the branch from Lane F and the integrator, not from Lane E’s allowed set. |

Refutation of Law 6 / §4.8 / §19.1 / Audit V8–V9 **fails** for this lane. The banned Quiet surfaces are the Standing tab, grant-kind toasts, and the grant/petition pip. They are gone. A toast engine that does not mint grant copy is not a standing feed.

### Smoke (adversarial)

Isolated `Celebrate` / `Push` against current `Toasts.lua` (UI stub):

| Call | Result |
|---|---|
| `Celebrate("suggest", { title = "Cooked Beef" })` | `false, "invalid"` — no text |
| `Celebrate("suggest", { name, title })` | `false, "invalid"` — no text |
| `Celebrate("credit", { attendees = 3 })` | `false, "invalid"` — no text |
| `Celebrate("credit", { detail = "win", standingDelta = 15 })` | shows as `system` text `"win"` — leftover remap; standing-delta copy is gone; **no live caller** |
| `Celebrate("demote" / "excommunicate", { name, title })` | `false, "invalid"` |
| `Celebrate("rite", { name, standingDelta = 12 })` | `false, "invalid"` |
| `Push({ kind = "credit", text = "…" })` | shows as `system` — leftover engine path, documented by writer |
| `Celebrate("promote" / "rite" with leftover fields)` | still mints leftover non-grant copy — allowed by brief |

BeefNet leftover `toastCelebrate("suggest", { title / name, dedupeKey }, fallback)` does **not** use the fallback: `Celebrate` exists, returns invalid, and never reaches `Show(fallbackText)`. Current leftover callers no-op.

## Leftover callers (other lanes — expected; not fixed)

Writer leftover list is partly stale (TOC / `run.lua` already dropped Standing; OfficerTab / `test_officer_ui.lua` already deleted by Lane F; `test_ui.lua` no longer `dofile`s StandingTab or asserts `kind = "credit"`; `test_gora_ceremony.lua` no longer loads StandingTab; MainFrame no longer `MarkDirty("standing")`). Current Quiet-UI-shaped leftovers:

### Lane F (shell)

- `UI/MainFrame.lua` — `RefreshLadder` still calls `Minimap:Refresh`. Refresh no longer paints a pip. Tab registry remains as plumbing; no Standing tab registers.
- `UI/Status.lua` — player-opened shell chip (guild / roster / §13.4 version word). Not Lane E. Not a grant pip.

### Net (out of lane)

- `Net/BeefNet.lua` — `toastCelebrate("suggest", …)` on local and inbound suggestion. `Celebrate("suggest")` without `text`/`detail` no-ops. Suggestion fanout itself is a later Net cut, not this lane.

### Tests that still speak standing (other lanes)

- `tests/test_net_validate.lua`, `tests/test_net_adversarial.lua` — suggestion / standing claims on the wire.
- `tests/test_roster.lua`, `tests/test_db.lua` — Ladder standing schema (Lanes B / G).

`ChurchOfBeef.lua` has no StandingTab references. Do not treat deleted `UI/OfficerTab.lua` as a current caller.

## Findings

### Critical

None.

### Important

None for this lane’s exclusive files.

### Nit

1. **Writer report leftover map is stale** (`P1-E-quiet-ui.md`). It still lists TOC / `test_standing_ui` in `run.lua`, `dofile` StandingTab in three suites, `test_ui.lua` `kind = "credit"`, live OfficerTab toasts, and `MarkDirty("standing")`. Integrator and Lane F already moved those. Does not reopen Spec. This review’s leftover list is the current map.

2. **Unknown kinds remap to `system` and will mint `fields.detail` or explicit `text`.** `Celebrate("credit", { detail = "win", standingDelta = 15 })` shows `"win"` as `system`. Standing-delta copy is gone. No current addon caller passes `detail` on a grant kind. Brief allowed a leftover system path that is not a standing feed. Phase 4 owns a Quiet gate if one is needed.

3. **Leftover `promote` / `rite` copy builders remain** (`"%s is now %s."`, `"%s: %s → %s"`). Not grant kinds. No current caller. Brief allowed them so the engine is not an empty stub.

## Brief contract

| Requirement | Result |
|---|---|
| Delete `UI/StandingTab.lua` | Met |
| Delete `tests/test_standing_ui.lua` | Met |
| Remove grant-driven toast kinds; keep engine; do not invent Event Mode kinds | Met |
| Keep minimap button; delete grant/petition pip | Met |
| `test_minimap.lua` presence/button only | Met |
| Do not edit MainFrame / LadderTab / OfficerTab / TOC / bootstrap / `run.lua` (writer) | Met (integrator dropped TOC + suite list) |
| Do not invent Director Console, Decree, Event theater, or a Quiet ambient feed | Met |
| Report leftover callers; do not fix them | Met |
| No commit | Met |
| StandingTab not restored this review | Met |

## Sections checked

- Brief `docs/reformation/phase-1/briefs/P1-E-quiet-ui.md`
- Writer report `docs/reformation/phase-1/reports/P1-E-quiet-ui.md`
- `docs/reformation/phase-0/TEN_LAWS.md` Law 6
- `.cursor/rules/quiet-event-modes.mdc`
- Bible §4.8, §19.1 (and §13.4 / §14.1 / §14.2 / §19.4 as cited)
- Audit V8, V9 and §4 `UI/Minimap.lua` Rework (light) row
- `ChurchOfBeef.toc`, `tests/run.lua`, `ChurchOfBeef.lua`
- Live `UI/Toasts.lua`, `UI/Minimap.lua`, `tests/test_minimap.lua`
- HEAD `Toasts.lua` / `Minimap.lua` / `StandingTab.lua` for before/after
- Live UI/Net for `StandingTab`, `petitionPip`, `StandingGlanceLines`, grant toast kinds
- `docs/REFORMATION_LOG.md` P1-E integrator note
- Isolated minimap suite; isolated toast kind smoke
