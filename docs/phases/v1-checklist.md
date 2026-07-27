# Church of Beef — V1 Verification Checklist

Walkable success criteria under the Accepted **roster-backed** amendment
([roster-backed design](../superpowers/specs/2026-07-25-roster-backed-ladder-design.md) §11)
and the parent [design spec](../superpowers/specs/2026-07-25-church-of-beef-design.md)
(§13 as amended by the 2026-07-26 §15 Accept note).

A green offline harness (`lua tests/run.lua`) is a precondition, not a substitute.
Prefer the single-client pack first: [`solo-smoke.md`](solo-smoke.md).

Do not claim V1 complete until every box is ticked and dated.

**Polish ≠ V1 complete:** functional ticks and agent `POLISH:CANDIDATE` evidence do
**not** auto-grant `POLISH:PASS` or V1 complete. Guild-chat promote spectacle is
**deferred** under the roster-backed amendment (no Commit announcer).

Tick a box by replacing `[ ]` with `[x]` and appending `— YYYY-MM-DD, character`.

## Success criteria (roster-backed §11 + scoring)

- [ ] **1. Loads on TBC Classic Anniversary** and appears in the AddOns list as
      **Church of Beef** (`## Interface: 20506`, no "out of date" toggle needed)
- [ ] **2. `/beef` opens a real frame**, not a chat-only response — including on a
      fresh install where no `ChurchOfBeefDB` exists yet
- [ ] **3. Ladder occupants come from the live guild roster** via the fixed
      `rankIndex`→Church map; local title/standing visible and match canon titles
      (`Data/Ranks.lua`) plus the map in the roster amendment
- [ ] **4. Shared instance co-play grants capped standing** — a dungeon, raid or BG
      with at least one guildmate pays per closed bucket the player fought in, and
      stops paying at the daily cap
- [ ] **5. Thin Gora and ceremony actions grant standing** — a recorded Gora result
      (win, draw *and* loss) and a cleanly closed ceremony both pay
- [ ] **6. Crossing a threshold creates an officer-visible promote suggestion** and
      never auto-promotes; Council and Prophet never appear as suggestion targets
- [ ] **7. Officer tab is Dismiss + standing correction only** — no Approve-commit /
      Demote / Council / Prophet rites; copy tells officers to promote in the
      guild roster
- [ ] **8. Promoting in the Blizzard guild UI updates the Ladder** on roster refresh;
      satisfied suggestions auto-clear
- [ ] **9. Addon never calls guild promote/demote APIs**; legacy `RANK_COMMIT` on the
      wire is soft-ignored (does not invent ranks)
- [ ] **10. No Retail-only APIs and no combat automation** — `/console scriptErrors 1`
      plus BugSack stay clean through a full session
- [ ] **11. Solo social check (deferred `/g`):** at least one promote suggestion is
      acted on in the guild UI during a real session and the Ladder visibly moves.
      Full guild-chat spectacle returns only with a future roster-diff announcer.

## Verification approach

- [ ] [`solo-smoke.md`](solo-smoke.md) walked on a TBC Anniversary client (GM/Officer+)
- [ ] Optional: second client for suggestion fanout (`SUGGESTION` toast on Officer+)
- [x] Load-with-missing-assets smoke test — vacuous in V1 and intentionally so: the
      addon ships no `Media/` folder and references only default Blizzard textures and
      fonts, so there is nothing to go missing. Re-open this box the moment custom
      media lands. — 2026-07-25, offline grep of the addon tree
- [ ] Doc review: canon ranks match what the UI shows; deferred features (announce,
      ceremonial dashboard) are marked as later-phase rather than looking broken

## Supporting checks

- [ ] `lua tests/run.lua` exits 0 from the addon checkout root
- [ ] `ChurchOfBeef.toc` lists only files that exist, lists every file that exists,
      and load order is `Data → Core → Net → UI → bootstrap` with `MainFrame` ahead of
      the tabs that register into it
- [ ] `ChurchOfBeefDB` survives `/reload` and logout, and stays comfortably under 1 MB
- [ ] Frame position and minimap toggle persist across sessions
- [ ] Announce checkbox stays hidden / inactive until a roster-diff announcer lands
- [ ] Not in a guild: empty ladder, scoring paused, no BeefNet sends, no errors
- [ ] Officer tab hidden for a member; dismiss / standing correction no-op if reached
- [ ] UI polish evidence attached for touched surfaces? (`POLISH:CANDIDATE` + `/reload`
      smoke notes — optional support; not a numeric rubric; does **not** replace
      criterion 11 or human `POLISH:PASS`)
