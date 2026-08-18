# B26-B — Toast Init restores a missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

**Do not edit** Decree, Records, glue. Do not commit. No `PlaySound` / `IG_CHARACTER_INFO_*`. No new kind names. `KINDS.interrupt` stays false. Nest in `runB12D()`.

## Law

B23-C leftover: Init early-return `rememberSpecial`s but never restores a missing OnHide. A remount that dropped the handler leaves ESC Hide idle.

On the Init early-return path: `rememberSpecial("ChurchOfBeefToast")`; if `GetScript("OnHide")` is nil, wire the **same** idle-return handler as create (`if not self.showing then return` then `bumpGen` / nil showing / `pump`). Do **not** replace an existing script. Do not rebuild.

## Tests

Nil the OnHide, second Init: script is restored; identity after a third Init with the script already set stays the same. Wipe `UISpecialFrames` uniqueness pins stay. Isolation wrap stays.

`lua tests/test_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B26-B-toast-onhide-report.md` + diff.
