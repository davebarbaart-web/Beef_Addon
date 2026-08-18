Spec PASS

# B12-A — ASSEMBLY may carry subjects (review)

**Quality:** Approved-with-nits

**Lane:** B12-A ASSEMBLY may carry subjects
**Brief:** `docs/reformation/vestments/briefs/B12-A-runtime-assembly.md`
**Writer report:** `docs/reformation/vestments/briefs/B12-A-runtime-assembly-report.md`
**Diff:** `docs/reformation/vestments/briefs/B12-A-runtime-assembly.diff` (byte-matches live exclusive hunks)
**Exclusive files:** `addon/ChurchOfBeef/Core/Runtime.lua`, `tests/test_runtime.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `Core/Runtime.lua` (`parseEvent` subject refuse, `StartEvent` / `Continue` / `EndEvent` `emptySubjects()`, `OpenRite`, `Restore`), and `tests/test_runtime.lua`; then ran `lua tests/test_runtime.lua` (**688 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §20 broadcast active subjects; §20.1 ASSEMBLY is a live event; Law 4 / §20.2 no auto-advance; no sixth state; no holdSeconds; no SV persist. Did not mutate `Runtime.lua` or `test_runtime.lua`. Did not commit. Did not edit Snapshot, glue, Codec, Gora, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| QUIET accepts subjects | **Pass.** `parseEvent` still refuses nonempty `candidate` / `fighters` when `state == "QUIET"` (`invalid subjects`). Pin: QUIET + `{ 8, 9 }` is inert. Reviewer probe: QUIET + candidate `7`, and QUIET + both, also `invalid subjects` and leave cold QUIET. |
| ASSEMBLY still refuses fighters / candidate | **Pass.** Subject refuse is QUIET-only. Restore ASSEMBLY + `{ 8, 9 }` succeeds; Snapshot keeps both ids, nil rite, stays ASSEMBLY. Restore ASSEMBLY + `candidate = 7` succeeds. Probe: ASSEMBLY + both also Restores. |
| `riteType` allowed on ASSEMBLY | **Pass.** `(QUIET or ASSEMBLY) and riteType ~= nil` still returns `invalid rite type` before subjects land. Existing empty-subjects pin stays. New pin: ASSEMBLY + `Gora` + fighters also refused. Probe: both refuse with `invalid rite type`; cold state stays QUIET. |
| `StartEvent` / `Continue` / `EndEvent` no longer clear subjects | **Pass.** All three still pass `subjects = emptySubjects()`. Existing StartEvent / Continue empty-subject pins stay. EndEvent-from-ASSEMBLY empty pin stays. Probe: EndEvent after Restore ASSEMBLY + `{ 8, 9 }` writes nil/nil; Continue after a restored-subject rite still clears. |
| Auto-advance / OpenRite auto-fire | **Pass.** Restore assigns the parsed event; it does not call `succeed` or `OpenRite`. New pins re-read ASSEMBLY after Restore. Existing no-auto-advance verb pins stay. `Runtime.AutoAdvance` stays nil. Probe: Restore stays ASSEMBLY; OpenRite is still a Pope verb. |
| Isolated suite not exit 0 | **Pass. Verified.** 688 passed, 0 failed. Writer-reported count matches. |
| Exclusive breach | **Pass.** Provided packet is two `diff --git` hunks and byte-matches `git diff` of the exclusive pair. Runtime live hunk is the one-line `parseEvent` condition. Sibling dirt in this workspace is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Snapshot / glue / Codec / Gora; no commit; no sixth state; no holdSeconds | **Pass.** Named-risk check. Restore still refuses `AWAITING_POPE`. Extra `holdSeconds` is stripped. |
| QUIET: subjects must stay empty | **Pass.** Named-risk check. Brief pin is fighters; probe covers candidate. |
| ASSEMBLY: `riteType` still nil; candidate and/or fighters MAY Restore | **Pass.** Both brief success pins. Probe: both names together. |
| RITE / CONSEQUENCE unchanged (`riteType` required) | **Pass.** Existing refuse pins stay. Probe: RITE / CONSEQUENCE without a type still `rite type required`; RITE + fighters still Restores. |
| `StartEvent` / `Continue` / `EndEvent` still write `emptySubjects()` | **Pass.** Named-risk check. Existing ASSEMBLY-empty after StartEvent / Continue pins stay. |
| Do not let OpenRite auto-fire. Do not persist Runtime to SV | **Pass.** Restore does not open a rite. Existing SV / `CreateFrame` / Net block still runs after Restore of a parked snapshot. |
| Brief test pins; `lua tests/test_runtime.lua` exit 0 | **Pass.** Four added pins match the brief. **688 / 0.** |

Bible §20 (broadcast carries active subjects with the event; ASSEMBLY is live) holds on Restore. Pope verbs that leave or start ASSEMBLY still wipe subjects, as the brief required. Congregation catch-up of an ASSEMBLY snapshot that already names fighters or a candidate can land.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Pope verbs still wipe subjects; Sanction-before-`OpenRite` still does not live in Runtime after `StartEvent` / `Continue` / `EndEvent` | **On contract.** Brief: those three verbs still write `emptySubjects()`. This lane opens Restore only. Leftover for the Pope writer path / B12-INT encode, not a miss. |
| Snapshot / Codec / Gora not edited | **On contract.** Exclusive pair. Wire encode of ASSEMBLY subjects is other lanes. |
| No client / two-client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |

---

## Isolation / verbs / Restore

**Isolation — Pass.** Load list is still Common + Runtime. No `dofile` of Snapshot, Codec, Gora, or glue. Standalone `if standalone then` counter still wraps the suite.

**Verbs — Pass.** `StartEvent` / `Continue` / `EndEvent` still write `emptySubjects()` and `clearRite`. `OpenRite` still requires ASSEMBLY + a closed rite type and writes `parseSubjects(subjects)` — it does not inherit a prior Restore. No auto-advance helpers.

**Restore — Pass.** ASSEMBLY subjects copy through `parseSubjects` / `copyFighters`. Snapshot after Restore is a deepcopy (probe: mutating the getter does not retarget live fighters). Failed QUIET / riteType Restores are inert.

---

## Strengths

- One-line `parseEvent` change. RITE / CONSEQUENCE and the Pope verb writers are untouched.
- B11-A leftover (ASSEMBLY live overlay encodes, then Restore refuses) is now Restore-safe on this exclusive pair.
- Existing ASSEMBLY-empty StartEvent / Continue pins and the empty-subjects ASSEMBLY + `riteType` refuse stay.
- Writer did not claim Pope verbs now keep a sanctioned pair, and did not touch the wire.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Pope writer still cannot park ASSEMBLY subjects via `StartEvent` / `Continue` / `EndEvent`.** Restore is the only Runtime door. Sanction-before-`OpenRite` on the Pope client still needs another path (or `OpenRite`) before a STATE / SNAPSHOT can carry those ids. Brief scoped this lane to Restore. B12-INT owns live-pair STATE overlay on ASSEMBLY.

### Minor

1. **QUIET + candidate is unpinned.** Contract names both fields. Fighters pin exists. Probe: candidate `7` and both are `invalid subjects`.

2. **ASSEMBLY + both candidate and fighters is unpinned.** Brief says and/or. Probe: both Restores, `riteType` stays nil.

3. **EndEvent after Restore-with-fighters is unpinned.** Existing EndEvent pin is the empty `StartEvent` path. Probe: EndEvent still writes `emptySubjects()`.

4. **`OpenRite` with nil subjects after an ASSEMBLY Restore writes empty subjects** (`parseSubjects(nil)`). It does not inherit Restore fighters. Unchanged OpenRite contract; unpinned. Congregation Restore is safe; the Pope still passes subjects on the verb.

5. **No `/reload` / two-client catch-up smoke and no full `lua tests/run.lua`.** Isolated **688 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

QUIET still refuses subjects. ASSEMBLY Restores candidate and/or fighters and stays ASSEMBLY with a nil rite type. `riteType` on ASSEMBLY is still refused. `StartEvent` / `Continue` / `EndEvent` still write `emptySubjects()`. No auto-advance, no sixth state, no holdSeconds, no SV. Exclusive packet is the two named files and matches live. Isolated `lua tests/test_runtime.lua` **688 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
