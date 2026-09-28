# Task 9 review — Latest-wins without dropping favor

**Scope (this gate only):** live `Runtime:Restore` Option C gate; `Snapshot:ApplyResponse` via Restore; `_HandleState` return as overlay gate; I-06 invert in `tests/test_ceremony_chaos.lua`; favor overlay pins in `tests/test_net_v2.lua`; `DropToQuietForVersion` still lands Quiet (`newEvent` `eventId` nil is a different id). Task 7 skew drop and Task 8 packed names / stash / #111 must still hold.

Must hold: PROTOCOL 2, SCHEMA 7, Interface 20506, favor is not a Runtime field, no inbound Proclaim, no schema 8, I-06 leftovers inverted (not reverted to ungated rewind).

Full `lua tests/run.lua` was not re-run (per gate instruction). Working tree was not mutated except this review file.

**Spec-compliance:** PASS

**Task quality:** Approved

The implementer report matches the live tree. Ceremony applies on a new `eventId` or a greater sequence. Equal sequence is a no-op that still returns ok so favor overlay can paint. Older same-`eventId` is `nil, "stale sequence"` so favor is not overlaid. I-06 leftover rewind is inverted. `#27` unanswered.

---

## Verdict

Task 9 matches the brief, plan §3 Option C, and pin catalog I-06. RecordFavor STATE at the current sequence is no longer dropped. Older Apply/Restore no longer rewind CONSEQUENCE / seq 3 / Gora. Task 7 Quiet drop and Task 8 names were not reverted.

---

## Spec Compliance

| Pin | Result | Evidence |
|-----|--------|----------|
| Ceremony applies only if `sequence` is **greater** (same `eventId`) | Met | `Runtime:Restore`: same `eventId` + `sequence < current` → `nil, "stale sequence"`; `>` replaces the event object. `test_runtime.lua` older / greater pins. Chaos + snapshot Apply go through Restore |
| Equal sequence: no ceremony apply; return **ok** (favor overlay uses `>=`) | Met | Same `eventId` + equal seq `return true` without writing Bible fields. Hijack fighters `{1,2}` stay `{8,9}` in runtime, chaos, snapshot, and `test_net_v2`. Bootstrap / isolated wrap is `if ok then` paint |
| Older same `eventId`: do not apply; do not overlay | Met | Restore not-ok `"stale sequence"`. `_HandleState` returns that result. Isolated favor spy: `#favorSpy == 0`. Ceremony stays RITE / seq 2 (v2) or CONSEQUENCE / seq 3 / Gora (chaos) |
| Different `eventId` still applies (smaller seq is not a rewind of event 1) | Met | `parsed.eventId == ev.eventId` is the only compare. Chaos + runtime + v2 land a new ASSEMBLY / RITE at seq 1. Named SNAPSHOT Apply lands from QUIET (`nil` vs `1`) |
| `DropToQuietForVersion` still works | Met | `newEvent()` is QUIET / `eventId` nil / seq 0. Live Event Mode has an integer id, so nil is a different `eventId` and Restore applies. I-03 still QUIET / nil id / seq 0. `test_runtime.lua`: drop from RITE then next `StartEvent` is event 2 (`nextEventId` kept) |
| I-06 invert in `tests/test_ceremony_chaos.lua` | Met | Header is latest-wins, not “Do NOT invent a monotonic-sequence gate.” Older Apply/Restore do not rewind; later CONSEQUENCE / seq 3 / Gora remain. Equal seq does not replace fighters and does not Proclaim / Sound. Different `eventId` applies |
| Favor overlay pins in `tests/test_net_v2.lua` | Met | Accept stub + `_HandleState` `if ok` spy: greater applies ceremony + favor; equal paints later `{4,3}` without moving fighters; older is `"stale sequence"` and does not overlay; different `eventId` overlays. `Snapshot().favor` is nil |
| Favor is not a Runtime field | Met | `parseEvent` copies only Bible fields (+ `awaitingPope`). Restore never writes favor. Snapshot `bibleFields` is the five Bible keys. Apply / STATE Restore leave `favor` nil |
| Snapshot Apply uses the same rule | Met | `ApplyResponse` Restores `bibleFields(msg)` after the compatible decode. Snapshot suite: older `"stale sequence"`; equal hijack ok, fighters unchanged |
| No inbound Proclaim; `#27` unanswered | Met | Net / Snapshot / Runtime have no `Toasts` / `Proclaim` / `Sound`. Bootstrap `proclaim` is Pope verb wraps only (`sanction` / `knighting` / `elevation` / `verdict` / `cowardice`). Inbound `_HandleState` paints favor / stash / card, not Proclaim. `OPEN_QUESTIONS.md` #27 still unanswered |
| PROTOCOL 2; SCHEMA 7; Interface 20506 | Met | `Codec.PROTOCOL = 2`, `Net.PROTOCOL = 2`. `DB.lua` `SCHEMA_VERSION = 7`. TOC `## Interface: 20506`. Task 7 I-02 / I-03 Quiet drop still live (`"version skew drops the live event"` / rite) |
| Task 8 names / stash / #111 not reverted | Met | `STATE_KEYS` / `SNAPSHOT_RES_KEYS` still allowlist `names`. Encode still always emits the field. `stashInboundCast` + `#111` dismissed flag still on the inbound wrap. `MAX_BODY` still 240. Named SNAPSHOT still lands from QUIET so names stay off Restore |
| Option C (not A/B) | Met | Gate is inside Restore. Overlay stays Net/bootstrap on Restore’s ok. Chaos `Restore(earlySnap)` is gated. Equal is ok; older is not-ok. No structured Restore result beyond that split |
| Do-not: schema 8, clerical beat, congregation Ensure, commit | Met | No SCHEMA 8. No `kind` / `beat` on STATE. No `EnsureCharacterByName`. Report: no commit. Hud.lua / FighterCard.lua untouched (fixture seq bump only) |

---

## Strengths

- Option C is the table, not a ceremony-only `seq >` that would drop RecordFavor. Equal ok / older not-ok is the exact glue `_HandleState` already returned into `if ok then paintInboundFavor`.
- I-06 is a real invert. CONSEQUENCE / seq 3 / Gora stay after both Apply and Restore of the early ASSEMBLY blob. Different-fighters equal-seq is pinned, not only “replay the same object.”
- `DropToQuietForVersion` did not need a special case. Quiet `eventId` nil vs a live integer id is the different-`eventId` rule the brief named.
- Task 7 and Task 8 neighbors stayed. Foreign-major still drops to Quiet. Packed names still encode; Apply still drops them. SCHEMA stays 7.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Chaos older-err is `type == "string"`, not `"stale sequence"`.** Runtime, snapshot, and `test_net_v2` pin the exact reason. The I-06 leftover invert does not. Shape is the same path.

2. **Equal-seq “must not theater” is a spy on a path that never Proclaim.** `ApplyResponse` / Restore do not call `Toasts` / `Sound`. Counts stay 0 because inbound theater is off this slice (#27), not because equal seq specially suppresses a beat.

3. **Isolated favor spy is glue-shaped, not `paintInboundFavor`.** `test_net_v2` wraps `_HandleState` the same `if ok` way as bootstrap. SNAPSHOT equal-seq favor is the same production `if ok` path and is not named-suite pinned (report leftover).

4. **`DropToQuietForVersion` would return `"stale sequence"` if current were QUIET + `eventId` nil + `sequence > 0`.** Live Event Mode and the Task 7 pins use an integer id or clean Quiet (nil / 0). EndEvent keeps the id. Not the night-one drop path.

5. **Equal-seq after `StartEvent` is a no-op.** Congregation catch-up must land from QUIET or use a greater sequence. Two Task 8 stash suites were bumped to seq 2. Report concern 1 is accurate, not a product miss.

6. **Full harness counts (16555 / 0) and client `/reload` were not re-checked.** Net + Core were touched. Isolated counts in the report were not re-run this pass.

---

## Assessment

**PASS / Approved.**

Latest-wins is Option C in Restore. Favor STATE at the current sequence still overlays. Older blobs do not rewind ceremony. I-06 is inverted. Favor is not a Runtime field. No inbound Proclaim. PROTOCOL 2. SCHEMA 7. Interface 20506. Task 8 names were not reverted.

Do not claim `POLISH:PASS`.
