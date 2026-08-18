# B4-H — Event-only Director Console dock

**Exclusive:** create `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

**Do not edit** TOC, `run.lua`, Console.lua, Hud, Toasts. Integrator lists the files after you. Do not commit. Stock functional chrome. No custom media.

## Law

Bible §18.1 (collapsible), §19.1. Batch 4 critique: the minimized console is titled **DIRECTOR CONSOLE** and appears **only during a live event, only on the Pope's screen**. A SANCTION dock over quiet Orgrimmar is illegal.

```lua
ConsoleDock:Init()
ConsoleDock:Refresh()
ConsoleDock:Show() / Hide()
ConsoleDock:GetView()
ConsoleDock:ResetForTests()
```

Show only when **all** are true:

1. Runtime snapshot state is not `QUIET`
2. `Sender:IsRegisteredPope` for the local player (`UnitName("player")` / Net:PlayerName / Group.PlayerName — use whatever the suite already stubs; fail-closed if missing)

Otherwise Hide. Title string exactly `DIRECTOR CONSOLE`. Two stock buttons:

- `SANCTION` → `Console:Sanction()` if Console exists (do not reimplement Gora)
- `Expand` → `Console:Show()` if Console exists

No WHISPER ALL. No Quiet presence. No sound. No toasts. No favor bar on the dock.

## Tests

Isolated: wow_ui_stub + Common + Runtime + ConsoleDock. Stub Sender.IsRegisteredPope and Console.Sanction/Show. Quiet → hidden. StartEvent + Pope true → shown, title pin. Pope false → hidden. SANCTION click spies Console:Sanction. Isolation wrap.

`lua tests/test_console_dock.lua` exit 0.

Report `docs/reformation/vestments/briefs/B4-H-console-dock-report.md` + diff. POLISH:CANDIDATE.
