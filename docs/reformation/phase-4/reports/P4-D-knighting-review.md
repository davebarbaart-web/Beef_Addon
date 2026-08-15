# Phase 4 Lane D — Adversarial Review

**Lane:** Knighting + Lord elevation Core verbs
**Exclusive files:** `addon/ChurchOfBeef/Core/Knighting.lua`, `tests/test_knighting.lua`
**Lane report:** `docs/reformation/phase-4/reports/P4-D-knighting.md`
**Cited law:** Ten Laws 3, 4, 9; Bible §8, §10.4, §5; `.cursor/rules/pope-authority.mdc`; `.cursor/rules/records-not-points.mdc`; brief `docs/reformation/phase-4/briefs/P4-D-knighting.md`
**Writer:** [Knighting](1511d548-db04-4ce3-b6c8-74858cfa4433)

**Spec:** PASS
**Quality:** Approved

Two Pope verbs that write the Church record only. `KnightThisBeef` is `Store:SetRank(humanId, 3)` (Beef Knight). `ElevateToLord` is `Store:SetRank(humanId, 4)` (Beef Lord). Unknown humans and non-id keys are refused. First Lord `elevationAt` comes from Store. A Gora win does not elevate. No Demote, Prophet, Butcher/Council rite, `GuildPromote` / `SetGuildRank`, queue, Runtime verbs, fairness score, or narration. Isolated suite: **134 passed, 0 failed**. Writer stayed inside exclusive files. Integrator already listed `Core/Knighting.lua` and `test_knighting` (writer leftover is stale). `OPEN_QUESTIONS.md` #8 unchanged. No `Data/Popes.lua`. No commit. This review did not invent a Pope list, a queue UI, or a guild-index map, and did not edit `Knighting.lua` or the suite.

## Verdict

Refutation of Laws 3, 4, 9, Bible §8 / §10.4 / §5, and “software proposes; the Pope ratifies / no guild promote from Core” **fails** for this lane’s exclusive files.

Law 3 is intact on the terms the brief set. Knighting and elevation are Pope-shaped store writes, not officer rituals, not a second authority-gate outside `Officer.lua`, and not a registered-Pope lookup. `#8` is not coded. The Director Console one-click is later. These methods are the Church-record half of **KNIGHT THIS BEEF** and the Lord elevation beat.

Law 4 is intact. Nothing auto-declares a victor, auto-advances a queue, auto-announces, or appends ceremony text. `RecordGoraResult` leaves rank at Knight. Elevation is its own verb. Fairness is not computed. The software does not narrate.

Law 9 and §5 are intact. Ids 3 and 4 are Beef Knight and Beef Lord. No Prophet. No threshold (Fresh may be elevated; Cooked may be knighted). Butcher and Council are not this rite. Rank is written on the human. Guild rank is not written. Church store remains truth.

§8’s full verb (guild-rank promotion, proclamation, staging the next candidate) is carved out by the brief and by Core purity: Core never performs protected actions. pope-authority.mdc: guild-rank write is a later Pope-client capability; other elevations write the store only. This lane does the store write and stops.

§10.4 is intact. “Fair” is not a predicate. Elevation is not automatic after a win. There is no Demote API, no decay, no defense counter. `KnightThisBeef` on a sitting Lord writes 3 because that is `SetRank(humanId, 3)` — disclosed, specified, not a hidden demote-from-loss. Do not invent a refusal gate.

## Confirmations

| Check | Result |
|---|---|
| `KnightThisBeef` → `SetRank` 3 (Beef Knight); refuses unknown humans; does not write Lord | **Yes.** `KNIGHT_ID = 3`. Suite: new human `rankId` 3, title Beef Knight, store holds 3. Unknown `99` / `0` / `nil` / `"Steve"` / `Names.Key` → `nil, err`; known human unchanged. Two knightings stay 3. Cooked Beef is knighted, not made Lord. Reviewer: float / bool / table refused; `error()` not used. |
| `ElevateToLord` → `SetRank` 4; does not compute fairness; first `elevationAt` from Store; not auto after Gora | **Yes.** `LORD_ID = 4`. First `elevationAt` is the injected `now` (2500 / 2706). Second Lord write keeps the first timestamp. `IsFair` / `JudgeFair` / `ComputeFairness` / `Pair` / `Match` / `CountDefense` / `RecordDefense` are `nil`. After `RecordGoraResult` (victor / won), rank stays 3 and `elevationAt` stays `nil` until `ElevateToLord`. Clock omit uses `COB.Clock.Wall` (55555). Reviewer: Fresh / Cooked elevate without a score. |
| No Demote, Prophet, Butcher/Council rite, `GuildPromote` / `SetGuildRank`, queue auto-advance, Runtime verbs | **Yes.** `Demote` / `DemoteHuman` / `SetRank` / `Prophet` / `ElevateToProphet` / `ElevateToButcher` / `SetButcher` / `ElevateToCouncil` / `SetCouncil` / `Grant` / `AddPoints` / `AdvanceQueue` / `NextCandidate` / `OpenRite` / `EndEvent` / `CloseRite` / `OpenConsole` / `Proclaim` / `Narrate` / `RegisterPope` / `GuildRankFor` are `nil`. Stubs: `GuildPromote` / `SetGuildRank` / `GuildSetLeader` / `CreateFrame` stay 0. Runtime stub `OpenRite` / `EndEvent` / `CloseRite` / `Continue` stay 0. Reviewer: public surface is only the two verbs; elevate also leaves Runtime at 0. |
| Isolated suite green | **Yes.** Reviewer rerun: `lua tests/test_knighting.lua` → **134 passed, 0 failed** (Lua 5.1.5). Loads Common + Ranks + Store + Knighting. Isolation asserts wrapped in `if standalone then`. Writer count matches. |
| Writer did not edit TOC / bootstrap / `run.lua` / Store / Gora / UI | **Yes.** Transcript Writes: `tests/test_knighting.lua` (first; RED on missing module), `Core/Knighting.lua`, this lane’s report. Those other paths were Read only. Mtimes: Store / bootstrap / UI / `OPEN_QUESTIONS.md` Aug 14; Knighting 07:13:57; suite 07:13:50; report 07:14:13. TOC 07:15:13 and `run.lua` 07:15:14 list `Core\Knighting.lua` / `test_knighting` — integrator, after the writer. `Gora.lua` 07:16 is Lane C (writer Read only; no `ElevateToLord` call). No commit (`Knighting.lua` still untracked). |

## Attack results

| Attack | Result |
|---|---|
| Law 3 — ungated Core verbs mean officers / any client can knight? | **No as this lane.** Brief and GATE1 `#8`: do not look up a Pope character; do not create `Data/Popes.lua`. Layers: no second authority-gate outside `Officer.lua`. `IsPope` / `RequirePope` / `RegisterPope` are `nil`. Congregation Net / slash / Console are not this file. Later wiring must not call these from a congregation client. This review does not invent that gate. |
| Law 3 — missing Director Console one-click is a miss? | **No.** Brief: do not invent the Console. These are the store writes the Console will call. Zero-setup Tuesday Knighting is later Runtime + Console, not a fourth verb here. |
| Law 3 / layers — `Officer.lua` already exists, so Knighting should refuse non-officers? | **No.** `rankIndex ≤ 1` is not a ritual gate (pope-authority). Officer+ is not the Church. Adding a roster-rank check would invent product and a second gate. |
| Law 4 — `ElevateToLord` writes immediately, so software declared the outcome? | **No.** The verb *is* the Pope ratification write. Software proposing would be a fairness score, a pairing, or auto-Lord after `RecordGoraResult`. None of those exist. |
| Law 4 — Gora win auto-elevates via Store hook / Knighting side effect? | **No.** Suite + reviewer: victor / won leaves `rankId` 3 and `elevationAt` nil. Lane C brief also says elevation is not that lane. `Gora.lua` does not call these verbs. |
| Law 4 — two knightings stage / auto-advance a queue? | **No.** No `queue` / `next` / `AdvanceQueue` / `NextCandidate`. Second knighting does not OpenRite / EndEvent. Runtime stub stays 0. |
| Law 4 — Church record write is generated narration / Chronicle scripture? | **No.** `GetCeremonyLog()` stays `{}`. No `Proclaim` / `Narrate` / `AppendCeremony` on Knighting. `SetRank` does not append `human.history` (still `created` / `linked` only). No honorific invented. |
| Law 4 / §10.4 — `KnightThisBeef` on a sitting Lord is auto-demote? | **No.** It is the specified verb writing 3. Not loss-triggered, not a `Demote` API, not decay. Writer disclosed it. Store already keeps `elevationAt` when leaving Lord (signed P2; Law 7 / `#9`). Reviewer: Lord → Knight leaves `elevationAt`; ceremony log still empty; promote stubs 0. Do not invent a refusal. |
| Law 9 — hardcoded 3 / 4 drift from `Ranks.lua` or invent Prophet? | **No.** `Ranks.ById[3/4]` are Beef Knight / Beef Lord. Id 7 is nil. Verbs never write 5, 6, or 7. `knownRank` in Store would refuse 7 if they tried. |
| Law 9 — `ElevateToLord` on Fresh / Cooked is a hidden threshold miss / ladder step? | **No.** Law 9 bans thresholds. §5 ranks are relationships, not a linear ladder. §10.4 “Knight who wins a fair Gora” is the Pope’s norm, not a software gate. Brief: this lane does not compute fairness. Reviewer: Fresh and Cooked elevate. |
| Law 9 / records-not-points — Grant / standing / points rebuilt as elevation? | **No.** `Grant` / `AddPoints` / `standing` / `threshold` / `elo` / `leaderboard` / `prophet` are absent. No service score. |
| §8 — Core must `GuildPromote` because KNIGHT THIS BEEF “performs everything the API legally permits”? | **No.** Brief: Core never calls `GuildPromote` / `SetGuildRank`. pope-authority: guild-rank write is a Pope-client capability later; do not invent extra guild-rank write verbs for other elevations. Core purity / taint: no protected actions in `Core/`. Reviewer: promote stubs stay 0, including `GuildSetLeader`. Do not add promote here. |
| §8 — missing proclamation / raid marker / next-candidate is a spec fail? | **No.** Brief: queue, targeting, raid markers, proclamation are later Console. Law 4 forbids auto-announce and generated text. Staging the next candidate is “only because the Pope clicked” (pope-authority) — and there is no queue here to advance. |
| §8 — `SetRank` without `AppendCeremony` drops the “record entry”? | **No.** The Church record *is* `rankId` on the human. Brief: do not append ceremony text. Do not invent a `knighted` history kind. |
| §5 — guild rank treated as truth / roster index maps to Church rank? | **No.** No `GuildRankFor` / `ChurchRankIdForGuildIndex` on Knighting. `Ranks.ChurchRankIdForGuildIndex` already returns nil (signed). Verbs take store `humanId`, not a roster index. This review does not invent a guild-index map. |
| §5 — Butcher / Council overwritten by elevation is a new dual-rank model? | **No as this lane.** Store has one `rankId` (signed). Reviewer: Elevate on id 5 or 6 writes 4; `council` boolean is not cleared. Pre-existing single-rank model. Do not invent alongside-Lord flags here. |
| §10.4 — first `elevationAt` computed in Knighting / overwritten on re-elevate? | **No.** Knighting passes `now` through. Store sets `elevationAt` only when `rankId == 4` and it is nil. Suite: 2500 kept at 2501. Knighting does not write `elevationAt` on Knight. |
| §10.4 — mandatory defense / sit-the-champ / beating a Lord required? | **No.** No defense APIs. Elevate does not read Gora records. |
| “No guild promote from Core” — comment-only, still calls the API? | **No.** No call sites. Suite + reviewer stubs increment on `GuildPromote` / `SetGuildRank` / `GuildSetLeader`: **0**. |
| Writer invented a Pope list, queue UI, guild-index map, edited forbidden files, or committed? | **No.** Exclusive Writes only. No `Data/Popes.lua`. `OPEN_QUESTIONS.md` #8 text unchanged (mtime Aug 14). No commit. |

Refutation of Law 3 (Pope ceremonial sovereignty; no officer ritual; no `#8` list), Law 4 (no auto-declare / auto-queue / narration; elevation is its own beat), Law 9 (six ranks, no Prophet, no thresholds), Bible §8 (Church-record half of KNIGHT THIS BEEF; promote / proclamation / queue later), §10.4 (Pope judges fair; no auto-Lord; no Demote API), §5 (store is truth; rank on the human), and “no guild promote from Core” **fails** for the exclusive files.

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current except the integrator listing (already done).

### Integrator (already landed — writer report is stale)

- `ChurchOfBeef.toc` lists `Core\Knighting.lua` after `Recognition.lua`, after `Store.lua`. Interface stays `20506`.
- `tests/run.lua` lists `test_knighting`. Writer did not edit either file.
- Bootstrap still does not call the verbs (`ChurchOfBeef.lua` has no `Knighting` token). Correct until Console exists.

### #8 / Console (do not invent here)

- Registered-Pope list stays uncoded (`OPEN_QUESTIONS.md` #8; GATE1 §4). These verbs write the store; they do not look up a Pope character. Do not create `Data/Popes.lua` in review.
- Director Console one-click, targeting, raid markers, proclamation to installed clients, queue (advance only because the Pope clicked).
- Guild-rank promotion **where the API permits** — Pope client, later UI, not Core.
- Congregation / Net / slash must not call these verbs. Do not add `IsRegisteredPope` here.

### Store (signed; writer did not edit)

- `SetRank` to 3 on a Lord leaves `elevationAt` (suite `test_store.lua`; Law 7 / `#9` first elevation). Knighting inherits that. Do not clear the timestamp.
- One `rankId` per human. Butcher / Council “alongside” Lord is not this rite and not a new schema.
- Human ids and character ids are separate sequences and may both be `1`. Callers must pass `humanId`. Do not invent a character-id overload or a guild-index map.

### Gora / Runtime (other lanes)

- Lane C: elevation is not that lane; no auto-Lord. `Gora.lua` does not call `ElevateToLord`.
- Runtime rite type `Knighting` is ceremony state, not this module. These verbs do not `OpenRite` / `EndEvent`.

### Out of scope (do not invent here)

- Pope list, queue UI, guild-index map, dual-rank Butcher+Lord, `knighted` history kind, Demote, Prophet, Butcher/Council rite.

## Findings

### Critical

None. No one-line Law 3, Law 4, Law 9, §8 / §10.4 / §5, or “Core guild promote” breach in the exclusive files. No Pope list, queue UI, or guild-index map.

### Important

1. **These verbs are ungated and that is the product until Console / `#8`.** Anyone who can call `COB.Knighting` can write Knight or Lord. Writer did not add `IsPope`. Correct: brief forbids a Pope list; layers forbid a second gate outside Officer. Later UI/Net must not treat a congregation client as a writer. Do not stub a Pope name table to “fix” Law 3 here.

2. **`KnightThisBeef` on a sitting Lord writes 3.** Specified `SetRank(humanId, 3)`, not a `Demote` API, not loss-triggered. Writer disclosed it. `elevationAt` survives (Store). Do not invent a refusal (“already Lord”) — that would be a threshold / extra product answer. Console should not offer KNIGHT THIS BEEF as a demote control; that is later UX, not this file.

3. **`ElevateToLord` does not require a current Knight rank or a recorded Gora win.** Brief and Law 9. §10.4 fairness stays the Pope’s. Reviewer: Fresh / Cooked / Butcher-id / Council-id all write 4. Do not add a “must be Knight” gate here.

4. **Integrator leftover in the writer report is stale.** TOC and `run.lua` already list the new files. Not a writer miss.

### Nit

1. **Suite does not lock Lord → Knight overwrite.** Writer report states it. Reviewer probe confirms rank 3, `elevationAt` kept, log empty, promote 0.

2. **Suite does not lock store-missing / incomplete Store.** Reviewer: `COB.Store = nil` and Store without `SetRank` return `nil, "store is not available"`. Honest TOC loads Store first.

3. **Ids 3 and 4 are locals, not `Ranks.ById` lookups.** Brief specified `SetRank(..., 3)` and `SetRank(..., 4)`. Titles are asserted in the suite against `Ranks`. Fine.

4. **Optional `now` is not in the brief.** It is Store’s existing injectable clock for first-Lord `elevationAt`. Not invented product.

5. **Isolation asserts are skipped in the harness** (`if standalone then`). Correct wrap. Isolated run still locks Runtime / Gora / Officer / UI / Net / DB / Sender / Archive / Recognition / Popes / Roster at `nil`.

6. **Numeric `humanId` 1 can coincide with character id 1.** Knighting writes the human. Suite already refuses names and `Names.Key`. Console must pass store human ids. Do not add a character-id path here.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated Common + Ranks + Store + Knighting; isolation asserts in `if standalone then` | Met (134 / 0). Transcript: suite first (RED on missing `Knighting.lua`), then the module. |
| `KnightThisBeef(humanId)` → `Store:SetRank(humanId, 3)`; refuse unknown humans | Met |
| Do not knight to Lord; do not auto-advance a queue; do not OpenRite / EndEvent | Met |
| `ElevateToLord(humanId)` → `Store:SetRank(humanId, 4)`; no fairness / pairing / defenses | Met |
| First Lord `elevationAt` from Store; not automatic after a Gora win | Met |
| Do not invent Prophet; do not demote; Butcher / Council are not this rite | Met (no Demote API; overwrite-to-3 is the knighting verb) |
| Do not call `GuildPromote` / `SetGuildRank`; Core never performs protected actions | Met |
| Do not invent Director Console, proclamation text, narration, `#8`, INPUT channel, guild-index map | Met |
| Do not create `Data/Popes.lua` | Met |
| Do not edit TOC / bootstrap / `run.lua` / Store / Runtime / Gora / Officer / UI / Net / DB | Met (integrator listed after) |
| Isolated `test_knighting.lua` must pass | Met (134 / 0) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 3, 4, 9
- Brief `docs/reformation/phase-4/briefs/P4-D-knighting.md`
- Writer report `docs/reformation/phase-4/reports/P4-D-knighting.md`
- Bible §8, §10.4, §5 (also §4.2 / §4.4 / §6 / §13.1 as cited by those laws)
- `.cursor/rules/pope-authority.mdc` (KNIGHT THIS BEEF; display vs truth; no extra guild-rank write verbs)
- `.cursor/rules/records-not-points.mdc` (ranks; no Grant / Prophet / thresholds)
- `addon/ChurchOfBeef/Core/Knighting.lua`
- `tests/test_knighting.lua` (isolated run: 134 / 0)
- `addon/ChurchOfBeef/Core/Store.lua` `SetRank` / `elevationAt` / `GetHuman` (read only; mtime Aug 14)
- `addon/ChurchOfBeef/Data/Ranks.lua` (ids 1–6; no Prophet)
- Writer transcript ([Knighting](1511d548-db04-4ce3-b6c8-74858cfa4433)) — exclusive Writes only
- `ChurchOfBeef.toc` / `tests/run.lua` (integrator listing; writer did not edit)
- `ChurchOfBeef.lua` / `UI/MainFrame.lua` / `Core/Gora.lua` / `Core/Officer.lua` / `Core/Runtime.lua` (no verb calls from writer)
- `addon/ChurchOfBeef/Data/` (no `Popes.lua`)
- `docs/design/OPEN_QUESTIONS.md` (unchanged; #8 do not code; #9 elevation timestamp is Store’s)
- Reviewer probes (throwaway; suite not edited): Lord → Knight keeps `elevationAt`; Fresh/Cooked/Butcher-id/Council-id elevate; council flag not cleared; Gora win does not elevate; store-missing fail-closed; promote / CreateFrame / Runtime stubs 0; only two public verbs; no `Data/Popes.lua`
