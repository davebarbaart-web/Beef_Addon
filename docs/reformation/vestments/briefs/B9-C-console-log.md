# B9-C — Console ceremony log desk

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Store, Knighting, Gora. Do not commit. Console stays **stock**. `SaveNote` stays nil. No WHISPER ALL. No post-show summary. No SUMMON.

## Law

Bible §18.1: the Pope asks “what just happened?” Stock scroll list `CeremonyLog` (same furniture pattern as Presence / petitions). Newest first.

Each row paints **existing fields only**:

- `entry.type` (the token)
- participant names from `Store:GetHuman` / `GetCharacter` when the id matches
- `entry.text` when present (Pope-authored free-ruling line only)

Do not invent “The Pope knighted…”. Do not Proclaim. No Sound. Missing Store log → empty list.

## Tests

Seed AppendCeremony rows → list shows type tokens and names, not `ordained`. SaveNote nil. Isolation wrap stays. Ritual plates unchanged.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B9-C-console-log-report.md` + diff.
