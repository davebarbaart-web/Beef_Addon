# B3-E — Congregation Snapshot request send (review)

**Lane:** B3-E Congregation Snapshot request send
**Brief:** `docs/reformation/vestments/briefs/B3-E-snapshot.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B3-E-snapshot-report.md`
**Diff:** `docs/reformation/vestments/briefs/B3-E-snapshot.diff`
**Exclusive files:** `addon/ChurchOfBeef/Net/BeefNet.lua`, `tests/test_net_v2.lua`

**Spec:** PASS
**Quality:** Approved

Task-scoped gate only. Reviewer read the brief, the writer report, and the provided diff; then made one focused check per named risk (not Pope-gated; requires target; no new codec kind; no Pope name) plus the exclusive-file and sibling-gate pins. Did not mutate the working tree, did not re-run the harness, and did not treat writer counts as verified. This review does not sign the lane.

---

## Spec Compliance

- **Spec PASS**
- **Quality Approved**

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Codec / Snapshot.lua / `Data/Popes.lua` / Sender / Runtime / UI / TOC / bootstrap / `run.lua` / OPEN_QUESTIONS / REFORMATION_LOG / commit | **Pass.** Provided diff touches only the two exclusive files. |
| `RequestSnapshot(target, nowSeconds)` is not Pope-gated (congregation asks) | **Pass.** Named-risk check: no `_LocalPope()` on the send path. Suite pins `IsRegisteredPope(PlayerName()) == false` and the whisper still goes. Return why is `nil`, not `"not a registered pope"`. |
| Requires `target` (whisper destination). Missing → `false, "no target"`. Do not look up a Pope name | **Pass.** Named-risk check: `nil` and `""` fail before encode. No `LookupPope` / `FindPope` / `COB.Popes` read. Given target is passed through to `_TransmitWhisper`. |
| Body is `Snapshot:Request()` / `Codec:EncodeSnapshot({ role = "request" })` | **Pass.** Prefers `Snapshot:Request()`; Codec encode is the fallback. Suite pins the wire to `Snapshot:Request()` and to `1:SNAPSHOT:request`. |
| `_TransmitWhisper`. Size cap 240 | **Pass.** Same helper as `SendFavor` / `SendSnapshot`. Cap is `MAX_BODY` on `_TransmitWhisper`. Request body is role-only and well under 240. Not the GUILD outbound queue. |
| Do not add a new codec kind | **Pass.** Named-risk check: diff does not touch Codec. Transport `TYPES` stays `{ HELLO = true }`. Body is the existing SNAPSHOT **request** role, not a fifth TYPE, not a new INPUT kind, not a HELLO type. Closed-set pins at the end of the suite are unchanged. |
| Petition / confession stay unknown. `SendState` / `SendDecree` stay Pope-gated | **Pass.** Send path is SNAPSHOT request only. After a successful request, empty Popes list still blocks `SendState` / `SendDecree` / `SendSnapshot({ role = "request" })`. |
| Named tests (no target; given target whispers; empty Popes still blocks SendState). Isolation under `if standalone then` | **Pass.** All present. Existing `reset` / `wire` / `sent` spies reused. Isolation nil-module asserts stay gated. New pins sit in the shared body with `SendFavor`. |

Bible §20.3 late-join / reload ask is the missing congregation **send**. Inbound request answer stays `_LocalPope()` (unchanged; not this lane).

---

## Named risks

| Risk | Check |
|---|---|
| Not Pope-gated | **Pass.** `SendSnapshot({ role = "request" })` remains `_LocalPope()` and is a different method. `RequestSnapshot` does not call that gate. Local player is not a registered Pope in the suite; the whisper still succeeds. |
| Requires target | **Pass.** Fail-closed on non-string / empty. No guild-roster read, no `"Pope"` default, no `GetGuildRosterInfo` name used as destination. |
| No new codec kind | **Pass.** `1:SNAPSHOT:request` is the signed request role from Snapshot / Codec. No `Encode` type added. Petition / confession stay off this send. |
| No Pope name | **Pass.** Named-risk check: `COB.Popes` stays nil. `Net.LookupPope` stays nil after the send. Whisper target in the suite is `Steakina` (existing peer fixture, not a listed Pope). `Data/Popes.lua` is not in the diff. Header and method comment say do not look up a Pope name. |

---

## Strengths

- Congregation catch-up is a new method, not a hole punched in `SendSnapshot`. The suite keeps `SendSnapshot` request Pope-gated and names the split (`"SendSnapshot is not RequestSnapshot"`).
- Target is caller-supplied only. That is the #8 discipline: whisper destination is an argument, not a lookup, not a roster GM, not a hardcoded character.
- Body cannot grow STATE fields. `Snapshot:Request()` / `EncodeSnapshot({ role = "request" })` is role-only; extra snapshot schema would be a Codec refuse, and this lane did not open Codec.
- Sibling gates stay fail-closed on an empty Popes list after the congregation send. Runtime stays QUIET. `#Net.queue` stays 0 — catch-up is not GUILD fan-out.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Codec fallback is implemented, not pinned.** The `elseif COB.Codec.EncodeSnapshot` arm is dead in this suite because Snapshot is always `dofile`'d. Production TOC loads Snapshot before BeefNet. Brief licensed both encodings; they emit the same `1:SNAPSHOT:request` string. Coverage-could-be-broader.

---

## Assessment

**Spec PASS. Quality Approved.**

This is the B3-E send contract: congregation `RequestSnapshot` whisper, not Pope-gated, requires a caller-supplied target, body is the existing SNAPSHOT request role, no new codec kind, no Pope name. `SendState` / `SendSnapshot` / `SendDecree` stay Pope-gated. Exclusive files only.

Expected leftover (not a miss): a live client still needs a later caller on reload / late join that supplies the Pope character name. Inbound answer still requires `_LocalPope()`. Two-client smoke was not this lane.

Writer-reported isolated `lua tests/test_net_v2.lua` **433 / 0** was **not** re-run here.

No Critical or Important findings. Integrator can sign B3-E on this diff; do not block on the Minor. This review does not sign the lane.
