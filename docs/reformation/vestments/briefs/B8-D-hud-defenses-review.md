Spec PASS

# B8-D — HUD mute defense count (review)

**Quality:** Approved-with-nits

**Lane:** B8-D HUD mute defense count
**Brief:** `docs/reformation/vestments/briefs/B8-D-hud-defenses.md`
**Writer report:** `docs/reformation/vestments/briefs/B8-D-hud-defenses-report.md`
**Diff:** `docs/reformation/vestments/briefs/B8-D-hud-defenses.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, `UI/Hud.lua`, and `tests/test_hud.lua`; then ran `lua tests/test_hud.lua` (**421 passed, 0 failed**, exit 0, Lua 5.1.5). Did not mutate Hud or the suite. Did not commit. Did not edit Store, FighterCard, Records, Gora, Console, TOC, bootstrap, or `run.lua`.

This review does not sign the lane.

---

## Named gates

| Gate | Verdict |
|---|---|
| Mute integer from `Store:CountDefenses` | **Pass.** `defenseCount` calls `COB.Store:CountDefenses(id)` when the method exists, requires a number, floors it, and returns the whole only when `> 0`. `paintDefense` `SetText(tostring(n))` — arabic `"3"`, not roman, not `"DEF"`, not realm copy. Stock `GameFontNormal`. `tint(..., MUTED)`. Not class-colored (suite pin). Per-fighter on `fighterA.defenses` / `fighterB.defenses`. Pair-level `view.defenses` stays nil. |
| Hide when 0 or method missing | **Pass.** Missing method, non-number, or floor `<= 0` → `nil` + `SetText("")` + `Hide`. Fresh pair (real Store derive returns 0) hides both widgets. Stub `3` / `0` shows A and hides B. Both-zero stub hides both. Quiet rebuild starts hidden. |
| No `UnitHealth` / `health` nil | **Pass.** `Hud.lua` has no `UnitHealth`, `UnitHealthMax`, combat-log, or nameplate scrape. `hiddenView` and `paintShown` both set `health = nil`. Suite source greps stay. `healthReads == 0` on the CountDefenses paint path and at suite end. Mute rails stay textures. `countStatusBars` stays 2. |
| Favor W-F intact | **Pass.** Provided diff does not touch `resolveFavor`, `SetBroadcastFavor`, `PickFavor`, `SetFavorTarget`, `SetLocalCharacterId`, plate `OnClick`, or percent math. Pope still reads `Gora:GetFavorSplit()` while a pair is live (including zeros). Congregation still reads last `SetBroadcastFavor({ a, b })` only. STATE-off (no broadcast) still omits the FAVOR label and both halves — re-pinned in the defense block. `{2,1}` stays 66/34. `Hud.Favor` / `Hud.SendFavor` stay nil. |
| Isolated green | **Pass.** Reviewer ran `lua tests/test_hud.lua`: **421 passed, 0 failed**, exit 0. Isolation nil-module block (14 pins) and the standalone summary stay under `if standalone then`. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Store, FighterCard, Records; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/Hud.lua` and `tests/test_hud.lua` (13 hunks). Store / FighterCard / Records are not in the packet. |
| Bible §10.7 defense count; mute integer per fighter; hide when 0 or method missing | **Pass.** Named-gate check. HUD does not inline the #9 derive and does not read `gora.defenses`. Missing method hides (B8-B was allowed to inline; this brief was not). |
| Do not invent odds copy | **Pass.** Source greps refuse `defenses of` and `of the realm`. Painted text is `"3"`. Suite refuses `odds` / `realm` in the glyph. No `view.odds`. |
| Do not scrape health; no `UnitHealth` | **Pass.** Named-gate check. A01 still NOT RUN. |
| Favor W-F intact; STATE-off still omits the split | **Pass.** Named-gate check. Existing Pope / congregation / `PickFavor` / plate-click body is still in the suite and still green. |
| Stock only; no extra row / StatusBar / custom Media | **Pass.** `GameFontNormal` on the existing record row (`LEFT` of `recordA`, `RIGHT` of `recordB`). Height helper and 420×100 card unchanged. No `Media\`, `.tga`, `.blp`, `.ttf`. No third StatusBar. |
| Tests: sanctioned pair + stub or real CountDefenses → integer visible; zero hides; health nil; STATE-off omit; isolation wrap stays | **Pass.** Visible path is a stub (`3`). Zero / missing hide. Fresh-pair hide also exercises in-tree `Store:CountDefenses` (returns 0 → omit). Isolation stayed gated. |
| `lua tests/test_hud.lua` exit 0; **POLISH:CANDIDATE** at most | **Pass. Verified.** 421 / 0. Writer claimed that polish ceiling and no more. |

Bible §10.7 (defense count on the compact HUD; defined no-live-health fallback), Law 4 (software never narrates), Law 8 (no health hack), Law 10 / §19.3 (theatrical mute; class color on names only), OPEN_QUESTIONS #9 (paint the Store derive; do not invent a counter), and W-F favor (Pope from Gora; congregation broadcast-only; STATE-off omits) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; two-digit count may clip on the 420-wide card | **Not a spec miss.** Brief asked isolated green and a mute integer on the existing row. **POLISH:CANDIDATE** is the ceiling. See Minor. |
| B8-A has not landed; widgets stay hidden until the method exists | **Stale report.** `Store:CountDefenses` is in this checkout. Fresh-pair hide already goes through the real method (0 → omit). Visible integer is still stub-only. Not a code miss: brief allowed stub **or** real. |
| A01 still NOT RUN; `health` nil; no `UnitHealth` | **Not a miss.** Brief forbade opening it. |
| No label; stream distance may read a stray number next to W/L | **Not a miss.** Brief asked a mute integer, not `"DEF"` / roman / realm copy. See Minor. |
| Integrator still lists the files in the TOC and `run.lua` | **Not a miss.** Brief forbade those edits. Already listed. |

---

## Strengths

- Exclusive pair is small and on-contract. Favor fill, plate send, A01, Quiet hide, and the two favor StatusBars were not reopened.
- Hide is cheap and fail-closed: missing method, non-number, and `<= 0` are the same omit. The HUD does not invent a pair `defenses` table and does not walk `gora.results` itself.
- Painted glyph is only the integer. Source and widget greps keep odds / realm / `"defenses of"` out.
- W-F still proves itself in the same suite: Pope zeros and 2/1 → 66/34, congregation broadcast-only, STATE-off omit (re-asserted beside the defense stub), gated plate click.
- Isolation stayed gated. Writer-reported 421 / 0 matches the reviewer run.

---

## Issues

### Critical

None.

### Important (must-fix)

None.

### Minor

1. **Visible integer is stub-only.** B8-A is in this tree. A linked Lord + post-elevation win is never painted through the real `CountDefenses` on this surface. Brief allowed the stub. Fresh-pair hide does use the real method. B8-C seeded the Lord path; this lane did not.

2. **No `SetWidth` on `defenseA` / `defenseB`.** Same-row as level + W/L, growing toward center. One digit is fine. A two-digit W/L plus a two-digit count can crowd the seal / VS / opposite record. Writer disclosed clip. Unsmoked.

3. **No label.** Brief forbade realm copy. At stream distance `70  1-0  3` can read as a stray third number. Acceptable mute; not dual-encoded.

4. **MUTED ink is implemented, not pinned.** Suite asserts defense A is not class-colored. It does not assert the MUTED triple `{0.55, 0.50, 0.42}`. Source always `tint(fs, MUTED)`.

5. **B-only visible is unpinned.** Stub coverage is A=3/B=0, both 0, then A=2. The B widget and `RIGHT` anchor exist; a B-only nonzero is not asserted.

6. **Writer report is stale on B8-A.** "B8-A has not landed in this checkout" is false here. Does not change the code gate.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated suite was re-run here. Do not treat this as **POLISH:PASS**.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

The exclusive pair does what the brief asked: `Store:CountDefenses` paints as a mute arabic integer per fighter; zero and a missing method hide; no odds copy; `health` stays nil; no `UnitHealth`; W-F favor (including STATE-off omit) is untouched; isolated suite green (421 / 0). Named gates are clean. Nits are stub-only visible paint, unsmoked same-row clip, unlabeled glyph, and a stale B8-A sentence — not trust-breakers.

Must-fix list: **none.**

Do not sign. Do not claim **POLISH:PASS**. Do not claim V1 / MVP complete.
