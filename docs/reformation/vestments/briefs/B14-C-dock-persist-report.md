# B14-C — ConsoleDock drag persist (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 (collapsible movable Director Console); Law 10 / §19.3 (functional / stock templates); Law 6 / §19.1 (Quiet hide stays); HUD `savePoint` / `restorePoint` in `addon/ChurchOfBeef/UI/Hud.lua`; brief `docs/reformation/vestments/briefs/B14-C-dock-persist.md`. CONTINUE 2026-08-18 license 4 (stock only). Title stays exactly `DIRECTOR CONSOLE`. CloseButton hidden. No `PlaySound`. No custom media. No `OnUpdate`.

Copied the HUD persist pattern onto the stock dock. Title-bar `OnDragStop` calls `StopMovingOrSizing` then `savePoint` on the **dock widget** (`GetPoint(1)`). Flat `{ point, relativePoint, x, y }` writes to `ChurchOfBeefDB.ui.consoleDock`. Never stores a frame. `restorePoint` runs in `build()`. Invalid / missing saved point falls back to `BOTTOMLEFT`, `UIParent`, `16`, `80`. Missing `ChurchOfBeefDB` → default restore; save no-ops. `ResetForTests` does not wipe SavedVariables. Event-only show unchanged. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 207 passed, 0 failed (`lua tests/test_console_dock.lua`). **24** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console_dock.lua` | TDD first. TitleBar `OnDragStop` (not root). `DB={ui={}}`; Init; StartEvent; popeFlag true; Show; drag TitleBar; `SetPoint TOPLEFT UIParent TOPLEFT 24 90`; saved point TOPLEFT x 24 y 90, `relativeTo` nil. `dofile` + Init restores parented `UIParent`. Invalid `MIDDLE-OF-NOWHERE` falls back BOTTOMLEFT x 16 y 80. Quiet Init with a valid saved point still hides. `ResetForTests` leaves SV. Missing `ChurchOfBeefDB` restores default; save no-ops. Existing title / SANCTION + Expand / CloseButton / no-sound / no-media pins stay. Then `ChurchOfBeefDB=nil`. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/ConsoleDock.lua` | HUD `ANCHORS` + `uiDb` + `savePoint` / `restorePoint` keyed `consoleDock`. `restorePoint` in `build()` (replaces the hardcoded default `SetPoint`). TitleBar `OnDragStop` saves after `StopMovingOrSizing`. `GetPoint(1)` is on the dock widget. No `relativeTo` in source. `ResetForTests` still only nils the widget / view. |
| `docs/reformation/vestments/briefs/B14-C-dock-persist-report.md` | This file |
| `docs/reformation/vestments/briefs/B14-C-dock-persist.diff` | B14-C-only unified diff of the exclusive implementation files vs the pre-lane baseline |

Did not edit Console.lua, Hud.lua, glue, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add custom media or `PlaySound`. Did not commit.

Both exclusive files were untracked at lane start. The brief diff is the B14-C-only delta vs that pre-lane text.

## Contract

| Surface | Role |
|---------|------|
| `ChurchOfBeefDB.ui.consoleDock` | Flat `{ point, relativePoint, x, y }`. Never a frame. |
| TitleBar `OnDragStop` | `StopMovingOrSizing` on the dock, then `savePoint(widget)`. Root has no `OnDragStop`. |
| `restorePoint` | In `build()`. `ANCHORS` whitelist on point and relative. Else `BOTTOMLEFT` / `UIParent` / `16` / `80`. |
| Missing `ChurchOfBeefDB` | Restore default. Save no-ops. Does not create the global. |
| `ResetForTests` | Nils the widget / view under `_IN_TEST`. Does not wipe SV. |
| Show / hide | Unchanged. `mayShow` = live event + registered Pope. Quiet Init hides even with a saved point. |

### Unchanged

- Stock `BasicFrameTemplate`. Title exactly `DIRECTOR CONSOLE`. CloseButton hidden.
- SANCTION + Expand stock buttons. No whisper, toast, favor, cue.
- No `PlaySound`. No custom media. No `OnUpdate`.
- Isolation wrap. Event-only show.

## TDD

1. Extended `tests/test_console_dock.lua` first (TitleBar drag persist, `dofile` restore, invalid fallback, Quiet hide, ResetForTests leaves SV, missing-DB no-op, existing pins, `ChurchOfBeefDB=nil`). Isolation wrap untouched.
2. Red: `lua tests/test_console_dock.lua` — **193 passed, 14 failed**.
3. Implemented HUD-style `savePoint` / `restorePoint` keyed `consoleDock`; TitleBar drop saves the dock widget; `restorePoint` in `build()`.
4. Green: `lua tests/test_console_dock.lua` — **207 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console_dock.lua   # 207 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console_dock.lua` standalone | **207 passed, 0 failed.** Lua 5.1. Exit 0. |

**Isolated count:** 24 pins under `if standalone then` (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Decree, slash). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Console / Hud / glue / TOC not edited.
- Save fires on TitleBar `OnDragStop` after `StopMovingOrSizing`. `GetPoint(1)` is the dock, not the title bar.
- Saved table has point / relativePoint / x / y and no `relativeTo`. Source has no `relativeTo` string.
- `dofile` + Init restores TOPLEFT 24, 90 parented to `UIParent`. Invalid `MIDDLE-OF-NOWHERE` falls back BOTTOMLEFT 16, 80.
- Quiet Init with a valid saved point still hides. Title / SANCTION / Expand / hidden CloseButton stay.
- Missing `ChurchOfBeefDB` restores default; drag save leaves the global nil.
- `ResetForTests` leaves `ChurchOfBeefDB.ui.consoleDock`. No `PlaySound`. No `OnUpdate`. No custom media. Dock stays `BasicFrameTemplate`.

## Concerns

- **No client smoke.** Title-bar drag persist on Anniversary after `/reload` is unproven. Harness `GetPoint` / `SetPoint` is a stub. **POLISH:CANDIDATE** only.
- **`StopMovingOrSizing` on the real client** may rewrite the widget point (different relative / offsets) before save. Tests pin the stub: `SetPoint` then TitleBar drop stores that point.
- **`uiDb()` creates `ChurchOfBeefDB.ui` when the global exists but `ui` is missing** (HUD pattern). A missing global still no-ops save and does not create `ChurchOfBeefDB`.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Not signed. No Gate / **POLISH:PASS** claim.
