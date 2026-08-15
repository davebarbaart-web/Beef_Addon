# Phase 4 Lane E — Adversarial Review

**Lane:** Director Console (stock desks)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`
**Lane report:** `docs/reformation/phase-4/reports/P4-E-console.md`
**Cited law:** Ten Laws 3, 4, 6, 10; Bible §18.1–18.3, §20.2, §8, §19.3; `.cursor/rules/ui-juice-standards.mdc`; `.cursor/rules/quiet-event-modes.mdc`; `.cursor/rules/wow-ui-taint-lockdown.mdc`; brief `docs/reformation/phase-4/briefs/P4-E-console.md`
**Writer:** [Console](a6853f45-0b46-4d4b-92c8-6f766575545f)

**Spec:** PASS
**Quality:** Approved

Pope working tool. Stock `BasicFrameTemplate` / `UIPanelButtonTemplate` / `GameFont*` desks. Not theatrical parchment. The UI never tells jokes. `Toggle` / `Show` / `Hide` only; no new slash; `/beef` stays the Quiet empty shell. Ritual verbs call signed Core only when `Sender:IsRegisteredPope(local)` is true — always false today; the list was not stubbed true. Desks: Presence, Knighting (caller-supplied human id), Gora, MARK THIS MOMENT; Notebook is a header only. No `GuildPromote`, HUD, Records, Decree, favor, INPUT, or `Data/Popes.lua`. Isolated suite: **215 passed, 0 failed**. Writer stayed inside exclusive files. Integrator already listed `UI/Console.lua` and `test_console` (writer leftover is stale). `OPEN_QUESTIONS.md` #8 unchanged. No commit. This review did not invent a Pope list, a slash, or a Notebook store, and did not edit `Console.lua` or the suite.

## Verdict

Refutation of Laws 3, 4, 6, 10, Bible §18.1–18.3 / §20.2, and “ritual verbs stay fail-closed / no new slash / UI never jokes” **fails** for this lane’s exclusive files.

Law 3 is intact on the terms the brief set. Knighting, sanction, verdicts, elevation, and the runtime verbs are one-click Console actions that call signed Core. Officers have no ritual path in this file. The gate is `Sender:IsRegisteredPope` of the local player, not `rankIndex ≤ 1` and not a workspace Pope file. Today the predicate is always false, so even the real Pope cannot fire these buttons on a live client. That is fail-closed `#8`, not officer sovereignty. `Show` / `Toggle` are ungated; they do not write.

Law 4 is intact. Nothing auto-declares a victor, auto-opens a rite after `StartEvent`, auto-continues after a ruling, auto-announces, or appends flavor. `StartEvent` has no event-setup fields. `OpenRite("Proclamation")` is a rite type only. The FREE RULING button passes no text. There is no queue to advance. The software does not narrate.

Law 6 is intact. `COB.Console.MODE = "event"`. This is the Pope working tool that starts events from QUIET (§20.2), not Quiet congregation chrome. The frame starts hidden. `Init` is lazy. Bootstrap and MainFrame do not call it. `/beef` still opens the Quiet empty shell. No toasts, sound, pips, favor bar, HUD, Decree, or feed in this file.

Law 10 and §19.3 are intact. Functional stock templates. No custom media, no parchment paint, no meme chrome. Visible copy is Bible desk and verb names plus mechanical flags (`needs Knighting`, runtime state). Contrast with theater is left to other surfaces.

§18.1’s full MVP desk (queue, targeting, suggested pairings, stipulation line, Notebook persist) is carved out by the brief. The shipped slice is Presence / Knighting / Gora / MARK THIS MOMENT plus a Notebook label. §18.2 holds. §18.3 persist is omitted. §20.2 one-clicks and zero-config Tuesday start are present. §8’s guild-rank promotion, proclamation, and next-candidate staging are leftovers — Core purity and the brief forbid `GuildPromote` here.

Ritual verbs stay fail-closed. No new slash. UI never jokes.

## Confirmations

| Check | Result |
|---|---|
| Stock-template functional desks; not theatrical parchment; UI never jokes | **Yes.** Frame is `BasicFrameTemplate` under `UIParent`. Seventeen buttons are `UIPanelButtonTemplate`. Headers and lists are `GameFontNormal` / `GameFontHighlightSmall`. Zero `EditBox`. No `SetTexture` / `SetVertexColor` / custom media. Title is `Director Console`. Suite locks `Eternal Grazing.` absent. Reviewer font walk: no lol/meme/joke chrome. Verb labels are Bible names. |
| `Toggle` / `Show` / `Hide` only; no new slash; `/beef` unchanged | **Yes.** Public lifecycle is `Init` / `Show` / `Hide` / `Toggle` / `IsShown`. `SLASH_CHURCHOFBEEF1` unchanged in the suite. Console does not register a slash. Bootstrap still has only `/beef`. MainFrame still says `/beef` is not a Director Console (mtime Aug 14; writer Read only). Frame name is `ChurchOfBeefConsoleFrame`, not `ChurchOfBeefFrame`. |
| Ritual verbs call Core only when `Sender:IsRegisteredPope(local)` — always false today; not stubbed as a Pope list | **Yes.** Missing Sender, non-function predicate, and the live `return false` all refuse with `nil, "not the registered pope"` and do not call Runtime / Knighting / Gora / Store. Button `OnClick` while fail-closed does not `StartEvent` / knight / flag. Suite wraps the predicate in one section, then restores; after restore `IsRegisteredPope` is false again. No `Data/Popes.lua`. `COB.Popes` is nil. `RegisterPope` is nil. |
| Desks: Presence, Knighting (caller id), Gora, MARK THIS MOMENT; no Notebook persist | **Yes.** Presence from Roster + Store (copies). Knighting buttons call `KnightThisBeef` / `ElevateToLord` with argument or `selectedHumanId`. Gora: petitions, Sanction, Dismiss, four rulings. `FlagMoment` → `Store:FlagMoment`. `SaveNote` / `GetNotes` / `notes` are nil. Notebook is a `GameFontNormal` header only. |
| No `GuildPromote`, HUD, Records, Decree, favor, INPUT, `Data/Popes.lua` | **Yes.** `GuildPromote` / `SetGuildRank` stubs stay 0 (suite + reviewer knight/elevate). `OpenHud` / `OpenRecords` / `ShowDecree` / `Favor` / `INPUT` are nil. `addon/ChurchOfBeef/Data/` is only `Ranks.lua`. |
| Isolated suite green | **Yes.** Reviewer rerun: `lua tests/test_console.lua` → **215 passed, 0 failed** (Lua 5.1.5). Isolation asserts wrapped in `if standalone then`. Writer count matches. Full harness (integrator list): **5248 passed, 0 failed**. |
| Writer did not edit TOC / bootstrap / `run.lua` / MainFrame | **Yes.** Transcript Writes: `tests/test_console.lua` (first), `UI/Console.lua`, this lane’s report. Those other paths were Read only. Mtimes: MainFrame / bootstrap Aug 14; Console 07:28:45; suite 07:28:32; report 07:29:03; TOC and `run.lua` 07:29:32 list `UI\Console.lua` / `test_console` — integrator, after the writer. Exclusive files still untracked. No commit. |

## Attack results

| Attack | Result |
|---|---|
| Law 3 — officers / any client can knight because buttons exist? | **No.** Every ritual verb returns `nil, "not the registered pope"` unless `Sender:IsRegisteredPope(local) == true`. Dead buttons do not call Core. Reviewer: missing Sender and a non-function predicate also refuse. Direct `COB.Knighting` calls are Lane D, not this file. |
| Law 3 — wrapping `IsRegisteredPope` in the suite stubs a Pope list? | **No.** One in-test function replace, then restore. No names table. No `Data/Popes.lua`. `#8` text unchanged. |
| Law 3 — `Show` / `Toggle` are ungated, so congregation has administration? | **No as this lane.** Brief requires `Toggle` / `Show` / `Hide` and forbids a slash. Nothing in bootstrap or MainFrame calls them. A `/run` escape is not a product entry. Integrator must not wire this to `/beef` or the minimap. §18.5 leftover, not a writer miss. |
| Law 3 — always-false gate means the Pope has no sovereignty? | **No.** `#8` is uncoded. “No Pope, no rituals” is the fail-closed property until the list exists. Officers do not gain the verbs. |
| Law 3 / layers — Console is a second authority-gate outside `Officer.lua`? | **No.** The brief requires `Sender:IsRegisteredPope`. That is the existing registered-Pope predicate, not an Officer+ check and not a new list. |
| Law 4 — `StartEvent` auto-opens a rite / is a setup wizard? | **No.** Zero args. Snapshot is `ASSEMBLY` with `riteType` nil. No EditBoxes. Four `OpenRite` kinds are separate clicks. Unknown `Tournament` is refused. |
| Law 4 — `KnightThisBeef` / `Sanction` / `DeclareVictor` auto-advance Runtime? | **No.** Reviewer: knight leaves `ASSEMBLY`. `DeclareVictor` leaves `RITE`. No `AdvanceQueue` / `NextCandidate`. |
| Law 4 — `OpenRite("Proclamation")` or FREE RULING generates narration? | **No.** Proclamation is a rite type; no body/text field. `FreeRuling()` from the button passes nil; Gora returns `text = nil`. `Narrate` / `Proclaim` / `Announce` are nil. |
| Law 4 — `FlagMoment(location, note)` is Notebook persist / generated Chronicle text? | **No.** Second arg is Store’s injectable `now`, misnamed `note`. Reviewer: `FlagMoment("Goldshire", "promised him a Gora")` stores `location` only; no `note` / `text` field. Clock ignores a string. Do not invent a notes table to “fix” the name. |
| Law 6 — Event Mode console shown during QUIET is a Quiet dashboard? | **No.** §20.2 starts events from this desk. Player-opened Pope tool, not unbidden congregation chrome. Frame starts hidden. No sound, toast, pip, or feed. |
| Law 6 — TOC load creates Quiet chrome? | **No.** `Init` is lazy. Writer did not call it from bootstrap. Loading the file defines `COB.Console` only. |
| Law 6 — `MODE = "event"` is undeclared / Quiet? | **No.** Declared. Brief: not Quiet congregation chrome. |
| Law 10 — Bible verb names / `needs Knighting` are UI jokes? | **No.** Those are §8 / §10.8 / §18.1 names and a Presence flag. No meme clutter. Suite + reviewer joke scan clean. |
| Law 10 — stock 22px buttons fail §6 “large click targets”? | **No as this lane.** Brief wins: stock-template functional. Large targets / keybinds / collapsible are leftover polish. |
| §18.1 — missing queue / targeting / pairings / stipulation / Notebook persist is a spec fail? | **No.** Brief: do not invent a queue store; Notebook persist unspecified; no EditBoxes. Those are leftovers. `Recommend` is not on Console. |
| §18.2 — Console records official outcomes, so UI invents ranks? | **No.** Views call Core. Ranks come from `Knighting:SetRank` via the Pope verb. Presence does not default unlinked names to Fresh Beef. |
| §18.3 — header `Notebook` is a live notes desk? | **No.** No EditBox, no persist API, no notes table. Brief allowed a disabled label. |
| §20.2 — runtime verbs are missing or take setup fields? | **No.** `StartEvent` / `OpenRite` / `CloseRite` / `Continue` / `EndEvent` are one-click. Tuesday start is `StartEvent` with no fields. |
| §8 — Console must `GuildPromote` because KNIGHT THIS BEEF “performs everything the API legally permits”? | **No.** Brief: no `GuildPromote`. Core purity / taint: no protected actions from this UI path. Reviewer stubs stay 0. Guild-rank write is a later Pope-client leftover. |
| “Fail-closed / no new slash / UI never jokes” — comment-only, still slashes or jokes? | **No.** No `SLASH_` / `SlashCmdList` in `Console.lua`. No joke copy. Verbs refuse before Core. |
| Writer invented a Pope list, slash, Notebook store, edited forbidden files, or committed? | **No.** Exclusive Writes only. No `Data/Popes.lua`. `#8` text unchanged. No commit. |

Refutation of Law 3 (Pope ceremonial sovereignty; fail-closed `#8`; no officer ritual), Law 4 (no auto-declare / auto-advance / narration), Law 6 (declared Event Mode; `/beef` stays Quiet), Law 10 / §19.3 (stock desks; UI never jokes), Bible §18.1–18.3 (shipped slice; persist omitted), §20.2 (one-click, zero-config start), and “ritual verbs stay fail-closed / no new slash / UI never jokes” **fails** for the exclusive files.

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current except the integrator listing (already done).

### Integrator (already landed — writer report is stale)

- `ChurchOfBeef.toc` lists `UI\Console.lua` after `UI\MainFrame.lua`. Interface stays `20506`.
- `tests/run.lua` lists `test_console`. Isolated `wow_ui_stub.install` / `restore` did not break the full harness (**5248 / 0**).
- Writer did not edit either file.
- Bootstrap still does not `Init` / `Show` the console. Correct. Do not wire a slash. `/beef` stays the Quiet shell.

### #8 / live client (do not invent here)

- Registered-Pope list stays uncoded (`OPEN_QUESTIONS.md` #8). Console is fail-closed until that list exists. Do not create `Data/Popes.lua` in review.
- Buttons exist for the harness; they do not fire on a live client.
- Do not stub `IsRegisteredPope` true in production.

### §18.1 / §8 / §6 (do not invent here)

- Knighting queue, targeting assist, raid markers, latecomer insertion.
- Gora suggested pairings / head-to-head paint, optional stipulation line, mute cards.
- Guild-rank promotion **where the API permits** — Pope client, later, not this file.
- Proclamation to installed clients; software never narrates.
- Notebook persist (private; unspecified).
- Glanceable large targets, keybinds, collapsible, saved `ChurchOfBeefDB.ui` position (DB edits were forbidden).
- Canonization; SUMMON THE FAITHFUL (stretch).
- Software-proposes surface (`Gora:Propose`) — not this file.
- Petition paint is store character ids, not names.

### Presence hygiene (do not invent UnitIsDead / online here)

- “Here” is `Roster.members`. Roster does not pass the online flag through. Alive is not sensed. Writer report’s “present-and-alive” is roster∩store character id, not `UnitIsDead`.
- Name-match fallback can paint a human’s Church rank on an unlinked roster row when names match (see Important). Do not treat `Names.Same` as a link.

### Out of scope (do not invent here)

- Pope list, slash, Notebook store, Fight HUD, Records Book, Decree, favor / INPUT, `/beef` Console toggle.

## Findings

### Critical

None. No one-line Law 3, Law 4, Law 6, Law 10, §18.1–18.3 / §20.2, or “fail-closed / no slash / UI never jokes” breach in the exclusive files. No Pope list, slash, or Notebook store.

### Important

1. **Ritual verbs are fail-closed until `#8`.** Anyone who can call `COB.Knighting` / `COB.Gora` / `COB.Runtime` still bypasses this UI gate. Correct for this lane: the brief forbids stubbing the list true. Later UI/Net must not treat a congregation client as a writer. Do not add `Data/Popes.lua` here.

2. **`Show` / `Toggle` are ungated.** Congregation Lua can open the admin frame; buttons still refuse. Do not wire this to `/beef`, the minimap, or a new slash. That would be a Law 6 / §18.5 miss for the integrator, not a writer miss.

3. **Presence name-match fallback can paint a Church rank on an unlinked roster name.** If a human named Steve exists and the roster has an unlinked “Steve”, `GetPresence` shows that human’s rank and id (`namesSame`). Stranger-without-a-human stays rankless (suite). This does not invent Fresh Beef and does not write the store. It is still unlinked-character rank display. Do not treat a name string as a link. Do not invent a new identity key here.

4. **`KNIGHT THIS BEEF` on a sitting Lord writes 3.** Specified Lane D `SetRank(humanId, 3)`. Suite fires the button after `ElevateToLord` and asserts rank 3. Not a `Demote` API. Console should not be offered as a demote control later. Do not invent a refusal here.

5. **Integrator leftover in the writer report is stale.** TOC and `run.lua` already list the new files. Not a writer miss.

### Nit

1. **Notebook label is the same `header()` as Presence / Knighting / Gora.** Brief allowed “disabled label.” It does not say unavailable and is not `GameFontDisable`. No persist. Fine.

2. **`FlagMoment(location, note)` names Store’s `now` as `note`.** A string note is discarded by `Clock.Wall`. Not Notebook persist. Do not add a notes field.

3. **`SelectFighters` does not `isId`-check.** Garbage dies at `Gora:Sanction`. `SelectHuman` / `SelectCharacter` do validate.

4. **No confirm on End Event / VOID.** Brief wants one-click sacred actions. Taint “confirm destructive” loses.

5. **Isolation asserts are skipped in the harness** (`if standalone then`). Correct wrap. Isolated run still locks UI / DB / Net / Officer / Hud / Records / Popes / Roster at `nil`.

6. **Petition lines use `characterId` and the word `names`.** Mechanical, not a joke. Not glanceable. Leftover paint.

7. **Optional `now` / `stipulation` / `FreeRuling(text)` pass-throughs are not EditBoxes.** Harness APIs. The buttons pass nil.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated wow_ui_stub + Common + Runtime + Store + Gora + Knighting + Console; isolation asserts in `if standalone then` | Met (215 / 0). Also loads Ranks (titles) and Sender (gate). Transcript: suite first (RED on missing module), then the module. |
| Mode: Pope working tool; Law 10 functional / stock; not Quiet chrome; not theatrical parchment; UI never jokes; no narration | Met |
| Desks: Presence, Knighting (caller human id), Gora, MARK THIS MOMENT; Notebook omit or disabled label; no notes table | Met |
| `Toggle` / `Show` / `Hide` only; no new slash; `/beef` stays Quiet empty shell | Met |
| Ritual verbs only when `Sender:IsRegisteredPope(local)`; always false today; do not stub the list true | Met |
| `StartEvent` / `OpenRite` / `CloseRite` / `Continue` / `EndEvent` one-click; zero-config Tuesday start | Met |
| No auto-advance; no generated proclamation; no `GuildPromote` | Met |
| No favor bar, INPUT, HUD, Records Book, or Decree in this file | Met |
| Do not create `Data/Popes.lua` | Met |
| Do not edit TOC / bootstrap / `run.lua` / MainFrame / Minimap / Status / Toasts / Runtime / Gora / Knighting / Store / Net | Met (integrator listed after) |
| Isolated `test_console.lua` must pass | Met (215 / 0) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 3, 4, 6, 10
- Brief `docs/reformation/phase-4/briefs/P4-E-console.md`
- Writer report `docs/reformation/phase-4/reports/P4-E-console.md`
- Bible §18.1–18.3, §20.2, §8, §19.3 (also §6 / §10.6 / §4.8 / §4.11 as cited by those)
- `.cursor/rules/ui-juice-standards.mdc`
- `.cursor/rules/quiet-event-modes.mdc`
- `.cursor/rules/wow-ui-taint-lockdown.mdc`
- `addon/ChurchOfBeef/UI/Console.lua`
- `tests/test_console.lua` (isolated run: 215 / 0)
- `addon/ChurchOfBeef/UI/MainFrame.lua` (read only; Quiet empty shell; `/beef` unchanged)
- `addon/ChurchOfBeef/Core/Sender.lua` (`IsRegisteredPope` always false)
- Writer transcript ([Console](a6853f45-0b46-4d4b-92c8-6f766575545f)) — exclusive Writes only
- `ChurchOfBeef.toc` / `tests/run.lua` (integrator listing; writer did not edit)
- `ChurchOfBeef.lua` (no `Console` token; slash still `/beef`)
- `addon/ChurchOfBeef/Data/` (no `Popes.lua`)
- `docs/design/OPEN_QUESTIONS.md` (unchanged; #8 do not code)
- Reviewer probes (throwaway; suite not edited): name-match Presence fallback; unlinked alt rankless; needs-Knighting 1/2/nil only; `FlagMoment` note not persisted; missing Sender fail-closed; `Show` in QUIET; `StartEvent` does not OpenRite; knight does not advance Runtime; `DeclareVictor` does not Continue; FreeRuling text nil; Proclamation type only; `GuildPromote` 0; stock templates; zero EditBox; no OnUpdate; predicate restored false
