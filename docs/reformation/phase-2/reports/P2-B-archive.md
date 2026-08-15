# Phase 2 Lane B — Sacred Archive codec

**Status:** DONE

**Cited:** Ten Laws 5, 7, 9; Bible §13.5, §13.1; brief `docs/reformation/phase-2/briefs/P2-B-archive.md`; Lane A leftover `docs/reformation/phase-2/reports/P2-A-schema-review.md` (Restore fail-closed); `.cursor/rules/identity-records.mdc` Sacred Archive.

Codec only. Not a second writer. No TOC / bootstrap / `tests/run.lua` / `Core/Store.lua` / `Core/DB.lua` / UI / Recognition edits. No Discord, file-picker, weekly reminder, cold-mirror writer, or BeefNet v2. No commit. `OPEN_QUESTIONS.md` unchanged.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_archive.lua` | Created first. Isolated suite: Common + Ranks + Store + Archive. |
| `addon/ChurchOfBeef/Core/Archive.lua` | Created after the suite. Sacred Archive codec over `Store:Snapshot` / `Store:Restore`. |
| `docs/reformation/phase-2/reports/P2-B-archive.md` | This file |

## Codec

Archive is a stamp around the Pope store snapshot. It does not keep its own humans, ranks, or Gora rows. `Export` calls `Store:Snapshot` and returns a string. `Import` calls `Store:Restore` only after integrity and schema checks pass. `Check` is the same gate without Restore.

**Stamp (engineering, not product):** `COBARCH1` + checksum of the snapshot body + encoded Snapshot table. Not a file-picker format. Not a Discord payload.

**Serialized shape** is Store's Snapshot only: `humans`, `characters`, `ceremonyLog`, `markedMoments`, and the four `next*Id` counters. Not `ui`. Not leftover demo `ladder` / `scoring`.

**Fail closed — Restore is not called when:**

- the blob is missing, empty, truncated, tampered, or foreign
- the decoded payload is an empty table, or humans/characters are missing or not arrays (including map-shaped `{ [10] = row }`)
- a human `rankId` is not in `Ranks.ById` (including Prophet / 7, 99, `0`, and title strings)
- any table carries `points` / `standing` / Grant-shaped keys (`Grant`, `GrantGora`, `granted`, …)
- leftover `ladder` / `scoring` / `ui` keys appear at the snapshot root
- a ceremony entry (or any nested table) carries `narration`

A missing or bad archive leaves the live store untouched. That is not a wipe.

Round-trip preserves humans, characters, ranks 1–6, nil rank, Gora records (wins/losses/streak/head-to-heads/notable victims/rulings/Famous Upset), ceremony log, marked moments, honorifics, `elevationAt`, and tombstones. Unlinked characters still have no rank. Defenses are not invented.

## API

| Method | Role |
|--------|------|
| `Export()` | Encode `Store:Snapshot()` to a stamped string |
| `Check(blob)` | Integrity + schema only. Never Restores |
| `Import(blob)` | `Check`, then `Store:Restore` |

Expected failures are `nil, err`. No `Archive:Restore`, `Snapshot`, create/set/record verbs, Grant/standing, reminder, Discord, file write, or mirror.

## Verification

- Isolated suite (`Core/Common.lua` + `Data/Ranks.lua` + `Core/Store.lua` + `Core/Archive.lua`): **490 passed, 0 failed**.
- Lua 5.1.5. No `CreateFrame`. No `dofile` of Scoring / Ladder / DB / UI / Net / Recognition.
- `lua tests/test_archive.lua` exits 0.
- Fail-closed cases spy `Store.Restore` and assert zero calls; live Keep rank/name/history stay put.
- `Store.lua` unread for edits.

## Leftovers (other lanes — not fixed)

- **Integrator:** add `Core/Archive.lua` to `ChurchOfBeef.toc` (file exists now). Add `test_archive` to `tests/run.lua`. Full harness will report the new suite as unlisted until then.
- **Lane C:** Rite of Recognition. This lane has no link/kneel session.
- **Later / out of scope:** weekly Archive reminder (cold only), Discord post, file-picker widget, Council cold-mirror writer, Director Console export button, BeefNet v2. Do not invent them here.
- **Lane D / later:** `ChurchOfBeefDB.store` remains a hook. This codec does not persist into SV.

## Concerns

- A *valid* empty-store archive (Snapshot arrays present, all empty) may Restore empty. That is a Pope import of a real snapshot, not a missing-archive wipe.
- Human and character id sequences remain independent (Lane A). The codec does not retag them.
- `Check` is the named integrity API. Import is the only path that Restores.
- `OPEN_QUESTIONS.md` was not edited. The stamp is engineering, not a product file format.
