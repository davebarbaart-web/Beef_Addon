# Player Card Gathering Headline Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development. TDD per task. **Do not commit** unless David asks — append `.superpowers/sdd/progress.md` instead.

**Goal:** Make `/beef` read as identity + a Gathering headline, not three empty ledgers. Empty story sections collapse. Rubrics rename to Beef Gora / Beef Rivals / Beef Legacy.

**Approved decisions (David, 2026-09-13):** stacked C; Gathering-only status (lift Decree from footer); empty ledgers collapse; empty Gathering keeps muted `No gathering is posted.`; thin charcoal close band with no copy; rename rubrics; Approach 1 (Gathering plate, height shortens to a 380 floor).

**Files:** `addon/ChurchOfBeef/UI/PlayerCard.lua`, `tests/test_player_card.lua`. Task 2: honesty docs + Anniversary install.

## Global Constraints

- Product law: `docs/design/Game_Design_Bible_v1.1.1.md`. Law 1, 4, 6, 9, 10. §10.9: no position among members. §14.2: player-opened Quiet identity/history — not an always-on dashboard or feed.
- No presence census, last-rite line, or Chronicle headline on this card. The Gathering (Decree `line`) is the only Church-status fact.
- Banned in shipped `PlayerCard.lua` source: `standing`, `Grant`, `threshold`, `suggestion`, `elo`, `leaderboard`, `prophet`, `#1`, `rating`, `ranked`, `BEEF POPE`.
- MODE QUIET. No sound, toast, pip, `OnUpdate`.
- Ink: parchment text is charcoal / iron / oxblood. Gold, parchment, and class color text only on charcoal plates. Class color on names only.
- Dress through `COB.Theme` only. No `Interface\\` paths, RGB literals, font paths.
- Copy is clerical. UI never narrates or jokes.
- Lua 5.1. Watch the 200-local cap. No new top-level files. No TOC change. Interface stays `20506`.
- Persist: `ChurchOfBeefDB.ui.playerCard.point` only. No width/height persist. `SetResizable(false)` stays.
- UI reads `Decree:Get()`, Store, Records, Ranks. No store writes. No Core→UI.
- Tests: TDD. `lua tests/test_player_card.lua` then `lua tests/run.lua` exit 0.
- Do not commit. Do not touch `WTF/`.
- POLISH:CANDIDATE only.

---

### Task 1: Gathering plate, collapse, renamed ledgers

**Files:**
- Modify: `addon/ChurchOfBeef/UI/PlayerCard.lua`
- Modify: `tests/test_player_card.lua`

**Layout (top → bottom, width 320):**

1. Title band — unchanged (seal, `CHURCH OF BEEF`, CLOSE).
2. Identity plate — unchanged.
3. Rank plate + relationship + knighted + guild — unchanged.
4. **Gathering plate** — always shown. Charcoal plate, height 56 (same as identity). Left: existing `sigil_gora_small` (move off the footer). Small gold label `GATHERING`. Decree line in parchment type when a line is Set; muted iron `No gathering is posted.` when none. Do not show Decree `flavor`.
5. Story sections only when they have rows:
   - `BEEF GORA` when `record.fought > 0` (roman pair, streak, defenses as today).
   - `BEEF RIVALS` when `#rivalries > 0` (up to 3 `vs` lines as today).
   - `BEEF LEGACY` when `#distinctions > 0` (held superlatives then honorifics as today).
   Empty sections are **hidden** (`Hide()` on rule, rubric, and body widgets). Do not paint `No sanctioned bouts.`, `No rivalries yet.`, or `None yet.`
6. **CHURCH RECORDS** — still the one door; still steps aside for the book.
7. **Close band** — charcoal, height 16 (`Theme.Space.md`), no copy, no sigil, no Decree.

**Height:** `SetHeight(380)` when no story section is shown; `SetHeight(580)` when any of Gora / Rivals / Legacy is shown. Not user-resizable. Do not persist size.

**COPY** (exact):

```
gathering = "GATHERING"
goraLabel = "BEEF GORA"
rivalriesLabel = "BEEF RIVALS"
distinctionsLabel = "BEEF LEGACY"
noDecree = "No gathering is posted."
```

Keep existing identity / records / close / knighted / streak / defenses copy. Delete unused empty-ledger COPY keys (`noBouts`, `noRivalries`, `noDistinctions`) if nothing paints them.

**Paint / layout:**

- First visible story section anchors under the Gathering plate (below the plate, not the footer).
- Hidden sections do not hold layout.
- `DistinctionsText` BOTTOM stays bounded by `RecordsButton` when Legacy is shown.
- `RecordsButton` stays above the close band.
- Parchment still fills between title band and close band.
- Live Gathering ink: `DecreeText` role `parchment` on the charcoal plate. Empty Gathering: role `iron`.
- Rubrics stay oxblood on parchment when shown.
- `GatheringLabel` gold on charcoal. `GatheringPlate` charcoal.

**Header comment** in `PlayerCard.lua`: say identity + Gathering headline; empty story collapses; no feed.

**Tests** (`tests/test_player_card.lua`) — update existing pins; add the new ones. TDD: change/add assertions first, run isolated suite, watch RED, then implement.

Empty / unrecorded card (`Show` after `reset()`, no guild):

- Width 320, height **380**.
- `GatheringPlate` exists, charcoal.
- `GatheringLabel:GetText()` == `GATHERING`.
- `DecreeText:GetText()` == `No gathering is posted.`
- `DecreeText._cobColorRole` == `iron`.
- `GoraLabel:IsShown()` == false, `RecordText:IsShown()` == false.
- `RivalriesLabel:IsShown()` == false, `RivalryLines[1]:IsShown()` == false.
- `DistinctionsLabel:IsShown()` == false, `DistinctionsText:IsShown()` == false.
- `allText()` does not contain `SANCTIONED GORA`, `No sanctioned bouts.`, `No rivalries yet.`, `None yet.`, `RIVALRIES` as a rubric (the word `Rivalries` in comments is fine; painted widget text must not be the old rubrics).
- `allText()` contains `BEEF GORA` / `BEEF RIVALS` / `BEEF LEGACY` only when those sections are shown — so **not** on the empty card.
- Footer/close band has no Decree / no sigil. `DecreeSigil` parent/point is the Gathering plate (or its children), not the footer.
- Rank / format / CLOSE / CHURCH RECORDS / no-sound pins stay.

Knight card (`seedKnight` + `Show`):

- Height **580**.
- `GoraLabel:GetText()` == `BEEF GORA`, shown.
- `RivalriesLabel:GetText()` == `BEEF RIVALS`, shown.
- `DistinctionsLabel:GetText()` == `BEEF LEGACY`, shown.
- Record / rivalry / distinction / decree **line** pins stay (`II–N`, vs Tendermage, superlatives, `Goldshire Inn — Sunday, 7:00 PM`).
- `DecreeText._cobColorRole` == `parchment` (no longer gold-on-footer).
- `GatheringLabel._cobColorRole` == `gold`.
- Parchment-ink loop still includes shown ledger type (rubrics oxblood, record charcoal, etc.). Do not require footer-gold on `DecreeText`.
- `DistinctionsText` BOTTOM still relative to `RecordsButton`.

Guild-title / unranked / store-wins tests that currently assert `RecordText` == `No sanctioned bouts.`: assert the Gora section is hidden instead.

Missing `COB.Decree`: Gathering still paints `No gathering is posted.`; story still collapses if no record.

Lifecycle / persist / OpenRecords / ResetForTests / src grep pins stay. `ChurchOfBeefDB.ui.playerCard.w` still nil.

**Do not:** add Core keepers, Net, Console changes, presence, last Chronicle row, flavor on the card, a seventh rank, commits.

- [ ] **Step 1:** Write the failing test updates.
- [ ] **Step 2:** `lua tests/test_player_card.lua` — expect FAIL on height / labels / collapse / Gathering plate.
- [ ] **Step 3:** Implement `PlayerCard.lua`.
- [ ] **Step 4:** Isolated suite green, then `lua tests/run.lua` exit 0.
- [ ] **Step 5:** Do not commit. Write the report file.

---

### Task 2: Honesty docs and install

**Files:**
- Modify: `docs/phases/solo-smoke.md` (`/beef` row)
- Modify: `docs/phases/v1-checklist.md` (player-card sentence if it still says footer Decree / old rubrics)
- Modify: `docs/REFORMATION_LOG.md` (short 2026-09-13 gathering-headline note)
- Install only (no WTF)

**Honesty (`/beef` row):** 320 wide; height 380 with no story, 580 with a story; Gathering plate under rank (live Decree line or muted `No gathering is posted.`); story rubrics `BEEF GORA` / `BEEF RIVALS` / `BEEF LEGACY` only when they have rows; thin empty charcoal close band; **CHURCH RECORDS** still the one door; guild-title display sentence stays; no feed / no position.

**Install:**

```bash
: "${WOW_ADDONS_DIR:=/Applications/World of Warcraft/_anniversary_/Interface/AddOns}"
rsync -a --delete /Volumes/AI_Design_Drive/Beef_Addon/addon/ChurchOfBeef/ "$WOW_ADDONS_DIR/ChurchOfBeef/"
```

Do not commit. Do not zip-upload. Do not claim POLISH:PASS.

- [ ] **Step 1:** Update the three honesty files.
- [ ] **Step 2:** `lua tests/run.lua` still 0 failed (docs-only; run to confirm Task 1 still green).
- [ ] **Step 3:** rsync install.
- [ ] **Step 4:** Report file. Do not commit.
