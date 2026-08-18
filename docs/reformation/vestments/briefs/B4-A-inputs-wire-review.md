Spec PASS

# B4-A — Petition and confession INPUT on the wire (review)

**Lane:** B4-A Petition and confession INPUT on the wire
**Brief:** `docs/reformation/vestments/briefs/B4-A-inputs-wire.md`
**Writer report (unverified claims except isolated count):** `docs/reformation/vestments/briefs/B4-A-inputs-wire-report.md`
**Diff:** `docs/reformation/vestments/briefs/B4-A-inputs-wire.diff`
**Exclusive files:** `addon/ChurchOfBeef/Net/BeefNet.lua`, `tests/test_net_v2.lua`

**Spec:** PASS
**Quality:** Approved

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, current `BeefNet.lua`, and the B4-A pins in `tests/test_net_v2.lua`. Isolated `lua tests/test_net_v2.lua` was re-run: **523 passed, 0 failed, exit 0**. Did not edit addon code or tests. Did not commit. Did not run `lua tests/run.lua`. This review does not sign the lane.

The provided diff is the exclusive pair versus last commit, so it also contains earlier uncommitted W-D / B3-E hunks on the same two files (`SendDecree`, `SendFavor`, `RequestSnapshot`). Sibling dirt on `Codec.lua` / `Gora.lua` / `Confession.lua` is other lanes. This review judges the current exclusive-pair source against the B4-A brief, not those siblings.

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| `SendPetition` / `SendConfession` exist; not Pope-gated | **Pass.** Both methods exist. Neither calls `_LocalPope()`. Suite pins local `IsRegisteredPope(PlayerName()) == false` and both whispers still succeed; return why is `nil`, not `"not a registered pope"`. |
| Missing / empty `target` → `false, "no target"`. No Pope-name lookup | **Pass.** `nil` and `""` fail before encode. No `LookupPope` / `FindPope` / `COB.Popes` read. Whisper target is the caller argument (`"Pope"` in the suite — already the `SendFavor` fixture, not a listed Pope). `COB.Popes` stays nil. |
| Petition wire is `characterId` only (no named opponent) | **Pass.** Send rebuilds `{ kind = "petition", characterId }` and drops `namedOpponentId`. Suite sends `namedOpponentId = 99` and pins payload `1:INPUT:petition:12`. Recv calls `Gora:Petition(decoded.characterId)` only; spy pins `namedOpponentId == nil`. |
| Confession newline refused before encode | **Pass.** Load-bearing: `fields.text:find("\n", 1, true)` returns `false, "invalid text"` before `EncodeInput`. Codec `EncodeInput` does **not** refuse `"\n"` and does not emit `"invalid text"` — that string exists only on this send. Suite pins no whisper growth. |
| Inbound INPUT whisper-only; favor / petition / confession routed; GUILD INPUT unknown | **Pass.** `_HandleV2` returns `"unknown message type"` for INPUT on a non-WHISPER channel **before** the version gate. Favor still `_HandleFavor`. Petition / confession route to the new handlers. GUILD petition / confession / favor stay unknown on a Pope client too. |
| Petition recv → `Gora:Petition`; confession recv → `Confession:Receive` if exists else `false` | **Pass.** Local Pope required (`"not a registered pope"` otherwise). Missing `Gora.Petition` / missing `Confession.Receive` → `false`. Stubbed Pope whisper calls `Petition(12)` and `Receive(3, "free text")`. Missing Confession module is pinned fail-closed. Core errors pass through (`"no event"`). Never Restore. Never fan out. No inbox. |
| `SendState` still Pope-gated | **Pass.** `_LocalPope()` unchanged. After a successful `SendPetition`, empty Popes list still returns `false, "not a registered pope"` and `#Net.queue` stays 0. Stubbed predicate still opens `SendState`. |
| No extra codec kinds | **Pass.** This lane does not edit Codec. `Codec.INPUT_KINDS` stays `{ petition, favor, confession }`. `Codec.TYPES` stays STATE / SNAPSHOT / INPUT / DECREE. Transport `TYPES` stays `{ HELLO = true }`. No `SendInput`. Closed-set pins at the end of the suite are unchanged. |
| Isolated suite green; isolation under `if standalone then` | **Pass.** Verified: `lua tests/test_net_v2.lua` → **523 passed, 0 failed, exit 0**. Standalone loads stay Common + Runtime + Codec + Snapshot + Sender + BeefNet. Gora / Confession / Store / UI / DB / Popes nil asserts stay under `if standalone then`. |

Bible §9 / §10.2 wire (id only) / §13.1 / §13.4 / §18.5 and CONTINUE license 2 are met: petition and confession join favor on whisper-to-Pope. Congregation send is not Pope-gated. Only the Pope's client applies. GUILD INPUT stays not-a-live-channel.

---

## Named risks

| Risk | Check |
|---|---|
| Not Pope-gated | **Pass.** Send path has no `_LocalPope()`. `SendState` / `SendSnapshot` / `SendDecree` still have it. Local player is not a registered Pope in the send block; the whispers still go. |
| Requires target | **Pass.** Fail-closed on non-string / empty before codec. No guild-roster read, no `"Pope"` default, no `GetGuildRosterInfo` name used as destination. `_TransmitWhisper` is the only transmit. |
| No new codec kind | **Pass.** Existing INPUT kinds only. Body rebuild forces `kind`. Extra fields (`namedOpponentId`, `pick` on petition) never reach `EncodeInput`. |
| No Pope name | **Pass.** `COB.Popes` stays nil. `Net.LookupPope` stays nil after send. Header and method comments say do not look up a Pope name. `Data/Popes.lua` is not in the exclusive pair. Pope predicate is stubbed name-aware (`beefina`) and restored. |

---

## Strengths

- Send cannot smuggle a named opponent or a foreign INPUT kind. Both methods rebuild a closed body, then whisper. That is the brief’s “no named-opponent field” rule on the wire, not a comment.
- Newline refuse is on BeefNet, before encode, with a unique `"invalid text"` why. Codec would have encoded `"a\nb"` into the payload. The pin is therefore the real gate, not a codec echo.
- Recv is fail-closed the same way favor already was: whisper + `_LocalPope()`, then Core. Missing Confession does not invent a queue. `Gora:Petition` errors return. Runtime stays put. `#wire` stays 0.
- GUILD INPUT stays `"unknown message type"` *before* the version check, so it does not grow a second refuse vocabulary on a live Pope client.
- Sibling gates stay fail-closed on an empty Popes list after the congregation sends. `#Net.queue` stays 0 — these are not GUILD fan-out.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **`test_wire_glue.lua` still pins whispered petition as `"unknown message type"`.** After this lane a non-Pope whisper returns `"not a registered pope"` (same as favor). Writer flagged it. Exclusive set forbade that file. Integrator must update the glue suite before a full `lua tests/run.lua`. Not a B4-A miss.

2. **Gora / Confession stubs are assigned, then niled, not restored.** `Sender.IsRegisteredPope` is saved and put back. `COB.Gora` / `COB.Confession` are overwritten and set to `nil`. Later harness suites re-`dofile` those modules, so this is not a poison today. Same save/restore as the predicate would be cheaper hygiene.

3. **`Confession:Receive` error path is implemented, not pinned.** Missing module is pinned. `Gora:Petition` `"no event"` is pinned. A stubbed `Receive` that returns `nil, err` is not. The handler passes Core errors through the same way as petition / favor. Coverage-could-be-broader.

---

## Assessment

**Spec PASS. Quality Approved.**

This is the B4-A transport contract: congregation `SendPetition` / `SendConfession` whisper, not Pope-gated, require a caller-supplied target, petition id only, confession newline refused before encode, inbound INPUT live on WHISPER only into `Gora:Petition` / `Confession:Receive` (missing module fail-closes). `SendState` stays Pope-gated. No extra codec kind. No Pope-name lookup. Isolated suite green (523 / 0, exit 0). Exclusive pair only.

Expected leftover (not a miss): `tests/test_wire_glue.lua` still names whispered petition `"unknown message type"`. Live send still needs a caller-supplied Pope character name plus two-client smoke. Inbound apply still needs `_LocalPope()` plus Core (`Gora:Petition` / `Confession:Receive`). Writer status **DONE_WITH_CONCERNS** matches that leftover.

No Critical or Important findings. Integrator can sign B4-A on the exclusive pair; do not block on the Minors. This review does not sign the lane.
