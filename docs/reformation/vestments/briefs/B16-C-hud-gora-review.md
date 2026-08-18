Spec PASS

# B16-C — Congregation picks only during Gora RITE (review)

**Quality:** Approved-with-nits

**Lane:** B16-C Congregation picks only during Gora RITE
**Brief:** `docs/reformation/vestments/briefs/B16-C-hud-gora.md`
**Writer report:** `docs/reformation/vestments/briefs/B16-C-hud-gora-report.md`
**Diff:** `docs/reformation/vestments/briefs/B16-C-hud-gora.diff` (B16-C-only exclusive-pair packet)
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Hud.lua` (`goraPair` / `runtimePair` / `livePair` / `displayPair` / `pickPair` / `clickPlate` / `PickFavor`), and `tests/test_hud.lua` (source `riteType == "Gora"` pin, B11-B leftover-ruling Pope pins, congregation `OpenRite("Gora")` send, new Knighting leftover send-0); then ran `lua tests/test_hud.lua` (**646 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.6 (favor is pick-a-side only); §10.7 (HUD persists through the verdict; favor picks close); §13.1 (congregation input devices; they never Sanction). Congregation `pickPair` needs `state == "RITE"` and `riteType == "Gora"`; Pope is live `GetSanctioned()` only; no `lastPair` clicks; no `UnitHealth`. Did not mutate `Hud.lua` or `test_hud.lua`. Did not commit. Did not edit Gora, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Congregation Knighting RITE + leftover fighters still `SendFavor` | **Pass. Verified.** Pin: `OpenRite("Knighting", { candidate, fighters })`, Sender nil, `SetFavorTarget` + local id; both plates `OnClick` → `#knightSent == 0`. Reviewer probe: same path sends 0; `health` nil; state stays `RITE` / `Knighting`. |
| Existing congregation `OpenRite("Gora")` pick pins go red | **Pass.** Same B11-B block still sends on both plates and now asserts `riteType == "Gora"`. Reviewer probe: Gora RITE still sends on both plates. |
| Pope leftover / live `GetSanctioned` path changed | **Pass.** `pickPair` still returns `goraPair()` first; `isLocalPope()` then nils. B11-B leftover-ruling Pope pins stay. Reviewer probe: Pope leftover after `DeclareVictor` sends 0; isolated live `GetSanctioned` during Knighting still sends with Sender nil. |
| Plate `OnClick` uses `lastPair` | **Pass.** `clickPlate` calls `pickPair()` only. `lastPair` is still write/read in `rememberPair` / `displayPair` / `forgetPersist`. After `Continue`, persist still paints and both plates send 0 (B11-B pin). Reviewer probe: same; `pickPair` body has no `lastPair`. |
| `UnitHealth` / live health | **Pass.** `Hud.lua` has no `UnitHealth`, `UnitHealthMax`, combat-log, or nameplate scrape. Knighting leftover view pins `health` nil. `healthReads == 0` at the B16-C block end. Reviewer probe: source `UnitHealth` is nil; leftover view `health` is nil. |
| Isolated suite not exit 0 | **Pass. Verified.** 646 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Provided packet is two `diff --git` hunks: `UI/Hud.lua` and `tests/test_hud.lua`. Live `pickPair` matches that slice. Sibling dirt in this workspace is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Gora, glue; no commit | **Pass.** Named-risk check. |
| Congregation `pickPair`: `state == "RITE"` **and** `riteType == "Gora"` before `runtimePair()` | **Pass.** Live gate is that pair. Source pin is the exact `'riteType == "Gora"'` string inside `pickPair`. |
| Pope path unchanged: live `GetSanctioned()` only | **Pass.** Named-risk check. Isolated live pair still sends with Sender nil. |
| No `lastPair` clicks (B11-B) | **Pass.** Named-risk check. Continue persist / CONSEQUENCE / QUIET send-0 pins stay. |
| Existing congregation Gora RITE pins stay green | **Pass.** Named-risk check. |
| Knighting RITE + two Runtime fighters + target + local id: `OnClick` sends 0 | **Pass.** New B16-C block. |
| Keep B11-B leftover-ruling Pope pins | **Pass.** Pope leftover subjects after `DeclareVictor` still send 0. |
| Isolation wrap stays; `health` nil | **Pass.** Start wrap is still **13** nil-module pins under `if standalone then`. Knighting leftover view and leftover-lane end re-pin `health` nil / `healthReads == 0`. |
| No `UnitHealth`; Favor still W-F; dress stays stock | **Pass.** Diff is comments + `pickPair` + suite pins. `resolveFavor` / `displayPair` / Refresh paint / `PickFavor` / stock iron-parchment are untouched. |
| `lua tests/test_hud.lua` exit 0 | **Pass.** **646 / 0.** |

Bible §10.6 (favor is pick-a-side; no economy), §10.7 (persist through the verdict; leftover favor picks close), §13.1 (congregation never Sanctions; they pick only while a live Gora RITE pair exists), and Law 8 (no health hack) hold on the exclusive pair. B11-B's leftover (any RITE + leftover fighters still sent) is closed for Knighting on this suite.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client / two-client smoke; A01 still NOT RUN | **Not a miss.** Brief asked the isolated suite and forbade opening A01. `health` stays nil. |
| OpenRite stands in for STATE / Restore | **On contract.** Brief pins `StartEvent` + `OpenRite`. Same snapshot shape. Reviewer probe: `Restore` of a Knighting leftover snap also sends 0; Restore of a Gora RITE snap still sends. See leftover. |
| Display may still paint leftover fighters during Knighting | **On contract.** Brief scoped plate send. `livePair` / `displayPair` stay ungated. See leftover. |
| Confession / Proclamation leftovers are not separately pinned | **On contract.** Gate is `riteType == "Gora"`; only Knighting is the named pin. Reviewer probe: both other leftover rites send 0. |
| Gate W / Gate V stay OPEN; lane not signed | **On contract.** This review does not sign either. |

---

## Isolation / pickPair / Pope

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Ranks + Runtime + Store + Gora + Hud. No `dofile` of Net / Snapshot / Knighting / Console. **13** nil-module pins stay under the first `if standalone then` (Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console). Wrap was not rewritten.

**pickPair — Pass.** Live order is `goraPair()` first, then `isLocalPope()` nil, then Snapshot `RITE` + `riteType == "Gora"` before `runtimePair()`. Congregation Knighting leftover does not send. Congregation Gora RITE still sends. `clickPlate` never reads `lastPair`.

**Pope / lastPair / health — Pass.** Pope leftover Runtime subjects after a ruling still do not send. Isolated live `GetSanctioned` still sends with Sender nil. Continue `lastPair` persist still shows and still does not send. `health` stays nil. No `UnitHealth`.

---

## Strengths

- The gate is one extra conjunct on congregation `pickPair`, not a rewrite of `displayPair`, favor paint, or `PickFavor`. B11-B leftover-ruling Pope pins and Gora RITE send pins stay on the real plates.
- Knighting leftover is pinned as the brief named it: two Runtime fighter ids, no Sanction, Sender nil, target + local id, both `OnClick` send 0.
- Source pin is the production compare, not a comment. Isolation wrap stays **13**. Writer-reported **646 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Display still paints leftover fighters during a non-Gora RITE.** `livePair` / `displayPair` are unchanged, so a Knighting (or Confession / Proclamation) that still names two fighter ids keeps the HUD shown. Plates still have `OnClick`; they just do not `SendFavor`. Brief scoped the send gate. Paint leftover is Event Mode chrome, not a miss.

### Minor

1. **OpenRite stands in for inbound STATE.** Congregation production lands the same snapshot via Restore / STATE. The suite pin is `StartEvent` + `OpenRite`. Reviewer Restore probe agrees with the gate; it is not a suite pin.

2. **Knighting send-0 pin is thinner than the Gora send pin.** It checks `health` / `verdict` / send count. It does not re-pin `IsShown` or leftover fighter ids on the view. Probe: shown, `{1,2}`, `health` nil.

3. **Confession / Proclamation leftovers are not separately pinned.** The compare is `riteType == "Gora"`; only Knighting is named. Probe: both send 0.

4. **No `/reload` / two-client Knighting leftover smoke and no full `lua tests/run.lua`.** Isolated **646 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

Congregation `pickPair` now requires `RITE` and `riteType == "Gora"` before `runtimePair()`. Knighting leftover fighters do not `SendFavor`. Existing congregation Gora RITE pins stay green. Pope path is still live `GetSanctioned()` only. `lastPair` is still display persist, not a click pair. `health` stays nil. No `UnitHealth`. Isolated `lua tests/test_hud.lua` **646 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
