# Wave 2 Task 2 — honesty leftover audit

**Date:** 2026-09-14  
**Scope:** leftover LIES that claim Console / HUD / Records / favor / Popes / Decree are unhosted or “forthcoming” when they ship.  
**Plan:** `docs/superpowers/plans/2026-09-14-church-of-beef-first-night-wave-2.md` Task 2.  
**Fleet log:** `docs/superpowers/plans/2026-09-14-fleet-dispatch.md` (honesty lanes already marked Done).  
**Not done here:** product Lua (except reading `BeefNet.lua` header), Status / Result ticks, OPEN_QUESTIONS **#11** resolution, commit.

Fleet first-wave lanes had already rewritten most exclusive files. This pass found leftover false sentences **outside** the leftover table and one leftover A13 method line. Those docs-only lines were fixed. No Status boxes were ticked. **#11 stays open.**

---

## Remaining lies (after this pass)

**None** in the exclusive Task 2 files of the “unhosted / forthcoming” class.

Named leftovers that stay leftovers (honest): SUMMON, confession inbox UI, live HUD health, cold-tools UI, two-client smoke, **#8** designated-Council UX, **#26**, **#27**, A01–A04 Results, Wave 2 Task 10 congregation SV restore.

**#11** is still open. Guild-night already says `/beef console` is used tonight and **does not resolve #11**. This audit does not mark it resolved.

---

## Lies found and fixed (docs only)

Quoted as they stood **before** this pass.

### `docs/phases/v1-checklist.md` (leftover table was already honest)

1. Honesty opener:

   > Most Event boxes cannot be walked yet.

   Contradiction of the same section (“Coded and walkable: favor … Decree wire … STATE”). Desks are hosted; they are unwalked, not unhosted.

   **Edit:** “Event desks are hosted. **Do not tick leftovers as done.** A human walk is still required before any Event box is ticked.”

2. Quiet Tuesday Decree box:

   > minimap left-click replays it. … (Posting a Decree from a hosted Console is leftover — do not tick Console Post here)

   Two falsehoods: replay is **right-click** (`UI/Minimap.lua`); Console **Post the Decree** is coded (`UI/Console.lua` `PostDecree`).

   **Edit:** right-click replay; Post named as coded; this box stays login parchment + replay (box left `[ ]`).

3. §22.3 closer:

   > Do not tick this section while **#8**, hosted Console / HUD / Records, **favor**, Sound callers, or **SUMMON** remain leftovers that the night still needs.

   Treats hosted Console / HUD / Records / favor (and Pope-local Sound) as leftovers. They ship.

   **Edit:** leftovers named as two-client smoke, inbound Proclaim / Sound (**#27**), SUMMON, **#8** designated-Council UX. Hosted surfaces named as coded, still needing a human Gathering walk.

### `docs/phases/guild-night-playtest.md`

4. Decree walk:

   > Dismiss; minimap left-click replays

   Same wrong click. Dress rehearsal already said right-click.

   **Edit:** right-click. Box left `[ ]`. Status still **NOT RUN**.

### `docs/validation/A13-login-reload.md`

5. Method step 4 leftover:

   > If `#8` is still fail-closed, record "request timing only; theater snapshot not authorized" — do not invent a Pope list.

   `#8` remainder is designated-Council UX. `Data/Popes.lua` ships **Thedave**. The Pope list is not fail-closed.

   **Edit:** Thedave ships; STATE / SNAPSHOT accept listed senders; do not invent designated-Council UX. **Result:** still **NOT RUN**.

Leftover table in `v1-checklist.md` was **not** rewritten this pass — it already listed only real leftovers.

---

## Already honest (no edit)

### Leftover table — `docs/phases/v1-checklist.md`

Bottom table names **#8** remainder (Thedave ships; Council UX open), SUMMON, confession inbox UI, live HUD health (no-health HUD hosted), cold-tools UI, two-client smoke. Does **not** list Console / HUD / Records / favor / Decree / Popes as unhosted.

Honesty bullets already: player card + `/beef console`, Thedave + `popeOverrides`, favor / Decree wire / STATE / HELLO rebroadcast / petition INPUT as coded.

§22.1 component rows already say hosted / coded for Console, HUD, Records, Decree, favor. Boxes stay `[ ]`.

### `docs/phases/dress-rehearsal.md`

**Status:** NOT RUN (header and **Release gate:** NOT RUN). Boxes `[ ]`.

Honest map: hosted Pope desk + Quiet card; Decree Post + right-click replay + DECREE; `/beef console` on listed Pope (Thedave); HUD for a real pair; favor plates; Records behind **CHURCH RECORDS**; STATE on transitions; HELLO rebroadcast. Named leftovers: SUMMON, #26, #27, live health, cold-tools, two-client smoke, #8 Council UX.

### `docs/phases/guild-night-playtest.md` (except the left-click line)

**Status:** NOT RUN (header and **This night:** NOT RUN).

Mentions player card, `/beef console` (does not resolve #11), and STATE (on every Runtime transition + HELLO rebroadcast). Hosted Console / HUD / Records / favor / Decree / Thedave.

### Appendix A leftover sentences

| Sheet | Result | Honesty |
|-------|--------|---------|
| `A03-sender-integrity.md` | NOT RUN | Thedave ships; rituals / STATE / SNAPSHOT accept listed characters; #8 remainder is Council UX. Sender primitive still unwalked. |
| `A05-raid-markers.md` | NOT RUN | `Markers.lua` `SetRaidTarget` / `TargetUnit` exist; that is not a Result pass. Desk-visible refuse leftover. |
| `A06-targeting-by-name.md` | NOT RUN | `Markers:Target` is not a pass. #8 remainder + Thedave named. Not an uncoded Pope list. |
| `A13-login-reload.md` | NOT RUN | Banner exists ≠ timing Result. HELLO rebroadcast named. Wave 2 Task 10 congregation SV restore still “not implemented here” (honest; not a hosted-surface lie). |

### `README.md`

> The Decree ships as that Quiet Mode parchment — once per login, replayable from the minimap, posted from the Console, broadcast as DECREE.

Usage already: `/beef` player card + **CHURCH RECORDS**; `/beef console` listed-Pope desk.

Out of Task 2 class (not edited): “Machine ids belong in `Data/Ranks.lua` after Phase 1” is stale phase wording, not an unhosted-Decree lie.

### `.gitignore`

`/ChurchOfBeef.zip` and `/addon/ChurchOfBeef.zip` are ignored. Comment notes the 2026-08-20 zip is stale.

### `addon/ChurchOfBeef/Net/BeefNet.lua` header

Outbound STATE / SNAPSHOT / DECREE send if the local player is a registered Pope (`Data/Popes.lua` + `popeOverrides`). Not “always false until #8.” `SendState` exists. **No Lua edit.**

### OPEN_QUESTIONS #11

Still open: slash vs Bible §18 host. Wave 2 line already names `/beef console` + player card. **Not marked resolved.**

---

## Status / Result (untouched)

- `dress-rehearsal.md` Status: **NOT RUN**
- `guild-night-playtest.md` Status: **NOT RUN**
- A03 / A05 / A06 / A13 Result: **NOT RUN**
- All `[ ]` boxes left unchecked

---

## Out of exclusive-file scope (not edited)

`docs/validation/README.md`: “OPEN_QUESTIONS #8 … is not coded from these sheets.” Sloppy (Pope list is coded; remainder is not) but not a Task 2 exclusive file.
