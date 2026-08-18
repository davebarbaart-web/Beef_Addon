Spec PASS

# B34-A — HUD re-tints names after applyNameFont (review)

**Quality:** Approved-with-nits

**Lane:** B34-A HUD re-tints names after applyNameFont
**Brief:** `docs/reformation/vestments/briefs/B34-A-hud-tint.md`
**Writer report:** `docs/reformation/vestments/briefs/B34-A-hud-tint-report.md`
**Diff:** `docs/reformation/vestments/briefs/B34-A-hud-tint.diff` (B34-A-only exclusive-pair packet; live `Hud.lua` also carries earlier HUD batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Hud.lua` (`tint` ~174–180 / `paintFighter` ~486–501 / `applyNameFont` ~522–534 / `paintShown` ~536–573 / `build()` mint apply ~628–631), and `tests/test_hud.lua` (existing class-color pins ~444–461, nested `runB34A()` after `runB32A()` inside `runB19C()`); then ran `lua tests/test_hud.lua` (**779 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §19.3 / Law 10 (class color on fighter names). Brief leftover: `paintShown` calls `applyNameFont` after `paintFighter` already tinted `nameA` / `nameB`; live `SetFontObject(GameFontHighlight)` applies the font object's white and wipes class tint; harness `SetFont` / `SetFontObject` are often no-ops so `_cobColor` can look fine while Anniversary is white. Live `paintShown` now calls `tint(frame.nameA, fighterA.nameColor or INK)` and `tint(frame.nameB, fighterB.nameColor or INK)` after both `applyNameFont` calls. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. `GameFontHighlight` fallback stays inside `applyNameFont`. `build()` mint apply has no tint. Hidden paint stays empty. No `UnitHealth`. No roman numerals. No defense `SetWidth`. Did not mutate `Hud.lua` or `test_hud.lua`. Did not commit. Did not edit FighterCard, Console, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `paintShown` still leaves names white after `applyNameFont` (B25-D leftover; `SetFontObject(GameFontHighlight)` applies the font object's color) | **Pass. Verified.** Brief L11 vs live `Hud.lua` 567–570: after `applyNameFont(frame.nameA)` / `nameB`, `tint(..., fighterA.nameColor or INK)` / `fighterB.nameColor or INK`. Nested source pin requires `tint` or `SetTextColor` on each name after its `applyNameFont`. Wrap nils `_cobColor` on font apply; live Gora `Refresh` returns Warrior / Mage on the widgets. Reviewer probe: `SetFont` wrap fires once per name; `_cobColor` returns to class color. |
| Restore invents a new tint language / mint tint / hidden paint | **Pass.** Same `tint` helper `paintFighter` already uses (`nameColor or INK`). `applyNameFont` body unchanged. `build()` still applies name font only (reviewer probe: no `tint(widget.name` / `tint(frame.name` in `build`). `paintHidden` still clears name strings and does not call `applyNameFont`. |
| `NAME_FONT` / `GameFontHighlight` dropped; custom Media | **Pass.** `NAME_FONT` is still `Fonts\\MORPHEUS.ttf`. Fallback is still `SetFontObject(GameFontHighlight)`. Existing B22-B / B25-D source pins stay. `Hud.lua` has no `Media\\`, `.tga`, `.blp`, or `MORPHEUS_CYR`. |
| Existing class-color pins rewritten; level / title / record class-colored | **Pass.** Pins ~444–461 unchanged in the packet. Names Warrior / Mage; level / title / record not class-colored; mute rails fighter-tinted. Packet does not touch those asserts or `paintFighter` level / title / record tints. |
| `UnitHealth` / live health / roman HUD numerals / defense `SetWidth` | **Pass.** `Hud.lua` has no `UnitHealth`, `UnitHealthMax`, `SetWidth`, `roman`, or `Roman`. `paintDefense` is still `tostring(n)`. Nested `runB34A()` pins `health` nil and `healthReads == 0`. Source pin `UnitHealth` absent still runs. |
| Tests not nested after `runB32A()` / new main-chunk locals / isolation wrap rewritten | **Pass.** `runB34A()` is a nested `local function` inside `runB19C()` immediately after `runB32A()`. Packet adds no main-chunk `local`. Isolation wrap stays **13** under the first `if standalone then`. |
| Isolated suite not exit 0 / exclusive breach | **Pass. Verified.** 779 passed, 0 failed. Writer-reported count matches. Packet is the two named files. Sibling dirt is other lanes, not this packet. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit FighterCard, Console, glue; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| After `applyNameFont(frame.nameA)` / `nameB` in `paintShown`, restore tint from `fighterA.nameColor or INK` / `fighterB.nameColor or INK` via the existing `tint` helper (brief L11) | **Pass.** Live 569–570. Source pin + wrap Refresh. |
| Keep `NAME_FONT` / `GameFontHighlight` fallback (brief L11) | **Pass.** `applyNameFont` unchanged. B22-B pins stay. |
| `build()` mint apply stays before fighters exist — do not invent a mint tint (brief L11) | **Pass.** Reviewer probe: mint apply present, mint tint absent. |
| Hidden paint stays empty (brief L11) | **Pass.** `paintHidden` unchanged. B19-C / B21-B / B32-A leftover hide pins still run before `runB34A()`. |
| No `UnitHealth`. No roman numerals. No defense `SetWidth` (brief L7) | **Pass.** Named-risk check. |
| Nest after `runB32A()` inside `runB19C()`; source pin `applyNameFont` then `tint` / `SetTextColor`; wrap font apply wipe; Refresh live Gora pair; `_cobColor` / view `nameColor` return to Warrior / Mage (brief L15) | **Pass.** Nested block 1389–1450. |
| Existing class-color pins stay; isolation wrap stays (brief L15) | **Pass.** Pins ~444–461. Wrap **13**. |
| `lua tests/test_hud.lua` exit 0 (brief L17) | **Pass.** **779 / 0.** Writer ran it (report TDD red **774 / 5**, green **779 / 0**). Reviewer re-ran: **779 passed, 0 failed**, exit 0, Lua 5.1.5. |

Law 10 / §19.3 holds on the exclusive pair: fighter names keep class color after the shown-pair font re-apply. Law 8 holds: `health` stays nil; no scrape. Law 10 numerals: defense stays `tostring(n)`; no roman HUD numerals. Hybrid visual law: no custom Media; stock Morpheus + `GameFontHighlight` fallback stay.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; live `SetFontObject(GameFontHighlight)` wipe then restore unwalked | **Not a miss.** Brief asked the isolated suite and a harness wrap that simulates the wipe. |
| Harness `SetFont` / `SetFontObject` stay no-ops unless wrapped; `GetTextColor` after a real font-object apply is not pinned | **On contract as a leftover.** Brief asked `_cobColor` / view `nameColor`. Stub `GetTextColor` is a no-op (reviewer probe: nil). |
| Unknown-class `INK` fallback after font apply is not a separate runtime pin | **On contract as a leftover.** Source is `nameColor or INK`. Wrap Refresh uses Warrior / Mage. Reviewer probe: Banana class → view `nameColor` nil, widget `_cobColor` is INK `(0.95, 0.88, 0.70)`. |
| Font wraps stay on the B19-C `hud` instance; later V-D `dofile` + `Init` does not `paintShown` | **On contract.** Brief nested the wrap inside `runB19C()`. V-D height pins do not read name tint. |
| A01 still NOT RUN; full `lua tests/run.lua` not run | **Not a miss.** Brief forbade `UnitHealth` and asked the isolated suite. `health` stays nil. |
| Gate W / Gate V stay OPEN; lane not signed | **On contract.** This review does not sign either. |

---

## Isolation / paintShown / tint

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Ranks + Store + Runtime + Gora + Hud. No `dofile` of Net / Snapshot / Knighting / Console / FighterCard. **13** nil-module pins stay under the first `if standalone then` (Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console). Wrap was not rewritten.

**paintShown — Pass.** Order is still `paintFighter` (tints names) → lastView → `applyNameFont(nameA)` → `applyNameFont(nameB)` → `tint(nameA, nameColor or INK)` → `tint(nameB, nameColor or INK)` → `Show`. The leftover (font apply after the fighter tint) is closed on the same helper, not a second color language. `applyNameFont` still `pcall SetFont(NAME_FONT, 14)` then `SetFontObject(GameFontHighlight)`.

**Tests — Pass.** `runB34A()` sits after `runB32A()` on the same B19-C fixture (Knighting Continue has forgotten lastPair; a new `OpenRite("Gora")` + `Refresh` is a live pair). Source pin finds `applyNameFont` then `tint` / `SetTextColor` inside the `paintShown` body. Wrap wipes `_cobColor` on `SetFontObject` and `SetFont`. Widget `_cobColor` and view `nameColor` return to Warrior / Mage. `health` nil. Existing class-color pins stay. Isolation wrap stays **13**. No new main-chunk locals.

---

## Strengths

- The delta is the brief: two `tint` lines after the existing `paintShown` font apply, plus nested pins. `applyNameFont`, `build()` mint apply, `paintHidden`, favor, and defense were left alone.
- Restore uses the same `tint` + `nameColor or INK` path `paintFighter` already uses. No mint tint. No invented palette.
- The wrap makes the harness leftover visible: without the post-font `tint`, `_cobColor` stays nil (writer red **774 / 5**). Widget restore is the real leftover pin; it sits next to a live Gora `Refresh` so a comment-only source pin would still fail the widget asserts.
- `runB34A()` sits after `runB32A()` on the same fixture. Isolation wrap stays **13**. Writer-reported **779 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **No `/reload` smoke of the live `SetFontObject(GameFontHighlight)` wipe.** The isolated wrap simulates it. Brief asked the isolated suite. Do not expand this exclusive pair.

2. **Harness never reaches `SetFontObject`.** `GameFontHighlight` is nil in this suite, so `applyNameFont` calls wrapped `SetFont` (noop return → `used == false`) and then skips `SetFontObject` because `font` is nil. Reviewer probe: wrap hits `SetFont` 1 / `SetFontObject` 0 per name. The Anniversary leftover named in the brief is the font-object color apply; production `tint` after `applyNameFont` covers that branch, but the suite proves restore after `SetFont`, not after a real `GameFontHighlight` apply. Soft `GetTextColor` stays unpinned (stub no-op).

### Nit

1. **View `nameColor` is computed in `fighterFrom` before `applyNameFont`.** Pinning it after Refresh does not prove the widget leftover is closed. The `_cobColor` asserts do. Brief asked both; both pass.

2. **Unknown-class `INK` fallback after font apply is source-only in the suite.** Reviewer probe agrees with `nameColor or INK` (widget INK, view nil). Existing unknown-class pins (~573–578) stay on view `nameColor` only.

3. **Source pin is a string find on the `paintShown` body.** `tint(frame.nameA` or `nameA:SetTextColor` after `applyNameFont` is enough. A comment would still pass that pin. Live calls are the production `tint(..., nameColor or INK)` lines. Widget wrap would still fail without them.

4. **Exclusive-pair diff is not a vs-HEAD Hud delta.** Packet is the B34-A-only header comment + two `tint` lines + nested pins. `git diff HEAD` on the two files still includes earlier HUD batches. Report already says this.

5. **Font wraps stay on the B19-C `hud` instance.** Later V-D `dofile` + `Init` is idempotent and does not `paintShown`. On contract.

6. **Full `lua tests/run.lua` was not run.** Isolated **779 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **779 passed, 0 failed.** Isolation wrap: **13**. Writer ran `lua tests/test_hud.lua` (report: red 774 / 5, green 779 / 0). Reviewer re-ran: **779 / 0**, exit 0, Lua 5.1.5.

`paintShown` still calls `applyNameFont` on `nameA` / `nameB`, then restores class tint with the existing `tint` helper from `fighterA.nameColor or INK` / `fighterB.nameColor or INK`. `NAME_FONT` / `GameFontHighlight` stay. `build()` mint apply has no tint. Hidden paint stays empty. Existing class-color pins stay. `health` stays nil. No `UnitHealth`. No custom Media. No roman HUD numerals. No defense `SetWidth`. Isolated `lua tests/test_hud.lua` **779 passed, 0 failed**, exit 0.

Leftovers: no client smoke; harness never calls `SetFontObject` because `GameFontHighlight` is nil (`SetFont` wrap is what fires); `GetTextColor` unpinned; unknown-class INK after font apply is source-only; full harness not run.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
