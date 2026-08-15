# Phase 2 Lane A — Adversarial Review

**Lane:** Pope store schema
**Exclusive files:** `addon/ChurchOfBeef/Core/Store.lua`, `tests/test_store.lua`
**Lane report:** `docs/reformation/phase-2/reports/P2-A-schema.md`
**Cited law:** Ten Laws 1, 2, 5, 7, 9; Bible §12, §13.1, §10.9, §15, §16; GATE1 Design Lead §4 (elevation timestamps; #8 do not code); brief `docs/reformation/phase-2/briefs/P2-A-schema.md`; `.cursor/rules/identity-records.mdc`
**Writer:** [Pope store](465ecfeb-fb5c-4acf-8bcf-7d9a6965fec2)

**Spec:** PASS
**Quality:** Approved

In-memory Pope store only. Durable ids are store-local integers, never `Names.Key`. Rank lives on the human (nil until `SetRank`); unlinked characters have no rank and are not defaulted to Fresh Beef. First `SetRank(..., 4)` stamps `elevationAt`; `RecordGoraResult` does not elevate and does not store a defense counter. Tombstone only; no `SweepDeparted`. No Grant / standing / points / Prophet on the live write path. No Archive codec, Recognition rite, SV writes, or registered-Pope list. Isolated suite: **277 passed, 0 failed**. Writer stayed inside exclusive files. `OPEN_QUESTIONS.md` unchanged. No commit.

## Verdict

Refutation of Laws 1, 2, 5, 7, 9 and Bible §12 / §13.1 / §10.9 **fails** for this lane’s exclusive files.

The live APIs record Church events onto Bible-named rows: rank / Council / honorifics / membership history on the human; name / class / level / professions / Gora record on the character. Tallies are sanctioned W/L stories, not a points wallet. The module is the Pope writer surface (§13.1); congregation UI/Net are not called. History is inactivated, not deleted. Ranks are `Ranks.ById` 1–6; id 7 is refused on `SetRank`.

`Snapshot` / `Restore` are the in-memory shape Lane B’s brief already said to call. They are not an Archive codec and they do not validate a foreign payload — that integrity bar is Lane B (fail closed). This review did not invent Archive, Recognition, or a Director Console, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| Durable ids are store-local integers, never `Names.Key` | **Yes.** `CreateHuman` / `CreateCharacter` assign monotonic integers. `GetHuman` / `GetCharacter` / `LinkCharacter` / `RecordGoraResult` refuse non-integers. Suite: `GetHuman(Names.Key("Steve"))` and name strings are `nil`. Name reuse creates a new character id. Reviewer probe: sneaked `Names.Key` lookups stay `nil`. |
| Rank on human only; unlinked character has no rank / not defaulted to Fresh Beef | **Yes.** `CreateHuman` always `rankId = nil`. `CreateCharacter` never writes `rankId` or `humanId`. `RankForCharacter` is nil until a link **and** a human `SetRank`. Character row stays `rankId = nil` after link and after `SetRank`. Reviewer probe: `CreateHuman({ rankId = 1 })` and `CreateCharacter({ rankId = 1, humanId = ... })` ignore the sneak. |
| Elevation timestamp on first Lord (id 4); Gora result does not auto-elevate | **Yes.** `SetRank` to 4 stamps `elevationAt` once via `COB.Clock.Wall`. Later Lord writes, demotion, and nil-clear leave the first stamp. Knight / Fresh Beef do not stamp. `RecordGoraResult` after a Knight win leaves `rankId` and `elevationAt` unchanged. Reviewer probe: Lord + victory still does not rewrite `elevationAt`. |
| No stored defense counter | **Yes.** `emptyGora()` has no `defenses`. `RecordGoraResult` nils `defenses` / `defenseCount`. `ensureCharacter` strips them on Restore. Suite and reviewer probe: Lord win does not grow a counter. Design Lead §4: derive later from `gora.results` + `elevationAt`. |
| Never-delete: tombstone only; no `SweepDeparted` | **Yes.** `TombstoneHuman` / `TombstoneCharacter` set `inactive`; row, rank, honorifics, Gora, and links remain. `Store.SweepDeparted` / `Prune` / `DeleteHuman` / `DeleteCharacter` are `nil`. `ResetForTests` is gated on `COB._IN_TEST`. |
| No Grant / standing / points / Prophet | **Yes.** Live surface has no `Grant`, `GrantGora`, `SetStanding`, `GetStanding`, `AddPoints`, `Prophet`. `SetRank` refuses id 7 / unknown / title strings / 0. `Ranks.ById` is 1–6 only. |
| No Archive codec, Recognition rite, SV writes, registered-Pope list | **Yes.** No `Export` / `Import` / `BeginRecognition` / `Canonize`. No `ChurchOfBeefDB` / `CreateFrame` / `SendAddonMessage`. Snapshot/Restore are table copies (P2-B will codec). `#8` not coded. Bootstrap does not call `COB.Store`. |
| Isolated suite green; no `dofile` of Scoring / Ladder | **Yes.** `lua tests/test_store.lua` → **277 passed, 0 failed** (reviewer rerun). Loads `Core/Common.lua` + `Data/Ranks.lua` + `Core/Store.lua` only. Ranks is required for `ById`; not Scoring/Ladder. |
| Writer did not edit TOC / bootstrap / `run.lua` / DB / UI / Net | **Yes.** Transcript Writes: `tests/test_store.lua`, `Core/Store.lua`, this lane’s report. Integrator already lists `Core\Store.lua` in the TOC and `test_store` in `tests/run.lua` — not a writer miss. `DB.store` remains `{}`. |

## Attack results

| Attack | Result |
|---|---|
| Law 1 — stored `streak` / wins / H2H tallies are a points economy? | **No.** Gate 1 ratified narrative W/L streaks as event records. Bible §10.9 names wins/losses, streaks, head-to-heads. No amounts, Grant, daily cap, threshold, or standing sort. Famous Upset and notable victim are caller flags, not computed scores. |
| Law 1 — honorifics or Council flag are currencies / thresholds? | **No.** Gate 1: honorifics are records, not an economy. `AddHonorific` is cosmetic text. `SetCouncil` is a boolean and does not invent rank 6 or a score. |
| Law 1 — Restore can carry `points` / `standing` extra keys? | **Passthrough, not a faucet.** Reviewer probe: a crafted snapshot keeps `points` / `standing` on the human row. Live `Create*` / `SetRank` / `RecordGoraResult` never write those keys. Lane B integrity must fail closed (P2-B). Do not add a Store denylist this lane (that invents Archive policy and can look like a wipe). |
| Law 2 — `level` / class / professions / fight counts are behavior tracking? | **No.** Bible §12.1 names those character fields. `headToHeads.fights` is sanctioned-Gora event count (§10.9 / Iron Chin material), not hours or activity. No last-seen, combat minutes, or contribution number. |
| Law 5 — ungated APIs are a second writer / peer authority? | **No.** Brief: one writer = these APIs. Congregation UI/Net are not called. No broadcast, no self-reported authority, no registered-Pope list. Later layers must not call these writes on a congregation client — that is not this schema. |
| Law 5 — `Restore` is a second source of truth? | **No.** Same in-memory store. P2-B: Archive is a codec, not a second writer. `Restore` is the shape that codec will call. |
| Law 5 / §12.2 — `LinkCharacter` invents Recognition / silent self-link? | **No.** It is the Pope-store bind write P2-C is told to call. No kneel UI, no same-account auto-bind, no `BeginRecognition`. Create ignores sneaked `humanId`. Lane C must still require the logged-in character. |
| Law 7 — tombstone or `SetRank(nil)` deletes Church history? | **No.** Inactive flag; rank, honorifics, Gora, links, `elevationAt` remain. Clearing current rank does not clear elevation or history. No departed sweep. |
| Law 7 — `Restore({})` or a map-shaped `humans` table wipes the live store? | **Primitive replace, not `SweepDeparted`.** Reviewer probe: empty Restore drops live humans; `{ [10] = row }` loads nothing (`#list == 0`) and replaces the store. Live tombstone path never does this. Lane B must not apply an empty / non-array / failed-integrity payload. |
| Law 9 — Prophet / seventh rank / Pope-as-rank sneaks in? | **No on the live path.** `SetRank` uses `Ranks.ById`; id 7 / 99 / `"Beef Lord"` / 0 fail and leave rank unchanged. Reviewer probe: **Restore does not run `knownRank`** — a crafted `rankId = 7` survives and `RankForCharacter` returns 7. That is Lane B’s fail-closed import, not a live verb. Do not silently nil it here (looks like history mutation). |
| §12.1 — Gora on the human, or rank on the character? | **No.** Humans have no `gora` (`ensureHuman` strips it). Characters have no `rankId` (`ensureCharacter` strips it). `RecordGoraResult` refuses a human-only id. |
| §12.3 / §12.4 — name string as durable id; name reuse overwrites? | **No.** New id on reuse. Transfers are same-human re-link (confirmation); cross-human rebind is refused. No shared-account machinery. |
| §13.1 — store writes SV or congregation theater? | **No.** In-memory only. No `ChurchOfBeefDB`. No UI/Net. Lane D’s `store = {}` hook is untouched. |
| §10.9 / Design Lead §4 — defenses stored, or Gora auto-elevates to Lord? | **No.** No defense field. Elevation is a Pope `SetRank(..., 4)` stamp only. Results carry timestamps so defenses can be derived later. |
| §15 / §16 — mechanical honorifics or live canon scripture? | **No.** Honorifics are text. `FlagMoment` is `{ at, location? }`. `Store.Canonize` is `nil`. `AppendCeremony` stores type + time + ids; no narration fields on the live append. |
| Writer edited TOC / bootstrap / `run.lua` / DB / UI / Net, or committed? | **No.** Exclusive Writes only. No commit. `OPEN_QUESTIONS.md` has no new Lane A item (integer ids follow the brief; #9 already resolved). |

Refutation of Law 1 (no points economy), Law 2 (events, not behavior), Law 5 (one Pope writer), Law 7 (never-delete; rank on the human, Gora on the character), Law 9 (six ranks, no Prophet), and Bible §12 / §13.1 / §10.9 **fails** for the exclusive files. The Restore passthrough is a Lane B integrity leftover, not a live Grant / Prophet / sweep engine.

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current except the integrator lines (already done). Additional live leftovers this lane correctly did not touch:

### Integrator (already landed — writer report is stale)

- `ChurchOfBeef.toc` lists `Core\Store.lua`. Writer did not edit it.
- `tests/run.lua` lists `test_store`. Writer did not edit it.

### Lane B (Archive codec)

- `Snapshot` / `Restore` are table copies only. No export string, no integrity stamp.
- Restore will accept a crafted Prophet `rankId`, extra `points` / `standing` keys, ceremony `narration`, and an empty or map-shaped payload. **Fail closed on import.** Do not treat a missing archive as a wipe. Do not fork a second schema.

### Lane C (Rite of Recognition)

- `LinkCharacter` is the store write, not the rite. No logged-in check, no confirmer role, no kneel session.
- Same-human re-link is confirmation (id list does not duplicate; a second `linked` history event is recorded). Cross-human rebind is refused.

### Lane D / later

- `ChurchOfBeefDB.store` is still `{}`. This module does not persist.
- `ChurchOfBeef.lua` does not call `COB.Store`.
- Derive defense counts from character `gora.results` + human `elevationAt`. Do not add a stored counter.
- `CANONIZE`, Director Console, ceremony runtime, BeefNet v2, registered-Pope list (#8 — do not code).
- `Core/Gora.lua` remains the Phase 1 pair-note stub. Not a second Gora store.

## Findings

### Critical

None. No one-line Law breach in the live write path. Restore validation was not implemented: that would invent Lane B’s fail-closed import policy.

### Important

1. **`Restore` does not run `knownRank` and does not refuse extra keys.** Reviewer probe: `rankId = 7` plus `points` / `standing` survive; `RankForCharacter` then returns 7. Live `SetRank` still refuses Prophet. Lane B must reject that payload. Do not “fix” by silently nilling ranks in Store (Law 7 shape).

2. **`Restore` of `{}` or a map-shaped `humans` table replaces the live store.** Array load (`for i = 1, #list`) drops keyed maps. Lane B must require the Snapshot array shape and must not apply an empty/foreign blob. Not a `SweepDeparted` on the tombstone path.

3. **Human and character id sequences are independent.** Id `1` may exist in both maps. `SetRank(1)` is the human; `RecordGoraResult(1)` is the character. Ceremony `participantIds` are bare integers with no human/character tag. Writer disclosed this. Callers must use the matching getter. This review does not invent tagged ids.

### Nit

1. **Writer leftover map is stale** (`P2-A-schema.md`). TOC and `tests/run.lua` already list Store / `test_store`. Integrator, not a writer miss. Does not reopen Spec.

2. **`CreateCharacter` and `TombstoneCharacter` accept `now` and discard it.** Human create/tombstone append dated history. Character inactive has no timestamp. Brief asked for an inactive flag, not character membership history. Do not invent `createdAt` / `inactiveAt`.

3. **Suite does not lock sneaked create fields** (`CreateHuman({ rankId = 1 })`, `CreateCharacter({ humanId, defenses })`). Implementation ignores them (reviewer probe). Coverage gap only.

4. **`SetRank` / `SetCouncil` / `AddHonorific` do not append membership history.** History is `created` / `linked` / `inactive`. Rank is current state; Knighting belongs on the ceremony log. Acceptable MVP.

5. **`AppendCeremony` type is unvalidated text.** Live append writes no scripture. Closed rite kinds are ceremony runtime, not this log.

6. **`RecordGoraResult` writes one character.** The opponent’s Gora is unchanged unless the Pope records that side too. Correct for a per-character API; not a dual-write invention.

7. **Council boolean and rank id 6 are independent.** Bible names both (§5 rank; §12.1 flag; Design Lead: designations live in the Pope store). Do not collapse them.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated Common + Store (Ranks for `ById`); no Scoring/Ladder | Met (277 / 0) |
| Store-local integer ids; `Names.Key` is not a row key | Met |
| Human owns rank, Council, honorifics, membership history, tombstone | Met |
| Character owns name, class, level, professions, Gora, tombstone | Met |
| Unlinked character has no rank; not defaulted to Fresh Beef | Met |
| Gora fields named in §10.9; no stored defense counter | Met |
| Elevation timestamp on first Lord (id 4); no auto-elevate | Met |
| Ceremony log: type + timestamp + participant ids; no narration | Met |
| Marked moments: flag-hot timestamp + optional location; no canon text | Met |
| Tombstone only; no `SweepDeparted` | Met |
| `SetRank` validates `Ranks.ById`; refuse Prophet / unknown | Met |
| Reuse `COB.Clock` | Met |
| Do not invent Director Console, Archive codec, Recognition, SV/TOC, registered-Pope, Grant/standing/points | Met |
| Do not edit TOC / bootstrap / `run.lua` / DB / UI / Net | Met (integrator listed Store after) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 1, 2, 5, 7, 9
- Brief `docs/reformation/phase-2/briefs/P2-A-schema.md`
- Writer report `docs/reformation/phase-2/reports/P2-A-schema.md`
- Bible §12, §13.1, §10.9, §15, §16
- `docs/reformation/phase-1/GATE1_DESIGN_LEAD_DIRECTIVE.md` §4
- `.cursor/rules/identity-records.mdc`
- `addon/ChurchOfBeef/Core/Store.lua` (live + Restore/create/elevation/defense probes)
- `tests/test_store.lua` (live + isolated run: 277 / 0)
- `Data/Ranks.lua` (ids 1–6; no Prophet)
- `Core/DB.lua` (`store = {}` only)
- `ChurchOfBeef.toc` / `tests/run.lua` (integrator listings)
- Writer transcript ([Pope store](465ecfeb-fb5c-4acf-8bcf-7d9a6965fec2)) — exclusive Writes only
- `docs/design/OPEN_QUESTIONS.md` (unchanged; #8 do not code; #9 already resolved)
- P2-B / P2-C briefs (leftover assignment only; Archive / Recognition not invented)
