# B6-A — Console honorific + Recognition (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §15 (honorifics = Pope-granted plain text), §12.2 (Rite of Recognition; no self-service); Law 10 / §19.3; no designated-Council UX (#8); brief `docs/reformation/vestments/briefs/B6-A-console-identity.md`.

Director Console stays stock-pragmatic. `GrantHonorific(humanId, text)` trims, refuses empty and embedded `"\n"`, never invents titles, and writes `Store:AddHonorific(humanId or selectedHumanId, text)` (box text when omitted). `BeginRecognition` / `CompleteRecognition` / `CancelRecognition` are Pope-gated. Begin always passes confirmer `"pope"` plus `Clock.Wall()`; selected human + character when args are omitted. Missing Recognition module returns a refuse string. No auto-Complete on the 30s metadata duration. No UnitName bind. No Council button. `after()` Sound pins stay. `SaveNote` stays nil. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. GrantHonorific / Begin / Complete / Cancel API; stock honorific box; newline/empty refuse; Begin spies role `"pope"`; Complete/Cancel/Grant play no Sound; missing Recognition refuse; SaveNote nil; isolation wrap kept. Recognition verbs stubbed; suite does not load Recognition.lua. |
| `addon/ChurchOfBeef/UI/Console.lua` | Stock honorific EditBox + GRANT HONORIFIC. Begin / Complete / Cancel Recognition ritual plates. Verbs as above. Existing desks and `after()` cues unchanged. |
| `docs/reformation/vestments/briefs/B6-A-console-identity-report.md` | This file |
| `docs/reformation/vestments/briefs/B6-A-console-identity.diff` | B6-A-only unified diff of the exclusive files vs the pre-lane baseline |

Did not edit Store, Recognition.lua, Knighting, RecordsBook, TOC, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

| Method | Role |
|--------|------|
| `GrantHonorific(humanId?, text?)` | Pope-gated. `Store:AddHonorific(humanId or selectedHumanId, text)`. Text from the honorific box when omitted. Trim; empty refuse; embedded `"\n"` refuse. Never invents titles. No Sound. |
| `BeginRecognition(humanId?, characterId?)` | Pope-gated. `Recognition:Begin(..., "pope", now)` using selected human + selected character when args omitted. Missing module → refuse string. No UnitName bind. |
| `CompleteRecognition()` | Pope-gated. `Recognition:Complete(now)`. No Sound. Does not fire on duration. |
| `CancelRecognition()` | Pope-gated. `Recognition:Cancel()`. No Sound. |
| `SaveNote` | nil |

### Desk

- Stock `InputBoxTemplate` honorific box + ritual `GRANT HONORIFIC` (`UIPanelButtonTemplate`).
- Ritual plates: Begin Recognition / Complete Recognition / Cancel Recognition. No Council confirmer button.
- Existing desks, Recommend, CallForward, FlagMoment, and `after()` cues stay.
- No WHISPER ALL. No Notebook persist. No custom media.

## TDD

1. Extended `test_console.lua` first (API, isolation, stock box, Pope refuse, Store write, newline/empty, Begin role `"pope"`, Complete/Cancel/Grant no Sound, missing Recognition, SaveNote). Isolation stayed under `if standalone then`.
2. Implemented `Console.lua`.
3. Green: `lua tests/test_console.lua` — **744 passed, 0 failed**.

Pope predicate uses the suite’s existing `Sender.IsRegisteredPope = function() return true end` wrap. No Pope name. No `Data/Popes.lua`. Recognition is stubbed; this suite does not load `Recognition.lua`. Full-harness leftovers are niled for the missing-module pin, then restored.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 744 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | 744 passed, 0 failed. Lua 5.1.5. Exit 0. |

**Isolated count:** 17 nil-module pins inside `if standalone then` (Quiet shell, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Six loaded-module pins stay outside the wrap. Standalone suite: **744 passed**.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Honorific writes `Store:AddHonorific`. Recognition confirmer is always `"pope"`.
- Getters unchanged. Expected failures stay `nil, err`.
- GRANT HONORIFIC and Recognition verbs are ritual plates: `applyGate` disables them when the Pope predicate is false; methods stay refuse-closed.
- `after()` still plays knighting / elevation / sanction / verdict / cowardice. New verbs add no cues.
- `Console.SaveNote` remains nil. Source has no `WHISPER ALL` and no `"council"` confirmer literal.
- Isolation asserts remain behind `if standalone then`.
- Existing Proposed Bout, favor, Post Decree, FREE RULING, Dismiss, Recommend, CallForward, and MARK THIS MOMENT pins stayed green.

## Concerns

- Client `/reload` smoke was not run. The frame grew (`DEFAULT_HEIGHT` 770) to fit the honorific row and Recognition plates; glanceability on Anniversary is unproven.
- `Recognition.lua` is not loaded here. Begin / Complete / Cancel are proven against a stub. Integrator still wires the real module into the full harness.
- Duration stays Core metadata. This lane adds no 30s timer and does not auto-Complete.
- GRANT HONORIFIC / Recognition are ritual plates (disabled when not Pope), not B5-C furniture. Clicks still refuse while gated.
- Newline refuse is after trim. A trailing-only `"\n"` is whitespace and does not count as embedded.
- Console never offers a Council confirmer. Core still accepts `"council"`; designated-Council UX stays #8.

## Status

**DONE_WITH_CONCERNS.** Not signed.
