# Two-client star smoke

**Status:** NOT RUN. Do not tick this file as done. Do not date a pass.

**Purpose:** Prove the Pope-authoritative star on two live Anniversary clients. Client **P** is the Pope writer. Client **C** is the congregation display. This is not a guild night and not a Gathering.

**Do this after** the load / install half of [`solo-smoke.md`](solo-smoke.md) on at least one character. That file is Quiet Tuesday + hosted surfaces. Do not walk standing, Grant, or an Officer queue as this smoke.

**Law:** Bible §13.1, §13.4, §20.3, §21.3 · Ten Laws 5 and 6 · `.cursor/rules/ceremony-runtime.mdc`  
**Install / reload:** `.cursor/skills/church-of-beef-dev/SKILL.md`

A green harness (`lua tests/run.lua`) is a precondition, not this walk. **Do not claim V1 / MVP complete.** **Do not claim `POLISH:PASS`.**

Tick a box by replacing `[ ]` with `[x]` and appending `— YYYY-MM-DD, character`. Leave every box unchecked until a human walks it on two Anniversary clients.

---

## Honesty (today)

The deleted product (standing, SUGGESTION fan-out, Officer queue, claimed-vs-verified numbers) is gone. Pass/fail is the star, not a petition landing on an officer desk.

| Kind | What the code actually does |
|------|-----------------------------|
| **HELLO** | Live. `Net:SendHello()` on `Init`. GUILD. Presence / protocol version only. Not authority. |
| **STATE** | Live. Bootstrap `InstallWire` sends `Net:SendState` after a successful Runtime `StartEvent` / `OpenRite` / `CloseRite` / `Continue` / `EndEvent`, and after successful `Gora:RecordFavor` or `Console:SetCongregationFavorVisible`. Still **GUILD** only if `Sender:IsRegisteredPope` of the local player. Else `false, "not a registered pope"`. Inbound Restore only if `Sender:Accept(sender, "STATE")`. Optional `favor` is on the payload only when the Pope's congregation toggle is on and a sanctioned pair exists. |
| **SNAPSHOT** | Live codec. `Net:SendSnapshot(fields, target)` encodes and whispers to `target` only if the local player is a registered Pope. Else the same refuse. `Net:RequestSnapshot(target)` is live congregation whisper: not Pope-gated; a blank target now defaults to the last accepted STATE sender, else the first listed Pope in `Data/Popes.lua`. There is no Catch-up button and no `/beef catchup` — the Pope's client re-broadcasts STATE when a guildmate HELLOs during a live event, so a late joiner or `/reload` needs no action. Inbound **response** Restores only if `Accept(sender, "SNAPSHOT")`. Inbound **request** is answered only if the local player is a registered Pope. Channel must be **WHISPER**. No GUILD fan-out. C does not answer. |
| **DECREE** | Live. `Console:PostDecree` → `Net:SendDecree({ line, flavor })` after Core `Set`. Inbound `_HandleDecree` Sets when `Sender:IsRegisteredPope(sender)`. A successful `Decree:Set` (either path) also shows the banner once for that decree. `InspectProgress` does not broadcast. |
| **INPUT** | Favor, petition, and confession are live as **whisper-to-Pope** (`Net:SendFavor` / `SendPetition` / `SendConfession`). A blank target defaults to the last accepted STATE sender, else the listed Pope. GUILD INPUT stays unknown. Confession **fan-out** is leftover (never public theater). |
| **SUGGESTION / SYNC_REQUEST / SYNC_STATE / RANK_COMMIT** | Retired. Named so they die quietly. Discarded unread. Never answered. |

`Net:Send` (raw GUILD enqueue) is **not** Pope-gated. A congregation client can put bytes on GUILD. That is not becoming a writer. Theater is `Accept` / Restore, not "a message existed on the wire."

`Snapshot:Request()` only encodes `1:SNAPSHOT:request`. `Net:RequestSnapshot(target)` is the live congregation send: whisper that body to the given target, or to the default destination (last STATE sender, else the listed Pope) when target is blank. It is not Pope-gated. `SendSnapshot` remains Pope-gated even for `role = "request"`. C asks with `RequestSnapshot`, not `SendSnapshot`. Walk step 5 may still forge the same whisper. Do not invent an opcode.

**Listed Pope.** Send and Accept are fail-closed unless the Pope character is listed in `Data/Popes.lua` or `ChurchOfBeefDB.ui.popeOverrides`. Shipped name: **Thedave**. This file does not invent extra characters, a settings panel, or a `/run` stub of `IsRegisteredPope`. Agents do not edit `WTF/`. If the installed client still refuses on Thedave, step 4 is not a pass — the list is not live on that install.

**Observable.** Hosted rite theater (Fight HUD, fighter-card beat) needs a sanctioned pair besides Runtime. Do not `/run` a fake Gora so a HUD appears. The star observable is `Runtime:Snapshot()` plus the send refuse string. Missing HUD is not a star fail.

**Version notice.** Bible §13.4 names a gentle Quiet drop ("the Church's software has advanced"). The shipped function is `Net:_WarnVersion`. It prints **one** chat line per session, then sets `warnedVersion` and stays silent:

`Church of Beef: a guildmate is running BeefNet v<version>; this client speaks v1. Update for matching addon messages.`

That is the copy. Do not look for the Bible sentence in chat. `_WarnVersion` does not toast. There is no status chip — the shell and `UI/Status.lua` are retired; the chat line is the whole notice.

---

## Cast

| Role | Who | Client |
|------|-----|--------|
| **P** | **Thedave.** | Writer. `SendState` / `SendSnapshot` may succeed on that listed character. |
| **C** | A second guilded character on a second client, addon installed. | Display. Never a writer. |

Same guild. Both logged in. Both running Church of Beef (`## Interface: 20506`).

---

## Setup

- [ ] Both clients: addon reinstalled from `addon/ChurchOfBeef/` — skill §2. Player `WTF/` untouched
- [ ] Both clients: `/console scriptErrors 1` (BugGrabber + BugSack preferred)
- [ ] Both characters in the same guild, both logged in, both `/reload`ed after install
- [ ] **P** is Thedave and **C** is a second guilded character
- [ ] `lua tests/run.lua` was green on this checkout (agent or human). That is not this smoke

---

## Helpers (read, do not invent)

Space `/run` forges. Inbound per-sender burst is 5, then one every five seconds. A drop for talking too fast is not a star fail.

On either client, read the local machine:

```
/run local s=ChurchOfBeef.Runtime:Snapshot() print(s.state, s.eventId, s.sequence)
```

Quiet start is `QUIET`, `nil` event id, sequence `0`.

Send refuse / success (P or C):

```
/run local ok,err=ChurchOfBeef.Net:SendState({eventId=1,state="ASSEMBLY",sequence=1}) print(ok, err)
```

```
/run local ok,err=ChurchOfBeef.Net:SendSnapshot({role="response",eventId=1,state="ASSEMBLY",sequence=1}, "<congregation character>") print(ok, err)
```

Replace `<congregation character>` with C's name when you whisper. Do not invent one in this file.

---

## Walk

### 1. Both load

- [ ] Neither client shows a script error on login or `/reload`
- [ ] `/beef` opens the Church card without a Lua error on both
- [ ] No "syncing" / "synced" chrome anywhere — there is no status chip.
      The only version word is the one chat line from step 2
- [ ] No standing chip, Officer queue, or promote toast. That product is gone

### 2. HELLO / version (one Quiet notice)

`Net:Encode` always stamps this client's protocol (`1`). A mismatch has to be written by hand.

On **C** (or **P** — either side):

```
/run ChurchOfBeef.Net:Send("99:HELLO:9.9.9")
```

- [ ] The **other** client prints **one** `_WarnVersion` chat line (the shipped sentence above). No toast. No rite theater
- [ ] Send the same line again from the same client. The other client stays quiet — `warnedVersion` is once per session, not once per message
- [ ] Stale (`0:HELLO:9.9.9`) is the same gate. Do not send it in the same session if you still need to see the second-mismatch silence; `/reload` clears the flag

The sender also warns at itself: guild addon messages come back, and a version mismatch is judged before the self-check. That is expected.

### 3. Without a listed Pope

Do this **before** David lists P. Both clients still fail-closed.

On **P** and on **C**:

```
/run local ok,err=ChurchOfBeef.Net:SendState({eventId=1,state="ASSEMBLY",sequence=1}) print(ok, err)
/run local ok,err=ChurchOfBeef.Net:SendSnapshot({role="response",eventId=1,state="ASSEMBLY",sequence=1}, "<congregation character>") print(ok, err)
```

- [ ] Both print `false    not a registered pope`. Nothing new on the wire from those APIs

On **C**, forge STATE on GUILD (raw `Send` is not the Pope gate):

```
/run local N=ChurchOfBeef.Net local p=ChurchOfBeef.Codec:EncodeState({eventId=1,state="RITE",riteType="Knighting",sequence=1}) N:Send(p)
```

- [ ] **P** (and **C** via echo) do **not** Restore. `Runtime:Snapshot()` stays `QUIET`. C does not paint rite theater from a congregation sender
- [ ] Inbound theater from an unlisted sender is discarded. It is not stored for later paint

### 4. With P listed as Pope

**P** is **Thedave**, already listed in `Data/Popes.lua`. Both clients `/reload` after install. Do not stub `IsRegisteredPope`. Do not invent extra names.

On **P**:

```
/run local ok,err=ChurchOfBeef.Net:SendState({eventId=1,state="ASSEMBLY",sequence=1}) print(ok, err)
```

- [ ] **P** prints `true` (or `true    nil`). Refuse here means the list is not live — stop; do not stub
- [ ] **C** Accepts only from that sender: `Runtime:Snapshot()` on C becomes `ASSEMBLY` with event id `1` and sequence `1`
- [ ] On **C**, `SendState` / `SendSnapshot` still print `not a registered pope`. C does not become a writer
- [ ] Repeat the step-3 congregation STATE forge from **C**. **P** does not Restore C's rite. P remains the only writer

### 5. SNAPSHOT is whisper-to-Pope only

`SendSnapshot` whispers. A blank target on the congregation sends defaults to the last accepted STATE sender, else the listed Pope. `BuildResponse` returns nothing while Runtime is `QUIET` (`no event`). Step 4's STATE echo is what makes P able to answer a request. Separately from this step: while an event is live, a guildmate HELLO (login / `/reload`) makes P re-broadcast STATE — the late joiner lands in the theater without asking.

On **C**, put a request on **GUILD** (wrong channel):

```
/run local N=ChurchOfBeef.Net N:Send(ChurchOfBeef.Snapshot:Request())
```

- [ ] Neither client answers. Inbound SNAPSHOT requires WHISPER. No GUILD fan-out

Whisper a request **to C** (from P). Prefix `COB`, body from `Snapshot:Request()`, channel `WHISPER`, target = C's name:

```
/run C_ChatInfo.SendAddonMessage("COB", ChurchOfBeef.Snapshot:Request(), "WHISPER", "<congregation character>")
```

If `C_ChatInfo.SendAddonMessage` is missing on that client, the transport's other guard is `SendAddonMessage` with the same four arguments.

- [ ] **C** does not answer (`_LocalPope` is false). No snapshot whisper comes back

Whisper a request **to P** (from C). Target = the Pope character David listed:

```
/run C_ChatInfo.SendAddonMessage("COB", ChurchOfBeef.Snapshot:Request(), "WHISPER", "<Pope character>")
```

- [ ] **P** answers on WHISPER only (after step 4 left P out of QUIET). **C** Accepts the response from that sender and Restores. C does not send a snapshot of its own
- [ ] Optional check from **P**: `SendSnapshot({role="response",...}, C's name)` succeeds only on P, and is a whisper, not GUILD

### 6. Retired traffic is discarded unread

Same `/run` forge style as the old standing smoke. Payloads are retired kinds. Do not rebuild a standing petition.

On **C**:

```
/run local N=ChurchOfBeef.Net N:Send(N:Encode("SUGGESTION","SomeoneElse",1,2,999,50))
/run local N=ChurchOfBeef.Net N:Send(N:Encode("SYNC_REQUEST"))
/run local N=ChurchOfBeef.Net N:Send(N:Encode("SYNC_STATE"))
/run local N=ChurchOfBeef.Net N:Send(N:Encode("RANK_COMMIT"))
```

- [ ] **P** does nothing: no reply on the wire, no chat line, no toast, no queue, no Restore, no error
- [ ] Same if **P** forges them at **C**

### 7. Quiet Mode on C — INPUT is not live

```
/run local N=ChurchOfBeef.Net local p=ChurchOfBeef.Codec:EncodeInput({kind="petition",characterId=1}) print(p) N:Send(p)
```

- [ ] The encode may print a body (`1:INPUT:petition:1`). `Net:Send` may put those bytes on GUILD. BeefNet still does not route INPUT
- [ ] **C** (and **P**) stay Quiet: no feed, no toast, no pip, no sound, no rite theater from that payload
- [ ] Unbidden Quiet chrome remains minimap + the active Decree only. The only Quiet notice allowed in this walk is the step-2 version line

A guildmate without the addon may be online. Nothing waits on them. That is §13.6, not a standing pass.

---

## Out of scope

Do not add boxes for these, and do not invent a path so they look walked:

- Favor split display (coded; needs a live sanctioned Gora — not this star walk)
- Confession fan-out (whisper INPUT is live; never public theater)
- SUMMON THE FAITHFUL
- Live HUD health (Appendix A item 1)
- 40-client rate limits (Appendix A item 3 — owner David; [`A03-sender-integrity.md`](../validation/A03-sender-integrity.md))
- Dress-rehearsal chaos night ([`dress-rehearsal.md`](dress-rehearsal.md))
- V1 / MVP complete (Bible §22.3)

---

## Pass / fail

**Pass:** steps 1–7 clean on two clients. HELLO version warns once. Unlisted send refuses. Listed P can `SendState`; C Accepts only that sender and does not become a writer. SNAPSHOT is whisper-to-Pope; C does not answer. Retired kinds die unread. INPUT does not paint Quiet.

**Fail:** a congregation STATE Restores on anyone; C answers a snapshot request; SNAPSHOT travels on GUILD and is treated as catch-up; `SendState` / `SendSnapshot` succeed on an unlisted character; a stub of `IsRegisteredPope` was used to force a pass; retired traffic is answered; version-warn spam; a standing / SUGGESTION / Officer-queue surface returns; a script error on either client.

**Not a pass:** green harness; one client; hosted HUD missing; A03 unproven; dress rehearsal unrun; Bible §22.3 Gathering.

**This smoke:** NOT RUN.
