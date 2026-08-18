Spec PASS

# B32-A — Non-Gora hide forgets lastPair (review)

**Quality:** Approved-with-nits

**Lane:** B32-A Non-Gora hide forgets lastPair
**Brief:** `docs/reformation/vestments/briefs/B32-A-hud-forget.md`
**Writer report:** `docs/reformation/vestments/briefs/B32-A-hud-forget-report.md`
**Diff:** `docs/reformation/vestments/briefs/B32-A-hud-forget.diff` (B32-A-only exclusive-pair packet; live `Hud.lua` also carries earlier HUD batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Hud.lua` (`goraPair` / `livePair` / `forgetPersist` hoisted above `displayPair` / lastPair refuse arm ~311–321 / `pickPair` / Refresh QUIET forget), and `tests/test_hud.lua` (source `forgetPersist` inside `displayPair`, existing Sanction-during-Knighting and Gora CONSEQUENCE / ASSEMBLY persist pins, nested `runB32A()` inside `runB19C()` after `runB21B()`: Knighting Continue + Refresh → `shown == false`, names `""`); then ran `lua tests/test_hud.lua` (**764 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.7 (HUD exits with that Gora consequence); B19-C / B21-B hid lastPair through Knighting RITE and CONSEQUENCE but did not `forgetPersist`, so `Runtime:Continue` (ASSEMBLY, `riteType` nil) returned lastPair; refuse arm now calls `forgetPersist()` then returns nil when state is `RITE` or `CONSEQUENCE` and `riteType ~= "Gora"`; Gora CONSEQUENCE / ASSEMBLY Continue persist stay; QUIET still forgets in `Refresh`; no `UnitHealth`; no roman numerals; defense integers stay arabic mute; `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. Did not mutate `Hud.lua` or `test_hud.lua`. Did not commit. Did not edit FighterCard, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| lastPair still returns after Knighting Continue (B21-B leftover; ASSEMBLY + `riteType` nil) | **Pass. Verified.** Refuse arm calls `forgetPersist()` then `return nil`. Nested `runB32A()`: after B21-B Knighting CONSEQUENCE hide, Continue + Refresh → `shown == false`, leftover Gora names `""`, `health` nil. Reviewer probe: same sequence stays hidden; leftover Runtime fighter ids 99 / 100 stay on the snapshot and are not painted. |
| `forgetPersist` missing / refuse is still a paint-only hide | **Pass.** `forgetPersist` is hoisted above `displayPair` (Lua 5.1 local). Live refuse arm (~317) calls it before nil. Source pin finds `forgetPersist` inside the `displayPair` body. Reviewer probe: CONSEQUENCE-only refuse (skip RITE Refresh) also forgets; a later Continue stays hidden. |
| lastPair during Gora CONSEQUENCE broken | **Pass.** `riteType == "Gora"` misses the refuse. `runB19C()` still pins persist + names before the Knighting hide. Reviewer probe: same. |
| lastPair after a Gora Continue (ASSEMBLY, no prior forget) broken | **Pass.** Gate requires `RITE` or `CONSEQUENCE`. `runB19C()` re-pins ASSEMBLY persist before the Knighting hide. Reviewer probe: Gora → CloseRite → Continue still shown. |
| Live `GetSanctioned` hidden during Knighting | **Pass.** `livePair` still returns `goraPair()` first; forget runs only when lastPair would be used. Existing pin: Sanction then `OpenRite("Knighting")` stays shown. Reviewer probe: sanctioned A/B still painted through Knighting RITE, Knighting CONSEQUENCE, and Knighting Continue. |
| B19-C / B21-B hides broken; B16-C / B17-D Gora-RITE gates rewritten | **Pass.** Packet does not touch `livePair` / `pickPair`. Live source still has exactly two `'state == "RITE" and snap.riteType == "Gora"'` compares. Knighting RITE and CONSEQUENCE hide pins still run before `runB32A()`. |
| `UnitHealth` / live health / roman numerals | **Pass.** `Hud.lua` has no `UnitHealth`, `UnitHealthMax`, `UnitIsDead`, combat-log, or nameplate scrape. `paintDefense` is still `tostring(n)`. Hide / persist pins `health` nil. `healthReads == 0` at the B32-A block end. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. Reviewer probe: no `UnitHealth` / roman word; defense path is arabic. |
| Isolated suite not exit 0 / isolation wrap rewritten / exclusive breach | **Pass. Verified.** 764 passed, 0 failed. Writer-reported count matches. Isolation wrap stays **13**. Packet is the two named files. FighterCard has no vs-HEAD delta. Sibling dirt (`ChurchOfBeef.lua`) is other lanes (B32-INT glue), not this packet. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit FighterCard, glue; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| When `displayPair` refuses lastPair (`RITE` or `CONSEQUENCE` and `riteType ~= "Gora"`), call `forgetPersist()` then return nil | **Pass.** Live arm is that call then nil. Source pin + `runB32A()`. |
| Gora CONSEQUENCE / ASSEMBLY Continue persist stay | **Pass.** Named-risk check. |
| After B21-B Knighting CONSEQUENCE hide: Continue + Refresh → `shown == false`, names `""` | **Pass.** Nested `runB32A()` after `runB21B()` inside `runB19C()`. |
| QUIET still forgets in `Refresh` | **Pass.** Refresh `eventLive()` miss still `forgetPersist()`. Reviewer probe: EndEvent hides; a new ASSEMBLY does not revive the pair. |
| Live `GetSanctioned` still shows during Knighting | **Pass.** Named-risk check. |
| B16-C `pickPair` / B17-D `livePair` Gora-RITE gates stay; no lastPair clicks | **Pass.** Exactly two Gora-RITE compares. `clickPlate` still calls `pickPair()` only. |
| No `UnitHealth`; no roman numerals; defense integers arabic mute; `NAME_FONT` stays `Fonts\\MORPHEUS.ttf` | **Pass.** Named-risk check. |
| Nest `runB32A()` after `runB21B()` inside `runB19C()`; isolation wrap stays; `lua tests/test_hud.lua` exit 0 | **Pass.** **764 / 0.** Isolation wrap **13**. No new main-chunk function; `runB32A` is a nested local. |

Bible §10.7 holds on the exclusive pair: lastPair still paints Gora CONSEQUENCE and a Gora Continue, and a later non-Gora refuse forgets the pair so Knighting Continue cannot bring the Gora HUD back. Live sanction still wins during Knighting. Law 8 holds: `health` stays nil; no scrape. Law 10: no roman HUD numerals; defense stays `tostring(n)`.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client / two-client smoke; A01 still NOT RUN | **Not a miss.** Brief asked the isolated suite and forbade `UnitHealth`. `health` stays nil. |
| OpenRite stands in for STATE / Restore | **On contract.** Brief pins OpenRite. Runtime only opens a rite from ASSEMBLY, so CloseRite + Continue is the legal verb path between the two OpenRites. Reviewer Restore probe: Knighting RITE / CONSEQUENCE hide and forget; later ASSEMBLY Restore stays hidden; Gora CONSEQUENCE Restore still paints. |
| Confession / Proclamation leftovers are not separately pinned | **On contract.** Gate is `riteType ~= "Gora"` on RITE and CONSEQUENCE; only Knighting is the named leftover-forget pin. Reviewer probe: both other rites hide and stay hidden after Continue. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Gate W / Gate V stay OPEN; lane not signed | **On contract.** This review does not sign either. |

B32-INT glue is not required. This is a `displayPair` forget on the refuse arm; `livePair` / `pickPair` / Net / FighterCard are unchanged.

---

## Isolation / displayPair / persist

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Ranks + Store + Runtime + Gora + Hud. No `dofile` of Net / Snapshot / Knighting / Console / FighterCard. **13** nil-module pins stay under the first `if standalone then` (Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console). Wrap was not rewritten. Reviewer probe: those keys are nil at load.

**displayPair — Pass.** Live order is still `livePair()` first (`goraPair()` then B17-D Gora-RITE `runtimePair()`). The refuse sits only on the lastPair fall-through: Snapshot `RITE` or `CONSEQUENCE` and `riteType ~= "Gora"` now `forgetPersist()` then returns nil. B21-B leftover (Continue after Knighting returned lastPair) is closed when that refuse has run. Live Sanction during Knighting never reaches that arm. Refresh `paintHidden()` still clears name strings when the pair is nil. QUIET / EndEvent / `ResetForTests` still `forgetPersist()`.

**lastPair / pickPair / health — Pass.** Gora CONSEQUENCE and ASSEMBLY Continue still show. `clickPlate` still calls `pickPair()` only. `health` stays nil. No `UnitHealth`. No `UnitIsDead`. Defense integers stay arabic. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`.

---

## Strengths

- The delta is the brief: hoist the existing `forgetPersist` helper so the Lua 5.1 local is visible, then call it on the lastPair refuse. `livePair`, `pickPair`, favor paint, and Refresh QUIET forget were left alone.
- B21-B leftover (Knighting Continue returned lastPair because ASSEMBLY + `riteType` nil missed the refuse) is closed on the same remembered pair, not a second paint language. Gora CONSEQUENCE / ASSEMBLY persist stay pinned first so a blanket forget would fail.
- `goraPair()` stays first, so a live Sanction during Knighting cannot be swept up. A new Gora after the forget still paints (reviewer probe).
- `runB32A()` sits after `runB21B()` on the same fixture. Isolation wrap stays **13**. No new main-chunk locals. Writer-reported **764 / 0** matched the re-run. Writer-reported red (**757 / 7**) matches a missing `forgetPersist` source pin plus the leftover Continue paint asserts.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **A Knighting path that never `Refresh`es during RITE or CONSEQUENCE still returns lastPair on Continue.** Forget is on the refuse arm, not on the Runtime verb. Reviewer probe: Gora remember, OpenRite Knighting, CloseRite, Continue with no intervening `Hud:Refresh` → Continue Refresh re-shows Chuckroast. Live `afterRuntime` still does not call `Hud:Refresh` (B32-INT exclusive). Brief scoped the forget to `displayPair` refuse and forbade glue. Do not expand this exclusive pair.

### Nit

1. **OpenRite stands in for inbound STATE.** Congregation production lands the same snapshot via Restore / STATE. Brief sequence cannot `OpenRite("Knighting")` directly from a Gora RITE (`"rite opens from assembly"`). CloseRite + Continue is the verb path. Reviewer Restore probe agrees with the gate and the forget.

2. **Confession / Proclamation leftovers are not separately pinned.** The compare is `riteType ~= "Gora"`; only Knighting is named. Probe: both hide on RITE / CONSEQUENCE and stay hidden after Continue.

3. **Source pin is a string find on the `displayPair` body.** One `forgetPersist` token is enough. A comment would still pass. Live call is the production `forgetPersist()` then `return nil`.

4. **`runB32A()` does not re-pin live Sanction-during-Knighting or Gora CONSEQUENCE persist.** Those pins stay earlier / in `runB19C()` and still pass. Reviewer probe agrees.

5. **Exclusive-pair diff is not a vs-HEAD Hud delta.** Packet is the B32-A-only hoist + refuse call + pins. `git diff HEAD` on the two files still includes earlier HUD batches. Report already says this.

6. **No `/reload` / two-client Knighting-after-Gora smoke and no full `lua tests/run.lua`.** Isolated **764 / 0** was re-run here.

7. **`forgetPersist` also nils `lastPopeFavor`.** That is the existing helper, not a new wipe. Hidden Continue pins `favor == nil`. On contract with “call `forgetPersist()`.”

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **764 passed, 0 failed.** Isolation wrap: **13**.

`displayPair` still returns `livePair()` first. When lastPair would be used and Runtime is `RITE` or `CONSEQUENCE` with a `riteType` that is not `"Gora"`, it calls `forgetPersist()` then returns nil. After Knighting Continue, Refresh stays `shown == false` and leftover Gora names stay `""`. lastPair during Gora CONSEQUENCE and after a Gora Continue (ASSEMBLY, no prior forget) still paints. Live `GetSanctioned` still shows during Knighting. QUIET still forgets in `Refresh`. `health` stays nil. No `UnitHealth`. No roman numerals. Isolated `lua tests/test_hud.lua` **764 passed, 0 failed**, exit 0.

Leftovers: skip-Refresh during Knighting still lets Continue re-show lastPair (glue Hud Refresh is B32-INT; do not expand exclusive); OpenRite stands in for STATE (Restore probe agrees); Confession / Proclamation not separately pinned; no client smoke; full harness not run.

Do not claim V1 / MVP complete. This review does not sign the lane.
