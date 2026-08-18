Spec PASS

# B7-B — Console Archive, Canonize, Flag Upset (review)

**Quality:** Approved-with-nits

**Lane:** B7-B Console Archive / Canonize / Flag Upset (stock)
**Brief:** `docs/reformation/vestments/briefs/B7-B-console-archive.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B7-B-console-archive-report.md`
**Diff:** `docs/reformation/vestments/briefs/B7-B-console-archive.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the exclusive-pair diff, `UI/Console.lua` (ExportArchive / ImportArchive / CanonizeMoment / FlagFamousUpset / ArchiveBox / SaveNote), and `tests/test_console.lua`; then ran `lua tests/test_console.lua`. Law cited: Bible §13.5 (one-action Archive export/import), §16 (CANONIZE; software supplies the seal, never the scripture), §10.9 (Famous Upsets are Pope-flagged); Law 7 (bad import is not a wipe); Law 10 / §19.3; CONTINUE 2026-08-18 (no post-show ceremony-summary clipboard; CopyToClipboard only for the Archive blob; no SUMMON; Director Console stays plain). Did not mutate addon code. Did not commit. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `ExportArchive` → `Archive:Export`; box fill; `CopyToClipboard` blob only | **Pass.** Pope-gated. Missing `Archive` / missing `Export` → refuse string; box is not touched. Non-string export → refuse; box is not touched. Else `ArchiveBox:SetText(blob)` then `pcall(CopyToClipboard, blob)` only when `type(CopyToClipboard)=="function"`. Missing Os API still fills the box. `pcall` failure still fills the box and still returns the blob. Anniversary `CopyToClipboard(text, [removeMarkup])` exists; the call passes the blob only. `Refresh` after fill does not rewrite the box. |
| `ImportArchive` Check-then-Import; Law 7 no wipe | **Pass.** Pope-gated. Missing `Check` or `Import` → refuse; `Import` is not called. Blob is the argument when present, else `ArchiveBox:GetText()`. `if not checked` returns before `Import`. Suite pins Check count up, Import count flat, box text kept, and `Store:Snapshot().humans` unchanged on a bad Check. Console never calls `Store:Restore`. |
| `CanonizeMoment` → Store; latest moment / box text; no generated scripture | **Pass.** Pope-gated. Missing `Store.CanonizeMoment` → refuse string. Omitted id is `GetMarkedMoments()[#moments].id` (Store appends; last row is latest). Omitted text is `CanonizeText` as typed — no trim, no invented prose, no location. Explicit args win. `after()` has no cue and no HUD. |
| `FlagFamousUpset` defaults; never computes an upset | **Pass.** Pope-gated. Missing `Store.FlagFamousUpset` → refuse string. Omitted victor = `selectedCharacterId` if it is an id, else proposed `fighterA`. Omitted opponent = the other proposed fighter only when the victor is A or B. No `level`, `won`, streak, or record compare. Store still requires a matching victory — Console does not swap a selected loser for the winner. |
| `SaveNote` nil; no post-show clipboard; no SUMMON | **Pass.** `Console.SaveNote` / `GetNotes` are nil at API scan and after the B7-B block. No `CopyCeremonySummary`, `CeremonySummary`, or `COPY SUMMARY` chrome. Source has no `WHISPER ALL`, `SUMMON THE FAITHFUL`, `Knighted:`, or `CopyCeremonySummary`. The only `CopyToClipboard` site is the Archive blob. Notebook is still a label. |
| No Sound / Toasts / `SendChatMessage` | **Pass.** Export refreshes itself with no `playCue`. Import / Canonize / FlagUpset use `after(self, result, err)` with no cue and no `wantHud`. `after()` plays only when a cue is passed. Existing knighting / elevation / sanction / verdict / cowardice cues stay. Suite stubs Sound / Toasts / chat and pins 0 on the four methods and the four buttons. Import does not copy. |
| Isolated green | **Pass.** Reviewer ran `lua tests/test_console.lua`: **887 passed, 0 failed**, exit 0. Isolation cluster is still `if standalone then` (17 nil-module pins, including `COB.Archive == nil`). Suite does not `dofile` `Archive.lua`. B7-B block is a nested `runB7B()` (Lua 5.1 200-local cap). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Store, Archive.lua, Gora; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/Console.lua` and `tests/test_console.lua`. |
| Console stays stock; `SaveNote` stays nil; no WHISPER ALL; no post-show ceremony summary; no SUMMON | **Pass.** New chrome is `InputBoxTemplate` + `UIPanelButtonTemplate`. No parchment, QuestBG, custom media, jokes, `OnUpdate`, or `UIParent:SetScale`. Named-risk checks for SaveNote, clipboard, and SUMMON. |
| Stock `ArchiveBox` + `EXPORT ARCHIVE` / `IMPORT ARCHIVE`; Pope-gated; missing Archive refuse | **Pass.** Both plates are ritual (`applyGate` + `isRegisteredPope`). Clicks still refuse while gated. Isolation keeps Archive nil and stubs. |
| `ExportArchive` → `Archive:Export`; fill box; `pcall(CopyToClipboard, blob)` only when the function exists | **Pass.** Named-risk check. CONTINUE license: clipboard is the Archive blob only. |
| `ImportArchive(blob?)` → Check then Import; bad blob refuse; do not wipe (Law 7) | **Pass.** Named-risk check. |
| Stock EditBox + `CANONIZE` → `Store:CanonizeMoment`; omitted id = latest marked moment; omitted text = box | **Pass.** Named-risk check. Scripture is Pope-typed. Software does not write it. |
| Stock `FLAG UPSET` → `Store:FlagFamousUpset`; default proposed bout / selected fighters; never compute | **Pass.** Named-risk check. |
| No Sound / Toasts / `SendChatMessage` on these verbs | **Pass.** Named-risk check. |
| Tests: stub Archive Export/Import/Check; export fills box; Import Check-then-Import; CopyToClipboard spy optional; Canonize/FlagUpset reach Store when Pope; SaveNote nil; isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** Isolation stayed gated. This review re-ran the isolated suite. |

Bible §13.5 (one-action string export/import on the Pope console), §16 (seal, not scripture), §10.9 (Pope-flagged upsets), Law 7 (bad import is not a wipe), Law 10 / §19.3 (functional stock), and CONTINUE (no post-show summary clipboard; no SUMMON) are met. Weekly Archive reminder (cold-only, §13.5) is not this lane.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; frame grew (`DEFAULT_HEIGHT` 770 → 880) | **Not a spec miss.** Brief asked isolated `tests/test_console.lua`. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| `Archive.lua` not loaded; Export / Import / Check proven against a stub | **Not a miss.** Brief allowed a stub. Integrator still wires the real module. Console never `Restore`s and never skips Check. |
| `Store:CanonizeMoment` / `FlagFamousUpset` are B7-A; suite wraps / stubs when missing | **Not a miss.** B7-A is in this checkout; the wrap still forwards. Console does not trim or refuse canonize newlines — brief left that to Store. |
| Weekly Archive reminder is not this lane | **Not a miss.** §13.5 reminder is a later cold-state ritual, not B7-B. |
| EXPORT / IMPORT / CANONIZE / FLAG UPSET are ritual plates | **Not a miss.** Brief asked Pope-gating. Clicks still refuse while gated. Same reading as B6-A. |
| B7-B tests live in nested `runB7B()` (Lua 5.1 200-local cap) | **Not a miss.** Suite still ran. See leftover. |

---

## Strengths

- Import cannot reach `Archive:Import` or `Store:Restore` unless Check is truthy. The Law 7 pin is a store-human count, not a comment.
- `CopyToClipboard` is a single guarded `pcall` of the Archive blob. There is no ceremony-summary method, button, or `Knighted:` string.
- FlagUpset forwards the Pope's selection. It does not read `won` or swap a selected loser for the winner.
- Canonize passes box text through. It does not invent scripture, location, or flavor.
- Missing Archive / missing Store verbs refuse with a string and do not clear `ArchiveBox`.
- Isolation stayed under `if standalone then`. Theater Sound pins from the earlier desk were not deleted. Isolated **887 / 0** was re-run here.

---

## Issues

### Must-fix (Critical / Important)

None.

### Leftover (Minor)

1. **Archive and Canonize rows have no headers.** They are unlabeled `InputBoxTemplate`s stacked under Recognition, same pattern as the honorific box. The plates are the only tell. A Pope can type scripture into `ArchiveBox` and canonize an empty box, or the reverse.

2. **`FLAG UPSET` shares the IMPORT ARCHIVE row.** The pairing is legal stock layout and easy to mis-glance. Desk-only.

3. **One-line `ArchiveBox` will clip a real export string.** Clipboard is the carry path when the Os API exists; the box is still the paste target for import. Writer already named this.

4. **Selected character outside the proposed bout leaves `opponentId` nil.** Presence click then FLAG UPSET calls Store with one id and refuses. Fail-closed, not a computed upset — but the default is not “the other fighter.”

5. **CANONIZE is not gated to QUIET / cold.** Bible §16 is flag-hot / canonize-cold. The brief did not ask for a runtime gate. Mid-ceremony CANONIZE still writes Store if the Pope clicks.

6. **Canonize box is not cleared after a write.** `Refresh` does not touch `CanonizeText`. A second click re-stamps the latest moment with the same text.

7. **Suite header is still stale.** It still says the Pope predicate is always false and the suite does not stub a Pope list. B7-B uses the existing `Sender.IsRegisteredPope` wrap. Isolation itself stayed gated.

8. **Check-then-Import order is proven by counts, not a call log.** Bad-Check pins Import-not-called. Happy path does not record which method ran first. Implementation is sequential.

9. **Nested `runB7B()`** is a Lua 5.1 local-cap workaround. Fine as long as the next console lane does not add another 80 locals to the main chunk.

10. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **887 / 0** was re-run here. Client path was not. Frame height 880 is unproven on Anniversary.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

This is the B7-B vestment contract: one-action Archive export that fills a stock box and may copy that blob only, Import that Checks before Import and does not wipe on a bad blob, Canonize that writes Pope-typed scripture onto the latest marked moment, Flag Upset that forwards the proposed bout and never computes a winner. `SaveNote` is still nil. No SUMMON. No post-show clipboard. Named risks are clean. Nits are unlabeled boxes, a cramped desk, an unsmoked height bump, and no cold-state CANONIZE gate — not trust-breakers.

Isolated `lua tests/test_console.lua` **887 passed, 0 failed**, exit 0. Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
