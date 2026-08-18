Spec PASS

# B10-B — HUD reads Runtime subjects (review)

**Quality:** Approved-with-nits

**Lane:** B10-B HUD reads Runtime subjects (congregation)
**Brief:** `docs/reformation/vestments/briefs/B10-B-hud-subjects.md`
**Writer report:** `docs/reformation/vestments/briefs/B10-B-hud-subjects-report.md`
**Diff:** `docs/reformation/vestments/briefs/B10-B-hud-subjects.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Hud.lua`, `tests/test_hud.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, `UI/Hud.lua` `goraPair` / `runtimePair` / `livePair` / `displayPair` / `Refresh`, and `tests/test_hud.lua`; then ran `lua tests/test_hud.lua` (**539 passed, 0 failed**, exit 0, Lua 5.1.5). Law cited: Bible §10.7 (HUD during a sanctioned fight; persist through the verdict; defined no-live-health fallback), §13.1 (congregation display terminals; star pair on STATE `subjects.fighters`), Law 6 / §19.1 (Quiet hides Event chrome), W-F favor (Pope from `GetFavorSplit` while a Gora pair is live; congregation `SetBroadcastFavor` only). Did not mutate Hud or the suite. Did not commit. Did not edit Gora, FighterCard, Console, glue, TOC, bootstrap, or `run.lua`.

This review does not sign the lane.

---

## Named gates

| Gate | Verdict |
|---|---|
| Congregation pair from Runtime `subjects.fighters` | **Pass.** `livePair` is `goraPair()` (`GetSanctioned()` with both ids) else `runtimePair()`. Runtime path reads `Snapshot().subjects.fighters[1]` / `[2]` and returns `{ fighterA, fighterB }` only when both are `number`. No `Gora:Sanction` in `Hud.lua`. Flipped pin: `StartEvent` + `OpenRite("Gora", { fighters })` with `GetSanctioned() == nil` → shown, those ids, Store names. One id does not invent a pair. |
| Persist `lastPair` | **Pass.** `displayPair` still `rememberPair`s any live pair. After `CloseRite` + `Continue` (Runtime fighters nil, Gora still nil, event live) the congregation HUD stays shown with the same ids (B9-E). Existing `DeclareVictor` persist pins stay. A new live pair replaces `lastPair`. `forgetPersist` on QUIET and `ResetForTests`. |
| Hide QUIET | **Pass.** `Refresh` calls `forgetPersist` + `paintHidden` when `eventLive()` is false (`Runtime` state `== "QUIET"` or missing). Subjects block: `EndEvent` → hidden, no fighter A, `health` nil. Earlier persist block still pins ASSEMBLY-after-QUIET does not revive. Event-without-a-pair still hides. |
| No `UnitHealth`; `health` stays nil | **Pass.** `Hud.lua` has no `UnitHealth`, `UnitHealthMax`, combat-log, or nameplate scrape. `hiddenView` and `paintShown` both set `health = nil`. Subjects / persist / Quiet pins re-assert nil. Suite source greps stay. `healthReads == 0` at the subjects-lane end and (via later `reset`) the suite end. Mute rails stay textures. `countStatusBars` stays 2. |
| Favor W-F intact | **Pass.** Congregation subjects still follow `SetBroadcastFavor` only (nil without broadcast; `{2,1}` still 66/34; clearing broadcast hides favor and does **not** hide the card). Pope live path still reads `Gora:GetFavorSplit()` (including zeros) **while `goraPair()` is live**. After the Gora pair clears, Pope returns `lastPopeFavor` even when Runtime leftover still names two fighters — freeze is gora-keyed, so leftover subjects do not thaw `{0,0}`. `PickFavor` / plate `OnClick` still require `livePair()` (`goraPair` or Runtime two-ids). STATE-off still omits the FAVOR label and both halves. `Hud.Favor` / `Hud.SendFavor` stay nil. |
| Isolated green | **Pass.** Reviewer ran `lua tests/test_hud.lua`: **539 passed, 0 failed**, exit 0. Isolation nil-module block (**13** pins) and the standalone summary stay under `if standalone then`. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Gora, glue, FighterCard; no commit | **Pass.** Provided packet is two `diff --git` hunks: `UI/Hud.lua` and `tests/test_hud.lua`. Gora / glue / FighterCard are not in the packet. Live exclusive pair matches the packet (header + `goraPair` / `runtimePair` split + Pope favor keyed off `goraPair` + subjects suite). |
| `GetSanctioned()` wins; else two Runtime fighter ids; do not invent a pair | **Pass.** Named-gate check. One-id OpenRite stays hidden. Non-number / missing second id fail closed. Candidate-only rites are not a pair source. |
| Remember as `lastPair`; persist when both sources empty and the event is still live (B9-E) | **Pass.** Named-gate check. Continue-after-subjects pin is in the new block. Pre-existing rematch / DeclareVictor persist pins were not flipped back to hide. |
| Hide when QUIET | **Pass.** Named-gate check. |
| Health nil; no `UnitHealth` | **Pass.** Named-gate check. A01 still NOT RUN. |
| Favor W-F intact | **Pass.** Named-gate check. The `resolveFavor` Pope branch change (`livePair` → `goraPair`) is the leftover-subjects freeze, not a congregation fill from Gora. |
| Tests: no Gora sanction; OpenRite two ids → shown; QUIET hides; persist-after-DeclareVictor pins stay; isolation wrap stays | **Pass.** New block starts with `GetSanctioned() == nil`. Existing persist-after-DeclareVictor pins (head-to-head block and dedicated persist block) are still in the file and still green. Isolation stayed gated. |
| `lua tests/test_hud.lua` exit 0; **POLISH:CANDIDATE** at most | **Pass. Verified.** 539 / 0. Writer claimed that polish ceiling and no more. |

Bible §10.7 (HUD during the fight; persist through the verdict beat; defined no-live-health fallback), §13.1 (congregation never Sanctions; pair arrives as Runtime / STATE subjects), Law 6 (Quiet hides Event chrome), Law 4 (no invented verdict copy), Law 8 (no health hack), and W-F (Pope from Gora while the Gora pair is live; congregation broadcast-only; STATE-off omits) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; **POLISH:CANDIDATE** only | **Not a spec miss.** Brief asked isolated green. See Minor. |
| OpenRite stands in for STATE / Restore | **Matches the brief.** Brief pins `StartEvent` + `OpenRite`. Runtime `Restore` / Codec land the same integer list on `subjects.fighters`. See Minor. |
| B10-A last pair unused | **Not a miss.** This brief reads Runtime subjects, not `GetLastSanctioned`. Integrator owns outbound STATE after a ruling. |
| Plate click follows `livePair`; leftover subjects after a ruling still click | **Not a fill break.** Congregation *must* pick from Runtime subjects (they never Sanction). After `Continue`, both sources empty → plate no-ops. After a ruling, leftover Runtime subjects keep `livePair()` truthy; `Gora:RecordFavor` still refuses with no sanctioned gora. W-F *paint* stays gora-keyed / broadcast-only. See Minor. |
| A01 still NOT RUN; `health` nil; no `UnitHealth` | **Not a miss.** Brief forbade opening it. |
| FighterCard / glue were not edited | **Not a miss.** Exclusive HUD-only. Card persist is B10-C. STATE last-pair fill is the integrator. |
| Integrator still lists the files in the TOC and `run.lua` | **Not a miss.** Brief forbade those edits. Already listed. |

---

## Strengths

- Exclusive pair is small and on-contract. Dress, mute rails, defense integers, A01, and the two favor StatusBars were not reopened.
- Fail-closed pair: one id, a missing second id, or a non-number does not mint fighter A. `view.verdict` stays nil. `health` stays nil.
- Pope freeze was the real W-F trap (leftover subjects would have made `livePair()` truthy and re-read `GetFavorSplit()` `{0,0}`). Keying that branch on `goraPair()` keeps the B9-E freeze. Pinned.
- Congregation paint still proves W-F on the new path: no broadcast → favor nil and still shown; `{2,1}` → 66%; clear broadcast does not hide the card.
- Isolation stayed gated (13). Writer-reported 539 / 0 matches the reviewer run.

---

## Issues

### Critical

None.

### Important (must-fix)

None.

### Minor

1. **OpenRite stands in for inbound STATE.** Congregation production path is `Runtime:Restore` then glue `paintInboundFavor` → `Hud:Refresh`. Same snapshot shape (`copyFighters` / Codec ids are integers). Not a separate pin. Brief did not ask for one.

2. **Plate click after a ruling with leftover subjects.** `clickPlate` uses `livePair()`, not `displayPair()`. During RITE that is required. After `DeclareVictor`, Runtime leftover still names two fighters, so a plate click still `SendFavor`s. Gora will not tally it. After `Continue` the plate no-ops (unpinned on the subjects path). Writer disclosed the leftover click. Not a W-F fill regression.

3. **Congregation plate-on-subjects-only is unpinned.** New block covers broadcast paint, not `OnClick` / `PickFavor` with `GetSanctioned() == nil`. Implementation would send (`livePair` is `runtimePair`). Existing plate pins still use a Gora pair.

4. **Glue still only copies a live Gora pair onto outbound subjects when congregation favor is visible.** Sanction-before-OpenRite with the toggle off can leave STATE without two fighters. Congregation HUD then stays hidden until OpenRite (or the integrator last-pair fill). Out of exclusive scope. This lane is correct *when* Runtime names two ids.

5. **Console `OpenRite` does not `refreshHud`.** Pope HUD still keys off `GetSanctioned` after `Sanction` (`wantHud`). Congregation Refresh is inbound STATE. Fine for the star. A Pope client that only OpenRite’d would not repaint until something else `Refresh`es.

6. **One-id is pinned; same-id / three-id / empty `{}` / Restore are not.** `{n,n}` would paint. Runtime + Codec will not hand a holey list or string ids. Empty Codec `fighters = {}` fails the number check.

7. **QUIET-after-subjects does not re-pin fighter B or ASSEMBLY-no-revive.** `fighterA` / `health` / `shown` are pinned. No-revive still lives in the earlier persist block.

8. **Forget is Refresh-lazy.** Pre-existing. Console `EndEvent` and inbound QUIET STATE both `Refresh`.

9. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated suite was re-run here. Do not treat this as **POLISH:PASS**.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

The exclusive pair does what the brief asked: with no `Gora:Sanction`, two Runtime `subjects.fighters` ids show the HUD; one id does not invent a pair; `lastPair` persists when both sources are empty and the event is still live; QUIET / EndEvent hides and forgets; `health` stays nil; no `UnitHealth`; W-F favor (Pope freeze stays gora-keyed so leftover subjects do not thaw; congregation broadcast-only) holds; existing persist-after-DeclareVictor pins stay; isolated suite green (539 / 0). Named gates are clean. Nits are OpenRite-for-Restore, leftover-subjects plate send, unpinned subjects click, glue/OpenRite refresh edges, and unsmoked theater — not trust-breakers.

Must-fix list: **none.**

Do not sign. Do not claim **POLISH:PASS**. Do not claim V1 / MVP complete.
