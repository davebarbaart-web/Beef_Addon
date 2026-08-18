# B10-D — Glanceable Console scroll (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 (glanceable, movable, large targets; minimize window switching); Law 10 / §19.3 (Director Console stays stock-pragmatic); CONTINUE 2026-08-18 (no SUMMON; no post-show clipboard; `SaveNote` stays nil; Console stays plain); brief `docs/reformation/vestments/briefs/B10-D-console-scroll.md`.

Director Console stays stock. Outer frame height is **780**. Desk content sits on a stock `UIPanelScrollFrameTemplate` `ScrollFrame` (`ChurchOfBeefConsoleFrameDeskScroll`). Child height stays **1050**. `SetScrollChild` and `SetVerticalScroll` are type-guarded. Desks are not collapsed into tabs. Console is not parchment. `SaveNote` stays nil. No SUMMON. No post-show summary. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Init pins outer height 780 + desk `ScrollFrame`. Nested inside `runB8E()` (Lua 5.1 200-local cap): stock template + name; six ScrollFrames; child taller than the frame (1050); CeremonyLog / Archive / Canonize stay; SaveNote nil; no SUMMON / COPY SUMMARY / WHISPER ALL; source type-guards; isolation wrap re-pin. |
| `addon/ChurchOfBeef/UI/Console.lua` | `DEFAULT_HEIGHT` 1050 → 780. `DESK_CHILD_H` 1050. Stock `CreateFrame("ScrollFrame", …DeskScroll, …, "UIPanelScrollFrameTemplate")` around the desk. Type-guarded `SetScrollChild` / `SetVerticalScroll`. `frame.DeskScroll` / `DeskChild` / `Content`. Ritual plates and `SaveNote` untouched. |
| `docs/reformation/vestments/briefs/B10-D-console-scroll-report.md` | This file |
| `docs/reformation/vestments/briefs/B10-D-console-scroll.diff` | B10-D-only unified diff of the exclusive files vs the pre-lane baseline |

Did not edit Store, Gora, TOC, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

| Surface | Role |
|---------|------|
| Outer frame | Width 780, height **780**. Title bar stays on the frame. Movable / clamped unchanged. |
| Desk `ScrollFrame` | Stock `UIPanelScrollFrameTemplate`. Named `ChurchOfBeefConsoleFrameDeskScroll`. Viewport fills the body under the title bar. |
| Desk child | `Content` / `DeskChild`. Width `DEFAULT_WIDTH - 28`. Height `DESK_CHILD_H` (1050). Every existing desk stays on this child. |
| `SetScrollChild` / `SetVerticalScroll` | Called only when `type(...) == "function"`. Vertical scroll starts at 0. |
| `SaveNote` | nil |

### Desk

- Console stays stock. No custom media. No parchment.
- No SUMMON. No post-show ceremony summary. No WHISPER ALL.
- Desks are not tabs. Presence, Knighting, Gora, Confession, CeremonyLog, Archive, Canonize, Notebook stay.
- Ritual plates unchanged.

## TDD

1. Extended `test_console.lua` first (height 780, desk ScrollFrame, child tall, CeremonyLog / Archive / Canonize / SaveNote, isolation wrap, source type-guards). Isolation stayed under `if standalone then`. B10-D lives inside `runB8E()` (Lua 5.1 200-local cap).
2. Implemented `Console.lua`.
3. Green: `lua tests/test_console.lua` — **1081 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 1081 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | 1081 passed, 0 failed. Lua 5.1.5. Exit 0. |

**Isolated count:** 17 unique nil-module pins inside the opening `if standalone then` (Quiet shell, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Six loaded-module pins stay outside the wrap. B10-D re-pins Archive + Quiet shell + Toasts. Standalone suite: **1081 passed**.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Store / Gora not edited.
- Outer height is 780. Desk body is one stock ScrollFrame. Child stays 1050.
- `SetScrollChild` and `SetVerticalScroll` are type-guarded. Missing APIs skip.
- `Console.SaveNote` remains nil. Source has no `WHISPER ALL` and no `SUMMON THE FAITHFUL`.
- Isolation asserts remain behind `if standalone then`.
- CeremonyLog, Archive, Canonize, Proposed Bout, favor, Post Decree, and ritual plates stayed green.

## Concerns

- Client `/reload` smoke was not run. Mouse-wheel and the stock scrollbar thumb are unproven on Anniversary. **POLISH:CANDIDATE** only.
- Bible §18.1 also wants to minimize scrolling. This lane keeps every desk (no tabs) by scrolling the body. Archive / Canonize / Notebook sit below the 780 viewport and need a scroll.
- `UIPanelScrollFrameTemplate` draws a scrollbar on the right of a 780-wide frame. It may overlap the right Gora column; width was not changed.
- `DESK_CHILD_H` is a fixed 1050 (the pre-lane outer height). A later desk row will need a bump or the bottom will clip inside the child.
- The harness `SetScrollChild` / `GetScrollChild` pair is a stub noop. Tests pin `DeskChild` parentage and height, not `GetScrollChild()`.
- B10-D tests live inside `runB8E()` because the main chunk is already under Lua 5.1’s 200-local cap.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
