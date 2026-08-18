Spec PASS

# B8-E — Console Archive box usable (review)

**Quality:** Approved-with-nits

**Lane:** B8-E Console Archive box usable (stock)
**Brief:** `docs/reformation/vestments/briefs/B8-E-archive-box.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B8-E-archive-box-report.md`
**Diff:** `docs/reformation/vestments/briefs/B8-E-archive-box.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the exclusive-pair diff, `UI/Console.lua` (ArchiveBox / ArchiveLabel / CanonizeLabel / SaveNote / ExportArchive clipboard), and `tests/test_console.lua`; then ran `lua tests/test_console.lua`. Law cited: Bible §13.5 (Sacred Archive one-action export/import on the Pope console); Law 10 / §19.3 (Director Console stays stock-pragmatic); Anniversary `EditBox:SetMultiLine` (SimpleEditBoxAPI, confirmed on `classic_anniversary` 2.5.6); CONTINUE 2026-08-18 (no SUMMON; no post-show clipboard; `SaveNote` stays nil; Console stays plain). Did not mutate addon code. Did not commit. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `SetMultiLine` type-guarded; taller than one line | **Pass.** Only `ArchiveBox` is gated: `if type(frame.ArchiveBox.SetMultiLine) == "function"` then `SetMultiLine(true)`, `_multiline = true`, `SetHeight(72)`. `stockEdit` still starts at 22 / `SetAutoFocus(false)` / `InputBoxTemplate`. Other boxes are not touched. `Refresh` / `Show` do not reset height or call `SetFocus`. |
| Stock `ARCHIVE` / `CANONIZE` FontStrings | **Pass.** Both go through existing `header()` → `GameFontNormal`. Exact words. Placed above those boxes (`ArchiveLabel` / `CanonizeLabel`). Not jokes. Distinct from the existing `CANONIZE` ritual plate. |
| `SaveNote` nil; no post-show clipboard; no SUMMON | **Pass.** `Console.SaveNote` / `GetNotes` / `CopyCeremonySummary` / `CeremonySummary` are nil. No `SUMMON THE FAITHFUL`, `COPY SUMMARY`, or `WHISPER ALL` chrome. Source has no `function Console:SaveNote`. The only `CopyToClipboard` site is still `pcall(CopyToClipboard, blob)` after a successful Archive export. |
| Verbs unchanged; `SetMaxLetters` not lowered | **Pass.** Provided diff does not touch `ExportArchive` / `ImportArchive` / `CanonizeMoment` / `FlagFamousUpset`. Clipboard is still the Archive blob only. `Console.lua` has no `SetMaxLetters` call. |
| Isolated green | **Pass.** Reviewer ran `lua tests/test_console.lua`: **936 passed, 0 failed**, exit 0. Isolation cluster is still `if standalone then` (17 nil-module pins at file load). B8-E re-pins Archive + Quiet shell. Suite does not `dofile` `Archive.lua`. B8-E block is a nested `runB8E()` (Lua 5.1 200-local cap). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Archive.lua, Store; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/Console.lua` and `tests/test_console.lua`. `Archive.lua` is unmodified. `Store.lua` is dirty from B8-A, not this lane. |
| Console stays stock; `SaveNote` stays nil; no post-show summary; no SUMMON | **Pass.** New chrome is two `GameFontNormal` headers plus the existing `InputBoxTemplate` box grown in place. No parchment, QuestBG, custom media, jokes, `OnUpdate`, or `UIParent:SetScale`. Named-risk checks for SaveNote, clipboard, and SUMMON. |
| Type-guard `SetMultiLine`; if it is a function, `SetMultiLine(true)` and height ~72; keep `InputBoxTemplate`; do not steal focus | **Pass.** Named-risk check. Anniversary SimpleEditBoxAPI exists on this target. Harness `_multiline` is the brief-allowed equivalent (stub `SetMultiLine` is a no-op). |
| Stock `ARCHIVE` by the archive box, `CANONIZE` by the canonize box; functional, not jokes | **Pass.** Named-risk check. |
| Export / Import / Canonize / Flag Upset unchanged; `CopyToClipboard` still blob-only; do not lower `SetMaxLetters` | **Pass.** Named-risk check. |
| Tests: `_multiline == true` (or harness equivalent); height > 22; labels exist as FontStrings with those exact words; SaveNote nil; isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** Isolation stayed gated. This review re-ran the isolated suite. |

Bible §13.5 (one-action string export/import on the Pope console), Law 10 / §19.3 (functional stock), and CONTINUE (no post-show summary clipboard; no SUMMON; `SaveNote` nil) are met. Weekly Archive reminder (cold-only, §13.5) is not this lane.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; `InputBoxTemplate` may look like a stretched one-liner at 72px | **Not a spec miss.** Brief required that template and a taller box. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| `DEFAULT_HEIGHT` 880 → 960 unproven on 1080p Anniversary UI | **Not a miss.** Brief did not freeze the frame size. The extra 80px matches the two label rows plus the 22→72 box. See leftover. |
| `_multiline` is harness bookkeeping; stub does not model `SetMultiLine` / `IsMultiLine` | **Not a miss.** Brief allowed “the harness equivalent you set.” Production still calls the type-guarded client method. |
| Labels sit **above** the boxes, not the STIPULATION left-of-box pattern | **Not a miss.** Brief said “by” those boxes. Wording is exact `ARCHIVE` / `CANONIZE`. |
| A long export string can still overflow 72px | **Not a miss.** Brief asked taller than one line (~72), not a full-blob viewport. Clipboard remains the B7-B carry path. |
| Weekly Archive reminder is not this lane | **Not a miss.** §13.5 reminder is a later cold-state ritual. |
| B8-E tests live in nested `runB8E()` (Lua 5.1 200-local cap) | **Not a miss.** Suite still ran. See leftover. |

---

## Strengths

- The multiline path is a single type-guard on the widget method, not a global, and it only fires for `ArchiveBox`. Canonize / Decree / Honorific boxes stay one line.
- Focus is not stolen: `SetAutoFocus(false)` is unchanged; `Show` / `Refresh` never `SetFocus`.
- `SaveNote` is still absent. There is no second clipboard, no ceremony-summary method, and no SUMMON chrome. `CopyToClipboard` is still one guarded `pcall` of the Archive blob.
- Labels reuse `header()` / `GameFontNormal`. No new template, no custom media, no joke copy.
- Isolation stayed under `if standalone then`. Archive.lua was not loaded. Isolated **936 / 0** was re-run here.

---

## Issues

### Must-fix (Critical / Important)

None.

### Leftover (Minor)

1. **`InputBoxTemplate` at 72px is unsmoked.** The brief required that pairing. Anniversary left/right caps may still read as a stretched one-liner; Enter may still clear focus the way a single-line box does. **POLISH:CANDIDATE** only.

2. **`DEFAULT_HEIGHT` 960 is unproven.** Content is not a scroll child. The extra 80px fits the new rows inside the frame; whether a 960-tall console fits a default-scale Anniversary UI was not walked.

3. **`_multiline` is set by Console, not by the stub.** `wow_ui_stub` `SetMultiLine` is an allowed no-op. The source pin `SetMultiLine(true)` also matches the file-header comment, so a deleted live call could still satisfy that one assert. Height > 22 and the type-guard string are the real pins.

4. **`findFont("CANONIZE")` is harness-lucky.** Stub `UIPanelButtonTemplate` mints a FontString but `SetText` does not copy onto it. In-game the plate label is also `CANONIZE`. Implementation still owns a distinct `CanonizeLabel`.

5. **EXPORT ARCHIVE stays 28px beside a 72px box.** Legal stock layout. Easy to mis-glance. Desk-only.

6. **Nested `runB8E()`** is a Lua 5.1 local-cap workaround. Fine as long as the next console lane does not add another 80 locals to the main chunk.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **936 / 0** was re-run here. Client path was not.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

This is the B8-E vestment contract: type-guarded `ArchiveBox:SetMultiLine(true)` and a 72px stock box when the Anniversary API exists, `ARCHIVE` / `CANONIZE` `GameFontNormal` labels by those boxes, verbs and blob-only clipboard left alone, `SaveNote` still nil, no SUMMON, no post-show summary. Named risks are clean. Nits are an unsmoked stretched InputBox, a taller unsmoked frame, and harness bookkeeping for multiline — not trust-breakers.

Isolated `lua tests/test_console.lua` **936 passed, 0 failed**, exit 0. Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
