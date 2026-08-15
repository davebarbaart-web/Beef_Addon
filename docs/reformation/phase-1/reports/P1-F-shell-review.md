# Phase 1 Lane F — Adversarial Review

**Lane:** Strip ladder/standing IA from the shell  
**Exclusive files:** `UI/MainFrame.lua`, `UI/LadderTab.lua`, `UI/OfficerTab.lua`, `UI/Status.lua`, `UI/Announce.lua`; related tests `tests/test_ui.lua`, `tests/test_officer_ui.lua`  
**Lane report:** `docs/reformation/phase-1/reports/P1-F-shell.md`  
**Writer:** [Shell IA](a57732e0-666b-43a7-811c-5af8444b4336)  
**Cited law:** Ten Laws 6; Bible §4.8, §19.1, §19.3; Audit §4 `UI/MainFrame.lua` Rework (salvage plumbing, discard IA)

**Spec:** PASS  
**Quality:** Approved

The guild-management window is gone. Ladder / Officer / Announce files are deleted, not gutted. `/beef` is a tabless drag/resize shell. No Director Console, Decree banner, or Event theater was invented. Status is guild / roster / version-mismatch only. Writer stayed off Toasts, Minimap, StandingTab, TOC, bootstrap, and `tests/run.lua`. Integrator already dropped the TOC and runner leftovers. Tabs were not restored this review.

## Verdict

Lane F discarded the Standing / Ladder / Officer information architecture. What remains in `MainFrame.lua` is the Audit’s salvage: insecure `BasicFrameTemplate`, drag, resize, clamp, SV point/size, paint coalesce ≤10 Hz, and an empty content host. Nothing under `addon/` calls `RegisterTab`. `GetTabNames()` is empty at ship. `ShowTab("ladder"|"standing"|"officer")` returns nil. Status no longer has learning / hard-gate banners, standing copy, points, or grants.

Law 6 / Bible §4.8 / §19.1 are not refuted for this lane’s exclusive files. The brief already allows a player-opened minimal frame. The empty window is not unbidden Quiet chrome (it starts hidden; `/beef` or persisted `ui.shown` opens it). It is not a Decree and not a Director Console. Residual tab-registry hooks, a dead `GetLadderView` class-color helper, `RefreshLadder` as a name, and `db.ui.announce` are leftovers — not a second guild-management window.

## Confirmations

| Check | Result |
|---|---|
| `UI/LadderTab.lua` gone | **Yes.** Not on disk. Not under `attic/`. Git: `D`. |
| `UI/OfficerTab.lua` gone | **Yes.** Not on disk. Git: `D`. |
| `UI/Announce.lua` gone | **Yes.** Not on disk. Git: `D`. Prefer-delete honored (no stub). |
| MainFrame keeps drag / resize / coalesce | **Yes.** Title-bar drag, grip + Classic min/max, `PAINT_COALESCE` 0.1, `ResetSize`, SV point/size. |
| No Standing / Ladder / Officer tab IA | **Yes.** No product tabs register. No Ladder / Standing / Officer buttons. Empty content host. |
| `/beef` may open a minimal tabless frame | **Yes.** Title `"Church of Beef"`, empty content, footer, optional status chip. Allowed by the brief. |
| No Director Console / Decree / Event theater invented | **Yes.** No Presence / Knighting / Gora desks, no parchment Decree, no HUD / cards / favor / ceremonial sound. |
| `Status.lua` has no standing / points / grant chip | **Yes.** States: `unguilded`, `roster_wait`, `ready`. Soft flag: `version_warn` only. `ShowsLearningBanner` / `ShowsHardGateBanner` gone. |
| `tests/test_officer_ui.lua` gone | **Yes.** Writer deleted it (standing / officer-queue only). Git: `D`. |
| `tests/test_ui.lua` rewritten off deleted tabs | **Yes.** Isolated run: **119 passed, 0 failed.** Asserts zero shipped tabs; does not `dofile` deleted files. |
| TOC no longer lists Announce / LadderTab / OfficerTab | **Yes.** Integrator. Notes: `"Ceremony, sanctioned Gora, and memory…"` — no “rank ladder.” |
| `tests/run.lua` no longer lists `test_officer_ui` | **Yes.** Integrator. |
| Writer did not edit forbidden files | **Yes.** Transcript writes/deletes are MainFrame, Status, `test_ui.lua`, the four deletes, and the lane report only. Toasts / Minimap / StandingTab / TOC / bootstrap / `run.lua` were read, not edited. |

Writer brief forbade TOC / bootstrap / `run.lua` edits. Integrator owns those files (`docs/REFORMATION_LOG.md`). Writer report’s “still listed” lines are stale against the current tree.

## Attack results

| Attack | Result |
|---|---|
| Guild-management window still present under another tab name? | **No.** Live UI folder is MainFrame, Status, Minimap, Toasts. No `RegisterTab` caller in `addon/`. No Roster / Presence / Guild / Records / Console tab. Probe registration exists only inside `test_ui.lua` and is not shipped. |
| Director Console invented? | **No.** No §18.1 desks, queues, or one-click ritual verbs. Header states the frame is not a Director Console. Title is the addon name. |
| Decree banner invented? | **No.** No parchment, no Gathering copy, no once-per-login banner. Footer `"Eternal Grazing."` is pre-existing chrome, not §14.1. |
| Event theater invented? | **No.** No proclamations, fighter cards, HUD, favor, seals, or §19.4 cues in exclusive files. |
| Status still shows standing / points / grants? | **No.** Chip copy is `"Not in a guild"`, `"Reading the guild roster…"`, `""`, or `"BeefNet version mismatch"`. Ready hides the chip. |
| Announce spectacle moved into MainFrame? | **No.** No `SendChatMessage`, no promote / demote / council / prophet liturgy, no `COB.Announce`. |
| Writer edited forbidden files? | **No.** See confirmations. Integrator dropped TOC lines and `test_officer_ui` after the writer. Lane E owns StandingTab / Toasts / Minimap diffs. |
| Quiet Mode violated by the `/beef` frame? | **No for this brief.** Law 6 bans unbidden feeds / dashboards. The brief explicitly allows a minimal player-opened frame. Frame starts hidden. Chip is not always-on Quiet chrome. Version-mismatch on the player-opened chip is the §13.4 notice, not a toast-kind family. |
| Tab registry = leftover IA that fails Spec? | **No.** Audit: salvage plumbing, discard IA. Registry is empty at load. Standing / Ladder / Officer *content* is gone. `officerOnly` / gold-idle tab chrome / `ClassColorCode` are empty hooks, not a presented window. |

Refutation of Law 6 / Bible §4.8 / Audit MainFrame-rework **fails** for this lane. The banned IA is the tabbed guild-management window. It is gone.

## Leftover callers (expected; not fixed)

TOC leftovers named in the writer report were integrator-owned and are **already dropped**. Do not treat them as current. `db.ui.announce` is other-lane. Do not fix.

| File | What remains | Owner |
|---|---|---|
| `Core/DB.lua` | `ui.announce` default / migrate | Lane G / DB. Unused with Announce gone. |
| `tests/test_db.lua` | asserts `ChurchOfBeefDB.ui.announce` | Follows DB schema. |
| `Net/BeefNet.lua` | `COB.UI:RefreshLadder()` | Valid leftover name. Body is `MarkDirty()` + optional `Minimap:Refresh`. Paints no tabs. |
| `Core/Roster.lua` | `GetLadderView()` | Other-lane leftover name. MainFrame’s dead `ClassColorCode` still walks it. |
| `tests/wow_ui_stub.lua` | comment: announce suite / guild-chat recorder | Harness leftover. Not a live announcer. |

`ChurchOfBeef.lua` `/beef` only `Toggle`s the shell (or `minimap`). No tab names. `SavedVariablesPerCharacter` on the TOC is identity / packaging — out of this lane.

## Findings

### Critical

None.

### Important

1. **`UI:ClassColorCode` still walks `Roster:GetLadderView()`.** (`MainFrame.lua`.) Dead helper — nothing in live UI calls it after the tabs died. It is leftover ladder coupling inside an exclusive file, not a presented ladder. Not Spec.

2. **Full tab registry remains** (`RegisterTab`, `officerOnly`, `UpdateOfficerVisibility`, gold / idle `PanelTabButtonTemplate`, CharacterFrame-style bottom chain). Empty at ship. Writer kept it as plumbing; the brief did not forbid the registry. A later lane can re-attach a guild-management window without growing new chrome. Documented in the writer report. Not Spec.

3. **`tests/test_ui.lua` still covers the toast engine and minimap hide preference.** The rewrite dropped tab IA and does not require deleted files. It is not *only* drag/resize/coalesce. Toast / minimap coverage belongs with Lane E surfaces the writer was forbidden to edit. Does not restore Standing / Ladder / Officer.

4. **Writer leftover map is stale** (`P1-F-shell.md`). TOC and `tests/run.lua` no longer list Announce / LadderTab / OfficerTab / `test_officer_ui`. Integrator already moved those. Does not reopen Spec.

### Nit

1. **Footer `"Eternal Grazing."`** is leftover joke chrome (Law 10: the UI never tells jokes). Pre-existing; writer disclosed; not a Decree; not invented this lane.

2. **Comments still name the Find strip, Amendment §6.1, and “an officer acting on a queue.”** Archived large-guild / officer-desk residue. Not live IA.

3. **`RefreshLadder` name kept.** Documented. BeefNet still calls it.

4. **In-game `/reload` smoke was not run.** Writer disclosed (TOC was unloadable at write time). Isolated `test_ui` is green. Client smoke is still a human path (`verification.mdc`).

## Brief contract

| Requirement | Result |
|---|---|
| Delete or gut LadderTab / OfficerTab / Announce (prefer delete) | Met (deleted) |
| Keep MainFrame drag / resize / coalesce | Met |
| Remove Standing / Ladder / Officer tab IA | Met |
| Do not invent Director Console / Decree / Event theater | Met |
| Status: no standing / points / grant chip | Met |
| Rewrite or delete tab-only tests | Met (`test_officer_ui` deleted; `test_ui` no longer requires those tabs) |
| Do not edit Toasts / Minimap / StandingTab / TOC / bootstrap / `run.lua` (writer) | Met (integrator dropped TOC + suite list) |
| Report leftover callers; do not fix them | Met |
| No commit | Met |
| Tabs / Console / Decree not restored this review | Met |

## Sections checked

- Brief `docs/reformation/phase-1/briefs/P1-F-shell.md`
- Writer report `docs/reformation/phase-1/reports/P1-F-shell.md`
- Writer transcript [Shell IA](a57732e0-666b-43a7-811c-5af8444b4336)
- `docs/reformation/phase-0/TEN_LAWS.md` Law 6
- Bible §4.8, §14.1–14.2, §18.1, §19.1–19.3
- Audit §4 `UI/MainFrame.lua` Rework; V9; §6 step 2
- `addon/ChurchOfBeef/UI/MainFrame.lua` (full)
- `addon/ChurchOfBeef/UI/Status.lua` (full)
- `ChurchOfBeef.toc`, `ChurchOfBeef.lua`, `tests/run.lua`
- Live `addon/ChurchOfBeef/UI/` (four files; no LadderTab / OfficerTab / Announce / StandingTab)
- `tests/test_ui.lua` (full); isolated run 119 / 0
- Repo glob for deleted filenames; `RegisterTab` / `ShowTab` / Announce / Director / Decree / Grant / standing chip in exclusive files
- `docs/REFORMATION_LOG.md` P1-F integrator note
- `docs/design/OPEN_QUESTIONS.md` (no item appended; none required)
