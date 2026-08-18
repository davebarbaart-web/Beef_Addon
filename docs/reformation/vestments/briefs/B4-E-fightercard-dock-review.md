Spec PASS

# B4-E — Fighter card left dock + display face (review)

**Quality:** Approved-with-nits

**Lane:** B4-E Fighter card left dock + display face
**Brief:** `docs/reformation/vestments/briefs/B4-E-fightercard-dock.md`
**API note:** `docs/reformation/vestments/briefs/V-stock-textures.md`
**Writer report:** `docs/reformation/vestments/briefs/B4-E-fightercard-dock-report.md`
**Diff:** `docs/reformation/vestments/briefs/B4-E-fightercard-dock.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, `UI/FighterCard.lua`, and `tests/test_fighter_card.lua`. Isolated `lua tests/test_fighter_card.lua` was re-run: **276 passed, 0 failed**, exit 0. Did not mutate addon code. Did not commit. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| LEFT dock | **Pass.** `build()` `SetPoint("LEFT", parent, "LEFT", 0, 0)`. Init and rebuild pins: `GetPoint` is LEFT / UIParent / LEFT. Width remains `floor(parent/3)` or **420**. `SetClampedToScreen(true)` kept. Not CENTER. |
| MORPHEUS names via `pcall` `SetFont` | **Pass vs brief.** `NAME_FONT = "Fonts\\MORPHEUS.TTF"`. `applyNameFont` runs only on plate names after `GameFontHighlight`. `pcall(fs.SetFont, fs, NAME_FONT, 16, "")`; fallback `SetFontObject(GameFontHighlight)`. Titles / records / H2H / stipulation / VS stay `GameFont*`. Soft `GetFont` pin does not fail when the stub ignores `SetFont`. **Nit:** runtime apply is unproven (see Issues). |
| H2H still `1-0` | **Pass.** `recordText` is still `wins-losses` arabic. Rematch pins `frame.plateA.record` `1-0`, `plateB` `0-1`, `frame.headToHead` `1-0`. No `toRoman`. B3-B pin kept; Batch 4 render roman is out of this brief. |
| No close chrome | **Pass.** No `CreateFrame("Button")`, no `CloseButton`, no `✕` / star / `UISpecialFrames`. Suite `countType(..., "Button") == 0`. `EnableMouse(false)`. Seal is the pre-existing `UI-EmptySlot-White` ring, not new close furniture. |
| No `UnitHealth` | **Pass.** Source has no `UnitHealth`, `UnitHealthMax`, combat-log, or nameplate scrape. `hiddenView` / `paintShown` set `health = nil`. Suite stubs those APIs and pins `healthReads == 0`. No `StatusBar`. |
| Stock only | **Pass.** Paths are `Fonts\\MORPHEUS.TTF`, `QuestBG`, `WHITE8X8`, `UI-EmptySlot-White`, `UI-Tooltip-Border`. No `Media\\`, `.tga`, `.blp`, or extra `.ttf`. Custom-font grep keeps the one stock Morpheus path. |
| Isolated green | **Pass.** Re-run: `lua tests/test_fighter_card.lua` — **276 passed, 0 failed**, exit 0. Isolation nil-module asserts stay under `if standalone then`. Load list is still wow_ui_stub + Common + Ranks + Store + Runtime + Gora + FighterCard. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit TOC, Hud, Toasts, Console, Gora; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/FighterCard.lua` and `tests/test_fighter_card.lua`. |
| Default LEFT of UIParent (left third), not CENTER; keep clamp; no close / star / ✕ | **Pass.** Named-risk checks. |
| Names try `Fonts\\MORPHEUS.TTF` via `pcall` `SetFont`; fallback `GameFontHighlight`; titles/records stay `GameFont*` | **Pass.** Named-risk check. Brief used the `.TTF` form. |
| Keep W–L and H2H as `1-0`; do not invent roman | **Pass.** Named-risk check. Existing rematch pins unchanged. |
| Quiet / no pair still Hide; `health` stays nil; no faction crests; no `Media/` | **Pass.** Quiet Show is false. ASSEMBLY without Sanction is false. `DeclareVictor` / `EndEvent` hide. PvP / Horde / Alliance greps stay. |
| Init/layout pins: LEFT `GetPoint`; soft Morpheus `GetFont`; `1-0` stay green; no `rubber` / `ordained`; isolation wrap stays | **Pass.** Source still refuses `rubber` / `ordained` / `one apiece`. Isolation print and nil cluster still gated. |
| Isolated `lua tests/test_fighter_card.lua` exit 0 | **Pass.** Verified 276 / 0. |
| **POLISH:CANDIDATE** at most | **Pass.** Writer claimed that ceiling and no more. |

Bible §10.6 (mute tape), §19.2–19.3 / Law 10 (theatrical dress, stock this wave), Law 4 (no generated flavor), Law 6 (Event chrome; Quiet hides), B3-B arabic H2H pin, and CONTINUE license 4 are met on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; Morpheus at height 16 unsmoked on 20506 | **Not a spec miss.** Brief asked isolated green. **POLISH:CANDIDATE** is the ceiling. |
| Harness `SetFont` is a no-op; soft `GetFont` pin does not fail | **Not a miss.** Brief: do not fail if the stub ignores `SetFont`. |
| Size sampled once at first `Init` | **Not a miss.** Brief named the left-third / compact rule, not live resize. |
| LEFT flush at 0,0 | **Not a miss.** Brief named LEFT, not an inset. |
| `WHITE8X8` UNCONFIRMED | **Minor.** Same `pcall` `SetTexture` + vertex-color path as B3-B. |
| Integrator still lists TOC / `run.lua` | **Not a miss.** Brief forbade those edits. |

---

## Strengths

- The delta is the brief: CENTER → LEFT, names try stock Morpheus, mute tape and arabic `1-0` left alone.
- Display-face is names only. Titles, records, H2H, stipulation, and VS stay `GameFont*`. Class color still tints the name, not the ledger.
- Close furniture was not added. Mouse is off. Button count stays 0.
- Isolation stayed gated. Rematch `1-0`, Quiet hide, `health` nil, and scrape pins are still in the shared body.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Morpheus apply is source-only.** `wow_ui_stub` `SetFont` is an accepted no-op that returns nil. `used = ok and applied and true or false` then calls `SetFontObject(GameFontHighlight)`. Soft `GetFont` never fires. The suite proves the string is in the file, not that a 20506 FontString wears Morpheus.

2. **`Fonts\\MORPHEUS.TTF` does not match FrameXML `Fonts\MORPHEUS.ttf`.** V-stock says match FrameXML casing. Anniversary FrameXML (`GlueFonts.xml`) uses `.ttf`. Brief mandated `.TTF` (same as V-A / V-C). `SimpleFontStringAPI` `SetFont` returns `success`; a case miss returns false and the name stays `GameFontHighlight`. WoW VFS is usually case-insensitive. Unsmoked.

3. **Empty flags `""`.** `pcall(SetFont, fs, path, 16, "")` copies Decree / Records. Flags are optional (`TBFFlags?`). If `""` is rejected, `applied` is false and Morpheus never sticks. Prefer omit, or a documented Outline/none.

4. **Custom-font grep is weak.** `gsub("Fonts\\\\MORPHEUS%.TTF", "")` may not strip the two-backslash source spelling; `find(".ttf", 1, true)` is lowercase and would miss another `.TTF`. Today the file has one font path. A second stock/custom `.TTF` would not fail that pin.

5. **LEFT flush at 0,0.** Clamped, but the card can sit under left-side bags / chat / other chrome. Brief named LEFT, not inset. Writer disclosed it.

6. **`SetTexture` fallback is throw-only.** Silent missing `QuestBG` / `WHITE8X8` / EmptySlot will not fall through to fill. Same edge as B3-B / V-A.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated 276 / 0 was re-run here. Client path and runner listing were not.

---

## Assessment

**Spec PASS. Quality Approved-with-nits.**

This is the B4-E contract: LEFT dock (left-third width, clamped), names try stock Morpheus via `pcall` `SetFont` with `GameFontHighlight` fallback, H2H and W–L stay `1-0`, no close chrome, no `UnitHealth`, stock paths only, isolated suite green. Named risks are clean. The nits cluster on the display face: the harness cannot prove `SetFont`, FrameXML casing is `.ttf`, and the success-bool + empty flags can keep `GameFontHighlight` without a red test.

Expected leftover (not a miss): integrator lists `UI\FighterCard.lua` in the TOC and `test_fighter_card` in `tests/run.lua` if those lines are not already present. Brief forbade those edits.

Isolated **276 passed, 0 failed** verified. Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
