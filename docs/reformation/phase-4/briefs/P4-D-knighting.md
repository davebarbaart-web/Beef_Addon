# Phase 4 Lane D — Knighting + Lord elevation verbs (Core)

Read: Ten Laws 3, 4, 9; Bible §8, §10.4, §5; `.cursor/rules/pope-authority.mdc`; `.cursor/rules/records-not-points.mdc`. Lanes A and B are signed. Store already has `SetRank` and first-Lord `elevationAt`.

## Exclusive files

- `addon/ChurchOfBeef/Core/Knighting.lua` (create)
- `tests/test_knighting.lua` (create)
- Report: `docs/reformation/phase-4/reports/P4-D-knighting.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, Store, Runtime, Gora, Officer, UI, Net, DB. **Do not** create `Data/Popes.lua`. **Do not** call `GuildPromote` / `SetGuildRank` (Core never performs protected actions). Integrator lists the file after it exists.

## Mission

Test-first. Isolated suite: Common + Ranks + Store + Knighting. Wrap isolation asserts in `if standalone then`.

**KNIGHT THIS BEEF** is one Pope verb: the Church record that the human is a Beef Knight. Guild-rank promotion is later UI, where the API permits. Queue, targeting, and raid markers are later Console.

- **KnightThisBeef(humanId)** — `Store:SetRank(humanId, 3)` (Beef Knight). Refuse unknown humans. Do not auto-advance a queue. Do not OpenRite / EndEvent.
- **ElevateToLord(humanId)** — `Store:SetRank(humanId, 4)` (Beef Lord). The Pope judges “fair”; this lane does not compute fairness, pairing, or defenses. First Lord still gets `elevationAt` from Store. Not automatic after a Gora win.
- Do not knight to Lord. Do not invent Prophet. Do not demote. Butcher / Council are not this rite.

Do not invent: Director Console, proclamation text, narration, `#8`, INPUT channel, guild-index map.

## Do not git commit.
