# Phase 2 Lane B — Sacred Archive codec

Read: Ten Laws 5, 7; Bible §13.5, §13.1; `.cursor/rules/identity-records.mdc` Sacred Archive section.

**Do not start until Lane A is signed.** The store snapshot shape is A's.

## Exclusive files

- `addon/ChurchOfBeef/Core/Archive.lua` (create)
- `tests/test_archive.lua` (create)
- Report: `docs/reformation/phase-2/reports/P2-B-archive.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, `Core/Store.lua`, `Core/DB.lua`, UI.

## Mission

Test-first. Sacred Archive is a **codec**, not a second writer (Law 5).

Bible §13.5 requirements for this lane:

- One-action **export** to a string (file/string).
- **Import** that restores the Pope store.
- **Integrity** check (detect truncated / tampered / foreign payload). Fail closed — do not apply a bad import.

Cold-mirror and weekly reminder are **out of scope**. Do not invent Discord posting, file-picker widgets, or a Quiet-Mode nag.

Serialize the store snapshot only (not `ui`, not leftover demo `ladder` / `scoring` keys). Round-trip must preserve humans, characters, ranks, Gora records, ceremony log, marked moments, honorifics, elevation timestamps, tombstones.

If Store has `Snapshot` / `Restore`, call those. Do not fork a second schema. Isolated suite: Common + Ranks + Store + Archive.

**Fail closed on import** (Lane A review leftover): refuse and do not call `Restore` when integrity fails, payload is empty, humans/characters are not arrays, a human `rankId` is not in `Ranks.ById` (including Prophet / 7), or the snapshot carries `points` / `standing` / Grant-shaped keys. A missing or bad archive is not a wipe.

## Do not invent

Export file format beyond a string + integrity stamp (engineering, not product). Reminder UX. Council mirror writer. Phase 3 broadcasts.

## Do not git commit.
