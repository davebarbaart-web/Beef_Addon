Spec PASS

# B19-C — lastPair does not paint through a non-Gora RITE (review)

**Quality:** Approved-with-nits

**Lane:** B19-C lastPair does not paint through a non-Gora RITE
**Brief:** `docs/reformation/vestments/briefs/B19-C-hud-rite.md`
**Writer report:** `docs/reformation/vestments/briefs/B19-C-hud-rite-report.md`
**Diff:** `docs/reformation/vestments/briefs/B19-C-hud-rite.diff` (B19-C-only exclusive-pair packet; live `Hud.lua` also carries earlier HUD batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Hud.lua` (`goraPair` / `livePair` / `displayPair` lastPair arm / `pickPair` / Refresh hide), and `tests/test_hud.lua` (source `riteType ~= "Gora"` pin, existing Sanction-during-Knighting and Continue persist pins, nested `runB19C()` Gora remember → CONSEQUENCE persist → ASSEMBLY persist → Knighting hide); then ran `lua tests/test_hud.lua` (**714 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.7 (HUD persists through a Gora verdict); B9-E lastPair until QUIET still applies to ASSEMBLY / CONSEQUENCE; B16-C `pickPair` and B17-D `livePair` Gora-RITE gates stay; live `GetSanctioned` still shows during Knighting; no `UnitHealth`. Did not mutate `Hud.lua` or `test_hud.lua`. Did not commit. Did not edit Gora, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `lastPair` still paints during a later Knighting RITE (B17-D leftover) | **Pass. Verified.** `displayPair` lastPair arm: `snap.state == "RITE"` and `snap.riteType ~= "Gora"` returns nil. `runB19C()`: OpenRite Gora → Refresh (remember) → CloseRite / Continue → OpenRite Knighting, no Sanction → `shown == false`, leftover Gora names empty, `health` nil. Reviewer probe: same hide; leftover Runtime fighter ids on a Knighting leftover stay on the snapshot and are not painted. |
| Live `GetSanctioned` hidden during Knighting | **Pass.** `livePair` still returns `goraPair()` first; the new gate runs only when lastPair would be used. Existing pin: Sanction then `OpenRite("Knighting")` stays shown. Reviewer probe: sanctioned A/B still painted; leftover Knighting fighter ids 99 / 100 are not the painted pair. |
| lastPair after Continue (ASSEMBLY, no riteType) broken | **Pass.** Gate requires `state == "RITE"`. Existing B10-B / leftover-pick Continue pins stay. `runB19C()` re-pins ASSEMBLY persist before the Knighting hide. Reviewer probe: Gora → CloseRite → Continue still shown. |
| lastPair during Gora CONSEQUENCE broken | **Pass.** CloseRite leaves `riteType == "Gora"` and `state == "CONSEQUENCE"`, so the RITE compare misses. `runB19C()` pins persist + names. Reviewer probe: same. |
| B16-C `pickPair` / B17-D `livePair` Gora-RITE gates rewritten | **Pass.** Packet does not touch those arms. Live source still has exactly two `'state == "RITE" and snap.riteType == "Gora"'` compares. Continue persist plates still send 0. |
| `UnitHealth` / live health | **Pass.** `Hud.lua` has no `UnitHealth`, `UnitHealthMax`, combat-log, or nameplate scrape. Hide / persist pins `health` nil. `healthReads == 0` at the B19-C block end. Reviewer probe: source `UnitHealth` is nil; hide / persist / Restore views stay `health` nil; `healthReads == 0`. |
| Isolated suite not exit 0 | **Pass. Verified.** 714 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Provided packet is two `diff --git` hunks: `UI/Hud.lua` and `tests/test_hud.lua`. Live `displayPair` lastPair arm matches that slice. Sibling dirt in this workspace is other lanes (Gora, Console, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Gora, glue; no commit; no `UnitHealth` | **Pass.** Named-risk check. |
| `displayPair`: if lastPair would be used and snapshot is `RITE` with `riteType` not `"Gora"`, return nil (do not paint) | **Pass.** Live arm is that conjunct. Source pin finds `riteType ~= "Gora"`. `runB19C()` hide + empty names. |
| Live `GetSanctioned` still shows during Knighting (existing pin) | **Pass.** Named-risk check. |
| lastPair after Continue (ASSEMBLY, no riteType) still paints | **Pass.** Named-risk check. |
| lastPair during Gora CONSEQUENCE still paints | **Pass.** Named-risk check. |
| QUIET still hides | **Pass.** Existing Quiet pins stay. Reviewer probe: EndEvent forgets lastPair; a new ASSEMBLY does not re-paint. |
| After `reset()`: OpenRite Gora → Refresh (remember lastPair) → later Knighting, no Sanction → `shown == false` (or not those leftover Gora names) | **Pass.** Nested `runB19C()` uses CloseRite + Continue between the two OpenRites (Runtime only opens a rite from ASSEMBLY). Pins both `shown == false` and empty name strings. |
| B16-C pickPair and B17-D livePair Gora-RITE gates stay; Favor W-F intact; dress stays stock | **Pass.** Packet is header comments + lastPair refuse + suite pins. `pickPair` / `livePair` / `resolveFavor` / stock iron-parchment are untouched. Isolation wrap stays **13**. |
| Isolation wrap stays; `health` stays nil | **Pass.** Named-risk check. |
| `lua tests/test_hud.lua` exit 0 | **Pass.** **714 / 0.** |

Bible §10.7 (HUD persists through a Gora verdict via `lastPair`) holds on the exclusive pair: persist still paints ASSEMBLY and Gora CONSEQUENCE, and a later non-Gora RITE no longer shows leftover Gora names. Live sanction still wins during Knighting. Law 8 holds: `health` stays nil; no scrape.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client / two-client smoke; A01 still NOT RUN | **Not a miss.** Brief asked the isolated suite and forbade `UnitHealth`. `health` stays nil. |
| OpenRite stands in for STATE / Restore | **On contract.** Brief pins OpenRite. Runtime only opens a rite from ASSEMBLY, so CloseRite + Continue is the legal verb path. Reviewer Restore probe: Knighting RITE hides lastPair; Gora CONSEQUENCE still paints. |
| Confession / Proclamation leftovers are not separately pinned | **On contract.** Gate is `riteType ~= "Gora"`; only Knighting is the named leftover hide pin. Reviewer probe: both other rites hide lastPair. |
| Knighting CONSEQUENCE still paints lastPair | **On contract.** Brief gates `RITE` + non-Gora only; B9-E persist still applies to CONSEQUENCE. See leftover. |
| Gate W / Gate V stay OPEN; lane not signed | **On contract.** This review does not sign either. |

B19-INT glue is not required. This is a display refuse on `lastPair`; `livePair` / `pickPair` / Net are unchanged.

---

## Isolation / displayPair / persist

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Ranks + Store + Runtime + Gora + Hud. No `dofile` of Net / Snapshot / Knighting / Console. **13** nil-module pins stay under the first `if standalone then` (Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console). Wrap was not rewritten.

**displayPair — Pass.** Live order is still `livePair()` first (`goraPair()` then B17-D Gora-RITE `runtimePair()`). The new refuse sits only on the lastPair fall-through: Snapshot `RITE` and `riteType ~= "Gora"` returns nil without calling `forgetPersist()`. lastPair is not forgotten during the hide; only the paint is refused. Live Sanction during Knighting never reaches that arm.

**lastPair / pickPair / health — Pass.** Gora CONSEQUENCE and ASSEMBLY Continue still show. Existing Continue persist plates still send 0. `clickPlate` still calls `pickPair()` only. `health` stays nil. No `UnitHealth`.

---

## Strengths

- The refuse is six lines on the lastPair arm, not a rewrite of `livePair`, `pickPair`, favor paint, or Refresh. `goraPair()` stays first, so a live Sanction during Knighting cannot be swept up.
- lastPair is not cleared on hide. QUIET / EndEvent still `forgetPersist()`. That keeps B9-E persist for ASSEMBLY and Gora CONSEQUENCE without a second remember path.
- `runB19C()` pins the keep-paths (Gora CONSEQUENCE, ASSEMBLY Continue) on the same remembered pair before the Knighting hide, and pins both `shown == false` and empty leftover names.
- B16-C / B17-D Gora-RITE compares stay exactly two. Sanction-during-Knighting and Continue persist pins were left in place. Isolation wrap stays **13**.
- Writer-reported **714 / 0** matched the re-run. Writer-reported red (**707 / 7**) matches the new source pin plus the six leftover-hide asserts that old lastPair-through-RITE would fail (persist asserts in `runB19C()` already passed).

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Knighting CONSEQUENCE still paints lastPair.** CloseRite after the hide leaves `state == "CONSEQUENCE"` and `riteType == "Knighting"`. The gate is RITE-only, so leftover Gora names return until QUIET or a later non-Gora RITE. Brief scoped `RITE` + non-Gora; B9-E persist still applies to CONSEQUENCE. Reviewer probe: CloseRite after the hide re-shows Chuckroast / Tendermage; Continue after that still shows.

### Nit

1. **OpenRite stands in for inbound STATE.** Congregation production lands the same snapshot via Restore / STATE. Brief sequence cannot `OpenRite("Knighting")` directly from a Gora RITE (`"rite opens from assembly"`). CloseRite + Continue is the verb path. Reviewer Restore probe agrees with the gate.

2. **Confession / Proclamation leftovers are not separately pinned.** The compare is `riteType ~= "Gora"`; only Knighting is named. Probe: both hide lastPair.

3. **Source pin is a string find, not a count.** One production `riteType ~= "Gora"` is enough. A second copy would still pass.

4. **`runB19C()` does not re-pin live Sanction-during-Knighting.** The existing earlier pin stays and still passes. Reviewer probe agrees.

5. **Exclusive-pair diff is not a vs-HEAD Hud delta.** Packet is the B19-C-only lastPair refuse + pins. `git diff HEAD` on the two files still includes earlier HUD batches. Report already says this.

6. **No `/reload` / two-client Knighting-after-Gora smoke and no full `lua tests/run.lua`.** Isolated **714 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **714 passed, 0 failed.** Isolation wrap: **13**.

`displayPair` still returns `livePair()` first. When lastPair would be used and Runtime is `RITE` with a `riteType` that is not `"Gora"`, it returns nil and does not paint. Live `GetSanctioned` still shows during Knighting. lastPair after Continue (ASSEMBLY) and during Gora CONSEQUENCE still paints. QUIET still hides. `health` stays nil. No `UnitHealth`. Isolated `lua tests/test_hud.lua` **714 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
