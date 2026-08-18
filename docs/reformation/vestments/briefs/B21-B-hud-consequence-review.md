Spec PASS

# B21-B — lastPair does not paint through a non-Gora CONSEQUENCE (review)

**Quality:** Approved-with-nits

**Lane:** B21-B lastPair does not paint through a non-Gora CONSEQUENCE
**Brief:** `docs/reformation/vestments/briefs/B21-B-hud-consequence.md`
**Writer report:** `docs/reformation/vestments/briefs/B21-B-hud-consequence-report.md`
**Diff:** `docs/reformation/vestments/briefs/B21-B-hud-consequence.diff` (B21-B-only exclusive-pair packet; live `Hud.lua` also carries earlier HUD batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Hud.lua` (`goraPair` / `livePair` / `displayPair` lastPair arm / `pickPair` / Refresh hide), and `tests/test_hud.lua` (source `RITE` or `CONSEQUENCE` pin, existing Sanction-during-Knighting and Gora CONSEQUENCE / ASSEMBLY persist pins, nested `runB21B()` inside `runB19C()` after the Knighting RITE hide: CloseRite → CONSEQUENCE / Knighting → `shown == false`); then ran `lua tests/test_hud.lua` (**729 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.7 (HUD persists through a **Gora** verdict); lastPair refuse `RITE` or `CONSEQUENCE` when `riteType ~= "Gora"`; Gora CONSEQUENCE / ASSEMBLY persist stay; B16-C `pickPair` and B17-D `livePair` Gora-RITE gates stay; live `GetSanctioned` still shows during Knighting; no `UnitHealth`. Did not mutate `Hud.lua` or `test_hud.lua`. Did not commit. Did not edit Gora, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `lastPair` still paints during a later Knighting CONSEQUENCE (B19-C leftover) | **Pass. Verified.** `displayPair` lastPair arm: `(snap.state == "RITE" or snap.state == "CONSEQUENCE")` and `snap.riteType ~= "Gora"` returns nil. `runB21B()`: after the B19-C Knighting hide, CloseRite → CONSEQUENCE / Knighting, no Sanction → `shown == false`, leftover Gora names empty, `health` nil. Reviewer probe: same hide; leftover Runtime fighter ids 99 / 100 stay on the snapshot and are not painted. |
| Live `GetSanctioned` hidden during Knighting | **Pass.** `livePair` still returns `goraPair()` first; the new conjunct runs only when lastPair would be used. Existing pin: Sanction then `OpenRite("Knighting")` stays shown. Reviewer probe: sanctioned A/B still painted through Knighting RITE and Knighting CONSEQUENCE; leftover fighter ids 99 / 100 are not the painted pair. |
| lastPair during Gora CONSEQUENCE broken | **Pass.** CloseRite leaves `riteType == "Gora"` and `state == "CONSEQUENCE"`, so `riteType ~= "Gora"` misses. `runB19C()` still pins persist + names before the Knighting hide. Reviewer probe: same. |
| lastPair after Continue (ASSEMBLY, no riteType) broken | **Pass.** Gate requires `RITE` or `CONSEQUENCE`. `runB19C()` re-pins ASSEMBLY persist before the Knighting hide. Existing B10-B / leftover-pick Continue pins stay. Reviewer probe: Gora → CloseRite → Continue still shown. |
| B19-C Knighting RITE hide broken | **Pass.** RITE conjunct stays. `runB19C()` hide + empty names still run immediately before `runB21B()`. Reviewer probe: same. |
| B16-C `pickPair` / B17-D `livePair` Gora-RITE gates rewritten | **Pass.** Packet does not touch those arms. Live source still has exactly two `'state == "RITE" and snap.riteType == "Gora"'` compares. Continue persist plates still send 0. |
| `UnitHealth` / live health | **Pass.** `Hud.lua` has no `UnitHealth`, `UnitHealthMax`, `UnitIsDead`, combat-log, or nameplate scrape. Hide / persist pins `health` nil. `healthReads == 0` at the B21-B block end. Reviewer probe: source `UnitHealth` / `UnitIsDead` are nil; hide / persist / Restore views stay `health` nil; `healthReads == 0`. |
| Isolated suite not exit 0 | **Pass. Verified.** 729 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Provided packet is two `diff --git` hunks: `UI/Hud.lua` and `tests/test_hud.lua`. Live `displayPair` lastPair arm matches that slice. Sibling dirt in this workspace is other lanes (Gora, Console, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Gora, glue; no commit; no `UnitHealth` | **Pass.** Named-risk check. |
| `displayPair`: if lastPair would be used and snapshot is `RITE` **or** `CONSEQUENCE` with `riteType` not `"Gora"`, return nil (do not paint) | **Pass.** Live arm is that conjunct. Source pin finds `state == "RITE" or snap.state == "CONSEQUENCE"`. `runB21B()` hide + empty names. |
| Live `GetSanctioned` still shows during Knighting (existing pin) | **Pass.** Named-risk check. |
| lastPair during Gora CONSEQUENCE still paints | **Pass.** Named-risk check. |
| lastPair after Continue (ASSEMBLY, no riteType) still paints | **Pass.** Named-risk check. |
| B19-C Knighting RITE hide stays | **Pass.** Named-risk check. |
| QUIET still hides | **Pass.** Existing Quiet pins stay. Reviewer probe: EndEvent forgets lastPair; a new ASSEMBLY does not re-paint. |
| After the B19-C Knighting hide: `CloseRite` → CONSEQUENCE / Knighting → Refresh `shown == false` (leftover Gora names stay unpainted) | **Pass.** Nested `runB21B()` inside `runB19C()`. Pins both `shown == false` and empty name strings. `riteType` stays `"Knighting"`. |
| B16-C pickPair and B17-D livePair Gora-RITE gates stay; Favor W-F intact; dress stays stock | **Pass.** Packet is header comments + lastPair refuse conjunct + suite pins. `pickPair` / `livePair` / `resolveFavor` / stock iron-parchment are untouched. Isolation wrap stays **13**. |
| Isolation wrap stays; `health` stays nil; nest `runB21B()` (no new main-chunk locals) | **Pass.** Named-risk check. `runB21B` is a local inside `runB19C`. |
| `lua tests/test_hud.lua` exit 0 | **Pass.** **729 / 0.** |

Bible §10.7 (HUD persists through a **Gora** verdict via `lastPair`) holds on the exclusive pair: persist still paints Gora CONSEQUENCE and ASSEMBLY, and a later non-Gora CONSEQUENCE no longer shows leftover Gora names. Live sanction still wins during Knighting. Law 8 holds: `health` stays nil; no scrape.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client / two-client smoke; A01 still NOT RUN | **Not a miss.** Brief asked the isolated suite and forbade `UnitHealth`. `health` stays nil. |
| OpenRite stands in for STATE / Restore | **On contract.** Brief pins OpenRite. Runtime only opens a rite from ASSEMBLY, so CloseRite + Continue is the legal verb path between the two OpenRites. Reviewer Restore probe: Knighting CONSEQUENCE hides lastPair; Gora CONSEQUENCE still paints. |
| Confession / Proclamation leftovers are not separately pinned | **On contract.** Gate is `riteType ~= "Gora"` on RITE and CONSEQUENCE; only Knighting is the named leftover hide pin. Reviewer probe: both other rites hide lastPair on RITE and CONSEQUENCE. |
| lastPair is not forgotten during the hide | **On contract.** Brief asked a paint refuse, not `forgetPersist()`. See leftover. |
| Gate W / Gate V stay OPEN; lane not signed | **On contract.** This review does not sign either. |

B21-INT glue is not required. This is a display refuse on `lastPair`; `livePair` / `pickPair` / Net are unchanged.

---

## Isolation / displayPair / persist

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Ranks + Store + Runtime + Gora + Hud. No `dofile` of Net / Snapshot / Knighting / Console. **13** nil-module pins stay under the first `if standalone then` (Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console). Wrap was not rewritten. Reviewer probe: those keys are nil at load.

**displayPair — Pass.** Live order is still `livePair()` first (`goraPair()` then B17-D Gora-RITE `runtimePair()`). The refuse sits only on the lastPair fall-through: Snapshot `RITE` or `CONSEQUENCE` and `riteType ~= "Gora"` returns nil without calling `forgetPersist()`. lastPair is not forgotten during the hide; only the paint is refused. Live Sanction during Knighting never reaches that arm. Refresh `paintHidden()` still clears name strings when the pair is nil.

**lastPair / pickPair / health — Pass.** Gora CONSEQUENCE and ASSEMBLY Continue still show. Existing Continue persist plates still send 0. `clickPlate` still calls `pickPair()` only. `health` stays nil. No `UnitHealth`. No `UnitIsDead`.

---

## Strengths

- The refuse is a two-state conjunct on the lastPair arm, not a rewrite of `livePair`, `pickPair`, favor paint, or Refresh. `goraPair()` stays first, so a live Sanction during Knighting cannot be swept up.
- lastPair is not cleared on hide. QUIET / EndEvent still `forgetPersist()`. That keeps B9-E persist for ASSEMBLY and Gora CONSEQUENCE without a second remember path.
- `runB21B()` sits after the B19-C Knighting hide on the same remembered pair. Gora CONSEQUENCE and ASSEMBLY Continue stay pinned first. Hide pins both `shown == false` and empty leftover names.
- B16-C / B17-D Gora-RITE compares stay exactly two. Sanction-during-Knighting and persist pins were left in place. Isolation wrap stays **13**. No new main-chunk locals.
- Writer-reported **729 / 0** matched the re-run. Writer-reported red count (**722 / 7**) matches the new source pin plus the six leftover-hide asserts that old lastPair-through-CONSEQUENCE would fail (CloseRite / state / `riteType` / Sanction / `health` / favor / sound / `healthReads` asserts in `runB21B()` already passed).

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Continue after a Knighting CONSEQUENCE hide still paints lastPair.** The gate is `RITE` or `CONSEQUENCE` with `riteType ~= "Gora"`. Continue clears `riteType` and returns to ASSEMBLY, so leftover Gora names return. Brief scoped the refuse to those two states and kept ASSEMBLY persist. Reviewer probe: CloseRite hide, then Continue, re-shows Chuckroast / Tendermage. `forgetPersist()` still runs only on QUIET / EndEvent / `ResetForTests`.

### Nit

1. **OpenRite stands in for inbound STATE.** Congregation production lands the same snapshot via Restore / STATE. Brief sequence cannot `OpenRite("Knighting")` directly from a Gora RITE (`"rite opens from assembly"`). CloseRite + Continue is the verb path. Reviewer Restore probe agrees with the gate.

2. **Confession / Proclamation leftovers are not separately pinned.** The compare is `riteType ~= "Gora"`; only Knighting is named. Probe: both hide lastPair on RITE and CONSEQUENCE.

3. **Source pin is a string find, not a count.** One production `RITE` or `CONSEQUENCE` conjunct is enough. A second copy would still pass.

4. **`runB21B()` does not re-pin live Sanction-during-Knighting or Gora CONSEQUENCE persist.** Those pins stay earlier / in `runB19C()` and still pass. Reviewer probe agrees.

5. **Exclusive-pair diff is not a vs-HEAD Hud delta.** Packet is the B21-B-only lastPair refuse + pins. `git diff HEAD` on the two files still includes earlier HUD batches. Report already says this.

6. **No `/reload` / two-client Knighting-CONSEQUENCE-after-Gora smoke and no full `lua tests/run.lua`.** Isolated **729 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **729 passed, 0 failed.** Isolation wrap: **13**.

`displayPair` still returns `livePair()` first. When lastPair would be used and Runtime is `RITE` or `CONSEQUENCE` with a `riteType` that is not `"Gora"`, it returns nil and does not paint. Live `GetSanctioned` still shows during Knighting. lastPair during Gora CONSEQUENCE and after Continue (ASSEMBLY) still paints. B19-C Knighting RITE hide stays. QUIET still hides. `health` stays nil. No `UnitHealth`. Isolated `lua tests/test_hud.lua` **729 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
