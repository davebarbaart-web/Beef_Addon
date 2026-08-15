# A09 — Party/raid composition and raid-leader detection

**Appendix A item:** 9  
**Owner:** David  
**Result:** NOT RUN

Cited: Bible Appendix A item 9; §14.3 (later-phase Expeditions/Campaigns); §13.2 (raid leadership is worth observing later).

## Dependent feature

Later-phase **Church Expeditions** and **Church Campaigns** (§14.3). Campaigns distinguish *Church Raid* (majority/supermajority of members) from *Church-Led Raid* (member leading, outsiders welcome). Those systems are not specified here.

Appendix A: party/raid composition and raid-leader detection on the live client.

This sheet is **method only**. Do not spec Expeditions, Campaigns, attendance, or a qualification rule.

## Bible fallback

Appendix A item 9 names **no** standalone fallback. The Appendix A closer applies. Do not invent a composition heuristic or a Campaign tracker from a FAIL.

Item 5 (raid markers) needs leader/assist as a *different* dependent. This item's Result is not a pass of item 5.

## Live-client method (Anniversary TBC, Interface 20506)

Two or more characters. `/console scriptErrors 1`. Blizzard party/raid UI only. Do not add composition code to the addon.

1. **Solo.** Record what the client reports for party size, raid size, and "is this character the leader" while grouped with nobody.
2. **Party.** Form a party. Record the APIs this client actually exposes (party count, member names, party leader). Note realm suffix if present.
3. **Raid.** Convert to raid if the client allows. Record raid size, each member's subgroup if shown, and who the raid leader is.
4. **Leader vs assist vs member.** From leader, assist (if promoted), and a plain member, record which character the client marks as raid leader / assist. Use the default raid UI plus a `/run` read — do not write a detector module.
5. **Write facts on this sheet.** Composition reads and leader detection only. No Expedition. No Campaign. No calendar/RSVP. No favor.

Do not change addon Lua from this sheet.

## Not a pass

- Harness green
- Item 5 marker writes
- Any invented ~3-of-5 or majority rule
- Butcher display-only rank existing in `Data/Ranks.lua`

## Leftovers

- Church Expeditions / Campaigns (§14.3 — later phase; do not spec)
- Witnessing raid leadership (§13.2 — later)
- Item 5 programmatic markers (separate sheet)
