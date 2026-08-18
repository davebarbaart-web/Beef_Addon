Spec PASS

# B4-F — HUD parchment name fields (review)

**Quality:** Approved-with-nits

**Lane:** B4-F HUD parchment name fields
**Brief:** `docs/reformation/vestments/briefs/B4-F-hud-parchment.md`
**API note:** `docs/reformation/vestments/briefs/V-stock-textures.md`
**Writer report:** `docs/reformation/vestments/briefs/B4-F-hud-parchment-report.md`
**Diff:** `docs/reformation/vestments/briefs/B4-F-hud-parchment.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, `UI/Hud.lua`, and `tests/test_hud.lua`; checked the provided exclusive-pair diff; then ran `lua tests/test_hud.lua` (370 passed, 0 failed, exit 0). One focused check per named gate (`nameFieldA` / `nameFieldB` QuestBG parchment; StatusBar count stays 2; `health` nil; no `UnitHealth`; W-F favor unchanged; isolation wrap + isolated green). Law cited: Bible §10.7 / §19.3, CONTINUE 2026-08-18 license 4, Batch 3 HUD-B polish (thin parchment behind name/title only), Appendix A01 fallback. Did not mutate addon code. Did not commit. This review does not sign the lane.

---

## Named gates

| Gate | Verdict |
|---|---|
| `nameFieldA` / `nameFieldB` exist (QuestBG parchment) | **Pass.** `CreateTexture` on `BORDER`. Both go through the existing `applyParchment` helper (`Interface\QuestFrame\QuestBG`, fill fallback `0.78, 0.70, 0.52, 0.94`). Suite pins existence, `_type == "Texture"`, QuestBG or that fill, and rebuild survival. |
| No extra StatusBars (`countStatusBars` stays 2) | **Pass.** Still exactly two `CreateFrame("StatusBar")` (`barA` / `barB`). Name fields are textures. Mute rails stay `CreateTexture`. Suite pins count 2 after Init, after rail tint, and after rebuild. |
| `health` nil | **Pass.** `hiddenView` and `paintShown` both set `health = nil`. Quiet, shown, Pope, and post-rebuild views re-pin nil. Mutating a copy’s `health` does not change `GetView()`. |
| No `UnitHealth` | **Pass.** `Hud.lua` has no `UnitHealth`, `UnitHealthMax`, combat-log, or nameplate scrape. Suite source greps stay. `healthReads == 0` on show, hide, and suite end. |
| Favor contract unchanged | **Pass.** Provided diff does not touch `resolveFavor`, `SetBroadcastFavor`, `PickFavor`, `SetFavorTarget`, `SetLocalCharacterId`, plate `OnClick`, or percent math. Pope still reads `Gora:GetFavorSplit()` while a pair is live (including zeros). Congregation still reads last `SetBroadcastFavor({ a, b })` only. `{2,1}` stays 66/34. `Hud.Favor` / `Hud.SendFavor` stay nil. |
| Isolated green | **Pass.** Reviewer ran `lua tests/test_hud.lua`: **370 passed, 0 failed**, exit 0. Isolation nil-module block and the standalone summary stay under `if standalone then`. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no FighterCard / Console / Toasts / Gora / BeefNet / TOC / bootstrap / `run.lua` / OPEN_QUESTIONS / REFORMATION_LOG / Media / commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/Hud.lua` and `tests/test_hud.lua`. Hud change is the header comment plus the two name-field textures and their points. |
| Thin parchment behind name+title; no extra row; no faction crest | **Pass.** Fields span name top → title bottom. Level/record stay below `title*`. Center is still `UI-EmptySlot-White`. Source greps still refuse PvP / PlusManz / Horde / Alliance crests. |
| QuestBG via the same `applyParchment` helper; stock only | **Pass.** `applyParchment(widget.nameFieldA/B)`. No `Media\`, `.tga`, `.blp`, or `.ttf`. No new StatusBar texture. |
| Do not add StatusBars; do not add a third favor widget | **Pass.** Named-gate check. Favor chrome is still `favorLabel` + two halves + two percents. |
| Mute rails stay textures; EmptySlot-White center stays | **Pass.** `railA` / `railB` remain 2×120 `ARTWORK` textures. Seal path unchanged. |
| W-F favor / PickFavor / SetFavorTarget / SetLocalCharacterId stay | **Pass.** Named-gate check. Favor pins in the suite body are untouched by the provided diff. |
| A01 still NOT RUN; `health` stays nil; no `UnitHealth` | **Pass.** Named-gate check. Rails are not health. Name fields are not health. |
| Pin existence + QuestBG-or-fallback; `countStatusBars` 2; `healthReads` 0; isolation wrap stays | **Pass.** New pins sit in the shared body. Isolation was not pulled out of `if standalone then`. |
| `lua tests/test_hud.lua` exit 0; **POLISH:CANDIDATE** at most | **Pass.** Isolated suite green (verified). Writer claimed that polish ceiling and no more. |

Bible §10.7 defined fallback, Law 10 / §19.3 dress, CONTINUE license 4, and the Batch 3 HUD-B *parchment-behind-name* slice (not portraits, not a FAVOR sigil) are met on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; QuestBG cropped into a thin strip may read as quest-log chrome; same fill as the card sheet may not separate | **Not a spec miss.** Brief required QuestBG via the existing helper. License 4 forbids a second parchment. **POLISH:CANDIDATE** is the ceiling. See Minor. |
| Horizontal size follows mute rails (120 + pad), not live string width; empty title still occupies the title point | **Not a miss.** Brief said sized to the name+title block. Name has no explicit width; the rail is the block’s existing measure. Title is a live FontString even when empty. |
| A01 still NOT RUN | **Not a miss.** Brief forbade opening it. |
| `applyTexture` fallback is throw-only | **Minor.** Same V-D edge. A silent missing `QuestBG` on 20506 will not fall through to fill. |
| Batch 3 HUD-B also named painted portraits and a FAVOR-label sigil | **Not a miss.** This lane is the parchment field only. |

---

## Strengths

- Exclusive pair is small and on-contract. Favor fill, plate send, A01, Quiet hide, and the two favor StatusBars were not reopened.
- Name fields are real textures on `BORDER` (under `OVERLAY` name/title, above the `BACKGROUND` card parchment). They are not StatusBars and not a third favor widget.
- Vertical span is name top → title bottom. Level/record stay outside the field. Center ring and mute rails are untouched.
- Suite still greps `UnitHealth` / nameplates / faction crests, still pins `health == nil` and `healthReads == 0`, and still pins `countStatusBars == 2` after dress and rebuild.
- Isolation stayed gated. Writer-reported 370/0 matches the reviewer run.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Layer pin is `BACKGROUND` or `BORDER`.** Implementation uses `BORDER`, which is the layer that can sit above the card parchment. A later swap to `BACKGROUND` would still pass and could z-fight the V-D sheet.

2. **Geometry is implemented, not pinned.** Suite asserts the widgets exist and carry QuestBG. It does not read `GetPoint`. A 0-size or unanchored texture would still pass the brief’s existence pins. Source does three-point the field to name / title / rail.

3. **No `SetTexCoord` / alpha / vertex distinction from the card parchment.** Same `applyParchment` path as `widget.parchment`. BORDER stacking is the only separation. At stream distance the “thin field” may be invisible. Brief required that helper; this is a polish gap, not a helper miss.

4. **`applyTexture` is throw-only.** `pcall(SetTexture)` success does not mean the file exists on 20506. Same V-D / V-A edge. Writer disclosed it.

5. **Source `QuestBG` grep was already true from V-D.** The new source pins that matter are the `nameFieldA` / `nameFieldB` name greps. The widget `_cobTexture` pins are the real QuestBG check.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated suite was run. Client paint of a QuestBG strip on a QuestBG card was not. Do not treat this as **POLISH:PASS**.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

The exclusive pair does what the brief asked: `nameFieldA` / `nameFieldB` QuestBG textures behind name+title, no extra StatusBars, `health` nil, no `UnitHealth`, W-F favor untouched, isolated suite green (370 / 0). Named gates are clean. Nits are a loose layer pin, unpinned geometry, and unsmoked same-QuestBG stacking — not trust-breakers.

Do not sign. Do not claim **POLISH:PASS**. Do not claim V1 / MVP complete.
