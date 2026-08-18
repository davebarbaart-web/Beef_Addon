Spec PASS

# B34-D — SendSnapshot destName before encode (review)

**Quality:** Approved-with-nits

**Lane:** B34-D SendSnapshot destName before encode
**Brief:** `docs/reformation/vestments/briefs/B34-D-snapshot-dest.md`
**Writer report:** `docs/reformation/vestments/briefs/B34-D-snapshot-dest-report.md`
**Diff:** `docs/reformation/vestments/briefs/B34-D-snapshot-dest.diff` (B34-D-only exclusive-pair packet; live `BeefNet.lua` / `test_net_v2.lua` vs HEAD also carry earlier BeefNet batches)
**Exclusive files:** `addon/ChurchOfBeef/Net/BeefNet.lua`, `tests/test_net_v2.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `Net/BeefNet.lua` (`destName` ~86, `_LocalPope`, `SendSnapshot` ~356–372, `_TransmitWhisper` destName, `C_ChatInfo.SendAddonMessage(..., "WHISPER", target)`), live `tests/test_net_v2.lua` (nested snapshot dest `do`/`end` immediately after the B33-D block, unstubbed `"not a registered pope"` pins, stubbed `"no target"` + `EncodeSnapshot` spy count 0, `"  Host  "` spy `"Host"`, payload `1:SNAPSHOT:request`, isolation re-pins), and live `Net/Codec.lua` / `Net/Snapshot.lua` (`SNAPSHOT_REQ_KEYS` / `SNAPSHOT_RES_KEYS` — no dest token; neither file contains `dest`); then ran `lua tests/test_net_v2.lua` (**682 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Anniversary `C_ChatInfo.SendAddonMessage(prefix, message, chatType, target)` — target is the whisper dest; License 2 / Bible §13.1 (Pope client is the snapshot writer; caller supplies dest; no Pope-name lookup). `_LocalPope()` stays first. Then `destName(target)`; empty after trim is `"no target"` and does not `EncodeSnapshot`. Then encode + `_TransmitWhisper`. `_TransmitWhisper` still trims. No dest on SNAPSHOT body. No Pope-name lookup. Exclusive files only. Did not mutate `BeefNet.lua` or `test_net_v2.lua`. Did not commit. Did not edit Codec, Snapshot, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `_LocalPope()` no longer first; existing non-pope pins flip to `"no target"` | **Pass. Verified.** Live `SendSnapshot` returns `"not a registered pope"` before `destName`. Brief L11 vs `BeefNet.lua` ~357–359. Existing suite pins (`"LateJoin"`, `"Pope"`, no fields, `"Steakina"`) stay above the nest. B34-D re-pins whitespace / `""` / nil / `"  Host  "` as `"not a registered pope"`. Reviewer probe: unstubbed `"  Host  "` is `"not a registered pope"`, encode 0, no `SendAddonMessage`. |
| Whitespace dest still `EncodeSnapshot` then dies at `_TransmitWhisper` | **Pass. Verified.** Brief L11 vs `BeefNet.lua` ~360–367: `target = destName(target)`; `if not target` is `"no target"` before the codec check / `EncodeSnapshot`. Pins: stubbed `"   "` / `" "` / `""` / nil — `false`, `"no target"`, spy count 0, `#wire == 0`, `sent == 0`. Reviewer probe: same four plus tab / newline; `C_ChatInfo` path with `Net.transmit` nil is **0** `SendAddonMessage` calls. |
| dest lands on the SNAPSHOT body / Codec or Snapshot edited | **Pass. Verified.** `SendSnapshot` passes caller `fields` through. Packet does not touch `Codec.lua` / `Snapshot.lua`. Live `SNAPSHOT_REQ_KEYS` / `SNAPSHOT_RES_KEYS` have no `dest`. `rg '\bdest\b'` on both files is empty. Suite payload stays `1:SNAPSHOT:request`; `Decode(...).dest` is nil. Reviewer probe: encode fields have no dest; `fields.dest = "Sneaky"` is existing Codec `"unknown field"` and does not `SendAddonMessage`. |
| Pope-name lookup | **Pass. Verified.** `destName` only calls `Names.Trim` or local `trim`. `SendSnapshot` source has no `LookupPope` / `FindPope` / `COB.Popes`. File-wide BeefNet grep is empty. Suite pins `Net.LookupPope` / `Net.FindPope` nil and unstubbed `IsRegisteredPope` false. Nested block re-pins `COB.Popes` nil. Stub is the later decree pattern (`Names.Key(sender) == "beefina"`), not a dest lookup. Whisper dest stays caller-supplied `"Host"`. |
| Exclusive breach / Codec / Snapshot / glue edited | **Pass.** Provided packet is two hunks: `SendSnapshot` destName gate + comment, and the nested B34-D pins after B33-D. Sibling dirt vs HEAD is earlier batches — no dest field, not this packet. Glue / TOC / bootstrap / `run.lua` / Codec / Snapshot are not in the packet. |
| Isolated suite not exit 0 | **Pass. Verified.** 682 passed, 0 failed. Writer-reported count matches. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Codec.lua / Snapshot.lua / glue; no commit; no dest on any codec payload | **Pass.** Named-risk check. Brief L3 / L5. |
| Isolation wrap stays (Common + Runtime + Codec + Snapshot + Sender + BeefNet) | **Pass.** Six `dofile`s unchanged. Wrap is still **11** nil-module pins under `if standalone then` at file load. Nested B33-D and B34-D blocks each re-pin Store / UI / Popes / Gora / Confession (**5**). |
| Keep `_LocalPope()` first; existing non-pope `SendSnapshot` pins stay `"not a registered pope"` | **Pass.** Brief L11 / L15 vs `BeefNet.lua` ~357–359 and the unstubbed B34-D pins. |
| Then `destName(target)`; empty after trim is `"no target"` and does **not** `EncodeSnapshot` | **Pass.** Brief L11 vs `BeefNet.lua` ~360–363. Spy count 0 on stubbed whitespace / `""` / nil. |
| Then encode + `_TransmitWhisper`; `_TransmitWhisper` still trims | **Pass.** Brief L11 vs `BeefNet.lua` ~364–371 and `_TransmitWhisper` ~242. `"  Host  "` spy / `C_ChatInfo` target is `"Host"`. |
| No dest on SNAPSHOT body | **Pass.** Brief L11 / L5. Named-risk check. |
| Tests after the B33-D block. Stub `IsRegisteredPope` true: whitespace / `""` / nil is `"no target"`, no encode, no whisper. `"  Host  "` may encode and transmit with target `"Host"` (`role = "request"` is enough). Isolation wrap stays. No Pope-name lookup | **Pass.** Brief L15. Nest starts at the B34-D banner immediately after B33-D's `end`. |
| `lua tests/test_net_v2.lua` exit 0 | **Pass.** **682 / 0.** |

License 2 / Bible §13.1 hold on the exclusive pair: dest is the Anniversary whisper `target` argument, not a SNAPSHOT field, and not a Pope-name lookup. The B33-D leftover (Pope-gated `SendSnapshot` encoded a whitespace dest, then `_TransmitWhisper` refused) is closed.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; Anniversary `SendAddonMessage(..., "WHISPER", target)` with a trimmed SendSnapshot dest is unsmoked | **Not a miss.** Brief asked the isolated suite. Reviewer `C_ChatInfo` spy proves the trimmed target; it does not prove the client whisper. |
| Double trim on the happy path (`SendSnapshot` destName then `_TransmitWhisper` destName) | **Required.** Brief L11: `_TransmitWhisper` still trims. |
| `{ role = "request" }` is a test body | **On contract.** Brief L15 allowed it. |
| Full `lua tests/run.lua` was not run | **Not a miss.** Brief asked the isolated suite. |
| Gate W / Gate V stay OPEN; not signed | **On contract.** This review does not sign the lane. |

B34-INT glue is not required. Dest trim on `SendSnapshot` lives in the exclusive pair.

---

## Isolation / destName / gates

**Isolation wrap — Pass.** Load list is still Common + Runtime + Codec + Snapshot + Sender + BeefNet. No `dofile` of Store / UI / DB / Popes / Officer / Ranks / Archive / Recognition / Gora / Decree / Confession. Standalone wrap is still **11** nils. Nested B33-D and B34-D blocks each re-pin five of them. Wrap is load-time only (unchanged).

**destName — Pass.** Helper is the existing `local function destName` (~86). `debug.getupvalue`: it is an upvalue of `SendSnapshot` and of `_TransmitWhisper`. Prefers `COB.Names.Trim` when that function exists; else the file-local `trim` (`^%s+` / `%s+$`, empty → nil). Does not call `Names.Display` / `Names.Key` / `LookupPope`. Reviewer probe: `"  Host-Whitemane  "` stays `"Host-Whitemane"` (trim only).

**Gates — Pass.** Pope gate first. dest refuse is before `EncodeSnapshot` / `sentCount` / `transmit` / `SendAddonMessage`. `"no codec"` stays after dest trim. SendState / SendDecree stay Pope-gated and GUILD. RequestSnapshot stays not Pope-gated. Immediate WHISPER, not the GUILD queue.

---

## Strengths

- Order matches the brief: `_LocalPope()` first, then destName, then encode. Non-pope whitespace stays `"not a registered pope"` instead of flipping to `"no target"`.
- Encode spy pins the actual B33-D leftover (whitespace dest encoded four times before `_TransmitWhisper` refused). Stubbed empty dest is now count 0.
- `"  Host  "` spy target is `"Host"`. SNAPSHOT payload stays `1:SNAPSHOT:request`. Decode `dest` is nil.
- `IsRegisteredPope` stub matches the later decree pattern and is restored. `LookupPope` stays nil. Isolation wrap stays. Nested `do`/`end` after B33-D.
- Packet does not rewrite Codec, Snapshot, or Pope-gated STATE / DECREE.
- Writer-reported **682 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Client Anniversary `SendAddonMessage(..., "WHISPER", target)` with a trimmed SendSnapshot dest is unsmoked.** The suite and reviewer spy prove the refuse / trim contract. They do not prove the client whisper.

### Nit

1. **Double trim on the happy path.** `SendSnapshot` destName then `_TransmitWhisper` destName again. Brief required the second trim.

2. **`if not target` depends on `destName` never returning `""`.** Local `trim` / `Names.Trim` already map empty to nil. A later Trim that returned `""` would be truthy and would encode, then die at `_TransmitWhisper`. Brief asked empty-after-trim = no encode; the current helpers hold that.

3. **Tab / newline dest is unpinned.** Lua `%s` trims them; reviewer probe refuses with encode 0. Brief named whitespace / `""` / nil.

4. **`fields.dest` on SendSnapshot is existing Codec `"unknown field"`.** Encode runs once, then refuse; no whisper. Exclusive lane correctly leaves Codec alone.

5. **Nested snapshot dest `do`/`end` still adds locals** toward the Lua 5.1 200-local cap. `luac -l -p` main chunk reports **159** locals (B33-D review was 152). Under the cap. Report's "no new main-chunk locals" is the nest tactic, not a zero add.

6. **Exclusive-pair diff is not a vs-HEAD BeefNet delta.** Both exclusive files are dirty vs HEAD from earlier batches. Packet is the B34-D-only gate + pins. Report already says this.

7. **Isolation wrap is load-only.** Eleven pins under `if standalone then` at file load. Brief said the wrap stays; it did.

8. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **682 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief L11 (`_LocalPope()` first, then `destName`; empty after trim is `"no target"` and does not `EncodeSnapshot`; then encode + `_TransmitWhisper`; no dest on SNAPSHOT body) matches `BeefNet.lua` ~356–372. Brief L15 pins sit in the nest after B33-D.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftover: client whisper unsmoked. Nits listed above.

**3. Isolation count:** **682 passed, 0 failed.** Isolation wrap: **11**.

**4. Law:** License 2 / Bible §13.1 hold. dest is the Anniversary whisper `target`, not a codec field. No Pope-name lookup. wow-api `classic_anniversary`: `C_ChatInfo.SendAddonMessage(prefix, message, [chatType], [target])` — target applies to targeted channels.

**Leftovers:**
- Client Anniversary `SendAddonMessage(..., "WHISPER", target)` with a trimmed SendSnapshot dest is unsmoked (Important, not must-fix).
- Double trim is required, not a miss.
- `if not target` depends on Trim returning nil, not `""`.
- Tab / newline dest is unpinned (reviewer probed; they refuse, encode 0).
- `fields.dest` is existing Codec `"unknown field"`; lane did not add dest to SNAPSHOT keys.
- Nested dest `do`/`end` still counts toward the 200-local cap (159).
- Exclusive-pair packet is not a vs-HEAD BeefNet delta.
- Isolation wrap is load-only.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

`SendSnapshot` keeps `_LocalPope()` first. Then `destName`; empty after trim is `"no target"` and does not `EncodeSnapshot`. `"  Host  "` spy target is `"Host"`. No dest on SNAPSHOT. No Pope-name lookup. Isolated `lua tests/test_net_v2.lua` **682 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. Do not claim Gate W, Gate V, or POLISH:PASS. This review does not sign the lane.
