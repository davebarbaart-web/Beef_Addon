# B5-B — Candidate / fighter raid marks

**Exclusive:** create `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

**Do not edit** TOC, run.lua, Knighting, Gora, Console. Integrator lists files after you. Do not commit. No GuildPromote. No combat automation.

## Law

Bible §8: clicking a queue entry **targets** the candidate where the API allows; when raid-grouped, place a **raid marker** on the current candidate (and Gora fighters). Anniversary (`20506`) APIs (wow-api MCP):

- `TargetUnit(name, exactMatch)`
- `SetRaidTarget(target, userIndex)`
- `GetRaidTargetIndex(target)`

`GetNumGroupMembers` / `IsInRaid` may be absent from the catalog — guard with `type() == "function"` (same as `Core/Common.lua` Group). Fail-closed: missing API → `false`, no throw.

```lua
Markers:Target(name)                 -- pcall TargetUnit(name, true)
Markers:MarkCandidate(name)          -- raid mark index 1 (star) on a matching raid/party unit
Markers:MarkFighters(nameA, nameB)   -- indices 2 and 3
Markers:Clear(name)                  -- SetRaidTarget(unit, 0)
Markers:GetView()                    -- copy of last attempt
Markers:ResetForTests()
```

- `MODE = "Event"`. Runtime QUIET / missing → Mark* return false. Target may still run (desk assist) **or** also Quiet-refuse — prefer Quiet-refuse all verbs for Law 6.
- Mark* only if a raid/party unit token can be resolved for that name **and** a group API says the player is grouped. Not grouped → `false, "not in a group"`.
- Pope-gated: `Sender:IsRegisteredPope` on the local player (`UnitName("player")` / Group.PlayerName). Unlisted → `false, "not a registered pope"`.
- Do not invent unit tokens. Scan `raid1..N` / `party1..N` via GetNumGroupMembers when present.
- No Sound, no Toasts, no Net.

## Tests

Isolated: wow_ui_stub + Common + Runtime + Markers. Stub SetRaidTarget / TargetUnit / Sender / UnitName. Quiet refuse. StartEvent + Pope + grouped → MarkCandidate spies SetRaidTarget(unit, 1). Missing API fail-closed. Isolation wrap.

`lua tests/test_markers.lua` exit 0.

Report `docs/reformation/vestments/briefs/B5-B-markers-report.md` + diff.
