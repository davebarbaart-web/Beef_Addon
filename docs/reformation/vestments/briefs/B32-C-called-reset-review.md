Spec PASS

# B32-C — Latest confession line clears called (review)

**Quality:** Approved-with-nits

**Lane:** B32-C Latest confession line clears called
**Brief:** `docs/reformation/vestments/briefs/B32-C-called-reset.md`
**Writer report:** `docs/reformation/vestments/briefs/B32-C-called-reset-report.md`
**Diff:** `docs/reformation/vestments/briefs/B32-C-called-reset.diff` (B32-C-only exclusive-pair packet; both files were untracked before this lane)
**Exclusive files:** `addon/ChurchOfBeef/Core/Confession.lua`, `tests/test_confession.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `Core/Confession.lua` (`Receive` existing-row overwrite / new-row insert / `CallForward` / `Dismiss` / `_Expire` / `copyRow` / `parseText`), and live `tests/test_confession.lua` (B32-C pins after the CallForward first-arrival, isolation wrap, B4 Quiet / Dismiss / rite-survival / wipe / source-negative pins); then ran `lua tests/test_confession.lua` (**184 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: header “Latest line replaces.”; Bible §9 (software organizes the queue; it does not write the Pope’s response); §13.4 (free text stays on the Pope desk; no theater); Law 4; B4 leftover (`Receive` overwrite left `called`, so after Call Forward a new line still painted mute `"  called"`). When replacing an existing inbox row, set `called = false` and keep `seq`. New rows stay `called = false`. `CallForward` still sets `called = true`. `Dismiss` still removes. Empty / whitespace still no-text. No fan-out. No theater. Did not mutate `Confession.lua` or `test_confession.lua`. Did not commit. Did not edit Console, Net, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Latest `Receive` on an existing id leaves `called` stuck (B4 leftover; mute `"  called"` survives a new line) | **Pass. Verified.** Existing-row `Receive` writes `text` / `eventId` then `existing.called = false`. Suite: CallForward first-arrival → Receive same id → return copy and `GetQueue()[1]` are `called == false` with the new line. Reviewer probe: same-text replace also clears `called`. |
| Replace reassigns `seq` / increments `nextSeq` so oldest-first jumps | **Pass. Verified.** Existing-row branch does not name `seq` or `nextSeq`. Pins: queue length stays 2; tender stays first; chuck stays second; CallForward after replace does not reorder; whitespace replace does not jump. Reviewer probe: three later arrivals stay behind the replaced first row; a fourth new id is newest. |
| Replace clears `called` on every inbox row (fan-out of the mark) | **Pass. Verified.** Only `existing` is written. Suite pins the other row `called == false` (that row was never called). Reviewer probe: CallForward Alpha, Receive Bravo → Alpha stays `called == true`, Bravo text updates, Charlie untouched. |
| Empty / whitespace become refuse, or store text | **Pass. Verified.** `"   "` and omitted text still accept, `text == nil`, and also clear `called`. Brief Tests line said “refused”; Law / header / B4 contract are “no-text.” Writer followed Law. Newline / non-string still `nil, "invalid text"`. |
| Refused newline / non-string still mutates the row (false replace) | **Pass. Verified.** `textErr` returns before the existing-row write. Pre-existing pins: refused newline does not rewrite inbox text. Reviewer probe: CallForward then `"bad\nline"` leaves `called == true` and the earlier line. |
| `CallForward` no longer marks, or now announces / fans out | **Pass.** `CallForward` is still `entry.called = true`. After replace it still marks and does not reorder. Pre-existing spies stay at 0 chat / addon / Proclaim / Play. Source has no `SendChatMessage` / `SendAddonMessage` / `COB.Toasts` / `COB.Sound` / `COB.Net`. Reviewer probe: Receive replace under planted spies stays mute. |
| `Dismiss` no longer removes; new rows start `called = true` | **Pass.** `Dismiss` still nils the inbox key. New-row constructor still `called = false`. Pre-existing Dismiss / new-row pins stay. |
| Theater / fan-out / Core→UI | **Pass.** Live source has no `CreateFrame`, chat, addon message, SV, `PlaySound`, Toasts, Sound, Net, Penance, or `Grant(`. Public surface still has no `FanOut` / `Broadcast` / `Proclaim`. |
| Isolation wrap rewritten / suite not exit 0 / exclusive breach | **Pass. Verified.** **184 / 0.** Wrap stays under the first `if standalone then` (**19** nil pins). Load list stays wow_stub + Common + Store + Runtime + Confession. Packet is one Core line plus the B32-C pin block and one source pin. Sibling dirt (Console B32-B, Hud, Markers, glue) is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Console, Net, glue; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| When replacing an existing inbox row, set `called = false` | **Pass.** Named-risk check. |
| Keep `seq` so order does not jump | **Pass.** Named-risk check. Order is pinned by `GetQueue` position; public copy still omits `seq`. |
| New rows stay `called = false` | **Pass.** Constructor unchanged. |
| `CallForward` still sets `called = true` | **Pass.** Named-risk check. |
| `Dismiss` still removes the row | **Pass.** Named-risk check. |
| Empty / whitespace still no-text | **Pass.** Accepted; `text == nil`; replace also clears `called`. |
| No theater. No fan-out. No Toasts. No Sound | **Pass.** Named-risk check. |
| Tests: Receive, CallForward, Receive same id → `called == false`, new line, seq/order unchanged | **Pass.** B32-C block reuses the called first-arrival. |
| Isolation wrap stays; `lua tests/test_confession.lua` exit 0 | **Pass.** **184 / 0.** Isolation wrap **19**. |

Bible §9 holds on the exclusive pair: software organizes the queue (latest line replaces; the called mark resets so the desk does not keep a stale “already called”) and still does not write the Pope’s response. §13.4 / Law 4 hold: `Receive` does not announce, toast, sound, or fan out. The B4 leftover (`Receive` overwrite left `called`) is closed on Core.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Console paint is not this lane. B20-A appends mute `"  called"` from `row.called` | **Not a miss.** Exclusive pair is Core + this suite. After this fix `GetQueue` returns `called == false` on a later line; the next Console Refresh should drop the token. Desk is unproven here. Do not expand exclusive to Console (B32-B is the sibling desk lane). |
| No client smoke | **Not a miss.** Brief asked isolated green. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked `lua tests/test_confession.lua`. |
| `seq` is not on the public copy row | **On contract.** Brief said keep `seq` so order does not jump. Pins are `GetQueue` position. `copyRow` still omits `seq` (B4). |
| `GetQueue` still has no present-and-alive filter | **Out of brief.** B4 leftover. |
| B32-B Console `Dismiss` of a confession is a sibling lane | **On contract.** This Core `Dismiss` is unchanged. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / replace / keep

**Isolation wrap — Pass.** Load list is still wow_stub + Common + Store + Runtime + Confession. No `dofile` of Console, Net, glue, UI, Toasts, or Sound. Standalone wrap is still **19** nils (Net, UI, DB, Officer, Archive, Recognition, Popes, Sender, Codec, Snapshot, Gora, Knighting, Toasts, Sound, Console, Hud, Decree, Roster, Ranks). Wrap is load-time only (unchanged).

**Replace — Pass.** Existing-row `Receive` overwrites `text` and `eventId`, sets `called = false`, and returns a `copyRow`. `seq` is untouched. Same-id after CallForward stores the new line, stays oldest, and does not add a row. Whitespace / omitted still store no text (`Names.Trim` → nil) and also clear `called`. Newline / non-string still refuse before the write.

**Keep — Pass.** New rows still `called = false` and take `nextSeq`. `CallForward` still marks and does not announce. `Dismiss` still removes. Quiet / missing `eventId` still refuse. OpenRite / CONSEQUENCE / Continue still keep. EndEvent / missing eventId still wipe. Oldest-first `GetQueue` copies. Public row is still `{ characterId, text, called }`. `ResetForTests` still `_IN_TEST` only.

---

## Strengths

- The delta is the brief: one assignment on the existing-row path. `seq`, new-row insert, `CallForward`, `Dismiss`, `_Expire`, and `parseText` were left alone.
- B4 leftover (`Receive` overwrite kept `called`) is closed on the same CallForward first-arrival fixture, not a second queue language.
- CallForward-after-replace and order-after-replace sit next to the clear, so a replace that re-queued or a CallForward that stopped marking would fail.
- Empty / whitespace keep-pins sit next to the clear, so a writer who “refused” whitespace to satisfy the Tests-line typo would fail Law.
- Writer-reported **184 / 0** matched the re-run. Writer-reported red (**179 / 5**) matches the five asserts that a keep-`called` overwrite fails (`latest line clears called`; `GetQueue shows called cleared`; `whitespace replace also clears called`; `empty replace leaves called false`; `existing-row Receive clears called`). Order / text / CallForward-still-marks pins stay green without the one-liner.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Console paint is unproven.** B20-A appends mute `"  called"` when `row.called == true`. This Core `GetQueue` now returns `false` after a later line. The desk Refresh that would drop the token is not this exclusive pair. Do not expand to Console.

### Nit

1. **`seq` is not on the public copy.** Order is pinned by `GetQueue` position only. A replace that rewrote `seq` to the same numeric value would still pass. Live existing-row branch does not name `seq`. Reviewer probe: a later fourth arrival stays last.

2. **“Other row untouched” only pins `called == false` on a never-called chuck.** A blanket inbox `called = false` would still pass that assert. Reviewer probe closed the hole: CallForward Alpha, Receive Bravo leaves Alpha called.

3. **Refused newline after CallForward is un-pinned.** Pre-existing refuse pins are text-only and run before CallForward. Reviewer probe: `"bad\nline"` leaves `called == true`.

4. **B32-C Receive is not under the CallForward theater spies.** Those spies restore before the new block. End-of-file source pins plus a reviewer probe cover mute replace.

5. **Brief Tests line says “Empty / whitespace still refused.”** Law / header / B4 contract are no-text accept. Writer followed Law. Not a miss.

6. **Source pin is a literal `existing.called = false`.** It would miss `existing["called"] = false`. Live assignment is the literal.

7. **Isolation wrap is load-only.** Nineteen pins under the first `if standalone then`. Brief said the wrap stays; it did.

8. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **184 / 0** was re-run here. Anniversary Call Forward then a new confession line is unproven.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **184 passed, 0 failed.** Isolation wrap: **19**.

Existing-row `Receive` sets `called = false` after writing `text` / `eventId` and does not touch `seq`. New rows stay uncalled. `CallForward` still marks. `Dismiss` still removes. Empty / whitespace still store no text and also clear `called`. Newline / non-string still refuse. No theater. No fan-out. Isolated `lua tests/test_confession.lua` **184 passed, 0 failed**, exit 0.

Leftovers: Console paint / next Refresh that would drop `"  called"` is unproven (do not expand exclusive to Console); `seq` is not on the public copy (order pinned by position); `GetQueue` still has no present-and-alive filter; B32-B Console `Dismiss` is a sibling lane; no client smoke; full harness not run.

Do not claim V1 / MVP complete. This review does not sign the lane.
