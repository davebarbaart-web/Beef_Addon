# B15-INT — Line mutations send STATE

**Exclusive (integrator only):** `addon/ChurchOfBeef/ChurchOfBeef.lua`, `tests/test_wire_glue.lua`

Writers must not edit these files.

## Law

B14-INT overlays the line head on STATE when Runtime lacks a candidate. Enqueue / Skip / Insert / KnightThisBeef / ElevateToLord change that head but do not broadcast. Congregation already in the event keeps a stale candidate until some other SendState.

`wrapAfter` already sends only when `result ~= nil`. Add:

- `wrapAfter(COB.Knighting, "Enqueue", sendState)`
- `wrapAfter(COB.Knighting, "Skip", sendState)`
- `wrapAfter(COB.Knighting, "Insert", sendState)`
- `sendState()` at the end of the existing KnightThisBeef and ElevateToLord after-fns

Do not add a Console-only wrap. Do not send on failed verbs. Last pair still stays off post-Continue ASSEMBLY. Candidate overlay rules unchanged.

## Tests

Append after the B14 `do` block (another `do` — no new main-chunk local). Isolation wrap stays.

1. Stubbed Pope + StartEvent + `Knighting:Enqueue(human)` → last STATE `subjects.candidate` is that human. Runtime candidate still nil.
2. Enqueue a second human, `Skip` the first → last STATE candidate is the remaining head.
3. Failed Enqueue (already Lord) does not add a STATE.
4. Existing B14 Gora-RITE-no-candidate and post-Continue pins still pass.

Full harness `lua tests/run.lua` exit 0. Do not tick walk boxes. Do not claim Gate W / Gate V / POLISH:PASS.
