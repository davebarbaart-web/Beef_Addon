# B3-D — Console proposed bout + stipulation (report)

**Status:** DONE

**Cited:** CONTINUE 2026-08-18 license 4 (stock only; Console stays plain); Bible §10.3, §18.1, §19.3 / Law 10; Batch 2 critique §A.3; brief `docs/reformation/vestments/briefs/B3-D-console-bout.md`.

Director Console stays stock-pragmatic. Proposed bout is a pairing slot above SANCTION (`Name vs Name`) plus a one-line STIPULATION `InputBoxTemplate`. `Sanction()` reads `frame.Stipulation:GetText()` when the third argument is omitted; trim stays Gora’s. No parchment. No jokes. No winner picker. This file does not call `COB.Net`. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. GetProposedBout, proposed-bout paint, STIPULATION box → Gora, empty/whitespace omit, explicit arg wins. Isolation stays under `if standalone then`. Favor / decree / free-ruling pins kept. |
| `addon/ChurchOfBeef/UI/Console.lua` | `GetProposedBout`. Stock `PROPOSED BOUT` + `STIPULATION` above SANCTION. Refresh paints `frame.ProposedBout`. `Sanction` reads the box when the 3rd arg is omitted. |
| `docs/reformation/vestments/briefs/B3-D-console-bout-report.md` | This file |
| `docs/reformation/vestments/briefs/B3-D-console-bout.diff` | B3-D-only unified diff of the exclusive files vs the pre-lane baseline |

Did not edit Gora, Toasts, Store, Net, HUD, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

| Method | Role |
|--------|------|
| `GetProposedBout()` | Fresh `{ fighterA, fighterB, label }`. Valid selected ids only. `label` is `"NameA vs NameB"` from Store names when both ids are selected; else `""`. Mutating the copy does not change Console. |
| `Sanction(fighterA?, fighterB?, stipulation?)` | When `stipulation` is omitted, reads `frame.Stipulation`. Empty / whitespace box → Gora stores `nil`. An explicit third argument wins over the box. Still uses selected fighters when ids are omitted. |
| Refresh | Paints `frame.ProposedBout` from `GetProposedBout().label`. |

### Desk

- `PROPOSED BOUT` + pairing FontString directly above SANCTION.
- `STIPULATION` + `InputBoxTemplate` (`frame.Stipulation`), auto-focus off.
- Gora verbs shifted to `GORA_VERB_Y = 186`. Desk 336 / frame 636 so the slot fits without crushing the petition scroller.
- No winner picker. No custom media.

## TDD

1. Extended `test_console.lua` first (API, chrome, copy safety, two-id label, box trim / empty / explicit, Net counters). Isolation stayed under `if standalone then`.
2. Red: `GetProposedBout is a console readout` expected function got nil; EditBox count expected 4 got 3; stub aborted on missing `ProposedBout`.
3. Implemented `Console.lua`.
4. Green: `lua tests/test_console.lua` — **439 passed, 0 failed**.

Pope predicate uses the suite’s existing `Sender.IsRegisteredPope = function() return true end` wrap. No Pope name. No `Data/Popes.lua`.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 439 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | 439 passed, 0 failed. Lua 5.1.5. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. `after()` still Refresh / cue / HUD — no Net.
- Getters return copies. Expected failures stay `nil, err`.
- Stipulation is a remembered line, not a picker or rules engine.
- `Console.WinnerPicker` / `PickWinner` remain nil. No `OnUpdate`. No `UIParent:SetScale`.
- Isolation asserts remain behind `if standalone then`.
- Existing favor pane, congregation toggle, PostDecree-does-not-Net, and FREE RULING box pins stayed green.

## Concerns

- Client `/reload` smoke was not run. Harness does not prove Anniversary layout of the taller Gora desk.
- Long Store names may clip on the pairing FontString; the desk does not wrap them.
- Integrator still owns any wire after sanction. This lane does not call Net.

## Status

**DONE.** Not signed.
