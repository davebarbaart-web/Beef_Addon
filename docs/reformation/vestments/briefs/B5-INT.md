# B5-INT — Batch 5 integrator

All five B5 reviews are Spec PASS. Do not reopen exclusive sources unless a listed suite goes red.

You may edit:
- `addon/ChurchOfBeef/ChurchOfBeef.toc` — `UI\Markers.lua` next to other UI (file exists). Interface `20506`. Only existing files.
- `tests/run.lua` — `test_markers` near test_inputs / test_hud
- `addon/ChurchOfBeef/ChurchOfBeef.lua` — InstallWire / slash / bind only
- `addon/ChurchOfBeef/UI/MainFrame.lua` — UI:Init pcall Markers:Init (and Console/Toasts/DecreeBanner/Sound/FighterCard/Inputs/ConsoleDock if not already)
- `tests/test_wire_glue.lua` — Markers spies; `/beef catchup` if you add it
- `docs/phases/two-client-smoke.md` honesty: `Inputs:Catchup` / `RequestSnapshot(target)` still needs a caller-supplied target. Do not tick walk boxes.
- `docs/REFORMATION_LOG.md` — Batch 5 verdicts only. Gates W/V stay OPEN.

## Glue

Skip while `_inspecting`. pcall missing modules.

1. After successful `KnightThisBeef` (existing Proclaim wrap): `Markers:Target(name)` and `Markers:MarkCandidate(name)` using Store human/character name. Missing name → skip marks.
2. After successful `Gora:Sanction` (existing): `Markers:MarkFighters(nameA, nameB)` from Store character names.
3. Slash `/beef catchup` (stripped word): `bindSlashInputTarget()` then `Inputs:Catchup()` if Inputs exists. Do not look up a Pope name.
4. Do not call GuildPromote. Do not invent a Pope name.

## Verify

```
lua tests/test_knighting.lua
lua tests/test_markers.lua
lua tests/test_console.lua
lua tests/test_ui.lua
lua tests/test_inputs.lua
lua tests/test_wire_glue.lua
lua tests/run.lua
```

All exit 0. Write `docs/reformation/vestments/briefs/B5-INT-report.md`. POLISH:CANDIDATE at most. No POLISH:PASS. No V1 complete. No commit.
