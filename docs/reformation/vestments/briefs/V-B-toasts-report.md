# V-B — Sanction proclamation + verdict seals (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** CONTINUE 2026-08-18 license 4; Bible §19.2–19.4, Law 4, Law 6; Batch 2 §C / §F; brief `docs/reformation/vestments/briefs/V-B-toasts.md`.

Event Mode theatrical overlay for sanction / verdict / cowardice. Clerical copy only. Center-third panel, dim ≤ 50%, timed via `C_Timer.After`. Stock textures only. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_ui.lua` | TDD first. Standalone wrap + gated isolation. Runtime/Sound dofile for Quiet and cue pins. Proclaim pins: names, dim, panel size, exact clerical sentences, Quiet refuse, no `SendChatMessage`. Existing MainFrame / system / debug pins kept. |
| `addon/ChurchOfBeef/UI/Toasts.lua` | `Toasts:Proclaim`. Theater overlay (`ChurchOfBeefProclaim`). Quiet / missing Runtime refuse. Sound:Play when Sound exists. `HideAll` dismisses theater. `Celebrate` routes theater kinds to Proclaim. |
| `docs/reformation/vestments/briefs/V-B-toasts-report.md` | This file |
| `docs/reformation/vestments/briefs/V-B-toasts.diff` | `git diff -- addon/ChurchOfBeef/UI/Toasts.lua tests/test_ui.lua` |

Did not edit Console, Decree, Records, HUD, Sound.lua, Core, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not wire Console or Gora.

## Contract

### `Toasts:Proclaim(kind, fields)`

Kinds: `sanction`, `verdict`, `cowardice`. Unknown kinds return `false, "invalid"` and mint no copy.

Refuse (`false, "quiet"`) when Runtime is missing or `Snapshot().state == "QUIET"`. No overlay show.

| Kind | Copy |
|------|------|
| `sanction` | `A Beef Gora is Sanctioned` + `fighterA` + `VS` + `fighterB`. Optional `stipulation` printed as-is. |
| `verdict` + `ruling = "victor"` | `Victor declared: {name}.` |
| `verdict` + `ruling = "void"` | `Void.` |
| `verdict` + `ruling = "free"` | Pope `text` if non-empty, else `Free ruling.` |
| `cowardice` | `Cowardice recorded: {name}. So ruled by the Beef Pope.` |

Fields: `{ fighterA, fighterB, name, ruling, text, stipulation }`. No generated oratory. No `"Their third meeting"`. No `SendChatMessage`. Optional `DEFAULT_CHAT_FRAME:AddMessage` repeats the same clerical line.

### Overlay

- Center of `UIParent`. Panel width = 1/3 of parent, or 420 if parent width is unknown.
- Dim: black `SetColorTexture` / `WHITE8X8` at alpha **0.45** (≤ 0.5). Recorded as `theater.dimAlpha`.
- Stock only: `Interface\QuestFrame\QuestBG`, tooltip border, `WHITE8X8`. Gold tint = victor; oxblood = cowardice.
- No close button. No `UISpecialFrames`. No permanent `OnUpdate`. Hide after 5s via `C_Timer.After`.
- Cue: `Sound:Play("sanction"|"verdict"|"cowardice")` when Sound exists. Missing Sound still shows.

System / debug `Push` / `Celebrate` are unchanged. Theater kinds are not queue `KINDS`.

## TDD

1. Baseline: `Proclaim` was nil; theater kinds did not exist.
2. Extended `test_ui.lua` first (standalone wrap, isolation gated, Quiet / copy / dim / size / cue / no chat).
3. Red: `Proclaim is the theatrical entry` expected function got nil; suite then aborted on the nil call.
4. Implemented `Toasts.lua`.
5. Green: `lua tests/test_ui.lua` — **237 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_ui.lua   # 237 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_ui.lua` standalone | 237 passed, 0 failed. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive files only. Quiet refuses. System/debug and MainFrame pins stay.
- Isolation asserts stay under `if standalone then`.
- Source has no `SendChatMessage(`, `COB.Console`, `COB.Gora`, or generated H2H/sermon strings.
- `Celebrate("sanction")` with no fields now refuses via Proclaim instead of minting a system toast that says `"sanction"`.

## Concerns

- **Integrator glue is still required.** Console / Gora do not call Proclaim. This lane tests Push/Proclaim directly, as the brief requires.
- **`theater.dimAlpha` is a recorded field.** The widget stub does not persist `SetColorTexture` / `GetAlpha`, so the suite reads the value Toasts stores after applying 0.45.
- **VS is always printed** when both sanction names are present. The brief called VS optional; omitting it is not offered.
- Client `/reload` smoke was not run. Stock QuestBG + dim at 45% need a human eye against Batch 2 §C / §F. Do not claim signed.

## Status

**DONE_WITH_CONCERNS.** **POLISH:CANDIDATE.** Not signed.
