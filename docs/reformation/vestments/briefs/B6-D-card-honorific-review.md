Spec PASS

# B6-D — Mute fighter-card honorifics (review)

**Quality:** Approved-with-nits

**Lane:** B6-D Mute fighter-card honorifics
**Brief:** `docs/reformation/vestments/briefs/B6-D-card-honorific.md`
**Writer report:** `docs/reformation/vestments/briefs/B6-D-card-honorific-report.md`
**Diff:** `docs/reformation/vestments/briefs/B6-D-card-honorific.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, `UI/FighterCard.lua`, and `tests/test_fighter_card.lua`; checked the provided exclusive-pair diff; then ran `lua tests/test_fighter_card.lua`. Isolated result: **329 passed, 0 failed**, exit 0. Did not mutate addon code. Did not commit. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Honorific paints Store text or hides | **Pass.** `fighterFrom` reads `Store:GetCharacter(id)` then `honorificFrom(ch)` uses `ch.humanId` → `Store:GetHuman`. First string in `human.honorifics` is returned as-is (`return first`). Empty table, empty string, missing human, or `humanId == nil` → `nil`. `paintHonorific` `SetText` + `Show` only for a non-empty string; else `SetText("")` + `Hide`. Suite: fresh linked humans hide; `AddHonorific(..., "Defender of the Faith")` then `Refresh` paints exactly that string on plate A; unseeded plate B stays hidden. |
| `1-0` pins stay | **Pass.** `recordText` is still `wins-losses` arabic. Pre-existing rematch pins remain: plate A `1-0`, plate B `0-1`, `headToHead` `1-0`. Honorific rematch re-pins the same three strings after `DeclareVictor` + `Sanction`. Seeding an honorific does not change a fresh `0-0`. No `toRoman`. |
| No `UnitHealth` | **Pass.** Source has no `UnitHealth`, `UnitHealthMax`, combat-log, or nameplate scrape. `hiddenView` / `paintShown` set `health = nil`. Suite stubs those APIs and pins `healthReads == 0` on Show / Hide / suite end. No `StatusBar`. |
| No invented titles | **Pass.** Honorific is not `Ranks.Title` and not a class mash. Unlinked characters (`humanId` nil) keep `honorific == nil` and a hidden empty widget. Source greps refuse `Duke of`, `Squire`, and `Paladin`. Painted seed is Store text, not `"Duke of …"`. Mutating `GetView().fighterA.honorific` to `"Duke of the Fountain"` does not leak. Church title stays a separate plate line. |
| Isolated green | **Pass.** Reviewer ran `lua tests/test_fighter_card.lua`: **329 passed, 0 failed**, exit 0. Isolation nil-module asserts and the standalone summary stay under `if standalone then`. Load list is still wow_ui_stub + Common + Ranks + Store + Runtime + Gora + FighterCard. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Hud, Toasts, Console; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/FighterCard.lua` and `tests/test_fighter_card.lua`. Hud / Toasts have no honorific paint. |
| Read `Store:GetCharacter(id).humanId` → `Store:GetHuman.honorifics`; first honorific as a mute line (or ` · ` join, max 2); empty → hide | **Pass.** First only. Empty / unlinked hide. Join of two was optional; this lane does not join. **Nit:** later Store honorifics stay unpublished (see Issues). |
| Never invent `"Duke of …"` | **Pass.** Named-risk check. `honorificFrom` has no fallback string. |
| LEFT dock and MORPHEUS names stay | **Pass.** `SetPoint("LEFT", parent, "LEFT", 0, 0)` unchanged. `NAME_FONT = "Fonts\\MORPHEUS.TTF"` still applies only to plate names. Honorific is `GameFontNormal` + `MUTED`, not class-colored. |
| Keep H2H / record as `1-0`; no `UnitHealth`; no generated flavor | **Pass.** Named-risk checks. Source still refuses `rubber` / `ordained` / `one apiece`. |
| Tests: no honorifics → hidden; seed Pope text → exact string; `1-0` pins stay; isolation wrap stays | **Pass.** Shared-body empty hide + dedicated honorific block + rematch re-pin + gated isolation. |
| Isolated `lua tests/test_fighter_card.lua` exit 0 | **Pass.** Verified 329 / 0. |
| **POLISH:CANDIDATE** at most | **Pass.** Writer claimed that ceiling and no more. |

Bible §10.6 (mute tape, relevant accolades), §15 (honorifics are Pope-authored plain text), Law 4 (software never narrates), Law 6 (Event chrome; Quiet hides), Law 10 (theatrical dress; UI never tells jokes), and B3-B / B4-E `1-0` + LEFT + Morpheus pins are met on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; extra mute line on the 220-high plate unsmoked; long Pope text may clip | **Not a spec miss.** Brief asked isolated green. **POLISH:CANDIDATE** is the ceiling. **Nit:** no `SetWidth` / `SetWordWrap` on the new line (see Issues). |
| First honorific only; brief allowed a ` · ` join of at most two | **Not a miss.** Brief named first, with join optional. |
| Defenses stay omitted until Store stops nilling the field | **Not a miss.** Out of this brief. Do not invent a counter. |
| Integrator still lists the files in the TOC and `run.lua` | **Not a miss.** Brief forbade those edits. |

---

## Strengths

- The card remains a display terminal. It reads Store text and does not write humans, invent a title, toast, chat, or play sound.
- Empty and unlinked are the same hide path. Linked humans with `honorifics = {}` do not fall back to Fresh Beef, rank, or `"Duke of …"`.
- Seed-then-paint is exact: `AddHonorific` → `Refresh` → `GetView` and the FontString both equal `"Defender of the Faith"`. Plate B stays empty when that human was not seeded.
- Arabic `1-0` survives the new line. The honorific rematch block re-pins record A / B / H2H after the paint path has run.
- LEFT dock, Morpheus names, `GameFont*` ledger, class-color-on-name-only, Quiet hide, `health` nil, and gated isolation were left alone.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Long Pope text can overflow the plate.** Honorific is a `GameFontNormal` FontString with no `SetWidth` and no `SetWordWrap`. Plate width is `floor((cardW - 56) / 2)` — **182** on the 420 fallback. A real GRANT HONORIFIC line will run into the VS / seal or off the parchment. Writer disclosed clip. Unsmoked.

2. **First honorific only.** Brief allowed a ` · ` join of at most two. `honorificFrom` returns `honorifics[1]` and drops the rest. Legal. Later Pope text on that human stays unpublished on this surface.

3. **Suite seeds one Bible example.** `"Defender of the Faith"` is the only painted title. A substitution that returned that literal whenever `honorifics[1]` was any non-empty string would still go green. Reviewer checked source: `return first`. A second, different `AddHonorific` seed is not in the suite.

4. **`Duke of` is a phrase grep.** It catches the Bible’s own example wording in source. It does not prove the paint path refuses generation. The hide / exact-seed / unlinked pins do that.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated 329 / 0 was re-run here. Client path and runner listing were not.

---

## Assessment

**Spec PASS. Quality Approved-with-nits.**

This is the B6-D contract: mute honorific line from `GetCharacter.humanId` → `GetHuman.honorifics[1]`, hide when empty or unlinked, paint seeded Pope text exactly, keep `1-0`, no `UnitHealth`, no invented `"Duke of …"`, LEFT / Morpheus names stay, isolated suite green. Named risks are clean. The nits are clip on a compact plate, first-only unpublished rest, and a single-seed test gap — not trust-breakers.

Expected leftover (not a miss): integrator lists `UI\FighterCard.lua` in the TOC and `test_fighter_card` in `tests/run.lua` if those lines are not already present. Brief forbade those edits.

Isolated **329 passed, 0 failed** verified. Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
