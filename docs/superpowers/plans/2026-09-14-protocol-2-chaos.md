# PROTOCOL 2 + chaos invert inventory (Wave 2 Tasks 7 and 9)

**Date:** 2026-09-14  
**Status:** Options and invert inventory only. Not implementation. Do not edit addon Lua or tests from this file.  
**Slice:** `docs/superpowers/plans/2026-09-14-church-of-beef-first-night-wave-2.md` Tasks **7** and **9**.  
**Catalog:** `docs/superpowers/plans/2026-09-14-wave-2-pin-catalog.md` I-02, I-03, I-05, I-06 (I-04 noted only as a Task 7/8 boundary).  
**Review:** `docs/superpowers/specs/2026-09-14-church-of-beef-wave-2-review.md` §2.2.  
**Law:** Bible §13.4 / §20.3 / §21.3. Do **not** resolve OPEN_QUESTIONS **#27**.

**Does not:** implement Codec / Runtime / Net; add a clerical beat or inbound `Toasts:Proclaim`; invent `holdSeconds`; tick phase docs; claim `POLISH:PASS` / §22.3. Task **8** (packed names, 240-byte Send) is a neighbor, not this brief.

---

## Law the invert must satisfy

Bible **§13.4**:

> Every message carries a protocol version; clients on stale versions degrade to Quiet Mode with a gentle "the Church's software has advanced" notice rather than misrendering theater (§21.3).

Bible **§20.3** (same contract, update-notice wording):

> Version mismatch: protocol-versioned messages; stale clients drop to Quiet Mode with a gentle update notice rather than misrender theater (§13.4).

Task 7 requires both ideas in one Quiet notice: **the Church's software has advanced** + **update the addon**. Once per session. No toast family. The notice is the Law 6 Quiet exception (`quiet-event-modes.mdc`), not a `Toasts` kind.

Live `_WarnVersion` (`addon/ChurchOfBeef/Net/BeefNet.lua`) does **not** meet that copy, and does **not** drop Event chrome:

```lua
function Net:_WarnVersion(version)
  if self.warnedVersion then return false end
  self.warnedVersion = true
  chat(string.format(
    "a guildmate is running BeefNet v%s; this client speaks v%d. Update for matching addon messages.",
    tostring(version), self.PROTOCOL))
  return true
end
```

The latch (`warnedVersion`) and “chat once” shape stay. The engineer sentence is not law. Pin catalog I-02: keep discard reason `"protocol mismatch"`; keep once-per-session; keep no toast.

Review **§2.2** (why Task 9 cannot be `seq >` alone):

> Latest-wins as `seq > current` **drops every favor STATE and every HELLO refresh** (`RecordFavor` does not increment sequence).

Task 9: ceremony fields apply only if `sequence` is **greater**; favor overlay when `eventId` matches and `sequence >= current`; different `eventId` still applies; equal sequence must not fire theater; invert the chaos rewind pin; Snapshot `ApplyResponse` uses the same rule.

---

## 1. Fixtures that assume PROTOCOL 1 or “skew keeps theater”

Already inverted: **none**. Companion `1:` / `2:` wire literals are fixtures of **I-05**, not extra pins.

### 1.1 Named inverts (must flip meaning)

Quoted from the live suites.

**I-05 — `PROTOCOL` stays 1; protocol 2 is the foreign major**

```lua
-- tests/test_net_codec.lua
assert_eq(Codec.PROTOCOL, 1, "protocol major stays 1; v2 is the vocabulary")
assert_eq(quietMsg.version, 1, "every message carries a protocol version")
assert_eq(Codec:IsCompatible(1), true, "this protocol is compatible")
assert_eq(Codec:IsCompatible(2), false, "foreign major is not compatible")
-- nearby: Codec:Decode("2:STATE:1:QUIET::::0"); EncodeState({ version = 2, … }) refuses "protocol mismatch"

-- tests/test_net_v2.lua
assert_eq(Net.PROTOCOL, 1, "protocol major stays 1")
assert_eq(hello_payload("0.1.0"), "1:HELLO:0.1.0", "HELLO framing is unchanged")
assert_eq(Codec:IsCompatible(2), false, "protocol 2 is incompatible")
assert_eq(Net:Encode("HELLO", "0.1.0"), "1:HELLO:0.1.0", "HELLO is still the transport type")

-- tests/test_ceremony_chaos.lua and tests/test_net_snapshot.lua
assert_eq(Codec:IsCompatible(foreignMsg.version), false, "protocol 2 is incompatible")
-- foreign = "2:SNAPSHOT:response:1:ASSEMBLY::::1"
```

**I-02 — version skew keeps the live event** (`tests/test_net_v2.lua`)

Setup today: `Runtime:StartEvent()` (ASSEMBLY), then GUILD `"2:STATE:1:ASSEMBLY::::1"` and WHISPER `"2:SNAPSHOT:response:1:ASSEMBLY::::1"`. Discard + warn already fire. Runtime is left up.

```lua
assert_eq(skewWhy, "protocol mismatch", "incompatible STATE names the mismatch")
assert_eq(Net.warnedVersion, true, "incompatible STATE is the Quiet version notice")
assert_eq(#chats, 1, "incompatible STATE chats once")
assert_unchanged(beforeSkew, Runtime:Snapshot(), "incompatible STATE does not Restore")
assert_eq(Net:_WarnVersion(2), false, "the version notice still fires once")
assert_eq(#chats, 1, "no second Quiet notice")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "version skew does not drop the live event")
```

**I-03 — version skew keeps the live rite** (`tests/test_ceremony_chaos.lua`)

Section header today: “ApplyResponse of a foreign-major SNAPSHOT fails closed; Runtime unchanged. Do not add a Quiet toast.” Isolated suite: no BeefNet, no chat frame.

```lua
assert_eq(Runtime.Toast, nil, "Runtime has no toast")
assert_eq(Runtime._WarnVersion, nil, "Runtime has no _WarnVersion")
local foreign = "2:SNAPSHOT:response:1:ASSEMBLY::::1"
assert_eq(foreignApply, nil, "ApplyResponse refuses an incompatible version")
assert_eq(foreignErr, "protocol mismatch", "incompatible version fails closed")
assert_unchanged(beforeSkew, Runtime:Snapshot(), "foreign-major SNAPSHOT does not Restore")
assert_eq(Runtime:Snapshot().state, "RITE", "version skew does not drop the live rite")
assert_eq(Runtime:Snapshot().state ~= "QUIET", true, "this lane does not paint Quiet Mode")
```

**I-06 — chaos rewind** (`tests/test_ceremony_chaos.lua`)

Section header today: “Do NOT invent a monotonic-sequence gate. Older snapshots Restore.”

```lua
assert_eq(replayed, true, "ApplyResponse of an older snapshot succeeds")
assert_eq(replayErr, nil, "older Apply has no error")
assert_eq(afterOlder.sequence, 1, "leftover: older Apply Restores the earlier sequence")
assert_eq(afterOlder.state, "ASSEMBLY", "leftover: older Apply overwrites later state")
assert_eq(afterOlder.riteType, nil, "leftover: older Apply drops the later rite")
assert_bible(afterOlder, earlySnap, "leftover: Apply has no monotonic-sequence gate")
assert_eq(Runtime:Restore(earlySnap), true, "Restore of an older object succeeds")
assert_eq(Runtime:Snapshot().sequence, 1, "leftover: older Restore also has no sequence gate")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "leftover: older Restore overwrites later state")
assert_eq(Runtime:Restore(laterSnap), true, "same-object Restore is also ungated")
assert_eq(Snapshot:ApplyResponse(sameWire), true, "replay of the current sequence Applys")
assert_bible(Runtime:Snapshot(), laterSnap, "current-sequence replay Restores the same Bible fields")
```

Live Core matches those leftovers: `Runtime:Restore` replaces the event object with no sequence compare. `Snapshot:ApplyResponse` Restores Bible fields after a compatible decode; **favor stays off Restore**. `Net:_HandleState` always `Runtime:Restore({…})`. Bootstrap `paintInboundFavor` runs only when `_HandleState` / `_HandleSnapshot` returns **ok**.

### 1.2 Foreign-major bodies that become native if left as `2:`

After `PROTOCOL = 2`, today’s skew fixtures are well-formed local traffic. They **must not** keep major `2`.

| Suite | Current foreign body | Used as |
|-------|----------------------|---------|
| `test_net_v2.lua` | `"2:STATE:1:ASSEMBLY::::1"` | I-02 skew; also CreateFrame isolation |
| `test_net_v2.lua` | `"2:SNAPSHOT:response:1:ASSEMBLY::::1"` | I-02 skew |
| `test_net_v2.lua` | `"2:HELLO:9.9.9"` | HELLO mismatch (twice) |
| `test_net_codec.lua` | `"2:STATE:1:QUIET::::0"` | I-05 `IsCompatible(2)` |
| `test_ceremony_chaos.lua` | `"2:SNAPSHOT:response:1:ASSEMBLY::::1"` | I-03 + isolation Apply |
| `test_net_snapshot.lua` | `"2:SNAPSHOT:response:1:ASSEMBLY::::1"` | `"protocol 2 is incompatible"` |

Protocol **0** fixtures (`"0:STATE:…"` / `"0:SNAPSHOT:…"`) stay foreign. Keep `"protocol 0 is incompatible"`.

### 1.3 Local `1:` literals (I-05 retarget, not new pins)

Every locally encoded or hardcoded `1:TYPE:…` in the Task 7 suites must become `2:TYPE:…` when the major bumps. Families (not a second pin each):

| Family | Where | Example pin name |
|--------|-------|------------------|
| STATE prefix / exact body | `test_net_codec.lua` | `"STATE wire starts with version and type"` (`"1:STATE:"`); `"STATE without favor stays eight fields"`; `"STATE favor is countA,countB after sequence"` |
| SNAPSHOT prefix / request | codec, snapshot, chaos, v2 | `"SNAPSHOT wire starts with version and type"`; `"Request wire is role only"` (`"1:SNAPSHOT:request"`) |
| INPUT / DECREE exact bodies | codec, v2 | `"SendFavor encodes favor+pick"` (`"1:INPUT:favor:2:1"`); decree line-only |
| HELLO transport | v2 | `"HELLO framing is unchanged"` |
| Fail-closed `1:` Decode | codec, snapshot, chaos | extra field, invalid role/state/rite, retired TYPEs |
| Dest-trim / `_TransmitWhisper` | v2 | hardcoded `"1:SNAPSHOT:request"` / `"1:INPUT:…"` |

`Decode("1:INPUT:…")` after the bump is an **old v1 body**: incompatible, not a kind-round-trip. Those asserts must retarget to `2:` or they invert by accident.

### 1.4 Companion suite (not in Task 7’s file list; goes red on the bump)

`tests/test_net_validate.lua` (HELLO-only Net cut):

```lua
assert_eq(N.PROTOCOL, 1, "this cut does not invent a v2 protocol number")
assert_eq(encoded, "1:HELLO:0.1.0", "payload is version, type, then fields")
assert_eq(message.version, 1, "the version is read back")
-- deliver("2:HELLO:9.9.9"); N:_WarnVersion(2)
```

**Option V1:** retarget this suite in the same Task 7 change (same I-05 rule).  
**Option V2:** leave it and accept a red harness until a follow-up. Task 7’s named files do not include it; `lua tests/run.lua` still will.

### 1.5 Keep (do not invert)

| Pin / header | Why |
|--------------|-----|
| `"protocol mismatch"` as discard reason | I-02 keep-as-shape |
| `_WarnVersion` fires once; `#chats == 1` on the second call | once-per-session |
| `"Net has no toast"` / `"Runtime has no toast"` / `"Snapshot has no toast"` | no toast family |
| Chaos: `"Runtime has no _WarnVersion"` | notice is Net, not Core |
| `"Do not add a Quiet toast"` (chaos skew header) | stay; drop is presentation + Net chat |
| Protocol 0 refuse | still foreign |
| `"STATE extra wire field"` / `"response extra wire field"` on junk | I-04: invert **only** for allowlisted packed **names** (Task 8). Request extra stays fail-closed |
| `"request extra wire field"` | requests do not grow names |
| Isolation / no `holdSeconds` / no `CreateFrame` | stay |
| `SCHEMA_VERSION == 7` | not this slice |
| I-09 / I-10 (unknown opponent, payload `characterId`) | Task 6, not 7/9 |

---

## 2. Required invert — PROTOCOL 2 + Quiet drop + once-per-session warn

### 2.1 Locked by the plan (not options)

- `Codec.PROTOCOL == 2` and `Net.PROTOCOL == 2`.
- Old v1 bodies are incompatible: `IsCompatible(1) == false`.
- Foreign-major fixtures **must not use `2`**.
- Incompatible inbound does **not** Restore / Apply the foreign theater.
- Event chrome drops to **Quiet presentation**.
- `_WarnVersion` chats the §13.4 sentence **once per session** (`warnedVersion`). Second mismatch (STATE, SNAPSHOT, HELLO, protocol 0) is silent.
- No toast kind, no status chip, no Sound.
- Extra unknown colon parts still `"unknown field"`. Do not add a clerical kind / beat.

### 2.2 Options (implementer picks; this brief does not)

**O-Foreign — rewrite of today’s `2:` skew bodies**

| Option | Foreign major after the bump | Fits |
|--------|------------------------------|------|
| **A** | `1:` (old v1 STATE/SNAPSHOT/HELLO) | Task 7 “old v1 bodies are incompatible.” Preferred default. |
| **B** | `3:` (future major) | Still `IsCompatible == false`; does not prove v1 die. |
| **C** | Mix: v1 for “stale zip,” `0:` / `3:` for unknown | Extra fixtures; protocol 0 already exists. |

Do not leave `"2:STATE:…"` as the skew body.

**O-Drop — what “Quiet presentation” means**

Pin catalog I-02: “Runtime presentation is Quiet **(or Event furniture is hidden)**.”

| Option | Observable | Constraint |
|--------|------------|------------|
| **A** | `Runtime:Snapshot().state == "QUIET"` after skew | Isolated chaos can pin I-03 without UI. Not `EndEvent` from RITE (that verb is illegal). Not a sixth state. Not `holdSeconds`. |
| **B** | Runtime event object stays; HUD / cards / favor hide | Matches “Event furniture is hidden.” **Invisible** in `test_ceremony_chaos.lua` (no UI). Would leave I-03 un-inverted unless a Core presentation flag is added. |
| **C** | Dedicated skew flag + QUIET paint, event object parked | More machinery than the plan named. Do not invent unless A/B cannot satisfy both suites. |

I-03 flips `"this lane does not paint Quiet Mode"` to **this lane does drop to Quiet presentation**. Option A is the only drop chaos can see today. Option B is only lawful if chaos also gets a Core-visible signal.

`BuildResponse` after a real QUIET drop is `nil, "no event"` (already pinned for cold QUIET). That is a useful companion, not a new product field.

**O-Warn — exact chat line**

Must include both plan fragments. Exact string is not filed as product law.

| Option | Shape |
|--------|-------|
| **A** | Replace the engineer sentence with a line that contains `the Church's software has advanced` and tells the player to update the addon. |
| **B** | Keep a version-number clause (`v%s` / `v%d`) **and** the Bible phrase + update. |

Do not pin the current `"a guildmate is running BeefNet v%s…"` sentence as the keep. HELLO mismatch and Codec-path mismatch share one latch. Isolated chaos must **not** grow a Runtime toast to fake the Net pin.

**O-Where the drop runs**

Task 7 inverts **both** `test_net_v2.lua` (Net inbound) and `test_ceremony_chaos.lua` (`ApplyResponse`). A Net-only drop leaves I-03 green-wrong. An Apply-only drop leaves I-02 green-wrong. Same product rule, two call sites (plus any login snapshot apply — Task 10, not this brief).

### 2.3 Suggested pin flips (names, not code)

| Current | After |
|---------|--------|
| `"protocol major stays 1; v2 is the vocabulary"` / `"protocol major stays 1"` | `Codec.PROTOCOL == 2`, `Net.PROTOCOL == 2` |
| `"protocol 2 is incompatible"` | `"protocol 1 is incompatible"` (or `"old v1 … is incompatible"`) |
| `"this protocol is compatible"` on `IsCompatible(1)` | `IsCompatible(2)` |
| `"every message carries a protocol version"` expecting `1` | expecting `2` |
| `"HELLO framing is unchanged"` | `2:HELLO:0.1.0` |
| `"version skew does not drop the live event"` | Quiet presentation; foreign body not Restored |
| `"version skew does not drop the live rite"` | same |
| `"this lane does not paint Quiet Mode"` | this lane **does** drop to Quiet presentation |
| `"incompatible STATE chats once"` | line contains `the Church's software has advanced` and update-the-addon |
| `_WarnVersion(2)` latch probes | `_WarnVersion` of the **foreign** major (1, or 3/0 if O-Foreign B/C) |

---

## 3. Latest-wins so favor STATE is not dropped

### 3.1 Why `seq >` alone is wrong

Review §2.2 + 100-point **#44**: `RecordFavor` writes `favorPicks` and does **not** increment Runtime sequence. Pope glue `wrapAfter(Gora, "RecordFavor", sendState)` rebroadcasts STATE at the **current** sequence. Congregation `_HandleState` that applies ceremony only when `seq > current` **drops every favor STATE**. HELLO refresh that re-sends the same sequence has the same hole.

Snapshot header today: “favor stays off Restore.” Bootstrap paints favor only if the handle returned **ok**. A ceremony-only refuse on equal seq that returns not-ok also drops favor in glue. That is the invert risk for Task 9.

### 3.2 Locked rules

| Incoming | Ceremony (Bible fields: eventId, state, riteType, subjects, sequence) | Favor overlay |
|----------|----------------------------------------------------------------------|---------------|
| Different `eventId` | Apply (new event). Smaller sequence is not a rewind of event 1. | Apply if the body carries favor |
| Same `eventId`, `sequence` **greater** | Apply | Overlay if present |
| Same `eventId`, `sequence` **equal** | Do **not** apply ceremony | Overlay if present (`>=`) |
| Same `eventId`, `sequence` **less** | Do **not** apply | Do **not** overlay |
| Incompatible version | Do not apply; Quiet drop (Task 7) | Do not overlay |

Equal sequence must not fire theater (`Toasts:Proclaim` / `Sound`). Theater is **off this slice** anyway (#27). Snapshot `ApplyResponse` uses the **same** ceremony rule as `Runtime:Restore`. Older Apply/Restore leaves later ceremony fields unchanged (invert I-06).

Favor is not a Runtime Bible field. Do not `Restore` a favor table onto the event object.

### 3.3 Options (where the compare lives)

| Option | Ceremony gate | Favor overlay | Trap |
|--------|---------------|---------------|------|
| **A** | Inside `Runtime:Restore` (greater only) | Net / bootstrap after a **structured** result | Restore `false` + today’s `if ok then paintInboundFavor` drops favor |
| **B** | Inside `ApplyResponse` + `_HandleState`; Restore stays wholesale | Same Net/glue, called on `>=` even when ceremony no-ops | Two sites must not drift; chaos `Restore(earlySnap)` still needs the gate |
| **C** | Restore splits: ceremony if `seq >`, ignore older, return ok on equal | Overlay in Net when `eventId` matches and `seq >=` | Cleanest match to the table; still no clerical beat |

Plan requires the rule at Restore **and** ApplyResponse. Option B without a Restore gate fails I-06’s `Runtime:Restore(earlySnap)` lines.

Equal-seq Apply/Restore: **no-op with `true`** or **`nil` + err** is an option. Pin the snapshot (CONSEQUENCE / seq 3 / rite still Gora after an older blob), not the verb poetry. Pin catalog: “Equal-sequence replay may stay applied (favor overlay uses `>=`).” A same-seq body with **different fighters** must not overwrite ceremony.

### 3.4 I-06 pin flips (names)

| Current leftover | After |
|------------------|--------|
| `"ApplyResponse of an older snapshot succeeds"` + seq 1 / ASSEMBLY / rite nil | Older Apply does **not** rewind; later CONSEQUENCE / seq 3 / Gora remain |
| `"leftover: Apply has no monotonic-sequence gate"` | Ceremony requires a **greater** sequence (same eventId) |
| `"leftover: older Restore also has no sequence gate"` | Older Restore does not rewind |
| `"same-object Restore is also ungated"` / `"replay of the current sequence Applys"` | Equal sequence does not apply ceremony; must not theater |
| `"current-sequence replay Restores the same Bible fields"` | Unchanged ceremony is OK only because nothing moved; different fighters on equal seq must not win |

Different `eventId` still applies (new pin; no current leftover names this). Favor overlay pins belong in `test_net_v2.lua` / glue (Accept stub + favor spy), not as `Runtime:Restore(favor)`.

---

## 4. What must NOT be added

Do not treat this list as OPEN_QUESTIONS answers. **#27 stays unanswered.**

| Temptation | Why not |
|------------|---------|
| Clerical `beat` / `kind` on STATE | OPEN_QUESTIONS **#27**. Review §2.2: inbound Proclaim cannot choose Victor vs Void vs Free vs Cowardice vs Knighting from Bible §20.2 fields. Verdicts do not `CloseRite`. |
| Inbound `Toasts:Proclaim` / `Sound:Play` | Same. Wave 2 lawful default: inbound Proclaim / Sound **off**. Pope wrap stays local. Equal-seq pin is “must not theater,” not “fire once.” |
| Infer kind from `state` + `riteType` | Explicitly forbidden by #27 and review §2.2. |
| Generic theater opcode / new TYPE | Review: say “no new TYPE,” not “no new protocol.” Closed set stays STATE, SNAPSHOT, INPUT, DECREE. HELLO stays transport. |
| W/L, H2H, title, stipulation, free-ruling prose on the wire | #27 + Task 8 names-only. Not this brief. |
| Invert **all** `"STATE extra wire field"` pins | I-04: invert **only** for the allowlisted packed **names** field. Junk / `kind` / `text` / `beat` stay `"unknown field"`. |
| Congregation `EnsureCharacterByName` | Task 6 / #26. |
| `holdSeconds` / MarkPopeLost timer | Chaos already forbids it. |
| Schema 8 | Forbidden. |
| Pinning the live engineer `_WarnVersion` sentence as law | Task 7 replaces copy with §13.4 + update the addon. |
| Resolving #27 in this file or in Lua | David answers. Night-one refuse path only. |

Task 8 (packed names, 240 through `Net:Send`, inbound name stash) may land beside Task 7. This brief does not specify that field beyond: extra colon parts remain fail-closed until names are allowlisted; no clerical field hides inside “names.”
