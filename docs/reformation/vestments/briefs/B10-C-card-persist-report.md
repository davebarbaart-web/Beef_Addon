# B10-C — Fighter card persists through the verdict (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.6 (mute tape), §10.7 (persist through the verdict beat, exits with the consequence); Law 6 / §19.1 (Quiet Mode hides Event chrome); brief `docs/reformation/vestments/briefs/B10-C-card-persist.md`. B3-B mute tape, B4-E LEFT / Morpheus, B6-D honorifics, and B8-C mute defense integers kept. A01 still NOT RUN.

Event Mode mute fighter card remembers the last sanctioned pair. After `Gora:GetSanctioned()` is nil, if Runtime is still not QUIET, the card keeps painting that pair. Congregation pair may arrive as Runtime `subjects.fighters` when Gora has no live pair. Hide on QUIET / Hide() / EndEvent. A new Sanction replaces the remembered pair. Painted W–L and H2H stay `1-0`. `health` stays nil. No `UnitHealth`. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

**Isolated count:** 441 passed, 0 failed (`lua tests/test_fighter_card.lua`). **17** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_fighter_card.lua` | TDD first. Flipped `card hides when the pair clears` → stays shown after DeclareVictor while the event is live; names still painted; `health` nil; no `view.verdict`; persist paint keeps `1-0`. Hide still dismisses. QUIET still hides. ASSEMBLY after QUIET does not revive the last pair. Runtime-subjects-only pair shows (no Gora sanction). Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/FighterCard.lua` | `lastPair`. `displayPair` prefers live `GetSanctioned()`, then Runtime `subjects.fighters` with two ids, then the remembered pair. `Refresh` / `Show` paint while not QUIET. `forgetPersist` on QUIET and `ResetForTests`. Hide dismisses the widget and does not forget the pair. No `UnitHealth`. |
| `docs/reformation/vestments/briefs/B10-C-card-persist-report.md` | This file |
| `docs/reformation/vestments/briefs/B10-C-card-persist.diff` | B10-C-only unified diff of the exclusive implementation files vs the pre-lane baseline |

Did not edit Hud, Gora, Console, TOC, bootstrap, `run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

## Contract

```lua
FighterCard:Init()
FighterCard:Show()      -- live pair, Runtime subjects, or remembered pair while not QUIET
FighterCard:Hide()      -- dismisses the widget; Refresh may restore while the event is live
FighterCard:Refresh()
FighterCard:GetView()   -- copy
FighterCard:ResetForTests()
```

Mode Event. Quiet / Hide / EndEvent still Hide. `health` stays nil.

### Persist (Bible §10.7 composition)

- Remember the last sanctioned `fighterA` / `fighterB` (and Pope stipulation, if any) when `GetSanctioned()` is a live pair.
- If `GetSanctioned()` is nil and Runtime snapshot `subjects.fighters` has two ids, use that pair (congregation). Remember it as last pair.
- After both Gora and Runtime fighters are empty, if Runtime is not QUIET, keep painting the remembered pair.
- Hide on QUIET / Hide() / EndEvent. Forget the remembered pair on QUIET so a later ASSEMBLY does not revive it.
- A new Sanction replaces the remembered pair.
- No verdict qualifier on the card (`view.verdict` stays nil). Health stays nil. Defense integers and honorifics unchanged.

| Field | Source / form |
|-------|----------------|
| dock | LEFT of UIParent, clamped (B4-E; unchanged) |
| names | `GameFontHighlight` + stock Morpheus (unchanged). Class color on the name only |
| titles / records / H2H / stipulation | `GameFont*`. W–L and H2H paint as `1-0` (arabic) |
| honorific | Store human text. Empty / unlinked → Hide (B6-D; unchanged) |
| defenses | `Store:CountDefenses(id)` mute integer. Hide when 0 or missing (B8-C; unchanged) |
| health | not on the card. No `UnitHealth` |

## TDD

1. Extended `tests/test_fighter_card.lua` first (flip the mid-event hide pin; persist names / shown / health nil / `1-0`; QUIET hide; ASSEMBLY after QUIET; Runtime-subjects-only; isolation wrap).
2. Implemented `lastPair` persist + Runtime `subjects.fighters` in `FighterCard.lua`.
3. Green: `lua tests/test_fighter_card.lua` — **441 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_fighter_card.lua   # 441 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_fighter_card.lua` standalone | **441 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 17 pins under `if standalone then` (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Sound, Decree, Records Book). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Quiet / Hide / EndEvent still Hide. `health` stays nil. No close button.
- Source has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `PlaySound`, `StatusBar`, `Toasts`, `Media\\`, `.tga`, `.blp`, `rubber`, `ordained`.
- Painted rematch record and H2H stay `1-0`. LEFT dock and Morpheus names stay.
- `GetView` is still a copy. Isolation asserts stay under `if standalone then`.
- Card does not write Store or Gora. Card does not call `Gora:GetLastSanctioned` (B10-A exclusive).

## Concerns

- **No client smoke.** Persist through the verdict beat is Event Mode theater. Harness proves `Refresh` after `DeclareVictor` / `EndEvent` / Runtime subjects. `/reload` after a live ruling was not run. **POLISH:CANDIDATE** only.
- **lastPair is card-local.** This lane does not edit Gora. Persist works only after `Show` / `Refresh` has seen a live pair or Runtime subjects. A first paint after `DeclareVictor` with no remembered pair and no subjects stays hidden.
- **Store W/L updates on persist paint.** The remembered pair is re-read from Store, so the tape can show `1-0` immediately after `DeclareVictor`. That is not a verdict qualifier.
- **Hide() does not forget lastPair.** Hide dismisses the widget. Refresh while the event is still live restores the remembered pair. QUIET / EndEvent forget.
- **Cowardice / Void share the same persist path** (`GetSanctioned()` nil + not QUIET). Only `DeclareVictor` is pinned.
- **A01 still NOT RUN.** `health` is nil. No `UnitHealth`.
- **Hud / Gora were not edited.** HUD persist and `GetLastSanctioned` stay those lanes.
- Integrator still lists the files in the TOC and `run.lua` (already listed).

## Status

**DONE_WITH_CONCERNS.** Isolated **441 / 0**. Isolation wrap **17**. Not signed. **POLISH:CANDIDATE.**
