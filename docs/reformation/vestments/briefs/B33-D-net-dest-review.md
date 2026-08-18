Spec PASS

# B33-D — BeefNet refuses a whitespace whisper dest (review)

**Quality:** Approved-with-nits

**Lane:** B33-D BeefNet refuses a whitespace whisper dest
**Brief:** `docs/reformation/vestments/briefs/B33-D-net-dest.md`
**Writer report:** `docs/reformation/vestments/briefs/B33-D-net-dest-report.md`
**Diff:** `docs/reformation/vestments/briefs/B33-D-net-dest.diff` (B33-D-only exclusive-pair packet; live `BeefNet.lua` / `test_net_v2.lua` vs HEAD also carry earlier BeefNet batches)
**Exclusive files:** `addon/ChurchOfBeef/Net/BeefNet.lua`, `tests/test_net_v2.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `Net/BeefNet.lua` (`destName`, local `trim`, `_TransmitWhisper`, `SendFavor` / `SendPetition` / `SendConfession` / `RequestSnapshot`, `SendSnapshot` / `_HandleSnapshot` reply, `C_ChatInfo.SendAddonMessage(..., "WHISPER", target)`), live `tests/test_net_v2.lua` (nested dest `do`/`end`, `"   "` / `" "` refuse, existing `""` / nil, `"  Host  "` spy `"Host"`, no dest on INPUT, Codec kinds, isolation re-pins), and live `Net/Codec.lua` (`INPUT_KEYS`, `EncodeInput` — no dest token); then ran `lua tests/test_net_v2.lua` (**632 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Anniversary `C_ChatInfo.SendAddonMessage(prefix, message, chatType, target)` — target is the whisper dest; License 2 / Bible §13.1 (congregation inputs to the Pope client; caller supplies dest; no Pope-name lookup); whitespace dest is no target and does not transmit. Trim via `Names.Trim` (fallback `^%s+` / `%s+$`). Empty after trim is `"no target"`. Existing `""` / nil pins stay. Codec kinds unchanged. No dest on INPUT. No Pope-name lookup. Exclusive files only. Did not mutate `BeefNet.lua` or `test_net_v2.lua`. Did not commit. Did not edit Codec, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Whitespace dest still transmits (`target ~= ""`) | **Pass. Verified.** Live `destName` wraps `Names.Trim` (else local `trim`). Empty after trim is nil. `_TransmitWhisper` / `SendFavor` / `SendPetition` / `SendConfession` / `RequestSnapshot` assign `target = destName(target)` and refuse `nil` as `"no target"` before `sentCount` / `transmit` / `SendAddonMessage`. Pins: `"   "` and `" "` on the four named senders plus `SendFavor` — `false`, `"no target"`, `#wire == 0`, `sent == 0`. Reviewer probe: tab / newline dest also refuse; `C_ChatInfo` path with `Net.transmit` nil is **0** `SendAddonMessage` calls and `sentCount == 0`; `lastSent` stays nil. |
| dest lands on the INPUT payload / extra Codec field | **Pass. Verified.** `SendPetition` / `SendConfession` / `SendFavor` build a body of kind+id (+ opponent / text / pick). Packet does not touch `Codec.lua`. Live `INPUT_KEYS` has no `dest`. Suite payloads stay `1:INPUT:petition:12`, `1:INPUT:confession:3:free text`, `1:INPUT:favor:2:1`. Reviewer probe: `fields.dest = "Sneaky"` still wires `1:INPUT:petition:12` with spy target `"Host"`; `Codec:EncodeInput({ dest = "Host", ... })` is `"unknown field"` (existing Codec, not this lane). `source` grep of `Codec.lua` has no `dest` token. |
| Pope-name lookup | **Pass. Verified.** `destName` only calls `Names.Trim` or local `trim`. Source has no `LookupPope` / `FindPope` / `COB.Popes` read. Suite pins `Net.LookupPope` / `Net.FindPope` nil and `Sender:IsRegisteredPope(Net:PlayerName()) == false`. Nested dest block re-pins `COB.Popes` nil. Reviewer probe: `Net.LookupPope` / `Net.FindPope` / `COB.Popes` stay nil. Congregation whisper is still not Pope-gated. |
| Exclusive breach / Codec edited | **Pass.** Provided packet is two hunks: `destName` + five dest gates, and the nested dest pins. Sibling dirt vs HEAD (`Codec.lua` opponent / decree / state) is earlier batches — no dest field, not this packet. Glue / TOC / bootstrap / `run.lua` are not in the packet. |
| Isolated suite not exit 0 | **Pass. Verified.** 632 passed, 0 failed. Writer-reported count matches. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Codec / glue; no commit | **Pass.** Named-risk check. |
| Isolation wrap stays (Common + Runtime + Codec + Snapshot + Sender + BeefNet) | **Pass.** Six `dofile`s unchanged. Wrap is still **11** nil-module pins under `if standalone then` at file load. Nested dest block re-pins Store / UI / Popes / Gora / Confession (**5**). |
| Trim dest (`Names.Trim` or `^%s+` / `%s+$`); empty after trim is `"no target"` and does not transmit | **Pass.** Named-risk check. `"  Host  "` spy target is `"Host"`. |
| `_TransmitWhisper` / `SendPetition` / `SendConfession` / `RequestSnapshot` refuse `"   "` / `" "` | **Pass.** Named-risk check. `SendFavor` also gated (extra, exclusive). |
| Existing `""` / nil pins stay | **Pass.** Nested dest block re-asserts `""` / nil on SendPetition / `_TransmitWhisper` / SendFavor / SendConfession / RequestSnapshot. Earlier suite pins stay above the nest. |
| Codec kinds unchanged; no extra codec field; no dest on INPUT | **Pass.** Named-risk check. |
| No Pope-name lookup | **Pass.** Named-risk check. |
| Anniversary `SendAddonMessage` target is the whisper dest | **Pass.** `_TransmitWhisper` still `C_ChatInfo.SendAddonMessage(self.Prefix, payload, "WHISPER", target)` (legacy `SendAddonMessage` same arity). Reviewer probe: spy / `C_ChatInfo` target is the trimmed dest. wow-api `classic_anniversary`: `C_ChatInfo.SendAddonMessage(prefix, message, [chatType], [target])` — target applies to targeted channels. |
| `lua tests/test_net_v2.lua` exit 0 | **Pass.** **632 / 0.** |

License 2 / Bible §13.1 hold on the exclusive pair: dest is the whisper target, not a payload field, and not a Pope-name lookup. The old `target ~= ""` hole (`" "` sent) is closed on the named senders and on `_TransmitWhisper`.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; Anniversary `SendAddonMessage(..., "WHISPER", target)` with a trimmed dest is unsmoked | **Not a miss.** Brief asked the isolated suite. Reviewer `C_ChatInfo` spy proves the trimmed target; it does not prove the client whisper. |
| `SendSnapshot` still has no early `destName`; `_TransmitWhisper` still trims if a stubbed Pope send reaches it | **On contract.** Brief named `_TransmitWhisper` / SendPetition / SendConfession / RequestSnapshot. Reviewer probe: Pope-stubbed `SendSnapshot("   ")` is `false`, `"no target"`, `sentCount == 0`; padded dest spy is `"Host"`. |
| Inbound snapshot reply now passes `sender` through `destName` | **On contract / wording.** Packet does not change `_HandleSnapshot`. Reply still `_TransmitWhisper(blob, sender)`, so dest trim is the existing whisper gate. A real CHAT_MSG_ADDON sender is unchanged. Pure-whitespace sender never reaches the reply: `_AllowInbound` `nameKey` is nil (`"sender is talking too fast"`). Padded `"  Host  "` reply spy is `"Host"`. |
| Full `lua tests/run.lua` was not run | **Not a miss.** Brief asked the isolated suite. |
| Gate W / Gate V stay OPEN; not signed | **On contract.** This review does not sign the lane. |

B33-INT glue is not required. Dest trim lives on the whisper send path.

---

## Isolation / destName / gates

**Isolation wrap — Pass.** Load list is still Common + Runtime + Codec + Snapshot + Sender + BeefNet. No `dofile` of Store / UI / DB / Popes / Officer / Ranks / Archive / Recognition / Gora / Decree / Confession. Standalone wrap is still **11** nils. Nested dest block re-pins five of them. Wrap is load-time only (unchanged).

**destName — Pass.** Helper is `local function destName`. `debug.getupvalue`: it is an upvalue of `SendFavor`, `SendPetition`, `SendConfession`, `RequestSnapshot`, and `_TransmitWhisper`. Prefers `COB.Names.Trim` when that function exists; else the file-local `trim` (`^%s+` / `%s+$`, empty → nil). Does not call `Names.Display` / `Names.Key` / `LookupPope`. Reviewer probe: `"  Host-Whitemane  "` stays `"Host-Whitemane"` (trim only).

**Gates — Pass.** dest refuse is before `sentCount` / `transmit` / `SendAddonMessage`. Payload empty / too-large gates on `_TransmitWhisper` stay first. SendState / SendDecree stay Pope-gated. RequestSnapshot body is still `Snapshot:Request()` / `1:SNAPSHOT:request`. Immediate WHISPER, not the GUILD queue. Size cap 240 stays.

---

## Strengths

- One helper, used on early refuse and on `_TransmitWhisper`, so a later whisper caller cannot skip the trim.
- `"   "` / `" "` / `""` / nil are pinned not to increment `sent` / `#wire`. `"  Host  "` spy target is `"Host"` on all five whisper paths.
- INPUT payloads stay kind+id (+ pick / text / opponent). dest is the Anniversary whisper `target` argument only.
- `LookupPope` stays nil. Isolation wrap stays. Nested dest `do`/`end` after RequestSnapshot.
- Packet does not rewrite Codec, Snapshot request body, or Pope-gated STATE / DECREE.
- Writer-reported **632 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Client Anniversary `SendAddonMessage(..., "WHISPER", target)` with a trimmed dest is unsmoked.** The suite and reviewer spy prove the refuse / trim contract. They do not prove the client whisper.

2. **`SendSnapshot` has no early `destName`.** Pope-gated first; encode then `_TransmitWhisper`. Whitespace still refuses (reviewer probe). Out of this lane's named senders.

### Nit

1. **`if not target` depends on `destName` never returning `""`.** Local `trim` / `Names.Trim` already map empty to nil. A later Trim that returned `""` would be truthy and would transmit. Brief asked empty-after-trim = no target; the current helpers hold that.

2. **Tab / newline dest is unpinned.** Lua `%s` trims them; reviewer probe refuses. Brief named `" "` / `"   "`.

3. **Writer leftover overstates inbound destName.** Packet does not pass `sender` through `destName` at `_HandleSnapshot`. Pure-whitespace inbound dies at `_AllowInbound` (`nameKey` nil → `"sender is talking too fast"`), not `"no target"`.

4. **Nested dest `do`/`end` still adds main-chunk locals** (`space`, `hostPad`, `ok`, `why`) toward the Lua 5.1 200-local cap. `luac -l -p` main chunk reports **152** locals. Under the cap. Report's "no new main-chunk locals" is the nest tactic, not a zero add.

5. **`fields.dest` on SendPetition is silently dropped** (body rebuild). Codec `EncodeInput` would say `"unknown field"`. Exclusive lane correctly leaves Codec alone.

6. **Exclusive-pair diff is not a vs-HEAD BeefNet delta.** Both exclusive files are dirty vs HEAD from earlier batches. Packet is the B33-D-only helper + pins. Report already says this.

7. **Isolation wrap is load-only.** Eleven pins under `if standalone then` at file load. Brief said the wrap stays; it did.

8. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **632 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **632 passed, 0 failed.** Isolation wrap: **11**.

**Leftovers:**
- Client Anniversary `SendAddonMessage(..., "WHISPER", target)` with a trimmed dest is unsmoked (Important, not must-fix).
- `SendSnapshot` has no early `destName`; `_TransmitWhisper` still refuses whitespace (Important, not must-fix).
- `if not target` depends on Trim returning nil, not `""`.
- Tab / newline dest is unpinned (reviewer probed; they refuse).
- Inbound whitespace sender dies at `_AllowInbound` / `nameKey`, not destName; packet did not change `_HandleSnapshot`.
- Nested dest `do`/`end` still counts toward the 200-local cap (152).
- `fields.dest` is dropped by the Send* body rebuild; Codec unknown-field stays out of this lane.
- Exclusive-pair packet is not a vs-HEAD BeefNet delta.
- Isolation wrap is load-only.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

Whitespace dest (`" "` / `"   "`) on `_TransmitWhisper` / `SendPetition` / `SendConfession` / `RequestSnapshot` (and `SendFavor`) is `"no target"` and does not transmit. `"  Host  "` spy target is `"Host"`. No dest on INPUT. No Pope-name lookup. Codec untouched. Isolated `lua tests/test_net_v2.lua` **632 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
