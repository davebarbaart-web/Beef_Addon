# Church of Beef — V1 Verification Checklist

The success criteria from [the design spec](../superpowers/specs/2026-07-25-church-of-beef-design.md)
(§13) as a walkable list. A green offline harness (`lua tests/run.lua`) is a
precondition, not a substitute: every success criterion below needs a real TBC
Classic Anniversary client, and criteria 7–9 need two characters (Officer+ and
Member).

Do not claim V1 complete until every box is ticked and dated. Task 13 ticked only
the boxes it could actually prove without a client — harness, TOC, and the
missing-media case — and installed the addon into the Anniversary client. Every
remaining box is a human pass in game.

Tick a box by replacing `[ ]` with `[x]` and appending `— YYYY-MM-DD, character`.

## Success criteria (spec §13)

- [ ] **1. Loads on TBC Classic Anniversary** and appears in the AddOns list as
      **Church of Beef** (`## Interface: 20506`, no "out of date" toggle needed)
- [ ] **2. `/beef` opens a real frame**, not a chat-only response — including on a
      fresh install where no `ChurchOfBeefDB` exists yet
- [ ] **3. All seven ranks display** on the Ladder tab; the local player's title and
      standing are visible and match canon (`Data/Ranks.lua`)
- [ ] **4. Shared instance co-play grants capped standing** — a dungeon, raid or BG
      with at least one guildmate pays per closed bucket the player fought in, and
      stops paying at the daily cap
- [ ] **5. Thin Gora and ceremony actions grant standing** — a recorded Gora result
      (win, draw *and* loss) and a cleanly closed ceremony both pay
- [ ] **6. Crossing a threshold creates an officer-visible suggestion** and never
      auto-promotes; Council and Prophet never appear as suggestion targets
- [ ] **7. Officer+ approve updates the rank locally and over BeefNet** — approve on
      client A, and client B (online, addon running) shows the new rank
- [ ] **8. Login sync repairs a stale ladder** — client C is offline during a
      promotion; on login it shows the correct rank without an officer redoing anything
- [ ] **9. A non-officer cannot apply a forged `RANK_COMMIT`** — from a member client,
      hand-send one on the wire and confirm peers ignore it and their ladder is
      unchanged. There is no debug slash command by design; use the public send path:

      ```
      /run local N=ChurchOfBeef.Net N:Send(N:Encode("RANK_COMMIT","Someguildie",5,9999,999,0,UnitName("player")))
      ```
- [ ] **10. No Retail-only APIs and no combat automation** — `/console scriptErrors 1`
      plus BugSack stay clean through a full session
- [ ] **11. Social check:** during a real guild night, at least one promotion happens
      and gets a visible reaction in guild chat. This is the point of V1 — if rank
      changes pass unnoticed, the feature failed even with every function working.

## Verification approach (spec §13.1)

- [ ] In-game checklist walked on a TBC Anniversary client with two characters
      (member + officer)
- [ ] BeefNet check: approve on the officer → the member sees the update
- [x] Load-with-missing-assets smoke test — vacuous in V1 and intentionally so: the
      addon ships no `Media/` folder and references only default Blizzard textures and
      fonts, so there is nothing to go missing. Re-open this box the moment custom
      media lands. — 2026-07-25, offline grep of the addon tree
- [ ] Doc review: canon ranks match what the UI shows; deferred features are marked
      as later-phase rather than looking broken

## Supporting checks

- [x] `lua tests/run.lua` exits 0 from the addon checkout root — 2026-07-25,
      879 passed / 0 failed on Lua 5.1.5
- [x] `ChurchOfBeef.toc` lists only files that exist, lists every file that exists,
      and load order is `Data → Core → Net → UI → bootstrap` with `MainFrame` ahead of
      the tabs that register into it — 2026-07-25, offline check
- [ ] `ChurchOfBeefDB` survives `/reload` and logout, and stays comfortably under 1 MB
- [ ] Frame position, minimap toggle and the announce opt-out persist across sessions
- [ ] Announce opt-out silences guild chat without affecting the commit
- [ ] Not in a guild: empty ladder, scoring paused, no BeefNet sends, no errors
- [ ] Officer tab hidden for a member; approve actions no-op if reached
