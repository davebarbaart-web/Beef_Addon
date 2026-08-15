# Phase 6 Lane D — Appendix A validation sheets (items 5–13)

**Status:** DONE (method sheets only)

**Cited:** Bible Appendix A items 5–13; §8, §3.1, §3.2, §12, §13.1, §13.2, §13.4, §13.5, §14.1, §14.3, §16, §17, §19.1, §19.4, §20.3; Laws 6, 7, 8; Adjudication (raid-marker assist; guild-bank Important Later); Audit V6; ledger `docs/validation/README.md`; sheet pattern A01 / A04. Gate 5 is closed. Items 1–4 remain **NOT RUN** (owner David).

Addon Lua, TOC, bootstrap, tests, `OPEN_QUESTIONS.md`, `REFORMATION_LOG.md`, A01–A04, and `docs/phases/**` were not edited. No commit. No push.

## Files written

| Path | What changed |
|------|----------------|
| `docs/validation/A05-raid-markers.md` | Item 5: candidate/fighter marking (§8); fallback target-assist only; live leader/assist/member/combat/no-raid method. |
| `docs/validation/A06-targeting-by-name.md` | Item 6: console targeting assist; no named fallback (closer applies); live name-target in/out of combat; no SecureActionButton product. |
| `docs/validation/A07-savedvariables.md` | Item 7: records / Chronicle / Archive; no named fallback; live restore/reload/logout/size method; do not touch `WTF/`. |
| `docs/validation/A08-playsoundfile.md` | Item 8: §19.4 cues; no named fallback; live `PlaySoundFile` method; shipped `PlaySound` stub is not a pass. |
| `docs/validation/A09-party-raid.md` | Item 9: later-phase Expeditions/Campaigns; method only; composition + leader detection. |
| `docs/validation/A10-profession-links.md` | Item 10: later-phase self-reported profession directory; method only; TBC link observation. |
| `docs/validation/A11-guild-bank.md` | Item 11: later-phase tithe recognition; method only; log queryability; no contribution score. |
| `docs/validation/A12-dungeon-completion.md` | Item 12: later-phase Expeditions; method only; final-boss-kill signals per dungeon walked. |
| `docs/validation/A13-login-reload.md` | Item 13: Decree banner + snapshot requests; no named fallback; event-order method; existing banner is not a pass. |
| `docs/validation/README.md` | Ledger rows 5–13 now link the sheets; Result **NOT RUN**. Rows 1–4 unchanged (NOT RUN, owner David). |
| `docs/reformation/phase-6/reports/P6-D-appendix-a-5-13.md` | This file |

## Isolation

Docs only. Exclusive files listed above. No addon Lua, no TOC, no tests, no player `ChurchOfBeefDB.lua`, no `WTF/`.

## Sheet contract (items 5–13)

Each sheet names, from the Bible only:

| Field | Present |
|-------|---------|
| Title `A0N — <Bible title>` | Yes |
| Appendix A item / Owner: David / Result: NOT RUN | Yes |
| Dependent feature | Yes |
| Bible fallback, or "Appendix A names no standalone fallback" | Yes (item 5 names target-assist only; 6–13 have no standalone fallback) |
| Live Anniversary TBC (`20506`) method | Yes |
| Not a pass | Yes |
| Leftovers (named, not invented as product) | Yes |

## What this lane refused to invent

- In-game Results (PASS / FAIL / PARTIAL) on any item
- Live HUD health / health workarounds
- `#8` override UX / `Data/Popes.lua`
- SUMMON protocol
- INPUT channel
- Favor
- Calendar / RSVP / Decree deputy
- Grant / standing
- `GuildPromote` from Core
- A fifth Gora outcome
- SecureActionButton product (item 6)
- Marker-index scheme (item 5)
- Archive file format / weekly reminder widgets (item 7)
- Extra sound cues or Canonization seal product (item 8)
- Expeditions / Campaigns / profession directory / tithe UX / per-dungeon boss table (items 9–12 — method only)
- Snapshot schema / hold-timer / sixth runtime state (item 13)
- Treating `UI/Sound.lua` `PlaySound` as an A08 pass
- Treating the existing Decree banner on login as an A13 pass
- Any edit to `OPEN_QUESTIONS.md` or `REFORMATION_LOG.md`

## Verification

- All nine sheets exist under `docs/validation/`.
- Every sheet **Result:** is **NOT RUN**.
- Ledger rows 1–13 **Result** column is **NOT RUN**.
- Owner on every new sheet: **David**.

## Leftovers (other lanes / David — not fixed)

- **David:** walk A01–A13 on the live client and write Results. Items 1–4 remain load-bearing and still NOT RUN.
- **#8** stays uncoded; A13 snapshot theater stays fail-closed until licensed.
- Items 9–12 stay later-phase dependents after their Results exist.
- Do not claim V1/MVP complete from these sheets (Bible §22.3).
