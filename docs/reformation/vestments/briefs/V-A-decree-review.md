# V-A — Decree parchment dress (review)

**Lane:** V-A Decree parchment dress (stock textures only)
**Brief:** `docs/reformation/vestments/briefs/V-A-decree.md`
**API note:** `docs/reformation/vestments/briefs/V-stock-textures.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/V-A-decree-report.md`
**Diff:** `docs/reformation/vestments/briefs/V-A-decree.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

**Spec:** PASS
**Quality:** Approved

Task-scoped gate only. Reviewer read the brief, the stock-texture note, the writer report, and the provided diff; then made one focused check per named risk (line is the visual headline; no required `Media\\` paths; no `✠`; Quiet no sound; exclusive files only) plus the `UI-Quickslot2` pin. Did not mutate the working tree, did not re-run git or the harness, and did not treat writer counts as verified.

---

## Spec Compliance

- **Spec PASS**
- **Quality Approved**

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Console / Toasts / Records / HUD / Core / TOC / bootstrap / OPEN_QUESTIONS / REFORMATION_LOG / `Data/Popes.lua` / `Media/` / commit | **Pass.** Provided diff touches only the two exclusive files. |
| Decree **line** is the visual headline (`GameFontNormalHuge` or `pcall` `SetFont` then GameFont fallback) | **Pass.** Named-risk check: `LineText` is created as `GameFontNormalHuge` and `applyFont(..., LINE_FONT, 18)`. Suite pins `_template == "GameFontNormalHuge"`. |
| `HEADER` stays `Banner.HEADER` / `GetView().header` / tooltip copy; not the largest line | **Pass.** Copy is still `A GATHERING HAS BEEN DECREED`. `HeaderText` is `GameFontNormalSmall`. Suite: header is not Huge and is small-clerical. `GetView().header` unchanged. Minimap not edited. |
| Church name small by the seal (`GameFontHighlightSmall`); institution string, not a Pope | **Pass.** `CHURCH_NAME = "Church of Beef"`. Anchored `LEFT` of `Seal` `RIGHT`. Suite pins text, template, and relative point. |
| `FlavorText` optional under the line; hidden when omitted | **Pass.** Anchored under the new gold rule under `LineText`. Existing hide-when-omitted paint and tests kept. |
| No cross glyphs (`✠` or `+` ornaments); no jokes | **Pass.** Named-risk check: source has no `✠`. Close copy is still `Close`. Gold rule replaces the dropped crosses (Batch 2 §B.2). |
| No required `Media\\` paths; missing media must not fail load | **Pass.** Named-risk check: `DecreeTitle.ttf` / `decree-seal` / `decree-parchment` dropped. No `Media\\` left in `UI/Decree.lua`. Stock paths are `Interface\\` / `Fonts\\` only, all `pcall`'d. |
| Quiet: no `PlaySound`; no Event Mode host | **Pass.** Named-risk check: source has no `PlaySound` / `PlaySoundFile`. `MODE = "QUIET"`. Existing greps still refuse Console / HUD / Records / Toasts / `StatusBar`. Suite keeps `sounds == 0`. |
| Scale ~300–340 × 130–160; upper-center; movable; clamped | **Pass.** Frame is `320×148`. `TOP` / `TOP_INSET` default kept. Movable + clamped kept. Suite pins the band. |
| Parchment: stock `QuestBG` or `StationeryTest1` via `pcall` `SetTexture`; fail → aged `fill()` `0.62, 0.52, 0.34` | **Pass.** `QuestBG` through `applyTexture`. Fail arm uses the brief’s aged triple. Bright `0.78, 0.70, 0.52` dropped. |
| Seal: stock gold ring or `UI-Quickslot2` tinted; not Horde / Alliance / PVP crests | **Pass vs brief.** `UI-Quickslot2` + gold `SetVertexColor`; fill if `SetTexture` throws. Source greps refuse `UI-PVP` / `Horde` / `Alliance`. **Quality Minor:** path is UNCONFIRMED on 20506 (see Issues). |
| Gold rule / iron edge via `WHITE8X8` tints | **Pass.** Iron field, gold edge, 1px `GoldRule` all go through `fill()` (`SetColorTexture`, else `WHITE8X8` + vertex). |
| Keep: no empty parchment; Core Get/Set only; GetView copy; no slash; no calendar/RSVP; Init silent; flavor hide | **Pass.** Those blocks are still in the suite. `paint` still reads `Get().line` / optional flavor only. |
| Isolation asserts stay under `if standalone then` | **Pass.** Nil-module / slash block unchanged and still gated. New dress pins sit in the shared body. |
| Named tests (scale, LineText headline, church-by-seal, no `✠`, no `Media\\`, stock QuestBG, aged fill) | **Pass.** All present on the provided diff. |

CONTINUE license 4 (stock Blizzard textures and fonts only), Bible §14.1 / §19.1 / §19.3, Law 6, and Batch 2 §B are met on the exclusive files. `UI-Quickslot2` is a brief-licensed seal stand-in and is not load-breaking.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; 148px + Huge line + flavor + seal may clip | **Real UX note, not a spec fail.** Brief set the quest-tracker band. Templates match the hierarchy. Unsmoked, as required for POLISH:CANDIDATE. |
| `SetTexture` rarely errors; silent miss skips `fill()` | **Not a miss.** Brief asked for `pcall` then fill on failure. That is what `applyTexture` does. A missing file on 20506 is typically a blank/green texel, not a Lua throw — same edge P5-B already lived with. Load still succeeds. |
| `QuestBG` is a full quest-log sheet in a tracker rect | **Acceptable.** Brief named `QuestBG` first. `StationeryTest1` was the other option, not a requirement. |
| `UI-Quickslot2` is a bag-slot ring, not a wax bull | **Minor.** Brief allowed it. Stock note marks it UNCONFIRMED and prefers EmptySlot / TrackingBorder / a `WHITE8X8` disc. Not load-breaking (`pcall` + gold fill on throw). |

---

## Strengths

- Hierarchy is the Batch 2 miss, actually swapped: place/time is `GameFontNormalHuge`; `HEADER` stays the Bible sentence as small clerical copy; the institution sits by the seal. `GetView` / tooltip contract did not move.
- Required `Media\\decree-*` / `DecreeTitle.ttf` paths are gone, not left as a hopeful `pcall`. Stock `QuestBG` and fonts are the only file paths. Load no longer depends on shipped art.
- Quiet contract is intact. No sound, no Event host, no calendar/RSVP/slash, no empty parchment, no invented Pope name. Exclusive files only.
- Dress pins are source-greps plus widget templates, so the headline cannot regress to Huge-header / Large-line without a red suite. Isolation stayed gated.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **`Interface\\Buttons\\UI-Quickslot2` is UNCONFIRMED on 20506.** Stock note finds it only on Wrath `WatchFrame.xml` and says skip. Brief licensed it as a gold ring stand-in. `applyTexture` `pcall`s `SetTexture` and fills gold if it throws, so a miss is not load-breaking. Integrator may swap to `UI-EmptySlot-White`, `MiniMap-TrackingBorder`, or a `WHITE8X8` disc without reopening the lane.

2. **Aged parchment `fill()` is throw-only.** `applyTexture` returns true whenever `SetTexture` does not error. A silent missing `QuestBG` / seal file will not fall through to `0.62, 0.52, 0.34`. Writer disclosed this. Not a load fail.

3. **148px with `GameFontNormalHuge` plus optional flavor plus the seal row is tight.** A long place/time line may wrap into the rule / flavor / seal. Brief asked for that band. Not smoked after `/reload`.

4. **`Fonts\\MORPHEUS.TTF` casing does not match FrameXML `MORPHEUS.ttf`.** Brief used the `.TTF` form. `applyFont` still requires a truthy `SetFont` return, then GameFont fallback, so a case miss keeps the Huge headline.

---

## Assessment

**Spec PASS. Quality Approved.**

This is the V-A dress contract: stock textures and fonts only; the decree line is the visual headline; church name is small by the seal; `HEADER` stays UI copy; no `✠`; no required `Media\\` paths; Quiet stays silent; exclusive files only. `UI-Quickslot2` is a Minor (UNCONFIRMED, not load-breaking). POLISH:CANDIDATE at most.

Writer-reported isolated `lua tests/test_decree_ui.lua` **241 / 0** was **not** re-run here.

No Critical or Important findings. Integrator can sign V-A on this diff; do not block on the Minors. This review does not sign the lane.
