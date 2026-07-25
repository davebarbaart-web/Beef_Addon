# Offline vs in-game — Beef Core/Data matrix

**Track:** [73-desktop-lua-testing](README.md)  
**Sibling:** In-game checklist and labs → [19 church-of-beef-qa-checklist](../19-testing-debugging-qa/church-of-beef-qa-checklist.md).

Desktop tests prove **policy and pure transitions**. In-game QA proves **client, network, and spectacle**. Spec §13.1 two-character verification and §13.11 spectacle are never offline-green checkboxes.

---

## Offline: ship CI coverage here

| Area | File(s) | What to assert offline | Plan suite |
|------|---------|------------------------|------------|
| Rank canon | `Data/Ranks.lua` | Count, titles, thresholds, seats, officer index max, point-driven flags | `test_ranks` |
| Ladder records | `Core/Ladder.lua` | SetStanding, suggestions, commits, revision rules, demote, council seats | `test_ladder` |
| Scoring math | `Core/Scoring.lua` | Grant amounts, daily caps, AFK bucket=`inCombat` flag, Gora loss pays | `test_scoring` |
| Officer threshold | `Core/Officer.lua` | `IsOfficerIndex`; `IsOfficerName` with **injected** roster | `test_officer` |
| Payload validation | `Net/BeefNet.lua` (validate only) | Reject malformed types, bad revisions, forged shapes — **pure table in → bool/err** | `test_net_validate` |
| DB defaults shape | `Core/DB.lua` | Default table keys/types with a fake SV table | (add when Task lands) |
| Gora/Ceremony/Instance **pure** mappers | Core thin modules | Outcome → `Scoring:Grant*` args (no instance API) | optional suites |

Architecture enablers: Core free of frames; Data free of SV; Officer injection ([34 beef-v1-architecture](../34-lua-module-architecture/beef-v1-architecture.md); plan Tasks 2–5).

---

## Offline with fakes (still not “integration with Classic”)

These can run on desktop **if** callers inject doubles. They do **not** prove Blizzard behavior.

| Concern | Fake | Still must verify in-game |
|---------|------|---------------------------|
| Roster rank gate | `rosterLookup` table | `GuildRoster` timing, nil ranks, alt names |
| Clocks / day keys | pass `now` integers | DST / realm time assumptions (track 50) |
| Suggestion queue policy | local table of pending rows | Multi-client delivery ([67](../67-offline-officer-suggestion-sync/), [19 mock-guild](../19-testing-debugging-qa/mock-guild-scenarios.md)) |
| Sync merge rules | apply `SYNC_STATE` blobs to Ladder | Login storm / CTL ([14](../14-addon-messaging-beefnet/), [47](../47-login-storms-guild-scale/)) |

---

## In-game only (track 19 — do not duplicate here)

| Concern | Why desktop fails |
|---------|-------------------|
| Addon load / TOC / Interface | Client loader + flavor ([19 multi-flavor-toc](../19-testing-debugging-qa/multi-flavor-toc-testing.md)) |
| Lua errors visible | `scriptErrors`, BugSack ([19](../19-testing-debugging-qa/script-errors-bugsack.md)) |
| Frames, tabs, minimap, move/clamp | Widget API + scale |
| Combat lockdown / ordinary frames mid-combat | Secure engine ([19 combat-lockdown](../19-testing-debugging-qa/combat-lockdown-testing.md)) |
| Live instance co-play drip | Real `IsInInstance`, combat, guildmate presence |
| BeefNet on `GUILD` | Throttle, prefix, peer decode — stubs cannot prove Classic chat ([19 mock-guild](../19-testing-debugging-qa/mock-guild-scenarios.md): “no substitute for GUILD addon channel”) |
| Officer approve → peer ladder update | Two clients minimum (spec §13.1) |
| Guild-chat ceremony / promotion lines | Spectacle §13.11 |
| SavedVariables round-trip across `/reload` | Client SV serialization |
| Alpha cohort installs | Channels ([19 alpha](../19-testing-debugging-qa/alpha-channels.md)) |

---

## Grey zone (choose deliberately)

| Topic | Offline role | In-game role |
|-------|--------------|--------------|
| Anti-AFK | Assert `GrantInstanceBucket(..., false) == 0` | Confirm “AFK at entrance” really sets not-in-combat |
| Daily caps | Loop grants until clamp | Spot-check across day boundary |
| Self-reported standing honesty | N/A (policy) | Officer judgment playtest (spec anti-cheat stance) |
| UI refresh after commit | Call `UI:Refresh` stub that records | Visual ladder update |

---

## Coverage expectation for V1

```text
CI (this track)     → Data + Core (+ Net validate) green on every PR
Local smoke         → copy AddOns folder; /beef; no BugSack (19 §1)
Guild lab (19)      → member + officer; suggestion; commit; peer sync; spectacle
```

A PR that only adds UI chrome should still leave Core suites green; a PR that changes scoring must update offline tests **and** get a playtest note on drip/caps.

---

## Steal / adapt

- **Steal from plan:** suite names and `ResetForTests` hooks.
- **Steal from track 19 README insight #6:** spectacle can fail when unit tests pass — keep that sentence in contributor docs.
- **Avoid:** “100% coverage” of Net/UI via mocks — false confidence and mock maintenance dominate.
