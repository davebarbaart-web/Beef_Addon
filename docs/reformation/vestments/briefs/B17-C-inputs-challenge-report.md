# B17-C — Inputs Petition may name the current target (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.2 / §18.5 (a petition may name a desired opponent; congregation input never triggers public theater); Law 5 / §13.1 (whisper dest stays injected `inputTarget`); brief `docs/reformation/vestments/briefs/B17-C-inputs-challenge.md`. Anniversary `UnitName(unit)` exists (`classic_anniversary`, 20506). No Pope-name lookup. No `TargetUnit`. No `PlaySound`. No `Gora:Petition`. WIDTH 328 / HEIGHT 72 stay. TitleBar persist `ui.inputs` stays. ESC ClearFocus and `SetMultiLine(true)` stay. Not on `UISpecialFrames`.

`Inputs:Petition` still requires Event + whisper dest + local character id. Ready-to-send is unchanged. Both `UnitName` reads are pcalled. If `UnitName("target")` is a non-empty string and `COB.Names.Same` is false vs `inputTarget` and false vs `UnitName("player")`, `SendPetition` fields include `opponent`. Otherwise the fields table is `{ characterId = localCharacterId }` only. Missing `UnitName` omits opponent. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 505 passed, 0 failed (`lua tests/test_inputs.lua`). **24** isolation pins under the first `if standalone then`; **6** re-pins in `runB14B()`; **6** B15-A re-pins and **6** B16-B re-pins in `runB15A()`; **6** re-pins in `runB17C()`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_inputs.lua` | TDD first. Nested `runB17C()`. Existing unset-target spy stays `fields.opponent == nil`. Stub `UnitName("target")` → `"Chuckroast"`, dest `"Host"`, player `"Beefina"` → `opponent = "Chuckroast"` and `target = "Host"`. Names-same Host / Host-realm / player / player-realm omit. Missing / throwing / empty `UnitName` omit. Quiet refuse. HEIGHT 72, TitleBar, ESC ClearFocus, not `UISpecialFrames`, isolation wrap stay. |
| `addon/ChurchOfBeef/UI/Inputs.lua` | `petitionOpponent()` type-guards `UnitName`, pcalls `"target"` and `"player"`, compares with `COB.Names.Same`. `Inputs:Petition` adds `opponent` only when that helper returns a name. |
| `docs/reformation/vestments/briefs/B17-C-inputs-challenge-report.md` | This file |
| `docs/reformation/vestments/briefs/B17-C-inputs-challenge.diff` | B17-C-only unified diff of the exclusive implementation files vs the pre-lane baseline |

Did not edit Net, Codec, Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not look up a Pope name. Did not call `TargetUnit`. Did not add `PlaySound`. Did not call `Gora:Petition`. Did not commit.

The exclusive pair already existed. The brief diff is the B17-C-only delta vs the pre-lane text.

## Contract

```lua
local function petitionOpponent()
  -- missing UnitName → nil
  -- pcall UnitName("target") and UnitName("player")
  -- non-empty target name and not Names.Same vs inputTarget / player → name
end

function Inputs:Petition()
  -- readyToSend unchanged (Event, target, local character id)
  -- fields = { characterId }; opponent added only when petitionOpponent returns
  -- SendPetition(fields, inputTarget)
end
```

| Target name | Fields |
|-------------|--------|
| Stub `UnitName("target")` nil | `{ characterId }` only |
| `"Chuckroast"` vs dest `"Host"` / player `"Beefina"` | `{ characterId, opponent = "Chuckroast" }` |
| Names-same dest (`Host`, `Host-Whitemane`) | `{ characterId }` only |
| Names-same player (`Beefina`, `Beefina-Whitemane`) | `{ characterId }` only |
| Missing / throwing / empty `UnitName` | `{ characterId }` only |

Keep:

- Whisper dest is still `inputTarget` (injected). No Pope-name lookup.
- WIDTH 328 / HEIGHT 72. TitleBar drag persist `ChurchOfBeefDB.ui.inputs`.
- ESC `ClearFocus` only. Not on `UISpecialFrames`.
- No `TargetUnit`. No `PlaySound`. No `Gora:Petition`.
- Isolation wrap stays (wow_ui_stub + Common + Runtime + Inputs).

## TDD

1. Extended `tests/test_inputs.lua` first (`runB17C()`: source pcall / `Names.Same` pins; Chuckroast named; Host / player Same omit; missing `UnitName` omit; Quiet / TitleBar / ESC / isolation stay). Isolation wrap untouched.
2. Red: `lua tests/test_inputs.lua` — **500 passed, 5 failed**.
3. `petitionOpponent` + `Inputs:Petition` fields table. No chrome change.
4. Green: `lua tests/test_inputs.lua` — **505 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_inputs.lua   # 505 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_inputs.lua` standalone | **505 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 24 original isolation asserts stay under `if standalone then`. `runB14B()` / `runB15A()` / `runB17C()` re-pin Console / Popes / Sender / Sound / Hud / slash.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Net / Codec / Console / glue / TOC were not edited.
- Both `UnitName` reads are pcalled. Missing `UnitName` fail-closes (omit opponent). Empty string omits.
- `Names.Same` folds realm / case. Dest Host and local player Beefina never become `opponent`.
- Whisper dest stays `inputTarget`. No Pope list. No `TargetUnit`. No `Gora:Petition`. No `PlaySound`.
- Existing Event Petition spy stays opponent-less when stub `UnitName("target")` is nil.
- HEIGHT 72. TitleBar persist. ESC ClearFocus. Not on `UISpecialFrames`. Isolation wrap stays.

## Concerns

- **No client smoke.** Live `UnitName("target")` after `/reload` (no target, dead, nameplate-only) is unproven. **POLISH:CANDIDATE** only.
- **No chrome hint.** The stock Petition button does not say a current target will be named. Functional surface; no copy was added.
- **Whitespace-only target names.** This lane treats any non-empty string as a candidate. Codec (B17-A) may still drop whitespace-only `opponent` on the wire.
- **Confess box / TitleBar overlap** from B16-B is unchanged. HEIGHT was not grown.

## Status

**DONE_WITH_CONCERNS.** Not signed. No Gate / **POLISH:PASS** claim.
