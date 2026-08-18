# W-F — HUD: favor split bar + congregation plate pick

**Exclusive files (only these):**
- `addon/ChurchOfBeef/UI/Hud.lua`
- `tests/test_hud.lua`

**Do not edit:** Gora, Store, Codec, BeefNet, Console, TOC, bootstrap, Sender, Runtime, `tests/run.lua`, OPEN_QUESTIONS, REFORMATION_LOG, `Data/Popes.lua`.

**Do not commit.** TDD. Isolation asserts stay under `if standalone then`.

W-B and W-D are **signed**. `Gora:GetFavorSplit()` exists. `Net:SendFavor(fields, target)` exists (WHISPER, not Pope-gated).

## Law

CONTINUE license 2. Bible §10.6, §10.7. Batch 2 critique **§D** (favor readability only — not Vestments dress).

- HUD is Event Mode. Hidden in Quiet. `health` stays **nil** (A01 fallback).
- No live `UnitHealth`. No nameplate scrape. No custom `.tga` / `.blp` / `.ttf`. No faction icons. No Gora-sigil art import (that is V-D, closed).
- Stock Blizzard textures/fonts only. `BackdropTemplate` exists on Anniversary 20506 (HUD already uses it).
- Favor split renders to the **congregation** only when the Pope toggle is on — meaning a broadcast favor table is present. Toggle off = no visible STATE favor = `GetView().favor == nil`.
- Pope client always sees the live split from Gora while a pair is sanctioned (desk + HUD).
- No favor history, streaks, accuracy, economy, wagering. UI never records official outcomes.
- Do not invent a Pope name. Do not look up `Data/Popes.lua`.

## 1. Favor on `GetView`

Today `favor` is always `nil`. Change:

```lua
-- hidden / no pair:
favor = nil

-- rendering:
favor = { a = n, b = n, pctA = n, pctB = n }  -- integers; percents 0–100
```

Fill rules:

1. **Local Pope** (`Sender:IsRegisteredPope` of the local player): while a live sanctioned pair exists, fill from `Gora:GetFavorSplit()`. Zeros are a real split (`0,0` → percents 0/0). Always visible to the Pope.
2. **Congregation** (predicate missing or false): fill only from the last **broadcast** favor:
   ```lua
   Hud:SetBroadcastFavor(favor or nil)  -- { a, b } or nil
   ```
   `nil` = toggle off or no STATE favor yet → `GetView().favor == nil` (do not show the bar).
   Present `{ a, b }` = toggle on → render those counts. Do **not** read Gora on a congregation client (Gora tally lives on the Pope).
3. Isolated suite does not load Sender today. Missing Sender ⇒ congregation path. Tests stub `COB.Sender.IsRegisteredPope` for the Pope path.
4. `GetView` still returns a **copy**. Mutating it must not change live state. `health` stays nil.

Percentages: if `a + b == 0` then `pctA = 0`, `pctB = 0`. Else `pctA = floor(100 * a / (a+b))`, `pctB = 100 - pctA` (so they sum to 100). Integers only. No “favorite” label, no underdog copy.

## 2. Split bar (Batch 2 §D — functional, not dress)

Under the fighter plates, stock:

- Tiny `FAVOR` label (`GameFontNormal` / `GameFontHighlightSmall`).
- Two halves (two `StatusBar` frames **or** two textures). Tint each half with that fighter’s `nameColor` (class color already on the name). If `nameColor` is nil, use the existing muted ink.
- Small percentages at each end (`"40%"` / `"60%"`). Dual-encode: color + text.

`CreateFrame("StatusBar")` + `SetMinMaxValues` / `SetValue` / `SetStatusBarColor` are `SimpleStatusBarAPI` on classic_anniversary. `tests/wow_ui_stub.lua` already stubs StatusBar.

Do **not** add stained-glass health bars, portraits, or a center sigil (V-D). Do not grow the HUD into a toast. No `OnUpdate`. No `PlaySound`.

When `favor` is nil, hide the bar and the FAVOR label.

## 3. Congregation pick = click a fighter plate

```lua
Hud:PickFavor(pickId, target, characterId)
```

Calls `Net:SendFavor({ characterId = characterId, pick = pickId }, target)` when Net offers it.

- `pickId` must be the live fighter A or B store id.
- `target` is the whisper destination. **Required.** Do not invent or look up a Pope name. If missing → `nil, "no target"`. Integrator / later glue may remember the last accepted STATE sender and pass it in.
- `characterId` is the picker’s store id. Required. If missing → `nil, "no character"`. Do not invent a Store name lookup in this lane.
- Pope client clicking a plate: still allowed to send if Net exists (harmless); do not auto-tally locally (Gora tally is whisper-recv on the Pope). Isolated tests stub `COB.Net.SendFavor`.
- Wire the plate click (`nameA` / `nameB` or a stock `Button` overlay, `EnableMouse`, `OnClick`) to `PickFavor` **only if** a target and local character id have been set:

```lua
Hud:SetFavorTarget(target)           -- string or nil
Hud:SetLocalCharacterId(characterId) -- store int or nil
```

ResetForTests clears both plus broadcast favor.

If target or local id is missing, plate click is a no-op (no error chat). Programmatic `PickFavor` still returns the error string.

Do not add `Hud.SendFavor` as a public alias. Do not add `Hud.Favor` as an economy table. Remove `assert_eq(Hud.Favor, nil)` / `Hud.SendFavor` / “view never carries favor” as needed; keep “no live health” and nameplate-scrape pins.

## Tests (`test_hud.lua`)

Keep: Quiet hidden, Store names/class colors/W–L, GetView copy, health nil, no nameplates, no sound.

Add:

- Pope stub + RecordFavor → `GetView().favor` matches split + percents; bar shown.
- Congregation (no stub): `SetBroadcastFavor(nil)` → `favor == nil`; `SetBroadcastFavor({ a = 2, b = 1 })` → 67/33 (or 66/34 if you use floor-then-remainder — pin the exact integers you implement).
- Toggle-off congregation: broadcast nil → no FAVOR label / `favor == nil` even if Gora has picks (do not read Gora on congregation).
- `PickFavor` stubs Net and records `{ characterId, pick }` + target.
- Missing target / characterId refused.
- Plate click with target + local id set calls SendFavor; without them, no call.
- Isolation asserts stay under `if standalone then`.

You may `dofile` Sender in the suite if needed; do not load TOC / bootstrap / Console / `Data/Popes.lua`.

## Verify

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua
```

Must exit 0. No commit. Write `docs/reformation/wire/briefs/W-F-hud-report.md` and `W-F-hud.diff`.
