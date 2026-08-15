# Phase 6 Lane A — Appendix A validation sheets (items 1–4)

**Status:** DONE

**Cited:** Bible Appendix A (items 1–13), §10.7, §10.8, §13.1, §13.4, §20.3, §5, §8, §18.1, §22.1 item 2; Laws 4, 5, 8; brief `docs/reformation/phase-6/briefs/P6-A-appendix-a.md`; OPEN_QUESTIONS #2 and #8 (read only). Gate 5 is closed.

Validation ledger created. Items 1–4 have method sheets. Every Result is **NOT RUN**. Owner of in-game close: **David**. Items 5–13 are titled on the ledger as "sheet later" only. Addon Lua, TOC, tests, `OPEN_QUESTIONS.md`, and `docs/phases/**` were not edited. No commit.

## Files written

| Path | What changed |
|------|----------------|
| `docs/validation/README.md` | Ledger of Appendix A items 1–13. Items 1–4 link to sheets (Result NOT RUN). Items 5–13: title + "sheet later". How a Result is written. |
| `docs/validation/A01-live-health.md` | Item 1: Fight HUD live bars; fallback HUD without live health (§10.7); live target/nameplate method; coded no-health HUD is not a pass. |
| `docs/validation/A02-duel-messages.md` | Item 2: auto-proposed verdicts / Cowardice; fallback pure manual verdict (already the shipped override); live duel win/flee/locale/range method; no chat parser. |
| `docs/validation/A03-sender-integrity.md` | Item 3: §13.4 / §13.1 / §20.3; no named Bible fallback (closer applies); GUILD / WHISPER / RAID sender method; no 40-client proof; `#8` not coded. |
| `docs/validation/A04-guild-roster.md` | Item 4: KNIGHT THIS BEEF, Presence, §5 mapping; write only where the API permits; live read/refresh/Blizzard-UI promote method; no guild-rank map; no `GuildPromote` in addon. |
| `docs/reformation/phase-6/reports/P6-A-appendix-a.md` | This file |

## Sheet contract (items 1–4)

Each sheet names, from the Bible only:

| Field | Present |
|-------|---------|
| Dependent feature | Yes |
| Bible fallback if the API fails | Yes (item 3: Appendix A closer — no named fallback) |
| Live Anniversary TBC (`20506`) method | Yes |
| Owner: David | Yes |
| Result: NOT RUN | Yes |

## What this lane refused to invent

- In-game Results (PASS / FAIL / PARTIAL)
- HUD final form (OPEN_QUESTIONS #2 waits on A01)
- Treating `UI/Hud.lua` (`health` always nil) as an A01 pass
- Auto-propose from duel chat (A02 fallback is the shipped one-tap verdict)
- A 40-client rate-limit proof (A03)
- `Data/Popes.lua` / registered-Pope list / override UX (`#8`)
- A guild-rank map
- `GuildPromote` / `SetGuildRank` in addon code
- Items 5–13 method sheets
- Any edit to `OPEN_QUESTIONS.md`

## Leftovers (other lanes / David — not fixed)

- **David:** walk A01–A04 on the live client and write Results
- **Later lane:** items 5–13 sheets (raid markers, name targeting, SavedVariables, PlaySoundFile, party/raid, professions, guild bank, dungeon completion, login/reload timing)
- **#8** stays uncoded
- **A03 RAID** and **40-client scale** stay unproven until those conditions exist
- **A04** guild-rank write on KNIGHT THIS BEEF stays later UI, only if the Result says the API permits
- Lane B checklist and Lane C dress rehearsal are other exclusive files

## Concerns

- Item 3 has no Bible-named fallback. A FAIL there is a design decision, not a silent degrade-to-Quiet (that degrade is version mismatch, §13.4 / §20.3).
- Item 4's only Bible degradation is "where the API permits." Church store remains truth if promote is refused.
- A01's shipped no-health HUD is the §10.7 fallback surface. It must not be read as item 1 PASS.
