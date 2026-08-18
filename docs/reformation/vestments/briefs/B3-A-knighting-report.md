# B3-A — Knighting / elevation proclamation (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §8, §19.2–19.4; Law 4; Batch 3 R7; brief `docs/reformation/vestments/briefs/B3-A-knighting.md`.

Event Mode theatrical overlay for knighting / elevation. Fixed clerical headlines only. Same overlay contract as sanction: Quiet / missing Runtime refuse, center-third panel, dim ≤ 50%, timed via `C_Timer.After`. Stock textures only. Exclusive files only. No commit. No custom media. No new sound cue names. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | B3-A pins: Quiet / missing Runtime refuse; exact `RISE, BEEF KNIGHT` / `RISE, BEEF LORD` + name; dim; center third; no close button; `Sound:Play("knighting"|"elevation")`; no `SendChatMessage`; missing name invalid; Celebrate routes to Proclaim; `C_Timer.After` hide; source does not wire Knighting. Sanction / verdict / cowardice / system / debug pins kept. |
| `addon/ChurchOfBeef/UI/Toasts.lua` | `THEATER_KINDS` + `clericalCopy` for `knighting` / `elevation`. Gold tint bar. `Celebrate` already routes theater kinds to Proclaim. |
| `docs/reformation/vestments/briefs/B3-A-knighting-report.md` | This file |
| `docs/reformation/vestments/briefs/B3-A-knighting.diff` | B3-A hunks on `UI/Toasts.lua` and `tests/test_ui.lua` against the V-B theater baseline |

Did not edit Console, Knighting Core, Sound.lua, HUD, Decree, Records, Core, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not invent a sixth cue name.

## Contract

### `Toasts:Proclaim(kind, fields)` — B3-A kinds

Kinds added: `knighting`, `elevation`. Existing `sanction` / `verdict` / `cowardice` unchanged. Unknown kinds still return `false, "invalid"`.

Refuse (`false, "quiet"`) when Runtime is missing or `Snapshot().state == "QUIET"`. No overlay show.

| Kind | Copy |
|------|------|
| `knighting` | `RISE, BEEF KNIGHT` + `name` (two lines). Missing / empty name → `false, "invalid"`. |
| `elevation` | `RISE, BEEF LORD` + `name` (two lines). Missing / empty name → `false, "invalid"`. |

No generated oratory. No `"found worthy"`. No `SendChatMessage`. Optional `DEFAULT_CHAT_FRAME:AddMessage` repeats the same clerical line.

### Overlay (same as sanction)

- Center of `UIParent`. Panel width = 1/3 of parent, or 420 if parent width is unknown.
- Dim: black at alpha **0.45** (≤ 0.5). Recorded as `theater.dimAlpha`.
- Stock only: `Interface\QuestFrame\QuestBG`, tooltip border, `WHITE8X8`. Gold tint bar for knighting / elevation.
- No close button. No `UISpecialFrames`. No permanent `OnUpdate`. Hide after 5s via `C_Timer.After`.
- Cue: `Sound:Play("knighting")` / `Sound:Play("elevation")` when Sound exists. Missing Sound still shows. Those names already exist in Sound.lua; no sixth cue.

System / debug `Push` / `Celebrate` are unchanged. Theater kinds are not queue `KINDS`.

## TDD

1. Baseline: Proclaim existed for sanction / verdict / cowardice; knighting / elevation were not theater kinds.
2. Extended `test_ui.lua` with B3-A pins (Quiet, headlines, dim, size, cue names, no chat, no Knighting wire).
3. Implemented `THEATER_KINDS` + `clericalCopy` in `Toasts.lua`.
4. Green: `lua tests/test_ui.lua` — **302 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 302 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | 302 passed, 0 failed. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive files only. Quiet refuses. System / debug and sanction / verdict / cowardice stay.
- Isolation asserts stay under `if standalone then`.
- Source has no `SendChatMessage(`, `COB.Console`, `COB.Gora`, `COB.Knighting`, or generated oratory.
- `Celebrate("knighting")` with no fields refuses via Proclaim instead of minting a system toast that says `"knighting"`.
- Theatrical surface uses the existing parchment overlay. Headlines are ALL CAPS clerical (Batch 3 R7 / Batch 4: not title-case storybook). No custom media; `GameFontNormalLarge` is the stock face.

## Concerns

- **Integrator glue is still required.** Console / Knighting do not call Proclaim. This lane tests Push/Proclaim directly, as the brief requires.
- **Headline face is stock.** Blackletter for `RISE, BEEF KNIGHT` is an asset decision (Batch 4). This lane ships no fonts.
- **B3-C may change the `PlaySound` argument** to a SoundKit id. This lane pins the cue *name* `Sound:Play` is asked (`knighting` / `elevation`), matching the V-B pin style.
- Client `/reload` smoke was not run. Stock QuestBG + dim at 45% need a human eye. Do not claim signed.

## Status

**DONE_WITH_CONCERNS.** **POLISH:CANDIDATE.** Not signed.
