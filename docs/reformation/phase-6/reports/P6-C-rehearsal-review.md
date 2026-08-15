# Phase 6 Lane C — Adversarial Review

**Lane:** Dress-rehearsal script (Bible §22.3 release gate)
**Exclusive files:** `docs/phases/dress-rehearsal.md`, `docs/reformation/phase-6/reports/P6-C-rehearsal.md`
**Lane report:** `docs/reformation/phase-6/reports/P6-C-rehearsal.md`
**Cited law:** Ten Laws 4, 5, 6; Bible §22.3, §20.4, §20.1–20.3, §7, §10, §18; `.cursor/rules/ceremony-runtime.mdc` (Chaos test); brief `docs/reformation/phase-6/briefs/P6-C-rehearsal.md`
**Writer:** [Rehearsal](39940c31-f2b0-4dc6-bb31-e98a27b42467)

**Spec:** PASS
**Quality:** Approved

The exclusive file is a guild-only, unstreamed human run-of-show. Status line is **NOT RUN**. Every box is `[ ]` (85). No `[x]`. No dated pass. No V1 / MVP complete claim. No `POLISH:PASS`. The five deliberate failures are present by name. Five / thirty is a scribe quality bar, not `holdSeconds`. `#8`, SUMMON, favor, hosted Console / HUD / Records, unwired Sound, and Console Post are named leftover, not supplied as a pass path. `/run Console:Toggle`, `/run StartEvent`, `/run Decree:Set`, stub `IsRegisteredPope`, and `Data/Popes.lua` are forbidden, not official. Floor is two Anniversary clients (Pope writer + congregation). Offline `test_ceremony_chaos.lua` is a precondition, not this night. This review did not tick boxes, did not edit the script, and does not claim V1 / MVP.

## Verdict

Refutation of the brief contract **fails** for this lane’s exclusive files.

The attack that would FAIL this lane is: invent `#8` / SUMMON / favor / a hosted Console so the night can pass, tick the rehearsal done, or treat the Gate 5 skeleton as a live Gathering. The script does the opposite. Night 0 is the only stretch the load list can prove. Nights 1–3 are human staging with a Bible-expect / Tonight leftover table. The five failures carry a Bible expect and a Tonight leftover. The §22.3 release-gate block is a separate unchecked list that says **the current skeleton cannot satisfy it**.

Law 4 holds as run-of-show: software must not auto-announce, auto-advance, auto-declare, or narrate; the Pope’s voice is the ruling. Law 5 holds: one writer; no self-promotion; snapshot answers are Pope-only and fail-closed tonight. Law 6 holds as Night 0: minimap + optional local Decree; `/beef` is the empty Quiet shell; no toast / pip / sound on a cold login.

Writer report **Status: DONE** is lane authoring. The rehearsal file stays **NOT RUN**.

## Confirmations

| Check | Result |
|---|---|
| Exclusive writes only (`dress-rehearsal.md` + this lane’s report) | **Yes.** Writer transcript: `Write` those two paths only. `OPEN_QUESTIONS.md` mtime 07:23. Writer files 08:07:37 / 08:07:50. `v1-checklist.md` 08:07:08 is Lane B. `docs/validation/**` 08:06–08:07 is Lane A. TOC 08:00:33; bootstrap 08-14. No `Data/Popes.lua`. |
| Status is **NOT RUN**; no `[x]`; no dated pass | **Yes.** Line 3: **NOT RUN. Do not tick this file as done. Do not date a pass.** Reviewer: **85** `- [ ]` rows (12 Night 0 rows are indented); **0** `[x]` rows. One prose “Leave every box `[ ]`.” Release-gate closer: **NOT RUN.** |
| No V1 / MVP complete; no `POLISH:PASS` | **Yes.** Both appear only as **Not** / **Do not claim**. Streamed §22.3 Gathering is named a later product pass. Writer report **Status: DONE** is lane status. |
| All five deliberate failures are in the script | **Yes.** Late arrival; UI reload (both clients, Pope included); disconnect including the Pope’s; no-show petitioner; interrupted or disputed Gora. Matches brief + §22.3 + §20.4 + ceremony-runtime Chaos test. |
| Five / thirty is a quality bar, not a coded hold | **Yes.** Named a human quality bar, not a timeout, not a hold-timer in SV. `awaitingPope` is a flag. Hold duration unspecified — do not invent seconds. No `holdSeconds`. Scribe blanks are observational. |
| Honest map: leftovers named, not invented around | **Yes.** Map + leftover list: `#8`, unhosted Console / HUD / Records, no Console Post, unwired Sound, no favor, no SUMMON, no live INPUT, no Core guild promote, no `MarkPopeLost` caller / degrade paint. Tonight lines refuse `/run` manufacture. |
| No `/run Console:Toggle` / stub `IsRegisteredPope` / `Decree:Set` / `Data/Popes.lua` as the official path | **Yes.** “Do not invent” list forbids those four plus SUMMON and auto-declare. They appear only as anti-patterns. |
| Two-client minimum; offline chaos is not a substitute | **Yes.** Floor: Pope client + congregation client. More installed bodies preferred. Late arriver is a third installed member when Failure 1 is walked. Harness + `tests/test_ceremony_chaos.lua` are preconditions, not this rehearsal. |
| Pre-reformation smoke files disclaimed | **Yes.** `solo-smoke.md` / `two-client-smoke.md` / `guild-night-playtest.md` named as the deleted points ladder. Do not walk them as this night. |
| Writer did not edit addon Lua, TOC, tests, `docs/validation/**`, `v1-checklist.md`, or `OPEN_QUESTIONS.md` | **Yes.** Transcript + mtimes. Lane B owns the checklist pointer. Lane A owns validation sheets. `#8` text in `OPEN_QUESTIONS.md` unchanged. |

## Attack results

| Attack | Result |
|---|---|
| Rehearsal ticked done / dated pass / `[x]`? | **No.** Status **NOT RUN**. 0 `[x]`. Release-gate block unchecked and marked unsatisfiable on this skeleton. |
| Claims V1 / MVP complete or `POLISH:PASS`? | **No.** Explicit bans. Definition of done remains the streamed Gathering. |
| Invents `#8` / `Data/Popes.lua` / stub `IsRegisteredPope` true so rituals can pass? | **No.** Map: predicate always `false`. Forbidden list. Release-gate requires a real list, not a stub. Workspace has no `Data/Popes.lua`. Read-only confirm: `Sender:IsRegisteredPope` returns `false`; STATE / SNAPSHOT Accept fail-closed. |
| Invents SUMMON (ping / gathering-point / second assembly feature)? | **No.** Stretch-MVP leftover. People walk. Venue is human-chosen. “If used, it was one ping” is the Bible stretch line on the **unsatisfiable** release-gate block, not a tonight protocol. |
| Invents favor (UI, whisper opcode, raid-marker vote, `/s` tally as product)? | **No.** Leftover. Congregation cheers in `/s` is world noise, not a split bar. Night 3 and Failure 5 boxes say no favor UI appeared — leftover, do not invent. |
| Invents a hosted Console / HUD / Records so Event boxes can turn green? | **No.** Never shown / never `Init`ed / unhosted. `/beef` is the empty Quiet shell. No Console slash. `/run Toggle` / `StartEvent` forbidden. Read-only confirm: `UI:Init` starts Minimap only; bootstrap does not call `Console:Init` / `Hud:Init` / `RecordsBook:Init`; `Sound:Play` has no callers. |
| Invents Console Post via `/run Decree:Set` so a banner can be ticked? | **No.** Forbidden. Banner only if account SV already holds a line. Local congregation SV is not canonical theater. |
| Treats the shipped skeleton as a live Gathering? | **No.** Honest outcome: humans can stage assembly / kneel / unmodified duels / Pope voice; the addon stays a Quiet shell plus at most a local Decree. Rituals, theater, HUD, favor, bells, and catch-up will not fire. That is leftover, not a pass. Night 0 pass line is **skeleton only**, not the release gate. |
| Five / thirty coded as `holdSeconds` / a SavedVariables timer? | **No.** Quality bar + scribe blanks. Failure 3: do not invent hold seconds. Runtime leftover named: no `MarkPopeLost` caller, no degrade paint. |
| Offline chaos suite substituted for the night? | **No.** Named precondition. Monotonic-sequence Restore leftover is named from that suite, not treated as a walked rehearsal. |
| One-client / Pope-only night? | **No.** Two-client floor. Cast table requires Congregation A for the whole night. |
| Writer edited forbidden files or committed? | **No.** Exclusive Writes. No commit. Player `WTF/` not touched. |
| Paper-prototype console night passed off as this rehearsal? | **No.** Named a different §22.3 gate. Scribe notes of what David wishes the console showed “do not pass this rehearsal.” |
| INPUT / HELLO / STATE map is false, so a leftover was invented as shipped? | **No.** HELLO is live presence (`Net:Init` → `SendHello`). STATE / SNAPSHOT codecs exist and fail-closed. INPUT is codec-only (`_HandleV2` drops non-STATE/SNAPSHOT). Matches the map. |

Refutation of Laws 4, 5, 6, Bible §22.3 (release gate, not definition of done), §20.4 (chaos quality bar), ceremony-runtime Chaos test (no invented hold / opcode / snapshot schema), and “do not invent `#8` / SUMMON / favor / a hosted Console so the night can pass” **fails** for the exclusive files.

## Leftovers (named only — not fixed)

Named in the script. This review does not host them and does not tick them.

1. **`#8` fail-closed rituals** — `IsRegisteredPope` always false. STATE / SNAPSHOT never send or Accept. Console verbs refuse `not the registered pope`.
2. **Unhosted Console / HUD / Records** — modules load; bootstrap and `/beef` never show them. No Console slash.
3. **No Console Post** — Decree banner cannot be produced from the night’s UI.
4. **Unwired Sound** — five cue names exist; nothing calls `Play`.
5. **No favor** — no INPUT channel, no split bar.
6. **No SUMMON** — stretch-MVP. People walk.
7. **No live INPUT** — petition / favor / confession do not travel.
8. **No guild promote** from Core on KNIGHT THIS BEEF. `ChurchRankIdForGuildIndex` is a nil stub.
9. **No live HUD health** — Appendix A #1 / OPEN_QUESTIONS #2. Fallback cards are also unhosted.
10. **No `MarkPopeLost` caller / degrade paint.** Hold duration stays unspecified.
11. **No monotonic-sequence gate** on Restore (offline chaos-suite leftover).
12. **Scoped out:** Confession transport, post-show clipboard, onboarding wall, Decree deputy, Curtain UX.

Lane B owns `docs/phases/v1-checklist.md` (pointer only). Lane A owns `docs/validation/**`. `OPEN_QUESTIONS.md` #2 / #8 unread-as-answered.

## Findings

### Critical

None.

### Important

1. **Companion line undersells this file’s job.** “`v1-checklist.md` is the §22.3 walk. This file is the chaos night only.” Lane B’s checklist is the definition-of-done walk and a pointer. **This file is the §22.3 release-gate script.** The Release-gate section later says so. Sloppy companion, not a pass path. Do not “fix” by merging the streamed Gathering into this night.

2. **Many tonight boxes can go green on a Quiet shell.** Failure 1 “none will answer a snapshot,” Night 3 “no favor / HUD / bell,” and “software did not auto-declare” are true because leftovers are leftovers. A sloppy reader could tick Nights 0–3 + the five failures and feel the rehearsal happened. The Status line and the Release-gate block are the protection: they stay **NOT RUN** until a hosted night is real. Do not “fix” by deleting the observational leftover boxes (that would hide the honest map).

3. **Night 1 “Two of those are leftover” is arithmetic, not product.** Named contributions: Decree, SUMMON, runtime, Console. Tonight leftover is Post, SUMMON, hosted start, and hosted Console — more than two. The table rows are honest. Do not invent a SUMMON or a host to make the count tidy.

### Nit

1. **“Night 0 pass (skeleton only)” uses the word pass.** Immediately followed by **Not the release gate.** Not a dated tick.

2. **Scribe may note what David wishes the console showed.** Correctly labeled as not this rehearsal. Still sits next to the paper-prototype gate. Do not add a paper-prototype success box.

3. **Forbidden `/run` lines name the exact incantations.** They are anti-patterns, not the official path. Necessary to forbid.

4. **Night 0 Quiet box does not mention `ui.shown` restore.** `UI:Init` re-shows the empty `/beef` shell if it was left open. Player-opened Quiet, not a feed. Walk gap only.

5. **Slash line is slightly tight.** Bootstrap parses `/beef` and `/beef minimap` only; any other argument opens the empty shell. Not a Console slash.

6. **Failure headers say “not in QUIET” / “mid-rite” while Tonight Runtime stays QUIET.** Human staging is the interrupt. Tonight paragraphs correct it. Do not `/run StartEvent` to leave QUIET.

## Brief contract

| Requirement | Result |
|---|---|
| Author the guild-only, unstreamed dress-rehearsal script the Bible names | Met |
| Five deliberate failures: late arrival, UI reload, disconnect including the Pope’s, no-show petitioner, interrupted or disputed Gora | Met |
| Five / thirty is a quality bar, not a timeout constant to code | Met |
| Human run-of-show (Pope client + congregation client) | Met (two-client floor) |
| Mark shipped skeleton vs leftover (`#8`, unhosted Console / HUD, unwired Sound, no favor, no SUMMON) | Met (also names no Post, no live INPUT, no `MarkPopeLost` paint) |
| Do not invent a protocol so the script can pass | Met |
| Do not tick the rehearsal as done | Met (**NOT RUN**, 0 `[x]`) |
| Do not edit addon Lua, TOC, tests, `docs/validation/**`, `v1-checklist.md`, or `OPEN_QUESTIONS.md` | Met |
| No commit; do not invent product | Met |

## Sections checked

- Brief `docs/reformation/phase-6/briefs/P6-C-rehearsal.md`
- Writer report `docs/reformation/phase-6/reports/P6-C-rehearsal.md`
- Exclusive file `docs/phases/dress-rehearsal.md` (85 `[ ]`, 0 `[x]`, Status **NOT RUN**)
- Bible §22.3, §20.4, §20.1–20.3, §7, §10, §18
- `.cursor/rules/ceremony-runtime.mdc` (Chaos test; hold duration unspecified)
- Ten Laws 4, 5, 6
- Format example `docs/reformation/phase-6/reports/P6-B-checklist-review.md`
- `docs/design/OPEN_QUESTIONS.md` (#2, #8 unchanged; mtime 07:23)
- Writer transcript ([Rehearsal](39940c31-f2b0-4dc6-bb31-e98a27b42467)) — exclusive Writes only
- Read-only skeleton check: `ChurchOfBeef.lua` slash; `UI/MainFrame.lua` empty shell; `UI/Console.lua` no slash, refuse `#8`; `UI/Hud.lua` never bootstrapped; `UI/Sound.lua` no callers; `Core/Sender.lua` always false; `Net/BeefNet.lua` HELLO live, STATE/SNAPSHOT fail-closed, INPUT not a live channel; `Core/Runtime.lua` `awaitingPope` flag, no `holdSeconds`; `Core/Roster.lua` nil guild-rank map stub; no `Data/Popes.lua`
- Lane B `docs/phases/v1-checklist.md` (pointer; not edited by this writer)
- `docs/validation/**` (Lane A; not edited)
- `tests/test_ceremony_chaos.lua` (precondition leftover: no monotonic-sequence gate)
