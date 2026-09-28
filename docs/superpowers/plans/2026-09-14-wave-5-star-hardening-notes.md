# Wave 5 star-hardening notes — **not this slice**

> **After Wave 2 first-night.** Do not implement these items in the Wave 2 serial Lua pass (`docs/superpowers/plans/2026-09-14-church-of-beef-first-night-wave-2.md`). That plan’s spec list stops before Wave 5. Agents reading this file are mapping leftovers, not writing keepers.

**Source:** 100-point items **69–79** in `docs/superpowers/specs/2026-09-14-church-of-beef-100-point-plan-design.md` (Wave 5 — Star hardening). Item **80** is a two-client walk for David — not notes, not this slice.

**Do not invent:** a **10 Hz** wire rate (that is the open-UI dirty cap in `wow-performance.mdc`, not BeefNet); a **hold timer** / `holdSeconds` / “no STATE for N seconds” detector (**#73** is parked with **#47**). Coalesce to the **existing** outbound bucket: burst **10**, refill **1/s**.

**Product law:** Bible §13.1 / §13.4 / §20.3–20.4. Law 5 (star). Law 7 (history never deleted). Law 2 (no activity sensor). Law 8 / Audit V4 (Petition, not Challenge).

---

## Why this is later

Wave 2 first-night is recruit comprehension, named fighters, desk verbs, Pope `/reload` mid-Gora. A 40-person HELLO storm, whisper budget, inbound table wipe, SV fail-closed, and Challenge quarantine are **star hardening after a night can run**. Coding them now would compete with `ChurchOfBeef.lua` / `Net/BeefNet.lua` / `Core/DB.lua` / `Core/Gora.lua` — the same files Wave 2 already serializes.

---

## Live keepers (read these, do not grow them yet)

| Keeper | File | Wave 5 duty |
|--------|------|-------------|
| `COB.Net` | `addon/ChurchOfBeef/Net/BeefNet.lua` | Token bucket, inbound table, whisper bypass, HELLO dispatch |
| Bootstrap glue | `addon/ChurchOfBeef/ChurchOfBeef.lua` | `sendState`, `COB._OnPeerHello`, `wrapAfter(Gora, "RecordFavor", sendState)` |
| `COB.Store` | `addon/ChurchOfBeef/Core/Store.lua` | `Restore` / `Snapshot` / `RecordGoraResult` |
| `COB.DB` | `addon/ChurchOfBeef/Core/DB.lua` | `isSnapshot`, `restoreFromSv` |
| `COB.Archive` | `addon/ChurchOfBeef/Core/Archive.lua` | Fail-closed template (`isGrantShaped`, `walkBanned`, `knownRank`) |
| `COB.Gora` | `addon/ChurchOfBeef/Core/Gora.lua` | Leftover Challenge pair; product `Petition`; `writeBoth` |
| `COB.Group` | `addon/ChurchOfBeef/Core/Common.lua` | Unused `CountGuildmates` |
| `COB.Runtime` | `addon/ChurchOfBeef/Core/Runtime.lua` | `sequence`, `awaitingPope`, `MarkPopeLost` (paint later; **#73** parked) |

---

## Item map

### #69 — Coalesce HELLO-triggered STATE (P0)

**Law gap:** 40 logins → 40 `sendState` of the **same** `Runtime:Snapshot().sequence`.

| Symbol | Where | Live behavior |
|--------|-------|----------------|
| `Net:HandleHello` | `BeefNet.lua` | Compatible, non-self HELLO records `Net.peers[nameKey]` then `pcall(COB._OnPeerHello, sender)` |
| `COB._OnPeerHello` | `ChurchOfBeef.lua` `InstallWire` | Pope + live event (`state ~= "QUIET"`) → `sendState()`. QUIET / congregation / missing Runtime are no-ops. No Inputs refresh, no Proclaim |
| `sendState` | `ChurchOfBeef.lua` | `pcall(Net.SendState, Net, stateFields())` |
| `Net:SendState` | `BeefNet.lua` | Pope-gated `Codec:EncodeState` → `Net:Send` (queue + `Pump`) |
| `Net:Send` / `Net:Pump` / `Net.queue` | `BeefNet.lua` | FIFO payloads. **No** “replace queued STATE for this sequence.” Each HELLO enqueues another body |
| `stateFields().sequence` | `ChurchOfBeef.lua` ← `Runtime:Snapshot()` | Sequence does **not** bump on HELLO |

**Harness that pins the uncoalesced path:** `tests/test_wire_glue.lua` Lane W — one peer HELLO → `countType("STATE") + 1`. `tests/test_net_v2.lua` pins `_OnPeerHello` fire on compatible non-self HELLO.

**Later work (not now):** one live STATE per current sequence. Still spend the **token bucket** when that one body transmits. Do not add a second timer. Do not invent 10 Hz.

---

### #70 — Coalesce `RecordFavor` → STATE on the outbound token bucket (P0)

**Law gap:** each standing pick wraps `sendState`. Same sequence (item **44**: favor does not bump `sequence`). Forty picks → forty STATE payloads, paced but not coalesced.

| Symbol | Where | Live behavior |
|--------|-------|----------------|
| `Net:_HandleFavor` | `BeefNet.lua` | WHISPER + local Pope → `Gora:RecordFavor(decoded.characterId, pick)` |
| `Gora:RecordFavor` | `Gora.lua` | Memory map `favorPicks`; requires sanctioned pair |
| `wrapAfter(COB.Gora, "RecordFavor", sendState)` | `ChurchOfBeef.lua` `InstallWire` | Every successful pick calls `sendState` |
| `Net.OutboundBurst` / `Net.OutboundPerSecond` | `BeefNet.lua` Net table | **10** / **1** — this **is** the prefix budget |
| `Net:_Refill` / `Net.tokens` / `Net.tokensAt` | `BeefNet.lua` | Clock-injectable; `Pump` spends ≥1 token per queued payload |
| `Net:_Arm` | `BeefNet.lua` | `C_Timer.After` for the next token only |

**Do not invent a 10 Hz wire rate.** Open-UI dirty coalesce (≤10 Hz) is `wow-performance.mdc`. Favor STATE is a **bucket** problem: replace-or-hold one STATE for the current sequence, then `Pump` it.

---

### #71 — Congregation whispers on the outbound budget (P1)

**Law gap:** favor / petition / confession / snapshot **bypass** `Net.queue` / `Net:Pump`.

| Symbol | Where | Live path |
|--------|-------|-----------|
| `Net:_TransmitWhisper` | `BeefNet.lua` | Immediate `SendAddonMessage(..., "WHISPER", target)`. Increments `sentCount`. **No** `_Refill` / token spend |
| `Net:SendFavor` | same | `resolveDest` → `Codec:EncodeInput` → `_TransmitWhisper` |
| `Net:SendPetition` | same | same |
| `Net:SendConfession` | same | same |
| `Net:RequestSnapshot` | same | `Snapshot:Request()` or `EncodeSnapshot({ role = "request" })` → `_TransmitWhisper` |
| `Net:SendSnapshot` | same | Pope-gated response; still `_TransmitWhisper` |
| `Net:_HandleSnapshot` request | same | Pope `Snapshot:BuildResponse()` → `_TransmitWhisper(blob, sender)` |

`nowSeconds` on the whisper Send* methods is unused. GUILD `Send` / `SendState` / `SendDecree` / `SendHello` already share the bucket.

`tests/test_net_v2.lua` (B3-E era) pins `#Net.queue == 0` after `RequestSnapshot` — that pin **is** the bypass. Invert it when this item lands; do not invert it in Wave 2.

---

### #72 — Inbound evict-oldest; do not reset the Pope’s tokens (P1)

| Symbol | Where | Live behavior |
|--------|-------|----------------|
| `Net:_AllowInbound` | `BeefNet.lua` | Per-`nameKey` bucket. New sender: if `#inbound >= MaxInboundSenders` then **`self.inbound = {}`** (full wipe), then insert |
| `Net.inbound` | Net table | `{ [key] = { tokens, at } }` |
| `Net.MaxInboundSenders` | **200** | Cap before wipe |
| `Net.InboundBurst` / `Net.InboundPerSecond` | **5** / **0.2** | Per sender; not the Pope-writer outbound bucket |
| `Net:OnAddonMessage` | `BeefNet.lua` | Non-self must pass `_AllowInbound` before decode. Self echo is exempt |

Wipe comment in source: “Everyone starts full again, which is the harmless direction.” That **does** refill a registered Pope’s inbound tokens if the Pope’s key was in the table. Item 72: evict oldest (`at` is the only timestamp today — last refill, not first-seen; a later slice may need `created` if “oldest” must mean first insert). Do **not** `inbound = {}`.

`tests/test_net_validate.lua` lowers `MaxInboundSenders` to 4 and pins `tracked <= 4`. It does **not** pin that a known Pope bucket survives the cap.

---

### #73 — PARK with #47. No “no STATE for N seconds” detector (P2)

**Parked. Do not code.**

| Symbol | Where | What exists |
|--------|-------|-------------|
| `Runtime:MarkPopeLost` / `ClearPopeLost` | `Runtime.lua` | Sets / clears `awaitingPope` on a live event. QUIET refuses Mark |
| `ev.awaitingPope` | Runtime event object | Event Mode degraded — not a sixth state. Not encoded on STATE (`BeefNet._HandleState` Bible fields only) |
| Item **#47** | 100-point plan | Paint the flag only if it is **already** set. No disconnect detector |
| OPEN_QUESTIONS **#13** | `docs/design/OPEN_QUESTIONS.md` | Presence “here” — unanswered. Not a license for an online / silence sensor |

Bible §20.4 five / thirty seconds is a **scribe quality bar**, not `holdSeconds`. `ceremony-runtime.mdc` forbids invented hold-timeout seconds.

**Do not invent:** `C_Timer` silence watch, `lastStateAt`, 10 Hz poll, or a hold timer. Paint only if David licenses a discrete client signal (#13 / a hold policy). Until then the hole is documented.

---

### #74 — Align `Store:Restore` with Archive fail-closed (P1)

Archive already refuses Prophet / Grant-shaped keys. Store Restore does not.

| Symbol | Where | Live behavior |
|--------|-------|----------------|
| `Store:Restore` | `Store.lua` | Type-checks `humans` / `characters` / `ceremonyLog` / `markedMoments` as tables (or nil). Then `loadRows` + `ensureHuman` / `ensureCharacter`. Returns `true` |
| `ensureHuman` / `ensureCharacter` | `Store.lua` | Shape fill; strip character `rankId` / defenses. **No** rank allowlist. **No** Grant walk |
| `knownRank` (Store, local) | `Store.lua` | Used by `Store:SetRank` only. `Ranks.ById` — id **7** / Prophet is absent |
| `Archive.isGrantShaped` (local) | `Archive.lua` | `points`, `standing`, or key prefix `grant` |
| `Archive.walkBanned` (local) | `Archive.lua` | Recursive Grant-shaped + `narration` |
| `Archive.validate` / `Archive:Import` | `Archive.lua` | `knownRank` on each human `rankId`; `walkBanned` before `Store:Restore` |
| `Codec.isGrantShaped` (local) | `Net/Codec.lua` | Same Grant shape on the wire — not Store |

`tests/test_archive.lua` refuses crafted `rankId = 7` and `granted`. `tests/test_store.lua` pins Restore of a **legal** Snapshot and `SetRank` Prophet refuse — **not** Restore of a Prophet / Grant-shaped row.

**Later work:** fail-closed **inside** `Store:Restore` (SV and any caller, not only Archive Import). Reuse Archive’s ban shape; do not invent a fourth list. Leftover demo keys at the **SV root** stay (Law 7; `test_db.lua` leftover `scoring.granted`).

---

### #75 — `DB:restoreFromSv` must check Restore return values (P1)

| Symbol | Where | Live behavior |
|--------|-------|----------------|
| `restoreFromSv` | `DB.lua` (local) | `isSnapshot(db.store)` → `store:Restore(db.store)` — **return discarded** |
| `restoreEventFromSv` | same | `runtime:Restore(db.event)` — discarded |
| `restoreDecreeFromSv` | same | `decree:Restore(db.decree)` — discarded |
| `DB:Init` | `DB.lua` | Calls all three after `applyDefaults` |

`tests/test_db.lua` spies `Store.Restore` **call count**, not `ok, err`. A fail-closed Restore (#74) that returns `nil, reason` would still be ignored today — live memory already replaced only if Restore mutates before returning; if Restore starts failing closed **before** `loadRows`, Init would keep stale memory **and not know**. Check the first return; do not wipe on `nil`.

Same hole on event / decree restore (out of 69–79’s Store sentence; do not “fix” those as a silent extra unless the later slice names them).

---

### #76 — Empty Snapshot arrays must not wipe on ordinary Init (P1)

| Symbol | Where | Live behavior |
|--------|-------|----------------|
| `isSnapshot` | `DB.lua` | `type(store.humans) == "table"` **and** `type(store.characters) == "table"` |
| Empty hook `store = {}` | `DB.lua` / `test_db.lua` | **Not** a snapshot. Restore not called. Live humans kept |
| Partial `{ humans = {} }` | `test_db.lua` | **Not** a snapshot (no `characters`). Kept |
| `{ humans = {}, characters = {} }` | **unpinned hole** | `isSnapshot` is **true**. `Restore` → `loadRows({}, …)` **replaces** live maps with nobody |
| `Archive:Import` | `Archive.lua` | Operator action. Empty-array import may still replace — that is **not** ordinary Init |

Comment in `restoreFromSv`: “Empty `{}` must not replace live memory.” That is the hook, not empty arrays.

**Later work:** ordinary `DB:Init` must not treat empty arrays as a wipe. Import of an empty Archive stays an operator action (item text). Do not invent a third “are we empty?” policy beyond that split.

---

### #77 — Quarantine leftover `Gora:Challenge` (P1)

Product loop is **Petition → Recommend → Sanction → Propose → ruling**. Challenge is Audit V4 residue.

| Symbol | Where | Live behavior |
|--------|-------|----------------|
| `Gora:Challenge` / `Cancel` / `IsChallenged` / `GetPending` | `Gora.lua` | Pair-key notes in `Gora.pending`. **No** UI / Net / Console caller |
| `Gora:_Prune` | `Gora.lua` | Drops notes older than `CHALLENGE_TTL` |
| `CHALLENGE_TTL` | `Gora.lua` local | **`1800`** — invented seconds. Bible forbids invented petition TTL numbers; this is the leftover Challenge clock |
| `PENDING_MAX` | `Gora.lua` local | **20** |
| `pairKey` / `copyChallenge` | `Gora.lua` | Name-key pair, directionless |
| `Gora:Petition` / `GetPetitions` / `Dismiss` | `Gora.lua` | Product pool. Event-scoped via `_Expire` + `liveEventId()` |

Header already says leftover Challenge remains for the old suite.

**Harness that pins leftover as law:** `tests/test_gora.lua` (“Leftover Challenge pair-key notes stay working”); `tests/test_gora_ceremony.lua` Challenge / TTL block. 100-point testing section: **stop pinning leftover product as law**.

**Later work:** quarantine (delete or `_IN_TEST`-only) Challenge / GetPending / invented TTL. Invert those pins. Do not invent a new Challenge TTL. Do not grow Petition a numeric TTL here (OPEN_QUESTIONS / Bible: ~current event).

---

### #78 — Remove unused `Group.CountGuildmates` (P2)

| Symbol | Where | Live behavior |
|--------|-------|----------------|
| `Group.CountGuildmates` | `Core/Common.lua` | Party/raid guildmate census (“co-play to count”). Law 2 smell |
| TOC callers | **none** | `Group.PlayerName` is used (`Gora`, `Hud`, `Console`, `Markers`). Leave that |
| Attic | `attic/Core/Instance.lua`, `attic/Core/Quest.lua` | Callers exist; **not** TOC-loaded |

Do not persist a count. Do not hang Presence / #13 on it.

---

### #79 — `Gora.writeBoth` fail-closed (P1)

| Symbol | Where | Live behavior |
|--------|-------|----------------|
| `writeBoth` | `Gora.lua` local | `Store:RecordGoraResult(idA, …)` then `RecordGoraResult(idB, …)`. First success is **not** rolled back if the second returns `nil` |
| Callers | `Gora:DeclareVictor`, `CowardiceRecorded`, `Void`, `FreeRuling` | All go through `writeBoth` then `AppendCeremony` + `clearLive` |
| `Store:RecordGoraResult` | `Store.lua` | Mutates one character in place; no two-phase / undo |

Asymmetric bout: one character has a result row, the other does not; ceremony append still runs if `writeBoth` returned true only — today a second-leg error returns before ceremony. First-leg write **stays**.

**Later work:** both characters or neither (preflight both ids + rollback, or write to copies then commit). Do not invent a third ruling enum.

---

## Existing outbound / inbound numbers (do not add a third)

| Constant | Value | Role |
|----------|-------|------|
| `Net.OutboundBurst` | 10 | Prefix bucket — HELLO / STATE / DECREE |
| `Net.OutboundPerSecond` | 1 | Refill |
| `Net.MaxQueued` | 60 | Drop newest |
| `Net.InboundBurst` | 5 | Per sender |
| `Net.InboundPerSecond` | 0.2 | Per sender |
| `Net.MaxInboundSenders` | 200 | Today: wipe-all |
| UI dirty cap | ≤10 Hz | **Open frames only.** Not a wire rate |

---

## Tests to invert or add **when** Wave 5 is opened

Not Wave 2 work. Register new files in `tests/run.lua` only in that later slice.

| Item | Today | Later pin |
|------|-------|-----------|
| 69 | Lane W: +1 STATE per HELLO | N HELLOs, same `sequence` → one queued/live STATE |
| 70 | `wrapAfter` RecordFavor → SendState each pick | N favors, same sequence → one STATE; still `OutboundBurst` / `1/s` |
| 71 | Whisper `#queue == 0` | Whisper spends the same `_Refill` / `Pump` budget (or a named shared spend) |
| 72 | `tracked <= cap` after wipe | Cap evicts oldest; Pope `inbound[popeKey].tokens` unchanged |
| 73 | — | **No new suite.** Do not add a silence-timer test |
| 74 | Archive refuses Prophet / Grant; Store Restore does not | `Store:Restore` refuses the same shapes; live maps unchanged |
| 75 | Restore call counted, return ignored | Failed Restore does not apply; Init sees `ok` |
| 76 | `{}` / humans-only safe; both-empty unpinned | `humans = {}, characters = {}` on Init does not wipe; Archive Import still operator |
| 77 | Challenge / TTL **required** | Challenge absent or test-only; Petition still works |
| 78 | Function exists, unused | `Group.CountGuildmates == nil`; `PlayerName` stays |
| 79 | No rollback pin | Second-leg fail leaves **neither** character written |

---

## Files a later slice would touch (do not start)

`Net/BeefNet.lua` · `ChurchOfBeef.lua` (`sendState` / `_OnPeerHello` / RecordFavor wrap) · `Core/Store.lua` · `Core/DB.lua` · `Core/Gora.lua` · `Core/Common.lua` · `tests/test_net_validate.lua` · `tests/test_net_v2.lua` · `tests/test_wire_glue.lua` · `tests/test_store.lua` · `tests/test_db.lua` · `tests/test_gora.lua` · `tests/test_gora_ceremony.lua`

Archive / Codec Grant helpers are **templates** for #74, not an invitation to rewrite Import.

---

## Related, not this wave

| Item | Why it sits nearby |
|------|---------------------|
| **#44** | Latest-wins; favor overlay does not bump sequence — why #69/#70 must coalesce |
| **#45** | `RequestSnapshot` after accepted HELLO/STATE — still Wave 2 / first-night |
| **#47** | Paint `awaitingPope` only if set; complements parked **#73** |
| **#48 / #51** | Pope `/reload` `sendState` once — first-night persist, not HELLO storm |
| **#80** | Two-client smoke after 23–38 land — David |

---

## Stop conditions for anyone holding this file

- Do not implement. Do not open a Wave 5 PR from these notes.
- Do not invent 10 Hz, `holdSeconds`, or a Challenge TTL replacement.
- Do not resolve OPEN_QUESTIONS **#13**.
- Do not claim the star is hardened because the bucket already exists — **coalesce** and **whisper spend** are the missing pieces.
- Wave 2 first-night remains the executable slice.
