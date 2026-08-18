Spec PASS

# B11-A — SNAPSHOT last pair / last favor (review)

**Quality:** Approved-with-nits

**Lane:** B11-A SNAPSHOT last pair / last favor
**Brief:** `docs/reformation/vestments/briefs/B11-A-snapshot.md`
**Writer report:** `docs/reformation/vestments/briefs/B11-A-snapshot-report.md`
**Diff:** `docs/reformation/vestments/briefs/B11-A-snapshot.diff` (matches live exclusive hunks)
**Exclusive files:** `addon/ChurchOfBeef/Net/Snapshot.lua`, `tests/test_net_snapshot.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `Net/Snapshot.lua` (`BuildResponse` overlay / `bibleFields` / `ApplyResponse`), and `tests/test_net_snapshot.lua`; then ran `lua tests/test_net_snapshot.lua` (**610 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §20.3 catch-up; §13.1 star; license 2 (favor on SNAPSHOT only while the congregation toggle is on). No new codec kinds. Isolation Common + Runtime + Codec + Snapshot only. Did not mutate `Snapshot.lua` or the suite. Did not commit. Did not edit Codec, BeefNet, Gora, glue, Runtime, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Last pair overlaid in ASSEMBLY (post-Continue) | **Pass.** Last overlay is `elseif snap.state == "CONSEQUENCE"`. Pin 4: `Continue()` → wire equals `encode_expected`, `#fighters == 0`, no last favor even with toggle true. Reviewer probe: same. |
| Favor on SNAPSHOT when toggle is false | **Pass.** `GetCongregationFavorVisible() == true` is required. Live and last pins omit favor on `false`, missing Console, and missing getter. Probe: toggle `false` / truthy-`1` both omit favor; `true` carries last split `{3,1}`. |
| Runtime mutated by `BuildResponse` | **Pass.** Overlay writes a new `subjects` table on encode `fields` only. `Runtime:Snapshot()` is a deepcopy. `assert_unchanged` stays on no-Gora / live / last / post-Continue / kept-fighters. Probe: ASSEMBLY live overlay leaves Runtime fighters nil and sequence unchanged. |
| New codec kind / `dofile` Gora.lua | **Pass.** Load list is still Common + Runtime + Codec + Snapshot. Closed-set pins stay (`Snapshot.TYPES` / `SNAPSHOT_ROLES` / `PROTOCOL` nil). Source has no `dofile`, no `TYPES`, no SUMMON. Stubs are in-file tables. |
| `ApplyResponse` Restores favor | **Pass.** `ApplyResponse` still `Restore(bibleFields(msg))`. `BIBLE` is `eventId` / `state` / `riteType` / `subjects` / `sequence`. Pin 6: CONSEQUENCE overlay wire may carry favor; landed snapshot has no `favor` key. Probe: landed keys are Bible-only; fighters 41/42 Restore. |
| Exclusive file breach | **Pass.** Provided packet is two `diff --git` hunks and byte-matches `git diff` of the exclusive pair. Sibling dirt in this workspace is other lanes. |
| Isolated suite not exit 0 | **Pass. Verified.** 610 passed, 0 failed. Writer-reported count matches. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Codec / BeefNet / Gora / glue / Runtime / TOC / bootstrap / `run.lua`; no commit; no new codec kind | **Pass.** Named-risk check. |
| Overlay onto the encoded SNAPSHOT only; `BuildResponse` must not change Runtime | **Pass.** Named-risk check. `bibleFields(snap)` then replace `fields.subjects`. Live Runtime is not assigned. |
| Live `GetSanctioned` overlays any non-QUIET when Runtime lacks two fighters | **Pass (encode).** Pin 2: ASSEMBLY + empty Runtime fighters encodes `{31,32}`. Live wins over last in CONSEQUENCE (pinned). QUIET with stubs stays `nil, "no event"`. |
| Last `GetLastSanctioned` overlays only when `state == "CONSEQUENCE"` | **Pass.** Pins 3–4. RITE + last (no live) does not overlay (reviewer probe). |
| Favor only when toggle is on and two fighters are outbound; live → `GetFavorSplit`; last (CONSEQUENCE only) → `GetLastFavorSplit` | **Pass.** Missing Gora / Console / methods stay `encode_expected`. |
| Runtime already has two fighters → do not replace them | **Pass.** Pin 5 keeps `{8,9}` on RITE and after `CloseRite`. |
| `ApplyResponse` Restores Bible fields only; favor stays off Restore | **Pass.** Named-risk check. RITE live overlay Restores `{31,32}`. CONSEQUENCE last overlay Restores `{41,42}`. |
| Isolation wrap stays; `lua tests/test_net_snapshot.lua` exit 0 | **Pass.** End wrap re-asserts Net / Store / UI / DB / Gora / Console nil after stub clear. **610 / 0.** |

Bible §20.3 (late join / reload is a Pope snapshot, not peer SYNC), §13.1 (Pope client encodes; congregation Restores), and license 2 (favor rides SNAPSHOT only while the toggle is on) hold on the exclusive pair. `ApplyResponse` was not rewritten.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| ASSEMBLY live overlay encodes but Restore refuses subjects | **Known Runtime law.** Brief said live overlays any non-QUIET. Writer did **not** claim ASSEMBLY Restore works. See Important leftover. Spec PASS with concern. |
| Last favor only on last-pair overlay; kept CONSEQUENCE fighters skip `GetLastFavorSplit` | **Matches the brief's overlay contract.** CloseRite keeps rite fighters, so last is not used. Glue still paints favor only from the decoded message. Leftover for B11-INT / glue. |
| `usedLive` stays true so toggle-on `GetFavorSplit` can ride a RITE catch-up that already had fighters | **Matches the favor rule** (two outbound fighters + live pair + toggle). Keep-fighters pin leaves Console nil so `encode_expected` still matches. Reviewer probe: kept `{8,9}` + toggle on encodes live favor `{4,1}` and does not replace fighters. |
| Incomplete pair is a no-op | **Correct.** One id or a non-table → today's encode path, unless a complete last pair exists in CONSEQUENCE (probe: incomplete live falls through to last `{41,42}`). |
| No client / two-client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. B11-INT owns STATE last-pair CONSEQUENCE-only overlay. |

---

## Isolation wrap / Runtime / favor

**Isolation wrap — Pass.** Load list is still Common + Runtime + Codec + Snapshot. Standalone nil-module pins sit at load and again after stub clear. Re-run here: wrap fires, suite finishes 610 / 0.

**Runtime — Pass.** `BuildResponse` does not write `COB.Runtime`. Overlay subjects are a new table (`candidate` copied, `fighters` replaced). Existing `assert_eq(wire, encode_expected(snap))` pins still pass on paths with no `COB.Gora`.

**Favor — Pass.** Encode-only. Toggle is `== true`, not truthy. `bibleFields` never copies `favor` into Restore. No persist, no SUMMON.

---

## Strengths

- Last pair is CONSEQUENCE-only. Post-Continue ASSEMBLY does not revive the just-cleared bout on SNAPSHOT. That matches B11-INT's STATE rule.
- Live pair wins over last. Runtime two-fighter rows are kept. Missing module / method is the pre-lane encode path.
- `ApplyResponse` is untouched. Favor can sit on the wire and still die before Restore.
- QUIET stays `nil, "no event"` even when Gora stubs exist. Isolation stubs are cleared.
- Exclusive packet matches the live hunks. Writer-reported 610 / 0 matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **ASSEMBLY live overlay does not Restore.** `Runtime:Restore` refuses `subjects.fighters` in ASSEMBLY / QUIET (`invalid subjects`). Brief required live overlay on any non-QUIET, so encode is on-contract. `ApplyResponse` of that wire is `nil, "invalid subjects"` (reviewer probe; landed state stays QUIET). RITE and CONSEQUENCE overlays Restore. Writer documented this and did not claim ASSEMBLY Restore works. They did not pin the Restore refusal. Prefer live overlay only on RITE / CONSEQUENCE so every overlay wire Restores — Runtime was exclusive to another lane.

### Minor

1. **Last favor skipped when CONSEQUENCE already has Runtime fighters.** `CloseRite` keeps the rite pair, so `usedLast` stays false and `GetLastFavorSplit` is not called. Verdict catch-up then has the Runtime pair and no last favor on the wire. Glue `_HandleSnapshot` still paints favor only from the decoded message.

2. **Kept Runtime fighters + live pair can carry live favor** when the toggle is on (`usedLive` is set without replacing subjects). Spec-correct; unpinned except by the Console-nil keep-fighters path.

3. **ASSEMBLY Restore refusal is unpinned.** Pin 2 proves encode + `assert_unchanged`. Pin 6 Restores RITE / CONSEQUENCE overlays only.

4. **No `/reload` / two-client catch-up smoke and no full `lua tests/run.lua`.** Isolated **610 / 0** was re-run here. B11-INT owns STATE last-pair overlay.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

Last pair is not overlaid in post-Continue ASSEMBLY. Favor is omitted unless `GetCongregationFavorVisible() == true`. `BuildResponse` does not mutate Runtime. No new codec kind and no `dofile` of Gora.lua. `ApplyResponse` Restores Bible fields only. Exclusive packet is the two named files. Isolated `lua tests/test_net_snapshot.lua` **610 passed, 0 failed**, exit 0.

ASSEMBLY live overlay encodes the sanctioned pair and then fails Restore — known Runtime law, documented by the writer, leftover not a lane fail.

Do not claim V1 / MVP complete. This review does not sign the lane.
