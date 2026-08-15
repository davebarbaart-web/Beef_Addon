# Phase 6 Lane J — Fight HUD leftover

**Status:** DONE

**Cited:** Ten Laws 6, 8, 10; Bible §10.7, §19.2; Appendix A item 1 (`docs/validation/A01-live-health.md`, Result **NOT RUN**, owner David); `.cursor/rules/gora-sanction.mdc` (Fight HUD); existing `addon/ChurchOfBeef/UI/Hud.lua` and `tests/test_hud.lua`. OPEN_QUESTIONS #2 unread — not resolved. P4-F signed the surface. This lane is a leftover check, not a rebuild.

The pair contract already holds inside `Hud.lua`. **No Lua edits.** `tests/test_hud.lua` was not edited. Console, Gora, Store, Sender, TOC, bootstrap, `tests/run.lua`, `OPEN_QUESTIONS.md`, A01, and `REFORMATION_LOG.md` were not edited. No fake Store Gora rows. No invented characters. No live-health workaround. No commit.

## Files written

| Path | What changed |
|------|----------------|
| `docs/reformation/phase-6/reports/P6-J-hud.md` | This file |

`addon/ChurchOfBeef/UI/Hud.lua` and `tests/test_hud.lua` were read only.

## Contract (already intended — still true)

| Rule | In `Hud.lua` |
|------|----------------|
| `Hud.MODE` Event | `"Event"` |
| Show when Runtime is **not QUIET** and `Gora:GetSanctioned()` is a live pair | `Refresh` = `eventLive() and livePair()` |
| Hide in QUIET | `eventLive()` is `Snapshot().state ~= "QUIET"` |
| Hide when the pair clears | `livePair()` requires both `fighterA` and `fighterB`; `paintHidden` otherwise |
| No live health | `GetView().health` is always `nil`. No `UnitHealth`, nameplate, or combat-log read. No `StatusBar`. |
| No favor bar | `GetView().favor` is always `nil`. No INPUT. |
| No invented characters | Names, class, level, W/L come from `Store:GetCharacter`. Missing row paints empty name, not a demo fighter. |
| Top-center default, movable | `TOP` / `UIParent` / `TOP` / `0` / `-24`. Movable, clamped. Drag writes `ChurchOfBeefDB.ui.hud` when that table exists. |

`Gora:GetSanctioned()` returns a copy of the Pope-sanctioned pair (or `nil`). `_Expire` clears it in QUIET. A ruling (`DeclareVictor` / `CowardiceRecorded` / `Void` / `FreeRuling`) clears it. The HUD does not sanction, invent a pair, or write Store.

`fighterFrom` does not mint Store rows. This lane did not call `CreateCharacter` / `RecordGoraResult` outside the existing isolated suite.

## Pair exposure (read only)

- **Gora:** `Sanction` writes the live pair. `GetSanctioned` is the HUD's only pair source.
- **Console:** `Console:Sanction` calls `Gora:Sanction`, then `after` → `Console:Refresh`. That paints the **desk** (runtime / presence / petitions). It does **not** call `Hud:Refresh`.
- **Shell:** `MainFrame` `UI:Init` calls `Hud:Init` (Refresh at login; QUIET → hidden). That is not a sanction paint.

## Leftover (P6-I — not this lane)

**Console must `Hud:Refresh` after Sanction.** P6-I owns that exclusive Console edit. Same wire is needed after a ruling and after `EndEvent` so the card hides when the pair clears or the machine returns to QUIET. Do not invent a sanctioned pair in Store so the HUD can demo. Do not edit Console here.

`#8` still fail-closes `Sender:IsRegisteredPope`. Console rituals still refuse on a live client until that is licensed. Wiring `Hud:Refresh` does not make a Gathering.

## A01 is not a pass

Appendix A item 1 Result is **NOT RUN** (owner David). The coded no-health HUD is the Bible §10.7 defined fallback surface. **It is not an A01 pass.** OPEN_QUESTIONS #2 unread — do not resolve. Do not invent a health hack, nameplate scrape, or combat-log HP estimator.

## Verification

- Isolated suite (`wow_ui_stub` + Common + Ranks + Store + Runtime + Gora + Hud): **226 passed, 0 failed**.
- Lua 5.1. `lua tests/test_hud.lua` exits 0.
- Isolation asserts remain in `if standalone then`.
- Source still has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `C_NamePlate`, `PlaySound`, `StatusBar`, or `Toasts`.
- This lane did not add Store Gora rows, fake characters, or live health.

## Other leftovers (not fixed)

- Favor split: Bible-named; INPUT unspecified. Bar stays omitted.
- Defense count: Bible-named; Store still strips `defenses` / `defenseCount` (`#9`). Not painted.
- Bible §10.7 “persists through the verdict beat”: P4-F + Gora clear the pair on a ruling, so the card exits at ratification. Do not reopen as a Hud.lua defect.
- Congregation paint needs a live pair on that client. Do not invent Net paint here.
- Sound callers are a different leftover.

## Refused to invent

Live health; A01 Result; OPEN_QUESTIONS #2 answer; favor INPUT; defense increment; fake Store Gora rows; demo characters; Console `Hud:Refresh` (P6-I); `Data/Popes.lua` / `#8`; V1 / MVP complete; `POLISH:PASS`.

## Concerns

- The card will not appear in-game at Sanction until P6-I calls `Hud:Refresh`. `Hud:Init` at login only proves Quiet hide.
- `POLISH:CANDIDATE` only (already claimed in P4-F). This leftover check did not run `/reload` smoke and does not upgrade that claim.
- A human Gathering (Bible §22.3) was not run. Do not claim V1 / MVP complete.
