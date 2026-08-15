# Phase 6 Lane J — Adversarial Review

**Lane:** Fight HUD leftover
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua` (edit only if broken), `tests/test_hud.lua` (only if needed), `docs/reformation/phase-6/reports/P6-J-hud.md`
**Lane report:** `docs/reformation/phase-6/reports/P6-J-hud.md`
**Cited law:** Ten Laws 6, 8, 10; Bible §10.7, §19.2, Appendix A item 1; `.cursor/rules/gora-sanction.mdc` (Fight HUD); P4-F signed surface (`docs/reformation/phase-4/reports/P4-F-hud-review.md`); ledger leftover wave (`docs/REFORMATION_LOG.md`: verify only unless the pair contract is broken)
**Writer:** [Fight HUD](f1fd2b5c-30f7-47ef-ae8c-bc906088d074)
**Format example:** `docs/reformation/phase-6/reports/P6-A-appendix-a-review.md`

**Spec:** PASS
**Quality:** Approved

Leftover check, not a rebuild. `Hud.lua` and `test_hud.lua` mtimes are still P4-F (07:28:51 / 07:28:34). Writer Writes are the report only (08:54:38). Pair contract still holds inside `Refresh`: Event Mode, not QUIET, live `Gora:GetSanctioned()` pair with both fighter ids. QUIET hides. Incomplete / missing pair hides. `GetView().health` and `.favor` stay nil. No `UnitHealth`, nameplate, combat-log, or `StatusBar`. Missing Store row paints an empty name, not a demo fighter, and does not mint a Store row. Isolated `lua tests/test_hud.lua`: **226 passed, 0 failed** (reviewer rerun, Lua 5.1.5, exit 0). A01 Result is still **NOT RUN** (owner David). Writer did not treat the no-health fallback as an A01 pass. `#2` is unchanged. This review did not invent live health, fake Gora rows, or fill A01, and did not commit.

## Verdict

Refutation of “HUD shows in QUIET / without a pair / invents health / invents characters / treats no-health as A01 PASS / secretly edited product files” **fails** for this lane’s exclusive files.

Law 6 is intact in `Hud.lua`. `Hud.MODE = "Event"`. `Refresh` shows only when `Runtime:Snapshot().state ~= "QUIET"` **and** `Gora:GetSanctioned()` has both `fighterA` and `fighterB`. QUIET, ASSEMBLY without a pair, and a cleared pair call `paintHidden`. `Hud:Init` at login (`MainFrame` `UI:Init`) Refresh-hides in QUIET. No toast, pip, sound, or always-visible Tuesday card.

Law 8 is intact. The card reads Store W/L and head-to-head. It does not start a duel, scrape health, parse the combat log, mint a meter, or score favor. Combat remains WoW’s. Appendix A item 1 stays **NOT RUN**.

Law 10 is intact on the terms P4-F already signed. Compact spectator card. Class tint on names only. Mute “VS”. No joke copy. `POLISH:CANDIDATE` only; this leftover check did not upgrade it.

§10.7’s defined fallback (everything except live health) is still the shipped surface. Favor and defense count stay omitted (INPUT unspecified; Store still strips `defenses` / `#9`). “Persists through the verdict beat” is still the P4-F leftover: Gora clears the pair on a ruling, so a Refresh hides at ratification. Writer disclosed that. Do not reopen it as a Hud.lua defect.

§19.2 is intact. The HUD does not enter or exit Event Mode. It keys off the runtime plus a sanctioned pair.

This review did not invent a health hack, a demo pair, an A01 Result, or a `#2` answer, and did not commit.

## Claims vs evidence

| Writer claim | Evidence | Holds? |
|---|---|---|
| No Lua edits; `Hud.lua` / `test_hud.lua` read only | Mtimes: Hud `07:28:51`, suite `07:28:34` — identical to P4-F writer. Report `08:54:38` is the only new file in this exclusive set. `git status`: both still `??` (untracked since P4-F); no hunk from this writer. | **Yes.** |
| Pair contract already holds in `Hud.lua` | `Refresh` = `eventLive() and livePair()`. `eventLive` is `Snapshot().state ~= "QUIET"`. `livePair` requires both fighter ids from `Gora:GetSanctioned()`. `paintHidden` otherwise. Matches P4-F signed contract. | **Yes.** |
| Hide in QUIET | Suite: Init Quiet hidden; `EndEvent` → QUIET hidden. Reviewer: `eventLive()` is false when Runtime is missing or state is `QUIET`. Gora `_Expire` also nils the pair when there is no live event. | **Yes** when `Refresh` runs. Stale-widget leftover is Console wire (below). |
| Hide without a pair | Suite: ASSEMBLY without `GetSanctioned`; `CreateCharacter` alone stays hidden; `DeclareVictor` hides mid-event. Incomplete pair (`fighterA` or `fighterB` nil) returns nil from `livePair`. | **Yes** when `Refresh` runs. |
| No live health; not an A01 pass | `hiddenView` / `paintShown` set `health = nil`. Source has no `UnitHealth`, `UnitHealthMax`, `COMBAT_LOG`, `NamePlate`, `C_NamePlate`, `StatusBar`, `PlaySound`. Suite stubs stay at `healthReads == 0`. A01 header still `Result: NOT RUN`, owner David. Writer: “It is not an A01 pass.” | **Yes.** |
| No invented characters | `fighterFrom` reads `Store:GetCharacter`. Missing row → `name = ""`, no `CreateCharacter`. Suite: HUD does not write the character name; `Hud.Sanction` is nil. Test names (`Chuckroast` / `Tendermage`) come from the existing `twoChars` helper, not from Hud. This lane did not add Store Gora rows. | **Yes** (no Store mint). Display `0-0` on a missing row is a paint stub, not a demo fighter. |
| Isolated suite 226/0; `lua tests/test_hud.lua` exits 0 | Reviewer rerun, Lua 5.1.5, workspace root: `Tests finished: 226 passed, 0 failed`, exit 0. Isolation asserts remain in `if standalone then`. | **Yes.** |
| Console leftover: no `Hud:Refresh` after Sanction (P6-I) | At writer mtime `08:54:38`, Console was still `07:28:45` and `after()` only called `Console:Refresh`. First reviewer grep (pre-08:56) found no `Hud:Refresh`. Ledger assigns that exclusive edit to P6-I. | **Yes at write time.** Parallel P6-I began wiring `refreshHud` / `wantHud` at `08:56:15` — after this report. Not this writer. |
| Did not edit A01 / Console / Gora / Store / `OPEN_QUESTIONS.md` | A01 `08:07:00` (P6-A). Gora `07:16:29` (P4-C; pre-existing `M`, not this writer). Store `2026-08-14 22:07`. `#2` still: “Appendix A item 1 result decides HUD final form.” `OPEN_QUESTIONS.md` `08:52:43` is a parallel leftover-wave edit (`#8` license / `#11` console host) — `#2` untouched. | **Yes for this writer.** |
| A01 NOT RUN; no V1 / MVP; no `POLISH:PASS` | A01 Result field unchanged. Report refuses those claims. `POLISH:CANDIDATE` only, already claimed in P4-F. | **Yes.** |

## Confirmations

| Check | Result |
|---|---|
| Writer did not edit `Hud.lua` / `test_hud.lua` / A01 / Console / Gora / Store / `OPEN_QUESTIONS.md` | **Yes for this writer.** Exclusive write is the report. Forbidden-product mtimes are older or belong to parallel lanes (Console `08:56:15` = P6-I; `OPEN_QUESTIONS.md` `08:52:43` = leftover-wave `#8`/`#11`; `REFORMATION_LOG.md` `08:56:16` = orchestrator). |
| HUD does not show in QUIET when `Refresh` is invoked | **Yes.** `eventLive()` is false. Suite + `paintHidden`. |
| HUD does not show without a sanctioned pair | **Yes.** `livePair()` nil. Characters alone are not a Sanction. |
| HUD does not invent live health | **Yes.** `health` always nil. No scrape APIs. A01 not filled. |
| HUD does not invent Store characters | **Yes.** Read-only `GetCharacter`. Empty name on a missing row. |
| No-health fallback is not treated as A01 PASS | **Yes.** Writer and A01 “Not a pass” agree. `#2` open. |
| Isolated suite green | **Yes.** `lua tests/test_hud.lua` → **226 passed, 0 failed**, exit 0. |

## Attack results

| Attack | Result |
|---|---|
| Law 6 — HUD shows in QUIET? | **No** on `Refresh`. `state ~= "QUIET"` is required. Reviewer: missing Runtime → hidden. A leftover pair while QUIET still hides because `eventLive` is false (`GetSanctioned` also `_Expire`s). |
| Law 6 — widget can *remain* shown in QUIET if nobody calls `Refresh`? | **Yes as leftover, not as Hud.lua.** `paintHidden` is Refresh-only. Writer assigned the caller to P6-I (Sanction, ruling, `EndEvent`). At 08:54 Console did not call it. After 08:56 P6-I started `wantHud` on those verbs. Do not treat the parallel wire as this lane, and do not “fix” Hud.lua to poll. |
| Law 6 — `Hud:Init` at login is Quiet chrome? | **No.** `build()` ends `Hide`. Quiet `Refresh` hides. A Tuesday login that called `Init` still shows nothing. |
| Law 6 — `awaitingPope` / Knighting + live pair is Quiet chrome? | **No.** Event Mode degraded / pair + not QUIET, as P4-F already signed. No pair → hidden even in RITE. |
| Without a pair — `CreateCharacter` or ASSEMBLY alone shows the card? | **No.** Suite locks both. `Gora:GetSanctioned()` is the only pair source. HUD has no `Sanction`. |
| Law 8 — no-health card still scrapes HP (`UnitHealth`, nameplates, combat log)? | **No.** Source grep clean. Suite `healthReads == 0`. No `StatusBar`. |
| Law 8 — writer treated `health == nil` as A01 PASS? | **No.** Explicit “not an A01 pass.” A01 Result still NOT RUN. `#2` unread-as-answered. |
| Invented characters / fake Store Gora rows so the HUD can demo? | **No.** No `CreateCharacter` / `RecordGoraResult` in `Hud.lua`. This lane did not edit Store or the suite. Missing row → empty name, not “Chuckroast.” |
| Missing Store row paints a demo fighter (`0-0` + empty name)? | **No as Store mint.** It is a display stub. Suite does not assert the missing-row path (P4-F leftover). Not a secret character. |
| Writer secretly edited product files? | **No.** Hud / suite mtimes are P4-F. A01 is P6-A. Gora / Store older. Console jump is P6-I after this report. |
| Writer claimed A01 or V1 / MVP? | **No.** |
| §10.7 missing favor / defenses / verdict-beat persist is a Spec miss for this leftover check? | **No.** P4-F brief + review already ruled those leftovers. Ledger: verify only unless the pair contract is broken. Pair contract is not broken. Do not rebuild. |

Refutation of Law 6 (Quiet contract; Event chrome gone in QUIET on Refresh), Law 8 (unmodified duel; no scrape / meters; A01 not a pass), Law 10 (hybrid card; mute; no jokes), Bible §10.7 (fallback without live health; no invented favor or defense paint), §19.2 (theater hangs on the runtime), Appendix A item 1 (NOT RUN), and “no secret product edit / no A01 claim” **fails** for the exclusive files.

## Isolated rerun

Reviewer rerun, Lua 5.1.5, workspace root. No `tests/run.lua` edit. No Store Gora rows added.

| Suite | Result |
|---|---|
| `lua tests/test_hud.lua` | **226 passed, 0 failed** (exit 0) |

Writer count matches. Full harness was not required (no Core/Data/harness edit this lane).

## Leftovers (other lanes / David — not fixed)

Writer leftovers are current except the Console caller, which P6-I began after this report.

### P6-I (exclusive Console — in flight after 08:54)

- `Hud:Refresh` after Sanction, ruling, and `EndEvent` so the card appears at sanction and hides when the pair clears or the machine returns to QUIET.
- Writer was correct that the desk `Console:Refresh` is not that paint.
- Do not invent a sanctioned pair in Store so the HUD can demo.
- `#8` still gates live rituals until P6-H lands a listed Pope. Wiring `Hud:Refresh` does not make a Gathering.

### David (in-game)

- Walk A01 on Anniversary `20506` and write the Result. Agents do not tick it.
- OPEN_QUESTIONS `#2` waits on that Result. Do not treat the coded no-health HUD as the answer.

### Already signed leftovers (do not reopen as Hud.lua)

- Favor split: Bible-named; INPUT unspecified. Bar stays omitted.
- Defense count: Bible-named; Store still strips `defenses` / `defenseCount` (`#9`).
- §10.7 “persists through the verdict beat”: Gora clears the pair on a ruling. Card exits at ratification if Refresh runs.
- Congregation paint needs a live pair on that client. Do not invent Net paint here.
- Sound callers are P6-I, not this file.

## Findings

### Critical

None.

### Important

None that reopen Spec. The Console `Hud:Refresh` leftover the writer named is real at 08:54 and is P6-I’s exclusive file. A parallel edit at 08:56 does not make this leftover-check a rebuild, and does not make A01 a pass.

### Nit

1. **“`#2` unread” then cites the Bible/A01 sentence.** Harmless. The file was not edited by this writer; `#2` text is unchanged.

2. **Missing-row empty name is code-true, suite-untested.** P4-F already shipped that stub. This leftover check correctly refused to edit the suite.

3. **Leftover sentence aged in two minutes.** P6-I started `refreshHud` / `wantHud` at 08:56:15. Expected parallel. Do not credit this writer with that wire, and do not fail them for a report that was true when written.

## Brief contract

| Requirement | Result |
|---|---|
| Verify pair contract; edit `Hud.lua` only if broken | Met (not broken; no edit) |
| Edit `test_hud.lua` only if needed | Met (not edited) |
| Do not show in QUIET / without a pair | Met on `Refresh` |
| Do not invent health / characters / A01 Result | Met |
| Do not treat no-health HUD as A01 pass | Met |
| Do not edit Console / Gora / Store / A01 / `OPEN_QUESTIONS.md` | Met (this writer) |
| Isolated `test_hud` green if run | Met (226/0, exit 0) |
| No commit; do not claim V1 / MVP | Met |

## Sections checked

- Writer report `docs/reformation/phase-6/reports/P6-J-hud.md`
- `addon/ChurchOfBeef/UI/Hud.lua` (full)
- `tests/test_hud.lua` (full)
- `docs/validation/A01-live-health.md` (Result NOT RUN)
- Bible §10.7, §19.2, Appendix A item 1, §22.1 item 2
- Ten Laws 6, 8, 10; `.cursor/rules/gora-sanction.mdc` (Fight HUD)
- P4-F report + review (signed pair contract)
- Read-only: `UI/Console.lua` (no `Hud:Refresh` at writer mtime; P6-I `refreshHud` after 08:56), `UI/MainFrame.lua` `Hud:Init`, `Core/Gora.lua` `GetSanctioned` / `_Expire`
- `docs/design/OPEN_QUESTIONS.md` `#2` unchanged
- Mtimes / `git status` vs writer claim
- Isolated rerun `lua tests/test_hud.lua`

**Spec PASS**
**Quality Approved**
