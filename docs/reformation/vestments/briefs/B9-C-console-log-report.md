# B9-C — Console ceremony log desk (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 (“what just happened?”); Law 4 / §18.2 (software never narrates; no generated knighting prose); Law 10 / §19.3 (Director Console stays stock-pragmatic); CONTINUE 2026-08-18 (no SUMMON; no post-show clipboard; `SaveNote` stays nil; Console stays plain); brief `docs/reformation/vestments/briefs/B9-C-console-log.md`.

Director Console stays stock-pragmatic. `GetCeremonyLog()` copies `Store:GetCeremonyLog()` newest first when that API exists, else `{}`. Each painted row is existing fields only: `entry.type`, type-routed names, and `entry.text` when present. Knighting / Elevation → `GetHuman` only; victor / cowardice / void / free / Gora → `GetCharacter` only; Recognition → first id `GetCharacter`, later ids `GetHuman`; unknown type → `GetCharacter` then `GetHuman`. No “ordained.” No Proclaim. No Sound on paint. Missing Store log is an empty list. `SaveNote` stays nil. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

Review must-fix (Spec FAIL): human and character ids are independent sequences. `participantName` now takes `kind` and `index` from `ceremonyLine` and routes by `entry.type`. Collision pin: `seedLinked("Beefina", "Steve")` + `victor` with the character id paints Beefina and not Steve.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_console.lua` | TDD first. Nested inside `runB8E()` (Lua 5.1 200-local cap): empty / missing Store log; seed `AppendCeremony` rows show type tokens and names, not `ordained`; newest first; Pope text on `free` only; collision pin `seedLinked("Beefina", "Steve")` + `victor` paints Beefina not Steve; SaveNote nil; no SUMMON / COPY SUMMARY / WHISPER ALL; ritual plates unchanged; isolation wrap re-pin. |
| `addon/ChurchOfBeef/UI/Console.lua` | Stock `CeremonyLog` header + `scrollList`. `GetCeremonyLog` / type-routed `participantName(id, kind, index)` / `ceremonyLine` / `paintCeremonyLog`. `DEFAULT_HEIGHT` 960 → 1050. `SaveNote` and ritual plates untouched. |
| `docs/reformation/vestments/briefs/B9-C-console-log-report.md` | This file |
| `docs/reformation/vestments/briefs/B9-C-console-log.diff` | B9-C-only unified diff of the exclusive files vs the pre-lane baseline |

Did not edit Store, Knighting, Gora, TOC, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

| Surface | Role |
|---------|------|
| `GetCeremonyLog()` | Copies `Store:GetCeremonyLog()` reversed (newest first). Missing Store / missing getter / non-table → `{}`. Mutating a copy does not rewrite Store. |
| `CeremonyLog` | Stock `GameFontNormal` header + `UIPanelScrollFrameTemplate` list (`GameFontHighlightSmall`). Same `scrollList` furniture as Presence / petitions. |
| Row paint | `type` token, then type-routed names (`ceremonyLine` passes `kind` + index), then optional Pope `text`. No generated prose. |
| `SaveNote` | nil |

### Desk

- Console stays stock. No custom media. No parchment.
- No SUMMON. No post-show ceremony summary. No WHISPER ALL.
- Ritual plates unchanged. Paint does not Proclaim or Play Sound.
- Existing desks, honorific, Recognition, Recommend, Archive, and `after()` cues stay.

## TDD

1. Extended `test_console.lua` first (API, empty/missing Store, seeded types + names, newest first, Pope text, SaveNote nil, isolation wrap, source greps). Isolation stayed under `if standalone then`. B9-C lives inside `runB8E()` (Lua 5.1 200-local cap).
2. Implemented `Console.lua`.
3. Green: `lua tests/test_console.lua` — **1021 passed, 0 failed**. Collision pin added after Spec FAIL.

Seeded rows use `Store:AppendCeremony` only. This lane does not edit Knighting or Gora.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_console.lua   # 1021 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_console.lua` standalone | 1021 passed, 0 failed. Lua 5.1.5. Exit 0. |

**Isolated count:** 17 unique nil-module pins inside the opening `if standalone then` (Quiet shell, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Six loaded-module pins stay outside the wrap. B9-C re-pins Archive + Quiet shell + Toasts. Standalone suite: **1021 passed**. Collision pin confirmed: `seedLinked("Beefina", "Steve")` + `victor` { character id } paints Beefina and does not paint Steve.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Store / Knighting / Gora not edited.
- Getter returns copies, newest first. Expected missing-log path is `{}`.
- Paint uses existing fields only, routed by `entry.type`. Collision pin: victor + character id paints Beefina, not Steve. No `ordained`, no knighting prose, no Proclaim, no Sound.
- `Console.SaveNote` remains nil. Source has no `WHISPER ALL` and no `SUMMON THE FAITHFUL`.
- Isolation asserts remain behind `if standalone then`.
- Existing Proposed Bout, favor, Post Decree, FREE RULING, Dismiss, Recommend, CallForward, MARK THIS MOMENT, honorific, Recognition, and Archive pins stayed green.

## Concerns

- Client `/reload` smoke was not run. `DEFAULT_HEIGHT` grew 960 → 1050 to fit a 70px log above Decree. Glanceability on a 1080p Anniversary UI is unproven. **POLISH:CANDIDATE** only.
- Human and character ids remain independent sequences. Type routing is the fix; unknown types still try `GetCharacter` then `GetHuman`. A later rite token that is not in the closed set would use that fallback.
- The list is a FontString body (confession-style) on Presence/petition `scrollList` furniture, not click-to-select row buttons. The log is not a selection desk.
- Empty paint uses the stock line `No ceremony yet.` Missing Store log is still an empty getter list.
- B9-C tests live inside `runB8E()` because a second main-chunk `local function` exceeded Lua 5.1’s 200-local cap.
- Weekly Archive reminder, Notebook persist, and post-show summary stay out of this lane.

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
