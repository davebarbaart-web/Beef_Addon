# Task 14 review — Pope desk (Thedave can run the night)

**Scope (this gate only):** live listed-Pope card door **THE DESK** / `OpenDesk` → `Console:Show()`; congregation card has no door and `OpenDesk` never Shows; `PHASE_HINT` names the next verb (spec #102), no wizard; `after()` paints refuses on `GateStatus` including End-during-RITE; petition row fills the next empty Fighter A/B or reads “use this petitioner”; no auto-sanction; `PairVictorA` / `PairVictorB` `SelectCharacter` only; `DECLARE VICTOR` commits; Task 3 `Show` / `Toggle` gate not unwrapped; Task 6 unsigned Zipfresh still paints and click does not mint. Pins in `tests/test_console.lua` / `tests/test_player_card.lua`.

Must hold: SCHEMA 7, Interface 20506, no commit. Implementation site is `UI/PlayerCard.lua` + `UI/Console.lua` — not `ChurchOfBeef.lua`.

Read: `.superpowers/sdd/task-14-brief.md`, `.superpowers/sdd/task-14-report.md`. Live `UI/PlayerCard.lua`, `UI/Console.lua`, `ChurchOfBeef.lua` (slash / Task 3 wrap only), the two test files, plus SCHEMA / TOC stamps. Full `lua tests/run.lua` was not re-run (per gate instruction). Isolated console / player-card suites were not re-run. Working tree was not mutated except this review file.

**Spec-compliance:** PASS

**Task quality:** Approved

The implementer report matches the live tree. Listed-Pope card grows **THE DESK**. Congregation card does not. `PHASE_HINT` is next-click copy, not rite poetry. `after()` paints End-during-RITE on `GateStatus`. Petition fill is A then B, then “use this petitioner,” and never Sanction. Pair names select. `DECLARE VICTOR` is the commit. Task 3 `Show` / `Toggle` still refuse non-Popes. Unsigned Zipfresh still paints. SCHEMA stays 7.

---

## Verdict

Task 14 matches the brief, Wave 2 first-night Task 14, and plan items 101–105 / #102. Thedave’s card is a desk door. Congregation still cannot mint the desk. Pair names are not a verdict.

---

## Spec Compliance

| Pin | Result | Evidence |
|-----|--------|----------|
| Listed-Pope card door → `Console:Show()`. Congregation has no door. `OpenDesk` refuses and never Shows | Met | `COPY.desk` is `THE DESK`. `paint()` `isListedPope()` shows `DeskButton` and recenters Records; else hides the door. `OpenDesk` returns false before `Show` when not listed. `test_player_card.lua`: congregation `IsShown` false / `THE DESK` absent / `OpenDesk` false / `deskShows` 0; listed-Pope door click + `OpenDesk` increment `Show`; later congregation paint hides and does not Show |
| Bare `/beef` stays the card. Must not look like a failed kit | Met | `ChurchOfBeef.lua` slash: empty arg → `PlayerCard:Toggle()`. Help still names the card. `test_player_card.lua` congregation `/beef` stays the card. `test_wire_glue.lua` `/beef` toggles the card |
| `PHASE_HINT` names the next verb (spec #102). No wizard. No sixth state | Met | `PHASE_HINT` is Quiet `Start the gathering.`; Assembly `Open a rite / End the gathering.`; Rite `Close this rite.`; Consequence `Continue / End the gathering.`. Fallback is Quiet. `runPhaseCopy` pins those strings and `assertNoStateNames` (no QUIET / ASSEMBLY / RITE / CONSEQUENCE on chrome). Knighting, Gora, and Confession rites share the same Close hint |
| `after()` paints refuses on `GateStatus`. End-during-RITE is visible | Met | `after()` on string `err` sets `lastRefuse` and `GateStatus`. Success clears and Refresh. `Runtime:EndEvent` refuse is `event ends from assembly or consequence`. `runTask14Desk`: End while RITE paints that string; state stays RITE; Close then clears the line |
| Petition fills next empty A/B, or “use this petitioner.” No auto-sanction | Met | `UsePetitioner`: store id → `SelectCharacter` then A then B. Both full → label `use this petitioner`, no slot overwrite. No `Sanction` on the row. Unsigned name-key: subject paint only. `runTask14Desk`: Ribeye → A, Flatiron → B, `GetSanctioned` nil both clicks, then `Ribeye  use this petitioner` |
| Pair names select only. `DECLARE VICTOR` commits. Invert PairVictor → `DeclareVictor` | Met | `PairVictorA` / `B` OnClick: `SelectCharacter(_cobVictorId)` + Refresh. `DeclareVictor` button calls `Console:DeclareVictor()`. Subject-verb pin: click B, wins stay 0, pair stays; `DECLARE VICTOR` wins 1 and clears the pair |
| Task 6 unsigned Zipfresh still paints; click does not mint | Met | `runUnsignedPetitionPaint`: strip finds `Zipfresh`; humans/characters unchanged on paint, click, and Dismiss; click does not fill A/B or Sanction; subject name is Zipfresh |
| Task 3 `Show` / `Toggle` not unwrapped. Congregation `/beef console` stays hidden | Met | `Console:Show` / `Toggle` still `if not isRegisteredPope() then return end` before Init/Show. `test_console.lua` non-Pope Show/Toggle do not mint and stay hidden after Init. `test_wire_glue.lua` congregation `/beef console` after Init is not shown. Help still hides the desk line from the pew |
| `ChurchOfBeef.lua` is not the implementation site | Met | No `THE DESK` / `OpenDesk` / `PHASE_HINT` / `UsePetitioner` / `PairVictor` in bootstrap. Slash help still says `The desk is /beef console.` for listed Pope. Console path still `Console:Show()` (gated) |
| SCHEMA 7. Interface 20506 | Met | `DB.lua` `SCHEMA_VERSION = 7`. TOC `## Interface: 20506`. Console / PlayerCard do not stamp either. `BeefNet` / `Codec` `PROTOCOL` stays 2 |
| Pins in `tests/test_console.lua` / `tests/test_player_card.lua` | Met | Console: inverted PairVictor, `runPhaseCopy` next-verb, `runTask14Desk` End-during-RITE + petition fill, unsigned click. Player card: congregation no door; listed-Pope door Shows |
| Do-not: commit; congregation desk mint; auto-sanction | Met | Report: no commit. Task 3 gate live. `UsePetitioner` / unsigned click never call `Sanction` |

---

## Strengths

- The door is listed-Pope only on both sides. The button hides on a later congregation paint. `OpenDesk` returns false before `Console:Show`. Congregation `/beef` stays the card.
- Pair-name invert is a real fat-finger fix. Clicking Tendermage does not write a win. `DECLARE VICTOR` is the commit. I-08 is inverted.
- Petition fill is A then B, then a label, and never a Gora. Unsigned Zipfresh still paints and still must not mint.
- `after()` paints the Core End-during-RITE string on `GateStatus` without ending the event. Success Refresh clears the line. Console source has no `Toasts` / `Proclaim`.
- Neighbors held. Task 3 `Show` / `Toggle` still refuse non-Popes after Init. SCHEMA stays 7. Bootstrap was left to Tasks 8–11.

---

## Issues

### Critical

None.

### Important

None that miss a Task 14 pin.

### Minor

1. **End-during-RITE chrome is invoke-only.** `End the gathering` stays hidden in RITE (existing phase paint). The refuse is visible on `GateStatus` when `EndEvent` is called. Report concern 2.

2. **Petition fill writes `selectedFighterA` / `B` directly.** It does not go through `SetFighterA` / `EnsureCharacterByName`. Unsigned click still must not mint. A later Pope verb on a name-only subject can still recognise-on-verb. Existing desk law. Report concern 3.

3. **The desk door is card-only.** Slash help still says `The desk is /beef console.` `ChurchOfBeef.lua` was left alone so Tasks 8–11 keep login / persist / stash. Brief allows that second door.

4. **`OpenDesk` does not hide the card.** `OpenRecords` steps aside. Two Pope windows can stack. Brief only required a control that `Show`s.

5. **Assembly hint names the phase verbs, not “target then knight.”** Spec #102’s Assembly sentence is broader. Live copy is next phase click, shared across rite types, with no wizard. `runPhaseCopy` pins that. Not a brief miss.

6. **Isolated suite counts in the report (2689 / 348) and full harness (17028 / 0) were not re-checked this pass.** Client `/reload` smoke for the door and End-during-RITE paint was not walked. Green isolated pins in source are not a gathering.

---

## Assessment

**PASS / Approved.**

Listed-Pope **THE DESK** Shows the console. Congregation has no door. `PHASE_HINT` names the next verb. `after()` paints End-during-RITE on `GateStatus`. Petition fills A then B or reads “use this petitioner,” and does not Sanction. Pair names select. `DECLARE VICTOR` commits. Task 3 `Show` / `Toggle` stay gated. Unsigned Zipfresh still paints. SCHEMA 7. Interface 20506.

Do not claim `POLISH:PASS`.
