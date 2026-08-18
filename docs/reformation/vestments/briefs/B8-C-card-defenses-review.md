Spec PASS

# B8-C — Fighter card mute defense count (review)

**Quality:** Approved-with-nits

**Lane:** B8-C Fighter card mute defense count
**Brief:** `docs/reformation/vestments/briefs/B8-C-card-defenses.md`
**Writer report:** `docs/reformation/vestments/briefs/B8-C-card-defenses-report.md`
**Diff:** `docs/reformation/vestments/briefs/B8-C-card-defenses.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the exclusive-pair diff, `UI/FighterCard.lua`, and `tests/test_fighter_card.lua`; then ran `lua tests/test_fighter_card.lua`. Isolated result: **388 passed, 0 failed**, exit 0. Did not mutate addon code. Did not edit Store, HUD, or Records. Did not commit. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Mute integer only | **Pass.** `defensesFrom` reads `Store:CountDefenses(id)` and returns the number only when `type(n) == "number"` and `n >= 1`. `paintDefenses` `SetText(tostring(count))` — plate text is `"1"` / `"2"`, not `"1 defense"` or `"defenses of the realm"`. Zero or a non-number becomes `nil` and the line `SetText("")` + `Hide`. View field is the integer on the fighter row, not a pair-level counter. |
| Keep `1-0` | **Pass.** `recordText` is still `wins-losses` arabic. Defenses block re-pins plate A `1-0`, plate B `0-1`, H2H `1-0` after the Lord rematch paint, after honorific seed, after stubbing `CountDefenses` to `2`, and after nilling the method. No `toRoman`. Seeding / stubbing the count does not change W/L. |
| No `UnitHealth` | **Pass.** Source has no `UnitHealth`, `UnitHealthMax`, combat-log, or nameplate scrape. `hiddenView` / `paintShown` set `health = nil`. Suite stubs those APIs; first Show and suite end pin `healthReads == 0`. Defenses view pin: `view.health` stays nil. No `StatusBar`. No `GetHealth` / `ScrapeHealth`. |
| No flavor | **Pass.** Painted defenses line has no `defense` / `realm` substring. Source greps refuse `defenses of the realm`, `Duke of`, `rubber`, `ordained`, `one apiece`. Honorific remains Pope `Store` text (`Defender of the Faith`), not card-authored copy. No `PlaySound`, no `Media\\`, no `SendChatMessage`. `VS` is pre-existing structural chrome, not this lane. |
| Zero / missing method hides | **Pass.** Fresh sanctioned pair (no Lord win) hides both plates and omits `fighter*.defenses`. Challenger plate after a Lord defense hides. `Store.CountDefenses = nil` then `Refresh` → view field nil, widget hidden, empty text. Honorific and `1-0` survive that hide. |
| Honorific stays | **Pass.** `paintDefenses` re-anchors honorific under the integer when shown, else back to the record. `AddHonorific` then `Refresh` keeps `"Defender of the Faith"` shown with defenses `"1"`. Stub-to-`2` and missing-method paths keep the honorific shown. |
| Isolated green | **Pass.** Reviewer ran `lua tests/test_fighter_card.lua`: **388 passed, 0 failed**, exit 0. Isolation nil-module asserts stay under `if standalone then` (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Sound, Decree, Records Book — **17**). Load list is still wow_ui_stub + Common + Ranks + Store + Runtime + Gora + FighterCard. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Store, HUD, Records; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/FighterCard.lua` and `tests/test_fighter_card.lua`. Card reads `CountDefenses`; it does not write `gora.defenses`. |
| Paint `Store:CountDefenses(id)` as a mute integer on each plate | **Pass.** Named-risk check. Colon call so `self` is Store. Missing method short-circuits before the call. |
| Hide when count is 0 or the method is missing | **Pass.** Named-risk check. `n < 1` and non-number omit. No painted `"0"`. |
| Do not write copy like "defenses of the realm" | **Pass.** Named-risk check. Exact plate pins are `"1"` and `"2"`. |
| Stock GameFont; honorific line stays | **Pass.** `makeLabel(..., "GameFontNormal")`. MUTED, not class-colored. Honorific path named above. |
| Keep H2H / record as `1-0`; no `UnitHealth`; no generated flavor | **Pass.** Named-risk checks. LEFT dock and Morpheus names unchanged. |
| Tests: Lord + post-elevation win (or stub) → integer; zero hides; isolation wrap; health nil | **Pass.** Happy path uses live `CountDefenses` (B8-A is in this tree: `SetRank(4)` stamps `elevationAt`, `DeclareVictor` writes `won == true` with `at >= elevationAt` → `1`). Stub paints `2`. Missing method hides. Shared-body zero-hide + gated isolation + `health` nil. |
| Isolated `lua tests/test_fighter_card.lua` exit 0 | **Pass.** Verified 388 / 0. Writer-reported count matches. |
| **POLISH:CANDIDATE** at most | **Pass.** Writer claimed that ceiling and no more. |

Bible §10.6 (mute tape includes defenses; the card shows, the Pope tells), §10.4 / OPEN_QUESTIONS #9 (defenses are a derived story field, not a title-defense schema — this lane paints, it does not increment), Law 4 (software never narrates), Law 6 (Event chrome; Quiet hides), Law 10 (theatrical dress; UI never tells jokes), and B3-B / B4-E / B6-D `1-0` + LEFT + Morpheus + honorific pins are met on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; extra mute line on the 220-high plate may clip with honorific | **Not a spec miss.** Brief asked isolated green. **POLISH:CANDIDATE** is the ceiling. **Nit:** no `SetWidth` / `SetWordWrap`; honorific `GetPoint` after re-anchor is unpinned (see Leftover). |
| Unlabeled integer; a first-time spectator will not know the digit means defenses | **Matches the brief.** Mute integer, no realm copy. The Pope still tells. |
| B8-A present; suite also stubs / nils the method | **Not a miss.** Brief named the seed *or* stub. Both paths exist. Card does not invent a counter. |
| Integrator still lists the files in the TOC and `run.lua` | **Stale, not a miss.** `ChurchOfBeef.toc` already lists `UI\FighterCard.lua`. `tests/run.lua` already lists `test_fighter_card`. Brief forbade those edits. |

---

## Strengths

- The card remains a display terminal. It reads `CountDefenses` and does not write characters, increment a stored defense field, toast, chat, or play sound.
- Zero and missing method are the same hide path. Linked Fresh Beef / unearned plates do not fall back to `"0"` or realm copy.
- Seed-then-paint is exact: sitting Lord + one post-elevation win → plate `"1"`; stub → `"2"`; nil method → hidden empty. Challenger plate stays hidden.
- Arabic `1-0` survives the new line on record A / B and H2H across honorific seed, stub, and missing-method hide.
- Honorific is still Store human text. LEFT dock, Morpheus names, `GameFont*` ledger, class-color-on-name-only, Quiet hide, `health` nil, and gated isolation were left alone.
- Isolation stayed gated. Writer-reported 388 / 0 matched the re-run.

---

## Must-fix

None.

---

## Leftover

1. **Compact plate clip is unsmoked.** Six mute lines (name / title / level / record / integer / honorific) on a 220-high card, plate height `220 - 56`. Fallback math fits a short GameFont stack; a long GRANT HONORIFIC string still has no `SetWidth` / `SetWordWrap` (same B6-D nit). Honorific + integer on a short `UIParent` third would clip. **POLISH:CANDIDATE** only.

2. **Honorific re-anchor is unpinned.** `build()` still `SetPoint`s honorific on the record — the same point as the new defenses line. `paintDefenses` `ClearAllPoints` + re-anchors under the integer or back to the record. Suite never `GetPoint`s honorific. An overlap bug would still pass the text / `IsShown` pins. Live source does the re-anchor.

3. **`gora.defenses` pin is mistimed.** `assert_eq(..., nil, "card does not write gora.defenses")` runs after `DeclareVictor` and *before* `Show`. That proves B8-A still nils the stored field, not that paint refuses to write it. Reviewer checked source: no `gora.defenses` assignment. Post-`Show` re-pin is absent.

4. **Happy-path `CountDefenses == 1` is a cross-lane pin.** When the Store method exists, the suite asserts B8-A’s #9 derive (sitting Lord + one post-elevation win → 1). Brief allowed that seed. The card still paints whatever the method returns (stub `2`). Do not treat this file as the increment-rule owner.

5. **Source `defenses of the realm` grep is easy.** A comment without that phrase would satisfy it. The plate pins (`GetText() == "1"` / `"2"`, no `defense` / `realm` substring) are the real proof.

6. **`tostring(count)` is not `%d`.** Store’s derive only increments from 0, so the plate stays arabic integers. A non-integer number `>= 1` would paint decimals. `defensesFrom` does not floor.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated 388 / 0 was re-run here. Client path was not.

---

## Assessment

**Spec PASS. Quality Approved-with-nits.**

This is the B8-C contract: mute `CountDefenses` integer on each plate, hide when 0 or the method is missing, no realm copy, honorific stays, keep `1-0`, no `UnitHealth`, no generated flavor, exclusive files only, isolated suite green. Named risks are clean. Must-fix is empty. Leftovers are unsmoked clip, unpinned honorific `GetPoint`, a mistimed `gora.defenses` assert, and a cross-lane increment pin — not trust-breakers.

Expected leftover (not a miss): integrator wiring / in-game smoke. TOC and `run.lua` already list these files.

Isolated **388 passed, 0 failed** verified. Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
