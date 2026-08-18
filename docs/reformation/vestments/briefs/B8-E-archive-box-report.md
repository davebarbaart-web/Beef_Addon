# B8-E — Console Archive box usable (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §13.5 (Sacred Archive one-action export/import on the Pope console); Law 10 / §19.3 (Director Console stays stock-pragmatic); Anniversary `EditBox:SetMultiLine` (SimpleEditBoxAPI); CONTINUE 2026-08-18 (no SUMMON; no post-show clipboard; `SaveNote` stays nil; Console stays plain); brief `docs/reformation/vestments/briefs/B8-E-archive-box.md`.

`ArchiveBox` is type-guarded `SetMultiLine(true)` and 72px tall when the API exists. Stock `GameFontNormal` labels `ARCHIVE` and `CANONIZE` sit above those boxes. `InputBoxTemplate` kept. Focus not stolen. `SetMaxLetters` not lowered. Export / Import / Canonize / Flag Upset verbs unchanged. `CopyToClipboard` still the Archive blob only. `SaveNote` stays nil. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested `runB8E()`: `_multiline == true`; height > 22; `ARCHIVE` / `CANONIZE` FontStrings (`GameFontNormal`, exact words); other boxes stay one line; verbs still present; `SaveNote` nil; no SUMMON / COPY SUMMARY / WHISPER ALL; source pins the type-guard, `SetMultiLine(true)`, and no `SetMaxLetters`; isolation wrap re-pin. |
| `addon/ChurchOfBeef/UI/Console.lua` | Stock `ARCHIVE` / `CANONIZE` headers. Type-guarded `SetMultiLine(true)` + `_multiline` harness flag + `SetHeight(72)`. `DEFAULT_HEIGHT` 880 → 960. Verbs and `SaveNote` untouched. |
| `docs/reformation/vestments/briefs/B8-E-archive-box-report.md` | This file |
| `docs/reformation/vestments/briefs/B8-E-archive-box.diff` | B8-E-only unified diff of the exclusive files vs the pre-lane baseline |

Did not edit Archive.lua, Store, TOC, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

| Surface | Role |
|---------|------|
| `ArchiveBox` | Stock `InputBoxTemplate`. If `type(SetMultiLine) == "function"`, `SetMultiLine(true)`, `_multiline = true`, height 72. `SetAutoFocus(false)` unchanged. `SetMaxLetters` not called. |
| `ARCHIVE` | Stock `GameFontNormal` FontString by the archive box. Functional label, not a joke. |
| `CANONIZE` | Stock `GameFontNormal` FontString by the canonize box. Distinct from the existing `CANONIZE` ritual plate. |
| Export / Import / Canonize / Flag Upset | Unchanged. `CopyToClipboard` still pcalled with the Archive blob only. |
| `SaveNote` | nil |

### Desk

- Console stays stock. No custom media. No parchment.
- No SUMMON. No post-show ceremony summary. No WHISPER ALL.
- Existing desks, honorific, Recognition, Recommend, and `after()` cues stay.

## TDD

1. Extended `test_console.lua` first (multiline + height, stock labels, SaveNote nil, isolation wrap, source type-guard). Isolation stayed under `if standalone then`. B8-E block is a nested function (Lua 5.1 200-local cap).
2. Implemented `Console.lua`.
3. Green: `lua tests/test_console.lua` — **936 passed, 0 failed**.

The stub’s `SetMultiLine` is an allowed no-op, so `_multiline` is the harness equivalent the brief allowed. The type-guard is what Anniversary actually runs.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 936 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | 936 passed, 0 failed. Lua 5.1.5. Exit 0. |

**Isolated count:** 17 unique nil-module pins inside the opening `if standalone then` (Quiet shell, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Six loaded-module pins stay outside the wrap. B8-E re-pins Archive + Quiet shell. Standalone suite: **936 passed**.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Archive verbs not rewritten.
- Getters unchanged. Expected failures stay `nil, err`.
- `CopyToClipboard` is still the Archive blob only. No post-show ceremony summary. No `SendChatMessage`.
- `Console.SaveNote` remains nil. Source has no `WHISPER ALL` and no `SUMMON THE FAITHFUL`.
- Isolation asserts remain behind `if standalone then`.
- Existing Proposed Bout, favor, Post Decree, FREE RULING, Dismiss, Recommend, CallForward, MARK THIS MOMENT, honorific, Recognition, and B7-B Archive pins stayed green.

## Concerns

- Client `/reload` smoke was not run. `InputBoxTemplate` is a single-line visual (left/right caps); a 72px-tall box may look like a stretched one-liner on Anniversary. **POLISH:CANDIDATE** only.
- `DEFAULT_HEIGHT` grew 880 → 960 for the taller box plus two label rows. Glanceability on a 1080p Anniversary UI is unproven.
- `_multiline` is harness bookkeeping. The stub does not model `SetMultiLine` / `IsMultiLine` state. Production relies on the type-guarded client method.
- Labels sit **above** the boxes so the 560-wide blob field stays. Not the STIPULATION left-of-box pattern. Wording is exact `ARCHIVE` / `CANONIZE`.
- A long export string can still overflow 72px; clipboard remains the carry path when the Os API exists.
- Weekly Archive reminder (cold-only, §13.5) is not this lane.
- B8-E tests live in a nested `runB8E()` because the main chunk is already under Lua 5.1’s 200-local cap.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
