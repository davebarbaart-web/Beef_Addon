# Task 13 review — HUD copy + toast gloss

**Scope (this gate only):** live HUD hover `Click to pick this side.`; footer **Pick a side** before the first pick; after a ruling hide favor, footer **Ruled**, no invented winner, until Continue (#110); toast Void `This fight does not count.`; cowardice headline says fled; sanction keeps pomp with one plain `A sanctioned duel.` line under it; free ruling keeps `"Free ruling."` or the Pope’s text; **no** `The Pope ruled.`; no inbound `Toasts:Proclaim` / Sound (#27); #111 bootstrap dismissed flag not unwrapped; pins in `tests/test_hud.lua` / `tests/test_toasts.lua`.

Must hold: SCHEMA 7, PROTOCOL 2, Interface 20506, no commit. Implementation site is `UI/Hud.lua` + `UI/Toasts.lua` — not `ChurchOfBeef.lua` / FighterCard / Console / Inputs / DB / Codec.

Read: `.superpowers/sdd/task-13-brief.md`, `.superpowers/sdd/task-13-report.md`. Live `UI/Hud.lua`, `UI/Toasts.lua`, `ChurchOfBeef.lua` (#111 wrap only), the two test files, plus SCHEMA / PROTOCOL / TOC stamps. Full `lua tests/run.lua` was not re-run (per gate instruction). Isolated HUD / toast suites were not re-run. Working tree was not mutated except this review file.

**Spec-compliance:** PASS

**Task quality:** Approved

The implementer report matches the live tree. Hover and pre-pick footer are the pinned strings. After a pickable fight ends, favor hides and the footer reads **Ruled** until Continue. `view.winner` / `view.verdict` stay nil. Void / fled / sanctioned-duel / Free ruling are Pope-local `clericalCopy` only. Inbound STATE still does not Proclaim. `#111` is still the bootstrap dismissed flag. SCHEMA stays 7. PROTOCOL stays 2.

---

## Verdict

Task 13 matches the brief and #110 / #27. HUD copy is pick-a-side until a ruling, then Ruled with no invented winner. Toast gloss is clerical and Pope-local. Congregation leftover RITE + fighters cannot tell sanctioned-in-progress from already-ruled tape — that is #27, not a Task 13 miss.

---

## Spec Compliance

| Pin | Result | Evidence |
|-----|--------|----------|
| Hover: `Click to pick this side.` Only while `pickPair()` is live | Met | `Hud.COPY.favorHint`. `pickA` / `pickB` `OnEnter` → GameTooltip that string. After a ruling `pickPair()` is nil so the tip hides. `runTask13` + source + `COPY` pins |
| Footer **Pick a side** at a 0/0 split; after the first pick the rubric may stay `FAVOR` | Met | `paintFavor`: `a + b == 0` → `COPY.pickSide`. After `RecordFavor` the label is `FAVOR`. Inverted Pope-zero / broadcast-zero pins + `runTask13` |
| After a ruling: hide favor, footer **Ruled**, until Continue (#110) | Met | `updateRuledFlags`: pickable pair gone + `sawPickable` → `persistRuled`. `paintRuledFooter` hides bars / percents / sigil, shows `COPY.ruled`. Continue (`CONSEQUENCE` → `ASSEMBLY`) sets `leftoverAfterContinue` and clears Ruled. `runTask13` + Pope / leftover-subjects persist pins |
| No invented winner / verdict qualifier | Met | `lastView` / `hiddenView` have no `winner` or `verdict`. STATE subjects stay `candidate` + `fighters` (`Codec` encode refuses other keys). `view.winner` / `view.verdict` pins stay nil |
| Void → `This fight does not count.` | Met | `clericalCopy` `ruling == "void"` returns that string for headline / chat. Inverted theater + source pins |
| Cowardice headline says fled | Met | `Cowardice recorded: <name> fled. So ruled by the Beef Pope.` Headline and chat. `test_toasts.lua` Thickcut pin |
| Sanction: pomp headline + one plain sanctioned-duel line under it | Met | Headline `A Beef Gora is Sanctioned`. Body starts `A sanctioned duel.` then A / VS / B. Theater copy pin |
| Free ruling: keep `"Free ruling."` or Pope text; **no** `The Pope ruled.` | Met | Empty free → `"Free ruling."`; provided text is used as-is. Source `find("The Pope ruled.")` is nil. Void / free theater pins |
| No inbound `Toasts:Proclaim` / Sound (#27) | Met | Toasts has no `_HandleState` / `HandleState` / `SendState`. Hud source has no `Proclaim` / `Toasts` / `PlaySound`. Bootstrap `proclaim()` is Pope-verb wraps only (`Sanction`, `DeclareVictor`, `Void`, `FreeRuling`, `CowardiceRecorded`, knight / elevate). `_HandleState` wrap still stash + favor + #111 card — no Proclaim. `OPEN_QUESTIONS.md` #27 still unanswered |
| #111 dismissed flag not unwrapped; `ChurchOfBeef.lua` not the implementation site | Met | `_HandleState` wrap still CONSEQUENCE Hide + `_fighterCardDismissed = true`; later RITE + two fighters Shows only if dismissed is not true. Task 13 copy lives in Hud / Toasts. FighterCard has no hover / Ruled / toast gloss |
| Pins in `tests/test_hud.lua` / `tests/test_toasts.lua` | Met | HUD: `COPY` strings, source hover / Ruled, inverted FAVOR pre-pick, persist Ruled, `runTask13` (hover, Pick a side, Ruled, no winner, Continue clears Ruled, no pick tip). Toasts: inverted Void / fled / sanctioned duel; no `The Pope ruled.`; no inbound STATE handlers |
| SCHEMA 7. PROTOCOL 2. Interface 20506 | Met | `DB.lua` `SCHEMA_VERSION = 7`. `BeefNet.lua` / `Codec.lua` `PROTOCOL = 2`. TOC `## Interface: 20506`. Hud / Toasts do not stamp either |
| Arabic records optional; do not block Task 14 | Met | W/L and defenses stay `Common.RomanNumeral` / `RomanPair`. No Roman invert this slice |
| Do-not: commit; inbound theater; unwrap #111; invent a winner / beat field | Met | Report: no commit. No clerical beat on STATE. Winner id is not knowable without a new field, so footer is Ruled |

---

## Strengths

- Pre-pick vs post-pick is a real invert, not a comment. Zeros say **Pick a side**. After the first pick the rubric may stay `FAVOR`. Hover is the same sentence and goes away when the pair is no longer pickable.
- #110 does not invent a winner. Pope STATE subjects are still `candidate` + `fighters`. Hud hides the split and stamps **Ruled**. `view.winner` stays nil on live, persist, leftover subjects, and Continue.
- Continue is the named exit. `CONSEQUENCE` → `ASSEMBLY` clears Ruled and does not restore favor. QUIET still `forgetPersist`s.
- Toast gloss stays clerical and Pope-local. Void is plain. Cowardice says fled. Sanction pomp is kept with one sanctioned-duel line under it. Free ruling is `"Free ruling."` or the Pope’s text. Source has no `The Pope ruled.`
- #27 and #111 held. Inbound STATE does not Proclaim or Sound. The fighter-card dismissed flag is still the bootstrap wrap Task 8 pinned.

---

## Issues

### Critical

None.

### Important

None that miss a Task 13 pin.

### Minor

1. **Winner name is not stamped.** Correct for this slice. A winner id is not on Pope STATE subjects without a beat field. Report concern 1.

2. **Congregation leftover RITE + two fighters stays pickable.** `pickPair()` is GetSanctioned (Pope) else `congregationPair()` (ASSEMBLY or RITE + Gora). After a Pope ruling that clears Gora but leaves Runtime fighters, the pew cannot tell sanctioned-in-progress from already-ruled tape. Ruled chrome lands when `pickPair()` is gone. Report concern 2. `#27`.

3. **CloseRite without a local ruling also paints Ruled.** Congregation OpenRite → CloseRite drops `pickPair()` (CONSEQUENCE is not a congregation pick state) while `sawPickable` is still true. That is inferred from persist, not from a clerical beat. Report concern 3.

4. **Arabic records were left as Romans.** Brief said optional. Do not block Task 14.

5. **Fighter card was not touched.** #111 still depends on the bootstrap dismissed flag. Do not unwrap `ChurchOfBeef.lua`.

6. **Isolated suite counts in the report (1039 / 508) and full harness (16967 / 0) were not re-checked this pass.** Client `/reload` smoke was not walked. Green isolated pins in source are not a gathering.

---

## Assessment

**PASS / Approved.**

HUD hover is `Click to pick this side.` Footer is **Pick a side** before the first pick and **Ruled** after a ruling until Continue. Favor hides. No winner string. Void / fled / sanctioned duel / Free ruling are Pope-local clerical copy. No inbound Proclaim / Sound. #111 stays wrapped. SCHEMA 7. PROTOCOL 2. Interface 20506.

Do not claim `POLISH:PASS`.
