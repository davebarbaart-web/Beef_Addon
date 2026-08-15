# Phase 5 Lane C — Event Mode sound cues

**Status:** DONE

**Cited:** Ten Laws 6, 10; Bible §19.4; `.cursor/rules/quiet-event-modes.mdc` (Sound); `.cursor/rules/lua-cob-modules.mdc`; brief `docs/reformation/phase-5/briefs/P5-C-sound.md`. Gate 4 leftover: no sound cues. Appendix A #8 (PlaySoundFile / custom assets) remains open.

Event Mode verb only. Quiet Mode is silent, absolutely. Five MVP cue names. No addon media. No Canonization seal. No load/Init play. Callers are a later exclusive edit. TOC / bootstrap / `tests/run.lua` / Runtime / Console / HUD / Gora / Knighting / Minimap / Toasts / MainFrame / Net / `OPEN_QUESTIONS.md` not edited. No commit.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_sound.lua` | Created first. Isolated suite: Common + Runtime + Sound. Standalone wrap. Isolation asserts in `if standalone then`. |
| `addon/ChurchOfBeef/UI/Sound.lua` | Created after the suite. `COB.Sound` Event Mode verb. |
| `docs/reformation/phase-5/reports/P5-C-sound.md` | This file |

No `.ogg` / `.mp3` / other media files were added.

## Mode and gate

**Mode:** Event Mode (`Sound.MODE = "Event"`). Not Quiet chrome. Not a loop.

| Runtime | `Play` |
|---------|--------|
| Missing `COB.Runtime` / no `Snapshot` | No-op (`nil, reason`) |
| `QUIET` | No-op (`nil, reason`) |
| `ASSEMBLY` / `RITE` / `CONSEQUENCE` | Allow-list cue records and, if present, `pcall(PlaySound, name)` |
| `awaitingPope` | Still plays — Event Mode degraded, not a sixth state |

Unknown names (including `canonization`, `Sanction`, `summon`, `favor`, `grant`, `standing`, clicks, login, ambient) return `nil, reason` and call nothing.

## API

| Method | Role |
|--------|------|
| `Play(name)` | Allow-list only: `sanction`, `verdict`, `elevation`, `knighting`, `cowardice`. Success returns the cue name (recorded cue). Failures are `nil, reason`. |
| `ResetForTests()` | No-op unless `COB._IN_TEST`. |

No `Init`. File load does not play. If `PlaySound` is missing, success is still the recorded cue name and the client no-ops. If `PlaySound` errors (missing kit), `pcall` swallows it. `PlaySoundFile` is never called.

## Verification

- Isolated suite (`Core/Common.lua` + `Core/Runtime.lua` + `UI/Sound.lua`): **177 passed, 0 failed**.
- Isolation asserts (standalone only): **19**.
- Lua 5.1.5. `lua tests/test_sound.lua` exits 0.
- Source has no `.ogg`, `.mp3`, `PlaySoundFile`, `PlaySoundKitID`, `SOUNDKIT`, `RAID_WARNING`, `READY_CHECK`, `CreateFrame`, `SendChatMessage`, `SendAddonMessage`, or caller wires (`COB.Console` / `COB.Gora` / `COB.Knighting` / `COB.Hud`).
- No `dofile` of BeefNet / MainFrame / Console / HUD / Gora / Knighting / Minimap / Toasts / DB / Store / Officer / Archive / Recognition / Sender / Codec / Snapshot / Decree / TOC / bootstrap / `tests/run.lua`.

This lane did not edit `tests/run.lua`. The runner will report `test_sound` as unlisted until the integrator adds it.

## Leftovers (other lanes — not fixed)

- **Integrator:** add `UI/Sound.lua` to `ChurchOfBeef.toc` (file exists now). Add `test_sound` to `tests/run.lua`. The file will not load in the client until it is on the TOC.
- **Callers:** Console / Gora / Knighting / HUD do not call `Play`. Later exclusive edit.
- **Appendix A #8:** custom `PlaySoundFile` assets stay out. No kit map.
- **Canonization seal** is later (§19.4). Not this phase.
- **Director Console / Fight HUD / Decree / Records Book** are other surfaces.

## Refused to invent

Extra cue names; Quiet sound; `#8`; SUMMON chime; favor sting; Grant / standing; narration; addon `.ogg` / `.mp3`; `SOUNDKIT` ids (including RAID_WARNING / READY_CHECK); ambient / UI click / login jingle; a sixth runtime state check; `holdSeconds`; auto-play on load, `Init`, or Runtime transitions; PlaySound channel / Master; caller wiring.

## Concerns

- `PlaySound` is called with the cue name string so tests can record it. Custom assets are unvalidated (Appendix A #8); `pcall` keeps a missing kit from erroring. That is a stub, not a branded bell.
- `POLISH:CANDIDATE` only. No in-game `/reload` smoke — TOC was not edited. A human Gathering (Bible §22.3) was not run.
- `OPEN_QUESTIONS.md` was not edited. Do not claim V1 / MVP complete.
