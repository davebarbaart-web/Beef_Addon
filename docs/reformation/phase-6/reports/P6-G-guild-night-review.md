# Phase 6 Lane G — Adversarial Review

**Lane:** Guild-night playtest rewrite (Gathering prep, not Score Desk)
**Exclusive files:** `docs/phases/guild-night-playtest.md`, `docs/reformation/phase-6/reports/P6-G-guild-night.md`
**Lane report:** `docs/reformation/phase-6/reports/P6-G-guild-night.md`
**Cited law:** Bible §7, §14.1, §18, §20, §22.3; Ten Laws 1, 4, 5, 6, 8; signed companions `docs/phases/dress-rehearsal.md`, `docs/phases/v1-checklist.md`
**Writer:** [Guild night](b45efbda-4b39-4d59-a013-5c7f199de8ea)
**Brief:** none on disk (`docs/reformation/phase-6/briefs/` has A–C only). Contract taken from the writer report + ledger row + this review’s job.

**Spec:** PASS
**Quality:** Approved

The exclusive file is a small Gathering prep, not a roster-backed Score Desk night. Status line is **NOT RUN**. Every box is `[ ]` (43). No `[x]` row. No dated pass. No V1 / MVP complete claim. No `POLISH:PASS`. The five dress-rehearsal failures are pointers only. Favor, SUMMON, fake Store Gora rows, a Pope toon name, and A01–A04 Results are refused, not supplied. Writer did not edit addon Lua, `dress-rehearsal.md`, `v1-checklist.md`, `OPEN_QUESTIONS.md`, `REFORMATION_LOG.md`, or `docs/validation/A01`–`A04`. This review did not tick boxes, did not edit the playtest or companions, and does not claim V1 / MVP.

## Verdict

Refutation of the writer contract **fails** for this lane’s exclusive files.

The attack that would FAIL this lane is: keep Score Desk / standing Δ / Cooked-50 as the night; copy the five chaos failures into this script; tick the night done; invent favor / SUMMON / fake Gora rows / a Pope name so HUD and Records can fill; walk A01–A04; claim the small night is §22.3. The file does the opposite. It points at `v1-checklist.md` for the streamed Gathering and at `dress-rehearsal.md` for late arrival / reload / Pope disconnect / no-show / disputed Gora. It does not author those nights.

Law 1 holds as run-of-show: standing Δ, threshold, Score Desk, instance drip, Cooked eligibility, and suggestion fanout survive only as cut text. Law 4 holds: software must not auto-announce, auto-advance, auto-declare, or narrate; the Pope’s voice is the ruling. Law 5 holds: two-client floor; congregation does not run the Console; peer-invented theater is a must-no. Law 6 holds: unbidden chrome is minimap + Decree; `/beef` is player-opened Records; `/beef console` is player-opened, not unbidden. Law 8 holds: unmodified duel; no ELO; no invented favor UI.

Writer report **Status: DONE** is lane authoring. The playtest stays **NOT RUN**.

## Confirmations

| Check | Result |
|---|---|
| Exclusive writes only (`guild-night-playtest.md` + this lane’s report) | **Yes.** Playtest mtime 08:55:15. Writer report 08:55:26. `dress-rehearsal.md` 08:07:37 (Lane C). `v1-checklist.md` 08:07:08 (Lane B). `OPEN_QUESTIONS.md` 08:52:43 (before this writer). A01–A04 08:07 (Lane A). Bootstrap 08:52:52 (integrator). `Data/Popes.lua` 08:56:09 and `UI/Console.lua` 08:56:26 are parallel P6-H / P6-I, after this write. `REFORMATION_LOG.md` 08:58:51 is orchestrator, after this write. |
| Status is **NOT RUN**; no `[x]`; no dated pass | **Yes.** Line 3 and closer line 289. Reviewer: **43** `- [ ]` rows; **0** `- [x]` rows. The only `[x]` string is the tick-instruction sentence. |
| No V1 / MVP complete; no `POLISH:PASS` | **Yes.** Both appear only as **Not** / **Do not claim**. §22.3 stays on `v1-checklist.md`. Writer report **Status: DONE** is lane status. |
| Score Desk / standing / Grant / Prophet / threshold gone as this night’s script | **Yes.** `HEAD` playtest was Night Lead + Score Desk + standing Δ ~Cooked-50 / Knight-200 + suggestion fanout + `Data/Ranks.lua` retune. Those rows are gone. Current tokens are cut / “do not walk” only. `Grant`, `Prophet`, `XP`, `leaderboard` are absent. |
| Five dress-rehearsal failures pointed at, not copied as this night’s walk | **Yes.** Companions table, “What this is not,” Do-not-invent #7, Cannot-walk row, After-the-night closer. No Late arrival / Pope disconnect / no-show / disputed-Gora walk sections. Close `/reload` is persist after End Event, not mid-rite chaos. |
| Companions, addon Lua, `OPEN_QUESTIONS.md`, A01–A04 Results not edited by this writer | **Yes.** Mtimes above. A01–A04 headers still `Result: NOT RUN`, owner David. Playtest says this night does not close them. |
| No invented favor / SUMMON / Pope toon name / fake Store Gora rows | **Yes.** Favor leftover; cheers in `/s` are world noise; Capture must be **no** favor UI. SUMMON leftover; people walk; Capture must be **no**. Facilitator is “David, on the Pope character” (same as the signed rehearsal). “Do not treat a character named Pope as listed.” Fake Store rows forbidden; `InspectProgress` is not this night. |
| A01–A04 left **NOT RUN** | **Yes.** Honesty table + Cannot-walk + Capture. Validation sheets untouched. |

## Attack results

| Attack | Result |
|---|---|
| Night ticked done / dated pass / `[x]`? | **No.** Status **NOT RUN**. 0 `[x]`. |
| Still a Score Desk / standing / Grant / Prophet / threshold night? | **No.** Cut list + Capture ban. `HEAD` Score Desk table is gone. |
| Copies the five dress-rehearsal failures as this night’s script? | **No.** Named and pointed. Not walked. |
| Claims V1 / MVP complete or `POLISH:PASS`? | **No.** Explicit bans. Streamed Gathering remains the definition of done. |
| Invents favor (UI, whisper opcode, raid-marker vote, `/s` tally as product)? | **No.** Leftover. Capture: Favor UI must be **no**. |
| Invents SUMMON (ping / gathering-point / second assembly feature)? | **No.** Stretch-MVP leftover. Venue is human-chosen. People walk. |
| Invents a Pope character name or stubs `IsRegisteredPope` true? | **No.** Empty `Data/Popes.lua` `LIST` is not filled. Predicate stub forbidden. Listing is a precondition or **stop**. |
| Invents fake Store Gora rows / `InspectProgress` as the Gathering? | **No.** Forbidden. HUD needs a live sanctioned pair. Empty Records pages are honest. |
| Invents `/run Decree:Set` so the parchment can be ticked? | **No.** Forbidden. Post “if the desk has it”; if leftover, leave the box unchecked. |
| Walks or fills A01–A04 Results? | **No.** Named **NOT RUN**, owner David. Sheets untouched. |
| Writer edited companions, addon Lua, `OPEN_QUESTIONS.md`, the log, or validation Results? | **No.** Mtimes. Parallel lanes touched Popes / Console / smokes after this write. |
| Green harness substituted for a Gathering? | **No.** Preconditions: harness is not a Gathering pass. Do not tick Status from a green harness. |
| One-client / Pope-only night? | **No.** Floor: Pope writer + one congregation client. |

Refutation of Laws 1, 4, 5, 6, 8, Bible §7 (small Gathering / Tuesday floor), §14.1 (Decree bounds), §18 (Console as Pope tool, not congregation chrome), §20 (named runtime; Pope owns transitions), §22.3 (pointed at, not ticked here), and “do not invent favor / SUMMON / fake Gora rows / a Pope name so the night can pass” **fails** for the exclusive files.

## Leftovers (named only — not fixed)

Named in the script or true of this checkout. This review does not host them and does not tick them.

1. **`Data/Popes.lua` `LIST` is empty.** Rituals refuse until David lists a real character or sets `ui.popeOverrides`. This lane did not create or fill the file.
2. **No `Net:SendState` / `SendSnapshot` caller.** Definitions exist. Nothing sends. Congregation theater is not a local Console on the Pope client. Writer report says so; the walk does not invent a wire.
3. **Favor.** Uncoded. §22.3 requires it on the streamed Gathering.
4. **SUMMON THE FAITHFUL.** Uncoded. Stretch-MVP. People walk.
5. **Live HUD health.** A01 **NOT RUN**. No-health fallback is legal (§10.7). Not an A01 pass.
6. **A02–A04 Results.** Owner David. **NOT RUN.**
7. **`#8` designated-Council UX.** Still open. Listing is not Council designation.
8. **Live INPUT / petition channel.** Humans speak. Do not invent an opcode.
9. **Signed companions are Gate 5 stale.** `dress-rehearsal.md` still says this file is the deleted points ladder and `/beef` is an empty shell. `v1-checklist.md` still says this file uses Grant language and `/beef` is an empty shell. Writer was forbidden to edit them. Do not “fix” by walking this night as a Quiet shell.
10. **Writer-report leftover P6-I is stale at review time.** `UI/Console.lua` 08:56:26 already has `PostDecree`, `playCue`, and `refreshHud`. The playtest hedged Post (“if the desk has it”). Do not invent a `/run Set` because the report still says Post is leftover.

## Findings

### Critical

None.

### Important

1. **Capture overclaims congregation Fight HUD.** Capture: “Fight HUD shown? Congregation + Pope.” HUD reads local `Gora:GetSanctioned()`. `Net:SendState` has no caller. Congregation will not get a pair. The walk box’s leftover escape is “no pair / not listed / Runtime still QUIET” — it does not name “no STATE caller.” A sloppy night will seed the congregation store so the card can show. The Do-not-invent list already forbids that. Do not “fix” by adding a fake pair recipe.

2. **Signed companions now lie about this file.** Authority #3 still tells a human that `guild-night-playtest.md` is the ladder and that hosted Console is an invented pass path. This file tells them to open `/beef console` and the Records Book. Bible + checkout win. The companions are stale. Out of lane. Do not merge the five failures into this night to “reconcile.”

3. **“Do not knight a volunteer so a box can turn green” can be read as forbidding the Tuesday floor.** Bible §7 / §4.11: a Knighting of one nervous newcomer in front of six members is a complete ceremony. The same section correctly says earned means attended, approached, knelt — not a standing number. A newcomer who shows up and kneels is the floor, not a cheat. Do not “fix” by requiring a pre-night points gate.

4. **Listing bullet forbids `/run` Core verbs on the same line that names `popeOverrides`.** The licensed override is a `/run` into `ChurchOfBeefDB.ui.popeOverrides` (Sender comment; `#8`). Stubbing `IsRegisteredPope` true is the banned move. A facilitator can treat the licensed list path as a fake. Stop if unlisted is the honest out. Do not “fix” by pasting an override incantation into this night.

5. **Solo-smoke precondition can launder an `InspectProgress` Decree.** P6-E’s smoke walks owner inspection, which `Set`s a Goldshire line. This night forbids `InspectProgress` and `/run Decree:Set`, then ticks login parchment if a Decree is “already posted.” A Goldshire leftover is not a Gathering Decree. Prior smokes are load / presence only. Do not tick parchment from a smoke plant.

### Nit

1. **`[x]` appears in the tick-instruction sentence.** Not a ticked box. Same pattern as the signed companions.

2. **Knighting / Gora “Skipped” and “Or performed” are two boxes.** Both stay `[ ]` in this pass. A sloppy human can tick both. Observational, not a pass path.

3. **Writer leftover “P6-E / P6-F may still be the ladder” is stale at review time.** Both smokes were rewritten in the same wave (solo-smoke file 08:59; two-client 08:56). The playtest already says “not the deleted ladder.” Do not walk Score Desk there.

4. **Quiet walk does not name the §13.4 version-mismatch drop** as the only allowed Quiet notice. `v1-checklist.md` does. Walk gap only.

5. **Quiet walk does not mention `ui.shown` restore.** `UI:Init` re-shows the Records Book if it was left open. Player-opened Quiet, not a feed.

6. **No P6-G brief file.** Review used the writer report + ledger + Bible. Not a pass path.

## Writer-claim contract

| Claim | Result |
|---|---|
| Replaced Score Desk / standing night with small Gathering prep | Met |
| Points at `v1-checklist.md` (§22.3) and `dress-rehearsal.md` (five failures) without duplicating them | Met |
| All boxes `[ ]`; Status **NOT RUN** | Met (43 `[ ]`) |
| No addon Lua / companion / `OPEN_QUESTIONS.md` edits | Met |
| No fake Gora rows | Met (forbidden; none written) |
| A01–A04 left **NOT RUN** | Met |
| No invented favor / SUMMON / Pope name / V1-MVP claim | Met |

## Sections checked

- Writer report `docs/reformation/phase-6/reports/P6-G-guild-night.md`
- Exclusive file `docs/phases/guild-night-playtest.md` (43 `[ ]`, 0 `[x]`, Status **NOT RUN**; `git show HEAD:` Score Desk / standing Δ / Cooked-50)
- Signed companions `docs/phases/dress-rehearsal.md` (08:07:37; five failures; still calls this file the ladder), `docs/phases/v1-checklist.md` (08:07:08; §22.3 walk; still calls this file Grant language)
- Bible §7, §4.11, §14.1, §18, §20, §22.3
- Ten Laws 1, 4, 5, 6, 8 (`docs/reformation/phase-0/TEN_LAWS.md`)
- `docs/design/OPEN_QUESTIONS.md` (#8 listing licensed; #11 `/beef console`; mtime 08:52:43; designated-Council still open)
- `docs/validation/A01`–`A04` (Result **NOT RUN**; mtimes 08:07)
- Read-only checkout: `ChurchOfBeef.lua` slash (`/beef`, `minimap`, `console`); `UI/MainFrame.lua` `/beef` → Records Book, `Hud:Init`; `UI/Console.lua` lazy `Show`, rituals refuse unless listed, `PostDecree` / `playCue` / `refreshHud` present at 08:56:26; `Data/Popes.lua` empty `LIST`; `Core/Sender.lua` list + `popeOverrides`; `Net/BeefNet.lua` `SendState` / `SendSnapshot` defined, **no callers**; `UI/Hud.lua` show = Runtime ≠ QUIET **and** `Gora:GetSanctioned()`
- Parallel leftovers (not this lane): `docs/phases/solo-smoke.md`, `two-client-smoke.md`; P6-H / P6-I / P6-J reports
- Ledger `docs/REFORMATION_LOG.md` (P6-G row; not edited by this writer)
- Format example `docs/reformation/phase-6/reports/P6-C-rehearsal-review.md`
