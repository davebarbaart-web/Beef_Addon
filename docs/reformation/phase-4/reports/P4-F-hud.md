# Phase 4 Lane F — Fight HUD (no live health)

**Status:** DONE

**Cited:** Ten Laws 6, 8, 10; Bible §10.7, §19.2; `.cursor/rules/gora-sanction.mdc` (HUD); `.cursor/rules/ui-juice-standards.mdc`; `.cursor/rules/quiet-event-modes.mdc`; brief `docs/reformation/phase-4/briefs/P4-F-hud.md`. Appendix A #1 remains open — defined fallback: everything except live health. Lanes C and D are signed.

Event Mode spectator card only. Show when Runtime is not QUIET **and** `Gora:GetSanctioned()` is a live pair. Hide in Quiet, and when the pair clears. Top-center default, movable. Both fighters: name (class color on the name only), level, Church title, Store W/L. Head-to-head line when Store has history. No live health. No favor bar (INPUT unspecified). No sound. No toasts. No center-screen alert pulse. TOC / bootstrap / `tests/run.lua` / MainFrame / Console / Toasts / Gora / Store / Net / `OPEN_QUESTIONS.md` not edited. No commit.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | Created first. Isolated suite: wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Hud. Standalone wrap. Isolation asserts in `if standalone then`. |
| `addon/ChurchOfBeef/UI/Hud.lua` | Created after the suite. `COB.Hud` Event Mode surface. |
| `docs/reformation/phase-4/reports/P4-F-hud.md` | This file |

`Data/Ranks.lua` is dofiled in the suite so Church titles resolve through `Ranks.Title`. It was not edited.

## Mode and visibility

**Mode:** Event Mode (`Hud.MODE = "Event"`). Not Quiet chrome. Not a WA pulse.

| Runtime + pair | HUD |
|----------------|-----|
| QUIET | Hidden |
| ASSEMBLY / RITE / CONSEQUENCE, no sanctioned pair | Hidden |
| Not QUIET + `GetSanctioned()` live pair | Shown |
| Pair cleared (Pope ruling) | Hidden, even if still CONSEQUENCE |
| `EndEvent` → QUIET | Hidden (pair expires) |
| `awaitingPope` with a live pair | Shown (Event Mode degraded, not Quiet) |
| Knighting rite with a live pair | Shown (keys off pair + not QUIET, not rite type) |

Appears at sanction. Gone when the pair clears or the machine returns to QUIET. `Refresh` paints; no permanent `OnUpdate`. Integrator wires `Refresh` after Core changes — this lane does not edit bootstrap.

## Surface

Insecure `CreateFrame` under `UIParent`, name `ChurchOfBeefHud`. Top-center (`TOP` / `TOP` / `0` / `-24`). Movable, clamped. Drag writes `ChurchOfBeefDB.ui.hud` when that table exists (plain point fields, no frame reference). Invalid saved point falls back to top-center. `DB.lua` was not edited.

Compact two-fighter card. Theatrical ink (charcoal panel when `BackdropTemplate` is present; stock fonts otherwise). Missing backdrop methods do not fail load. Class color on **names** only via `RAID_CLASS_COLORS`. Level, title, and W/L stay parchment/muted. Unlinked characters show no title — no invented Fresh Beef. `Ranks.Title` `"Unknown"` is omitted.

Head-to-head is the Store record (`wins-losses` from fighter A) when `fights > 0`. No “meeting” narration. No odds copy.

## API

| Method | Role |
|--------|------|
| `Init()` | Builds the frame once, restores a saved point, `Refresh`es. Idempotent. |
| `Refresh()` | Show/hide and paint from Runtime + Gora + Store. Returns a `GetView` copy. |
| `IsShown()` | Widget visibility. |
| `GetView()` | Copy: `shown`, `mode`, `fighterA` / `fighterB` (name, level, title, W/L, `nameColor`), `headToHead` or nil. `health` and `favor` are always nil. |
| `ResetForTests()` | No-op unless `COB._IN_TEST`. |

Display only. No Sanction, no ruling, no Store write. Getters return copies.

## Verification

- Isolated suite (`wow_ui_stub` + `Core/Common.lua` + `Data/Ranks.lua` + `Core/Store.lua` + `Core/Runtime.lua` + `Core/Gora.lua` + `UI/Hud.lua`): **226 passed, 0 failed**.
- Lua 5.1.5. `lua tests/test_hud.lua` exits 0.
- Source has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `PlaySound`, `StatusBar`, `Toasts`, or `SendChatMessage`.
- No `dofile` of BeefNet / MainFrame / Console / Toasts / DB / Officer / Archive / Recognition / Sender / Codec / Snapshot / Knighting / Minimap / TOC / bootstrap / `tests/run.lua`.

This lane did not edit `tests/run.lua`. The runner will report `test_hud` as unlisted until the integrator adds it.

## Leftovers (other lanes — not fixed)

- **Integrator:** add `UI/Hud.lua` to `ChurchOfBeef.toc` (file exists now). Add `test_hud` to `tests/run.lua`. Call `Hud:Refresh` after sanction / ruling / runtime transitions. The file will not load in the client until it is on the TOC.
- **Appendix A #1 / OPEN_QUESTIONS #2:** live health stays out. No nameplate or combat-log workaround.
- **Favor / INPUT:** Bible-named split bar omitted. Do not invent a channel.
- **Defense count:** Store still strips `defenses` / `defenseCount` (`#9`). Not painted.
- **Sound:** Phase 5. No cue this lane.
- **Mute fighter cards / Director Console / Records Book / Decree** are other surfaces.

## Concerns

- Bible §10.7 says the HUD persists through the verdict beat. This lane follows the brief: hide when `GetSanctioned()` is nil. Lane C clears the pair on a ruling, so the card exits at ratification, not at `EndEvent`.
- `POLISH:CANDIDATE` only. No in-game `/reload` smoke — TOC was not edited. A human Gathering (Bible §22.3) was not run.
- `OPEN_QUESTIONS.md` was not edited. Do not claim V1 / MVP complete.
