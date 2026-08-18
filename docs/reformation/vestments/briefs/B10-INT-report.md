# B10-INT — Batch 10 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.7, §13.1; license 2. B10-A rereview PASS; B10-B/C/D Spec PASS.

No new TOC files. No new codec kinds. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Glue

`stateFields` uses `GetLastSanctioned` / `GetLastFavorSplit` when the live pair is gone and the event is still live. Toggle-off still omits favor. Sanction and the four rulings `SendState`. Inbound STATE with two fighters `Show`s the fighter card; QUIET inbound `Hide`s it. Inspect stays silent.

## Verification

```bash
lua tests/test_gora.lua           # 505 passed, 0 failed
lua tests/test_hud.lua            # 539 passed, 0 failed
lua tests/test_fighter_card.lua   # 441 passed, 0 failed
lua tests/test_console.lua        # 1081 passed, 0 failed
lua tests/test_wire_glue.lua      # 455 passed, 0 failed
lua tests/run.lua                 # 9936 passed, 0 failed
```

TOC `## Interface: 20506`. Anniversary `UIPanelScrollFrameTemplate` is a Classic FrameXML template (wiki).

## Concerns

- B10-A first review FAIL: last leaked across EndEvent → StartEvent. Event-id tag + pin. Rereview PASS.
- Console Archive/Canonize sit below the 780 viewport (scroll). Stock scrollbar may overlap the Gora column.
- Leftover Runtime subjects after a ruling can still make a congregation plate clickable; `RecordFavor` refuses without a live pair.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
