# V-C — Records Book tome dress (review)

**Spec:** PASS
**Quality:** Approved

**Lane:** V-C Records Book tome dress (stock textures only)
**Brief:** `docs/reformation/vestments/briefs/V-C-records.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/V-C-records-report.md`
**Diff:** `docs/reformation/vestments/briefs/V-C-records.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, and the provided diff; then made one focused check per named risk (PAGE_TITLES vs HEAD; generated prose; roman on paint only; required `Media\\`; exclusive files). Law cited: Bible §10.9 / §14.2 / §19.3, Batch 2 §E, Law 1, Law 4, OPEN_QUESTIONS #3. Did not mutate addon code, did not re-run the harness, and did not treat writer counts as verified. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `PAGE_TITLES` unchanged | **Pass.** HEAD and the live table are the same nine Bible names in Bible order. The provided diff does not add, rename, or delete a title. OPEN_QUESTIONS #3 stays parked. |
| No generated prose | **Pass.** No `ordained`, no `This is not hatred`, no epithet / scripture generator. Famous Upsets stay `Name over Opponent`. The Undefeated stays a name. Citation is painted only when `e.citation` is already a non-empty string; `buildPages` never writes that field. |
| Roman on paint only | **Pass.** `GetPages` is still `deepcopy(buildPages())` with arabic `wins` / `streak` / `fought` / `losses` / `scoreA` / `scoreB`. Suite still pins `wins == 14`. Roman lives in `toRoman` / `displayCount` / `bodyText` only. |
| No required `Media\\` | **Pass.** Addon `Media\\RecordsTitle.ttf` and `Media\\records-seal` are gone. Live source has no `Media\\`. Stock `Fonts\\MORPHEUS.TTF` → `Fonts\\FRIZQT__.TTF` via `pcall`, then `GameFont*`. Parchment is `QuestBG` with a fill fallback. |
| Exclusive files only | **Pass.** Provided diff and scoped `git diff --stat` touch only the two exclusive files. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Console / Decree / Toasts / HUD / Store / TOC / bootstrap / OPEN_QUESTIONS / REFORMATION_LOG / commit | **Pass.** Packet and scoped exclusive-file diff are the two paths only. |
| OPEN_QUESTIONS #3 parked: do not add, rename, or delete `PAGE_TITLES` | **Pass.** Named-risk check vs HEAD. Navigation jumps among the existing nine. |
| Player-opened Quiet tome: movable, clamped, world visible, no sound, no search, not a ladder | **Pass.** `MODE = "QUIET"`. DIALOG, no dimmer. Init stays hidden. No `PlaySound`, `EditBox`, Search, Sort, or `#1` chrome. Prev/next stay. |
| Height ≈ 70% of `UIParent`, cap ~480 when parent height unknown | **Pass.** `tomeHeight()` uses `floor(h * 0.7 + 0.5)` when `h` is a positive number, else 480. Suite pins 480 on the stub parent. |
| Two-page-ish stock spread: QuestBG / stationery + iron/gold `WHITE8X8` | **Pass.** Left `Parchment` + `RightLeaf` via `pcall` `SetTexture` `Interface\QuestFrame\QuestBG`, fill fallback. Iron field, gold edge, gutter, title rule via `fill` / `WHITE8X8`. |
| Page title: `MORPHEUS` or `FRIZQT__` via `pcall`; `GameFont*` fallback | **Pass.** `applyFont` tries the page-title path, then the fallback font, then `SetFontObject`. |
| Drop required addon Media font/seal | **Pass.** Seal is stock `Interface\Buttons\UI-Quickslot2`, gold-tinted. No required addon Media path. |
| Ribbons jump only to existing `PAGE_TITLES`; no invented Cowardice page | **Pass.** Three clerical buttons: Victories → Most Sanctioned Victories, Rivalries → Greatest Rivalry, Martyrs → The Glorious Martyr. `jumpToTitle` no-ops on unknown titles. No Cowardice ribbon. Prev/next remain. Brief allowed three ribbons. |
| `toRoman` for 1–3999; `14` → `XIV`; painted counts roman | **Pass.** Public `RecordsBook.toRoman`. Painted victories / streak / chin / martyr / rivalry scores use `displayCount`. Famous Upsets stay name-over-name. |
| GetPages stays arabic; tests still pin numbers | **Pass.** `wins == 14` remains on the GetPages row while the FontString is `Highbeef` + `XIV` and not raw `14`. |
| No generated prose; citation only if the row already has a string | **Pass.** See named risk. Chrome stays clerical (`The Records Book`, Previous, Next, Close, ribbon labels). |
| Keep: nine Bible titles; Tournament Champions empty; GetPages copies; Show/Hide do not write Store; no slash | **Pass.** Existing pins are still in the suite. Isolation stays under `if standalone then`. |
| Add: `toRoman(14)=="XIV"`; painted victories contain roman not raw `14`; source grep no `ordained` / `This is not hatred`; no required `Media\\` | **Pass.** All present. Rivalry paint also pins `II` and refuses raw `2`. |
| **POLISH:CANDIDATE** at most | **Pass.** Writer claimed that and no more. |

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; QuestBG + `UI-Quickslot2` may read as quest-log chrome | **Not a spec miss.** CONTINUE license 4 and the brief require stock textures this wave. **POLISH:CANDIDATE** is the ceiling. |
| Height sampled once at first Init | **Not a miss.** Brief named the 70% / 480 rule, not live resize. Idempotent Init keeps the first height. |
| Cowardice ribbon omitted | **Not a miss.** Brief: three ribbons + prev/next if a fourth landing page is unclear. Did not invent a Cowardice superlative. |
| Right leaf is empty dress | **Not a miss.** Stock-only lane. Batch 2 facing-spread / medallions wait for licensed custom media. |
| `toRoman(0)` and out-of-range return `""` | **Matches the helper contract** (1–3999). See Minor on painted zeros. |

---

## Strengths

- `PAGE_TITLES` is untouched. Ribbons are labels that jump, not new categories. #3 stays a veto list.
- Law 4 holds. The addon still does not write scripture. Citation is an echo of an existing string, not a generator. Famous Upsets copy is unchanged.
- Roman is a paint helper. GetPages measures stay integers. The suite pins both sides of that split.
- Required addon Media paths are actually gone, not wrapped. Font and parchment attempts are `pcall` + stock fallback.
- Quiet contract is intact: no sound, no search, no OnUpdate, no slash, Show/Hide still do not write Store.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **`displayCount(0)` paints blank.** `toRoman` correctly returns `""` outside 1–3999. A rivalry `5–0` therefore drops the zero (`NameA  V –   NameB`). Brief named roman for rivalry scores and limited the helper to 1–3999. Not a Law 4 miss; zeros are unpinned.

2. **Chrome title and page title sit on the full 720-wide frame** while body + title rule are left-leaf only. The right leaf is empty dress, as the writer said. Stock-only; not a tenth page.

3. **Seal `SetTexture` is not `pcall`'d.** Path is stock `UI-Quickslot2`, not addon Media. Parchment and fonts are more defensive than the seal.

4. **Citation paint and unknown-title no-op are implemented, not pinned.** `buildPages` never sets `citation`. `jumpToTitle` only matches `PAGE_TITLES`. Suite covers the three named landings and refuses a Cowardice button.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Writer-reported isolated `tests/test_records.lua` **286 / 0** was **not** re-run here. Do not treat that count as verified.

---

## Assessment

**Spec PASS. Quality Approved.**

This is the V-C vestment contract: stock parchment spread, roman tallies on painted body only, nine Bible pages unchanged, no generated prose, no required `Media\\`, exclusive files only. Named risks are clean. Minors are zero-score paint, empty right leaf, and unsmoked stock chrome — not trust-breakers.

Writer-reported isolated **286 passed, 0 failed** was not re-run. Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
