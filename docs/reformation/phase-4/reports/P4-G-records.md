# Phase 4 Lane G — Records Book (superlatives, not a ladder)

**Status:** DONE

**Cited:** Ten Laws 1, 6, 10; Bible §10.9, §14.2, §19.3; `.cursor/rules/records-not-points.mdc`; `.cursor/rules/ui-juice-standards.mdc`; `.cursor/rules/quiet-event-modes.mdc`; brief `docs/reformation/phase-4/briefs/P4-G-records.md`. Store already has character Gora rows (`wins` / `losses` / `streak` / `headToHeads` / `results` with `famousUpset`). OPEN_QUESTIONS #3 is a veto list — Bible MVP names shipped, no "#1 rating."

Player-opened Quiet identity/history. Theatrical parchment. Not a sortable ranked ladder. The UI never tells jokes. No points, standing, or Grant. Toggle / Show / Hide only. No feed. No auto-open. No sound. No slash. TOC / bootstrap / `tests/run.lua` / MainFrame / Console / Hud / Store / Net / `OPEN_QUESTIONS.md` not edited. No commit.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_records.lua` | Created first. Isolated suite: wow_ui_stub + Common + Ranks + Store + RecordsBook. Standalone wrap. Isolation asserts in `if standalone then`. |
| `addon/ChurchOfBeef/UI/RecordsBook.lua` | Created after the suite. Parchment tome; pages from Store. |
| `docs/reformation/phase-4/reports/P4-G-records.md` | This file |

## Mode

**Quiet Mode**, player-opened identity/history (Bible §14.2 / Law 6). `RecordsBook.MODE = "QUIET"`. Not Event theater. Not an always-visible surface. Init does not open the book. Unbidden Quiet chrome is still only minimap + Decree — this file does not add those.

Theatrical (Law 10 / §19.3): dark iron, muted gold edge, aged parchment, ecclesiastical title. Not `BasicFrameTemplate`. Custom title font / seal paths are attempted; missing media does not fail load (`GameFont*` fallback; seal texture object still exists). The UI itself never tells jokes. No generated martyr poetry.

## Pages (Bible §10.9, from Store)

Display only. UI never writes Store.

| Page | Source | Notes |
|------|--------|-------|
| Most Sanctioned Victories | max `gora.wins` | Superlative holder(s). Ties share; id order. Not a ladder of everyone. |
| Longest Streak | longest consecutive `won == true` run in `gora.results` | Sanctioned-Gora W/L only. Void does not break the run. Peak from the log, not only the live `streak` field. |
| Most Successful Defenses | empty | OPEN_QUESTIONS #9. Lord wins after `elevationAt` do not invent an increment. |
| The Iron Chin | max `#gora.results` | Most Goras fought. Voids count. |
| Greatest Rivalry | max `headToHeads.fights` pairing | Running score from that pairing. One-off pairings are not listed unless they are the max. |
| Famous Upsets | `results` with `famousUpset == true` | Pope-flagged only. Never computed from rank or level. |
| The Undefeated | `wins >= 1` and `losses == 0` | A set, id-ordered, not sorted by wins. |
| The Glorious Martyr | max `gora.losses` | Title is the frame; body is name + count. |
| Tournament Champions | empty | No tournament engine. |

Tombstoned characters still hold records (Law 7). Getters return copies.

## API

| Method | Role |
|--------|------|
| `MODE` | `"QUIET"` |
| `Init()` | Builds the hidden tome once. Idempotent. |
| `Show()` / `Hide()` / `Toggle()` | Player-opened only. Return true. No sound. |
| `IsShown()` | Widget visibility. |
| `GetPages()` | Copy of the nine Bible pages from `Store:Snapshot()`. |
| `ResetForTests()` | No-op unless `COB._IN_TEST`. Closes the book; page 1. |

No Grant, Standing, ComputeFamousUpsets, RecordDefense, AddTournamentChampion, or SortPages. Previous / Next turn leaves; they do not rank. Close hides. Escape via `UISpecialFrames`.

## Verification

- Isolated suite (`wow_ui_stub` + `Core/Common.lua` + `Data/Ranks.lua` + `Core/Store.lua` + `UI/RecordsBook.lua`): **248 passed, 0 failed**.
- Lua 5.1.5. `lua tests/test_records.lua` exits 0.
- No `dofile` of MainFrame / Console / Hud / Minimap / Toasts / BeefNet / DB / Runtime / Gora / Knighting / Officer / bootstrap / `tests/run.lua`.
- No slash. No `PlaySound`. No permanent `OnUpdate`. Show / Hide do not write Store.

**POLISH:CANDIDATE** only. This file is not in the TOC, so it was not installed and not `/reload` smoked. A human signs `POLISH:PASS`. Do not claim V1 / MVP complete (Bible §22.3).

## Leftovers (other lanes — not fixed)

- **Integrator:** add `UI/RecordsBook.lua` to `ChurchOfBeef.toc` (file exists now). Add `test_records` to `tests/run.lua`. Until then, `lua tests/run.lua` will report the new file as unlisted. Do not treat that as a product miss.
- **Entry:** no slash, no minimap hook, no MainFrame host. `/beef` still opens the empty Quiet shell. A later integrator may reach this book from the minimap / identity path (§14.2). Do not invent that here.
- **Famous Upsets flagging** is a Pope verb on a Store result. This lane only displays the flag. Lane C left `famousUpset` false unless a later lane sets it.
- **Defenses** stay empty until a derived defense stat exists (OPEN_QUESTIONS #9).
- **Tournament Champions** stay empty until tournaments exist (§11).
- OPEN_QUESTIONS #3 (category veto) is unchanged. Bible names shipped; no added "#1 rating."

## Concerns

- Longest Streak reads the result log for the peak sanctioned win run. Store's live `gora.streak` is the current run and can be a loss after a longer peak. That is display from stored results, not a new category.
- Greatest Rivalry uses character-id order for the two names (stable, not a ranking of who is "ahead"). The running score is still shown.
- Custom Media paths are not shipped in this lane (exclusive files only). Missing textures/fonts must not fail load; they do not.
- `OPEN_QUESTIONS.md` was not edited. Client smoke and a human Gathering (Bible §22.3) were not run.
