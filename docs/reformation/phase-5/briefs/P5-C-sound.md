# Phase 5 Lane C — Event Mode sound cues

Read: Ten Laws 6; Bible §19.4; `.cursor/rules/quiet-event-modes.mdc` (Sound). Gate 4 is closed. Phase 4 leftover: no sound cues.

## Exclusive files

- `addon/ChurchOfBeef/UI/Sound.lua` (create)
- `tests/test_sound.lua` (create)
- Report: `docs/reformation/phase-5/reports/P5-C-sound.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, Runtime, Console, HUD, Gora, Knighting, Minimap, Toasts, MainFrame, Net. Integrator lists the file after it exists. Do not add media files to the addon.

## Mission

Test-first. Isolated suite with Common + Runtime + Sound. Wrap isolation asserts in `if standalone then`.

**Mode:** Event Mode only. Quiet Mode is silent, absolutely.

Bible §19.4 MVP cue names **only**: Sanction bell, Verdict, Elevation, Knighting, Cowardice Recorded. Canonization seal is later — do not add it.

- `Play(name)` allow-list (exact keys): `sanction`, `verdict`, `elevation`, `knighting`, `cowardice`. Anything else returns `nil, reason` and plays nothing.
- Play only when `Runtime:Snapshot().state` is `ASSEMBLY`, `RITE`, or `CONSEQUENCE`. In `QUIET`, or when Runtime is missing, no-op (`nil, reason`). Do not invent a sixth state check.
- Do not play on file load or `Init`. This module is a verb, not a loop.
- Do not invent `.ogg` / `.mp3` addon files. If `PlaySound` (or the client's equivalent) exists, call it; if it does not, succeed as a recorded cue in tests and no-op in the client. Missing sound must not error.
- No ambient audio, UI clicks-and-whooshes, notification pips, or login jingle.
- Do not wire Console / Gora / Knighting to call `Play` in this lane. Callers are a later exclusive edit.

## Do not invent

Extra cue names, Quiet sound, `#8`, SUMMON chime, favor sting, Grant/standing, narration.

## Do not git commit.
