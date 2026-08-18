# B24-B — Dock dismiss is per Runtime eventId (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 / §20 event lifetime; Law 6 / §19.4 (Quiet is silent; no `PlaySound` / `IG_CHARACTER_INFO_*`); Law 10 / §19.3 (functional / stock templates); wiki ESC `UISpecialFrames` + named frame; brief `docs/reformation/vestments/briefs/B24-B-dock-event.md`; B24 overview; B23-B leftover (boolean `dismissed` stuck across `EndEvent` without Refresh). CONTINUE 2026-08-18 license 4 (stock only). Title stays exactly `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. `UISpecialFrames` stays. Hide is not EndEvent. No dismiss-cooldown number.

OnHide (after create-time Hide): if the event is live, remember Runtime `Snapshot().eventId` (number) and set `lastView.shown = false`. Refresh: if `mayShow` and the current `eventId` equals the remembered id, stay hidden. A new `eventId` (or `eventId` nil / QUIET) clears dismiss and may show. `Show()` clears dismiss. `ResetForTests` clears it. B23-B same-event ESC + Refresh stay-hidden pins stay. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 314 passed, 0 failed (`lua tests/test_console_dock.lua`). **24** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console_dock.lua` | TDD first. Source `eventId` pin. StartEvent + Pope: shown. Widget Hide: hidden. EndEvent (no Refresh). StartEvent + Refresh: **shown** (new eventId). Same-event Hide + Refresh still hidden. Title / hidden CloseButton / `UISpecialFrames` / no-sound pins stay. Persist remount still keys `eventId`. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/ConsoleDock.lua` | `dismissedEventId` keyed to Runtime `eventId`. OnHide remembers that id while live. Refresh stays hidden only while `mayShow` and the id matches. New `eventId` / QUIET / nil clears. `Show()` and `ResetForTests` clear it. CloseButton stays hidden. No hide sound. |
| `docs/reformation/vestments/briefs/B24-B-dock-event-report.md` | This file |
| `docs/reformation/vestments/briefs/B24-B-dock-event.diff` | B24-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Console.lua, Hud, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add a close button, custom media, or `PlaySound`. Did not commit.

## Contract

| Surface | Role |
|---------|------|
| `OnHide` | After create-time `Hide`. Sets `lastView.shown = false`. If the event is live, remembers `Snapshot().eventId` when it is a number. |
| `Refresh` | Not `mayShow`: clear dismiss, paint hidden (clear again after paint so live-event OnHide cannot stick). Same current `eventId` as remembered: paint hidden, keep dismiss. New `eventId` or nil: clear dismiss and may show. |
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
- B23-B same-event Hide + Refresh stay-hidden pins.

## TDD

1. Extended `tests/test_console_dock.lua` first (source `eventId`; StartEvent + Pope shown; widget Hide hidden; EndEvent without Refresh; StartEvent + Refresh shown on new `eventId`; same-event Hide + Refresh still hidden). Isolation wrap untouched. Existing Quiet / persist / title / SANCTION + Expand / B23-B pins stayed.
2. Red: `lua tests/test_console_dock.lua` — **310 passed, 4 failed**.
3. Implemented `dismissedEventId` + `currentEventId` / `stayDismissed`; OnHide remembers the live id; Refresh / Show / `ResetForTests` honor the law.
4. Green: `lua tests/test_console_dock.lua` — **314 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console_dock.lua   # 314 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console_dock.lua` standalone | **314 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 24 pins under `if standalone then` (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Decree, slash). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Console / Hud / glue / TOC not edited.
- `OnHide` is after create-time `widget:Hide()`. Create does not fire teardown. Existing-script guard matches Toasts.
- Widget `Hide()` while ASSEMBLY + Pope: `IsShown` false, `GetView().shown` false, Runtime stays ASSEMBLY, `eventId` unchanged. Next `Refresh` stays hidden.
- `EndEvent` without Refresh leaves dismiss pointing at the old id. Next `StartEvent` + Refresh shows because the new `eventId` does not match.
- Same-event Hide + Refresh stays hidden. `Show()` paints again. `ResetForTests` clears dismiss.
- Title / SANCTION / Expand / hidden CloseButton / persist / `UISpecialFrames` stay.
- Source has no `PlaySound` / `IG_CHARACTER_INFO` / `cooldown`. No close button added.
- Isolation wrap stays.

## Concerns

- **No client smoke.** Real ESC vs `CloseSpecialWindows` on Anniversary is unproven. Harness `Hide()` is a transition-only stub, not a live Escape key. **POLISH:CANDIDATE** only.
- **`paint(false)` while shown and live also remembers `eventId`** (OnHide). `ConsoleDock:Hide()` therefore stays hidden across `Refresh` until `Show()`, a new `eventId`, or QUIET / nil. Brief named widget `Hide()`; the API Hide path matches because it `Hide()`s the widget.
- **Not-`mayShow` Refresh still clears dismiss twice** so a live-event OnHide from that paint cannot stick (Pope-false / missing Sender must not block a later Pope Refresh). End state matches B23-B: dismiss cleared, painted hidden.
- Runtime `EndEvent` leaves `eventId` on the snapshot (state QUIET). This lane treats QUIET as a clear regardless of that leftover id.
- Gate W stays OPEN. Gate V stays OPEN.

## Leftover (not this lane)

Parked (later Console batch): selected-pair inherit of Core `namedOpponent`. Not closed here.

B22-D nits left open: harness `CreateFrame` does not mint `_G["ChurchOfBeefConsoleDock"]`; first-`build` with a nil `UISpecialFrames` is not queued; suite pins list membership, not a special-frame walk.

B23-B leftover (boolean dismiss stuck after `EndEvent` without Refresh) is closed here.

## Status

**DONE_WITH_CONCERNS.** Isolated **314 / 0**. Isolation wrap **24**. Not signed. No Gate W / Gate V / **POLISH:PASS** / V1 claim.
