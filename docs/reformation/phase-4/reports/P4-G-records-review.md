# Phase 4 Lane G — Adversarial Review

**Lane:** Records Book superlatives
**Exclusive files:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`
**Lane report:** `docs/reformation/phase-4/reports/P4-G-records.md`
**Cited law:** Ten Laws 1, 6, 10; Bible §10.9, §14.2, §19.3; `.cursor/rules/records-not-points.mdc`; `.cursor/rules/ui-juice-standards.mdc`; `.cursor/rules/quiet-event-modes.mdc`; brief `docs/reformation/phase-4/briefs/P4-G-records.md`; OPEN_QUESTIONS #3 (veto list) and #9 (defenses empty)
**Writer:** [Records](f1369ae1-2568-402f-8fdf-79d8a08fc12e)

**Spec:** PASS
**Quality:** Approved

Player-opened Quiet identity/history. Theatrical parchment tome. Not a sortable ranked ladder. Bible pages only. Defenses empty (#9). Tournament Champions empty. Famous Upsets Pope-flagged only (never computed). Toggle / Show / Hide only. No slash, feed, auto-open, sound, points, standing, or Grant. Isolated suite: **248 passed, 0 failed**. Writer stayed inside exclusive files. Integrator already listed `UI/RecordsBook.lua` and `test_records` (writer leftover is stale). `OPEN_QUESTIONS.md` #3 and #9 unchanged. No commit. This review did not invent a defense increment, a tournament engine, or extra categories, and did not edit `RecordsBook.lua` or the suite.

## Verdict

Refutation of Laws 1, 6, 10, Bible §10.9 / §14.2 / §19.3, and “not a ranked ladder / Famous Upsets are Pope-flagged only” **fails** for this lane’s exclusive files.

Law 1 is intact on the terms the Bible and `records-not-points.mdc` set. Phase 0’s “no streaks” line does not ban Records Book Longest Streak. `ten-laws.mdc` already carves fight-record streaks and superlatives out of the points economy. There is no Grant, standing, XP, threshold, ELO, or “#1 rating.” Win / loss / streak / fought counts are measures on Bible-named superlative pages, not a wallet.

Law 6 and §14.2 are intact. `RecordsBook.MODE = "QUIET"`. The book is player-opened identity/history, not unbidden Quiet chrome. Init does not open it. File load does not create a frame. No feed, toast, pip, slash, or sound. Unbidden Quiet remains minimap + Decree — this file does not add those.

Law 10 and §19.3 are intact. The surface is the named theatrical Records Book: dark iron, muted gold edge, aged parchment, ecclesiastical title, seal texture object. Not `BasicFrameTemplate`. Custom title-font / seal paths are attempted; missing media does not fail load (`GameFont*` fallback). The UI itself never tells jokes. Martyr poetry is not generated.

§10.9 is intact. Nine Bible MVP names, in Bible order. Superlative holders (ties share; id order), not a sorted table of everyone. The Undefeated is an unbeaten set, id-ordered, not sorted by wins. Famous Upsets lists only `famousUpset == true`. Defenses and Tournament Champions stay empty. OPEN_QUESTIONS #3 is not resolved; no extra category was added.

This review did not invent a defense increment, a tournament engine, or a tenth page, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| Player-opened Quiet identity/history; theatrical; not a sortable ladder | **Yes.** `MODE = "QUIET"`. Init leaves the widget hidden. Show / Hide / Toggle only. No Sort / Ladder / Standing / #1 chrome. Prev / Next turn leaves. Title is “The Records Book.” Iron / gold / parchment / seal exist. Not `BasicFrameTemplate`. |
| Bible pages only; Defenses empty (#9); Tournament Champions empty; Famous Upsets flagged only | **Yes.** Exactly the nine §10.9 titles. `put("Most Successful Defenses", {})` — Lord wins and Cowardice after `elevationAt` still empty; Store `defenses` stays nil. Tournament Champions stays `{}`. Fresh Beef beating a Lord is not listed unless `famousUpset == true`. String `"true"` / `1` do not count. |
| Toggle / Show / Hide only; no slash, feed, auto-open, sound, points, standing, Grant | **Yes.** Public surface: `MODE`, `Init`, `Show`, `Hide`, `Toggle`, `IsShown`, `GetPages`, `ResetForTests`. `Grant` / `Standing` / `ComputeFamousUpsets` / `RecordDefense` / `AddTournamentChampion` / `SortPages` / `Narrate` / `SLASH_*` are nil. Suite + reviewer: `PlaySound*` stay 0; no `OnUpdate`. Show / Hide do not write Store wins or results. |
| Isolated suite green | **Yes.** Reviewer rerun: `lua tests/test_records.lua` → **248 passed, 0 failed** (Lua 5.1.5). Loads wow_ui_stub + Common + Ranks + Store + RecordsBook. Isolation asserts wrapped in `if standalone then`. Writer count matches. Full harness (integrator list): **5248 / 0**. |
| Writer did not edit TOC / bootstrap / `run.lua` / MainFrame / Store | **Yes.** Transcript Writes: `tests/test_records.lua` (first; RED on missing module), `UI/RecordsBook.lua`, this lane’s report. Store mtime Aug 14; bootstrap Aug 14; MainFrame Aug 14. TOC 07:31:56 and `run.lua` 07:29:32 list `UI\RecordsBook.lua` / `test_records` — integrator, not the writer. `OPEN_QUESTIONS.md` #3 / #9 text unchanged (mtime 07:23, Read only). No commit (`RecordsBook.lua` still untracked). |

## Attack results

| Attack | Result |
|---|---|
| Law 1 — Longest Streak is the banned streak economy? | **No.** Bible §10.9 names the page. `ten-laws.mdc` / `records-not-points.mdc`: sanctioned-Gora W/L streak is a narrative record, not engagement / favor / login. Peak is read from `gora.results` (`won == true` runs; `won == false` breaks; void skipped). Live `gora.streak` is not the page. Reviewer: Cowardice (`won = false`) breaks the run. |
| Law 1 — “Name — 3” on Victories / Chin / Martyr is points / standing? | **No.** Superlative measure on the holder(s) only. No Grant, wallet, threshold, daily, or `#1 rating`. Ties share the hold; lesser counts are not runner-up rows. OPEN_QUESTIONS #3 is untouched. |
| Law 1 / Law 2 — computing max across characters is an activity leaderboard? | **No.** §10.9 replaces the ranked ladder with superlatives. These are sanctioned-Gora event records, not hours / combat minutes / contribution. `maxHolders` lists only the max; it does not sort the guild. |
| Law 6 — a Records Book is ambient Quiet chrome / a dashboard? | **No.** quiet-event-modes: player-opened Quiet is identity/history per §14.2. Unbidden chrome is still only minimap + Decree. This file does not add those. Init does not Show. TOC load does not Init. |
| Law 6 — `GetPages` is a feed / auto-open / Quiet toast? | **No.** Pull getter for paint and tests. No toast, pip, sound, or slash. Show is an explicit call. |
| Law 6 — hidden DIALOG frame after Init is “just a small always-visible panel”? | **No.** Hidden until Show. Integrator has not wired Init on login. Do not add always-visible chrome “for usability.” |
| Law 10 — color fills without shipped Media fail ecclesiastical identity? | **No as this lane.** Exclusive files only; no Media tree. Paths are attempted; `GameFont*` fallback; seal object still exists. Missing media must not fail load — it does not. `POLISH:CANDIDATE` only. |
| Law 10 / Law 4 / §10.9 — Martyr is name + count, so “presented with love” / narrative framing is missing? | **No.** The page title *is* the frame. Generated “fallen / risen / Goldshire” copy would be Law 4 narration and invented flavor. Suite locks that poetry out. Do not invent martyr scripture here. |
| Law 10 — the UI tells a joke? | **No.** Chrome is “The Records Book”, “Previous”, “Next”, “Close”. Empty leaves have no invented copy. No meme clutter. |
| §10.9 — The Undefeated lists everyone unbeaten, so it is a ladder? | **No.** Bible: “active unbeaten records.” A set, id-ordered. Reviewer: 1-win then 3-win (ids 1 then 2), not sorted by wins. Body paints names only. `wins >= 1` and `losses == 0`; 0–0 is excluded. |
| §10.9 — Famous Upsets are computed from rank or level? | **No.** Unflagged Fresh 60 vs Lord 70 is empty. Only `famousUpset == true`. No `ComputeFamousUpsets`. Lane C still writes the flag false unless a later Pope verb sets it. |
| §10.9 / #9 — Lord wins / Cowardice after `elevationAt` should fill Defenses now that #9 is resolved? | **No as this lane.** Brief: omit or show empty; do not invent an increment. Store still nils `defenses`. Implementing #9 here would invent the derived stat in UI. Page stays empty. `#9` text unchanged. |
| §10.9 / §11 — Tournament Champions empty is a miss because hand-run tournaments exist? | **No.** Brief: empty until tournaments exist. Do not invent an engine. `AddTournamentChampion` is nil. This review does not add a Pope-flag for champions. |
| §14.2 — no slash / minimap hook means records are not “browsable” on a Tuesday? | **Leftover, not a miss.** Brief forbids a new slash and forbids MainFrame / Minimap edits. A later integrator may reach this book from the identity path. Do not invent that here. |
| “Not a ranked ladder” — Prev / Next and tied holders are place numbers? | **No.** Leaves, not ranks. Tied holders are id-ordered and share the same measure. `place` / `rank` / `rating` stay nil. |
| “Famous Upsets Pope-flagged only” — `won == false` swap computes the upset? | **No.** The flag is already on the result. The swap names the flagged pairing’s winner for display. It does not decide whether the bout is an upset. |
| Writer invented a tenth category, a defense increment, a tournament engine, edited forbidden files, or committed? | **No.** Exclusive Writes only. `#3` / `#9` unchanged. No commit. |

Refutation of Law 1 (no points economy; Longest Streak is the Bible narrative record), Law 6 (player-opened Quiet identity/history; no unbidden chrome), Law 10 (theatrical parchment; UI never jokes), Bible §10.9 (superlatives, not a `#1` ladder; flagged upsets only; Defenses / Tournament empty), §14.2 (browsable records, otherwise silent), §19.3 (ecclesiastical Records Book; missing media must not fail load), and “not a ranked ladder / Famous Upsets are Pope-flagged only” **fails** for the exclusive files.

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current except the integrator listing (already done).

### Integrator (already landed — writer report is stale)

- `ChurchOfBeef.toc` lists `UI\RecordsBook.lua` after `Hud.lua`, before `Status.lua`. Interface stays `20506`.
- `tests/run.lua` lists `test_records`. Writer did not edit either file.
- Bootstrap / MainFrame / Minimap / Console still do not call `Show` / `Toggle`. Correct until an identity-path host exists. `/beef` still opens the Quiet shell.

### Entry (do not invent here)

- No slash, no minimap hook, no MainFrame host. §14.2 “browsable” is a later integrator reach from the minimap / identity path. Do not add `/records` or always-visible chrome.

### Famous Upsets flagging (other lanes)

- This lane only displays `famousUpset == true`. Lane C left the flag false unless a later Pope verb sets it. Do not compute the flag from rank or level.

### #9 / tournaments (do not invent here)

- Most Successful Defenses stays empty until a derived defense stat exists. Store still nils `defenses`. Do not increment from `elevationAt` in this UI.
- Tournament Champions stays empty until tournaments exist (§11). Do not invent an engine or a champion writer.
- OPEN_QUESTIONS #3 remains a veto list. Bible names shipped; no added “#1 rating.”

### Out of scope (do not invent here)

- Defense increment, tournament engine, extra categories, martyr poetry, personal profile page, Curtain UX, honorific Grant from this book.

## Findings

### Critical

None. No one-line Law 1, Law 6, Law 10, §10.9 / §14.2 / §19.3, or “ranked ladder / computed Famous Upsets” breach in the exclusive files. No defense increment, tournament engine, or extra category.

### Important

1. **A Pope-flagged void is painted as “Name over Opponent.”** Reviewer probe: both sides `ruling = "void"` + `famousUpset = true` → one Famous Upsets row, body `VoidA over VoidB`. The flag is still Pope-only (not computed from rank/level). The `won == false` swap treats `won == nil` as a win for the first id-ordered character. That is display copy, not a Store write and not a new category. Do not “fix” it by computing upsets or inventing a void-upset product rule. A later paint pass may need void-safe copy. Not a spec fail.

2. **These pages are unreachable in the client until an integrator hosts them.** Correct: brief forbids slash / MainFrame / Minimap. Writer leftover about TOC / `run.lua` is stale — both already list the new files. Bootstrap still does not Init/Show. Do not add a Quiet feed to make the book “discoverable.”

3. **§10.9 “presented with love” is the page title + parchment, not generated narration.** Name + count on The Glorious Martyr is the Law 4 / brief-safe path. Do not invent Goldshire poetry in review.

4. **Integrator leftover in the writer report is stale.** TOC and `run.lua` already list the new files. Isolated 248 / 0 still matches. Full harness 5248 / 0 includes `test_records`. Not a writer miss.

### Nit

1. **Famous Upsets are listed in character-id then result order, not by `at`.** Still a flagged set, not a ranking. Do not add a Sort.

2. **The Undefeated entries carry a `wins` field the body does not paint.** Id order is locked. Do not start sorting that field.

3. **`ChurchOfBeefDB.ui.recordsBook` is created on drag-stop** when `ChurchOfBeefDB.ui` already exists. Position only (wow-ui-taint). Does not create the SV root. Not a Store write.

4. **Custom Media paths are not on disk.** Exclusive files only. Fallback holds. `POLISH:CANDIDATE`; no `/reload` smoke by the writer.

5. **Isolation asserts are skipped in the harness** (`if standalone then`). Correct wrap. Isolated run still locks Runtime / Gora / Officer / UI / Net / DB / Sender / Minimap / Toasts / Console / Hud at `nil`.

6. **Longest Streak uses the result log, not live `gora.streak`.** Writer disclosed it. Peak vs current run is the Bible page, not a new category.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated wow_ui_stub + Common + Ranks + Store + RecordsBook; isolation asserts in `if standalone then` | Met (248 / 0). Transcript: suite first (RED on missing `RecordsBook.lua`), then the module. |
| Player-opened Quiet identity/history; theatrical; not a sortable ranked ladder | Met |
| Bible MVP pages only; no “#1 rating”; OPEN_QUESTIONS #3 is a veto list | Met |
| Most Successful Defenses omit or empty; do not invent an increment (#9) | Met |
| Famous Upsets Pope-flagged only; never compute | Met |
| Tournament Champions empty; no tournament engine | Met |
| Toggle / Show / Hide only; no slash, feed, auto-open, sound, points, standing, Grant | Met |
| UI never writes Store outcomes; getters return copies | Met |
| Do not edit TOC / bootstrap / `run.lua` / MainFrame / Console / Hud / Store / Net | Met (integrator listed after) |
| Isolated `test_records.lua` must pass | Met (248 / 0) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 1, 6, 10
- Brief `docs/reformation/phase-4/briefs/P4-G-records.md`
- Writer report `docs/reformation/phase-4/reports/P4-G-records.md`
- Bible §10.9, §14.2, §19.3 (also §4.8 / §19.1 / §11 / §22.1 item 8 as cited by those)
- `.cursor/rules/records-not-points.mdc`
- `.cursor/rules/ui-juice-standards.mdc`
- `.cursor/rules/quiet-event-modes.mdc`
- `addon/ChurchOfBeef/UI/RecordsBook.lua`
- `tests/test_records.lua` (isolated run: 248 / 0)
- `addon/ChurchOfBeef/Core/Store.lua` `RecordGoraResult` / `famousUpset` / `defenses = nil` / `Snapshot` (read only; mtime Aug 14)
- Writer transcript ([Records](f1369ae1-2568-402f-8fdf-79d8a08fc12e)) — exclusive Writes only
- `ChurchOfBeef.toc` / `tests/run.lua` (integrator listing; writer did not edit)
- `ChurchOfBeef.lua` / `UI/MainFrame.lua` / `UI/Console.lua` / `UI/Hud.lua` (no RecordsBook calls)
- `docs/design/OPEN_QUESTIONS.md` (#3 veto unchanged; #9 defense definition unchanged; no increment here)
- Reviewer probes (throwaway; suite not edited): flagged void paints “over”; string/`1` flag ignored; Lord + Cowardice after elevation still empty Defenses; unbeaten id-ordered not win-sorted; Show does not write Store; no-Store pages empty; public API is Toggle/Show/Hide/GetPages only; no Media tree
