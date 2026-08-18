# B23-A — Theater owns §19.4 cues when Proclaim exists

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Toasts, Sound, glue. Do not commit. `SaveNote` stays nil. No new cue names. Nest new pins in `runB8E()` — Lua 5.1 200-local cap. Do not add main-chunk locals.

## Law

V-INT leftover: Console `after()` `playCue` and `Toasts:Proclaim` → `playTheaterCue` play the same §19.4 name twice on Sanction / KnightThisBeef / ElevateToLord / the four rulings.

`playCue`: if `COB.Toasts` is a table and `type(Toasts.Proclaim) == "function"`, return without `Sound:Play`. Theater owns the cue on the live client. Isolated suite does not load Toasts — existing Sound pins stay green.

Do not remove the `cue` arguments on the verbs. Do not call `Toasts:Proclaim` from Console. Do not call Net. `SaveNote` stays nil.

## Tests

Existing Sound stub pins stay (Knighting / elevation / sanction / verdict / cowardice). Nested pin: assign `COB.Toasts = { Proclaim = function() end }`, Sanction (and one other cued verb) does **not** append to the Sound spy. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B23-A-after-cue-report.md` + diff.
