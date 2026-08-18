# B9-A — Knighting / elevation ceremony log

**Exclusive:** `addon/ChurchOfBeef/Core/Knighting.lua`, `tests/test_knighting.lua`

**Do not edit** Store, Console, Gora, Toasts. Do not commit. No GuildPromote. No `queue` / `AdvanceQueue`. No generated scripture.

## Law

Bible §18.1 “what just happened.” The log already exists. KnightThisBeef / ElevateToLord currently write rank only. After a **successful** write, if `Store.AppendCeremony` exists:

```lua
Store:AppendCeremony("Knighting", { humanId }, now)
Store:AppendCeremony("Elevation", { humanId }, now)
```

Type token + human id + time only. No 4th-arg text. No `scripture` / `narration`. A refused verb does not append. Re-knight may append again (append-only; Law 7).

Flip the old pins that expected `#GetCeremonyLog() == 0` after those verbs. Those pins meant “no narration,” not “no log.”

Keep: no GuildPromote, no CreateFrame, ElevateToLord still dequeues, no auto-knight.

## Tests

Successful KnightThisBeef → one `Knighting` row, no text/scripture/narration. ElevateToLord → `Elevation` row. Unknown human → log unchanged. Isolation wrap stays. `lua tests/test_knighting.lua` exit 0.

Report `docs/reformation/vestments/briefs/B9-A-knighting-log-report.md` + diff.
