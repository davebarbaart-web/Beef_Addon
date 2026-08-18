# Batch 13 — Catch-up Restore + ESC / wheel polish

**Cited:** Bible §20.3 catch-up; §14.2 Records; §18.1 console; license 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No `PlaySound` on ESC.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B13-A | `Net/Snapshot.lua`, `tests/test_net_snapshot.lua` | Pin ApplyResponse of ASSEMBLY live overlay Restores (B12-A unlocked) |
| B13-B | `UI/FighterCard.lua`, `tests/test_fighter_card.lua` | OnHide syncs lastView; lastPair until QUIET |
| B13-C | `UI/RecordsBook.lua`, `tests/test_records.lua` | Mouse wheel turns leaves |
| B13-D | `UI/Console.lua`, `tests/test_console.lua` | stockEdit OnEscapePressed ClearFocus |
| B13-INT | glue only if needed; ledger; install | Exclusive sources unopened |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
