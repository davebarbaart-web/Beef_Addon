Spec PASS

# B13-A — ASSEMBLY overlay ApplyResponse (review)

**Quality:** Approved-with-nits

**Lane:** B13-A ASSEMBLY overlay ApplyResponse
**Brief:** `docs/reformation/vestments/briefs/B13-A-snapshot-apply.md`
**Writer report:** `docs/reformation/vestments/briefs/B13-A-snapshot-apply-report.md`
**Diff:** `docs/reformation/vestments/briefs/B13-A-snapshot-apply.diff` (exclusive-pair packet; includes already-on-disk B11-A overlay hunks plus this lane's Apply pins)
**Exclusive files:** `addon/ChurchOfBeef/Net/Snapshot.lua`, `tests/test_net_snapshot.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `Net/Snapshot.lua` (`BuildResponse` overlay / `bibleFields` / `ApplyResponse`), and `tests/test_net_snapshot.lua` (B13-A Apply pins after the live-overlay encode block); then ran `lua tests/test_net_snapshot.lua` (**640 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §20.3 catch-up; §13.1 star; B12-A ASSEMBLY Restore; B11-A live `GetSanctioned` overlay. Isolation Common + Runtime + Codec + Snapshot only. Did not mutate `Snapshot.lua` or `test_net_snapshot.lua`. Did not commit. Did not edit Runtime, Codec, Gora, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `ApplyResponse` of ASSEMBLY live overlay fails or does not land fighters | **Pass. Verified.** Pin after live-overlay encode: `ApplyResponse(liveWire) == true`; landed `ASSEMBLY`, fighters `{31,32}`, same event id / sequence as the encode snapshot, nil rite / candidate. Stubs are cleared before Apply. Reviewer probe: same path returns `true` with no err; lands `{31,32}` and stays `ASSEMBLY`. |
| Last pair overlaid on ASSEMBLY | **Pass.** Last overlay remains `elseif snap.state == "CONSEQUENCE"`. Pin 4: post-`Continue()` wire equals `encode_expected`, `#fighters == 0`, no last favor. Reviewer probe: same. |
| Favor Restored | **Pass.** `ApplyResponse` still `Restore(bibleFields(msg))`. `BIBLE` is `eventId` / `state` / `riteType` / `subjects` / `sequence`. Pin: `liveFavWire` carries `{a=2,b=5}`; landed `favor == nil`. Reviewer probe: landed Snapshot keys are Bible-only. |
| `BuildResponse` mutates Runtime | **Pass.** Overlay writes encode `fields` only. Live / live-favor / toggle-false paths keep `assert_unchanged(assemblyEmpty, …)` including the leave-Runtime-empty pin immediately before Apply. Reviewer probe: after live overlay, Runtime fighters stay nil and sequence is unchanged. |
| Isolated suite not exit 0 | **Pass. Verified.** 640 passed, 0 failed. Writer-reported count matches. |
| New codec kind / `dofile` Gora.lua | **Pass.** Load list is still Common + Runtime + Codec + Snapshot. Closed-set pins stay. Stubs are in-file tables, then nilled. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. `Snapshot.lua` has **no B13-A production hunk** (brief allows this). Sibling dirt in this workspace is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Runtime / Codec / Gora / glue; no commit; no new codec kind | **Pass.** Named-risk check. |
| Isolation stays Common + Runtime + Codec + Snapshot | **Pass.** End wrap re-asserts Net / Store / UI / DB / Gora / Console nil. |
| Pin `ApplyResponse(liveWire)` after the existing live-overlay encode pins | **Pass.** Sits after pin 2 / `clearPairStubs()`, before last-pair CONSEQUENCE. |
| Landed state is ASSEMBLY; fighters are the stub ids | **Pass.** `{31,32}` on both `liveWire` and `liveFavWire`. |
| Favor stays off Restore | **Pass.** Named-risk check. |
| `BuildResponse` still must not mutate Runtime | **Pass.** Named-risk check. |
| Do not overlay last pair onto ASSEMBLY | **Pass.** Named-risk check. Pin 4 stays. |
| `Snapshot.lua` needing no change is OK if the pin exists and passes | **Pass.** `ApplyResponse` was already `Restore(bibleFields(msg))`. B12-A already lets Runtime Restore fighters in ASSEMBLY. Pin exists and is green. |
| `lua tests/test_net_snapshot.lua` exit 0 | **Pass.** **640 / 0.** |

Bible §20.3 (late join / reload is a Pope snapshot, not peer SYNC) and §13.1 (Pope client encodes; congregation Restores) hold on the exclusive pair. B11-A's leftover (ASSEMBLY live overlay encodes, then Restore refused) is closed on this suite now that B12-A opened ASSEMBLY subjects.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| `Snapshot.lua` has no B13-A hunk; exclusive-pair diff still contains B11-A overlay | **On contract.** Brief: keep the pin if it already exists; add the missing ASSEMBLY land. Production Apply did not need a rewrite. |
| Pope verbs still wipe subjects; writer Runtime stays empty until `OpenRite` | **On contract.** Exclusive pair is Snapshot + suite. `StartEvent` / `Continue` empty writers are B12-A Runtime law, not this lane. |
| No client / two-client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |

---

## Isolation / Apply / overlay

**Isolation wrap — Pass.** Load list is still Common + Runtime + Codec + Snapshot. No `dofile` of Gora / Store / UI. B13-A Apply runs after `clearPairStubs()`. End wrap still fires.

**Apply — Pass.** Congregation-cold `reset()` then `ApplyResponse(liveWire)` Restores Bible fields only. Fighters land. State stays ASSEMBLY. Sequence is resumed, not incremented. Favor on `liveFavWire` dies before Restore.

**Overlay — Pass.** Live `GetSanctioned` still overlays ASSEMBLY when Runtime lacks two fighters. Last pair is still CONSEQUENCE-only. `BuildResponse` does not assign Runtime.

---

## Strengths

- The missing land is pinned on the real B11-A wires (`liveWire` / `liveFavWire`), not a hand-built blob. Apply is proven after stubs are cleared.
- No production rewrite. `bibleFields` already dropped favor; B12-A already opened ASSEMBLY Restore. Lane stayed a pin.
- Last-pair CONSEQUENCE / RITE Apply pins and post-Continue no-overlay pin stay. Isolation wrap stays.
- Writer-reported **640 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Pope writer still cannot park ASSEMBLY subjects via `StartEvent` / `Continue`.** Congregation Restore of the overlaid wire now lands `{31,32}`. The Pope client's live Runtime stays empty until `OpenRite`. Brief scoped this lane to Apply of the encode overlay. Sanction-before-`OpenRite` on the writer path is leftover.

### Minor

1. **Favor-carrying Apply pin is thinner than the no-favor pin.** `liveFavWire` checks state, two fighter ids, and `favor == nil`. It does not reuse `assert_snap_shape` or re-pin event id / sequence / riteType. Probe: those still hold.

2. **Last-pair ban is encode-only.** A crafted ASSEMBLY response that already names `{51,52}` Restores those fighters (B12-A law; Apply is Bible-field Restore). Pin 4 still proves `BuildResponse` will not invent that wire after `Continue()`.

3. **Exclusive-pair diff is not a B13-A-only delta.** Packet includes the B11-A `BuildResponse` overlay because `Snapshot.lua` has no new hunk. Report already says this.

4. **No `/reload` / two-client catch-up smoke and no full `lua tests/run.lua`.** Isolated **640 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

`ApplyResponse` of the B11-A live ASSEMBLY overlay Restores `{31,32}` and lands ASSEMBLY. Favor on that wire is not Restored. `BuildResponse` still does not mutate Runtime. Last pair is still not overlaid onto ASSEMBLY. No new codec kind. `Snapshot.lua` needed no B13-A rewrite; the pin exists and is green. Isolated `lua tests/test_net_snapshot.lua` **640 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
