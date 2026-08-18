# Batch 14 — Knighting catch-up overlay + ESC / persist polish

**Cited:** Bible §20.3 catch-up (subjects may carry candidate); §18.1 collapsible movable console; §18.5 congregation input; wiki ESC + `UISpecialFrames` dedupe; license 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No `PlaySound` on ESC / show / hide. No Pope-name lookup. No custom media.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B14-A | `Net/Snapshot.lua`, `tests/test_net_snapshot.lua` | Overlay Knighting line-head `humanId` onto encoded SNAPSHOT when Runtime lacks a candidate (ASSEMBLY, or RITE Knighting). Stub `COB.Knighting` in-file. Isolation stays Common+Runtime+Codec+Snapshot. |
| B14-B | `UI/Inputs.lua`, `tests/test_inputs.lua` | Confess box: type-guard `OnEscapePressed` → `ClearFocus` only; type-guard `SetMultiLine(true)`. Event Mode stock. No Pope-name lookup. Do not register Inputs on `UISpecialFrames`. |
| B14-C | `UI/ConsoleDock.lua`, `tests/test_console_dock.lua` | Persist drag point to `ChurchOfBeefDB.ui.consoleDock` (HUD savePoint pattern). Event-only; Quiet hide stays. Stock `BasicFrameTemplate`. |
| B14-D | `UI/Console.lua`, `tests/test_console.lua` | `UISpecialFrames` rememberSpecial dedupe (Decree-style). Named `ChurchOfBeefConsoleFrame`. No `PlaySound` on ESC. Nested pins inside `runB8E()`. `SaveNote` stays nil. |
| B14-INT | `ChurchOfBeef.lua`, `tests/test_wire_glue.lua` | Overlay Knighting line-head candidate onto STATE subjects when Runtime lacks candidate (mirror of SNAPSHOT). Last pair still not post-Continue ASSEMBLY. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
