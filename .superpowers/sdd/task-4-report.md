# Task 4 Report — Welcome parchment

**Status:** DONE_WITH_CONCERNS  
**Commits:** none  
**Interface:** 20506  
**SCHEMA_VERSION:** 7 (never stamped 8)

## What landed

One Quiet first-launch parchment (Bible §19.5). Variant A copy only. `welcomeSeen` is filled `false` on missing, set on Close only, and left unset when the sheet is skipped because a Decree is showing or Runtime ≠ `QUIET`.

### Per-file changes

- `addon/ChurchOfBeef/UI/Welcome.lua` (new)  
  `COB.Welcome`, `MODE = "QUIET"`, Variant A `COPY`. Theatrical parchment via Theme (iron board, gold edge, charcoal bands, parchment body, papal seal, nails). Separate `AskText` / `FavorText` FontStrings. Close label `CLOSE`. No sound, no `Toasts:Proclaim`, no “Director Console”, no `/beef console`, no Store writes.

- `addon/ChurchOfBeef/ChurchOfBeef.toc`  
  `UI\Welcome.lua` after `UI\Decree.lua`, before `ChurchOfBeef.lua`. Interface stays `20506`.

- `addon/ChurchOfBeef/Core/DB.lua`  
  `defaultUi()` and `applyDefaults`: missing `ui.welcomeSeen` fills `false`. `SCHEMA_VERSION` remains 7.

- `addon/ChurchOfBeef/ChurchOfBeef.lua`  
  `initModule("Welcome", COB.Welcome)` immediately after `DecreeBanner` so a shown Decree can win the stack check.

- `tests/test_welcome.lua` (new)  
  Isolated suite (wow_ui_stub + Common + Theme + Runtime + Welcome).

- `tests/test_db.lua`  
  welcomeSeen / schema-7 pins (defaults, missing fill, keep-true, streamerMode survives, post-event-persist fill). After restoring the Runtime persist module, `ResetForTests` so leftover ASSEMBLY does not leak into later Quiet suites.

- `tests/run.lua`  
  Registered `test_welcome` after `test_decree_ui`.

## TDD

### RED (tests first, no `Welcome.lua`, no `welcomeSeen` default)

```text
$ lua tests/test_welcome.lua
lua: cannot open addon/ChurchOfBeef/UI/Welcome.lua: No such file or directory
WELCOME_EXIT:1

$ lua tests/test_db.lua
FAIL: welcomeSeen defaults false expected false got nil
FAIL: missing welcomeSeen fills false expected false got nil
Tests finished: 519 passed, 2 failed
```

### GREEN (after implementation)

```text
$ lua tests/test_welcome.lua
Tests finished: 99 passed, 0 failed
WELCOME_EXIT:0

$ lua tests/test_db.lua
Tests finished: 524 passed, 0 failed
DB_EXIT:0
```

`test_welcome` covers: `MODE == "QUIET"`; Variant A `COPY`; no “Director Console”; `ask` / `favor` separate and `ask` has no “click a name”; Init shows when unseen + QUIET + no Decree; Close sets `welcomeSeen` and hides; second Init stays hidden; Decree shown / ASSEMBLY skip without stamping the flag; no PlaySound / Proclaim / Sound; `ResetForTests` hides/nils the frame and does not write SV.

## Full harness

```text
$ lua tests/run.lua
Tests finished: 13394 passed, 24 failed
HARNESS_EXIT:1
```

Aborted suites: `test_net_v2`, `test_console`, `test_gora`, `test_wire_glue`.

Those failures are out of Task 4 scope (`PetitionFromSender` / `RecordFavorFromSender` missing on Gora; Console pair targeting; Net favor INPUT; Knighting line). Exclusive files for this task do not include Gora / Console / BeefNet / PlayerCard / Minimap. Task 4 suites stay green in isolation.

## Pins honored

- Missing `ui.welcomeSeen` → `false`; `streamerMode` survives; schema stays 7.
- One §19.5 sheet, first launch only. `MODE = "QUIET"`. No sound. No toast.
- Copy does not say “Director Console.” Ask and favor are separate FontStrings.
- Decree showing or Runtime ≠ QUIET → skip, do not set `welcomeSeen`.
- `pcall` via existing `initModule`, after DecreeBanner.
- Flag on Close only.
- Core never `CreateFrame`. No congregation Store writes.
- No git commit. No phase ticks. No POLISH:PASS / MVP claim.

## Concerns

1. **Full harness is red** from concurrent Wave 2 work on Gora unsigned verbs, Console targeting, Net favor, and Knighting — not from Welcome. Re-run `lua tests/run.lua` after those tasks land.
2. **`test_db.lua` end pin** resets Runtime after event-persist leftovers. That is extra hygiene beyond a pure welcomeSeen assert, so later Quiet surfaces (PlayerCard / Minimap live-gathering copy) do not see a leaked ASSEMBLY. The assertions themselves are welcomeSeen / schema-7.
3. **No client install / `/reload` smoke** this turn. Parchment is harness-green only. **POLISH:CANDIDATE** at most.
