# B13-B — Fighter card OnHide lastView (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.6 (mute tape), §10.7 (persist through the verdict beat); Law 6 / §19.1 (Quiet Mode hides Event chrome); Law 10 / §19.3 (theatrical card, no close ✕); brief `docs/reformation/vestments/briefs/B13-B-card-onhide.md`. B12-C ESC registers `UISpecialFrames`; this lane hooks `OnHide` so widget Hide syncs `lastView`. B10-C lastPair persist kept. A01 still NOT RUN.

ESC Hide()s the named widget (B12-C) and does not call `FighterCard:Hide()`, so `lastView.shown` could stay true. `OnHide` now sets `lastView` to the hidden view **without** forgetting `lastPair`. `paintHidden` / `Hide()` use a `hiding` guard so `OnHide` → `paintHidden` → `Hide` cannot recurse forever. Refresh while the event is live still paints the remembered pair. QUIET still forgets. No close ✕. No `PlaySound`. No `UnitHealth`. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

**Isolated count:** 482 passed, 0 failed (`lua tests/test_fighter_card.lua`). **17** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_fighter_card.lua` | TDD first. Source contains `OnHide`. Live card: `stub.fire(frame, "OnHide")` and `frame:Hide()` set `GetView().shown` false; Refresh while the event is live still paints the remembered pair; second Hide / OnHide while hidden stay bounded; QUIET still forgets. Rebuilt card still hooks `OnHide`. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/FighterCard.lua` | `SetScript("OnHide")` after the create-time `Hide`. Handler writes `hiddenView()` and, if not already hiding, calls `paintHidden`. `hiding` guard on `paintHidden` so `Hide` from `OnHide` does not loop. `forgetPersist` stays on QUIET / `Show` / `Refresh` only. |
| `docs/reformation/vestments/briefs/B13-B-card-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B13-B-card-onhide.diff` | B13-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Hud, Toasts, glue, TOC, bootstrap, `run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

`git diff` vs HEAD on these two files also includes Batches 3–12 (working tree already dirty). The brief diff is the B13-B-only delta.

## Contract

```lua
FighterCard:Init()      -- builds once; rememberSpecial; wires OnHide after create Hide
FighterCard:Show()      -- live pair, Runtime subjects, or remembered pair while not QUIET
FighterCard:Hide()      -- paintHidden; does not forget lastPair
frame:Hide() / OnHide   -- lastView.shown = false; lastPair remains
FighterCard:Refresh()   -- may restore while the event is live
FighterCard:GetView()   -- copy
FighterCard:ResetForTests()
```

Mode Event. Quiet / Hide / EndEvent still Hide. `health` stays nil.

### OnHide (B13-B)

- Wired after the create-time `widget:Hide()` so mint does not run teardown.
- Sets `lastView` to `hiddenView()` (`shown = false`). Does not call `forgetPersist`.
- If `hiding` is already true, returns (re-entry from `paintHidden` → `frame:Hide()`).
- Otherwise calls `paintHidden`. `paintHidden` sets `hiding`, clears paint, `Hide`s, then clears `hiding`.
- Second `FighterCard:Hide()` and `OnHide` while already hidden stay lastView hidden and do not loop.

| Field | Source / form |
|-------|----------------|
| dock | LEFT of UIParent, clamped (unchanged) |
| names | `GameFontHighlight` + stock Morpheus (unchanged). Class color on the name only |
| persist | lastPair until QUIET (B10-C; unchanged). Widget Hide / OnHide dismiss; Refresh may restore |
| ESC | `UISpecialFrames` (B12-C) + `OnHide` lastView sync (this lane) |
| health | not on the card. No `UnitHealth` |

## TDD

1. Extended `tests/test_fighter_card.lua` first (`OnHide` source pin; live card `stub.fire` / `frame:Hide` → `GetView().shown` false; Refresh still paints lastPair; guarded second Hide; QUIET forgets; rebuild still hooks). Isolation wrap stayed.
2. Red: `lua tests/test_fighter_card.lua` — **475 passed, 7 failed** (no `OnHide` source, no script, fire false, lastView stayed shown after fire / widget Hide, rebuild had no hook).
3. Implemented `hiding` guard + `OnHide` after create `Hide` in `FighterCard.lua`.
4. Green: `lua tests/test_fighter_card.lua` — **482 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_fighter_card.lua   # 482 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_fighter_card.lua` standalone | **482 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 17 pins under `if standalone then` (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Sound, Decree, Records Book). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Quiet / Hide / EndEvent still Hide. `health` stays nil. No close button.
- Source has `OnHide` and `UISpecialFrames`. Source has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `PlaySound`, `ShowUIPanel`, `StatusBar`, `Toasts`, `Media\\`, `.tga`, `.blp`, `✕`, `rubber`, `ordained`.
- `OnHide` does not call `forgetPersist`. Refresh after widget Hide / fire still paints Chuckroast / Tendermage while the event is live. ASSEMBLY after QUIET does not revive.
- `hiding` is set before `frame:Hide()` and cleared after, so `OnHide` → `paintHidden` → `Hide` returns on re-entry.
- `GetView` is still a copy. Isolation asserts stay under `if standalone then`.
- Card does not write Store or Gora.

## Concerns

- **No client smoke.** ESC is FrameXML `CloseSpecialWindows` → widget `Hide()`. The harness pins `OnHide` via `stub.fire` and `frame:Hide()`, not a live Escape key. **POLISH:CANDIDATE** only.
- **Harness `Hide()` is a transition-only stub.** Already-hidden `Hide()` does not re-fire `OnHide`. `stub.fire` can invoke the script while shown; that path is what needs the `hiding` guard (fire → `paintHidden` → `Hide` → `OnHide` again).
- **A01 still NOT RUN.** `health` is nil. No `UnitHealth`.
- **Hud / Toasts / glue were not edited.** HUD ESC and Proclaim `OnHide` stay those lanes.
- Integrator still lists the files in the TOC and `run.lua` (already listed).

## Status

**DONE_WITH_CONCERNS.** Isolated **482 / 0**. Isolation wrap **17**. Not signed. **POLISH:CANDIDATE.**
