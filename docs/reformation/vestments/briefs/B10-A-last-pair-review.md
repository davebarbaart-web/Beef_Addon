Spec PASS

# B10-A — Gora last pair / last favor (review)

**Quality:** Approved-with-nits

**Current verdict:** Rereview after event-scope must-fix. First review was Spec FAIL (last survived `EndEvent` → `StartEvent` with no `GetLast` in QUIET). Writer now snapshots `eventId` on last and wipes when the live event id differs. See **Rereview** below. The first-pass body is kept as history.

**Lane:** B10-A Gora last pair / last favor
**Brief:** `docs/reformation/vestments/briefs/B10-A-last-pair.md`
**Writer report:** `docs/reformation/vestments/briefs/B10-A-last-pair-report.md`
**Diff:** `docs/reformation/vestments/briefs/B10-A-last-pair.diff` (stale — not regenerated on the must-fix pass; live files were re-read)
**Exclusive files:** `addon/ChurchOfBeef/Core/Gora.lua`, `tests/test_gora.lua`

---

# First review (Spec FAIL)

**Quality:** Changes-requested

**Lane:** B10-A Gora last pair / last favor
**Brief:** `docs/reformation/vestments/briefs/B10-A-last-pair.md`
**Writer report:** `docs/reformation/vestments/briefs/B10-A-last-pair-report.md`
**Diff:** `docs/reformation/vestments/briefs/B10-A-last-pair.diff`
**Exclusive files:** `addon/ChurchOfBeef/Core/Gora.lua`, `tests/test_gora.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, `Core/Gora.lua` (`GetLastSanctioned` / `GetLastFavorSplit` / `clearLive` / `_Expire` / `Sanction` / `ResetForTests` / `GetFavorSplit`), and `tests/test_gora.lua`; then ran `lua tests/test_gora.lua` (**493 passed, 0 failed**, exit 0, Lua 5.1.5) and a throwaway EndEvent→StartEvent probe that does not live in the exclusive files. Law cited: Bible §10.7 persist through verdict; §10.9 Famous Upsets are Pope-flagged, never computed; §13.1 star; license 2 favor on STATE; brief wipe/pin rules. Did not mutate `Gora.lua` or the suite. Did not commit. Did not edit Hud, glue, Codec, TOC, or `run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `GetSanctioned()` stays nil after a ruling | **Pass.** `clearLive` nils `self.sanctioned` only after both Store writes. Existing + last-pair pins keep `GetSanctioned() == nil` on victor / cowardice / void / free. Refused outsider / double / late rulings do not call `clearLive`. |
| Last pair / last favor are memory-only; never SV | **Pass.** Locals only. Getters return copies. CreateFrame / `ChurchOfBeefDB.sentinel` block now calls both getters around Void. Source has no `ChurchOfBeefDB` write and does not put last on Store / ceremony / Snapshot. |
| `GetFavorSplit()` stays `{0,0}` without a live pair | **Pass.** Shared `favorSplitFor(self.sanctioned)` returns zeros when the pair is nil. Existing no-pair / post-ruling / Reset pins stay. Last-pair block re-pins zeros before Sanction and after `DeclareVictor`. |
| Famous Upsets stay not computed (§10.9) | **Pass.** `Gora.FamousUpsets` stays nil. `writeBoth` still omits `famousUpset`. Source has no flag walk, level compare, or `FlagFamousUpset`. Existing result pin and the last-pair path pin `famousUpset == false`. |
| EndEvent / QUIET expire nils last; new event does not inherit last | **Fail.** Wipe runs only when `_Expire` sees no event (QUIET / missing Runtime). Last is not tagged with an event id. Favor already closes `EndEvent` → `StartEvent` with no Gora call in QUIET via `favorEventId`. Last does not. Reviewer probe: `DeclareVictor` → `EndEvent` → `StartEvent` → `GetLastSanctioned().fighterA` is still the old id and `GetLastFavorSplit().a` is still the pre-ruling `2`. Suite pin calls `GetLastSanctioned` *during* QUIET, which is the wipe, not the production path. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Hud / glue / Codec; no commit; Famous Upsets not computed; favor memory-only | **Pass.** Provided diff is two `diff --git` hunks: `Core/Gora.lua` and `tests/test_gora.lua`. Live exclusive files match that packet. |
| `Gora:GetLastSanctioned()` / `Gora:GetLastFavorSplit()` | **Pass (shape).** Last pair is `{ fighterA, fighterB }` or nil (ids only, no stipulation). Last split is always `{ a, b }`; missing → `{0,0}`. Copies. |
| Snapshot on successful `clearLive` (victor / cowardice / void / free); compute split before nilling `sanctioned` | **Pass.** `favorSplitFor(pair)` then nil. Failed `writeBoth` / refused verbs do not invent last. Probe: outsider `DeclareVictor` leaves last nil. |
| Wipe last on `_Expire` with no event, `ResetForTests`, and new `Sanction` | **Partial.** All three sites call `wipeLast`. Successful `Sanction` nils last after validation (failed same-id Sanction keeps last — probe). **New event with a live `eventId` does not wipe last.** Brief also said EndEvent / QUIET expire nils last so STATE does not keep the old bout. That is only true if a Gora getter runs while QUIET. |
| Pin: new Sanction nils last; EndEvent / QUIET expire nils last; isolation wrap stays | **Partial.** New Sanction pin is real. QUIET pin is the lazy no-event wipe, proven only by reading last *in* QUIET. Isolation wrap is still **10** gated pins (Net, UI, DB, Officer, Archive, Recognition, Popes, Sender, Codec, Snapshot). |
| `lua tests/test_gora.lua` exit 0 | **Pass. Verified.** 493 passed, 0 failed. Writer-reported count matches. |

Bible §10.7 (Consequence still needs the pair after `GetSanctioned` is nil), §10.9 (Famous Upsets not computed), and memory-only favor hold on the exclusive pair. Event-scoped last does not. B10-INT will put last pair + last favor on outbound STATE when the live pair is gone and the event is not QUIET — that is the first `GetLast*` of a new ASSEMBLY.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Last pair is ids only; HUD must not expect a decree line | **Matches the brief.** `{ fighterA, fighterB }`. Stipulation pin is in `runLastPair`. |
| New Sanction nils last immediately, including same-pair rematch | **Matches the pin.** STATE drops the previous bout once a new Sanction succeeds. |
| `GetLast*` call `_Expire`; glue must read while the event is still live | **Correct, and incomplete.** Reading *after* EndEvent nils last. Not reading in QUIET, then reading on the next event, **revives** last. Favor already treats that as a production leak in this same file. Must-fix. |
| `{0,0}` is both missing and empty | **Matches the brief.** Distinguish via `GetLastSanctioned() == nil`. |
| Unrulied expire does not snapshot | **Correct.** `_Expire` with no event nils the live pair without `clearLive`. Last is not invented. EndEvent-without-ruling pin is good. |
| Favor map still survives Void; last split is a separate snapshot | **Correct.** Existing Void-leaves-picks pin stays. `GetFavorSplit` after clear is still `{0,0}`. |
| Nested `runLastPair`; no client smoke / full harness | **Not a miss.** Isolation wrap was not moved. B10-B / B10-C / B10-INT own persist paint and `stateFields`. |

---

## Isolation wrap / Famous Upsets / live split

**Isolation wrap — Pass.** Load list is still Common + Ranks + Store + Runtime + Gora. The **10** nil-module pins sit under `if standalone then` at file load. `lua tests/test_gora.lua` re-run here: wrap fires, suite finishes 493 / 0. Pins are not in the shared body.

**Famous Upsets — Pass.** Module `Gora.FamousUpsets == nil`. `clearLive` / last getters do not write Store flags. Victor result `famousUpset == false` is pinned on the existing path and again in `runLastPair`.

**`GetFavorSplit` without a live pair — Pass.** Refactor to `favorSplitFor` does not change the no-pair contract. Last split is a different table.

---

## Strengths

- Snapshot sits inside `clearLive` after both Store writes. Refused / failed rulings do not invent last. Getters return copies. Expected failures stay `nil, err`.
- Live `GetSanctioned` stays nil after a ruling. Live `GetFavorSplit` stays `{0,0}` once the pair is gone. That keeps the existing HUD/favor pins honest.
- New `Sanction` nils last after every validation, so a refused busy / same-id / no-event Sanction does not drop a still-needed snapshot.
- Famous Upsets stay uncomputed. Favor stays a local map. Exclusive packet matches the live hunks. Writer-reported 493 / 0 matched the re-run.

---

## Issues

### Critical

None. (The miss is event-scope, not an SV write, a computed upset, or a live-pair lie.)

### Important (must-fix)

1. **Last pair / last split are not event-scoped.** `_Expire` wipes last only when `liveEventId()` is nil. Favor already tags picks (`favorEventId`) and wipes when the live event changes — the suite comment at the Void leftover block is explicit: `EndEvent` → `StartEvent` with no Gora call in QUIET is a **production leak**. Last has no `lastEventId`. After a ruling, that same path returns the old pair and the old split.

   Reviewer probe (not checked in): `DeclareVictor` with a 2/0 split → `Runtime:EndEvent()` → `Runtime:StartEvent()` → `GetLastSanctioned().fighterA == 1` and `GetLastFavorSplit().a == 2`.

   The `runLastPair` QUIET pin calls `GetLastSanctioned` *while* the runtime is QUIET, which *is* the wipe. It does not prove the next event starts empty. B10-INT’s rule is “live pair gone and the event is not QUIET.” That is exactly the first `GetLast*` after `StartEvent`, before the next Sanction.

   Do not rely on glue `stateFields` calling `GetSanctioned` during EndEvent (`sendState` skips `stateFields` when Net is missing or `_inspecting`). Core last is event memory; tag it like favor.

   Exclusive fix: remember the sanctioned `eventId` on snapshot; in `_Expire`, when a live event id exists and it is not that id, `wipeLast()`. Pin `ruling → EndEvent → StartEvent → GetLastSanctioned() == nil` and last split `{0,0}` next to the existing favor leak pin. Keep the no-event wipe and the new-Sanction wipe.

### Minor (leftover nits)

1. **Continue-to-ASSEMBLY keeps last.** Same `eventId`, not QUIET. Brief does not wipe on `Continue`. Probe: last still names fighter A in ASSEMBLY. B10-INT / HUD must decide whether STATE should still carry the just-cleared bout between rites. Not a B10-A miss.

2. **Outsider / failed-`writeBoth` last is unpinned.** Probe: outsider `DeclareVictor` leaves last nil; failed same-id Sanction after a real ruling keeps last. Implementation is right. Pin both next to the leak pin.

3. **Missing-`AppendCeremony` last is unpinned.** `clearLive` still runs. The missing-append block still pins `GetSanctioned() == nil` and `famousUpset == false` only.

4. **`{0,0}` ambiguity** is specified. Glue must key off `GetLastSanctioned() == nil`.

5. **Last is gone after `/reload`.** Memory-only is required. Pope persist after a crash mid-CONSEQUENCE cannot resurrect the pair from SV. B10-INT / HUD must tolerate missing last.

6. **Nested `runLastPair`.** Extra locals in a helper. Isolation wrap was not moved.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated suite was re-run here. Persist paint is B10-B / B10-C / B10-INT.

---

## Assessment

**Spec FAIL. Quality: Changes-requested.**

The last-pair API, successful-`clearLive` snapshot, live `GetSanctioned` nil, live `GetFavorSplit` `{0,0}`, memory-only storage, Famous Upsets uncomputed, new-Sanction wipe, and isolation wrap are in place. Isolated **493 / 0** was re-run here.

The lane still fails the EndEvent / next-event half of the brief. Last is not tagged the way favor already is, so `EndEvent` → `StartEvent` with no Gora call in QUIET hands B10-INT the previous bout to put on STATE.

**Must-fix:**

1. Event-scope last pair and last split (snapshot the sanctioned `eventId`; wipe in `_Expire` when the live event id does not match). Pin `ruling → EndEvent → StartEvent` (no Gora call in QUIET) → `GetLastSanctioned()` nil and `GetLastFavorSplit()` `{0,0}`. Do not treat a GetLast *during* QUIET as that proof.

Do not claim V1 / MVP complete. This review does not sign the lane.

---

# Rereview (must-fix: event-scope last)

**Spec PASS. Quality: Approved-with-nits.**

Task-scoped gate only. Reviewer re-read the brief, the first FAIL, the updated writer report, live `Core/Gora.lua` (`_Expire` / `clearLive` / `GetLastSanctioned` / `GetLastFavorSplit` / `Sanction` / `ResetForTests`), and the StartEvent pin in `tests/test_gora.lua`; then re-ran `lua tests/test_gora.lua` (**505 passed, 0 failed**, exit 0, Lua 5.1.5) and a throwaway `DeclareVictor` → `EndEvent` → `StartEvent` probe that does not live in the exclusive files. Did not edit `Gora.lua` or `test_gora.lua`. Did not edit Hud, glue, Codec, TOC, or `run.lua`. Did not commit. This rereview does not sign the lane.

The checked-in `B10-A-last-pair.diff` was not regenerated on the must-fix pass. Live exclusive files were the source of truth.

---

## Named risks

| Risk | Verdict |
|---|---|
| `GetSanctioned()` stays nil after a ruling | **Pass.** Unchanged. `clearLive` still nils the live pair after both Store writes. StartEvent pin re-asserts `GetSanctioned() == nil` after `DeclareVictor` before `EndEvent`. |
| Last pair / last favor are memory-only; never SV | **Pass.** Unchanged. `eventId` lives on the internal last row only. Getter copies stay `{ fighterA, fighterB }`. CreateFrame / `ChurchOfBeefDB.sentinel` block still calls both getters around Void. |
| `GetFavorSplit()` stays `{0,0}` without a live pair | **Pass.** Unchanged. StartEvent pin re-asserts zeros on the new event with no live pair. |
| Famous Upsets stay not computed (§10.9) | **Pass.** Unchanged. StartEvent pin re-asserts `famousUpset == false` on the boundary path. `Gora.FamousUpsets` stays nil. |
| EndEvent / QUIET expire nils last; new event does not inherit last | **Pass.** `clearLive` stores `pair.eventId` on `lastSanctioned`. `_Expire` still `wipeLast()` when `liveEventId()` is nil, **and** `wipeLast()` when a live event id exists and `lastSanctioned.eventId ~= eventId`. Runtime `StartEvent` assigns a new incrementing id. First `GetLast*` of that event is the wipe. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Hud / glue / Codec; no commit; Famous Upsets not computed; favor memory-only | **Pass.** This rereview read only the exclusive pair plus Runtime as the event-id producer. No addon edits. No commit. |
| `Gora:GetLastSanctioned()` / `Gora:GetLastFavorSplit()` | **Pass.** Shape unchanged. Internal `eventId` is not copied out. Probe: getter `eventId` is nil; `stipulation` stays nil. |
| Snapshot on successful `clearLive`; compute split before nilling `sanctioned` | **Pass.** Unchanged. `favorSplitFor(pair)` then assign `eventId`, then nil the live pair. |
| Wipe last on `_Expire` with no event, `ResetForTests`, and new `Sanction` | **Pass.** All three stay. **New event with a live `eventId` now wipes last** when that id is not the snapshotted id. |
| Pin: new Sanction nils last; EndEvent / QUIET expire nils last; isolation wrap stays | **Pass.** New-Sanction and in-QUIET pins stay. StartEvent pin is the production proof. Isolation wrap is still **10** gated pins. |
| `lua tests/test_gora.lua` exit 0 | **Pass. Verified.** 505 passed, 0 failed. Writer-reported count matches. |

Bible §10.7 (Consequence still needs the pair after `GetSanctioned` is nil), §10.9 (Famous Upsets not computed), and memory-only favor hold. Event-scoped last now holds. B10-INT’s first `GetLast*` of a new ASSEMBLY no longer inherits the previous bout.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Internal last row stores `eventId`; getter copies stay ids only | **Matches the brief.** `{ fighterA, fighterB }`. Probe: no leaked `eventId`. |
| StartEvent pin covers the production leak (no GetLast in QUIET) | **Matches the must-fix.** Pin exists; first `GetLast*` is after `StartEvent`. |
| Glue must still read last while the event is live | **Correct.** Same-event last still holds (pinned). Continue keeps last (same `eventId`). |
| `{0,0}` is both missing and empty | **Matches the brief.** Distinguish via `GetLastSanctioned() == nil`. |
| Unrulied expire does not snapshot | **Correct.** EndEvent-without-ruling pin stays. |
| Favor map still survives Void; last split is a separate snapshot | **Correct.** Void leftover pick pin stays. Last still dies on the new event. |
| `.diff` not regenerated; no client smoke / full harness | **Not a miss.** Live files reviewed. Persist paint is B10-B / B10-C / B10-INT. |

First-review must-fix, judged:

| Must-fix | Gate |
|---|---|
| Snapshot the sanctioned `eventId` on last | **Fixed.** `clearLive` writes `eventId = pair.eventId`. |
| `_Expire` wipes when a live event id exists and it is not that id | **Fixed.** `if lastSanctioned and lastSanctioned.eventId ~= eventId then wipeLast()`. Same pattern as `favorEventId`. |
| Pin `ruling → EndEvent → StartEvent` with **no** GetLast in QUIET → `GetLastSanctioned()` nil and `GetLastFavorSplit()` `{0,0}` | **Fixed.** Pin is in `runLastPair` after the Reset block. Same-event last is asserted, then `Runtime:EndEvent()` then `Runtime:StartEvent()` with no Gora call between, then first `GetLast*`. |
| Do not treat a GetLast *during* QUIET as that proof | **Fixed.** The older QUIET pin remains; it is no longer the only expire proof. |
| Keep the no-event wipe and the new-Sanction wipe | **Kept.** |

---

## StartEvent pin (confirmed)

The production-leak pin **exists** in `tests/test_gora.lua` inside `runLastPair`:

- Comment: `ruling → EndEvent → StartEvent with no GetLast in QUIET`.
- Same-event last is asserted while the event is still live (`GetLastSanctioned().fighterA`, last split `a == 1`).
- Then `Runtime:EndEvent()` immediately followed by `Runtime:StartEvent()`. No `GetLastSanctioned` / `GetLastFavorSplit` / other Gora call in QUIET.
- First getters of the new event: `GetLastSanctioned() == nil`, `GetLastFavorSplit()` `{0,0}` on both halves.

Reviewer probe (not checked in): `DeclareVictor` with a 2/0 split → `EndEvent` → `StartEvent` → first `GetLastSanctioned()` is nil and first `GetLastFavorSplit()` is `{0,0}`. Runtime leftover `eventId` on the QUIET snapshot does not matter (`liveEventId()` is nil in QUIET). `StartEvent` assigns a new incrementing id; `_Expire` sees `lastSanctioned.eventId ~=` that id and `wipeLast()`. `GetLastFavorSplit`-first of the new event is also `{0,0}` (shared wipe). Cowardice and Void last do not inherit. `GetSanctioned`-first of the new event also expires last, because every public Gora read calls `_Expire`.

---

## Isolation wrap / Famous Upsets / live split

**Isolation wrap — Pass.** Load list is still Common + Ranks + Store + Runtime + Gora. The **10** nil-module pins sit under `if standalone then` at file load. Re-run here: wrap fires, suite finishes 505 / 0.

**Famous Upsets — Pass.** Unchanged. Boundary pin re-asserts `famousUpset == false`.

**`GetFavorSplit` without a live pair — Pass.** Unchanged. Last split is still a different table.

---

## Strengths

- Event-scope matches favor: tag on snapshot, wipe on live-id mismatch, lazy until the first Gora call of the new event.
- Getter copies still hide `eventId`. Live `GetSanctioned` stays nil. Live `GetFavorSplit` stays `{0,0}`.
- No-event wipe, new-Sanction wipe, and Reset wipe stayed. Failed same-id Sanction still keeps last (probe).
- StartEvent pin is the production path B10-INT will hit, not a GetLast during QUIET.
- Isolated **505 / 0** was re-run here and matches the writer report.

---

## Must-fix

None.

---

## Leftover (Minor)

1. **Continue-to-ASSEMBLY keeps last.** Same `eventId`, not QUIET. Brief does not wipe on `Continue`. Probe still names fighter A after `CloseRite` → `Continue`. B10-INT / HUD decide whether STATE still carries the just-cleared bout between rites. Not a B10-A miss.

2. **Last split is wiped with the pair, not tagged on its own.** `_Expire` keys the mismatch off `lastSanctioned.eventId`. `wipeLast` always clears both. They do not desync on current write sites.

3. **Outsider / failed-`writeBoth` last is still unpinned.** Probe: failed same-id Sanction after a real ruling keeps last. Implementation is right.

4. **Missing-`AppendCeremony` last is still unpinned.** `clearLive` still runs.

5. **`{0,0}` ambiguity** is specified. Glue must key off `GetLastSanctioned() == nil`.

6. **Last is gone after `/reload`.** Memory-only is required. B10-INT / HUD must tolerate missing last.

7. **Nested `runLastPair`.** Isolation wrap was not moved.

8. **Checked-in `.diff` is stale.** Live exclusive files are the review source.

9. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **505 / 0** was re-run here. Persist paint is B10-B / B10-C / B10-INT.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

`EndEvent` → `StartEvent` pin **exists** in `tests/test_gora.lua`: ruling, same-event last asserted, `Runtime:EndEvent()`, `Runtime:StartEvent()`, **no** `GetLast*` in QUIET, then first `GetLastSanctioned()` is nil and first `GetLastFavorSplit()` is `{0,0}`.

Last is wiped when event ids differ. `clearLive` stores the sanctioned `eventId`. `_Expire` calls `wipeLast()` when a live event id exists and it is not that id. A new ASSEMBLY does not inherit the previous bout.

Isolated `lua tests/test_gora.lua` **505 passed, 0 failed**, exit 0. Do not claim V1 / MVP complete. This rereview does not sign the lane.
