# Phase 2 Lane B — Adversarial Review

**Lane:** Sacred Archive codec
**Exclusive files:** `addon/ChurchOfBeef/Core/Archive.lua`, `tests/test_archive.lua`
**Lane report:** `docs/reformation/phase-2/reports/P2-B-archive.md`
**Cited law:** Ten Laws 5, 7, 9; Bible §13.5, §13.1; brief `docs/reformation/phase-2/briefs/P2-B-archive.md`; Lane A leftover `docs/reformation/phase-2/reports/P2-A-schema-review.md` (Restore fail-closed); `.cursor/rules/identity-records.mdc` Sacred Archive
**Writer:** [Sacred Archive](a02c68d2-d0f5-4bfe-a620-367dfb4488e2)

**Spec:** PASS
**Quality:** Approved

Codec only. Not a second writer. `Export` stamps `Store:Snapshot`. `Import` calls `Store:Restore` only after integrity and schema checks. `Check` is the same gate and never Restores. Named fail-closed cases leave the live store untouched. Isolated suite: **490 passed, 0 failed**. Writer stayed inside exclusive files. `Store.lua` / `DB.lua` / `Recognition.lua` not edited. `OPEN_QUESTIONS.md` unchanged. No commit. No Discord, reminder, file-picker, cold-mirror writer, or BeefNet v2.

## Verdict

Refutation of Laws 5, 7, 9 and Bible §13.5 / §13.1 **fails** for this lane’s exclusive files.

Law 5 and §13.1 are intact: the Pope store remains the single writer. Archive holds no humans, ranks, or Gora rows. It does not fork a second schema. A stamped string is a backup, not authority, until the Pope imports it through `Store:Restore`.

Law 7 is intact on the honest path and on the named leftover: missing, empty, truncated, tampered, foreign, non-array, Prophet, and points/standing/Grant payloads do not call Restore and do not wipe. Round-trip keeps Bible-named rows, including `elevationAt` and tombstones. A *valid* empty-store snapshot may Restore empty — that is a Pope import of a real Snapshot, not a missing-archive wipe.

Law 9 is intact: human `rankId` must be in `Ranks.ById` (1–6) or nil. Prophet / 7, 99, `0`, and title strings refuse. Character `rankId` is not a Church rank; Restore still strips it.

This review did not invent reminder UX, a file-picker, a Council mirror writer, or a Director Console button, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| Codec only; not a second writer; uses `Store:Snapshot` / `Restore` | **Yes.** Public surface is `Export` / `Check` / `Import` only. No `Archive.Restore`, `Snapshot`, create/set/record verbs, or local humans table. `Export` calls `Store:Snapshot`. `Import` calls `Store:Restore` only after `open` (unstamp + decode + `validate`). Stamp is `COBARCH1` + checksum + encoded Snapshot — engineering, not a product file format. |
| Export / Check / Import exist; Check never Restores | **Yes.** Suite spies `Store.Restore`: Export 0, Check(good) 0, Check(bad) 0, Import(good) 1. Reviewer probe: `Check(nil)` and `Check(good)` leave live Keep; `restoreCalls == 0`. |
| Fail closed (no Restore; live store untouched) on truncated / tampered / foreign / empty | **Yes for the named empties.** Suite + reviewer: `nil`, `""`, whitespace, foreign plaintext / JSON / `COBARCH2` / Discord paste, truncated magic/header/body, flipped body, bad checksum, leading newline, `{}`, missing humans+characters. All `ok == nil`, `restoreCalls == 0`, Keep rank/name/history stay put. A valid empty-*array* Snapshot is not this case (see attacks). |
| Fail closed on non-array humans / characters | **Yes.** String humans/characters, map-shaped `{ [10] = row }` for either side: refuse, no Restore, Keep lives. Reviewer: map-shaped `ceremonyLog` also refuses (`"empty snapshot"`). |
| Fail closed on `rankId` not in `Ranks.ById`, including Prophet / 7 | **Yes.** 7, 99, `"Beef Lord"`, `0`: refuse, no Restore. Reviewer: exporting a live Prophet row (via direct `Store:Restore`) then `Archive:Import` refuses `"unknown rank id"` and leaves Keep at Knight. `Ranks.ById[7]` is nil. Ranks 1–6 and nil round-trip. |
| Fail closed on points / standing / Grant-shaped keys | **Yes.** Human/character/top-level/nested `points` and `standing`; `Grant`, `GrantGora`, `granted`; leftover `ladder` / `scoring` / `ui`; ceremony (and moment) `narration`. Reviewer: `POINTS` and `history.standing` refuse; `grantedAt` matches the `grant*` prefix and refuses. Live Keep untouched. |
| Bad archive is not a wipe | **Yes on the named path.** After every suite refusal, Keep is still Knight `"Keep"` with `created` history. Reviewer repeats that for foreign / truncated / Prophet-reimport / `POINTS`. Honest Export cannot emit the named bad shapes. |
| Round-trip preserves Bible-named rows including `elevationAt` and tombstones | **Yes.** Filled fixture: human Lord + `elevationAt == 6003` + inactive + Council + honorifics + history (`created` / `linked` / `inactive`); character class/level/professions/Gora W-L/streak/H2H/notable/Famous Upset/rulings; foe tombstone; unlinked character still `RankForCharacter == nil` and no `rankId` on the row; ranks 1–6 and nil; ceremony type+time+ids with no narration; marked moment location+time; no invented `defenses`. Next ids do not reuse snapshot ids. |
| No Discord / reminder / file-picker / cold-mirror writer / BeefNet v2 | **Yes.** `Remind` / `PostToDiscord` / `WriteFile` / `Mirror` / `BeginRecognition` / `CreateFrame` are `nil`. Source has no `SendAddonMessage`, slash, `io.open`, `ChurchOfBeefDB`, or `loadstring`. Weekly reminder and cold mirror stay out of scope. |
| Isolated suite green; `Store.lua` / `DB.lua` / `Recognition.lua` not edited | **Yes.** `lua tests/test_archive.lua` → **490 passed, 0 failed** (reviewer rerun; Lua 5.1.5). Loads Common + Ranks + Store + Archive only. No Scoring / Ladder / DB / UI / Net / Recognition `dofile`. Writer transcript Writes: `tests/test_archive.lua`, `Core/Archive.lua`, this lane’s report. `Store.lua` was Read. Snapshot/Restore still match Lane A (array copy / `loadRows`; no integrity). `DB.store` remains the empty hook. |
| Writer did not edit TOC / bootstrap / `run.lua` | **Yes.** Exclusive Writes only. Integrator already lists `Core\Archive.lua` and `test_archive` — not a writer miss. `ChurchOfBeef.lua` does not call `COB.Archive`. Full harness (integrator listing): **1492 passed, 0 failed**. |

## Attack results

| Attack | Result |
|---|---|
| Law 5 — Archive is a second writer / second source of truth? | **No.** No row store. No create/set/record/Grant APIs. Import writes only by calling the Pope store’s `Restore`. Congregation UI/Net are not called. The stamp is not authority. |
| Law 5 / §13.1 — ungated `Import` on every client is peer authority? | **No.** Same leftover as Store: one writer = these APIs on the Pope client. This lane must not invent a registered-Pope list (`#8`). Later layers must not Import on a congregation client or treat a Council copy as authority. The cold mirror is not built. |
| Law 5 / §13.5 — checksummed file is a Council mirror writer? | **No.** No `Mirror`, no periodic refresh, no Net. A string the Pope can paste is the §13.5 export/import requirement. Disaster recovery, not a second authority. |
| Law 7 — missing / bad archive wipes the live store? | **No on the named cases.** Restore is not called. Keep remains. That was the Lane A leftover. |
| Law 7 — valid empty-store Import over live Keep is `SweepDeparted`? | **No.** Reviewer probe: it *does* Restore and replace Keep. Writer disclosed this. The blob is a real Snapshot (empty arrays + `next*Id`). That is a Pope import, not a missing-archive wipe, not a departed sweep. Do not invent “refuse empty churches.” |
| Law 7 — crafted id-less / string-id / float-id human arrays wipe Keep? | **Restore of a stamped-but-unloadable array, not a sweep.** Reviewer probe: those pass `Check`/`Import`, `loadRows` drops every row (`isId` fails), live Keep is replaced with nobody. Honest `Store:Snapshot` always has integer ids. A forger who wants a wipe can already Import a valid empty-store archive. Do not fork a second schema; an `isId(row.id)` gate would only match Store’s existing load contract. Coverage gap — see Important. |
| Law 7 — valid filled Import over live Keep deletes Church history? | **No.** It Restores the archive’s history (Lord, tombstones, `elevationAt`). Live Keep is replaced because the Pope imported a different snapshot. Disaster recovery, not prune. |
| Law 9 — Prophet / 7 sneaks through Import? | **No.** Human 7 / 99 / title / 0 refuse. Reviewer: Archive will not re-admit an exported Prophet row. Direct `Store:Restore` still passthrough — that is Lane A’s store, not this codec. Do not edit `Store.lua` to silently nil ranks (Law 7 shape). |
| Law 9 — character `rankId = 7` becomes Prophet? | **No.** Reviewer: Import succeeds (brief gates *human* `rankId`); `ensureCharacter` strips `rankId`; `RankForCharacter` still reads the linked human’s Knight (3). Unlinked characters stay nil. Rank is not on the character row. |
| Law 9 — extra `prophet` / `xp` / `elo` keys are a seventh rank or a points faucet? | **No as ranks.** Reviewer: those keys are not in the named denylist; Import Restores them as passthrough extras. Live `SetRank` / `Create*` still do not write them. Expanding the denylist beyond points / standing / `grant*` would invent product. Not a Prophet rank. |
| §13.5 — weekly Discord reminder or file-picker invented? | **No.** Out of scope. No Quiet-Mode nag, no congregation toast, no widget. `OPEN_QUESTIONS.md` unchanged. |
| §13.1 — codec writes SV or broadcasts theater? | **No.** In-memory Snapshot/Restore only. No `ChurchOfBeefDB`. No BeefNet. Lane D’s `store = {}` hook is untouched. |
| Writer edited `Store.lua` / `DB.lua` / Recognition / TOC / bootstrap / `run.lua`, or committed? | **No.** Exclusive Writes only. No commit. |

Refutation of Law 5 (one Pope writer; Archive is a codec), Law 7 (never-delete; missing/bad archive is not a wipe), Law 9 (six ranks, no Prophet), and Bible §13.5 / §13.1 **fails** for the exclusive files. The Lane A Restore leftover (empty table, non-array, Prophet, points/standing/Grant) is closed on the Import path.

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current except the integrator lines (already done). Additional leftovers this lane correctly did not touch:

### Integrator (already landed — writer report is stale)

- `ChurchOfBeef.toc` lists `Core\Archive.lua`. Writer did not edit it.
- `tests/run.lua` lists `test_archive`. Writer did not edit it.
- `ChurchOfBeef.lua` does not call `COB.Archive`. Correct.

### Later / out of scope (do not invent here)

- Weekly Archive reminder (cold only; never mid-ceremony; Pope console; Quiet Mode; never a congregation toast or pip).
- Discord post, file-picker widget, Director Console export button.
- Council cold-mirror writer. The mirror never imports into authority.
- BeefNet v2 / registered-Pope list (`#8` — do not code).

### Lane C (Rite of Recognition)

- This codec has no link / kneel session. Recognition is another lane.

### Lane D / later

- `ChurchOfBeefDB.store` remains a hook. This codec does not persist into SV.
- Direct `Store:Restore` still accepts a crafted Prophet `rankId` and extra keys if called *around* Archive. Later layers must go through `Archive:Import`, not raw Restore, for foreign payloads.

### Same-lane quality (not a Spec reopen)

- Crafted human/character rows without a store-local integer `id` pass `Check` and `Import`; Store `loadRows` then drops them. Honest Export never emits this. Optional tighten: require `isId(row.id)` before Restore — that is Store’s load contract, not a new product field.

## Findings

### Critical

None. No one-line Law 5 / 7 / 9 or §13.5 / §13.1 breach in the exclusive files. Named fail-closed Import does not call Restore.

### Important

1. **Crafted id-less / non-integer id arrays pass `Check` and then Restore to nobody.** Reviewer probe: `{ { name = "Ghost", rankId = 1 } }`, `{ id = "1" }`, and `{ id = 1.5 }` stamp, Check returns true, Import calls Restore, `loadRows` skips every row, live Keep is gone. This is not `SweepDeparted` and not a missing archive. Honest Snapshot rows always have integer ids. A wipe forger already has the valid empty-store export. Do not invent a second schema; do not silently nil ranks in Store.

2. **`Store:Restore` remains a passthrough if called directly.** Reviewer probe: `rankId = 7` still lands on the human via raw Restore. Archive will not re-admit that export. Do not “fix” Store this lane.

3. **Valid empty-store Import replaces live rows.** Disclosed by the writer. Reviewer confirmed Keep is replaced. That is Pope Restore of a real Snapshot (empty arrays present). Do not treat it as a missing-archive wipe and do not invent a “refuse empty church” rule.

### Nit

1. **Writer leftover map is stale** (`P2-B-archive.md`). TOC and `tests/run.lua` already list Archive / `test_archive`. Integrator, not a writer miss. Does not reopen Spec.

2. **Map-shaped `ceremonyLog` / `markedMoments` errors as `"empty snapshot"`.** Still fail-closed. Error copy is engineering, not product.

3. **Digest is djb2 modulo 2^31−1.** Detects the suite’s truncation and casual tamper. Not a cryptographic MAC. Bible asked for an integrity check, not an HMAC. Do not invent a new stamp as product.

4. **`grant*` prefix refuses `grantedAt`.** No such Bible field exists. Do not add a `grantedAt` product key to dodge it.

5. **Duplicate human ids last-win on Restore.** Reviewer: two `id = 1` rows Import; the second name/rank remain. Honest Export does not duplicate. Do not invent merge policy.

6. **Extra keys `xp` / `elo` / `threshold` / `score` / `prophet` passthrough.** Brief named points / standing / Grant-shaped only. Not a seventh rank. Do not expand the denylist.

7. **Human and character id sequences stay independent (Lane A).** The codec does not retag them. Callers must use the matching getter.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated Common + Ranks + Store + Archive; no Scoring/Ladder | Met (490 / 0) |
| Codec only; not a second writer; call `Store:Snapshot` / `Restore`; no second schema | Met |
| One-action export to a string; import restores the Pope store; integrity check | Met |
| Check never Restores | Met |
| Fail closed: truncated / tampered / foreign / empty payload; no Restore | Met |
| Fail closed: humans/characters not arrays (including map-shaped) | Met |
| Fail closed: human `rankId` not in `Ranks.ById` (including Prophet / 7) | Met |
| Fail closed: points / standing / Grant-shaped keys | Met |
| Missing or bad archive is not a wipe | Met (named cases) |
| Round-trip: humans, characters, ranks 1–6, nil rank, Gora, ceremony, moments, honorifics, `elevationAt`, tombstones | Met |
| Serialize Snapshot only — not `ui`, not leftover `ladder` / `scoring` | Met (export omits; import refuses) |
| No Discord, file-picker, weekly reminder, cold-mirror writer, BeefNet v2 | Met |
| Do not edit TOC / bootstrap / `run.lua` / `Store.lua` / `DB.lua` / UI / Recognition | Met (integrator listed Archive after) |
| No commit; do not invent product / reminder UX / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 5, 7, 9
- Brief `docs/reformation/phase-2/briefs/P2-B-archive.md`
- Writer report `docs/reformation/phase-2/reports/P2-B-archive.md`
- Lane A leftover `docs/reformation/phase-2/reports/P2-A-schema-review.md` (Restore fail-closed)
- Bible §13.5, §13.1
- `.cursor/rules/identity-records.mdc` Sacred Archive
- `addon/ChurchOfBeef/Core/Archive.lua`
- `tests/test_archive.lua` (isolated run: 490 / 0)
- `addon/ChurchOfBeef/Core/Store.lua` (Snapshot / Restore only — not edited this lane)
- `Data/Ranks.lua` (ids 1–6; no Prophet)
- `Core/DB.lua` / `Core/Recognition.lua` (not edited this lane)
- Writer transcript ([Sacred Archive](a02c68d2-d0f5-4bfe-a620-367dfb4488e2)) — exclusive Writes only
- `ChurchOfBeef.toc` / `tests/run.lua` / `ChurchOfBeef.lua` (integrator listings; bootstrap does not call Archive)
- `docs/design/OPEN_QUESTIONS.md` (unchanged; #8 do not code)
- Reviewer probes: empty-store over Keep; id-less / string / float ids; character `rankId = 7`; `POINTS` / `grantedAt` / nested `standing`; `xp`/`elo` passthrough; map `ceremonyLog`; foreign `notebook`; direct Restore Prophet; export-Prophet reimport; Check never Restores; unicode name; Council rank 6; leading newline; moment narration
