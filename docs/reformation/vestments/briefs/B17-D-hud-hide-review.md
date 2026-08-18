Spec PASS

# B17-D — HUD does not paint leftover fighters during a non-Gora RITE (review)

**Quality:** Approved-with-nits

**Lane:** B17-D HUD does not paint leftover fighters during a non-Gora RITE
**Brief:** `docs/reformation/vestments/briefs/B17-D-hud-hide.md`
**Writer report:** `docs/reformation/vestments/briefs/B17-D-hud-hide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B17-D-hud-hide.diff` (B17-D-only exclusive-pair packet; live `Hud.lua` also carries earlier HUD batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Hud.lua` (`goraPair` / `runtimePair` / `livePair` / `displayPair` / `pickPair` / `clickPlate` / Refresh hide), and `tests/test_hud.lua` (nested `>= 2` Gora-RITE source pin, B16-C leftover send-0 now also `shown == false`, new post-`reset()` Knighting leftover hide, kept Sanction-during-Knighting and Continue persist pins); then ran `lua tests/test_hud.lua` (**672 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.7 (HUD persists through a Gora verdict via `lastPair`; appears at sanction); B16-C send gate stays; `livePair` `runtimePair()` only while `state == "RITE"` and `riteType == "Gora"`; `goraPair()` first; no `UnitHealth`. Did not mutate `Hud.lua` or `test_hud.lua`. Did not commit. Did not edit Gora, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `livePair` still returns ungated `runtimePair()` (Knighting leftover paints) | **Pass. Verified.** After `goraPair()` miss, the runtime arm requires `snap.state == "RITE"` and `snap.riteType == "Gora"`. Pins: after `reset()` (empty `lastPair`), `OpenRite("Knighting", { candidate, fighters })` with no Sanction → `IsShown` / `shown == false`, leftover ids unpainted, names empty, `health` nil. Reviewer probe: same hide; Runtime leftover ids remain on the snapshot. |
| `goraPair()` no longer first (sanctioned pair hidden during Knighting) | **Pass.** `livePair` still returns `goraPair()` before the runtime gate. Existing pin: `Sanction` then `OpenRite("Knighting")` stays shown. Reviewer probe: sanctioned A/B still painted; isolated live pair during Knighting still sends with Sender nil. |
| `lastPair` persist after Continue broken | **Pass.** `displayPair` still falls through to `lastPair` when live is nil. B10-B / leftover-pick Continue pins stay. Reviewer probe: congregation Gora → CloseRite → Continue still shown; persist plates still send 0. |
| B16-C congregation send-0 on Knighting leftover broken | **Pass.** `pickPair` is unchanged in the packet (`RITE` + `riteType == "Gora"`). B16-C leftover `OnClick` send-0 pins stay; that Refresh now also asserts hide. Reviewer probe: leftover plates send 0; congregation Gora RITE still sends. |
| `UnitHealth` / live health | **Pass.** `Hud.lua` has no `UnitHealth`, `UnitHealthMax`, combat-log, or nameplate scrape. Hide pins `health` nil. `healthReads == 0` at the B17-D block end. Reviewer probe: source `UnitHealth` is nil; leftover / persist / Restore views stay `health` nil; `healthReads == 0`. |
| Isolated suite not exit 0 | **Pass. Verified.** 672 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Provided packet is two `diff --git` hunks: `UI/Hud.lua` and `tests/test_hud.lua`. Live `livePair` matches that slice. Sibling dirt in this workspace is other lanes (Gora, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Gora, glue; no commit | **Pass.** Named-risk check. |
| `livePair` `runtimePair()` only while `state == "RITE"` **and** `riteType == "Gora"` | **Pass.** Live nested arm is that pair. Source pin counts the exact `'state == "RITE" and snap.riteType == "Gora"'` string twice (`livePair` and `pickPair`). |
| `goraPair()` (live `GetSanctioned`) stays first | **Pass.** Named-risk check. |
| `displayPair` still falls through to `lastPair` when live is nil (Continue persist until QUIET) | **Pass.** Named-risk check. |
| After `reset()`: Knighting leftover fighters + no Sanction → `Refresh` hidden; leftover ids unpainted; `health` nil | **Pass.** New B17-D block. B16-C leftover Refresh now also asserts `shown == false` and nil fighter ids. |
| Keep: sanctioned pair still shown after `OpenRite("Knighting")` | **Pass.** Earlier pin stays. Probe agrees. |
| Keep: lastPair persist after Continue | **Pass.** Named-risk check. |
| Keep: B16-C send-0 on Knighting leftover plates | **Pass.** Named-risk check. |
| Isolation wrap stays; no `UnitHealth`; Favor still W-F; dress stays stock | **Pass.** Start wrap is still **13** nil-module pins under `if standalone then`. Packet is comments + `livePair` nest + suite pins. `pickPair` / `resolveFavor` / Refresh paint / stock iron-parchment are untouched. |
| `lua tests/test_hud.lua` exit 0 | **Pass.** **672 / 0.** |

Bible §10.7 (HUD appears at sanction; persists through a Gora verdict via `lastPair`) holds on the exclusive pair: leftover Knighting `subjects.fighters` no longer mint a live pair, and persist is still `lastPair` until QUIET. B16-C's send gate is untouched. Law 8 holds: `health` stays nil; no scrape.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client / two-client smoke; A01 still NOT RUN | **Not a miss.** Brief asked the isolated suite and forbade `UnitHealth`. `health` stays nil. |
| OpenRite stands in for STATE / Restore | **On contract.** Brief pins `StartEvent` + `OpenRite`. Same snapshot shape. Reviewer probe: `Restore` of a Knighting leftover snap also hides; Restore of a Gora RITE snap still paints. See leftover. |
| lastPair can still paint during Knighting | **On contract.** Brief: hide a live leftover `runtimePair` after `reset()`; `displayPair` still falls through to `lastPair`. Probe: prior Gora lastPair still shows during a later Knighting leftover; leftover ids are not the painted pair. |
| Confession / Proclamation leftovers are not separately pinned | **On contract.** Gate is `riteType == "Gora"`; only Knighting is the named leftover hide pin. Reviewer probe: both other leftover rites hide. |
| Gate W / Gate V stay OPEN; lane not signed | **On contract.** This review does not sign either. |

---

## Isolation / livePair / persist

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Ranks + Store + Runtime + Gora + Hud. No `dofile` of Net / Snapshot / Knighting / Console. **13** nil-module pins stay under the first `if standalone then` (Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console). Wrap was not rewritten.

**livePair — Pass.** Live order is `goraPair()` first, then a nested Snapshot check for `RITE` + `riteType == "Gora"` before `runtimePair()`, else nil. Knighting leftover after `reset()` does not paint. Congregation Gora RITE still paints. Sanctioned pair still shows during Knighting.

**lastPair / pickPair / health — Pass.** Continue persist still shows and still does not send. B16-C leftover plates still send 0. `clickPlate` still calls `pickPair()` only. `health` stays nil. No `UnitHealth`.

---

## Strengths

- The gate is one nested conjunct on the `livePair` runtime arm, not a rewrite of `displayPair`, `pickPair`, favor paint, or `PickFavor`. `goraPair()` stays the first return.
- Knighting leftover hide is pinned the way the brief named it: after `reset()` so `lastPair` is empty, two Runtime fighter ids, no Sanction, `Refresh` hidden, leftover ids and names unpainted, `health` nil.
- B16-C send-0, Sanction-during-Knighting, and Continue persist pins were left in place. The B16-C leftover Refresh now also asserts hide, so paint and send fail together on that leftover.
- Source pin is the production compare (`>= 2` Gora-RITE gates), nested. Isolation wrap stays **13**. Writer-reported **672 / 0** matched the re-run. Writer-reported red (**662 / 10**) matches the new gate pin plus leftover hide asserts that ungated `runtimePair()` would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`lastPair` can still paint during a Knighting leftover.** If a prior Gora pair was remembered, `displayPair` falls through to `lastPair` until QUIET. Brief scoped the live leftover `runtimePair` after `reset()`. Reviewer probe: leftover Knighting ids are not the painted pair; the remembered Gora pair is. Persist, not leftover paint.

### Nit

1. **OpenRite stands in for inbound STATE.** Congregation production lands the same snapshot via Restore / STATE. Reviewer Restore probe agrees with the gate (Knighting leftover hides; Gora RITE still paints). Not a suite pin.

2. **Confession / Proclamation leftovers are not separately pinned.** The compare is `riteType == "Gora"`; only Knighting is named. Probe: both hide after `reset()`.

3. **`livePair` Snapshots twice on the Gora RITE path.** The nested arm reads `Snapshot()`, then `runtimePair()` reads it again. Harmless. `pickPair` already did the same.

4. **Source pin is `>= 2`, not exactly two.** Live file has exactly two production compares. A third copy would still pass.

5. **B17-D hide and the B16-C leftover hide overlap.** Both `reset()` then Knighting leftover with no Sanction. B17-D is thicker (`IsShown`, empty names, `favor` nil). Harmless keep-pin.

6. **Exclusive-pair diff is not a vs-HEAD Hud delta.** Packet is the B17-D-only `livePair` nest + pins. `git diff HEAD` on the two files still includes earlier HUD batches. Report already says this.

7. **No `/reload` / two-client Knighting leftover smoke and no full `lua tests/run.lua`.** Isolated **672 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **672 passed, 0 failed.** Isolation wrap: **13**.

`livePair` still returns `goraPair()` first. The `runtimePair()` arm now requires `RITE` and `riteType == "Gora"`. After `reset()`, a Knighting leftover with two fighter ids and no Sanction does not paint. `lastPair` persist after Continue stays. B16-C leftover plates still send 0. `health` stays nil. No `UnitHealth`. Isolated `lua tests/test_hud.lua` **672 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
