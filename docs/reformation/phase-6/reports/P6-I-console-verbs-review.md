# Phase 6 Lane I — Adversarial Review

**Lane:** Console Post Decree + Sound callers + Hud:Refresh
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`, `docs/reformation/phase-6/reports/P6-I-console-verbs.md`
**Lane report:** `docs/reformation/phase-6/reports/P6-I-console-verbs.md`
**Cited law:** Ten Laws 3, 4, 6, 10; Bible §14.1, §18.1–18.2, §19.4, §20.2; `.cursor/rules/quiet-event-modes.mdc`; `.cursor/rules/ui-juice-standards.mdc`
**Writer:** [Console verbs](875fdd5e-934e-4e93-bde6-317590b1531f)
**Format example:** `docs/reformation/phase-6/reports/P6-J-hud-review.md`

**Spec:** PASS
**Quality:** Approved

Post Decree is a Pope-gated desk verb that calls `Decree:Set` (`line` + optional `flavor`) and does not play Sound. Event cues match the closed §19.4 map. `Hud:Refresh` runs after Sanction, the four rulings, and `EndEvent`. The desk stays stock-template. Isolated `lua tests/test_console.lua`: **293 passed, 0 failed** (reviewer rerun, Lua 5.1.5, exit 0). Writer did not edit Sound / Hud / Decree / Sender / TOC / bootstrap / `run.lua` / `OPEN_QUESTIONS.md`. `#8` remaining fail-closed is not a miss of this lane. Integrator `/beef console` is not a writer violation. This review did not invent a Decree wire, a Pope list, calendar / RSVP / deputy, extra cues, fake fighters, or live health, and did not commit.

## Verdict

Refutation of “PostDecree is ungated / plays Sound / invents a scheduling suite; Sound callers miss the map or fire on Quiet / runtime transitions; Hud:Refresh is missing or the Console invents fighters / health / Store Gora rows; parchment desk / UI jokes; writer edited forbidden files” **fails** for this lane’s exclusive files.

Law 3 is intact. Every ritual verb, including `PostDecree`, returns `nil, "not the registered pope"` unless `Sender:IsRegisteredPope(local) == true`. Dead buttons do not `Set`. Officers have no ritual path in this file. The suite wrap is one in-test replace, then restore.

Law 4 is intact. Nothing auto-declares, auto-advances, or narrates. Cues fire only after `result ~= nil` from signed Core. Header **A GATHERING HAS BEEN DECREED** is UI copy; `posted.header` is nil.

Law 6 is intact on the terms the brief set. `Console.MODE = "event"`. Post Decree is a Quiet desk verb on that tool: no `playCue`. `Sound:Play` is called after the listed Event verbs; `Sound.lua` already refuses QUIET (07:42:30, not this writer). Runtime transitions stay silent. No toast, pip, or feed.

Law 10 is intact. `BasicFrameTemplate` / `UIPanelButtonTemplate` / `InputBoxTemplate` / `GameFont*`. No parchment paint on the desk. No joke chrome.

§14.1 holds for the shipped slice: one line, optional flavor, Bible header as chrome, no calendar / RSVP / deputy / recurrence / attendance, no wire kind. §18.1–18.2 hold for this leftover (desk verb + callers; queue / targeting / stipulation / Notebook persist stay leftovers). §19.4 map is exact. §20.2 one-clicks are unchanged.

`#8` still fail-closes an unlisted live client. That is not this lane. `/beef console` is integrator-hosted. Do not claim V1 / MVP. No `POLISH:PASS`.

## Claims vs evidence

| Writer claim | Evidence | Holds? |
|---|---|---|
| `PostDecree` refuses unless registered Pope; calls `Decree:Set`; no Sound | `PostDecree` gates on `isRegisteredPope`, then `Decree:Set(decreeFields)`. Success path: `Refresh` + `showDecreeBanner`. No `playCue`. Suite: refuse does not `Set`; wrap sets line/flavor; `#soundCalls` unchanged; `posted.header == nil`. | **Yes.** |
| Header is UI copy, not stored | `DECREE_HEADER` is a FontString. `Decree:Set` stores `line` / `flavor` only (Core 07:42:18, not this writer). | **Yes.** |
| No calendar / RSVP / deputy | No methods, no buttons, no fields. Suite locks `Calendar` / `RSVP` / `Deputy` nil. | **Yes.** |
| Sound map: Sanction→sanction; rulings→verdict; Cowardice→cowardice; Elevate→elevation; Knight→knighting | `after(..., cue, ...)` on those verbs. Suite records the names. | **Yes.** |
| Silent: StartEvent / OpenRite / CloseRite / Continue / EndEvent / Dismiss / FlagMoment / PostDecree | Those paths pass no cue (Dismiss / PostDecree are not `after` cue). Suite locks counts. | **Yes.** |
| No auto-play on Runtime transitions; no extra cues; no Canonization | Runtime verbs call `after` without a cue. No `canonization` string. | **Yes.** |
| Missing / exploding Sound does not fail the verb | `playCue` existence-checks and `pcall`s. Suite: Sanction with `Sound = nil`; Void when `Play` errors. | **Yes.** |
| `Hud:Refresh` after Sanction, rulings, EndEvent | `wantHud` on Sanction, DeclareVictor, CowardiceRecorded, Void, FreeRuling, EndEvent. Suite asserts Sanction / Void / EndEvent. Code has the other three. | **Yes** (suite only required Sanction / EndEvent). |
| No fake fighters, no health, no Store Gora rows from UI | Console does not call `CreateCharacter` / `RecordGoraResult` / `UnitHealth`. `Hud:Refresh` is a no-arg paint. `FlagMoment` is the existing Pope Store verb, not a Gora row. | **Yes.** |
| Stock desks; UI never jokes | Frame `BasicFrameTemplate`. Two `InputBoxTemplate`. Buttons `UIPanelButtonTemplate`. No `SetTexture` / Media. Suite: no `Eternal Grazing.` | **Yes.** |
| Isolated 293/0; `lua tests/test_console.lua` exits 0 | Reviewer rerun, Lua 5.1.5: **293 passed, 0 failed**, exit 0. | **Yes.** |
| Did not edit Sound / Hud / Decree / Sender / TOC / bootstrap / `run.lua` / OPEN_QUESTIONS | Mtimes: Console `08:56:26`, suite `08:58:17`, report `08:58:38`. Sound `07:42:30`. Hud `07:28:51`. UI Decree `07:54:06`. Core Decree `07:42:18`. Sender `08:56:14` (P6-H). TOC `08:57:32` (integrator). Bootstrap `08:52:52` (before this writer). `run.lua` `08:00:33`. `OPEN_QUESTIONS.md` `08:52:43`. Transcript Writes: Console, suite, this report only. | **Yes.** |
| `#8` leftover; no V1 / MVP; no `POLISH:PASS` | Report names the leftover. No those claims. | **Yes.** |

## Confirmations

| Check | Result |
|---|---|
| PostDecree Pope-gated; `Decree:Set(line` + optional flavor); no Sound | **Yes.** |
| No calendar / RSVP / deputy | **Yes.** |
| Sound map matches the brief | **Yes.** |
| Silent on StartEvent / OpenRite / CloseRite / Continue / EndEvent / Dismiss / FlagMoment / PostDecree | **Yes.** |
| `Hud:Refresh` after Sanction, rulings, EndEvent | **Yes** in code. Suite locks Sanction / Void / EndEvent. |
| No fake fighters / health / Store Gora writes from UI | **Yes.** |
| Stock templates; not parchment desks; UI never jokes | **Yes.** |
| Isolated suite green | **Yes.** 293/0, exit 0. |
| Writer did not edit Sound.lua, Hud.lua, Decree.lua, Sender, TOC, bootstrap, `run.lua`, OPEN_QUESTIONS | **Yes.** |
| `#8` fail-closed is not scored as a miss | **Yes.** Not scored. |
| Integrator `/beef console` is not a writer violation | **Yes.** `ChurchOfBeef.lua` `08:52:52` is before Console `08:56:26`. Console registers no slash. |

## Attack results

| Attack | Result |
|---|---|
| Law 3 — PostDecree / ritual buttons fire without a registered Pope? | **No.** Same `REFUSE` gate. Suite: refuse + dead **Post Decree** click do not `Set`. |
| Law 3 — wrapping `IsRegisteredPope` stubs a Pope list? | **No.** In-test replace, then restore. `RegisterPope` is nil. This lane did not edit `Popes.lua` / Sender. |
| Law 3 — `#8` still dead on a live unlisted client, so the lane missed sovereignty? | **No as this lane.** Job: do not treat remaining fail-closed as a miss. Gate is wired. Empty workspace list + no override still refuses. |
| Law 4 — PostDecree stores the header or generates flavor? | **No.** Header is chrome. Flavor is caller-typed. Extra Core fields are ignored (not this file). |
| Law 4 — Sound / banner on a failed `Set` (empty line)? | **No.** Success is `result ~= nil`. Empty line → Core `nil, "line is required"` → no banner, no cue. |
| Law 6 — PostDecree plays Sound? | **No.** Custom success path. Suite: `#soundCalls` unchanged. |
| Law 6 — Console `Play` in QUIET leaks audible Quiet chrome? | **No.** Brief: still call `Play`; `Sound.lua` returns `"quiet"`. Writer did not edit that gate. |
| Law 6 — StartEvent / OpenRite / CloseRite / Continue / EndEvent auto-play? | **No.** No cue. Suite locks it. |
| Law 6 — `DecreeBanner:Show` after Post is a Quiet toast / feed? | **No.** Brief required Show so the Pope sees the parchment they posted. Banner is the §14.1 Quiet surface. No Sound. |
| Law 6 — Event Console open in QUIET is a Tuesday dashboard? | **No.** §20.2 starts events from this desk. Player-opened Pope tool. Frame starts hidden. |
| §19.4 — wrong cue names / extra cue / Canonization? | **No.** Closed map only. |
| §19.4 — congregation never hears the bell, so Console callers are a miss? | **No as this lane.** Exclusive files are Console. Net / apply callers were forbidden. Leftover, not a Spec hole. |
| `Hud:Refresh` missing after a ruling or EndEvent? | **No.** `wantHud` on all six. Knight / Elevate / runtime transitions do not pass it. |
| Console invents fighters, sets health, or writes Store Gora rows so the HUD can demo? | **No.** No-arg `Hud:Refresh`. No health APIs. No `CreateCharacter` / `RecordGoraResult` in `Console.lua`. |
| Law 10 — parchment desk / custom media / joke copy? | **No.** Stock templates. Bible header on a `GameFontNormal` label is chrome, not a theatrical desk. Suite joke scan clean. |
| §14.1 — calendar / RSVP / deputy / recurrence / attendance / wire kind? | **No.** Refused. `#5` unread-as-answered. |
| Writer secretly edited Sound / Hud / Decree / Sender / TOC / bootstrap / `run.lua` / OPEN_QUESTIONS? | **No.** Mtimes + transcript. Parallel P6-H owns Sender `08:56:14`. Integrator owns TOC `08:57:32` and `/beef console` `08:52:52`. |
| Writer claimed V1 / MVP or `POLISH:PASS`? | **No.** |
| Isolated count is a lie? | **No.** 293/0. Full harness (not required): **6033 passed, 0 failed**. P6-H’s in-flight EditBox fail is gone. |

Refutation of Law 3 (Pope-gated verbs; no officer ritual), Law 4 (no auto-declare / narration), Law 6 (Quiet PostDecree; Event cues only; Sound.lua still owns QUIET), Law 10 (stock desk; no jokes), Bible §14.1 (line + optional flavor; no scheduling suite), §18.1–18.2 (desk verb; no auto-announce), §19.4 (closed cue map), §20.2 (silent runtime transitions), and “no forbidden-file edit / no fake HUD / `#8` not this miss” **fails** for the exclusive files.

## Isolated rerun

Reviewer rerun, Lua 5.1.5, workspace root. No `tests/run.lua` edit.

| Suite | Result |
|---|---|
| `lua tests/test_console.lua` | **293 passed, 0 failed** (exit 0) |
| `lua tests/run.lua` (extra; not required) | **6033 passed, 0 failed** (exit 0) |

Writer count matches.

## Leftovers (other lanes / David — not fixed)

Writer leftovers are current.

### `#8` (not this miss)

- Unlisted live client: buttons exist; they do not fire.
- P6-H landed an empty `Data/Popes.lua` + SV override. A listed or override name would open the gate. This lane did not code that list.

### Congregation / persist (not this file)

- No Decree wire kind. Congregation does not receive a posted Decree.
- §19.4 “every installed client” still has no Net / apply `Sound:Play`. Console-only callers were the brief.
- `PostDecree` does not call `DB:Save`. Persist remains the Phase 5 Save / logout snapshot.

### Already signed Console leftovers (do not reopen)

- Knighting queue, targeting / markers, suggested pairings, sanction stipulation box, Notebook persist, `GuildPromote`, favor, INPUT, SUMMON, Canonization.
- FREE RULING still passes no text (P4-E).
- §10.7 “persists through the verdict beat”: Gora clears the pair on a ruling; `Hud:Refresh` then hides. P6-J already signed that.

### David

- `/reload` smoke of `/beef console` + a listed Pope. Harness ≠ Gathering (Bible §22.3).
- A01 Result still **NOT RUN**. Wiring `Hud:Refresh` is not an A01 pass.

## Findings

### Critical

None.

### Important

None that reopen Spec.

### Nit

1. **Hud:Refresh untested on DeclareVictor / CowardiceRecorded / FreeRuling.** Code passes `wantHud`. Brief only required Sanction / EndEvent. Void is locked. Do not rebuild the suite for this.

2. **Knight / Elevate do not assert `hudRefreshes` stayed 0.** Code does not pass `wantHud`. Count after those two is still 0 until Sanction.

3. **Line-only PostDecree (flavor omitted) is untested.** Core already treats missing / empty flavor as nil. Button path always fills both boxes in the suite.

4. **Suite header still says the predicate is “always false today.”** Stale after P6-H’s list + override. Isolated suite still has no `Popes` and no override, so the refuse block holds. Do not treat that as a `#8` miss.

5. **`assert_eq(COB.Popes, nil)` sits outside `if standalone then`.** Holds in the harness only because `test_sender` restores `priorPopes`. Fragile. Not a fail today (6033/0).

## Brief contract

| Requirement | Result |
|---|---|
| `PostDecree` Pope-gated; `Decree:Set`; no Sound; banner Show if present | Met |
| No calendar / RSVP / deputy / wire | Met |
| Sound map + silent runtime / Quiet verbs; missing Sound does not fail | Met |
| `Hud:Refresh` after Sanction, rulings, EndEvent; no fake fighters / health / Store Gora rows | Met |
| Stock desk; not parchment; UI never jokes | Met |
| Isolated `test_console` green | Met (293/0) |
| Do not edit Sound / Hud / Decree / Sender / TOC / bootstrap / `run.lua` / OPEN_QUESTIONS | Met |
| Do not invent `/beef console`, `#8` list, Favor, INPUT, SUMMON, GuildPromote, Notebook persist, live health, fake characters, deputy | Met |
| No commit; no V1 / MVP; no `POLISH:PASS` | Met |

## Sections checked

- Writer report `docs/reformation/phase-6/reports/P6-I-console-verbs.md`
- `addon/ChurchOfBeef/UI/Console.lua` (full)
- `tests/test_console.lua` (full)
- Writer brief (transcript `875fdd5e-934e-4e93-bde6-317590b1531f`)
- Bible §14.1, §18.1–18.2, §19.4, §20.2
- Ten Laws 3, 4, 6, 10; `quiet-event-modes.mdc`; `ui-juice-standards.mdc`
- Read-only: `UI/Sound.lua` `Play` + QUIET refuse; `UI/Hud.lua` `Refresh` pair contract; `Core/Decree.lua` `Set`; `UI/Decree.lua` `Show`; `Core/Sender.lua` `IsRegisteredPope`; `Core/DB.lua` Save snapshot (not called from Console)
- Mtimes / transcript vs writer claim
- Isolated rerun `lua tests/test_console.lua`; extra `lua tests/run.lua`

**Spec PASS**
**Quality Approved**
