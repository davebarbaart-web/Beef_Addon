# B18-INT — Batch 18 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.5 Inputs; §10.2 / §18.1 petition desk; §19.4 theater; §8 marks. B18-A/B/C/D Spec PASS.

No glue. Exclusive sources unopened after review. Confess box sits below the Inputs TitleBar. Opponent names trim. Console petition challenge line is pinned. HideAll bumps theaterGen once. Grouped Clear of the local name uses `"player", 0`. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_inputs.lua         # 599 passed, 0 failed
lua tests/test_console.lua        # 1388 passed, 0 failed
lua tests/test_ui.lua             # 382 passed, 0 failed
lua tests/test_markers.lua        # 342 passed, 0 failed
lua tests/test_wire_glue.lua      # 540 passed, 0 failed
lua tests/run.lua                 # 11544 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- No Petition chrome hint that a current target will be named.
- Presence filter still needs Roster ready.
- `ChurchOfBeefToast` (small toast) is still ESC-immune; Proclaim is the ESC surface.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
