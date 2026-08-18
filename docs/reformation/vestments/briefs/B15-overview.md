# Batch 15 — Persist / wheel chrome / ESC dedupe / no Lord demotion

**Cited:** Bible §18.5 congregation input; §14.2 Records; §8 Knighting; wiki ESC `UISpecialFrames`; license 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No `PlaySound` on ESC / show / hide. No custom media. No GuildPromote (A04). No live HUD health (A01).

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B15-A | `UI/Inputs.lua`, `tests/test_inputs.lua` | Persist drag to `ChurchOfBeefDB.ui.inputs` (HUD savePoint). Event-only. Not on `UISpecialFrames`. ESC ClearFocus stays. |
| B15-B | `UI/RecordsBook.lua`, `tests/test_records.lua` | Wire `OnMouseWheel` on TitleBar, Close, ribbons, Previous, Next so chrome hover still turns leaves. PAGE_TITLES stay 9. |
| B15-C | `UI/MainFrame.lua`, `tests/test_ui.lua` | `UISpecialFrames` rememberSpecial dedupe for `ChurchOfBeefFrame`. Nested pins (200-local). No panel whoosh. |
| B15-D | `Core/Knighting.lua`, `tests/test_knighting.lua` | `KnightThisBeef` refuses rank ≥ Lord (4/5/6). Re-knight of a Knight stays allowed. No GuildPromote. |
| B15-INT | `ChurchOfBeef.lua`, `tests/test_wire_glue.lua` | Successful `Enqueue` / `Skip` / `Insert` send STATE. Add `sendState` to existing KnightThisBeef / ElevateToLord wraps (line head changes). |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
