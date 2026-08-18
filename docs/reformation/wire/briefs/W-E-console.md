# W-E — Console: favor pane + congregation toggle + free-ruling text

**Exclusive files (only these):**
- `addon/ChurchOfBeef/UI/Console.lua`
- `tests/test_console.lua`

**Do not edit:** Gora, Store, Codec, BeefNet, HUD, TOC, bootstrap, Sender, Runtime, Decree Core, `tests/run.lua`, OPEN_QUESTIONS, REFORMATION_LOG, `Data/Popes.lua`.

**Do not commit.** TDD. Isolation asserts stay under `if standalone then`.

W-B, W-C, and W-D are **signed**. `Gora:GetFavor` / `GetFavorSplit` / `RecordFavor` / `FreeRuling(text)` exist. `Net:SendDecree` / `SendFavor` exist — **this lane must not call them.**

## Law

CONTINUE 2026-08-18 licenses 1–3. Bible §10.6, §14.1, §18.1–18.3, §19.3 / Law 10.

Director Console stays **stock-pragmatic forever**. `UIPanelButtonTemplate`, `InputBoxTemplate`, `UICheckButtonTemplate`, `GameFont*`. No parchment, no custom media, no jokes in chrome.

Layers: UI → Core only. **Do not call `COB.Net`.** `after()` must not call `SendState` or `SendDecree`. Post Decree still `Decree:Set` only. Integrator (bootstrap) broadcasts on Decree-set and Runtime transitions.

No favor history, streaks, accuracy, economy, wagering. No settings panel. No Pope name in `Data/Popes.lua`.

## 1. Gora desk favor pane (always visible to the Pope)

When the Console is shown, the Gora desk shows a stock **FAVOR** readout from `Gora:GetFavorSplit()` (copy `{ a = n, b = n }`; zeros if none) and a standing-pick count from `Gora:GetFavor()` (map size). Refresh paints it.

This pane is for the Pope. It is not congregation theater. Labels are clerical (`FAVOR`, counts). Do not invent narration.

API (names fixed):

```lua
Console:GetFavorSplit()   -- copy from Gora, or { a = 0, b = 0 }
Console:GetFavorCount()   -- integer standing picks (0 if Gora missing)
```

Mutating the return of `GetFavorSplit` must not change Gora.

Remove leftover `assert_eq(Console.Favor, nil)` and “no favor chrome” if they block the pane. Do not add a public `Console.Favor` economy table.

## 2. Per-event congregation display toggle

Bible §10.6: the split is always visible to the Pope; congregation display **defaults on** and is a per-event Pope toggle.

```lua
Console:GetCongregationFavorVisible()           -- boolean, default true
Console:SetCongregationFavorVisible(flag)       -- true/false; refuse non-boolean
```

Rules:

- Memory only. Never write SavedVariables / `ChurchOfBeefDB`.
- Default **true**. `ResetForTests` resets to true.
- Per-event: when `Runtime:Snapshot().eventId` changes (including QUIET `nil` after an event), reset to **true**. Do this in `Refresh` (or a helper Refresh already calls). Do **not** persist the last event’s off-state into the next Gathering.
- Stock `CheckButton` with `UICheckButtonTemplate` (exists on Anniversary 20506 — TradeSkill uses it). Fallback: `CreateFrame("CheckButton", …)` with no template if inherit fails in the harness. Label: `Congregation sees favor`.
- Setter does not need Net. Integrator reads `GetCongregationFavorVisible()` when building `SendState`.
- Ritual verbs stay Pope-gated. The toggle lives on the Pope desk; clicking it when `IsRegisteredPope` is false should no-op / refuse like other desk chrome (`applyGate`). Getter still returns the in-memory flag.

## 3. Post Decree — licensed path is Core Set, not Net

`Console:PostDecree` stays `Decree:Set` + local banner. **Do not** call `Net:SendDecree` or `Net:SendState`.

Update the file header: Post Decree writes Core; BeefNet broadcast is bootstrap glue (integrator). Decree is still a Quiet desk verb (Law 6: no Sound).

Tests: after a successful PostDecree, `Net` send counters stay 0 if a Net stub exists; do not invent a send.

## 4. FREE RULING — text box, no winner

`Console:FreeRuling(text)` already forwards optional text to Gora. The button currently calls `FreeRuling()` with no text.

Add a stock `InputBoxTemplate` on the Gora desk (`frame.FreeRulingText`). The FREE RULING button reads that box when `text` is omitted.

- Do **not** pass `selectedCharacterId` as a winner. Free ruling has no winner picker.
- Do not add a fighter dropdown.
- Existing `Console:FreeRuling()` (no args, empty box) still reaches Gora and records no W/L.
- `Console:FreeRuling("so ruled")` still passes the argument through (tests / programmatic).
- Trim is Gora’s job; do not invent a second trim policy.

## Tests (`test_console.lua`)

Keep existing Pope-gate, PostDecree Set, no-Sound, isolation.

Add:

- Favor pane: after RecordFavor on a sanctioned pair, `GetFavorSplit` matches Gora; mutating the copy does not change Gora; Refresh paints counts.
- Toggle defaults true; `SetCongregationFavorVisible(false)` then true; non-boolean refused; `ResetForTests` returns true.
- StartEvent → set toggle false → EndEvent → StartEvent (Refresh in between) → toggle is true again.
- PostDecree does not call Net.
- FreeRuling from the edit box passes that string to Gora (spy or Store row `text`); `FreeRuling()` with empty box still `ruling == "free"` and `won == nil`.
- Isolation asserts stay under `if standalone then`.

Follow the suite’s existing `Sender.IsRegisteredPope` stub pattern. Do not write `Data/Popes.lua`.

## WoW API (classic_anniversary / 20506)

- `CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")` + `SetChecked` / `GetChecked` / `OnClick`. `SetChecked` is `SimpleCheckboxAPI` on this flavor.
- `CreateFrame("EditBox", nil, parent, "InputBoxTemplate")` — already used as `stockEdit`.
- `CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")` — already used.
- Do **not** use Retail-only templates. Do not `SetScale` on `UIParent`. No `OnUpdate`.

`tests/wow_ui_stub.lua` already stubs `CheckButton` and `SetChecked`.

## Verify

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua
```

Must exit 0. Full harness optional; report counts if you run it. Do not edit files outside the exclusive pair if the harness is red.

No commit. Write `docs/reformation/wire/briefs/W-E-console-report.md` and `W-E-console.diff`.
