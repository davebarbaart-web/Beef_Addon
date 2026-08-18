# B8-D — HUD mute defense count (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.7, §19.3; Law 8, Law 10; brief `docs/reformation/vestments/briefs/B8-D-hud-defenses.md`. W-F favor, V-D dress, and B4-F name fields kept. OPEN_QUESTIONS #9 is the Store derive (B8-A); this lane only paints. A01 still NOT RUN.

Event Mode Fight HUD. `Store:CountDefenses(id)` paints as a **mute integer** per fighter (`defenseA` / `defenseB`). Hide when the count is 0 or the method is missing. No odds copy. No `UnitHealth`. Favor W-F intact: congregation STATE-off still omits the split. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | TDD first. Source names `CountDefenses` / `defenseA` / `defenseB`. Bans `defenses of` / `of the realm`. Fresh pair hides. Stub 3 visible / 0 hides / method missing hides. `health` nil. STATE-off still omits FAVOR. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Hud.lua` | `defenseCount` reads `Store:CountDefenses` when present. Mute `GameFontNormal` integer on the record row. Hide when 0 or missing. W-F favor / PickFavor / `health` nil unchanged. No new StatusBar. |
| `docs/reformation/vestments/briefs/B8-D-hud-defenses-report.md` | This file |
| `docs/reformation/vestments/briefs/B8-D-hud-defenses.diff` | B8-D-only unified diff of the exclusive files vs the pre-lane baseline |

Did not edit Store, FighterCard, Records, Gora, Console, TOC, bootstrap, `run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

## Contract

### Defense count

- Source: `COB.Store:CountDefenses(characterId)` when the method exists.
- Paint: arabic integer only (`"3"`). Stock `GameFontNormal`. Muted ink. Not class-colored.
- Hide when the method is missing, the return is not a number, or the floor is ≤ 0.
- Per-fighter on `GetView().fighterA.defenses` / `fighterB.defenses`. Pair-level `view.defenses` stays nil.
- Same row as the W/L record. Height budget unchanged (no extra row).

### W-F favor (unchanged)

| Client | Fill |
|--------|------|
| Hidden / no live pair | `favor == nil`, `health == nil` |
| Local Pope | `Gora:GetFavorSplit()` while a pair is live, including zeros |
| Congregation | last `SetBroadcastFavor({ a, b })` only |

`PickFavor` / plate click / GetView copy stay as W-F left them. STATE-off still omits the FAVOR label and both halves. No `UnitHealth`.

## TDD

1. Extended `test_hud.lua` first (source greps, hidden slots, stub 3 / zero / missing, health nil, STATE-off omit, isolation wrap).
2. Implemented `defenseCount` + mute `defenseA` / `defenseB` + Hide when 0 or missing.
3. Green: `lua tests/test_hud.lua` — **421 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua   # 421 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_hud.lua` standalone | **421 passed, 0 failed.** Lua 5.1. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**421 passed, 0 failed.**

## Self-review

- Exclusive implementation files only. Quiet still hides. Health pins and nameplate-scrape greps stay.
- Source has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `PlaySound`, `Toasts`, `Media\\`, `.tga`, `.blp`, or `.ttf`.
- Source has no `defenses of` / `of the realm`. Painted text is the integer.
- Pope split still comes from Gora. Congregation still comes from `SetBroadcastFavor`. `PickFavor` and plate clicks are unchanged.
- `countStatusBars` stays 2. `health` stays nil. `healthReads` stay 0.
- Isolation asserts stay under `if standalone then`.

## Concerns

- **No client smoke.** The mute integer sits on the same compact row as level + W/L. A two-digit count may clip on the 420-wide card. **POLISH:CANDIDATE** only.
- **B8-A has not landed in this checkout.** Until `Store:CountDefenses` exists, both widgets stay hidden (method missing). The suite stubs the method.
- **A01 still NOT RUN.** `health` is nil. Mute rails stay textures. No `UnitHealth`.
- **No label.** Brief asked a mute integer, not "DEF" / roman / "defenses of the realm." Stream distance may read the glyph as a stray number next to W/L.
- Integrator still lists the files in the TOC and `run.lua` (already listed).

## Status

**DONE_WITH_CONCERNS.** Isolated **421 / 0**. Not signed. **POLISH:CANDIDATE.**
