# Solo smoke (roster-backed V1)

**Purpose:** Single-client Anniversary walk matching the Accepted roster-backed amendment §10. Do this **before** a full guild night.

**Law:** [`docs/superpowers/specs/2026-07-25-roster-backed-ladder-design.md`](../superpowers/specs/2026-07-25-roster-backed-ladder-design.md)  
**Install:** `./scripts/install-anniversary.sh` · skill `.cursor/skills/church-of-beef-dev/SKILL.md`

Agents prep install + harness. Humans tick boxes with date + character.

## Preconditions

- [ ] `lua tests/run.lua` → `0 failed` (agent or human)
- [ ] Addon installed to Anniversary `Interface/AddOns/ChurchOfBeef/`
- [ ] Character **in a guild** (GM or Officer+ preferred for Officer tab)
- [ ] `/console scriptErrors 1` (prefer BugGrabber + BugSack)

## Walk (~15–20 min)

1. **Load**
   - [ ] `/reload` — no script errors; addon listed as Church of Beef (`20506`)
2. **Shell**
   - [ ] `/beef` opens a real frame (Ladder default); Esc / close hides; drag + `/reload` restores position
   - [ ] Minimap button toggles the same frame (or `/beef` still works if hidden)
3. **Roster ladder**
   - [ ] Ladder shows real guild members in mapped bands (GM → Beef Prophet, …)
   - [ ] Local title on Ladder / My Standing matches your WoW guild rank via the fixed map
   - [ ] No “ask an officer to log in” banner while the flock is visible
4. **Standing → suggestion**
   - [ ] As Officer+: Officer tab → correct a member’s standing to the next threshold (or run thin Ceremony / Gora)
   - [ ] Promote suggestion appears on Officer queue (“Promote … in the guild roster”)
   - [ ] Edge toast fires (eligible / promote prompt) — TOP edge, not center; no SFX
5. **Guild UI promote**
   - [ ] Promote that member **one step in Blizzard’s guild roster**
   - [ ] After roster refresh, Ladder moves the name; suggestion auto-clears
6. **Dismiss**
   - [ ] Create another suggestion (or use a second member); Officer **Dismiss** clears it; standing unchanged
7. **Gates**
   - [ ] Non-officer alt (if available): Officer tab hidden; cannot dismiss others’ queue
   - [ ] Combat: open/close `/beef` mid-trash — no taint; bags/character still work
8. **Out of scope this smoke**
   - Guild-chat promote announce (deferred until roster-diff announcer)
   - Two-client BeefNet rank sync (removed under roster-backed model)
   - Addon never calls guild promote/demote APIs

## Pass / fail

**Pass:** steps 1–7 clean; ranks move only via WoW guild ranks; suggestions are prompts only.  
**Fail:** load error, empty ladder while guilded with roster loaded, Commit/Approve rites still present, suggestion survives a matching guild promote, script errors in combat toggle.
