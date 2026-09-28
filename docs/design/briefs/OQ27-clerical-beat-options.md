# OQ27 — Clerical beat on STATE

**For:** David / Design Lead  
**Date:** 2026-09-14  
**Status:** Options only. Do not pick here. Do not implement from this file.  
**Question:** `docs/design/OPEN_QUESTIONS.md` #27  
**Cited:** Bible §13.1, §13.4, §19.2, §19.4, §20.1–20.3, §21.1; Law 4, Law 5, Law 6; Wave 2 review §2.2; live `Net/Codec.lua` `STATE_KEYS` (read 2026-09-14).

This brief does not resolve #27 and does not edit `OPEN_QUESTIONS.md`.

---

## The question

Congregation theater cannot tell Victor vs Void vs Free vs Cowardice vs Knighting vs Elevation from the Bible §20.2 fields that STATE already carries.

**May PROTOCOL 2 carry a closed optional beat (plus display names) so inbound `Toasts:Proclaim` / `Sound` fire once, or does spectacle stay Pope-local until a later licensed TYPE?**

Two options. No third. Inferring a kind from `state` + `riteType` is not on the table.

---

## Why inferring kind is illegal

Bible §20.2 says broadcast state carries **event id, state, rite type, active subjects (candidate, fighters), and a sequence number.** That is the ceremony skeleton. It is not a clerical ledger.

Live `STATE_KEYS` match that skeleton (plus favor):

`type`, `version`, `eventId`, `state`, `riteType`, `subjects`, `sequence`, `favor`

Closed allowlist. An extra colon part is `"unknown field"`. There is no beat, no ruling, no winner name, no stipulation, no free-ruling prose.

**Verdicts do not `CloseRite`.**

`Runtime:CloseRite` is its own Pope verb: `RITE` → `CONSEQUENCE`. It does not name a ruling. It does not write a Gora or Knighting record.

The clerical verbs write the store, then the Pope client wraps locally (`Toasts:Proclaim` + `Sound`) and `sendState()`:

| Pope verb | Store / ceremony | Runtime after the verb | Local wrap |
|-----------|------------------|------------------------|------------|
| `Gora:DeclareVictor` | victor W/L | still `RITE` + `Gora` + last pair | `verdict` / victor |
| `Gora:Void` | void | still `RITE` + `Gora` + last pair | `verdict` / void |
| `Gora:FreeRuling` | free (no W/L) | still `RITE` + `Gora` + last pair | `verdict` / free |
| `Gora:CowardiceRecorded` | cowardice | still `RITE` + `Gora` + last pair | `cowardice` |
| `Knighting:KnightThisBeef` | Knight record | still `RITE` + `Knighting` + candidate | `knighting` |
| `Knighting:ElevateToLord` | Lord record | still `RITE` + `Knighting` (or later) + subject | `elevation` |
| `Runtime:CloseRite` | none | `CONSEQUENCE` (rite type leftover) | none |

So after a ruling the wire still says **`RITE` + `Gora` + the same two fighter ids**. After a Knighting it still says **`RITE` + `Knighting` + the same candidate**. `CONSEQUENCE` means the Pope closed the rite — maybe after a verdict, maybe instead of one, maybe after a different rite.

A pew that guesses from `state` + `riteType` therefore cannot distinguish:

- sanctioned fight in progress vs already-ruled tape still on the wire
- Victor vs Void vs Free vs Cowardice (all four leave the same STATE)
- Knighting vs Elevation vs “candidate still kneeling”
- `CONSEQUENCE` after a close with no ruling vs `CONSEQUENCE` after any of the above

Guessing `RITE` + `Gora` = sanction re-proclaims the bell on every later STATE — including favor overlays (`RecordFavor` does not bump sequence) and the Pope’s HELLO-triggered refresh. Guessing `CONSEQUENCE` = verdict puts **software in the Pope’s mouth** (Law 4) and invents a verdict the Net is forbidden to invent (Law 5 / §13.1). Wave 1 item 37 was that fiction.

Do not infer kind. Do not add a generic theater opcode. Do not grow STATE on PROTOCOL 1 (extra fields make old clients discard STATE without `_WarnVersion` and sit on whatever `DB` restored).

---

## Night-one refuse path (not an answer)

Until David picks, implementers stay on **A**:

- PROTOCOL 2 packed **display names** only (fighters / candidate). Paint HUD / fighter card. Never upsert congregation Store.
- Inbound `Toasts:Proclaim` / `Sound` **off**.
- Pope client still wraps locally on his own verbs.
- No clerical kind on the wire.

That is the Wave 2 default (`docs/superpowers/specs/2026-09-14-church-of-beef-wave-2-review.md` §2.2 / §4). It is a refuse path, not a resolution of #27.

---

## Option A — Pope-local spectacle until a later licensed TYPE

**Wave 2 default.** Congregation is a named display terminal, not a pew that hears the bell.

### What ships

- PROTOCOL 2. Packed display names only. 240-byte pin through `Net:Send`. Snapshot overlay + inbound name stash for paint.
- HUD and mute card show the names the Pope already put on STATE. Favor split may still overlay when licensed by the existing favor field.
- No inbound parchment. No inbound §19.4 cue. Quiet Mode stays silent (Law 6).
- Pope `/reload` and congregation late-join still land in the right **state** (ASSEMBLY / RITE / CONSEQUENCE) with names. They do not replay a clerical beat.

### What waits

- Congregation `Toasts:Proclaim` and `Sound:Play`.
- Any later **TYPE** David licenses for spectacle (not a guessed STATE kind; not a generic theater opcode). This brief does not invent that TYPE or its fields.

### What the pew notices

A zip-install recruit sees two names on the fight bar and can pick a side. They do not see “A Beef Gora is Sanctioned,” “VICTOR DECLARED,” “RISE, BEEF KNIGHT,” or hear the Sanction bell / Verdict / Knighting / Elevation / Cowardice cues on their client.

Bible §21.1 names those bells as a reason to install (“when a Gora is sanctioned somewhere in the world, installed clients hear it”). **A postpones that sentence** until a later licensed TYPE. The Church still functions; the second client is quieter than the Pope’s.

### Bounds A does not relax

- No inferred kind.
- No W/L, H2H, title, stipulation, or free-ruling prose on the wire this pass.
- No congregation Store write from names.

---

## Option B — PROTOCOL 2 closed optional beat + display names

**Same PROTOCOL 2 names as A**, plus one optional closed beat field on STATE so inbound spectacle can fire **once**.

### What ships if licensed

- PROTOCOL 2 allowlist grows by one optional field: a **closed kind enum**. Absent field = names only, no Proclaim / Sound (A-shaped apply).
- Packed display names remain paint-only. Never upsert congregation Store.
- On an **accepted Pope STATE** (registered-Pope sender, `Sender:Accept`), while Runtime is Event Mode (`ASSEMBLY` / `RITE` / `CONSEQUENCE`), and the sender is **not** `IsSelf`:
  - inbound `Toasts:Proclaim` once
  - inbound `Sound:Play` once
- **Do not fire** on HELLO, on favor-only overlays, or on SNAPSHOT apply. Late join / `/reload` land in the right theater; they do not replay the bell.
- HELLO-triggered Pope refresh `sendState()` omits the beat (refresh is catch-up of skeleton + names, not a second clerical verb).
- Equal sequence must not Proclaim / Sound again. Ceremony apply stays latest-wins (`sequence` greater). Favor overlay must not carry or re-fire a beat.
- Unknown kind: **fail-closed**. Drop the beat (no sheet, no cue). Do not degrade the rest of a valid STATE. Do not guess a fallback kind. Do not print oratory.

### Closed kind enum (existing Pope-local wraps only)

B would put on the wire only the kinds the Pope client already wraps locally. Nothing new:

`sanction` · `victor` · `void` · `free` · `cowardice` · `knighting` · `elevation`

That is the local `InstallWire` set (`sanction`, `verdict`+ruling, `cowardice`, `knighting`, `elevation`), flattened so one optional field is enough. Fail-closed anything else — including a generic `verdict`, a free-text kind, or a future rite.

§19.4 cues map onto that set: Sanction bell, Verdict, Cowardice, Knighting, Elevation. `void` / `free` may share the Verdict cue or stay silent; this brief does not invent a sixth cue.

### What stays off the wire this pass

- W/L tallies
- Head-to-head
- Title
- Stipulation
- Free-ruling prose (Pope-typed text stays on the Pope console; inbound `free` uses the existing mute fallback “Free ruling.” — not generated oratory, not the desk box)

Mute-card replica remains out. B is a clerical **kind**, not a gossiped record.

### Payload bound David should see before picking B

Packed names are **fighters / candidate**, not a winner id. After `DeclareVictor` / `CowardiceRecorded` the pair is still the pair. B as specified does **not** add a winner/fleer token this pass.

So inbound `victor` / `cowardice` can license the **kind** (sheet chrome + cue) without a lawful named subject unless David later licenses more than this pass allows. Local `clericalCopy` today refuses `victor` / `cowardice` / `knighting` / `elevation` without a name. Knighting / elevation can use the packed candidate; the Gora pair cannot lawfully pick a winner by inference. That is a bound of B, not a hidden Option C.

### Fire-once (restated)

| Gate | Fire? |
|------|--------|
| Accepted Pope STATE, Event Mode, new ceremony `sequence`, beat present and known, not `IsSelf` | Once |
| `IsSelf` (Pope’s guild echo) | No — Pope already wrapped locally |
| HELLO | No |
| Favor overlay / `RecordFavor` STATE | No |
| SNAPSHOT request or response | No |
| Equal `sequence` | No |
| Unknown kind | Fail-closed; no sheet, no cue |
| Quiet Mode | No (Law 6) |

No generic theater TYPE. No store-gossip. Say “closed optional STATE field,” not “no new protocol.” PROTOCOL 2 is already required for names.

---

## Shared (both options)

- PROTOCOL bump to 2 for packed display names. Paint-only. 240-byte pin.
- Subjects on the wire stay store integers; names are a display overlay, not identity.
- Theatrical UI only from a registered-Pope sender (§13.4).
- Player-typed free text stays on the Pope console.
- Net does not invent ranks or verdicts.
- Quiet Mode: no toasts, no sound, except the existing §13.4 version-mismatch notice.
- Wave 2 first-night plan does not inbound-Proclaim until this question is answered.

---

## What David is choosing

| | A | B |
|--|---|---|
| PROTOCOL 2 names on HUD / card | Yes | Yes |
| Inbound Proclaim / Sound | No | Yes, once, closed kind |
| Beat field on STATE | No | Optional, fail-closed |
| Later spectacle | A later **licensed TYPE** (undesigned here) | Already on STATE |
| §21.1 “installed clients hear it” | Postponed | Licensed this pass |
| Night-one refuse until you answer | **This** | Not yet |

Pick A or B. Do not infer. Do not invent a third opcode.
