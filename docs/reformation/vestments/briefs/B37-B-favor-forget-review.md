Spec PASS

# B37-B — Quiet forget also drops leftover congregation favor (review)

**Quality:** Approved-with-nits

**Lane:** B37-B Quiet forget also drops leftover congregation favor
**Brief:** `docs/reformation/vestments/briefs/B37-B-favor-forget.md`
**Writer report:** `docs/reformation/vestments/briefs/B37-B-favor-forget-report.md`
**Diff:** `docs/reformation/vestments/briefs/B37-B-favor-forget.diff` (B37-B-only exclusive-pair packet; live `Hud.lua` also carries earlier HUD batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Hud.lua` (`forgetPersist` ~305–309 / Quiet `Refresh` ~761–778 / `resolveFavor` ~286–299 / `SetBroadcastFavor` ~780–791 / `SetFavorTarget` ~793–799 / `paintHidden` ~509–526 / `ResetForTests` ~822–833), and `tests/test_hud.lua` (isolation wrap, existing STATE-off / class-color pins, nested `runB37B()` after `runB35A()` inside `runB19C()`); then ran `lua tests/test_hud.lua` (**854 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: License 2 / Bible §10.6 favor is per-event. `forgetPersist` also nils `broadcastFavor`. Does **not** nil `favorTarget` (dest persist). Hidden paint stays empty. No `UnitHealth`. No roman numerals. Did not mutate `Hud.lua` or `test_hud.lua`. Did not commit. Did not edit glue, Gora, Console, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Quiet forget still leaves `broadcastFavor`, so a later live pair paints leftover last-event favor | **Pass. Verified.** Live `forgetPersist` sets `broadcastFavor = nil` after `lastPair` / `lastPopeFavor`. Quiet `Refresh` still `forgetPersist()` then `paintHidden`. Nested: congregation `SetBroadcastFavor` 2/1 paints; CloseRite + EndEvent + Quiet Refresh → `view.favor` nil; later OpenRite Gora without a new `SetBroadcastFavor` stays `favor == nil`, FAVOR / bars hidden. Reviewer probe: same leftover drop. |
| Quiet `view.favor == nil` is only `paintHidden` (false proof of leftover drop) | **Pass.** `paintHidden` already writes `hiddenView()` (`favor` nil) even if `broadcastFavor` still holds. Nested later-live-pair pin is the leftover proof. Writer red already named this: Quiet hide stayed green before the helper nil. Reviewer probe: skip Quiet Refresh, then Start + OpenRite + Refresh still paints leftover 2/1 — so the nil is what closes the named hole, not hidden paint. |
| `forgetPersist` nils `favorTarget` (dest persist dies) | **Pass. Verified.** Helper body does not name `favorTarget`. `SetFavorTarget` / `clickPlate` unchanged. Nested: `SetFavorTarget("Host")` before Quiet; later plate click still sends `target == "Host"`. Reviewer probe: same dest persist. `ResetForTests` still nils dest (harness hatch, not this helper). |
| Same-event Gora CONSEQUENCE / ASSEMBLY Continue lose congregation fill; Pope `lastPopeFavor` freeze broken | **Pass.** Refuse arm still Gora-misses. Quiet / non-Gora refuse are the helper call sites. Reviewer probe: 2/1 still paints through Gora CONSEQUENCE and ASSEMBLY Continue. Pope Sanction + RecordFavor + DeclareVictor still freezes 2/1 while the event is live; Quiet then a later runtime pair has no leftover `lastPopeFavor`. |
| Existing STATE-off / class-color / B16-C / B17-D gates rewritten | **Pass.** Pins ~435–437 and ~447–464 unchanged in the packet. Nested re-pins STATE-off widgets + Warrior / Mage. Live source still has exactly two `'state == "RITE" and snap.riteType == "Gora"'` compares (`livePair` / `pickPair`). |
| `UnitHealth` / live health / roman HUD numerals | **Pass.** `Hud.lua` has no `UnitHealth`, `UnitHealthMax`, `UnitIsDead`, `COMBAT_LOG`, `NamePlate`, or roman word. `health` stays nil. Nested + existing source pin: `healthReads == 0`. Reviewer probe: same. |
| Tests not nested after `runB35A()` / new main-chunk locals / isolation wrap rewritten | **Pass.** `runB37B()` is a nested `local function` inside `runB19C()` immediately after `runB35A()`. Packet adds no main-chunk `local`. Isolation wrap stays **13** under the first `if standalone then`. |
| Isolated suite not exit 0 / exclusive breach | **Pass. Verified.** 854 passed, 0 failed. Writer-reported count matches. Packet is the two named files. Sibling dirt vs HEAD is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, Gora, Console; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| `forgetPersist` also nils `broadcastFavor` | **Pass.** Live 308. Source pin + later-live-pair behavior. |
| Does **not** nil `favorTarget` (dest persist, like Inputs dest) | **Pass.** Named-risk check. |
| Quiet `Refresh` still `forgetPersist` then `paintHidden`; hidden paint stays empty | **Pass.** Live 766–768. Nested names `""`; FAVOR / bars hidden; `health` nil. |
| Later live pair without a new `SetBroadcastFavor` has no leftover favor | **Pass.** Nested 1555–1570. Reviewer probe agrees. |
| Existing STATE-off / class-color pins stay | **Pass.** Named-risk check. |
| No `UnitHealth`. No roman numerals | **Pass.** Named-risk check. |
| Nest `runB37B()` after `runB35A()` inside `runB19C()`; isolation wrap stays; `lua tests/test_hud.lua` exit 0 | **Pass.** **854 / 0.** Isolation wrap **13**. No new main-chunk function. |

License 2 / Bible §10.6 hold on the exclusive pair: congregation favor is a per-event split. Quiet forget drops leftover `broadcastFavor`, so a later live pair does not inherit last-event 2/1. Dest persist is the whisper target, not favor memory. Law 1 holds: this is not a favor economy. Law 6 holds: Quiet Refresh hides the HUD and the favor widgets. Law 8 holds: `health` stays nil; no scrape. Law 10: no roman HUD numerals; Warrior / Mage class color stays. Congregation fill is still `SetBroadcastFavor` only. UI → Core only.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| `ResetForTests` still nils `broadcastFavor` before `forgetPersist()` | **On contract.** Double-nil is the harness hatch. Brief named the helper. |
| Non-Gora refuse also calls `forgetPersist`, so Knighting leftover lastPair now drops leftover broadcast favor | **On contract.** Brief asked for the helper itself. Reviewer probe: Knighting Refresh then a later Gora without a new `SetBroadcastFavor` has `favor == nil`. |
| Quiet path is CloseRite then EndEvent; EndEvent from RITE still refuses | **On contract.** Existing Runtime contract. The forget is the QUIET `Refresh`. |
| Dest persist pin uses a local Net stub | **On contract.** Isolation wrap still asserts `COB.Net` nil at file load; the stub is cleared before return. |
| Quiet `view.favor` nil is `paintHidden`; leftover proof is the later live pair | **On contract.** Brief asked both. The later pair is the leftover pin. |
| No client smoke; A01 still NOT RUN; `health` is nil | **Not a miss.** Brief asked the isolated suite and forbade `UnitHealth`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The leftover (Quiet hid the widgets but `broadcastFavor` still filled the next live pair) is this lane's spec. It is closed on the exclusive pair when Quiet `Refresh` actually runs.

---

## Isolation / forgetPersist / dest persist

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Ranks + Store + Runtime + Gora + Hud. No `dofile` of Net / Snapshot / Knighting / Console / FighterCard. **13** nil-module pins stay under the first `if standalone then` (Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console). Wrap was not rewritten. Reviewer probe: those keys are nil at load.

**forgetPersist — Pass.** Live body nils `lastPair`, `lastPopeFavor`, and `broadcastFavor`. It does not name `favorTarget`. Quiet `Refresh` (`not eventLive()`) still calls the helper then `paintHidden`. Congregation `resolveFavor` is still `favorView(broadcastFavor)` only. A later live pair without a new fill is STATE-off.

**Dest persist / health — Pass.** `favorTarget` survives Quiet forget. Later plate click still uses `"Host"`. `clickPlate` still calls `pickPair()` only. `health` stays nil. No `UnitHealth`. Same-event Gora CONSEQUENCE / ASSEMBLY Continue still keep congregation broadcast (reviewer probe).

---

## Strengths

- The delta is the brief: one assignment on the existing Quiet helper. `Refresh`, `resolveFavor`, `SetBroadcastFavor`, `SetFavorTarget`, `paintHidden`, and the Gora-RITE gates were left alone.
- Later-live-pair + dest persist sit next to the source pin, so a comment-only `broadcastFavor = nil` or a dest wipe would fail the behavioral half.
- Same fixture as B35-A: still in a live Gora RITE when the 2/1 fill is applied, then a real CloseRite + EndEvent Quiet path. No `reset()` between fill and forget, so `ResetForTests` cannot fake the leftover drop.
- `runB37B()` sits after `runB35A()` inside `runB19C()`. Isolation wrap stays **13**. No new main-chunk locals. Writer-reported **854 / 0** matched the re-run. Writer-reported red (**849 / 5**) matches a missing helper nil plus leftover 2/1 on the later pair (Quiet hide already green via `paintHidden`).

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **Skip Quiet `Refresh` and leftover `broadcastFavor` still fills the next live pair.** Forget runs only when `Refresh` sees `QUIET`. Reviewer probe: EndEvent with no intervening `Hud:Refresh`, then Start + OpenRite + Refresh still paints leftover 2/1. Production `afterEndEvent` / inbound STATE already `Hud:Refresh` (glue is not this exclusive). Brief scoped the helper + Quiet Refresh. Do not expand this exclusive pair. B37-INT says no glue unless a review Important requires it — this leftover does not require INT glue.

### Nit

1. **Quiet `view.favor == nil` is `paintHidden`, not leftover proof.** The later live pair is the leftover pin. Correctly paired.

2. **Source pin is a string find on the `forgetPersist` body.** `broadcastFavor = nil` matches. A comment with the same characters would still pass that pin. Behavioral later-pair would still fail.

3. **Non-Gora refuse also drops leftover broadcast favor.** On contract with “the helper itself.” Not a Quiet-only wipe.

4. **Dest persist pin uses a local Net stub and sets `SetLocalCharacterId` after Quiet.** Brief named `favorTarget`, not `localCharacterId`. Isolation wrap still has `COB.Net` nil at load.

5. **`ResetForTests` still nils `broadcastFavor` before `forgetPersist()` and still nils `favorTarget`.** Harness hatch. Not this helper.

6. **OpenRite stands in for inbound STATE.** Congregation production lands the same snapshot via Restore / STATE. Reviewer leftover probe agrees with the helper: Quiet Refresh drops the fill; skip-Refresh does not.

7. **Exclusive-pair diff is not a vs-HEAD Hud delta.** Packet is the B37-B-only header comment + helper nil + nested pins. `git diff HEAD` on the two files still includes earlier HUD batches. Report already says this.

8. **No `/reload` / two-client smoke and no full `lua tests/run.lua`.** Isolated **854 / 0** was re-run here. Live congregation HUD after End Event then a new Gora (no leftover favor bar; whisper dest still set) is unproven on Anniversary.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **854 passed, 0 failed.** Isolation wrap: **13**. Writer ran `lua tests/test_hud.lua` (report: **854 / 0**). Reviewer re-ran: **854 / 0**, exit 0, Lua 5.1.5.

`forgetPersist` nils `lastPair`, `lastPopeFavor`, and `broadcastFavor`. It does not nil `favorTarget`. Quiet `Refresh` still forgets then `paintHidden`. A later live pair without a new `SetBroadcastFavor` has no leftover favor. STATE-off widgets stay hidden. Warrior / Mage class color stays. `health` stays nil. No `UnitHealth`. No roman numerals. `runB37B()` is nested inside `runB19C()` after `runB35A()`. Isolated `lua tests/test_hud.lua` **854 passed, 0 failed**, exit 0.

Leftovers: skip Quiet Refresh still lets leftover 2/1 paint the next live pair (glue already Refreshes on End / STATE; do not expand exclusive); Knighting refuse also drops broadcast favor (on contract); Quiet `favor` nil is `paintHidden`; no client smoke; full harness not run.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.
