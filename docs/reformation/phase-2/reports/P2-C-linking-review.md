# Phase 2 Lane C — Adversarial Review

**Lane:** Rite of Recognition (Core flow)
**Exclusive files:** `addon/ChurchOfBeef/Core/Recognition.lua`, `tests/test_recognition.lua`
**Lane report:** `docs/reformation/phase-2/reports/P2-C-linking.md`
**Cited law:** Ten Laws 3, 4, 5, 7; Bible §12.2, §12.4; brief `docs/reformation/phase-2/briefs/P2-C-linking.md`; `.cursor/rules/identity-records.mdc` Linking
**Writer:** [Recognition](e3c25aed-3e66-4a59-ba2a-f0360697c813)

**Spec:** PASS
**Quality:** Approved

Core-only Recognition session. No self-service, silent same-account bind, or BattleNet auto-link. Begin does not write. Complete writes the Pope store via `Store:LinkCharacter` (then type-only `AppendCeremony` when present). Cancel writes nothing. Confirmer is a `pope` / `council` token; the write is still the Pope store. Logged-in character id is an argument — no `UnitName`, no `CreateFrame`. Isolated suite: **163 passed, 0 failed**. Writer stayed inside exclusive files. `Store.lua` not edited. `OPEN_QUESTIONS.md` unchanged. No commit.

## Verdict

Refutation of Laws 3, 4, 5, 7 and Bible §12.2 / §12.4 **fails** for this lane’s exclusive files.

Law 3’s Pope-only ritual list is Knighting, sanctioning Goras, verdicts, elevation, and canonization. §12.2 names the Rite of Recognition as Pope **or Council** confirmation with the logged-in character. On conflict the Bible wins. Council `Complete` is that confirmation; it calls the same Pope-store APIs. Officers, members, and `self` are refused.

Law 4 is intact: nothing auto-binds, auto-appends, auto-cancels, or writes scripture. Duration is session metadata. `IsExpired` is a query. Immediate `Complete` still requires the confirmer verb.

Law 5 is intact: one writer surface (`Store:LinkCharacter` / `AppendCeremony`). Recognition holds an ephemeral session only. There is no second store, no congregation theater, and no registered-Pope list (#8).

Law 7 and §12.4 are intact: no Unlink-as-delete, no sweep, no record expiry. Already-bound-to-another-human is refused. Same-human re-link is confirmation (`relink = true`; the character-id list does not grow). Name strings and `Names.Key` are not ids. Shared-account / BattleNet fields are ignored and not stored.

This review did not invent a Director Console or kneel UI, did not edit `Store.lua`, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| No self-service / silent same-account / BattleNet auto-link | **Yes.** `LinkSelf` / `AutoLink` / `BindAccount` / `BindBattleNet` / `SplitAccount` are `nil`. Roles `self`, `member`, `officer`, `battlenet` refuse and do not bind. Reviewer probe: `{ accountId, battlenetId }` on Begin is dropped from the session and does not bind. |
| Begin does not write; Complete writes Pope store via `LinkCharacter`; Cancel writes nothing | **Yes.** Suite and reviewer probe: after Begin, `humanId` is still nil, ceremony log is empty, history is only `created`. Complete calls `Store:LinkCharacter` then, if present, `AppendCeremony("Recognition", { characterId, humanId }, now)`. Cancel leaves the character unbound and the log empty. Failed Complete (mid-rite foreign bind) keeps the session and does not steal. |
| Confirmer is pope or council; store write remains Pope store | **Yes.** Role is case-folded to `pope` or `council`. Council Complete binds through `Store:LinkCharacter` / the human `characterIds` list. No second writer. `#8` is not consulted (brief: do not code). |
| Logged-in character id is an argument (no `UnitName` / `CreateFrame`) | **Yes.** Missing / name-string / `Names.Key` character ids refuse. Suite stubs `UnitName` to `"Impostor"`; the passed store id wins. Source has no `UnitName(` / `CreateFrame` / `SLASH_` / `SendAddonMessage`. |
| Refuse already bound to a different human | **Yes.** Begin refuses and does not open a session. `Store:LinkCharacter` refuses again on Complete if the row moved. Reviewer probe: mid-rite `LinkCharacter` to Dave, then Complete for Steve → error, Dave keeps the bind, Steve’s list stays empty. |
| Same-human re-link is confirmation, not a new identity | **Yes.** `relink = true`. Human `characterIds` stays length 1. A second `linked` history event and a second ceremony row are additive records, not a second human or character id. Tombstone + re-link leaves `inactive` set and the bind intact. |
| No generated scripture; ceremony append type only | **Yes.** Log entry is `{ type = "Recognition", at, participantIds }`. `scripture` / `narration` / `text` are nil. If `AppendCeremony` is absent, Complete still binds (append is optional per the brief). |
| No registered-Pope list (#8), kneel slash, Unlink-as-delete | **Yes.** No Pope-list lookup. `Kneel` / `OpenConsole` / `Unlink` / `SweepDeparted` are `nil`. `Store.Unlink` remains `nil`. Tombstone stays on Store. |
| Isolated suite green; `Store.lua` not edited by this writer | **Yes.** `lua tests/test_recognition.lua` → **163 passed, 0 failed** (reviewer rerun). Loads Common + Ranks + Store + Recognition. No Scoring / Ladder / DB / UI / Net. Writer transcript Writes: `tests/test_recognition.lua`, `Core/Recognition.lua`, `P2-C-linking.md` only. `Store.lua` was Read. `LinkCharacter` / `AppendCeremony` still match Lane A (cross-human refuse; no id-list duplicate; type + time + ids; no scripture). |
| Writer did not edit TOC / bootstrap / `run.lua` | **Yes.** Exclusive Writes only. Integrator already lists `Core\Recognition.lua` and `test_recognition` — not a writer miss. Bootstrap does not call `COB.Recognition`. |

Public functions after load: `Begin`, `Complete`, `Cancel`, `GetSession`, `IsExpired`, `ResetForTests`. Getters return copies. Expected failures are `nil, err`. `ResetForTests` is inert unless `COB._IN_TEST`.

## Attack results

| Attack | Result |
|---|---|
| Law 3 — Council `Complete` is Council performing a ritual? | **No.** §12.2 and identity-records say Pope **or Council** confirm the Rite of Recognition. Law 3’s non-delegable list does not include linking. The write is `Store:LinkCharacter` on the Pope store (Law 5). Officers are refused. |
| Law 3 — `Begin(..., "pope")` is self-service sovereignty? | **No.** The role is an honor token. `#8` (registered-Pope / designated-Council) is Phase 4 and must not be coded here. There is no `LinkSelf`. Later console must pass the real role. |
| Law 4 — duration `30` / `IsExpired` auto-declares or auto-advances? | **No.** Reviewer probe: expiry does not bind, append, or cancel. Immediate Complete still binds only because the confirmer called Complete. A forced 30s lock would invent a UI timer and could block the Pope. |
| Law 4 — `AppendCeremony("Recognition")` is generated scripture? | **No.** Type token + ids + timestamp. No narration fields. The software does not speak. |
| Law 5 — Council write or the session table is a second source of truth? | **No.** Canonical bind is the Pope store. The session is ephemeral (Begin writes nothing). Congregation UI/Net are not called. Ungated Store APIs are Lane A’s leftover; this lane only fronts them with a rite session. |
| Law 5 / §13.1 — any client that can call Complete writes locally? | **Same as Store.** This module does not invent a Pope-client gate. Later Net/UI must not call these writes on a congregation client. Do not add a Pope list here. |
| Law 7 — Cancel, expiry, or `ResetForTests` deletes Church history? | **No.** Cancel / expiry drop an unwritten session. `ResetForTests` is harness-gated. Tombstone + re-link does not clear `inactive`, rank, or the bind. No Unlink, prune, or sweep. |
| Law 7 — re-link creates a new identity? | **No.** Same human id, same character id, `characterIds` length 1. Extra `linked` / ceremony rows are history, not a second person. |
| §12.2 — no kneel / no logged-in proof, so this is a silent admin bind? | **No.** Brief: Core session the harness can drive; character id is an argument; do not invent kneel widgets or a Director Console. Begin still requires pope/council + existing store ids and does not write. Complete is the confirmer verb. |
| §12.2 — impersonation via a forged name string? | **No.** Name strings and `Names.Key` refuse. Binding a new store id that happens to reuse a spelling is a different character (reviewer probe: two `Chuckroast` rows, two humans, two binds). Human confirmation only. |
| §12.4 — shared-account / BattleNet machinery sneaks in via opts? | **No.** Extra opts are not stored. No split/bind-account API. Disputes stay social (Pope). `OPEN_QUESTIONS.md` was not edited. |
| §12.4 — transfer / faction change mints a new human or character? | **No.** Same-human Begin sets `relink = true`; Complete confirms the existing bind. |
| Writer edited `Store.lua` / TOC / bootstrap / `run.lua`, invented kneel UI / Director Console, or committed? | **No.** Exclusive Writes only. No commit. |

Refutation of Law 3 (Pope ceremonial sovereignty, with §12.2’s Council confirmation), Law 4 (software proposes; Pope/Council ratifies; no narration), Law 5 (one Pope writer), Law 7 (never-delete; rank stays on the human), and Bible §12.2 / §12.4 **fails** for the exclusive files.

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current except the integrator lines (already done). Additional leftovers this lane correctly did not touch:

### Integrator (already landed — writer report is stale)

- `ChurchOfBeef.toc` lists `Core\Recognition.lua`. Writer did not edit it.
- `tests/run.lua` lists `test_recognition`. Writer did not edit it.
- `ChurchOfBeef.lua` does not call `COB.Recognition`. Correct.

### Later UI / ceremony runtime (do not invent here)

- Kneel presentation, Director Console verb, congregation theater. Not this lane.
- **`IsExpired` must not become auto-Complete or auto-Cancel** (Law 4). Writer disclosed the Complete half. Auto-Cancel on expiry would also be software aborting the rite.
- Later UI must pass the **currently logged-in** character id at Begin and must not Complete a session after a character swap without a new Begin. Do not add `UnitName` to Core.
- `#8`: registered-Pope / designated-Council configuration remains Phase 4. This module accepts a role token.

### Lane A (store shape)

- Ceremony `participantIds` are bare store integers with no human/character tag. This lane writes `{ characterId, humanId }`. Callers must use the matching getter. Do not invent tagged ids.
- `LinkCharacter` remains callable without a rite. Recognition is the product front; later layers must not bypass it for a silent bind.

### Store / never-delete

- Tombstone / inactive stay on Store. Recognition has no Unlink.

## Findings

### Critical

None. No one-line Law 3 / 4 / 5 / 7 or §12.2 / §12.4 breach in the exclusive files.

### Important

1. **`confirmerRole` is an unauthenticated token.** `Begin(..., "pope")` does not look up a Pope list or `Store.council`. That is required (`#8` do not code). Later console / Net must not treat the string as proof of sovereignty.

2. **Duration does not gate Complete.** Reviewer probe: `Complete` at `startedAt` binds. Correct under Law 4 and the brief (no UI timer). Later presentation owns the thirty-second kneel beat. Do not add a wait lock in Core.

3. **Ceremony `participantIds` stay untagged.** Same Lane A leftover this lane correctly reused. A human id and a character id can both be `1`. Do not fork a second ceremony schema here.

### Nit

1. **Writer leftover map is stale** (`P2-C-linking.md`). TOC and `tests/run.lua` already list Recognition / `test_recognition`. Integrator, not a writer miss. Does not reopen Spec.

2. **`Complete` does not unwrap Begin’s `{ now, duration }` table.** Reviewer probe: `Complete({ now = 1001 })` still binds, but `Clock.Wall` ignores the table and stamps `0` (or `time()`). Suite and Store APIs pass a number. Do not invent a Complete opts object.

3. **Isolated load includes `Data/Ranks.lua`.** Brief named Common + Store + Recognition. Ranks is Store’s `ById` helper; the suite uses `RankForCharacter`. Not Scoring / Ladder. Harmless.

4. **Confirmer role is not copied onto the ceremony row.** Brief did not ask for it. Do not invent a confirmer-id field.

5. **`AppendCeremony` failure is ignored after a successful link.** Brief: append if Store offers it. The `linked` history event still records the bind.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated Common + Store + Recognition; no `CreateFrame` | Met (163 / 0; Ranks loaded for Store) |
| No self-service / silent same-account / BattleNet auto-link | Met |
| Begin (human id + character id + confirmer role); logged-in id is an argument | Met |
| Begin does not write; Complete → `Store:LinkCharacter`; Cancel → no write | Met |
| Refuse already bound to a different human | Met |
| Council may confirm; store write remains the Pope store | Met |
| Same-human re-link is confirmation, not a new identity (§12.4) | Met |
| Shared accounts: no machinery | Met |
| Ceremony append if Store offers it; no generated scripture | Met |
| No registered-Pope list (#8), kneel slash, UI timer, Director Console, congregation theater, Unlink-as-delete | Met |
| Do not edit TOC / bootstrap / `run.lua` / `Store.lua` / UI / Net | Met (integrator listed Recognition after) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 3, 4, 5, 7
- Brief `docs/reformation/phase-2/briefs/P2-C-linking.md`
- Writer report `docs/reformation/phase-2/reports/P2-C-linking.md`
- Bible §12.2, §12.4 (and §12.1 / §12.3 as identity context)
- `.cursor/rules/identity-records.mdc` Linking
- `addon/ChurchOfBeef/Core/Recognition.lua`
- `tests/test_recognition.lua` (isolated run: 163 / 0)
- `addon/ChurchOfBeef/Core/Store.lua` (`LinkCharacter` / `AppendCeremony` only — not edited this lane)
- Writer transcript ([Recognition](e3c25aed-3e66-4a59-ba2a-f0360697c813)) — exclusive Writes only
- `ChurchOfBeef.toc` / `tests/run.lua` / `ChurchOfBeef.lua` (integrator listings; bootstrap does not call Recognition)
- `docs/design/OPEN_QUESTIONS.md` (unchanged; #8 do not code)
- Reviewer probes: immediate Complete; mid-rite foreign bind; name-reuse twins; tombstone re-link; sneaked account opts; missing `AppendCeremony`; banned roles; no `UnitName(` / `CreateFrame`
