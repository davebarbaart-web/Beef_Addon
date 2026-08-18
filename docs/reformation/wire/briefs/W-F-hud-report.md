# W-F — HUD: favor split bar + congregation plate pick (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** CONTINUE 2026-08-18 license 2; Bible §10.6, §10.7; Batch 2 critique §D (favor readability only); brief `docs/reformation/wire/briefs/W-F-hud.md`.

Event Mode Fight HUD now paints a stock favor split and lets the congregation click a fighter plate to whisper a pick. Congregation fill is broadcast-only. Local Pope (stub `Sender:IsRegisteredPope`) fills from `Gora:GetFavorSplit()` while a pair is live. `health` stays nil. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | TDD first. Relaxed the old “no StatusBar / view never carries favor” pins. Pope stub + Gora split, congregation broadcast 66/34, toggle-off ignores Gora, PickFavor / plate-click, missing target/character. Isolation stays under `if standalone then`. |
| `addon/ChurchOfBeef/UI/Hud.lua` | `SetBroadcastFavor`, `SetFavorTarget`, `SetLocalCharacterId`, `PickFavor`. Stock StatusBar halves + FAVOR + percents. Plate `Button` overlays. `ResetForTests` clears broadcast + target + local id. |
| `docs/reformation/wire/briefs/W-F-hud-report.md` | This file |
| `docs/reformation/wire/briefs/W-F-hud.diff` | `git diff -- addon/ChurchOfBeef/UI/Hud.lua tests/test_hud.lua` |

Did not edit Gora, Store, Codec, BeefNet, Console, TOC, bootstrap, Sender, Runtime, `tests/run.lua`, OPEN_QUESTIONS, REFORMATION_LOG, or `Data/Popes.lua`. Did not invent or look up a Pope name.

## Contract

### `GetView().favor`

| Client | Fill |
|--------|------|
| Hidden / no live pair | `nil` |
| Local Pope (`Sender:IsRegisteredPope` of the local player) | `Gora:GetFavorSplit()` while a pair is live, including `{ a = 0, b = 0 }` |
| Congregation (predicate missing or false) | last `SetBroadcastFavor({ a, b })` only. `nil` hides the bar. Does not read Gora. |

Shape: `{ a, b, pctA, pctB }` integers. `a + b == 0` → `0/0`. Else `pctA = floor(100 * a / (a + b))`, `pctB = 100 - pctA`. Pinned **66/34** for `{ 2, 1 }`. `GetView` is still a copy. `health` stays nil.

### Split bar

- Stock `StatusBar` pair, `Interface\TargetingFrame\UI-StatusBar`.
- `FAVOR` (`GameFontHighlightSmall`) + `"N%"` at each end.
- Halves tinted with that fighter’s `nameColor`, else muted ink.
- Hidden when `favor` is nil. No `OnUpdate`. No `PlaySound`. No V-D dress.

### Congregation pick

| Method | Role |
|--------|------|
| `SetBroadcastFavor(favor or nil)` | Store `{ a, b }` or clear. Invalid table clears. |
| `SetFavorTarget(target)` | Whisper dest string, or nil. |
| `SetLocalCharacterId(characterId)` | Picker store int, or nil. |
| `PickFavor(pickId, target, characterId)` | `Net:SendFavor({ characterId, pick }, target)` when Net offers it. Missing target → `nil, "no target"`. Missing characterId → `nil, "no character"`. Missing Net → `nil, "no net"`. |

Plate click (`pickA` / `pickB`) calls `PickFavor` only when both target and local id are set. Otherwise no-op, no error chat. Programmatic `PickFavor` still returns the error string. No `Hud.SendFavor` alias. No `Hud.Favor` economy table.

## TDD

1. Extended `test_hud.lua` first (APIs, StatusBar allowed, Pope stub, congregation broadcast, PickFavor, plate click). Isolation unchanged.
2. Red: `SetBroadcastFavor` / `SetFavorTarget` / `SetLocalCharacterId` / `PickFavor` nil; source had no `StatusBar`; `Init` aborted on missing `favorLabel`.
3. Implemented `Hud.lua`.
4. Green: `lua tests/test_hud.lua` — **320 passed, 0 failed**.

Pope predicate is a boolean stub (`IsRegisteredPope` returns true/false). No Pope name. Sender was not `dofile`d. Net is stubbed `SendFavor` only.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua   # 320 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_hud.lua` standalone | 320 passed, 0 failed. Lua 5.1. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive files only. Quiet still hides. Health pins and nameplate-scrape greps stay.
- Congregation path never calls `GetFavorSplit`. Pope path never uses broadcast.
- Percents are floor-then-remainder so they always sum to 100.
- `Hud.Favor` and `Hud.SendFavor` remain nil.
- Local player for the Pope predicate is `Group.PlayerName()` / `UnitName("player")` — the same Console pattern. Not a Pope-name lookup.

## Concerns

- **Integrator glue is still required.** Congregation bar and plate send do nothing until something (W-INT / bootstrap) calls `SetBroadcastFavor` from STATE and `SetFavorTarget` / `SetLocalCharacterId`. This lane does not invent that wire.
- **`SetBroadcastFavor` does not Refresh.** `GetView` updates on the next `Refresh` / `paintShown`. Tests Refresh after set.
- **Plate overlays vs drag.** `pickA` / `pickB` cover the name plates. In-game, left-drag on those halves may not move the HUD. Not smoked.
- **`PickFavor` extra error `"no net"`** when `Net.SendFavor` is missing. Brief did not name that string; missing target/character still match the brief.
- Client `/reload` + two-client favor whisper were not run. Do not claim signed.

## Status

**DONE_WITH_CONCERNS.** Not signed.
