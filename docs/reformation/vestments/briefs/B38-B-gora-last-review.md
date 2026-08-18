Spec PASS

# B38-B — last-pair SNAPSHOT overlay is Gora-only (review)

**Quality:** Approved-with-nits

**Lane:** B38-B last-pair SNAPSHOT overlay is Gora-only
**Brief:** `docs/reformation/vestments/briefs/B38-B-gora-last.md`
**Writer report:** `docs/reformation/vestments/briefs/B38-B-gora-last-report.md`
**Diff:** `docs/reformation/vestments/briefs/B38-B-gora-last.diff` (B38-B-only exclusive-pair packet; live `Snapshot.lua` / `test_net_snapshot.lua` also carry earlier Snapshot batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/Net/Snapshot.lua`, `tests/test_net_snapshot.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `Net/Snapshot.lua` (`BuildResponse` ~83–118; last overlay ~93–102; live `GetSanctioned`; B14-A candidate overlay ~108–118; `ApplyResponse` ~135–145), and `tests/test_net_snapshot.lua` (isolation wrap, existing Gora last overlay ~651, B14-A block, B38-B block after B14-A ~1036); then ran `lua tests/test_net_snapshot.lua` (**826 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.7 persist is the Gora pair; B32-A HUD already forgets leftover lastPair when `riteType ~= "Gora"`; B11-A last overlay; B14-A candidate overlay. Last-pair arm is `CONSEQUENCE` **and** `snap.riteType == "Gora"`. Live `GetSanctioned` overlay stays ungated. Candidate overlay stays B14-A. Existing ~651 Gora CONSEQUENCE last pins stay. Runtime is not assigned. No dest on Codec. Did not mutate `Snapshot.lua` or `test_net_snapshot.lua`. Did not commit. Did not edit glue, Codec, Gora, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Last-pair overlay still runs on Knighting / Confession / any non-Gora CONSEQUENCE | **Pass. Verified.** Live last arm is `elseif snap.state == "CONSEQUENCE" and snap.riteType == "Gora"`. Nested: Knighting CONSEQUENCE + last stub is `encode_expected`, decoded fighter count 0, leftover last favor omitted. Reviewer probe: Confession CONSEQUENCE and Proclamation CONSEQUENCE also stay Runtime-only (0 fighters, favor nil). Bug sequence Gora → Continue → Knighting CloseRite + last stub also stays `encode_expected`. |
| Existing Gora empty CONSEQUENCE last overlay (~651) broken | **Pass. Verified.** Existing ~651 block is untouched in the packet and is inside the 826. Nested B38-B re-pin: Gora empty CONSEQUENCE + `GetLastSanctioned` still overlays `{41,42}`; Runtime unchanged. Reviewer probe: same fixture with last favor still encodes `{41,42}` + `{a=3,b=1}`. Live-over-last and kept-Runtime-fighters pins above the B14-A block still pass. |
| Live `GetSanctioned` overlay gated or removed | **Pass. Verified.** Live arm is still `if liveA and liveB then` with no rite-type gate. Existing ASSEMBLY live overlay ~583 and RITE live Apply ~820 stay. Reviewer probe: live `{61,62}` still overlays on ASSEMBLY, Knighting CONSEQUENCE, and Confession CONSEQUENCE; last pair is ignored when live is present. |
| B14-A candidate overlay broken (ASSEMBLY / RITE Knighting) | **Pass. Verified.** Candidate block ~108–118 is unchanged (`ASSEMBLY` or `RITE` + `Knighting`). B14-A pins sit above B38-B and are in the 826. Reviewer probe: last-pair stub present still overlays candidate `77` on ASSEMBLY and on empty RITE Knighting; Knighting CONSEQUENCE + last stub + line head overlays neither leftover fighters nor a candidate. |
| Last overlay now runs on ASSEMBLY / QUIET | **Pass. Verified.** QUIET still returns `nil, "no event"` before any overlay (existing ~568). Post-Continue ASSEMBLY last refuse ~723 stays. Reviewer probe: QUIET + last stub is still `nil, "no event"`; ASSEMBLY + last stub stays `encode_expected` (0 fighters, favor nil). RITE Gora + last-only also stays Runtime-only (existing CONSEQUENCE gate). |
| Runtime mutated | **Pass. Verified.** Overlay writes a new `subjects` table on encode `fields` only. `Runtime:Snapshot()` is a deepcopy. Nested Gora stay and Knighting refuse both `assert_unchanged`. Reviewer probe: Confession refuse, sequence refuse, live Knighting overlay, and Gora last+favor leave Runtime fighters nil. `ApplyResponse` is still `Restore(bibleFields(msg))`. |
| Dest added on Codec | **Pass.** Packet does not touch Codec. Live `Codec.lua` has no `dest`. `SNAPSHOT_RES_KEYS` is still type / version / role / eventId / state / riteType / subjects / sequence / favor. `Snapshot.lua` has no `dest`. Closed-set pins stay. Sibling Codec dirt vs HEAD is DECREE, not dest. |
| Isolation wrap rewritten / exclusive breach / suite not exit 0 | **Pass. Verified.** 826 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the last `if standalone then` (**7** nil pins). Packet is the two named files. Sibling dirt vs HEAD is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Codec, Gora, glue; no commit; no dest on Codec | **Pass.** Named-risk check. Reviewer did not commit. |
| Last-pair overlay only when `snap.riteType == "Gora"` (with existing CONSEQUENCE gate) | **Pass.** Brief vs `Snapshot.lua` ~97. Nested Knighting refuse + reviewer Confession / Proclamation / sequence probes. |
| Live `GetSanctioned` overlay stays | **Pass.** Named-risk check. |
| Candidate overlay stays B14-A (ASSEMBLY / RITE Knighting) | **Pass.** Named-risk check. |
| Existing Gora CONSEQUENCE last-pair pins stay | **Pass.** Named-risk check. ~651 untouched; B38-B re-pins `{41,42}`. |
| After B14-A: Gora empty CONSEQUENCE + `GetLastSanctioned` still overlays; Knighting (or Confession) CONSEQUENCE + last stub does **not** overlay leftover fighters | **Pass.** B38-B block ~1040–1094. Knighting is the named refuse. Confession is the brief's `or`. Reviewer probe closed Confession. |
| Isolation wrap stays; `lua tests/test_net_snapshot.lua` exit 0 | **Pass.** **826 / 0.** Wrap **7**. |

Bible §10.7 holds on the exclusive pair: persist is the Gora pair. After Gora → Continue → Knighting CloseRite, catch-up no longer carries leftover last Gora fighters or last favor. Law 5 holds: Net does not invent a later-rite subject from a prior Gora pair; congregation Restore of the Knighting refuse wire lands empty fighters. Law 4 holds: gating leftover overlay is not an auto-verdict and does not narrate. Law 8 holds: the leftover pair is not a Knighting / Confession subject. §20.3 holds: Pope `BuildResponse` still encodes current theater; QUIET stays `nil, "no event"`. B32-A HUD forget (`riteType ~= "Gora"`) now has a matching wire gate. Live sanctioned pair and B14-A line-head candidate stay.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Confession / Proclamation CONSEQUENCE leftovers are not separately pinned; only Knighting is the named refuse | **On contract.** Brief said Knighting **or** Confession. Gate is `riteType == "Gora"`. Reviewer probe: Confession and Proclamation CONSEQUENCE stay `encode_expected` (0 fighters, favor nil). |
| Gora → Continue → Knighting is not a separate sequence pin | **On contract.** Fresh `OpenRite("Knighting")` + `CloseRite` plus a last-pair stub is the refuse. Same gate. Reviewer probe: the full sequence also stays Runtime-only. |
| Live `GetSanctioned` during non-Gora CONSEQUENCE still overlays | **On contract.** Brief keeps the live path. Not re-pinned in the B38-B block. Reviewer probe: Knighting CONSEQUENCE and Confession CONSEQUENCE still overlay live `{61,62}`. |
| No client / two-client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B11 leftover (last-pair overlay on **any** CONSEQUENCE with fewer than two fighters, so Gora → Continue → Knighting CloseRite still shipped leftover last Gora pair) is this lane's spec. It is closed on the exclusive pair.

---

## Isolation / keep

**Isolation wrap — Pass.** Load list is still Common + Runtime + Codec + Snapshot. No `dofile` of Gora, Knighting, Store, UI, glue, or BeefNet. Stubs are in-file tables, then nilled. Load isolation is still **4** (Net / Store / UI / DB). B14-A candidate Apply isolation is still **3**. End wrap is still **7** (those four plus Gora / Console / Knighting). Wrap body is unchanged; B38-B sits after the B14-A block and before the wrap. Extra `clearPairStubs()` immediately above the wrap is redundant, not a rewrite.

**Last-pair gate — Pass.** `usedLast` (and last favor) only set when the Gora CONSEQUENCE last overlay runs. Knighting CONSEQUENCE leftover last favor is not invented. Overlay writes encode `fields` only. `ApplyResponse` still drops favor before Restore. Reviewer probe: Apply of the Knighting refuse wire Restores CONSEQUENCE Knighting with fighters nil and favor nil.

**Keep — Pass.** Live `GetSanctioned` still overlays on any live event state when Runtime has fewer than two fighters. B14-A candidate overlay is still ASSEMBLY / RITE Knighting. Existing Gora empty CONSEQUENCE last overlay (~651) still encodes `{41,42}` and last favor when the toggle is on. Post-Continue ASSEMBLY last refuse stays. QUIET BuildResponse stays nil. Runtime-already-has-two-fighters still wins. Live pair still wins over last pair in Gora CONSEQUENCE.

---

## Strengths

- The fix is one conjunct on the existing last-pair `elseif`. Live overlay, candidate overlay, and `ApplyResponse` were left alone.
- Gora stay and Knighting refuse sit next to each other after B14-A, so a blanket last-pair delete, a live-arm gate, or a candidate rewrite would fail.
- Knighting refuse pins the wire as `encode_expected`, decoded fighter count 0, **and** leftover last favor omitted, so a pair-only refuse that still invented `{a=3,b=1}` would fail.
- Existing ~651 Gora last+favor pins were not rewritten. Writer-reported red (**823 / 3**) matches leftover Knighting `{41,42}` plus last favor `3,1`. Writer-reported green (**826 / 0**) matched the re-run.
- Isolation wrap stays **7**. No new helpers. No new codec kind. No dest.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **Confession / Proclamation CONSEQUENCE leftovers are not in-lane pins.** Brief allowed Knighting or Confession. Reviewer probe closed both plus Proclamation. Do not expand this exclusive pair to pin every rite unless a later brief asks.

2. **Gora → Continue → Knighting is not a sequence pin.** Fresh Knighting CloseRite plus a last stub is the refuse. Reviewer probe closed the full sequence. Same `riteType == "Gora"` gate.

3. **Live `GetSanctioned` during non-Gora CONSEQUENCE still overlays.** Required keep. Not re-pinned in the B38-B block. Reviewer probe closed Knighting / Confession CONSEQUENCE live `{61,62}`.

### Nit

1. **Double `clearPairStubs()`** immediately before the isolation wrap (`test_net_snapshot.lua` ~1094 and ~1096). Wrap still asserts the seven nils. Not a rewrite.

2. **Writer "no new main-chunk locals" is slightly loose.** The B38-B block adds mid-file locals (`goraLastStay`, `knightLastRefuse`, …) in this suite's existing sequential style. Brief did not require nesting.

3. **Exclusive-pair diff is not a vs-HEAD Snapshot delta.** Packet is the one-line last-arm conjunct plus the post-B14-A pins. Report already says this. Sibling dirt vs HEAD includes earlier Snapshot batches and other-lane Runtime / Codec / Gora / glue.

4. **Isolation wrap is load-only.** Seven pins under the last `if standalone then`. B38-B re-uses `clearPairStubs` then the wrap re-asserts. Brief said the wrap stays; it did.

5. **No `/reload` or two-client catch-up smoke and no full `lua tests/run.lua`.** Isolated **826 / 0** was re-run here. Late join during a later Knighting CONSEQUENCE after a real Gora last pair is unproven on Anniversary.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: last-pair overlay only when `riteType == "Gora"`; live `GetSanctioned` stays; B14-A candidate stays; existing Gora CONSEQUENCE last pins stay; Knighting (or Confession) CONSEQUENCE + last stub does not overlay leftover fighters. Live `BuildResponse` ~97 matches. Brief test pins sit after the B14-A block.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftovers: Confession / Proclamation not separately pinned (reviewer probe closed); sequence pin absent (reviewer probe closed); live non-Gora CONSEQUENCE overlay is a required keep. Nits listed above.

**3. Isolation count:** **826 passed, 0 failed.** Isolation wrap: **7**.

**4. Law:** Bible §10.7 holds. Persist is the Gora pair; leftover last pair no longer rides a later Knighting / Confession CONSEQUENCE wire. Law 5 holds: Net does not invent later-rite fighters from `GetLastSanctioned`. Law 4 holds: the gate is encode-only, not an auto-verdict. Law 8 holds. §20.3 holds: QUIET stays `no event`; catch-up encodes current theater. B32-A HUD forget now has a matching wire gate. Live sanctioned pair and B14-A candidate stay.

**Leftovers:**
- Confession / Proclamation CONSEQUENCE leftovers are not in-lane pins (Important, not must-fix; reviewer probe closed).
- Gora → Continue → Knighting is not a sequence pin (reviewer probe closed).
- Live `GetSanctioned` during non-Gora CONSEQUENCE still overlays (required keep).
- Double `clearPairStubs()` before the wrap.
- Writer "no new main-chunk locals" is slightly loose (house-style mid-file locals).
- Exclusive-pair packet is not a vs-HEAD Snapshot delta.
- Isolation wrap is load-only.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

Last-pair overlay runs only on Gora CONSEQUENCE. Live `GetSanctioned` stays. B14-A candidate overlay stays. Existing Gora empty CONSEQUENCE last overlay (~651) still encodes `{41,42}`. Knighting CONSEQUENCE + last stub does not overlay leftover fighters or last favor. Isolation wrap stays **7**. Isolated `lua tests/test_net_snapshot.lua` **826 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
