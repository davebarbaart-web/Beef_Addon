Spec PASS

# B35-A — HUD defense labels SetWidth(28) (review)

**Quality:** Approved-with-nits

**Lane:** B35-A HUD defense labels SetWidth(28)
**Brief:** `docs/reformation/vestments/briefs/B35-A-defense-width.md`
**Writer report:** `docs/reformation/vestments/briefs/B35-A-defense-width-report.md`
**Diff:** `docs/reformation/vestments/briefs/B35-A-defense-width.diff` (B35-A-only exclusive-pair packet; live `Hud.lua` also carries earlier HUD batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Hud.lua` (`paintDefense` ~475–487 / `makeLabel` ~578–582 / `build()` defense mint ~641–642 and ~699–704 / `WIDTH` 420), and `tests/test_hud.lua` (existing CountDefenses 3 pin ~618–637, nested `runB35A()` after `runB34A()` inside `runB19C()`); then ran `lua tests/test_hud.lua` (**814 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.7 mute integer (defense count on the Fight HUD; defined no-live-health fallback). Brief leftover: `defenseA` / `defenseB` were unbounded `makeLabel` FontStrings anchored LEFT of `recordA` / RIGHT of `recordB`; two-digit W/L plus a two-digit count can grow into VS / seal. Live `build()` calls `defenseA:SetWidth(28)` / `defenseB:SetWidth(28)` after those anchors; `paintDefense` re-asserts `fs:SetWidth(28)` before MUTED / `tostring(n)` / Hide-when-zero. Existing 8px LEFT/RIGHT anchors stay. HUD width stays 420. No `SetWidth` on names / records / VS. No roman. No `UnitHealth`. Did not mutate `Hud.lua` or `test_hud.lua`. Did not commit. Did not edit FighterCard, Console, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Defense labels stay unbounded / mint missing / cap is not 28 | **Pass. Verified.** Live `build()` 701–702: `widget.defenseA:SetWidth(28)` / `defenseB:SetWidth(28)` after the LEFT/RIGHT anchors. `paintDefense` 478: `fs:SetWidth(28)`. Reviewer probe: exactly one `defenseA:SetWidth(28)`, one `defenseB:SetWidth(28)`, one `fs:SetWidth(28)`. After `Init`, both `GetWidth() == 28`. After a 3 / 12 `CountDefenses` paint, both stay 28 and paint `"3"` / `"12"`. |
| Existing LEFT/RIGHT anchors moved or 8px gap dropped | **Pass.** Live 699–700 unchanged in the packet: `LEFT` of `recordA` `RIGHT` +8; `RIGHT` of `recordB` `LEFT` −8. Nested `GetPoint(1)` pins point / relative / relativePoint. Reviewer probe: offsets still `8, 0` and `-8, 0`. |
| Names / records / VS `SetWidth`; HUD grown off 420 | **Pass.** Source pins `nameA` / `nameB` / `recordA` / `recordB` / `vs` `SetWidth` absent. Reviewer probe: those five `GetWidth()` stay `nil` after Init and after the 3 / 12 paint. `WIDTH` is still 420. Nested + probe: `hud:GetWidth() == 420`. |
| `UnitHealth` / live health / roman HUD numerals | **Pass.** `Hud.lua` has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `roman`, or `Roman`. `paintDefense` is still `tostring(n)`. Nested pins `health` nil and `healthReads == 0`. Two-digit stub paints `"12"`, not a numeral glyph. |
| MUTED / Hide-when-zero / `tostring` dropped | **Pass.** `paintDefense` still tints MUTED, `SetText(tostring(n))` when `n > 0`, else `""` + Hide. Existing 3 pin (~618–637) unchanged. Nested 3 / 12 paint: shown, MUTED `r == 0.55`, texts `"3"` / `"12"`. |
| Tests not nested after `runB34A()` / new main-chunk locals / isolation wrap rewritten | **Pass.** `runB35A()` is a nested `local function` inside `runB19C()` immediately after `runB34A()`. Packet adds no main-chunk `local`. Isolation wrap stays **13** under the first `if standalone then`. |
| Isolated suite not exit 0 / exclusive breach | **Pass. Verified.** 814 passed, 0 failed. Writer-reported count matches. Packet is the two named files. Sibling dirt is other lanes, not this packet. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit FighterCard, Console, glue; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| Cap only `defenseA` / `defenseB` at **28**; mint in `build()` after the labels exist and/or in `paintDefense` (brief L11) | **Pass.** Live mint 701–702. `paintDefense` re-asserts. Brief allows both. |
| Existing anchors, MUTED tint, `tostring(n)` paint, Hide-when-zero stay (brief L11) | **Pass.** Named-risk check. |
| HUD width stays 420 (brief L11) | **Pass.** `WIDTH` 420. Nested + probe `GetWidth() == 420`. |
| No roman. No `UnitHealth`. No `SetWidth` on names / records / VS (brief L5, L11) | **Pass.** Named-risk check. |
| Nest `runB35A()` after `runB34A()` inside `runB19C()`; source pin `defenseA` / `defenseB` `SetWidth(28)`; after Init and after a nonzero `CountDefenses` paint (existing 3 pin **or** a two-digit stub), `GetWidth() == 28`; record / name widths untouched; isolation wrap stays (brief L15) | **Pass.** Nested block 1455–1505. Two-digit stub is 12. Existing 3 pin left alone. |
| `lua tests/test_hud.lua` exit 0 (brief L17) | **Pass.** **814 / 0.** Writer ran it (report green **814 / 0**). Reviewer re-ran: **814 passed, 0 failed**, exit 0, Lua 5.1.5. |

Law 8 / §10.7 holds on the exclusive pair: defense stays a mute integer; `health` stays nil; no scrape. Law 10 numerals: defense stays `tostring(n)`; no roman HUD numerals. Hybrid visual law: no custom Media; defense stays stock `GameFontNormal` + MUTED. Favor W-F and leftover hide pins were left alone.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; live `SetWidth(28)` clipping a two-digit defense next to two-digit W/L vs VS / seal unwalked | **Not a miss.** Brief asked the isolated suite and harness `GetWidth() == 28`. |
| Harness `GetWidth` is the stub `_width` field, not live FontString layout | **On contract as a leftover.** Brief asked `GetWidth() == 28`. Stub `SetWidth` writes `_width`. |
| `paintDefense` also re-caps, including the hide path | **On contract.** Brief said mint in `build()` **and/or** `paintDefense`. |
| Two-digit 12 is the nested stub; existing main-chunk CountDefenses 3 pin does not assert width | **On contract.** Brief allowed the existing 3 pin **or** a two-digit stub. |
| A01 still NOT RUN; `health` is nil | **Not a miss.** Brief forbade `UnitHealth`. |
| Full `lua tests/run.lua` was not run | **Not a miss.** Brief asked the isolated suite. |
| Gate W / Gate V stay OPEN; lane not signed | **On contract.** This review does not sign either. |

---

## Isolation / mint / paintDefense

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Ranks + Store + Runtime + Gora + Hud. No `dofile` of Net / Snapshot / Knighting / Console / FighterCard. **13** nil-module pins stay under the first `if standalone then` (Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console). Wrap was not rewritten.

**Mint — Pass.** `makeLabel` still returns an unbounded FontString (`SetJustifyH` only). `build()` mints `defenseA` / `defenseB` as `GameFontNormal`, keeps the existing LEFT/RIGHT anchors, then `SetWidth(28)` on those two only, then Hide. Names / records / VS are not sized.

**paintDefense — Pass.** Re-asserts `SetWidth(28)`, then MUTED, then `tostring(n)` + Show when `n > 0`, else `""` + Hide. Reviewer probe: Quiet `Init` / `Refresh` leaves both hidden at width 28; a 3 / 12 paint shows `"3"` / `"12"` at width 28, MUTED `r == 0.55`, `health` nil.

**Tests — Pass.** `runB35A()` sits after `runB34A()` on the same B19-C fixture (B34-A has re-opened a live Gora pair). Source pin finds `defenseA:SetWidth(28)` / `defenseB:SetWidth(28)` and no name / record / VS `SetWidth`. Widget `GetWidth() == 28` after the nested Init instance and after the 3 / 12 stub. Isolation wrap stays **13**. No new main-chunk locals.

---

## Strengths

- The delta is the brief: two `SetWidth(28)` lines after the existing defense anchors, a matching re-assert in `paintDefense`, plus nested pins. Names, records, VS, favor, leftover hide, and B34-A tint were left alone.
- Cap uses Anniversary `SetWidth(width)` (SimpleScriptRegionResizingAPI), not a second layout language. Anchors stay LEFT/RIGHT with the 8px gap.
- The two-digit stub paints `"12"` next to the existing 3 pin, so arabic `tostring` and the width cap are checked on the same Refresh.
- `runB35A()` sits after `runB34A()` on the same fixture. Isolation wrap stays **13**. Writer-reported **814 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **No `/reload` smoke of live `SetWidth(28)` next to two-digit W/L vs VS / seal.** The isolated suite proves the stub `_width` field. Brief asked the isolated suite. Do not expand this exclusive pair.

2. **Harness `GetWidth` is not FontString layout.** `wow_ui_stub` `SetWidth` writes `_width`; it does not clip, wrap, or measure `GetStringWidth`. Anniversary overflow into VS / seal is unproven here.

### Nit

1. **The first nested `GetWidth() == 28` is not a virgin Init.** `Hud:Init` always `Refresh`es, and `runB35A()` runs after B34-A paints. `paintDefense` would keep the cap even if the `build()` mint were deleted. The source pin (`defenseA:SetWidth(28)` / `defenseB:SetWidth(28)`) is what ties the mint form; `paintDefense` uses `fs:SetWidth(28)`.

2. **Existing CountDefenses 3 pin (~618–637) still has no width assert.** Brief allowed that pin **or** a two-digit stub. The stub is the nested 12.

3. **`paintDefense` re-caps on the hide path too.** Soft. Brief allowed paint-path mint.

4. **Source pin is a string find.** `widget.defenseA:SetWidth(28)` matches. A comment with the same characters would still pass that pin. Widget `GetWidth` would still fail if nothing called `SetWidth`.

5. **Nested runtime width pins cover `nameA` / `recordA` / `vs`, not `nameB` / `recordB`.** Source pins cover all five. Reviewer probe: `nameB` / `recordB` `GetWidth()` stay `nil`.

6. **`GetPoint` pins omit the 8px offsets.** Reviewer probe: still `8, 0` and `-8, 0`.

7. **No `SetWordWrap(false)`.** Brief asked `SetWidth(28)` only. Two-digit `"12"` will not wrap; a later three-digit count could wrap vertically. Out of scope.

8. **Exclusive-pair diff is not a vs-HEAD Hud delta.** Packet is the B35-A-only header comment + `paintDefense` re-cap + two mint lines + nested pins. `git diff HEAD` on the two files still includes earlier HUD batches. Report already says this.

9. **Full `lua tests/run.lua` was not run.** Isolated **814 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **814 passed, 0 failed.** Isolation wrap: **13**. Writer ran `lua tests/test_hud.lua` (report: **814 / 0**). Reviewer re-ran: **814 / 0**, exit 0, Lua 5.1.5.

`build()` still anchors `defenseA` LEFT of `recordA` and `defenseB` RIGHT of `recordB`, then caps those two labels at `SetWidth(28)`. `paintDefense` re-asserts the same cap, then MUTED / `tostring(n)` / Hide-when-zero. Names / records / VS have no `SetWidth`. HUD `WIDTH` stays 420. `health` stays nil. No `UnitHealth`. No custom Media. No roman HUD numerals. Isolated `lua tests/test_hud.lua` **814 passed, 0 failed**, exit 0.

Leftovers: no client smoke; stub `GetWidth` is `_width`, not live clip; first nested width pin is post-paint; existing 3 pin has no width assert; hide-path also re-caps; full harness not run.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
