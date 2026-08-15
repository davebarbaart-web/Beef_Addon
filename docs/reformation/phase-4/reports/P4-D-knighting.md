# Phase 4 Lane D — Knighting + Lord elevation verbs (Core)

**Status:** DONE

**Cited:** Ten Laws 3, 4, 9; Bible §8, §10.4, §5; `.cursor/rules/pope-authority.mdc`; `.cursor/rules/records-not-points.mdc`; brief `docs/reformation/phase-4/briefs/P4-D-knighting.md`. Store already has `SetRank` and first-Lord `elevationAt`.

Pope verbs that write the Church record only. No TOC / bootstrap / `tests/run.lua` / Store / Runtime / Gora / Officer / UI / Net / DB edits. No `Data/Popes.lua`. No `GuildPromote` / `SetGuildRank`. No queue auto-advance, Runtime verbs, fairness score, Prophet, demote, or Butcher / Council rite. No commit. `OPEN_QUESTIONS.md` unchanged.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_knighting.lua` | Created first. Isolated suite: Common + Ranks + Store + Knighting. Isolation asserts wrapped in `if standalone then`. |
| `addon/ChurchOfBeef/Core/Knighting.lua` | Created after the suite. Two Pope verbs. |
| `docs/reformation/phase-4/reports/P4-D-knighting.md` | This file |

## Verbs

**KNIGHT THIS BEEF** is the Church record that the human is a Beef Knight. Guild-rank promotion, queue, targeting, raid markers, and proclamation are later Console / UI.

| Method | Role |
|--------|------|
| `KnightThisBeef(humanId, now?)` | `Store:SetRank(humanId, 3)` (Beef Knight). Refuses unknown humans and non-id keys. Does not write Lord. Does not append ceremony text. |
| `ElevateToLord(humanId, now?)` | `Store:SetRank(humanId, 4)` (Beef Lord). Does not compute fairness, pairing, or defenses. First `elevationAt` comes from Store. Not automatic after a Gora win. |

Expected failures are `nil, err`. Success returns Store's human copy. Optional `now` is the injectable clock Store already uses for first-Lord `elevationAt`.

No Demote, Prophet, ElevateToButcher, SetCouncil, Grant, queue, OpenRite, EndEvent, or guild-index map.

## Verification

- Isolated suite (`Core/Common.lua` + `Data/Ranks.lua` + `Core/Store.lua` + `Core/Knighting.lua`): **134 passed, 0 failed**.
- Lua 5.1.5. `lua tests/test_knighting.lua` exits 0.
- No `CreateFrame`. No `GuildPromote` / `SetGuildRank`. No `dofile` of Runtime / Gora / Officer / UI / Net / DB. Store unread for edits.

## Leftovers (other lanes — not fixed)

- **Integrator:** add `Core/Knighting.lua` to `ChurchOfBeef.toc` (file exists now). Add `test_knighting` to `tests/run.lua`.
- **Later UI / Console:** guild-rank promotion where the API permits; queue, targeting, raid markers; Director Console one-click; proclamation to installed clients.
- **#8:** registered-Pope list is not this lane. These verbs write the store; they do not look up a Pope character.
- Butcher / Council remain other human judgments. This rite does not write ids 5 or 6.

## Concerns

- `KnightThisBeef` on a sitting Lord would `SetRank` to 3 because that is the specified verb. This lane does not add a demote API and does not invent a refusal gate.
- `ElevateToLord` does not require a current Knight rank or a recorded Gora win. Fairness stays the Pope's.
- `OPEN_QUESTIONS.md` was not edited. Do not claim V1 / MVP complete. Client smoke and a human Gathering (Bible §22.3) are not this lane.
