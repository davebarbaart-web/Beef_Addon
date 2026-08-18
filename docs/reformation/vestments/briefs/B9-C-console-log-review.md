Spec PASS

# B9-C — Console ceremony log desk (review)

**Quality:** Approved-with-nits

**Current verdict:** Rereview after must-fix. First review was Spec FAIL (GetHuman-first painted colliding human names on Gora rows). Writer now type-routes `participantName`. See **Rereview** below. The first-pass body is kept as history.

**Lane:** B9-C Console ceremony log desk (stock)
**Brief:** `docs/reformation/vestments/briefs/B9-C-console-log.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B9-C-console-log-report.md`
**Diff:** `docs/reformation/vestments/briefs/B9-C-console-log.diff` (stale — still shows GetHuman-first; live files were re-read)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

---

# First review (Spec FAIL)

**Quality:** Changes-requested

Task-scoped gate only. Reviewer read the brief, the writer report, the exclusive-pair diff, `UI/Console.lua` (`GetCeremonyLog` / `ceremonyLine` / `participantName` / `paintCeremonyLog` / `SaveNote` / CeremonyLog furniture), and `tests/test_console.lua`; then ran `lua tests/test_console.lua` and a throwaway name-collision probe that does not live in the exclusive files. Law cited: Bible §18.1 (“what just happened?”); Law 4 / §18.2 (software never narrates; no generated knighting prose); Law 10 / §19.3 (Director Console stays stock-pragmatic); CONTINUE 2026-08-18 (no SUMMON; no post-show clipboard; `SaveNote` stays nil; Console stays plain). Did not mutate addon code. Did not edit Store, Knighting, or Gora. Did not commit. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Stock list, newest first | **Pass.** `GetCeremonyLog` copies `Store:GetCeremonyLog()` reversed (`#log` down to 1). Missing Store / missing getter / non-table → `{}`. Store itself stays oldest-first (suite pin). Furniture is `header("CeremonyLog")` + `scrollList` / `UIPanelScrollFrameTemplate` / `GameFontHighlightSmall` — same helper as Presence / petitions / Confession. |
| Type + names + optional Pope text; no invented narration | **Fail.** Row paint is `entry.type`, then names, then `entry.text` when present, joined by two spaces. No `ordained`, no “The Pope knighted…”, no Proclaim, no Sound on paint. **Names are not the matching participant.** `participantName` tries `GetHuman` then `GetCharacter`. Human and character ids are separate sequences that both start at 1, so id N exists in both tables after the first linked pair. B9-A appends `{ humanId }`; B9-B appends character ids (`victor` / `cowardice` / `void` / `free`). A reviewer probe (`Steve` human 1, `Beefina` character 1) painted `victor  Steve` — the human — not `victor  Beefina`. The suite hid this with `seedLinked("Beefina")` (same name both sides) and `assert_eq(h2.id, c2.id)`. |
| `SaveNote` nil; no SUMMON; no post-show clipboard | **Pass.** `Console.SaveNote` / `GetNotes` / `CopyCeremonySummary` / `CeremonySummary` are nil. No `SUMMON THE FAITHFUL`, `COPY SUMMARY`, or `WHISPER ALL` chrome. Source has no `function Console:SaveNote`. The only `CopyToClipboard` site is still the Archive-export blob. |
| Isolated green | **Pass (suite).** Reviewer ran `lua tests/test_console.lua`: **1010 passed, 0 failed**, exit 0. Isolation cluster is still `if standalone then` (17 nil-module pins at file load). B9-C re-pins Archive + Quiet shell + Toasts inside `runB8E()`. That green run does not cover the colliding-id name case. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Store, Knighting, Gora; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/Console.lua` and `tests/test_console.lua`. |
| Console stays stock; `SaveNote` stays nil; no WHISPER ALL; no post-show summary; no SUMMON | **Pass.** New chrome is one `GameFontNormal` header plus the existing `scrollList` furniture. No parchment, QuestBG, custom media, jokes, `OnUpdate`, or `UIParent:SetScale`. Named-risk check for SaveNote, clipboard, and SUMMON. |
| Stock scroll list `CeremonyLog`, newest first; same furniture pattern as Presence / petitions | **Pass.** Named-risk check. Paint is confession-style FontString, not click-to-select row buttons. The log is not a selection desk. See leftover. |
| Each row paints existing fields only: `entry.type`, names from `GetHuman` / `GetCharacter` when the id matches, `entry.text` when present | **Fail.** Type token and Pope `text` are existing fields. The slash in the brief is the two lookup APIs, used **when the id matches that table**. GetHuman-first treats a character id as a human id whenever both namespaces hold N — the normal Store case, not an edge. Painted names can be the wrong person. |
| Do not invent “The Pope knighted…”. Do not Proclaim. No Sound. Missing Store log → empty list | **Pass.** Getter `{}` on missing Store / getter. Empty paint uses the stock empty line `No ceremony yet.` (same furniture class as `No petitions.` / `No confessions.`). `Console.Proclaim` is nil. Refresh-with-seeded-log Play count is 0. |
| Tests: seed `AppendCeremony` rows → type tokens and names, not `ordained`; SaveNote nil; isolation wrap stays; ritual plates unchanged; `lua tests/test_console.lua` exit 0 | **Partial.** Types, newest-first, Pope text, SaveNote, isolation, and ritual plates are pinned. The name pin is satisfied by matching-name fixtures and does not prove the matching table. Isolated **1010 / 0** was re-run here. |

Bible §18.1 (the desk answers “what just happened?”), Law 4 / §18.2 (no generated prose), Law 10 / §19.3 (stock desk), and CONTINUE (no SUMMON; no post-show clipboard; `SaveNote` nil) are met **except** the name half of “type + names.” A victor line that paints the colliding human is a wrong answer to “what just happened?”

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; `DEFAULT_HEIGHT` 960 → 1050 unproven on 1080p Anniversary UI | **Not a spec miss.** Brief asked isolated `tests/test_console.lua`. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| Human and character ids are separate namespaces; GetHuman-first; matching-name `seedLinked` so the paint pin is unambiguous | **Spec miss.** Brief said names from `GetHuman` / `GetCharacter` **when the id matches**. Matching-name fixtures make a false match look green. Must-fix. |
| FontString body (confession-style), not click-to-select row buttons | **Not a miss.** Brief asked Presence/petition **furniture** (`scrollList`). The log is not a selection desk. See leftover. |
| Empty paint uses `No ceremony yet.`; missing Store log is still `{}` | **Not a miss.** Getter contract is the empty list. Empty-state copy matches other stock desks. |
| B9-C tests live inside `runB8E()` (Lua 5.1 200-local cap) | **Not a miss.** Suite still ran. See leftover. |
| Weekly Archive reminder, Notebook persist, and post-show summary stay out | **Not a miss.** CONTINUE forbids those here. |

---

## Strengths

- Getter is fail-closed and newest-first. Missing Store / missing `GetCeremonyLog` / non-table → `{}`. A mutated copy does not rewrite Store.
- Paint concatenates existing fields only. No knighting prose, no `ordained`, no `at` / id decoration, no Proclaim, no Sound.
- `SaveNote` is still absent. There is no second clipboard, no ceremony-summary method, and no SUMMON chrome. `CopyToClipboard` is still one guarded `pcall` of the Archive blob.
- Ritual plates, EditBox count (7), and isolation wrap stayed. Isolated **1010 / 0** was re-run here.

---

## Issues

### Must-fix (Critical / Important)

1. **Important — colliding store ids paint the wrong name.** `participantName` returns `GetHuman(id).name` whenever that row exists, and only then tries `GetCharacter`. `Store` human ids and character ids are independent counters (`nextHumanId` / `nextCharacterId` both start at 1). After any linked pair, id N is a valid human **and** a valid character. B9-A writes `AppendCeremony("Knighting"\|"Elevation", { humanId }, now)`. B9-B writes `victor` / `cowardice` / `void` / `free` with character ids. Reviewer probe (not checked in): human `Steve` id 1, character `Beefina` id 1 → painted body was `victor  Steve` / `Knighting  Steve`. The fighter on the victor row is Beefina. Suite `seedLinked("Beefina")` names both sides the same and pins `h2.id == c2.id`, so **1010 / 0** does not prove names.

   Console-only fix (do not edit Store): resolve by `entry.type` — `Knighting` / `Elevation` → `GetHuman`; `victor` / `cowardice` / `void` / `free` → `GetCharacter`. Pin with `seedLinked("Beefina", "Steve")` so Knighting paints `Steve` and victor paints `Beefina`. Drop the matching-name fixture as the name proof.

### Leftover (Minor)

1. **`DEFAULT_HEIGHT` 1050 is unsmoked.** The extra 90px fits a 70px log above Decree. Whether a 1050-tall console fits a default-scale Anniversary UI was not walked. **POLISH:CANDIDATE** only.

2. **Header comment still says CeremonyLog is click-to-select.** `frame.CeremonyLogRows` is allocated and never painted. Dead pool, not a second desk.

3. **Painted-line format is substring-only.** `body:find("free")` / `find("Beefina")` would still pass if glue words appeared between tokens. After the name fix, pin the exact FontString line.

4. **`GetCeremonyLog` copies are shallow `pairs`.** Store already deep-copies. Nested `participantIds` on a held copy aliases that discarded getter result, not live Store. Fine today.

5. **Nested `runB8E()`** is a Lua 5.1 local-cap workaround. Fine as long as the next console lane does not add another 80 locals to the main chunk.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **1010 / 0** was re-run here. Client path was not.

---

## Assessment

**Spec FAIL. Quality: Changes-requested.**

**Must-fix:**

1. Resolve ceremony participant names by the matching store namespace (type-route `Knighting`/`Elevation` → human, Gora rulings → character). Pin with different human vs character names. Do not treat GetHuman-first plus matching-name `seedLinked` as proof.

Stock newest-first list, type token, optional Pope text, `SaveNote` nil, no SUMMON, and no post-show clipboard are in place. The desk still fails §18.1 when a Gora row’s character id collides with a human id — the default Store case.

Isolated `lua tests/test_console.lua` **1010 passed, 0 failed**, exit 0. Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.

---

# Rereview (must-fix: type-routed names)

**Spec PASS. Quality: Approved-with-nits.**

Task-scoped gate only. Reviewer re-read the brief, the updated writer report, live `UI/Console.lua` (`participantName(id, kind, index)` / `ceremonyLine` / `paintCeremonyLog` / `GetCeremonyLog`), and the B9-C block in `tests/test_console.lua`; then re-ran `lua tests/test_console.lua` and a throwaway collision probe that does not live in the exclusive files. Did not edit `Console.lua` or `test_console.lua`. Did not edit Store, Knighting, or Gora. Did not commit. This rereview does not sign the lane.

The checked-in `B9-C-console-log.diff` still shows the first-pass `participantName(id)` GetHuman-first helper. Live code was the source of truth.

---

## Named risks

| Risk | Verdict |
|---|---|
| Stock list, newest first | **Pass.** Unchanged. Getter copies Store reversed; missing Store / getter / non-table → `{}`; Store stays oldest-first. Furniture is still `header("CeremonyLog")` + `scrollList`. |
| Type + names + optional Pope text; matching namespace | **Pass.** `ceremonyLine` passes `row.type` and the id index into `participantName`. Closed producers: `Knighting` / `Elevation` → `GetHuman` only; `victor` / `cowardice` / `void` / `free` / `Gora` → `GetCharacter` only; `Recognition` → first id `GetCharacter`, later ids `GetHuman` (matches `Recognition:Complete` `{ characterId, humanId }`). Unknown type falls back to character then human. No `ordained`, no “The Pope knighted…”, no Proclaim, no Sound on paint. |
| Colliding human/character ids | **Pass.** Suite pin exists: `seedLinked("Beefina", "Steve")` (human `Steve`, character `Beefina`, `collideHuman.id == collideChar.id`), `AppendCeremony("victor", { collideChar.id })`, painted body contains `Beefina` and does not contain `Steve`. Reviewer probe (not checked in) with the same fixture: ids collide at 1; `victor` / `cowardice` / `void` / `free` paint `Beefina`; `Knighting` / `Elevation` paint `Steve`; `Recognition` paints `Beefina  Steve`. The first-pass `victor  Steve` failure is gone. |
| `SaveNote` nil; no SUMMON; no post-show clipboard | **Pass.** Unchanged. `SaveNote` / `GetNotes` / `CopyCeremonySummary` / `CeremonySummary` are nil. Source has no `function Console:SaveNote`, `SUMMON THE FAITHFUL`, `WHISPER ALL`, `CopyCeremonySummary`, `ordained`, or “The Pope knighted”. |
| Isolated green | **Pass.** Reviewer ran `lua tests/test_console.lua`: **1021 passed, 0 failed**, exit 0. Isolation wrap is still `if standalone then` (17 nil-module pins at file load). B9-C still re-pins Archive + Quiet shell + Toasts inside `runB8E()`. Writer-reported 1021 / 0 matches. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Store, Knighting, Gora; no commit | **Pass.** This rereview read only the exclusive pair plus Store/Knighting/Gora/Recognition as producers. No addon edits. No commit. |
| Console stays stock; `SaveNote` stays nil; no WHISPER ALL; no post-show summary; no SUMMON | **Pass.** First-review named-risk check still holds. |
| Stock scroll list `CeremonyLog`, newest first; same furniture as Presence / petitions | **Pass.** Unchanged. |
| Each row paints existing fields only: `entry.type`, names from `GetHuman` / `GetCharacter` **when the id matches**, `entry.text` when present | **Pass.** Type-route is the match. A colliding numeric id no longer resolves through the wrong table. Pope `text` still appends only when present. |
| Do not invent “The Pope knighted…”. Do not Proclaim. No Sound. Missing Store log → empty list | **Pass.** Unchanged. |
| Tests: seed `AppendCeremony` rows → type tokens and names, not `ordained`; SaveNote nil; isolation wrap stays; ritual plates unchanged; `lua tests/test_console.lua` exit 0 | **Pass.** Matching-name fixture still seeds the general paint block. The name-namespace proof is now the Beefina/Steve collision pin, not that fixture. Isolated **1021 / 0**. |

Bible §18.1 (the desk answers “what just happened?”), Law 4 / §18.2 (no generated prose), Law 10 / §19.3 (stock desk), and CONTINUE (no SUMMON; no post-show clipboard; `SaveNote` nil) are met, including the name half of “type + names.”

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; `DEFAULT_HEIGHT` 1050 unproven | **Not a spec miss.** Brief asked isolated `tests/test_console.lua`. **POLISH:CANDIDATE** only. |
| Unknown types still try `GetCharacter` then `GetHuman` | **Not a miss.** Closed producers are all routed. A later rite token not in the set would use the fallback. See leftover. |
| FontString body, not click-to-select | **Not a miss.** Brief asked `scrollList` furniture. |
| Empty paint `No ceremony yet.`; missing Store log is `{}` | **Not a miss.** |
| B9-C tests live inside `runB8E()` | **Not a miss.** Suite still ran. |
| Weekly Archive / Notebook / post-show stay out | **Not a miss.** CONTINUE forbids those here. |

First-review must-fix, judged:

| Must-fix | Gate |
|---|---|
| Type-route `Knighting`/`Elevation` → human; Gora rulings → character | **Fixed.** Live `participantName` does this. Recognition mixed-id routing is extra and matches the producer. |
| Pin with `seedLinked("Beefina", "Steve")` so names prove the matching table | **Fixed for the failing case.** Victor + character id paints Beefina, not Steve. The suggested Knighting-paints-Steve half is implemented and probe-confirmed, not suite-pinned. See leftover. |
| Do not treat GetHuman-first + matching-name `seedLinked` as proof | **Fixed.** GetHuman-first is gone. Matching-name `seedLinked("Beefina")` remains as a general paint seed, not as the namespace proof. |

---

## Strengths

- Type routing follows the writers, not a GetHuman-first walk: B9-A human ids, B9-B character ids, Recognition `{ characterId, humanId }`.
- Collision pin is in the exclusive suite: `seedLinked("Beefina", "Steve")`, human/character names asserted, ids asserted equal, victor row, Beefina present / Steve absent.
- Paint is still existing fields only. No knighting prose, no Proclaim, no Sound. `SaveNote` still nil.
- Isolated **1021 / 0** was re-run here and matches the writer report.

---

## Must-fix

None.

---

## Leftover (Minor)

1. **Collision pin is victor-only.** First review asked Knighting → `Steve` and victor → `Beefina`. The suite pins the Gora failure case. Knighting / Elevation / cowardice / void / free / Recognition colliding-id paint is implemented and probe-green, not asserted.

2. **Painted-line format is still substring-only.** `collideBody:find("Beefina")` / `find("Steve")` / `body:find("free")` would still pass if extra glue appeared. Exact FontString line (`victor  Beefina`) is unpinned.

3. **Matching-name `seedLinked("Beefina")` remains** in the general paint block, with `assert_eq(h2.id, c2.id)`. Harmless now that the collision pin is the name proof.

4. **Unknown-type fallback is GetCharacter-first.** No closed producer uses an unknown token. A later human-id rite not in the set would paint the colliding character.

5. **`DEFAULT_HEIGHT` 1050 is unsmoked.** **POLISH:CANDIDATE** only.

6. **Header comment still says CeremonyLog is click-to-select.** `frame.CeremonyLogRows` is still an unpainted pool.

7. **Checked-in `B9-C-console-log.diff` is stale** (GetHuman-first). Live files are the review source.

8. **Nested `runB8E()`** is still the Lua 5.1 local-cap workaround.

9. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **1021 / 0** was re-run here.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

Beefina/Steve collision pin **exists** in `tests/test_console.lua`: `seedLinked("Beefina", "Steve")` + `AppendCeremony("victor", { collideChar.id })` requires the painted body to contain `Beefina` and not `Steve`.

Stock newest-first list, type token, type-routed names, optional Pope text, `SaveNote` nil, no SUMMON, and no post-show clipboard are in place. A Gora row whose character id collides with a human id now paints the fighter.

Isolated `lua tests/test_console.lua` **1021 passed, 0 failed**, exit 0. Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This rereview does not sign the lane.
