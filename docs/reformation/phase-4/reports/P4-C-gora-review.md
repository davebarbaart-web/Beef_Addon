# Phase 4 Lane C — Adversarial Review

**Lane:** Gora Core (sanction + verdict)
**Exclusive files:** `addon/ChurchOfBeef/Core/Gora.lua`, `tests/test_gora.lua`
**Lane report:** `docs/reformation/phase-4/reports/P4-C-gora.md`
**Cited law:** Ten Laws 3, 4, 5, 8; Bible §10.1–10.8; `.cursor/rules/gora-sanction.mdc`; `.cursor/rules/records-not-points.mdc`; brief `docs/reformation/phase-4/briefs/P4-C-gora.md`
**Writer:** [Gora](16506793-dc48-467f-89a6-0a010107bb42)

**Spec:** PASS
**Quality:** Approved

A Beef Gora exists only after `Sanction`. Petition / Recommend / leftover `Challenge` are not a Gora. Combat is WoW’s (no duel API). Software proposes (`Propose` is caller-supplied and does not write Store); the Pope ratifies with one of four verbs that call `Store:RecordGoraResult` for both characters. No invented petition TTL or dismiss cooldown. No auto-sanction, auto-declare, auto-void, auto-elevate, OpenRite, ELO, pairing score, Grant, HUD, favor, INPUT, or Pope list. Isolated suite: **304 passed, 0 failed**. Leftover pair-key suite: **17 passed, 0 failed**. Writer stayed inside exclusive files. `OPEN_QUESTIONS.md` unchanged. No commit. This review did not invent a petition cooldown, Fight HUD, favor bar, INPUT channel, or Pope list, and did not edit `Gora.lua` or the suite.

## Verdict

Refutation of Laws 3, 4, 5, 8, Bible §10.1–10.8, and “a Gora exists only after SANCTION / software proposes Pope ratifies / no invented TTL” **fails** for this lane’s exclusive files.

Law 3 is intact as Core verbs. `Sanction`, `DeclareVictor`, `CowardiceRecorded`, `Void`, and `FreeRuling` are one-click Pope actions. Officers have no ritual API here. There is no `IsPope` gate and no `Data/Popes.lua` — that is `#8` / Director Console, not a miss. The Pope may sanction a pair that never petitioned. Elevation is not this lane.

Law 4 is intact. `Recommend` does not Sanction. `Propose` stores a caller table or string and does not write Store. `DeclareVictor(winnerId)` records the Pope’s named winner, not the proposal (suite proposes B, Pope names A). `EndEvent` without a ruling clears the live pair and writes nothing — no auto-void, no auto-declare. Rulings do not `OpenRite`, `Continue`, `EndEvent`, or `SetRank`. No narration, no announce, no duel-chat parser.

Law 5 is intact on this Core. Store writes happen only when a ruling verb runs. No Net, no peer self-report, no congregation theater, no INPUT inbox. A congregation client that later called these Lua verbs would be a console-binding problem, not a second writer invented here. Do not add a Pope list to “fix” it.

Law 8 is intact. No `StartDuel` / `AcceptDuel` / combat analytics / ELO / MMR / betting. Leftover `Challenge` is still a name-pair note (`challenger`, `target`, `at`). It is not a Gora.

§10.1–10.8 hold for the slice this lane owns: petition pool → optional Recommend → SANCTION BEEF GORA → caller-supplied Propose → Pope ruling → Store record. Mute cards, favor, Fight HUD, and elevation ceremony are correctly absent. Stipulation is an optional remembered line, not a picker. Level gap is not a hard filter (reviewer: 70 vs 1 sanctions). Famous Upsets stay uncomputed. Defenses are not incremented.

Petition freshness is Runtime QUIET / `EndEvent` / event-id change — Bible “~the current event.” `CHALLENGE_TTL = 1800` and `PENDING_MAX = 20` remain Phase 1 salvage on the leftover notes. They are not a petition window.

This review did not invent a petition cooldown, HUD, favor bar, INPUT channel, or Pope list, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| Petition / Dismiss; expire on QUIET / `EndEvent`; no TTL or cooldown number | **Yes.** `Petition` refuses QUIET / name strings / humans / self-named opponent. Dedupes by character id. `Dismiss` is consequence-free; immediate re-petition is accepted. `OpenRite` / `CloseRite` / `Continue` keep the current-event pool. `EndEvent` and a new `StartEvent` empty it. `Gora.PETITION_TTL` / `DISMISS_COOLDOWN` / `REPETITION_COOLDOWN` are nil. No petition timestamp except internal `eventId`. |
| Present-and-alive is a caller flag; no roster sensing | **Yes.** `GetPetitions(presentAndAlive)` copies entries only when `presentAndAlive[id] == true`. Omitting the set, a non-table, or a truthy `1` shows none. Absent petitioners are hidden, not deleted. No `Roster` / `UnitIsDead` / `GetGuildRosterInfo`. `knownCharacter` is Store identity, not presence. |
| Named opponent stored, not announced | **Yes.** `namedOpponentId` is stored on the petition and copied out. `Announce` / `Notify` / `Callout` are nil. Suite + reviewer: `SendChatMessage` / `SendAddonMessage` stay 0 on named Petition. |
| Recommend has no odds / rating / auto-sanction | **Yes.** Returns `levelA` / `levelB` (raw Store levels), optional `headToHead` copy, `namedOpponent` bool. `score` / `odds` / `rating` / `elo` / `mmr` / `fairness` / `classOdds` are nil. Does not call `Sanction`. Level 70 vs 1 is not refused. |
| Sanction is one verb; optional one-line stipulation; no OpenRite; no duel | **Yes.** `Sanction(a, b, stipulation?)`. Same pair (order-insensitive) may update the line. A different pair is refused while live. QUIET refused. Runtime `state` / `sequence` / `riteType` unchanged. `Gora.OpenRite` / `StartDuel` / `AcceptDuel` are nil. No stipulations table or picker. |
| Propose is caller-supplied and does not write Store | **Yes.** Table or string. Nil refused. No sanctioned pair refused. Does not increment wins/losses. `GetProposal` returns a copy. No duel-chat parser (`ParseDuel` / `ParseChat` nil). |
| Four Pope rulings write `RecordGoraResult` for both characters; no auto-elevate | **Yes.** `victor` / `cowardice` / `void` / `free` on both rows. Winner/fleer must be in the live pair. Pair + proposal clear after a successful write. Knight + `elevationAt` unchanged. `Gora.SetRank` / `Elevate` / `AutoElevate` are nil. `famousUpset` stays false. `EndEvent` without a ruling writes nothing. |
| Challenge leftover APIs still work | **Yes.** `Challenge` / `Cancel` / `IsChallenged` / `GetPending` unchanged in role. Isolated leftover suite **17 / 0**. Does not enter the petition pool or set `GetSanctioned`. `EndEvent` does not prune leftover notes. TTL 1800 + `PENDING_MAX` 20 still govern notes only. |
| Isolated suite green | **Yes.** Reviewer rerun, Lua 5.1.5: `lua tests/test_gora.lua` → **304 passed, 0 failed**. Leftover (Common + harness asserts + `test_gora_ceremony.lua`) → **17 / 0**. Full harness (integrator list): **4597 / 0**. |
| Writer did not edit TOC / bootstrap / `run.lua` / Store / Runtime / UI | **Yes.** Transcript Writes: `tests/test_gora.lua` (first), `Core/Gora.lua`, this lane’s report. Store mtime Aug 14; Runtime 06:37; bootstrap Aug 14; `test_gora_ceremony.lua` Aug 14; `OPEN_QUESTIONS.md` Aug 14. TOC / `run.lua` dirty from other lanes; writer did not Write them. `tests/run.lua` already lists `test_gora` — integrator, not a writer miss. No `Data/Popes.lua`. |

## Attack results

| Attack | Result |
|---|---|
| Law 3 — ungated Lua verbs mean officers can sanction / rule? | **No as this lane.** Brief forbids `Data/Popes.lua`. These are Core verbs for the Director Console. `Gora.IsPope` / `RequirePope` are nil. Do not invent a list here. |
| Law 3 — Sanction requires a petition, so the pool rules the Pope? | **No.** Reviewer: Sanction without Petition succeeds. The pool is material, not a gate. |
| Law 3 / §10.4 — a Gora win auto-elevates a Knight to Lord? | **No.** Suite + reviewer: `SetRank` is not called; `rankId` stays 3; `elevationAt` stays nil. Elevation is Lane D. |
| Law 4 — `Propose` writes the record / auto-declares? | **No.** Wins stay 0 until a ruling. `DeclareVictor` uses the Pope’s `winnerId`, not `GetProposal()`. |
| Law 4 — `Recommend` auto-sanctions the next pair / emits a pairing score? | **No.** Pair unchanged. No `score` / odds / rating / ELO. No ranked suggestion list API. `GetPetitions` sorts by character id, not “best match.” |
| Law 4 — `EndEvent` auto-voids or auto-declares the live pair? | **No.** Pair expires. Store wins/results unchanged. Late `DeclareVictor` is refused. |
| Law 4 — rulings advance Runtime (auto-advance the queue)? | **No.** Reviewer: `state` / `sequence` unchanged across Propose + `DeclareVictor`. `OpenRite` stays on Runtime. |
| Law 4 — `CowardiceRecorded` is a second auto-DECLARE VICTOR? | **No.** One Pope verb. Fleer `won = false`, standing `won = true`, both `ruling = "cowardice"`. Design Lead `#9`: opponent Cowardice is a victory for the standing fighter. Not a parser guess. |
| Law 4 — `FreeRuling` invents a typed outcome / double-loss? | **Leftover Store contract, not a new enum.** Store requires `won` on non-void. Writer writes `won = false` for both; Store then increments losses and moves streak. Ruling field is `free`. Text is on the verb, not a new outcome name. Do not edit Store here. See Important. |
| Law 5 — congregation `Petition` / `DeclareVictor` is peer authority? | **No as product this lane.** No Net, no INPUT channel, no inbox, no broadcast. Store writes are the Pope-client Core path. Console binding is later. Do not invent INPUT or a Pope list. |
| Law 5 — leftover `Challenge` is a typed self-report Gora (Audit V4)? | **No.** Still `{ challenger, target, at }`. `RecordResult` / `GrantGora` remain nil. Challenge is not Sanction and does not write Store. |
| Law 8 — Sanction starts a duel / parses combat? | **No.** No duel API, no chat parser, no analytics. Combat remains WoW’s. |
| Law 8 / §10.5 — level gap ~2 is a hard filter / pairing score? | **No.** Recommend shows raw levels. 70 vs 1 sanctions. Pope may waive. |
| “Gora exists only after SANCTION” — Petition / Challenge / Propose create a Gora? | **No.** `GetSanctioned()` is nil until `Sanction`. Propose and all four rulings refuse without a live pair. Challenge does not set the pair. |
| “Software proposes; Pope ratifies” — proposal is required / overrides the Pope? | **No.** Ruling without Propose works. Propose-B + Declare-A records A. |
| “No invented TTL” — `CHALLENGE_TTL = 1800` is a petition cooldown? | **No.** Leftover pair-key prune only. Petitions use `eventId`. Reviewer: Challenge TTL does not touch the pool or `GetSanctioned`. `EndEvent` expires petitions/pair and leaves Challenge notes. |
| “No invented TTL” — immediate re-petition is cooldown `0`? | **No.** Brief: do not invent a number; Dismiss is consequence-free. Bible duration is unspecified. Immediate accept is the unconstrained path. |
| Present-and-alive — omitting the set shows everyone (invented roster)? | **No.** Empty / omitted / non-table → none. Fail-closed. No sensing. |
| Named callout is official when stored? | **No.** Stored only. No announce. Official when the Pope announces — not this file. |
| Stipulation is a rules picker / database? | **No.** Optional trimmed line. Table refused. No `STIPULATIONS` / `PickStipulation`. |
| Famous Upsets computed from the level gap? | **No.** `famousUpset` is false on all four writes. Never passed `true`. |
| Defense increment / sit-the-champ invented? | **No.** Gora does not write `defenses`. Store still nils those fields. `#9` untouched. |
| Writer invented HUD / favor / INPUT / `#8` / `holdSeconds` / `Data/Popes.lua`? | **No.** Those APIs are nil. `addon/ChurchOfBeef/Data/` is only `Ranks.lua`. `#8` text in `OPEN_QUESTIONS.md` is unchanged (mtime Aug 14). |
| Writer edited TOC / bootstrap / `run.lua` / Store / Runtime / UI, or committed? | **No.** Exclusive Writes only. No commit. |

Refutation of Law 3 (Pope verbs; no officer ritual; no auto-Lord), Law 4 (propose ≠ record; no auto-declare / auto-advance / narration), Law 5 (one writer; no peer result; no INPUT), Law 8 (unmodified duel; no ELO), Bible §10.1–10.8 (loop, petition hygiene, Pope ruleset, no ratings, one sanction verb, four adjudication verbs, elevation later), and “exists only after SANCTION / no invented TTL” **fails** for the exclusive files.

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current except the integrator listing (already done).

### Integrator (already landed — writer report is stale)

- `tests/run.lua` lists `test_gora`. Writer did not edit it. Full harness **4597 / 0**.
- `ChurchOfBeef.toc` already lists `Core\Gora.lua` (pre-Phase 4). Writer did not touch TOC / bootstrap.
- Raw `lua tests/test_gora_ceremony.lua` still needs harness `assert_*` plus Common (`Names`). Pre-existing; this lane was forbidden to wrap that file.

### Store (signed; writer did not edit)

- `RecordGoraResult` does not persist free-ruling text. `FreeRuling` returns the line; Store stores `ruling = "free"`.
- Store requires `won` on non-void. Writer writes `won = false` for both on `free`. That increments **losses** and moves narrative streak on both characters. Disclosed as “won = false”; the W/L side effect is the live leftover. Do not “fix” by mapping free → void (wrong enum) or by editing Store in this lane.
- `famousUpset` is a Store flag the Pope may set later. This lane never sets it.

### Leftover Challenge (Phase 1 salvage — do not grow)

- `CHALLENGE_TTL = 1800` and `PENDING_MAX = 20` remain demo numbers on pair-key notes. Not a petition freshness window. Isolated leftover suite still **17 / 0**.
- Challenge error copy still says “a Gora needs two different combatants.” The note is not a Gora. Do not retitle it into the product loop.

### #8 / Director Console / later (do not invent here)

- No Pope-authority gate on these verbs. Console must be the only caller of Sanction / rulings. Do not create `Data/Popes.lua` in review.
- Mute cards, congregation favor, Fight HUD, INPUT channel, holdSeconds, `#8`, Famous Upsets computation, defense increment, elevation ceremony. Brief forbade all of them.

### Not this lane

- `OPEN_QUESTIONS.md` #2 (HUD health), #3 (Records Book veto), #8 (Pope list), #9 (defense derivation) stay unanswered.
- UI has zero `Gora:` callees today. Wiring the console is a later lane.

## Findings

### Critical

None. No one-line Law 3, 4, 5, 8, §10.1–10.8, “exists only after SANCTION,” invented petition TTL, auto-elevate, or Audit V4 typed-result breach in the exclusive files.

### Important

1. **`FreeRuling` + Store `won = false` records two losses.** Reviewer: both characters `losses += 1`, `streak = -1`, `results[].won == false`. The Pope’s verb was free, not “both lost.” Writer could not omit `won` (Store rejects) and could not edit Store. Do not treat this as a Gora.lua bug to patch with a fifth outcome or a silent Void. A later Store/record lane may allow `free` without a `won` flag. The isolated suite locks `won == false` and does not lock `losses`.

2. **These verbs are ungated Core.** Anyone who can call Lua can Sanction and rule. That is fail-open until the Director Console / `#8` bind the Pope client. Correct for this lane. Do not stub `IsPope` or add a workspace Pope file in review.

3. **A sanctioned pair can live in ASSEMBLY / CONSEQUENCE.** Brief: Sanction does not `OpenRite`. Runtime rite type stays a separate Pope verb. HUD / Event Mode theater must key off the sanctioned pair **and** the runtime, not treat `GetSanctioned()` as a rite transition. Do not add `OpenRite` here.

### Nit

1. **Writer leftover map is stale** (`P4-C-gora.md`). `tests/run.lua` already lists `test_gora`. Integrator, not a writer miss.

2. **Newline survives `trimLine`.** Reviewer: `"no pots\nand nude"` is stored. Not a picker. “One-line” is Pope-supplied text, not a second rules engine. Do not add a max-length or newline ban here.

3. **Recommend omits class.** Bible §10.5 “shows class matchup plainly” is card/HUD work. Brief’s optional Recommend is levels / H2H / named-challenge only. Fine.

4. **Suite does not lock Sanction without a petition, rematch after a ruling, or `presentAndAlive[id] = 1`.** Reviewer probes confirm: Sanction without Petition works; same pair may re-sanction after a ruling; truthy `1` hides. Coverage gaps only.

5. **Suite does not lock Challenge surviving `EndEvent` or `PENDING_MAX`.** Reviewer: notes survive QUIET; the 21st Challenge is refused. Leftover behavior, not product.

6. **`GetSanctioned` / `copyPetition` omit `eventId`.** Freshness stays internal. Fine.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated Common + Ranks + Store + Runtime + Gora; standalone wraps “other modules nil” | Met (304 / 0). Transcript: suite first, then `Gora.lua`. |
| Petition pool is character ids; optional named opponent; expire on QUIET / `EndEvent`; no TTL / cooldown number | Met |
| `Dismiss` consequence-free | Met |
| Present-and-alive is a caller flag; no roster sensing | Met |
| Named opponent stored, not announced | Met |
| Recommend: Store context only; no odds / rating / auto-sanction | Met |
| `Sanction` one verb; optional one-line stipulation; no OpenRite; no duel | Met |
| Propose caller-supplied; does not write Store; no duel-chat parser | Met |
| Four Pope rulings write `RecordGoraResult` for both; record the Pope’s ruling; free text is not a new enum | Met (text on the verb; Store leftover on persistence / `won`) |
| No auto-Lord / Grant / ELO / pairing score / HUD / favor / INPUT / `#8` / Famous Upsets computation / defense increment | Met |
| Keep leftover `Challenge` / `GetPending`; do not grow into the product loop | Met (17 / 0) |
| Do not edit TOC / bootstrap / `run.lua` / Store / Runtime / Sender / Codec / Snapshot / BeefNet / UI / DB; no `Data/Popes.lua` | Met (integrator listed `test_gora`) |
| Isolated `test_gora.lua` must pass | Met (304 / 0) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 3, 4, 5, 8
- Brief `docs/reformation/phase-4/briefs/P4-C-gora.md`
- Writer report `docs/reformation/phase-4/reports/P4-C-gora.md`
- Bible §10.1–10.8 (also §10.9 Famous Upsets / records as stories — not rebuilt)
- `.cursor/rules/gora-sanction.mdc`
- `.cursor/rules/records-not-points.mdc`
- `addon/ChurchOfBeef/Core/Gora.lua`
- `tests/test_gora.lua` (isolated run: 304 / 0)
- `tests/test_gora_ceremony.lua` (leftover: 17 / 0; file not edited)
- `addon/ChurchOfBeef/Core/Store.lua` `RecordGoraResult` / `RULINGS` (read only; mtime Aug 14)
- `addon/ChurchOfBeef/Core/Runtime.lua` StartEvent / OpenRite / Continue / EndEvent (read only)
- Writer transcript ([Gora](16506793-dc48-467f-89a6-0a010107bb42)) — exclusive Writes only
- `ChurchOfBeef.toc` / `ChurchOfBeef.lua` / `tests/run.lua` (integrator listing; writer did not edit)
- `addon/ChurchOfBeef/Data/` (no `Popes.lua`)
- `docs/design/OPEN_QUESTIONS.md` (unchanged; #8 / #9 not coded)
- Full harness: 4597 / 0
- Reviewer probes: Sanction without Petition; 70 vs 1; Recommend no score; present flag `== true` only; newline stipulation; table stipulation refused; Propose ignored by DeclareVictor; rematch after ruling; Continue keeps pair + pool; Sanction in CONSEQUENCE; EndEvent no Store write; Challenge TTL isolated from petitions; FreeRuling double-loss side effect; Cowardice standing win; no SetRank; Propose/ruling without pair refused; one live pair; no announce / CreateFrame / SV write; H2H copy isolation; `PENDING_MAX` 20; Famous Upsets false on all four writes
