# B4-H — Event-only Director Console dock (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 (collapsible), §19.1; Law 6, Law 10; Batch 4 critique (dock titled **DIRECTOR CONSOLE**, live event + Pope screen only); brief `docs/reformation/vestments/briefs/B4-H-console-dock.md`.

Event-only Pope dock. Stock functional chrome. Title exactly `DIRECTOR CONSOLE`. Shown only when Runtime is not `QUIET` **and** `Sender:IsRegisteredPope(local player)`. Else Hide. `SANCTION` → `Console:Sanction()`. `Expand` → `Console:Show()`. No WHISPER ALL. No Quiet chrome. No sound. No toasts. No favor bar. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console_dock.lua` | TDD first. Isolated: wow_ui_stub + Common + Runtime + ConsoleDock. Stub Sender.IsRegisteredPope and Console.Sanction/Show. Quiet hidden. StartEvent + Pope true → shown, title pin. Pope false → hidden. SANCTION click spies Console:Sanction. Isolation wrap (24 pins). |
| `addon/ChurchOfBeef/UI/ConsoleDock.lua` | `COB.ConsoleDock`. Init / Refresh / Show / Hide / GetView / ResetForTests. Stock BasicFrameTemplate. Two `UIPanelButtonTemplate` buttons. Fail-closed if Sender, Runtime, or local name is missing. |
| `docs/reformation/vestments/briefs/B4-H-console-dock-report.md` | This file |
| `docs/reformation/vestments/briefs/B4-H-console-dock.diff` | B4-H-only unified diff of the exclusive implementation files |

Did not edit TOC, `run.lua`, Console.lua, Hud, Toasts, bootstrap, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

## Contract

```lua
ConsoleDock:Init()
ConsoleDock:Refresh()
ConsoleDock:Show() / Hide()
ConsoleDock:GetView()
ConsoleDock:ResetForTests()
```

Mode Event. Show only when **all** are true:

1. Runtime snapshot state is not `QUIET` (missing Runtime is `QUIET`)
2. `Sender:IsRegisteredPope(local)` is exactly `true`

Local name: `Group.PlayerName` → `Net:PlayerName` → `UnitName("player")`. Missing name, missing Sender, or a non-`true` Pope return is Hide.

| Chrome | Rule |
|--------|------|
| Title | exactly `DIRECTOR CONSOLE` |
| `SANCTION` | stock button → `Console:Sanction()` if Console exists |
| `Expand` | stock button → `Console:Show()` if Console exists |
| WHISPER ALL | absent |
| Favor / StatusBar / EditBox | absent |
| Sound / toasts | absent |

`GetView()` is a copy: `{ shown, title, mode, state, pope }`. `ResetForTests` no-ops unless `COB._IN_TEST`; harness reset nils the widget.

## TDD

1. Wrote `tests/test_console_dock.lua` first (API, isolation, source grep, Quiet refuse, StartEvent + Pope title pin, Pope false hide, SANCTION/Expand spies, fail-closed, GetView copy).
2. Implemented `ConsoleDock.lua`.
3. Green: `lua tests/test_console_dock.lua` — **156 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console_dock.lua   # 156 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console_dock.lua` standalone | 156 passed, 0 failed. Lua 5.1.5. Exit 0. |

**Isolated count:** 24 pins under `if standalone then` (Quiet shell, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Core Decree, slash).

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI calls Console when present; it does not call Gora.
- Quiet Show is false. Pope false Hide. EndEvent Hide. ASSEMBLY / RITE / CONSEQUENCE still show when Pope.
- Source has no `WHISPER ALL`, `PlaySound`, `Toasts`, `StatusBar`, `FAVOR`, `OnUpdate`, `ShowUIPanel`, `Gora:Sanction`, or custom Media.
- Isolation asserts stay under `if standalone then`. Sender / Console stubs are restored at teardown.
- `GetView` is a copy. `ResetForTests` is harness-gated.

## Concerns

- **No client smoke.** The dock is not in the TOC yet. Integrator lists the files. **POLISH:CANDIDATE** only.
- **`#8` stays fail-closed** on a live client until a Pope name is listed. The dock will not appear in-game until `Sender:IsRegisteredPope(local)` is true.
- **`SANCTION` does not pick fighters.** It forwards to `Console:Sanction()` with no args. An unopened desk has no selection; Gora may refuse. This lane does not reimplement sanction.
- **BOTTOMLEFT (16, 80)** is a composition default from Batch 4 (ring stays visible). Not a Bible coordinate. Movable; position is not saved this lane.
- **`BasicFrameTemplate` CloseButton** still exists; it is hidden so chrome is SANCTION + Expand only.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
