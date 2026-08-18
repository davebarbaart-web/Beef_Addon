# B3-B — Mute fighter cards (review)

**Spec:** PASS
**Quality:** Approved

**Lane:** B3-B Mute fighter cards
**Brief:** `docs/reformation/vestments/briefs/B3-B-fightercard.md`
**API note:** `docs/reformation/vestments/briefs/V-stock-textures.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B3-B-fightercard-report.md`
**Diff:** `docs/reformation/vestments/briefs/B3-B-fightercard.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

Task-scoped gate only. Reviewer read the brief, the stock-texture note, the writer report, and the provided diff; then made one focused check per named risk (mute / no prose; no `UnitHealth`; no defenses invented; TOC / `run.lua` not edited). Did not mutate the working tree except this review file. Did not re-run git or the harness. Writer-reported **263 / 0** is a claim — do not treat it as verified.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Mute / no prose | **Pass.** Source has no `rubber`, `ordained`, or `one apiece`. Head-to-head paints `recordText` (`1-0`) only when Store `fights > 0`; otherwise the widget is hidden. Stipulation is `Gora:GetSanctioned().stipulation` as-is, or hidden. Titles come from `Store:RankForCharacter` → `Ranks.Title` (unlinked paints empty, not Fresh Beef). `Narrate` / `Announce` stay nil. `VS` is the same structural chrome as `Hud.lua`, not Bible §10.6 color commentary. |
| No `UnitHealth` | **Pass.** `FighterCard.lua` has no `UnitHealth`, `UnitHealthMax`, combat-log, or nameplate scrape. `hiddenView` and `paintShown` both set `health = nil`. Suite stubs those APIs, greps the source, and pins `healthReads == 0` on Show / Hide / suite end. No StatusBar. No `GetHealth` / `ScrapeHealth`. |
| No defenses invented | **Pass.** `fighterFrom` copies wins / losses only. Views omit `defenses`. After `DeclareVictor`, suite re-pins `Store` still nils `gora.defenses`. No `defenseCount`, no zero counter, no read of the niled Store fields. OPEN_QUESTIONS #9 stays closed. |
| TOC / `run.lua` not edited | **Pass.** Provided diff is two `diff --git` hunks: `UI/FighterCard.lua` and `tests/test_fighter_card.lua`. Current `ChurchOfBeef.toc` does not list `FighterCard.lua`. Current `tests/run.lua` does not list `test_fighter_card`. Bootstrap has no `FighterCard` symbol. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no TOC / `run.lua` / Console / Hud / Toasts / Store / Gora / Runtime / bootstrap / OPEN_QUESTIONS / REFORMATION_LOG / Media / commit | **Pass.** Named-risk check. Packet is the two exclusive files. |
| API: `Init` / `Show` / `Hide` / `Refresh` / `GetView` (copy) / `ResetForTests` | **Pass.** `MODE = "Event"`. `Show` is true only for a live `GetSanctioned` pair; else `paintHidden` and `false`. `GetView` is `deepcopy(lastView)`. Out-of-harness `ResetForTests` returns false and does not hide. |
| Event Mode; hidden in Quiet / no pair | **Pass.** Quiet Show is false. ASSEMBLY without Sanction is false. `DeclareVictor` clears the pair and Refresh hides. `EndEvent` → QUIET → Show false. Hide does not clear the live pair. Production `GetSanctioned` calls `_Expire`, so QUIET drops the pair. |
| Stock QuestBG + WHITE8X8; center-third or two facing plates; not a full-screen toast | **Pass.** Iron fill + inset QuestBG via `pcall` `SetTexture`; WHITE8X8 then `SetColorTexture`. Two facing plates. Width = `floor(parent/3)` or **420**; height = `min(220, floor(parent/3))` or **220**. Suite pins 420×220 on the stub parent and 341×220 on 1024×768. No close button. No `OnUpdate`. |
| Plate fields from Store + Ranks (same helpers as HUD) | **Pass.** `churchTitle`, `classColor`, `headToHeadFor`, `fighterFrom`, `recordText`, `levelText` match `Hud.lua`. Class color on the name only. Level omitted when not a number. W–L is Store wins/losses (`0-0`, `1-0`). |
| Church title, never Squire / Paladin-as-title | **Pass.** Linked Knight / Fresh Beef come from `Ranks.Title`. Source greps refuse `Squire` and `Paladin`. Painted title is not a class mash. |
| Head-to-head as numbers when history exists — no prose | **Pass.** Named-risk check. |
| Stipulation from `GetSanctioned().stipulation` if any | **Pass.** `"no potions"` paints; empty / missing hides the widget. |
| Defenses omitted; `health` not on the card; no `UnitHealth`; no jokes; no sound | **Pass.** Named-risk checks. Suite `sounds == 0`. No `PlaySound` in source. Toast trap: a planted `COB.Toasts` is not called. |
| Isolated suite: wow_ui_stub + Common + Ranks + Store + Runtime + Gora + FighterCard | **Pass.** That load list only. Isolation nil-module asserts stay under `if standalone then`. |
| Named tests (Quiet refuse, sanction paint, GetView copy, no `rubber` / `ordained` in source) | **Pass.** Plus titles, W–L, stipulation, rematch `1-0`, class-color-on-name-only, unlinked empty title, missing class/level, out-of-harness Reset, center-third rebuild, health / defense / sound pins. |
| No custom media; **POLISH:CANDIDATE** at most | **Pass.** No `Media\`, `.tga`, `.blp`, or `.ttf`. Writer claimed that ceiling and no more. |

Bible §10.6 (mute tale of the tape), Law 4 (software never narrates), Law 6 (Event chrome; Quiet hides), Law 10 / §19.3 (theatrical dress, UI never tells jokes), and CONTINUE license 4 (stock textures this wave) are met on the exclusive pair. Bible’s example H2H sentence stays Pope speech; the card shows `1-0`.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; QuestBG + EmptySlot may read as quest-log / mail-slot chrome | **Not a miss.** License 4 and the brief require stock paths. **POLISH:CANDIDATE** is the ceiling. |
| Size sampled once at first `Init` | **Not a miss.** Brief named the center-third / compact rule, not live resize. Idempotent `Init` keeps the first size. |
| Defenses stay omitted until Store stops nilling the field | **Not a miss.** That is the brief. Do not invent a counter. |
| `WHITE8X8` is UNCONFIRMED | **Minor.** V-stock already marks it UNCONFIRMED. `fill()` `pcall`s `SetTexture`, then vertex-colors; `SetColorTexture` is the throw fallback. |
| Integrator still lists the files in the TOC and `run.lua` | **Not a miss.** Brief forbade those edits. |

---

## Strengths

- The card is a display terminal. It reads Store / Ranks / `GetSanctioned` and does not write characters, clear the pair, toast, chat, or play sound.
- Mute is enforced in paint, not only in comments: H2H is a Store record string; stipulation is the Pope line; flavor greps cover the Bible’s own example words.
- Defenses and live health are actually absent. `health` is a literal nil on both view paths. Fighter rows have no defense field. The rematch block re-checks Store still nils `defenses`.
- Plate helpers are the HUD copies, including unlinked-title omit and `Ranks.Title` `"Unknown"` drop, so this surface cannot invent Fresh Beef or Paladin-as-title on its own.
- Isolation stayed gated. Quiet / no-pair / copy / scrape pins sit in the shared body.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **`SetTexture` fallback is throw-only.** `applyTexture` returns true whenever `SetTexture` does not error. A silent missing `QuestBG` / `UI-EmptySlot-White` / `WHITE8X8` on 20506 will not fall through to fill. Writer disclosed the `WHITE8X8` case. Load still succeeds. Same edge as V-A / V-D.

2. **Quiet hide depends on `Gora:GetSanctioned` → `_Expire`.** `Hud.lua` also consults `eventLive()`. This card does not. Production Gora clears the pair in QUIET, and the suite hits that path via `EndEvent`. A stubbed `GetSanctioned` that skipped `_Expire` would Show in Quiet. Not a production miss.

3. **28×28 EmptySlot sits on the `VS` label.** Brief allowed QuestBG + WHITE8X8 and two plates; the ring is licensed stock (V-stock preferred). It crowds the center of a 220px card. Unsmoked.

4. **Center-third after a known `UIParent` size is rebuilt via mid-suite `dofile`.** First `Init` keeps 420×220 because the stub parent has no size. Later live size changes do not resize. Brief did not ask for live resize.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Writer-reported isolated `tests/test_fighter_card.lua` **263 / 0** was **not** re-run here. Do not treat that count as verified.

---

## Assessment

**Spec PASS. Quality Approved.**

This is the B3-B mute-tape contract: Event Mode card, Quiet / no-pair Show is false, plates are Store + Ranks, H2H is `1-0` not prose, stipulation is the Pope line, defenses are omitted, `health` is nil, no `UnitHealth`, exclusive files only. Named risks are clean. Minors are throw-only texture fallback, unsmoked stock chrome, and integrator listing — not trust-breakers.

Expected leftover (not a miss): integrator lists `UI\FighterCard.lua` in the TOC and `test_fighter_card` in `tests/run.lua`, then wires a caller. Until that list lands, the runner’s on-disk discovery contract will fail because `tests/test_fighter_card.lua` exists and is unlisted.

Writer-reported isolated **263 passed, 0 failed** was not re-run. Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
