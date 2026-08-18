# B5-INT — Batch 5 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** CONTINUE 2026-08-18 licenses 1–4; Bible §8, §9, §10.2, §13.1, §18.1, §19.3, §20.3; Laws 4, 5, 6; Batch 5 reviews all Spec PASS.

Bootstrap glue after Batch 5. `InstallWire` only: successful `KnightThisBeef` (existing Proclaim wrap) also `Markers:Target(name)` and `Markers:MarkCandidate(name)` from Store human/character name; missing name skips marks. Successful `Gora:Sanction` (existing) also `Markers:MarkFighters(nameA, nameB)` from Store character names. Slash `/beef catchup` binds `UnitName("target")` then `Inputs:Catchup()` — no Pope-name lookup. Skip while `COB._inspecting`. TOC lists `UI\Markers.lua`. Harness lists `test_markers`. Two-client honesty: `Inputs:Catchup` / `RequestSnapshot(target)` still need a caller-supplied target; no Pope name invented. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Files written

| Path | What changed |
|------|----------------|
| `addon/ChurchOfBeef/ChurchOfBeef.toc` | Listed `UI\Markers.lua` after Inputs. Interface stays `20506`. |
| `tests/run.lua` | Listed `test_markers` next to `test_inputs`. |
| `addon/ChurchOfBeef/ChurchOfBeef.lua` | Knighting wrap also Targets / MarkCandidate. Sanction wrap also MarkFighters. Slash `catchup`. |
| `addon/ChurchOfBeef/UI/MainFrame.lua` | `UI:Init` pcall-Inits Console, Toasts, DecreeBanner, Sound, Markers when those modules exist (FighterCard / Inputs / ConsoleDock already did). |
| `tests/test_wire_glue.lua` | Markers spies; nameless skip; `/beef catchup` target bind. |
| `docs/phases/two-client-smoke.md` | Honesty: `Inputs:Catchup` / `RequestSnapshot(target)` still need a caller-supplied target. Walk boxes not ticked. |
| `docs/REFORMATION_LOG.md` | Batch 5 verdicts only. Gates W / V stay OPEN. |
| `docs/reformation/vestments/briefs/B5-INT-report.md` | This file |

Did not edit Knighting.lua, Markers.lua, Console.lua, Toasts.lua, Inputs.lua, or their exclusive suites except compose pins in `test_wire_glue.lua`. Did not invent a Pope name. Did not `GuildPromote`. Did not `SendChatMessage`. Did not tick two-client walk boxes.

## Contract

| Path | After success |
|------|----------------|
| `Knighting:KnightThisBeef` | existing `proclaim("knighting", { name })` from `Store:GetHuman`; `Markers:Target(name)` and `Markers:MarkCandidate(name)` using Store human name, else character name. Missing name → skip marks |
| `Gora:Sanction` (existing) | existing sanction Proclaim + fighter card; `Markers:MarkFighters(nameA, nameB)` from Store character names. Missing either name → skip marks |
| `/beef catchup` | `bindSlashInputTarget()` then `Inputs:Catchup()` if Inputs exists |

Missing modules / functions are `pcall`'d no-ops. Skip marks and slash furniture while `COB._inspecting`. ElevateToLord does not mark.

## TDD

1. Listed Markers in TOC and `run.lua`. Extended `tests/test_wire_glue.lua` (Target / MarkCandidate / MarkFighters spies, nameless skip, inspect / refuse / missing-module, `/beef catchup`).
2. First listed-suite run was green on the exclusive lanes (no exclusive reopen). Glue pins were written against the bootstrap contract, then the wraps and slash landed in `InstallWire` / the slash list. `UI:Init` pcall-Inits the remaining modules.
3. Isolated glue 423/0. Full harness 8776/0. No exclusive compose fix.

Pope predicate stays the existing Beefina stub and is restored. Markers / Inputs spies are restored at suite end.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_knighting.lua      # 306 passed, 0 failed
lua tests/test_markers.lua        # 251 passed, 0 failed
lua tests/test_console.lua        # 630 passed, 0 failed
lua tests/test_ui.lua             # 321 passed, 0 failed
lua tests/test_inputs.lua         # 241 passed, 0 failed
lua tests/test_wire_glue.lua      # 423 passed, 0 failed
lua tests/run.lua                 # 8776 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_knighting.lua` standalone | 306 passed, 0 failed. Exit 0. |
| `tests/test_markers.lua` standalone | 251 passed, 0 failed. Exit 0. |
| `tests/test_console.lua` standalone | 630 passed, 0 failed. Exit 0. |
| `tests/test_ui.lua` standalone | 321 passed, 0 failed. Exit 0. |
| `tests/test_inputs.lua` standalone | 241 passed, 0 failed. Exit 0. |
| `tests/test_wire_glue.lua` standalone | 423 passed, 0 failed. Exit 0. |
| `lua tests/run.lua` | 8776 passed, 0 failed. Exit 0. |

Conformance (glue): no `GuildPromote`; no `SendChatMessage`; no invented Pope name; slash does not read `Data/Popes.lua`; Quiet inspect path does not Target / MarkCandidate / MarkFighters; refused verbs do not mark; missing Markers does not break Core verbs; missing Store name skips marks; `Inputs:Catchup` / `RequestSnapshot(target)` honesty still requires a caller-supplied target.

TOC lists only existing files. `## Interface: 20506`.

## Self-review

- Exclusive B5 sources unedited. Glue lives in bootstrap + MainFrame Init + compose pins.
- Wraps attach only inside idempotent `InstallWire` (OnLogin). File load does not mark.
- Fail-closed: inspecting, missing name, missing modules, `pcall` around Target / MarkCandidate / MarkFighters / Catchup.
- No Pope name written. `#8` list stays David's.
- Two-client walk boxes were not ticked. Gate W and Gate V are not claimed closed.

## Concerns

- Exclusive lanes were not reopened. **Compose fixes: none.**
- `Markers` has no `Init`; `UI:Init` pcall is a no-op until one exists. Isolated `test_ui` still does not load Markers.
- Glue suite still loads `Data/Ranks.lua` so Knighting can `SetRank`. Isolation still omits Popes; FighterCard / Inputs / ConsoleDock / Markers are spies.
- Client `/reload` smoke and the two-client walk were not run. The harness does not prove Anniversary theater.
- `Inputs:Catchup` still needs a caller-supplied target. Do not claim Gate W or Gate V closed. Do not claim POLISH:PASS. Do not claim V1 / MVP complete.

## Status

**DONE_WITH_CONCERNS.** Batch 5 lanes signed in the log. **Gate W stays OPEN.** **Gate V stays OPEN.**
