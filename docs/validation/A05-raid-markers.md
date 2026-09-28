# A05 — Raid target markers

**Appendix A item:** 5  
**Owner:** David  
**Result:** NOT RUN

Cited: Bible Appendix A item 5; §8; §3.1 (raid markers on the Classic-family client); Adjudication (raid-marker and targeting assist).

## Dependent feature

Candidate/fighter marking (§8). When the congregation is raid-grouped, the add-on auto-places a raid marker on the current Knighting candidate and, later, on Gora fighters. Diegetic, Classic-native stage management. Finding one body in a 40-body scrum is the physical half of the Knighting bottleneck.

Appendix A: setting markers programmatically as leader/assist.

This item does not invent live HUD health (item 1), favor, or a SUMMON protocol.

## Bible fallback

**Target-assist only** — Appendix A item 5.

If programmatic raid markers fail (no raid, not leader/assist, API refused), the console still targets the current candidate/fighter where the API allows (item 6). That fallback is named. Do not invent a third marking scheme.

`UI/Markers.lua` now calls capability-guarded `SetRaidTarget` and `TargetUnit`. **That is not a pass of this item.** David still walks the live method. Desk-visible refuse when marks fail may still be leftover. Do not invent SecureActionButton.

## Live-client method (Anniversary TBC, Interface 20506)

Two or more characters in the same **raid** (a party is not enough to prove raid markers). One character is raid leader or assist. `/console scriptErrors 1`. Do not add `SetRaidTarget` to the addon.

1. **Leader write.** As raid leader, target a willing raid member. From a `/run` (or the default raid-marker UI) set a marker, then clear it. Record: whether the skull/circle/etc. appeared for the leader and for the other client; the exact API or UI used; any error.
2. **Assist write.** Promote a second character to assist (Blizzard raid UI). Repeat set/clear from that assist. Record whether assist can write.
3. **Member refuse.** From a raid member who is neither leader nor assist, attempt the same set. Record the refuse (expected if the client gates writes).
4. **Combat.** Repeat a successful leader (or assist) set once in combat. Record whether lockdown blocks the write.
5. **No-raid control.** Leave the raid. Attempt the same programmatic set on a targeted guildmate. Record the refuse — this is the condition that falls back to target-assist only.
6. **Write facts on this sheet.** Who could set a marker, which index, in or out of combat. No auto-mark product. No fifth Gora outcome. No `#8` override UX.

Do not change addon Lua from this sheet.

## Not a pass

- Harness green
- HUD / Knighting / Gora desks existing without markers
- Item 6 targeting assist (that is the fallback, not this item)
- A party (not raid) smoke that never called a marker API

## Leftovers

- Desk-visible refuse when marks fail (no raid, not leader/assist, API refused)
- Which marker index is used for candidate vs fighters (do not invent)
- Item 6 must still be walked for the named fallback
