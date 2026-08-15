# Phase 1 Lane L — Adversarial Review

**Lane:** UI leftovers (tab registry, ClassColorCode, Eternal Grazing, promote/rite builders)  
**Exclusive files:** `addon/ChurchOfBeef/UI/MainFrame.lua`, `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`  
**Lane report:** `docs/reformation/phase-1/reports/P1-L-ui-leftovers.md`  
**Writer:** [UI leftovers](12cafee3-5836-496e-9c5b-298ae34f1ab0)  
**Cited law:** Ten Laws 6, 10; Bible §4.8, §19.1, §19.3; GATE1 §3a; brief `docs/reformation/phase-1/briefs/P1-L-ui-leftovers.md`

**Spec:** PASS  
**Quality:** Approved

The dead tab registry and `ClassColorCode` are gone, not renamed. Footer joke **"Eternal Grazing."** stays gone. Promote / rite `KINDS` and those Celebrate copy builders are gone. Drag / resize / coalesce / empty host and the `system` / `debug` / `Push` engine remain. No Director Console, Decree, or Event theater was invented. Isolated `test_ui.lua` is green off tab-registry probes. Writer did not edit TOC or Roster. Tabs were not restored this review.

## Verdict

GATE1 §3a named three Phase 1 remainders. All three are cut in the exclusive files:

1. Tab registry (`RegisterTab`, `ShowTab`, `GetTabNames`, officer-only chrome, `MarkDirty` / `_RefreshActive`) and the `ClassColorCode` walk over `GetLadderView`.
2. Footer joke **"Eternal Grazing."** — already empty; left empty. No live `addon/` string.
3. Orphaned promote / rite toast copy builders and those `KINDS`.

Refutation of Law 6 / Law 10 / Bible §4.8 / §19.1 / §19.3 **fails** for this lane’s exclusive files. The banned Quiet surfaces this lane was asked to finish are the leftover tab IA and the joke footer. They are gone. A player-opened empty `/beef` shell is the GATE1 §3e empty shell, not a dashboard. A toast engine that does not mint promote / rite / grant copy is the leftover engine the brief required, not Event theater.

This review did not restore tabs, did not edit leftover callers, did not invent product, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| `RegisterTab` / `ShowTab` / `GetTabNames` gone | **Yes.** `type` is `nil`. No `function UI:RegisterTab` (or Show/Get). Live `addon/` has the names only in a MainFrame header comment. |
| `ClassColorCode` gone | **Yes.** `type` is `nil`. No `GetLadderView` walk in UI. `Roster:GetLadderView` is also `nil` (Lane H already deleted it). |
| Drag / resize / coalesce / empty host kept | **Yes.** Title-bar drag, grip + Classic min/max, `PAINT_COALESCE` 0.1, `ResetSize`, SV point/size, empty `content` host. |
| **Eternal Grazing.** still gone | **Yes.** `FooterText` is `""`. Status presenter forces `footer:SetText("")`. Zero `Eternal Grazing` tokens under `addon/ChurchOfBeef/`. |
| Promote / rite `KINDS` and copy builders gone | **Yes.** `KINDS` is `system`, `debug` only. No `"%s is now %s."` / `"%s: %s → %s"`. `Celebrate("promote"\|"rite", { name, title, … })` → `false, "invalid"`. |
| `system` / `debug` / `Push` kept | **Yes.** Queue, priority, interrupt, dedupe, motion remain. `Show` / `Celebrate` (system/debug / plain string) remain. |
| No Director Console / Decree / Event theater invented | **Yes.** Title is `"Church of Beef"`. Empty content. No Presence / Knighting / Gora desks, no parchment Decree, no HUD / cards / favor / §19.4 cues. No new toast kinds. |
| `test_ui.lua` rewritten off tab-registry probes | **Yes.** Asserts registry APIs are `nil`. Does not `RegisterTab` a Probe tab. No `dofile` of deleted tab files. Isolated: **135 passed, 0 failed.** |
| Writer did not edit TOC / Roster | **Yes.** Transcript writes: `MainFrame.lua`, `Toasts.lua`, `test_ui.lua`, lane report. TOC and `Roster.lua` are dirty from other lanes (integrator / Lane H). Status.lua and `test_minimap.lua` not written this lane. |
| `RefreshLadder` name kept | **Yes.** Expected leftover. Body is optional `Minimap:Refresh` only. |
| No commit; `OPEN_QUESTIONS.md` not edited | **Yes.** |

## Attack results

| Attack | Result |
|---|---|
| Tab registry renamed / inlined, not cut? | **No.** No `_tabs`, `_BuildTab`, `officerOnly`, `PanelTabButtonTemplate`, gold/idle tab paint, or `UpdateOfficerVisibility`. No Ladder / Standing / Officer / Probe buttons. Live UI folder is MainFrame, Status, Minimap, Toasts. |
| `ClassColorCode` still walks `GetLadderView` under another name? | **No.** Zero UI callers. `Roster.GetLadderView` is `nil`. No class-color cache in MainFrame. |
| **Eternal Grazing.** moved to chip / tooltip / title? | **No.** Title `"Church of Beef"`. Grip tooltip is `"Drag to resize"` / `"Right-click restores default size"`. Chip copy is guild / roster / §13.4 version only (Status.lua, not this lane). |
| Promote / rite builders renamed (`record`, `favor`, …) and still mint copy? | **No.** No new kind names. Leftover field tables without `text`/`detail` mint nothing. |
| Director Console invented in the empty host? | **No.** No §18.1 desks, queues, or ritual verbs. Header states the frame is not a Director Console. `/beef` only `Toggle`s (or `minimap`). |
| Decree banner invented? | **No.** No parchment, no Gathering copy, no once-per-login banner. Empty footer is not §14.1. |
| Event theater invented? | **No.** Engine kept; no Event Mode kinds added. No proclamations, fighter cards, HUD, favor, seals, or ceremonial sound in exclusive files. |
| Quiet Mode violated by the `/beef` frame? | **No for this brief.** Law 6 bans unbidden feeds / dashboards / toasts. GATE1 §3e and the brief allow a tabless empty shell. Frame starts hidden. Chip is player-opened, not always-on Quiet chrome. |
| Quiet Mode violated by a live toast path? | **No exclusive-file caller.** BeefNet no longer `Celebrate`s (Lane J). `Celebrate("suggest", { title })` → `false, "invalid"`. Engine can still present if a caller supplies `text` (or `detail` after unknown-kind remap). That is the leftover path the brief allowed. |
| Writer edited TOC / Roster / Status / Minimap? | **No.** See confirmations. |
| Law 10 joke chrome still presented? | **No.** Footer empty. Unused `Palette.Gold` / `IdleTab` are not painted. Stock `BasicFrameTemplate` is functional chrome (Law 10 hybrid). |

Refutation of GATE1 §3a / Laws 6 and 10 **fails** for this lane. The leftovers that remain are names, an unused palette pair, and a toast engine that does not drive itself.

### Smoke (adversarial)

Isolated `test_ui.lua` (Common + assert helpers + suite): **135 passed, 0 failed.**

API types after load: `RegisterTab` / `ShowTab` / `GetTabNames` / `ClassColorCode` / `UpdateOfficerVisibility` / `MarkDirty` = `nil`. `RefreshLadder` = function. `Roster.GetLadderView` = `nil`.

| Call | Result |
|---|---|
| `Celebrate("promote", { name, title })` | `false, "invalid"` — no text |
| `Celebrate("rite", { verb, name, title })` | `false, "invalid"` — no text |
| `Celebrate("suggest", { title })` | `false, "invalid"` — no text |
| `Celebrate("debug", { detail = "probe" })` | `debug` / `"probe"` — engine kept |
| `Push({ kind = "system", text = "sys" })` | `system` — engine kept |
| `Push({ kind = "rite", text = "explicit" })` | shows as `system` — leftover remap; not a kind family |
| `Celebrate("promote", { detail = "hello" })` | shows as `system` text `"hello"` — leftover remap; **no live caller** |
| `Celebrate("promote")` / `Celebrate("rite")` bare | shows as `system` text `"promote"` / `"rite"` — `Celebrate(text)` back-compat after the kind died; **no live caller** |

## Leftover callers (expected; not fixed)

`RefreshLadder` as a name is the expected leftover this review was told to keep. Do not treat the writer’s BeefNet / `GetLadderView` rows as current — Lane J and Lane H already moved those.

| File | What remains | Owner |
|---|---|---|
| `UI/MainFrame.lua` | `UI:RefreshLadder()` — name kept; body is optional `Minimap:Refresh`. Self-called from roster coalesce and `OnShow`. | Expected leftover. |
| `UI/MainFrame.lua` | `UI.Palette.Gold` / `IdleTab` unused after tab chrome died. Not presented. | This lane leftover. Not tab IA. |
| `UI/Toasts.lua` | `system` / `debug` engine; unknown kind + explicit `text` (or remapped `detail`) still presents. No Quiet-Mode gate. | Brief-required keep. Phase 4 owns Event kinds / a Quiet gate if one is needed. Do not invent one here. |
| `Net/BeefNet.lua` | `COB.UI:OnStatusChanged()` only. **No** `RefreshLadder`, **no** `Celebrate("suggest")`. | Lane J. Writer leftover row is stale. |
| `Core/Roster.lua` | `GetLadderView` is **gone**. | Lane H. Writer leftover row is stale. |
| `UI/Status.lua` | Player-opened chip (guild / roster / §13.4 version word). Footer forced empty. | Out of lane. Not a joke. Not a Decree. |

`ChurchOfBeef.lua` `/beef` only `Toggle`s the shell (or `minimap`). No tab names.

## Findings

### Critical

None.

### Important

None for this lane’s exclusive files.

### Nit

1. **Writer leftover map is stale** (`P1-L-ui-leftovers.md`). It still lists `Roster:GetLadderView()` and BeefNet `RefreshLadder` / `Celebrate("suggest")`. Lane H deleted `GetLadderView`. Lane J dropped the BeefNet UI toast / ladder fan-out. This review’s leftover list is the current map. Does not reopen Spec.

2. **MainFrame comment still says “BeefNet still invokes RefreshLadder.”** The name is the expected leftover; the caller is gone. Comment only.

3. **Comment “Yields the scripture line while active”** on the status chip is leftover joke-adjacent narration. The chip no longer yields a scripture line. Not presented UI. Law 10 governs chrome copy, not comments.

4. **Unused `Palette.Gold` / `IdleTab`.** Writer disclosed; left in place so this lane would not restyle chrome. Not painted. Not tab IA.

5. **Unknown kinds remap to `system` and will mint `fields.detail` or a bare `Celebrate("promote")` string.** Cutting the kind inverted the no-fields `Celebrate("promote")` path from `invalid` to a system toast whose text is the word `promote`. No current addon caller. Brief allowed the leftover `Celebrate(text)` / `Push` engine. Phase 4 owns a Quiet gate if one is needed.

6. **In-game `/reload` smoke was not run.** Writer disclosed. Owner: David (GATE1 §3e). Harness cannot prove Law 6 in the client.

## Brief contract

| Requirement | Result |
|---|---|
| Cut dead tab registry and `ClassColorCode` | Met |
| Keep drag / resize / coalesce / empty content host | Met |
| `/beef` stays a tabless Quiet shell | Met |
| **Eternal Grazing.** stays gone | Met |
| Cut promote / rite copy builders and those `KINDS` | Met |
| Keep toast engine (`system` / `debug` / `Push`) | Met |
| Do not invent Director Console / Decree / Event theater / Event Mode kinds | Met |
| Rewrite `test_ui.lua` off tab-registry probes; isolated suite green | Met (135 / 0) |
| Do not edit TOC / Roster / Status.lua (unless joke restored) | Met |
| Report leftover callers; do not fix them | Met (`RefreshLadder` name kept) |
| No commit | Met |
| Tabs not restored this review | Met |

## Sections checked

- Brief `docs/reformation/phase-1/briefs/P1-L-ui-leftovers.md`
- Writer report `docs/reformation/phase-1/reports/P1-L-ui-leftovers.md`
- Writer transcript [UI leftovers](12cafee3-5836-496e-9c5b-298ae34f1ab0)
- `docs/reformation/phase-0/TEN_LAWS.md` Laws 6, 10
- GATE1 §3a (and §3e for the empty `/beef` shell)
- Bible §4.8, §14.1–14.2, §19.1, §19.3
- `.cursor/rules/quiet-event-modes.mdc`
- Live `UI/MainFrame.lua`, `UI/Toasts.lua`, `tests/test_ui.lua` (full)
- `UI/Status.lua` (footer / chip only; not edited this lane)
- `ChurchOfBeef.toc`, `ChurchOfBeef.lua`, `Net/BeefNet.lua`, `Core/Roster.lua`
- Live `addon/ChurchOfBeef/UI/` (four files; no LadderTab / OfficerTab / Announce / StandingTab)
- Repo grep: `RegisterTab`, `ShowTab`, `GetTabNames`, `ClassColorCode`, `Eternal Grazing`, promote/rite builders, `GetLadderView`, `RefreshLadder`
- Isolated `test_ui` 135 / 0; isolated Celebrate / Push smoke
- `docs/design/OPEN_QUESTIONS.md` (no item appended; none required)
