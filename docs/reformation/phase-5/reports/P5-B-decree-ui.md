# Phase 5 Lane B — Decree banner + minimap replay

**Status:** DONE

**Cited:** Ten Laws 6, 10; Bible §14.1, §14.2, §19.3; `.cursor/rules/quiet-event-modes.mdc`; `.cursor/rules/ui-juice-standards.mdc`; `.cursor/rules/wow-ui-taint-lockdown.mdc`; `.cursor/rules/wow-performance.mdc`; brief `docs/reformation/phase-5/briefs/P5-B-decree-ui.md`. Lane A signed: Core `Decree` stores `line` + optional `flavor`; header is UI copy.

Quiet Mode theatrical parchment. The one Quiet feature beyond minimap presence. Shown once per login as a banner; thereafter left-click on the minimap replays it. If `Get()` is nil the banner stays silent — no empty parchment. Session flag only; `/reload` may show again. No sound. No pip, RSVP, countdown, right-click menu, second button, or new slash. When `Get()` is nil, minimap left-click keeps today's `UI:Toggle`. TOC / bootstrap / `tests/run.lua` / MainFrame / Console / HUD / Records Book / Status / Toasts / Store / Runtime / Net / `Core/Decree.lua` / `Core/DB.lua` not edited. No commit.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_decree_ui.lua` | Created first. Isolated suite: wow_ui_stub + Common + Decree + Decree UI + Minimap. Isolation asserts wrapped in `if standalone then`. |
| `addon/ChurchOfBeef/UI/Decree.lua` | Created after the suite. `COB.DecreeBanner` Quiet parchment. Does not clobber `COB.Decree`. |
| `addon/ChurchOfBeef/UI/Minimap.lua` | `Init` calls `DecreeBanner:Init`. Left-click replays when `Get()` is set; else `UI:Toggle`. Tooltip may name the Decree. |
| `tests/test_minimap.lua` | Standalone wrap so `lua tests/test_minimap.lua` exits 0. Loads Common + Decree + banner. Keeps ring / drag / `/beef minimap` / plain-click-when-unset. Adds replay + tooltip + hide/show after replay. |
| `docs/reformation/phase-5/reports/P5-B-decree-ui.md` | This file |

No custom `.ttf` / seal / parchment files were added. Missing media must not fail load; it does not (`GameFont*` + color-fill fallback).

## Mode

**Quiet Mode** (`DecreeBanner.MODE = "QUIET"`). Theatrical (Law 10 / §19.3): dark iron, muted gold edge, aged parchment, ecclesiastical header. Not `BasicFrameTemplate`. Not Event chrome. Not a Console / HUD / Records host.

Unbidden Quiet chrome is still only minimap presence + this banner. Player-opened `/beef` is unchanged.

## Behavior

| Moment | Result |
|--------|--------|
| `Init` and `Get()` is nil | Hidden frame only. No empty parchment. |
| `Init` and `Get()` is non-nil | Show once this session. Paint header, `line`, optional `flavor`. |
| Same-session `Init` after dismiss | Does not auto-show again. |
| `Show()` while `Get()` is set | Replay. Used by minimap left-click. |
| `Show()` while `Get()` is nil | Hide / refuse. No blank banner. |
| `/reload` (fresh module locals) | Session flag resets. May show again. |
| Minimap left-click, `Get()` set | `DecreeBanner:Show()`. Does not `UI:Toggle`. |
| Minimap left-click, `Get()` nil | Today's `UI:Toggle`. Existing "plain click still opens the window" stays green. |
| Tooltip, `Get()` set | May name the header and line. No pip, RSVP, or countdown. |
| Tooltip, `Get()` nil | `Left-click: /beef`. |

"Once per login" is a **module-local** session flag (`loginRevealDone`). It is not written to `ChurchOfBeefDB`. Drag may save position under `ChurchOfBeefDB.ui.decree.point` only when `ui` already exists — that is not an already-seen key.

`Minimap:Init` calls `DecreeBanner:Init` so `PLAYER_LOGIN` / `UI:Init` reaches the banner without bootstrap or TOC edits from this lane.

## API

| Method | Role |
|--------|------|
| `MODE` | `"QUIET"` |
| `HEADER` | `"A GATHERING HAS BEEN DECREED"` (UI copy, not stored) |
| `Init()` | Builds the hidden frame once. Auto-shows at most once this session when `Get()` is set. Idempotent. |
| `Show()` | Paints from `Decree:Get()`. Returns `false` and stays hidden when Get is nil. |
| `Hide()` | Dismisses. Always succeeds. |
| `IsShown()` | Widget visibility. |
| `GetView()` | Copy `{ shown, header, line, flavor }`. No title / deputy / `postedAt`. |
| `ResetForTests()` | No-op unless `COB._IN_TEST`. Clears the session flag and the frame. |

No Grant, Standing, Calendar, RSVP, Summon, Deputy, Post, Narrate, PlayCue, Toast, or Toggle. Close + Escape (`UISpecialFrames`) dismiss. No slash.

## Verification

- Isolated suite (`wow_ui_stub` + `Core/Common.lua` + `Core/Decree.lua` + `UI/Decree.lua` + `UI/Minimap.lua`): **218 passed, 0 failed**.
- Isolation asserts (standalone only): **16**.
- Isolated suite (`lua tests/test_minimap.lua`): **92 passed, 0 failed**.
- Lua 5.1. Both commands exit 0.
- Existing "plain click still opens the window" stays green when no Decree is set.
- `/beef minimap` hide/show stays green after Decree replay.
- Source has no `PlaySound`, `ShowUIPanel`, `StatusBar`, `SendChatMessage`, `Calendar`, `RSVP`, `SLASH_`, `alreadySeen`, or `decreeSeen`.
- No `dofile` of MainFrame / Console / HUD / Records Book / Status / Toasts / Store / Runtime / Net / `Core/DB.lua` / bootstrap in `test_decree_ui.lua`.

This lane did not edit `tests/run.lua`. The runner will report `test_decree_ui` as unlisted until the integrator adds it.

**POLISH:CANDIDATE** only. `UI/Decree.lua` is not in the TOC, so it was not installed and not `/reload` smoked. A human signs `POLISH:PASS`. Do not claim V1 / MVP complete (Bible §22.3).

## Leftovers (other lanes — not fixed)

- **Integrator:** add `UI/Decree.lua` to `ChurchOfBeef.toc` (file exists now; list it with the other UI files so `PLAYER_LOGIN` can see `COB.DecreeBanner`). Add `test_decree_ui` to `tests/run.lua`.
- **#5** deputy UX is not coded. Bible §14.1 names a designated deputy; this lane paints one proclamation and does not invent a deputy picker.
- **#8** registered-Pope / congregation-vs-Pope persist policy is not coded. This lane paints `Decree:Get()` on whatever client has it.
- Console Post button, Decree wire kind, and SUMMON were not invented.
- Calendar / RSVP / reminders / recurrence / attendance were not invented.
- Custom media paths (`Media/DecreeTitle.ttf`, `decree-seal`, `decree-parchment`) are not shipped. Fallbacks keep load alive.
- `/beef` still opens the Quiet shell. Minimap left-click is Decree replay only while a Decree is active.

## What this lane refused to invent

Deputy UX, calendar, RSVP, reminders, recurrence, attendance, a Decree wire kind or STATE field, SUMMON, `#8`, Grant/standing, narration, a new slash, a right-click menu, a second minimap button, a pip, a countdown, sound, Console/HUD/Records hosting, or a SavedVariables "already seen" key.

## Concerns

- `COB.DecreeBanner` is the UI table so `UI/Decree.lua` cannot overwrite Core `COB.Decree`.
- After the first `Save` of a posted Decree (Lane A), `/reload` Restores Core then this `Init` may show the banner again. That is the Bible login reveal, not a second Quiet surface.
- Congregation display of a local SV Decree is not canonical. Theatrical render remains Pope-originated (later Net). This lane does not invent that gate.
- `OPEN_QUESTIONS.md` was not edited. #5 and #8 stay open.
