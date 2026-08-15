# Phase 2 Lane A — Pope store schema

Read: `docs/reformation/phase-0/TEN_LAWS.md` Laws 1, 2, 5, 7, 9; Bible §12, §13.1, §10.9, §15, §16; `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4 (elevation timestamps; #8 do not code); `.cursor/rules/identity-records.mdc`.

## Exclusive files

- `addon/ChurchOfBeef/Core/Store.lua` (create)
- `tests/test_store.lua` (create)
- Report: `docs/reformation/phase-2/reports/P2-A-schema.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, `Core/DB.lua`, UI, Net. Integrator adds the file to TOC after it exists.

## Mission

Test-first. Write the suite first, then the module. Isolated `lua -e 'dofile("tests/wow_stub.lua"); ...' ` or a self-contained suite that `dofile`s `Core/Common.lua` + `Core/Store.lua` only must pass. Do not `dofile` Scoring/Ladder.

Pope-authoritative in-memory store (Bible §13.1). One writer: these APIs. Congregation UI/Net do not exist yet — do not call them.

### Bible-named rows (implement these)

**Human owns** (§12.1): Church rank (ids 1–6 from `COB.Ranks` or nil), Council status (boolean flag only), honorifics (Pope-granted text list, §15 — cosmetic, no mechanics), membership history, inactive/tombstone flag.

**Character owns** (§12.1): display name, class, level, professions (may be empty), **Gora record**, inactive/tombstone flag. Gora record fields named in §10.9: wins, losses, fight-record streak, head-to-heads, notable victims, rulings received (including Cowardice). **Do not store a defense counter** — defenses are derived later from Gora results + elevation timestamp (Design Lead §4). Famous Upsets are a Pope flag on a result, not a ranking.

**Elevation** (Design Lead §4): when a human's Church rank becomes Beef Lord (id 4), record an **elevation timestamp**. Required so defenses are computable later. Do not auto-elevate. Do not invent sit-the-champ.

**Ceremony log** (handoff): append-only entries (type + timestamp + participant ids). No generated narration (Law 4).

**Marked moments** (§16): flag-hot only — timestamp, optional location. Do not write canonization scripture. Software supplies no flavor text.

**Never-delete** (Law 7 / §12.3): tombstone / inactive only. No prune, no departed sweep, no record expiry. No `SweepDeparted`.

### Identity keys

`COB.Names.Key` / `Display` are spelling helpers, not durable ids (§12.4). Assign store-local monotonic integers for human id and character id. If that is wrong, append to `docs/design/OPEN_QUESTIONS.md` — do not use a name string as the row key.

Unlinked characters have no Church rank. Do not default an unlinked alt to Fresh Beef.

### Required APIs (names may vary; suite must lock behavior)

Create/get human; create/get character; set human rank (validate against `Ranks.ById`; refuse Prophet / unknown); set Council flag; add honorific; tombstone human or character (row remains); append ceremony log; flag a marked moment; record a sanctioned Gora result onto a **character** (not a human); set elevation timestamp when rank is set to Lord (or a dedicated elevate API the Pope would call — no auto).

Reuse `COB.Clock` for timestamps.

## Do not invent

Director Console, Rite UI, Archive codec (Lane B), Recognition flow (Lane C), SV/TOC (Lane D / integrator), registered-Pope list (#8), BeefNet v2, activity hours, points, standing, Grant, pairing scores, Fallen memorials, Notebook, Curtain.

## Do not git commit.
