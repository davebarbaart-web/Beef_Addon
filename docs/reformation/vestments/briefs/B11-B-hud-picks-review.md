Spec PASS

# B11-B — HUD leftover plate clicks (review)

**Quality:** Approved-with-nits

**Lane:** B11-B HUD leftover plate clicks
**Brief:** `docs/reformation/vestments/briefs/B11-B-hud-picks.md`
**Writer report:** `docs/reformation/vestments/briefs/B11-B-hud-picks-report.md`
**Diff:** `docs/reformation/vestments/briefs/B11-B-hud-picks.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Hud.lua` (`goraPair` / `runtimePair` / `livePair` / `displayPair` / `pickPair` / `clickPlate` / `Refresh` / `PickFavor`), and live `tests/test_hud.lua`; then ran `lua tests/test_hud.lua` (**624 passed, 0 failed**, exit 0, Lua 5.1.5). Law cited: Bible §10.7 (HUD persists through the verdict; leftover favor picks must close), §10.6 (favor is pick-a-side only), §13.1 (congregation input devices; they never Sanction). Did not mutate Hud or the suite. Did not commit. Did not edit Gora, FighterCard, Snapshot, glue, Console, TOC, bootstrap, or `run.lua`.

This review does not sign the lane.

---

## Named gates

| Gate | Verdict |
|---|---|
| Plate `OnClick` never uses `lastPair` | **Pass.** `clickPlate` calls `pickPair()` only. `pickPair` reads `goraPair()` then (non-Pope) `Runtime` state + `runtimePair()`. `lastPair` is written/read only in `rememberPair` / `displayPair` / `forgetPersist`. After `Continue` (empty Gora + empty Runtime, event live) the HUD still paints from `lastPair` and both plates send 0. |
| Pope after `DeclareVictor` does not `SendFavor` | **Pass.** Local Pope (`Sender:IsRegisteredPope`) with leftover Runtime subjects still shown → `pickPair` returns nil once `GetSanctioned()` is nil. Both plates send 0. Isolated live-`GetSanctioned` path still sends with Sender nil (gora wins before the Pope gate). |
| Congregation CONSEQUENCE / post-Continue persist do not `SendFavor` | **Pass.** After `CloseRite`, state is `CONSEQUENCE` and subjects may still name two ids; `pickPair` requires `state == "RITE"`, so plates send 0 while the HUD may still show. After `Continue`, fighters are nil and `lastPair` persist still shows; plates send 0. QUIET plate is also a no-op. |
| Display persist stays (HUD does not hide after `DeclareVictor` while the event is live) | **Pass.** `Refresh` still paints `displayPair()` while `eventLive()`. B9-E / B10-B persist pins stay flipped to shown. B11-B re-pins shown + names + `health` nil + no `view.verdict` after `DeclareVictor`, after Pope leftover subjects, in CONSEQUENCE, and after Continue. |
| No `UnitHealth` / live health | **Pass.** `Hud.lua` has no `UnitHealth`, `UnitHealthMax`, combat-log, or nameplate scrape. `hiddenView` and `paintShown` set `health = nil`. Leftover / persist / Quiet pins re-assert nil. `healthReads == 0` at the leftover-lane end. Mute rails stay textures. `countStatusBars` stays 2. |
| `PickFavor` helper errors unchanged | **Pass.** Missing target → `nil, "no target"`; missing character → `nil, "no character"`. Helper still sends when both are present (gate is the plate, not the helper). |
| Isolated green | **Pass.** Reviewer ran `lua tests/test_hud.lua`: **624 passed, 0 failed**, exit 0. Isolation nil-module block (**13** pins) and the standalone summary stay under `if standalone then`. |
| Exclusive files only | **Pass.** Provided packet is two `diff --git` hunks: `UI/Hud.lua` and `tests/test_hud.lua`. Gora / FighterCard / Snapshot / glue are not in the packet. Live `pickPair` / leftover suite match the packet hunks that matter for this lane. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Gora, FighterCard, glue, Snapshot; no commit | **Pass.** Named-gate check. |
| `clickPlate` pick pair: Pope → `GetSanctioned()` only; congregation → Runtime two ids; never `lastPair` | **Pass.** Implementation is slightly tighter than the brief's three-line snippet: congregation also requires `state == "RITE"`. That is what tests 3–4 demand (CONSEQUENCE leftover subjects and Continue `lastPair` persist must not send). Isolated live `GetSanctioned` still sends with Sender nil. |
| Display persist (B9-E / B10-B `lastPair`) stays | **Pass.** Named-gate check. `displayPair` / `rememberPair` / Refresh paint path unchanged in role. |
| Favor W-F paint intact | **Pass.** Pope still fills from `Gora:GetFavorSplit()` only while `goraPair()` is live; leftover Runtime subjects do not thaw the freeze. Congregation still follows `SetBroadcastFavor` only. STATE-off still omits the FAVOR label and both halves. |
| Tests: live Sanction still sends; `DeclareVictor` persist shown → no send; OpenRite no-Sanction Sender-nil → send; `CloseRite` → no send; Continue `lastPair` → no send, HUD shown; health nil; isolation wrap stays | **Pass.** New B11-B block covers all five plus Pope leftover subjects, QUIET no-op, and the existing `PickFavor` error strings. |
| `lua tests/test_hud.lua` exit 0; **POLISH:CANDIDATE** at most | **Pass. Verified.** 624 / 0. Writer claimed that polish ceiling and no more. |

Bible §10.7 (persist through the verdict; leftover favor picks close), §10.6 (favor is pick-a-side; no economy), §13.1 (congregation never Sanctions; they pick only while a live Runtime pair exists), Law 6 (Quiet hides Event chrome), Law 4 (no invented verdict copy), and Law 8 (no health hack) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; **POLISH:CANDIDATE** only | **Not a spec miss.** Brief asked isolated green. See Minor. |
| OpenRite stands in for STATE / Restore | **Matches the brief.** Brief pins `StartEvent` + `OpenRite`. See Minor. |
| Congregation leftover RITE after a local ruling still sends (Sender nil + two Runtime fighters) | **Accepted leftover.** Congregation never `DeclareVictor`s locally. Leftover picks close when inbound STATE leaves `RITE`. Not a must-fix. |
| A01 still NOT RUN; `health` nil; no `UnitHealth` | **Not a miss.** Brief forbade opening it. |
| FighterCard / Snapshot / glue were not edited | **Not a miss.** Exclusive HUD-only. |
| Integrator still lists the files in the TOC and `run.lua` | **Not a miss.** Brief forbade those edits. Already listed. |

---

## Strengths

- The plate gate is a new `pickPair`, not a mutation of `displayPair`. Paint still remembers `lastPair`; clicks never read it.
- Fail-closed leftovers: Pope with leftover Runtime subjects cannot pick (`GetSanctioned()` only). Congregation leftover subjects cannot pick once the machine leaves `RITE`. Continue persist still shows and still does not send.
- Isolated Sanctioned plate-click sends stay (gora pair wins before the Pope / RITE gates). Existing missing-target / missing-character `PickFavor` strings stay.
- Isolation stayed gated (13). Writer-reported 624 / 0 matches the reviewer run.

---

## Issues

### Critical

None.

### Important (must-fix)

None.

### Minor

1. **Congregation leftover RITE after a remote ruling still sends.** Sender-nil + `state == "RITE"` + two Runtime fighters still `SendFavor`. Production congregation never `DeclareVictor`s; leftover closes when STATE leaves `RITE`. Writer disclosed it. Accepted leftover; not a must-fix.

2. **First leftover pin is weaker than it looks.** Sanction → `DeclareVictor` with no `OpenRite` leaves Runtime in `ASSEMBLY` and `livePair()` nil. That path would also no-op if `clickPlate` still called `livePair()`. The pins that actually distinguish `pickPair` from the old `livePair()` gate are Pope leftover subjects (still RITE, `livePair()` truthy) and CONSEQUENCE leftover subjects (`runtimePair()` still truthy, state not RITE). Those exist and are green.

3. **OpenRite stands in for inbound STATE.** Congregation production path is Restore / STATE then `Hud:Refresh`. Same snapshot shape. Brief did not ask for a Restore pin.

4. **Packet diff is a long exclusive-pair dump, not a tight B11-B delta.** Live `pickPair` / leftover suite match the hunks that matter. Dress / persist / W-F / defenses in the same files are prior lanes, not an exclusive-file breach.

5. **`PickFavor` still sends if called directly after a ruling.** Brief said the helper stays a send helper. Gate is `OnClick`. Correct.

6. **Cowardice / Void leftover clicks are implemented, not pinned.** `clearLive` still nils `GetSanctioned()`. Only `DeclareVictor` is in the leftover block.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated suite was re-run here. Do not treat this as **POLISH:PASS**.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

The exclusive pair does what the brief asked: plate `OnClick` never uses `lastPair`; Pope leftover after `DeclareVictor` does not `SendFavor`; congregation CONSEQUENCE leftover and post-Continue `lastPair` persist do not `SendFavor`; the HUD still paints through the verdict while the event is live; `health` stays nil; no `UnitHealth`; `PickFavor` error strings stay; isolated suite green (624 / 0). Named must-fix gates are clean. The accepted leftover is congregation leftover RITE after a remote ruling (they never `DeclareVictor` locally). Nits are that leftover, a weak first persist-click pin, OpenRite-for-Restore, a bloated exclusive-pair diff, and unsmoked theater — not trust-breakers.

Must-fix list: **none.**

Do not sign. Do not claim **POLISH:PASS**. Do not claim V1 / MVP complete.
