# B4-D — Console petition H2H + confession inbox (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.2, §10.5, §18.1–18.2, §9; Law 10 / §19.3; Batch 3 critique (petitioner H2H; SKIP/Dismiss is furniture); brief `docs/reformation/vestments/briefs/B4-D-console-inbox.md`.

Director Console stays stock-pragmatic. Named petitions append a mute numeric H2H (`1-0`) when Store has a petitioner `headToHeads` row for `namedOpponentId`. Confession inbox is a small stock list on the Pope desk: `GetConfessions()` copies `Confession:GetQueue()` when the module exists, else `{}`. Paint is name + text here only. Dismiss is `stockButton` / `UIPanelButtonTemplate`, not `ritual`. `SaveNote` stays nil. No WHISPER ALL. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. GetConfessions empty / copies / paint; named petition H2H `1-0`; unnamed and no-history stay names only; Dismiss is stock furniture and still reaches Gora; SaveNote nil; source has no `WHISPER ALL`; isolation wrap kept and gained Confession. |
| `addon/ChurchOfBeef/UI/Console.lua` | `petitionLine` appends mute H2H. `GetConfessions` + stock Confession list. Dismiss created with `stockButton`, not `ritual`. Refresh paints the inbox. Proposed Bout, Sanction, favor, Post Decree, FREE RULING, MARK THIS MOMENT kept. |
| `docs/reformation/vestments/briefs/B4-D-console-inbox-report.md` | This file |
| `docs/reformation/vestments/briefs/B4-D-console-inbox.diff` | B4-D-only unified diff of the exclusive files vs the pre-lane baseline |

Did not edit Gora, Confession.lua, BeefNet, Hud, Toasts, TOC, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

| Method | Role |
|--------|------|
| `GetConfessions()` | Fresh copies of `Confession:GetQueue()` when that module exists; else `{}`. Mutating a copy does not rewrite the queue. |
| `petitionLine` (display) | Store names. Named opponent + petitioner H2H row → append `wins-losses`. No named opponent → name only. No matching row → names only. No `meeting` / `demanded` / `odds`. |
| `Dismiss` | `UIPanelButtonTemplate` via `stockButton`. Not in `RitualButtons`. Label `Dismiss`. Still `Gora:Dismiss`. |
| `SaveNote` | nil |

### Desk

- Confession header + 70px stock scroll on the left column under Knighting.
- Dismiss remains next to SANCTION; same size; stock furniture, not a ritual plate.
- No WHISPER ALL. No SUMMON. No Notebook persist.

## TDD

1. Extended `test_console.lua` first (API, isolation, H2H paint, inbox copies/paint/no theater leak, stock Dismiss, SaveNote, source grep). Isolation stayed under `if standalone then`.
2. Red: `GetConfessions is a console readout` expected function got nil; then `GetConfessions` called as nil.
3. Implemented `Console.lua`.
4. Green: `lua tests/test_console.lua` — **499 passed, 0 failed**.

Pope predicate uses the suite’s existing `Sender.IsRegisteredPope = function() return true end` wrap. No Pope name. No `Data/Popes.lua`. Confession is stubbed; this suite does not load `Confession.lua`.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 499 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | 499 passed, 0 failed. Lua 5.1.5. Exit 0. |

**Isolated count:** 17 nil-module pins inside `if standalone then` (added Confession). Six loaded-module pins stay outside the wrap. Standalone suite: **499 passed**.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Confession text is painted on `frame.ConfessionList` and is not sent to Toasts, Hud, Decree, or Net.
- Getters return copies. Expected failures stay `nil, err`.
- Dismiss is furniture: enabled when the Pope predicate is false; `Console:Dismiss` still refuse-closed.
- `Console.SaveNote` remains nil. Source has no `WHISPER ALL`.
- Isolation asserts remain behind `if standalone then`.
- Existing Proposed Bout, favor, Post Decree, FREE RULING, and MARK THIS MOMENT pins stayed green.

## Concerns

- Client `/reload` smoke was not run. The 70px left-column inbox may clip long confession text on Anniversary.
- `Confession.lua` is not loaded here. Paint is proven against a stubbed `GetQueue`. Integrator still wires B4-C into TOC / bootstrap / `run.lua`.
- H2H reads the **petitioner** Store row only. A named callout with history only on the opponent paints names, no score.
- A Store H2H row with no W/L change (Void) would paint `0-0`.
- Dismiss no longer rides `applyGate`. Non-Pope clicks still refuse in `Console:Dismiss`; the button looks live. That is the furniture brief.

## Status

**DONE_WITH_CONCERNS.** Not signed.
