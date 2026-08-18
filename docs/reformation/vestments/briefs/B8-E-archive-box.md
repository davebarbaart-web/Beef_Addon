# B8-E — Console Archive box usable

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Archive.lua, Store. Do not commit. Console stays **stock**. `SaveNote` stays nil. No post-show summary. No SUMMON.

## Law

Anniversary `EditBox:SetMultiLine(multiline)` exists (SimpleEditBoxAPI). Type-guard it.

- `ArchiveBox`: if `SetMultiLine` is a function, `SetMultiLine(true)` and make the box taller than one line (about 72px). Keep `InputBoxTemplate`. Do not steal focus.
- Stock `GameFontNormal` labels: `ARCHIVE` by the archive box, `CANONIZE` by the canonize box. Functional, not jokes.
- Export / Import / Canonize / Flag Upset verbs unchanged. `CopyToClipboard` still blob-only.
- Do not lower `SetMaxLetters` on the archive box (blobs are long).

## Tests

ArchiveBox `_multiline == true` (or the harness equivalent you set). Height > 22. Labels exist as FontStrings with those exact words. SaveNote nil. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B8-E-archive-box-report.md` + diff.
