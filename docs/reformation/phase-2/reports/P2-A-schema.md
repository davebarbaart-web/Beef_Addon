# Phase 2 Lane A — Pope store schema

**Status:** DONE

**Cited:** Ten Laws 1, 2, 5, 7, 9; Bible §12, §13.1, §10.9, §15, §16; GATE1 Design Lead §4 (elevation timestamps; #8 do not code); brief `docs/reformation/phase-2/briefs/P2-A-schema.md`; `.cursor/rules/identity-records.mdc`.

In-memory Pope store only. No TOC / bootstrap / `tests/run.lua` / `Core/DB.lua` / UI / Net edits. No Grant, standing, points, Prophet, Director Console, Archive codec, Recognition rite, or BeefNet v2. No commit. `OPEN_QUESTIONS.md` unchanged.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_store.lua` | Created first. Isolated suite: Common + Ranks + Store. |
| `addon/ChurchOfBeef/Core/Store.lua` | Created after the suite. Pope-authoritative in-memory store. |
| `docs/reformation/phase-2/reports/P2-A-schema.md` | This file |

## Schema (Bible-named rows)

**Identity.** Store-local monotonic integers for human id and character id. `COB.Names.Key` / `Display` are spelling helpers only — never row keys. Name reuse creates a new character id.

**Human owns:** `rankId` (1–6 from `COB.Ranks.ById`, or nil), `council` (boolean), `honorifics` (text list), `history` (membership events), `inactive` (tombstone), `elevationAt` (set once when rank becomes Beef Lord, id 4), `characterIds`. No Gora record.

**Character owns:** display `name`, `class`, `level`, `professions` (may be empty), `gora`, `inactive`, optional `humanId`. No `rankId`. Unlinked characters have no Church rank and are not defaulted to Fresh Beef.

**Gora record (§10.9):** `wins`, `losses`, `streak` (sanctioned W/L only), `headToHeads`, `notableVictims`, `rulings`, `results` (timestamped; Famous Upset is a flag on a result). **No defense counter** — defenses stay derived later from results + `elevationAt` (Design Lead §4). RecordGoraResult does not set rank or elevation.

**Ceremony log:** append-only `{ type, at, participantIds }`. No narration.

**Marked moments (§16):** flag-hot `{ at, location? }`. No canonization scripture.

**Never-delete:** `TombstoneHuman` / `TombstoneCharacter` set `inactive`. Row remains. No `SweepDeparted`, prune, or delete.

## API

| Method | Role |
|--------|------|
| `CreateHuman(fields?, now?)` | New human; rank starts nil |
| `GetHuman(id)` | Copy |
| `CreateCharacter(fields, now?)` | New unlinked character; name required |
| `GetCharacter(id)` | Copy |
| `LinkCharacter(characterId, humanId, now?)` | Bind; refuse a different human; same-human re-link is confirmation |
| `RankForCharacter(characterId)` | Linked human's `rankId`, or nil |
| `SetRank(humanId, rankId, now?)` | Validate `Ranks.ById`; refuse Prophet / unknown; first Lord write stamps `elevationAt` via `COB.Clock` |
| `SetCouncil(humanId, flag)` | Boolean only; does not change rank |
| `AddHonorific(humanId, text)` | Cosmetic text; no mechanics |
| `TombstoneHuman(id, now?)` / `TombstoneCharacter(id, now?)` | Inactive flag; row remains |
| `RecordGoraResult(characterId, fields, now?)` | Sanctioned result on a **character**. Rulings: `victor`, `cowardice`, `void`, `free` |
| `AppendCeremony(type, participantIds, now?)` | Ceremony log |
| `GetCeremonyLog()` | Copy |
| `FlagMoment(location?, now?)` | Marked moment |
| `GetMarkedMoments()` | Copy |
| `Snapshot()` / `Restore(snap)` | In-memory shape for Lane B. Not an Archive codec |
| `ResetForTests()` | No-op unless `COB._IN_TEST` |

Getters return copies. Expected failures are `nil, err`. Timestamps go through `COB.Clock.Wall`.

## Verification

- Isolated suite (`tests/wow_stub.lua` optional; `Core/Common.lua` + `Data/Ranks.lua` + `Core/Store.lua`): **277 passed, 0 failed**.
- Lua 5.1.5. No `CreateFrame`. No `dofile` of Scoring / Ladder / DB / UI / Net.
- `lua tests/test_store.lua` exits 0.

## Leftovers (other lanes — not fixed)

- **Integrator:** add `Core/Store.lua` to `ChurchOfBeef.toc` (file exists now). Add `test_store` to `tests/run.lua`. Full harness will report the new suite as unlisted until then.
- **Lane B:** Archive codec over `Snapshot` / `Restore`. This lane does not export/import strings or check integrity.
- **Lane C:** Rite of Recognition session. Store only has `LinkCharacter` (Pope-store write). No kneel UI, no self-service bind.
- **Lane D:** empty `ChurchOfBeefDB.store = {}` hook already exists. This module does not persist into SV. Wiring Snapshot → `DB.store` is not this lane.
- **Later display:** derive defense counts from character `gora.results` + human `elevationAt`. Do not add a stored counter.
- **Later:** `CANONIZE` (cold scripture), Director Console, ceremony runtime, BeefNet v2, registered-Pope list (#8 — do not code).

## Concerns

- `LinkCharacter` is a store write, not the Rite. Lane C must still require a logged-in character and refuse silent same-account binds.
- Elevation is a Pope `SetRank(..., 4)` stamp. A Gora win never elevates.
- Human and character id sequences are independent; id `1` may exist in both maps. Callers must use the matching getter.
- `OPEN_QUESTIONS.md` was not edited. Monotonic integer ids follow the brief; defense remains a derived statistic (#9 resolved).
