# V-D — HUD iron/parchment dress (review)

**Spec:** PASS
**Quality:** Approved

**Lane:** V-D HUD iron/parchment dress (stock textures only; after V-B)
**Brief:** `docs/reformation/vestments/briefs/V-D-hud.md`
**API note:** `docs/reformation/vestments/briefs/V-stock-textures.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/V-D-hud-report.md`
**Diff:** `docs/reformation/vestments/briefs/V-D-hud.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

Task-scoped gate only. Reviewer read the brief, the stock-texture note, the writer report, and the provided diff; then made one focused check per named risk (`health` stays nil; no `UnitHealth`; no faction icons; W-F favor / `PickFavor` still work; exclusive files only). Law cited: Bible §10.7 / §19.3, CONTINUE license 4, Batch 2 §D **dress only**, Appendix A01 fallback. Did not mutate addon code, did not re-run git or the harness, and did not treat writer counts as verified. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `health` stays nil | **Pass.** `hiddenView` and `paintShown` both set `health = nil`. Quiet, shown, Pope, and post-rebuild views re-pin nil. Mutating a copy’s `health` does not change `GetView()`. |
| No `UnitHealth` | **Pass.** `Hud.lua` has no `UnitHealth`, `UnitHealthMax`, combat-log, or nameplate scrape. Suite source greps and `healthReads == 0` stay. Rails are 2px `Texture`s, not StatusBars. |
| No faction icons | **Pass.** Center is gold-tinted `Interface\Buttons\UI-EmptySlot-White`. Source greps refuse `Interface\PvPFrame\`, `PVP-Banner`, `UI-PVP-Horde`, `UI-PVP-Alliance`, and the extra V-stock `PlusManz-*` paths. |
| W-F favor / `PickFavor` still work | **Pass.** Provided diff does not touch `resolveFavor`, `SetBroadcastFavor`, `PickFavor`, plate `OnClick`, or percent math. Pope still reads `Gora:GetFavorSplit()`; congregation still reads broadcast only; `{2,1}` stays 66/34; plate send still needs target + local id. |
| Exclusive files only | **Pass.** Provided diff is two `diff --git` hunks: `UI/Hud.lua` and `tests/test_hud.lua`. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Toasts / Console / Decree / Records / Gora / Net / bootstrap / TOC / OPEN_QUESTIONS / REFORMATION_LOG / Media / commit | **Pass.** Packet touches only the two exclusive files. |
| Event Mode; Quiet still hides; no `OnUpdate`; no new sound | **Pass.** `MODE = "Event"`. Quiet / no-pair still `paintHidden`. Resting and post-drag `OnUpdate` stay nil. Source has no `PlaySound`. Suite `sounds == 0`. |
| Height ≤ 12% of `UIParent`; unknown parent keeps ~current card; do not grow into a toast | **Pass.** `hudHeight` is `min(100, floor(h * 0.12 + 0.5))` when parent height is a positive number; else **100**. Width stays 420. Suite pins 100 on the stub parent (no height) and 92 on 768. |
| Iron/parchment via QuestBG `pcall` + `WHITE8X8` / tooltip border | **Pass.** Backdrop edge is `UI-Tooltip-Border`. Iron field and gold rule go through `fill()`. Parchment is `pcall` `SetTexture` `Interface\QuestFrame\QuestBG`, then a parchment fill. |
| Center not Horde/Alliance; EmptySlot / TrackingBorder / or no crest | **Pass.** Named-risk check. `UI-EmptySlot-White` is the V-stock preferred ring. VS + FAVOR stay. |
| Class color on names; no live health bars; mute rails allowed | **Pass.** Names still take `nameColor`. Rails are fighter-tinted 2px textures. Exactly two StatusBars (favor halves). No percent health on the rails. |
| Keep `UI-StatusBar` for favor halves | **Pass.** `STOCK_BAR` unchanged. Suite still greps `UI-StatusBar` and pins two StatusBars after dress. |
| Head-to-head stays; Church title, not “Beef Paladin” | **Pass.** H2H is still the Store record (`1-0`), not narration. Title still comes from `Ranks.Title` (`Beef Knight`). Source and paint refuse `Paladin`. |
| W-F favor contract unchanged (Pope / congregation / `health` nil / plate `PickFavor`) | **Pass.** See named risk. `Hud.Favor` / `Hud.SendFavor` stay nil. |
| `GetView` still a copy | **Pass.** Still `deepcopy(lastView)`. Existing mutate pins plus a post-rebuild copy pin. |
| Isolation asserts stay under `if standalone then` | **Pass.** Nil-module block and the standalone summary print are unchanged and still gated. New dress pins sit in the shared body. |
| Named tests (faction greps, height budget, GetView copy, keep W-F / health / nameplate pins) | **Pass.** All present on the provided diff. |
| No custom media; **POLISH:CANDIDATE** at most | **Pass.** No `Media\`, `.tga`, `.blp`, or `.ttf`. Writer claimed that ceiling and no more. |

CONTINUE license 4 (stock textures/fonts only this wave), Bible §10.7 defined fallback, Law 10 dress, and Batch 2 §D **dress only** are met. CONTINUE’s “Gora sigil” and Batch 2 stained-glass health wait on licensed custom media and A01; the lane brief closed those as EmptySlot / mute rails.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; QuestBG + EmptySlot may read as quest-log / mail-slot chrome | **Not a spec miss.** License 4 and the brief require stock paths this wave. **POLISH:CANDIDATE** is the ceiling. |
| Height sampled once at first `Init` | **Not a miss.** Brief named the 12% / compact-card rule, not live resize. Idempotent `Init` keeps the first height. |
| Mute rails are not stained-glass health; A01 stays closed | **Not a miss.** Brief forbade live HP and allowed decorative `nameColor` rails with no `UnitHealth` and no percent health. |
| `WHITE8X8` is UNCONFIRMED | **Minor.** V-stock already marks it UNCONFIRMED. `fill()` `pcall`s `SetTexture`, then vertex-colors; `SetColorTexture` is the throw fallback. |

---

## Strengths

- Dress landed on the W-F card without reopening favor fill, plate send, or A01. Pope still reads Gora; congregation still reads `SetBroadcastFavor`; `health` is still a literal nil on both paint paths.
- Center is a licensed stock ring, not a faction crest. The suite greps the brief’s forbid list and the V-stock `PlusManz-*` extras, so a Horde/Alliance swap cannot sneak back as “ornament.”
- Mute rails are actually textures (2px, fighter-tinted). The suite pins “exactly two StatusBars” after paint, so a later health-bar regression has to fail that count.
- Height is a real ceiling: `min(100, 12%)`, not a toast-sized grow. Unknown parent keeps the current 100px card. Width stays 420.
- Isolation stayed gated. W-F pins (66/34, toggle-off ignores Gora, `PickFavor` errors, plate click gated, nameplate / sound greps) are still in the body.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **`SetTexture` fallback is throw-only.** `applyTexture` returns true whenever `SetTexture` does not error. A silent missing `QuestBG` / `UI-EmptySlot-White` / `WHITE8X8` on 20506 will not fall through to fill. Writer disclosed the `WHITE8X8` case. Load still succeeds. Same edge as V-A.

2. **28×28 seal sits on the VS label.** Brief allowed EmptySlot *or* no crest (“VS + FAVOR is enough”). The ring is legal and gold-tinted; it crowds the center of a 92–100px card. Unsmoked.

3. **Rail height is implemented, not pinned.** Source is 2×120 textures. The suite pins `_type == "Texture"` and the StatusBar count. A later 12px rail would still pass those asserts.

4. **Parchment miss-fill is the bright triple `0.78, 0.70, 0.52`.** V-D did not name an aged fallback. V-A did (`0.62, 0.52, 0.34`). Stock-wave inconsistency only; QuestBG is the live path.

5. **12% height is sampled once**, and the 768 pin rebuilds via mid-suite `dofile` (same trick the drag-restore block already used). Later `UIParent` size changes do not resize the live card. Brief did not ask for live resize.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Writer-reported isolated `tests/test_hud.lua` **358 / 0** was **not** re-run here. Do not treat that count as verified.

---

## Assessment

**Spec PASS. Quality Approved.**

This is the V-D vestment contract: stock iron/parchment on the existing W-F favor card; height capped at 12% / 100; center is a stock ring, not a faction crest; mute rails are decorative, not live HP; Church title and head-to-head stay; Quiet still hides. Named risks are clean. Minors are throw-only texture fallback, seal/VS crowding, and unsmoked stock chrome — not trust-breakers.

Writer-reported isolated **358 passed, 0 failed** was not re-run. Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
