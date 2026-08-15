# Phase 2 Lane C — Rite of Recognition (Core flow)

**Status:** DONE

**Cited:** Ten Laws 3, 4, 5, 7; Bible §12.2, §12.4; brief `docs/reformation/phase-2/briefs/P2-C-linking.md`; `.cursor/rules/identity-records.mdc` Linking; Lane A `Store:LinkCharacter` / `AppendCeremony`.

Core-only Recognition session. No TOC / bootstrap / `tests/run.lua` / `Core/Store.lua` / UI / Net edits. No self-service, silent same-account bind, BattleNet auto-link, kneel slash, UI timer, Director Console, congregation theater, registered-Pope list (#8), or unlink-as-delete. No commit. `OPEN_QUESTIONS.md` unchanged.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_recognition.lua` | Created first. Isolated suite: Common + Ranks + Store + Recognition. |
| `addon/ChurchOfBeef/Core/Recognition.lua` | Created after the suite. Core session only. |
| `docs/reformation/phase-2/reports/P2-C-linking.md` | This file |

## Session

One open rite at a time. The logged-in character id is an argument — `UnitName` is never read. Confirmer role is `pope` or `council` (case-folded). Begin does not write the store. Complete calls `Store:LinkCharacter` then, when present, `Store:AppendCeremony("Recognition", { characterId, humanId }, now)` with no scripture. Cancel clears the session and writes nothing.

Council may confirm; the write is still the Pope store (Law 5). Same-human re-link is confirmation (transfer/faction, §12.4) — `relink = true`; the character id list does not grow a second identity. Already bound to a different human is refused at Begin. Shared accounts have no machinery. Impersonation uses the same APIs.

Duration defaults to 30 and may be set on Begin via `{ now, duration }`. `IsExpired` is a harness query. Expiry does not auto-bind, auto-append, or block Complete.

## API

| Method | Role |
|--------|------|
| `Begin(humanId, characterId, confirmerRole, now?)` | Open a rite. `now` may be a number or `{ now, duration }`. Extra opts (`accountId`, `battlenetId`) are ignored and not stored. |
| `GetSession()` | Copy of the open rite, or nil |
| `Complete(now?)` | `Store:LinkCharacter`; optional ceremony append; close session |
| `Cancel()` | Close session; no store write |
| `IsExpired(now?)` | Metadata query; not a timer gate |
| `ResetForTests()` | No-op unless `COB._IN_TEST` |

Session copy fields: `humanId`, `characterId`, `confirmerRole`, `startedAt`, `duration`, `relink`. Getters return copies. Expected failures are `nil, err`.

## Verification

- Isolated suite (`Core/Common.lua` + `Data/Ranks.lua` + `Core/Store.lua` + `Core/Recognition.lua`): **163 passed, 0 failed**.
- Lua 5.1.5. No `CreateFrame`. No `dofile` of Scoring / Ladder / DB / UI / Net. `Store.lua` not edited.
- `lua tests/test_recognition.lua` exits 0.

## Leftovers (other lanes — not fixed)

- **Integrator:** add `Core/Recognition.lua` to `ChurchOfBeef.toc` (file exists now). Add `test_recognition` to `tests/run.lua`. Full harness will report the new suite as unlisted until then.
- **Later:** kneel presentation, Director Console verb, congregation theater. Not this lane.
- **#8:** registered-Pope / designated-Council configuration remains Phase 4. This module accepts a role token; it does not look up a Pope list.
- Tombstone / inactive stay on Store. Recognition has no Unlink.

## Concerns

- Duration is metadata. A later UI must not turn `IsExpired` into an auto-advance (Law 4).
- Ceremony `participantIds` are bare store integers with no human/character tag (Lane A leftover). This lane writes `{ characterId, humanId }`.
- `OPEN_QUESTIONS.md` was not edited. Shared-account disputes stay social (Pope), with no machinery here.
