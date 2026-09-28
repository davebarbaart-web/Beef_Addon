### Task 2: Honesty docs and install

**Files:**
- Modify: `docs/phases/solo-smoke.md` (`/beef` row)
- Modify: `docs/phases/v1-checklist.md` (player-card sentence if it still says footer Decree / old rubrics)
- Modify: `docs/REFORMATION_LOG.md` (short 2026-09-13 gathering-headline note)
- Install only (no WTF)

**Honesty (`/beef` row):** 320 wide; height 380 with no story, 540 with a story; Gathering plate under rank (live Decree line or muted `No gathering is posted.`); story rubrics `BEEF GORA` / `BEEF RIVALS` / `BEEF LEGACY` only when they have rows; thin empty charcoal close band; **CHURCH RECORDS** still the one door; guild-title display sentence stays; no feed / no position.

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
