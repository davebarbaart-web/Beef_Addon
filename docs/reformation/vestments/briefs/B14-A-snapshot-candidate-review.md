Spec PASS

# B14-A — SNAPSHOT Knighting candidate overlay (review)

**Quality:** Approved-with-nits

**Lane:** B14-A SNAPSHOT Knighting candidate overlay
**Brief:** `docs/reformation/vestments/briefs/B14-A-snapshot-candidate.md`
**Writer report:** `docs/reformation/vestments/briefs/B14-A-snapshot-candidate-report.md`
**Diff:** `docs/reformation/vestments/briefs/B14-A-snapshot-candidate.diff` (B14-A-only exclusive-pair packet; live `Snapshot.lua` also carries already-on-disk B11-A fighter overlay)
**Exclusive files:** `addon/ChurchOfBeef/Net/Snapshot.lua`, `tests/test_net_snapshot.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `Net/Snapshot.lua` (`overlayCandidate` / `lineHeadHumanId` / `BuildResponse` / `bibleFields` / `ApplyResponse`), and the B14-A block in `tests/test_net_snapshot.lua`; then ran `lua tests/test_net_snapshot.lua` (**800 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §20.3 catch-up; §13.1 star; B11-A fighter overlay; B12-A ASSEMBLY Restore; B13-A live ASSEMBLY Apply. Isolation Common + Runtime + Codec + Snapshot only. Did not mutate `Snapshot.lua` or `test_net_snapshot.lua`. Did not commit. Did not edit Runtime, Codec, Gora, Knighting.lua, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Overlay mutates Runtime / `StartEvent` writers | **Pass. Verified.** Overlay writes a new `subjects` table on encode `fields` only. `Runtime:Snapshot()` is a deepcopy. Pins 1–7 and 9 keep `assert_unchanged`. Reviewer probe: ASSEMBLY overlay leaves Runtime candidate nil; Runtime `{8,9}` fighters stay `{8,9}` after a candidate overlay. |
| Candidate overlaid on RITE Gora / other rites / CONSEQUENCE / QUIET | **Pass.** Allow-list is `ASSEMBLY` or (`RITE` and `riteType == "Knighting"`). Pins 4–5: Gora / Proclamation / CONSEQUENCE stay `encode_expected`, decoded candidate nil. Pin 1 extra: QUIET + stub is `nil, "no event"`. Reviewer probe: RITE Confession stays Runtime-only; CONSEQUENCE last-pair overlay still lands `{41,42}` with **no** candidate. |
| Existing numeric candidate replaced | **Pass.** Pin 6: Runtime `7` + line head `77` stays `encode_expected` / wire `7`. `type(cand) ~= "number"` is the gate. |
| `GetLine` throw escapes `BuildResponse` | **Pass. Verified.** `pcall(knighting.GetLine, knighting)`. Pin 9: `error("GetLine failed")` → `pcall` of `BuildResponse` is true, wire equals `encode_expected`, Runtime unchanged. Missing module / missing method / empty line / missing `humanId` also stay today's encode. |
| Combined fighters + candidate lost / B11-A broken | **Pass.** Pin 7: ASSEMBLY live `{31,32}` **and** candidate `77`. B11-A / B13-A pins still sit above this block and are in the 800. Reviewer probe: no-Knighting live overlay still `{31,32}` with nil candidate; Runtime-already-has-fighters `{8,9}` plus line head encodes `77` and `8,9`. |
| `ApplyResponse` drops the candidate / Restores favor | **Pass.** `ApplyResponse` is still `Restore(bibleFields(msg))`. `BIBLE` is `eventId` / `state` / `riteType` / `subjects` / `sequence`. Pin 8: `candWire` Restores `77`, stays ASSEMBLY, favor nil, role nil. Combined `bothWire` Restores `77` + `{31,32}`. Reviewer probe: favor-carrying `77` + `{31,32}` + `{a=2,b=5}` encodes favor, Apply lands Bible keys only (`favor == nil`). |
| New codec kind / `dofile` Knighting.lua | **Pass.** Load list is still Common + Runtime + Codec + Snapshot. Closed-set pins stay. Source has no `dofile`, no `TYPES`, no SUMMON, no `CreateFrame`. Stub is an in-file table, then nilled. `pcall` uses colon-call shape (`GetLine`, `knighting`). |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two `diff --git` hunks (`overlayCandidate` / `lineHeadHumanId` / `BuildResponse` insert; suite append + `clearPairStubs` also nils Knighting). Sibling dirt in this workspace is other lanes (Runtime B12-A, TOC extras, `run.lua` suite list, Knighting.lua). |
| Isolated suite not exit 0 | **Pass. Verified.** 800 passed, 0 failed. Writer-reported count matches. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Runtime / Codec / Gora / Knighting.lua / glue / TOC / bootstrap / `run.lua`; no commit; no new codec kind | **Pass.** Named-risk check. |
| Isolation stays Common + Runtime + Codec + Snapshot; stub `COB.Knighting` in-file; do not `dofile` Knighting / Gora / Store / UI | **Pass.** Four `dofile`s unchanged. End wrap re-asserts Net / Store / UI / DB / Gora / Console / **Knighting** nil. |
| Overlay onto the encoded SNAPSHOT only; `BuildResponse` must not change Runtime | **Pass.** Named-risk check. |
| Overlay when state is ASSEMBLY, or RITE Knighting, and Runtime lacks a numeric candidate | **Pass.** Pins 2–3. Empty-candidate RITE Knighting is a Restore of `{subjects={}}`, then overlay `77`. |
| Do **not** overlay on RITE Gora / Proclamation / other, CONSEQUENCE, or QUIET | **Pass.** Pins 4–5 + QUIET-with-stub. Probe: Confession. |
| Runtime already has a number candidate → do not replace it | **Pass.** Pin 6. |
| Preserve fighters when writing the candidate overlay; B11-A may coexist | **Pass.** `overlayCandidate` copies `fighters`. Pin 7. |
| `pcall` `GetLine`; missing Knighting / GetLine / empty line / missing `humanId` / throw → today's encode, no throw | **Pass.** Pins 1 and 9. Extra: Knighting table without `GetLine`. |
| Pin 8: `ApplyResponse` of a candidate overlay Restores that candidate, stays ASSEMBLY; isolation wrap stays | **Pass.** Apply runs after `clearPairStubs()`. `COB.Net` / Store / UI still nil. |
| Favor stays off Restore | **Pass.** Named-risk check. `bibleFields` still omits favor. |
| `lua tests/test_net_snapshot.lua` exit 0 | **Pass.** **800 / 0.** |

Bible §20.3 (late join / reload is a Pope snapshot, not peer SYNC) and §13.1 (Pope client encodes; congregation Restores) hold on the exclusive pair. Catch-up Restore of ASSEMBLY subjects with a candidate was already legal (B12-A). `ApplyResponse` was not rewritten.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| CONSEQUENCE still has no candidate overlay | **On contract.** Brief forbids CONSEQUENCE overlay. Late join during that verdict beat still encodes empty candidate. Leftover, not a miss. |
| Pope writer Runtime stays empty until `OpenRite` | **On contract.** Exclusive pair is Snapshot + suite. `StartEvent` / `Continue` empty writers are B12-A Runtime law. Congregation Restore of the overlaid wire **does** land `77`. |
| No client / two-client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Gate W / Gate V stay OPEN; not signed; not `POLISH:PASS` | **On contract.** This review does not sign either. |

---

## Isolation / Apply / overlay

**Isolation wrap — Pass.** Load list is still Common + Runtime + Codec + Snapshot. No `dofile` of Knighting / Gora / Store / UI. `clearPairStubs` now also nils Knighting (same pattern as the B11-A Gora stub). Pin 8 Apply isolation fires after stubs are cleared. End wrap still fires and now names Knighting.

**Apply — Pass.** Congregation-cold `reset()` then `ApplyResponse(candWire)` Restores Bible fields only. Candidate `77` lands. State stays ASSEMBLY. Sequence is resumed, not incremented. Combined overlay Restores fighters **and** candidate. Favor on a probed favor-carrying wire dies before Restore.

**Overlay — Pass.** `lineHeadHumanId` is encode-only, `pcall`'d, and gated to ASSEMBLY / RITE Knighting when Runtime candidate is not a number. Fighter overlay still runs first and may coexist. Last pair is still CONSEQUENCE-only. QUIET still returns `nil, "no event"` before any overlay. `BuildResponse` does not assign Runtime.

---

## Strengths

- Nine brief pins are present, in order, after the B11-A / B13-A overlay block, and they use `encode_candidate` / `encode_expected` rather than hand-built blobs.
- Extra pins beyond the brief: Knighting table without `GetLine`, QUIET-with-stub, RITE Proclamation, combined Apply of `bothWire`, isolation wrap after stub clear.
- Production `GetLine` shape matches the overlay (`copyRow` has `humanId`; `pcall(fn, knighting)` is a colon call). Stub `GetLine` ignores the extra self arg, which is correct.
- `overlayCandidate` mirrors `overlaySubjects` (new table, preserve the other subject). `ApplyResponse` needed no rewrite.
- Writer-reported **800 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Pope writer still cannot park ASSEMBLY (or empty RITE Knighting) candidate via `StartEvent` / `Continue` / `OpenRite` without subjects.** Congregation Restore of the overlaid wire **does** land `77`. The Pope client's live Runtime stays empty until `OpenRite` writes a candidate. Brief scoped this lane to encode overlay + Apply of that wire. Writer-path subjects remain leftover (B12-A / B14-INT).

### Nit

1. **Favor-carrying Apply is not on the suite.** Pin 8 checks `favor == nil` on `candWire` / `bothWire`, which never carried favor. Probe: Console toggle + `GetFavorSplit` `{2,5}` + live pair + line head encodes favor; Apply still drops it and keeps Bible keys only.

2. **RITE Knighting Apply of the overlay wire is unpinned.** Pin 8 is ASSEMBLY-only, as the brief asked. Probe: `ApplyResponse(riteCandWire)` Restores `77`, stays RITE Knighting.

3. **RITE Confession is unpinned.** Allow-list cannot overlay it. Probe: Confession + line head stays `encode_expected`. Proclamation is already pinned.

4. **Invalid numeric line-head ids are not treated as “today's encode.”** `lineHeadHumanId` accepts any `type == "number"`. Probe: `humanId` `0` / `1.5` / `-3` make `BuildResponse` return `nil, "invalid subjects"` (Codec `isId`) instead of Runtime-only encode. Production `Knighting:Enqueue` already `isId`-gates the line (`>= 1`). Not a brief pin.

5. **Exclusive-pair packet is a B14-A-only delta, not a full `git diff` of the two files from HEAD.** Live `Snapshot.lua` still contains the B11-A overlay hunks. Report already says this.

6. **No `/reload` / two-client catch-up smoke and no full `lua tests/run.lua`.** Isolated **800 / 0** was re-run here.

---

## Leftover honesty

- **CONSEQUENCE catch-up still has no candidate.** Brief forbids it. CloseRite of a Knighting whose Runtime snapshot never held a candidate still encodes empty candidate. Late join on that verdict beat is empty. B14-INT is STATE overlay, not this hole.
- **`GetLine` expire is a Knighting side effect, not a Runtime write.** Production `GetLine` calls `_Expire`. Overlay reads the public getter; this lane did not change `Knighting.lua`. Isolated stubs do not expire.
- **Full harness leftover line is likely inert.** `tests/run.lua` loads `test_knighting` before `test_net_snapshot`. Stale rows from that suite carry `eventId == nil` (no Runtime there); a later live `GetLine` would drop them in `_Expire`. Not proven here; brief asked the isolated file.
- Gate W / Gate V stay OPEN. Not signed. Not `POLISH:PASS`. Do not claim V1 / MVP complete.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

`BuildResponse` overlays `Knighting:GetLine()[1].humanId` onto the encoded SNAPSHOT when Runtime lacks a numeric candidate, only on ASSEMBLY or RITE Knighting. Runtime is unchanged. RITE Gora / Confession / Proclamation / CONSEQUENCE / QUIET do not take a candidate overlay. Existing numeric candidate `7` is kept. Live fighters `{31,32}` and candidate `77` coexist. `GetLine` throw does not escape. `ApplyResponse` Restores `77` and stays ASSEMBLY; favor stays off Restore. No new codec kind. Isolated `lua tests/test_net_snapshot.lua` **800 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
