# B23-B — ESC on the Event dock stays hidden until Show or QUIET (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 (collapsible Director Console dock); Law 6 / §19.4 (Quiet is silent; no `PlaySound` / `IG_CHARACTER_INFO_*`); Law 10 / §19.3 (functional / stock templates); wiki ESC `UISpecialFrames` + named frame; Toasts create-time Hide then `OnHide`; brief `docs/reformation/vestments/briefs/B23-B-dock-dismiss.md`; B23 overview; B22-D leftover (widget `Hide()` left `GetView().shown` true and `Refresh` re-showed). CONTINUE 2026-08-18 license 4 (stock only). Title stays exactly `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. `UISpecialFrames` stays. Hide is not EndEvent. No dismiss-cooldown number.

OnHide (after create-time Hide, Toasts guard): if the event is live, remember dismiss; set `lastView.shown = false`. `Refresh`: if not `mayShow`, clear dismiss and paint hidden. If dismiss is set, paint hidden and keep dismiss. `Show()` clears dismiss then paints if `mayShow`. `ResetForTests` clears dismiss. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 280 passed, 0 failed (`lua tests/test_console_dock.lua`). **24** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console_dock.lua` | TDD first. Source `OnHide` after create-time `widget:Hide()`; `dismissed`; no `cooldown`. StartEvent + Pope: shown. Widget `Hide()`: `IsShown` false, `GetView().shown == false`, Runtime still ASSEMBLY. `Refresh`: still hidden. `Show()`: shown again. EndEvent / Quiet Refresh: hidden; later StartEvent + Refresh shows. Title / hidden CloseButton / `UISpecialFrames` / no-sound pins stay. Persist remount still hooks OnHide. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/ConsoleDock.lua` | `dismissed` flag. `OnHide` after create-time Hide (Toasts existing-script guard). Refresh / Show / `ResetForTests` per the law. CloseButton stays hidden. No hide sound. |
| `docs/reformation/vestments/briefs/B23-B-dock-dismiss-report.md` | This file |
| `docs/reformation/vestments/briefs/B23-B-dock-dismiss.diff` | B23-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Console.lua, Hud, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add a close button, custom media, or `PlaySound`. Did not commit.

Both exclusive files were untracked at lane start. The brief diff is the B23-B-only delta vs the pre-lane text.

## Contract

| Surface | Role |
|---------|------|
| `OnHide` | After create-time `Hide`. Sets `lastView.shown = false`. If the event is live, `dismissed = true`. |
| `Refresh` | Not `mayShow`: clear dismiss, paint hidden (clear again after paint so live-event OnHide cannot stick). Dismiss set: paint hidden, keep dismiss. Else paint shown. |
| `Show()` | Clears dismiss, then paints if `mayShow`. |
| `ResetForTests` | Clears dismiss (before and after widget `Hide`). |
| `UISpecialFrames` | Unchanged. `rememberSpecial(FRAME_NAME)` stays. |
| Hide | Widget `Hide()` / ESC is not EndEvent. No hide sound. No dismiss-cooldown number. |
| CloseButton | Stays hidden. Title stays `DIRECTOR CONSOLE`. Persist stays. |

### Unchanged

- Stock `BasicFrameTemplate`. Title exactly `DIRECTOR CONSOLE`. CloseButton hidden.
- SANCTION + Expand stock buttons. No whisper, toast, favor, cue.
- No `PlaySound`. No `IG_CHARACTER_INFO_*`. No custom media. No `OnUpdate`.
- Isolation wrap. Event-only show. `mayShow` = live event + registered Pope.

## TDD

1. Extended `tests/test_console_dock.lua` first (OnHide after create Hide; `dismissed`; no `cooldown`; widget Hide / Refresh stay / Show / EndEvent / Quiet Refresh). Isolation wrap untouched. Existing Quiet / persist / title / SANCTION + Expand pins stayed.
2. Red: `lua tests/test_console_dock.lua` — **267 passed, 13 failed**.
3. Implemented `dismissed` + Toasts-shaped `OnHide` after create-time Hide; Refresh / Show / `ResetForTests` honor the law.
4. Green: `lua tests/test_console_dock.lua` — **280 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console_dock.lua   # 280 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console_dock.lua` standalone | **280 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 24 pins under `if standalone then` (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Decree, slash). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Console / Hud / glue / TOC not edited.
- `OnHide` is after create-time `widget:Hide()`. Create does not fire teardown. Existing-script guard matches Toasts.
- Widget `Hide()` while ASSEMBLY + Pope: `IsShown` false, `GetView().shown` false, Runtime stays ASSEMBLY. Next `Refresh` stays hidden. `Show()` paints again.
- EndEvent / Quiet Refresh paint hidden and clear dismiss; a later StartEvent + Refresh shows.
- `ResetForTests` clears dismiss. Title / SANCTION / Expand / hidden CloseButton / persist / `UISpecialFrames` stay.
- Source has no `PlaySound` / `IG_CHARACTER_INFO` / `cooldown`. No close button added.
- Isolation wrap stays.

## Concerns

- **No client smoke.** Real ESC vs `CloseSpecialWindows` on Anniversary is unproven. Harness `Hide()` is a transition-only stub, not a live Escape key. **POLISH:CANDIDATE** only.
- **`paint(false)` while shown and live also sets dismiss** (OnHide). `ConsoleDock:Hide()` therefore stays hidden across `Refresh` until `Show()` or QUIET. Brief named widget `Hide()`; the API Hide path matches because it `Hide()`s the widget.
- **Not-`mayShow` Refresh clears dismiss twice** so a live-event OnHide from that paint cannot stick (Pope-false / missing Sender must not block a later Pope Refresh). End state matches the brief: dismiss cleared, painted hidden.
- Gate W stays OPEN. Gate V stays OPEN.

## Leftover (not this lane)

Parked (later Console batch): desk `lastRecommendation` lifetime across EndEvent; selected-pair inherit of Core `namedOpponent`. Not closed here.

B22-D nits left open: harness `CreateFrame` does not mint `_G["ChurchOfBeefConsoleDock"]`; first-`build` with a nil `UISpecialFrames` is not queued; suite pins list membership, not a special-frame walk.

## Status

**DONE_WITH_CONCERNS.** Isolated **280 / 0**. Isolation wrap **24**. Not signed. No Gate W / Gate V / **POLISH:PASS** / V1 claim.
