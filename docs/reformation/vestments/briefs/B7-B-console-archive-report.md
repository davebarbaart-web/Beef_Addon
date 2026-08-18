# B7-B — Console Archive, Canonize, Flag Upset (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §13.5 (one-action Archive export/import), §16 (CANONIZE; software supplies the seal, never the scripture), §10.9 (Famous Upsets are Pope-flagged, never computed); Law 7 (bad import does not wipe); Law 10 / §19.3; CONTINUE: CopyToClipboard allowed for the Archive blob only; no post-show ceremony summary; no SUMMON; brief `docs/reformation/vestments/briefs/B7-B-console-archive.md`.

Director Console stays stock-pragmatic. `ExportArchive()` calls `Archive:Export()`, fills `ArchiveBox`, and `pcall`s `CopyToClipboard` with that blob only when `type(CopyToClipboard)=="function"`. Missing Os API still fills the box. `ImportArchive(blob)` reads the arg or the box, calls `Archive:Check` then `Archive:Import`; a bad blob refuses and does not wipe. `CanonizeMoment(momentId, text)` writes `Store:CanonizeMoment` using the latest `GetMarkedMoments()` id and the canonize box when omitted. `FlagFamousUpset(characterId, opponentId)` writes `Store:FlagFamousUpset` from the proposed bout (victor = selected character if set, else fighterA) and never computes an upset. All four verbs are Pope-gated. Missing Archive refuses. No Sound, Toasts, or `SendChatMessage` on these. `SaveNote` stays nil. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Export/Import/Canonize/FlagUpset API; stock ArchiveBox + canonize box; Pope refuse; missing Archive refuse; stubbed Archive Export fills box; Import Check-then-Import; bad blob does not Import or wipe; CopyToClipboard spy + missing-API + pcall; Canonize latest moment / box text; FlagUpset defaults; no Sound/Toasts/chat; SaveNote nil; isolation wrap kept. B7-B block is a nested function (Lua 5.1 200-local cap). |
| `addon/ChurchOfBeef/UI/Console.lua` | Stock `ArchiveBox` + EXPORT ARCHIVE / IMPORT ARCHIVE. Stock canonize EditBox + CANONIZE. Stock FLAG UPSET. Verbs as above. Existing desks and `after()` cues unchanged. |
| `docs/reformation/vestments/briefs/B7-B-console-archive-report.md` | This file |
| `docs/reformation/vestments/briefs/B7-B-console-archive.diff` | B7-B-only unified diff of the exclusive files vs the pre-lane baseline |

Did not edit Store, Archive.lua, Gora, TOC, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

| Method | Role |
|--------|------|
| `ExportArchive()` | Pope-gated. `Archive:Export()`; put blob in `ArchiveBox`; `pcall(CopyToClipboard, blob)` only when the function exists. Missing API is OK. Missing Archive → refuse string. No Sound. |
| `ImportArchive(blob?)` | Pope-gated. Blob from arg or box. `Archive:Check` then `Archive:Import`. Bad Check refuses; Import is not called; box and store are not wiped. Missing Archive → refuse string. No Sound. |
| `CanonizeMoment(momentId?, text?)` | Pope-gated. `Store:CanonizeMoment`. Omitted id = latest `GetMarkedMoments()` id. Omitted text = canonize box. No Sound. |
| `FlagFamousUpset(characterId?, opponentId?)` | Pope-gated. `Store:FlagFamousUpset`. Default victor = selected character if set, else fighterA; opponent = the other proposed fighter. Never computes an upset. No Sound. |
| `SaveNote` | nil |

### Desk

- Stock `InputBoxTemplate` `ArchiveBox` + ritual `EXPORT ARCHIVE` / `IMPORT ARCHIVE` (`UIPanelButtonTemplate`).
- Stock canonize `InputBoxTemplate` + ritual `CANONIZE`.
- Ritual `FLAG UPSET`. No ceremony-summary chrome. No SUMMON. No WHISPER ALL.
- Existing desks, honorific, Recognition, Recommend, and `after()` cues stay.
- No Notebook persist. No custom media.

## TDD

1. Extended `test_console.lua` first (API, isolation, stock boxes, Pope refuse, missing Archive, Export fills box, Import Check-then-Import, bad blob no wipe, CopyToClipboard spy, Canonize latest/box, FlagUpset defaults, no Sound/Toasts/chat, SaveNote). Isolation stayed under `if standalone then`.
2. Implemented `Console.lua`.
3. Green: `lua tests/test_console.lua` — **887 passed, 0 failed**.

Pope predicate uses the suite’s existing `Sender.IsRegisteredPope = function() return true end` wrap. No Pope name. No `Data/Popes.lua`. Archive is stubbed; this suite does not load `Archive.lua`. Store `CanonizeMoment` / `FlagFamousUpset` are wrapped (and stubbed when B7-A has not landed). Full-harness leftovers are niled for the missing-module pin, then restored.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 887 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | 887 passed, 0 failed. Lua 5.1.5. Exit 0. |

**Isolated count:** 17 nil-module pins inside `if standalone then` (Quiet shell, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Six loaded-module pins stay outside the wrap. Standalone suite: **887 passed**.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Archive verbs call `Archive:Export` / `Check` / `Import`. Canonize and FlagUpset call Store.
- Getters unchanged. Expected failures stay `nil, err`.
- New verbs are ritual plates: `applyGate` disables them when the Pope predicate is false; methods stay refuse-closed.
- `after()` still plays knighting / elevation / sanction / verdict / cowardice. New verbs add no cues.
- `CopyToClipboard` is pcalled with the Archive blob only. No post-show ceremony summary. No `SendChatMessage`.
- `Console.SaveNote` remains nil. Source has no `WHISPER ALL` and no `SUMMON THE FAITHFUL`.
- Isolation asserts remain behind `if standalone then`.
- Existing Proposed Bout, favor, Post Decree, FREE RULING, Dismiss, Recommend, CallForward, MARK THIS MOMENT, honorific, and Recognition pins stayed green.

## Concerns

- Client `/reload` smoke was not run. The frame grew (`DEFAULT_HEIGHT` 770 → 880) to fit Archive + Canonize + Flag Upset; glanceability on Anniversary is unproven. The one-line `ArchiveBox` will clip a long export string — clipboard is the real carry path when the Os API exists.
- `Archive.lua` is not loaded here. Export / Import / Check are proven against a stub. Integrator still wires the real module into the full harness.
- `Store:CanonizeMoment` / `Store:FlagFamousUpset` are B7-A. This suite wraps them and stubs when missing. Console does not trim or refuse canonize newlines — that stays Store’s job.
- Weekly Archive reminder (cold-only, §13.5) is not this lane.
- EXPORT / IMPORT / CANONIZE / FLAG UPSET are ritual plates (disabled when not Pope), not B5-C furniture. Clicks still refuse while gated.
- B7-B tests live in a nested `runB7B()` because the main chunk hit Lua 5.1’s 200-local cap.

## Status

**DONE_WITH_CONCERNS.** Not signed.
