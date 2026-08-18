Spec PASS

# B17-B — Send/recv petition opponent (review)

**Quality:** Approved-with-nits

**Lane:** B17-B Send/recv petition opponent
**Brief:** `docs/reformation/vestments/briefs/B17-B-petition-opponent.md`
**Writer report:** `docs/reformation/vestments/briefs/B17-B-petition-opponent-report.md`
**Diff:** `docs/reformation/vestments/briefs/B17-B-petition-opponent.diff` (B17-B-only exclusive-pair packet; live `BeefNet.lua` also carries earlier net batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/Net/BeefNet.lua`, `tests/test_net_v2.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `Net/BeefNet.lua` (`SendPetition` opponent copy, `resolveOpponentId`, `_HandlePetition`), and `tests/test_net_v2.lua` (existing no-opponent send/recv pins, new B17-B `do` block); then ran `lua tests/test_net_v2.lua` (**551 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.2 / §13.1 / §18.5 (petition may name a desired opponent; congregation input carries a **name string**, not a Pope Store id); B4-A leftover ("petition id only") closes here; opponent resolves via `Store:Snapshot().characters` + `Names` first-match; miss does not `Petition`; no-opponent path unchanged; isolation does not load Store; no Pope-name lookup; GUILD INPUT unknown. Did not mutate `BeefNet.lua` or `test_net_v2.lua`. Did not commit. Did not edit Codec, Inputs, Gora, Store, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `SendPetition` copies `namedOpponentId` / a Store id onto the wire | **Pass. Verified.** Body is a fresh `{ kind, characterId }` plus a non-empty string `fields.opponent` only. No `body.namedOpponentId`. Existing pin: `namedOpponentId = 99` still encodes `1:INPUT:petition:12`. New pin: opponent + id 99 still `1:INPUT:petition:12:Chuckroast`. Reviewer spies: numeric `opponent`, id-only, and empty / whitespace `opponent` stay four-part (Codec omits blank). Colon name is `"invalid opponent"` (Codec). |
| Inbound miss still calls `Petition` (silent drop of the challenge) | **Pass. Verified.** Pins: Store nil and empty `characters` → `false, "unknown opponent"`; spy count unchanged. Reviewer spies: populated-list miss, missing `characters` key, `Snapshot()` nil, name-match with `id == nil`, and characters hash (`# == 0`) all refuse and do not `Petition`. |
| No-opponent path changed | **Pass.** Existing send `1:INPUT:petition:12` and recv spy `namedOpponentId == nil` stay. Reviewer spy: four-part inbound still `Petition(12, nil)` even when a Store stub is present. `_HandlePetition` only resolves when trimmed `decoded.opponent` is a non-empty string. |
| Isolation loads Store / suite `dofile`s Store | **Pass.** Load list is still Common + Runtime + Codec + Snapshot + Sender + BeefNet. No `dofile` Store. Wrap still **11** nils under `if standalone then`. B17-B stubs `Store.Snapshot` in-file, then nils Store / Gora and re-pins both. |
| Pope-name lookup added | **Pass.** `SendPetition` still fails missing / empty target with `"no target"`. Source has no `LookupPope` / `FindPope`. Existing pin `Net.LookupPope == nil` stays. New send is still not Pope-gated (`"Host"` is caller-supplied). |
| GUILD INPUT accepted | **Pass. Verified.** `_HandleV2` still returns `"unknown message type"` for INPUT off WHISPER before `_HandlePetition`. New pin: five-part GUILD stays unknown and does not `Petition`. Reviewer spy: same. |
| Isolated suite not exit 0 | **Pass. Verified.** 551 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two `diff --git` hunks (header + `SendPetition` opponent copy + `resolveOpponentId` + `_HandlePetition` resolve; nested `do` pins). Sibling dirt in this workspace is other lanes (Codec B17-A, Inputs B17-C, HUD B17-D). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Codec / Inputs / Gora / Store / glue; no commit; no new codec kind | **Pass.** Named-risk check. BeefNet `TYPES` stays HELLO-only. |
| Isolation stays Common + Runtime + Codec + Snapshot + Sender + BeefNet; do not `dofile` Store; stub `Store.Snapshot` | **Pass.** Named-risk check. |
| `SendPetition` still not Pope-gated; missing target → `false, "no target"`; no Pope-name lookup | **Pass.** Named-risk check. |
| Body is `{ kind = "petition", characterId }` and, when `fields.opponent` is a non-empty string, `opponent = fields.opponent` | **Pass.** Live copy is `type == "string" and ~= ""`. Pin: `Chuckroast` → `1:INPUT:petition:12:Chuckroast`. |
| Do not copy `namedOpponentId` onto the wire | **Pass.** Named-risk check. |
| Encode via `Codec:EncodeInput`; `_TransmitWhisper`; size cap 240 | **Pass.** `SendPetition` still `_TransmitWhisper`. `MAX_BODY` is still 240. Reviewer spy: a 230-char opponent returns `"payload too large"` and does not whisper. |
| `_HandlePetition`: WHISPER + `_LocalPope()` stay; GUILD INPUT stays unknown | **Pass.** Named-risk check. Non-Pope five-part is `"not a registered pope"` and does not `Petition`. |
| No opponent → `Gora:Petition(characterId)` (`namedOpponentId == nil`) | **Pass.** Named-risk check. |
| `decoded.opponent` present: first-match `Store:Snapshot().characters` via `Names.Key` / `Names.Same` (same walk as `bindLocalCharacter`) | **Pass.** `for i = 1, #chars` + `Names.Same(row.name, opponentName)`. `Names.Same` is `Key(a) == Key(b)`. Existence requires both `Key` and `Same`. Hit pin: `Petition(12, 7)`. Reviewer spies: case-fold and realm-strip match; first array index wins. |
| Missing Store, missing list, or no match → `false, "unknown opponent"`; do not call `Petition` | **Pass.** Named-risk check. |
| Match → `Gora:Petition(characterId, namedOpponentId)` | **Pass.** Hit pin `namedOpponentId == 7`. |
| Header comment: petition may carry an opponent name | **Pass.** File header and `SendPetition` comment updated. B4-A "never a named opponent" line is gone. |
| Keep existing no-opponent pins; add Chuckroast send / inbound resolve / Store nil / empty characters / GUILD unknown | **Pass.** All present in the nested `do` after the existing Pope petition pins. |
| Isolation wrap stays; `lua tests/test_net_v2.lua` exit 0 | **Pass.** **551 / 0.** Wrap **11**. |

Bible §10.2 / §13.1 / §18.5 hold on the exclusive pair: the wire carries a name, the Pope client resolves it, and a miss does not silently `Petition`. Law 4 holds: Net does not announce the callout or invent a rite.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No two-client smoke; harness uses `Net.transmit` and an in-file `Store.Snapshot` stub | **Not a miss.** Brief asked the isolated suite. |
| B17-A Codec is a load-time dependency | **On contract.** This lane does not edit Codec. Live `EncodeInput` / `Decode` already accept `opponent`. If Codec drops the field, send returns the codec error and five-part inbound stays unknown. |
| First-match only; a characters hash has `#chars == 0` and refuses | **On contract / leftover.** Brief named the `bindLocalCharacter` `#chars` walk. Production `Store:Snapshot()` uses `listCopy` (id-sorted array). Reviewer spy: live Store resolves `chuckroast-whitemane` to the Chuckroast row. A hash stub refuses — same as a missing list. |
| Populated-list miss is not a separate pin | **Leftover — not a miss.** Brief asked Store nil or empty `characters`. Probe: wrong name in a non-empty list is `"unknown opponent"` and does not `Petition`. |
| Production `Gora:Petition` still validates the id | **On contract.** Brief: pass `row.id` through. Gora source was not edited. |
| Gate W / Gate V stay OPEN; lane not signed | **On contract.** This review does not sign either. |

Inputs already calls `COB.Net:SendPetition` and (B17-C sibling) may set `fields.opponent` from `UnitName("target")`. Bootstrap / INT glue is not required.

---

## Isolation / send / recv

**Isolation wrap — Pass.** Load list is still Common + Runtime + Codec + Snapshot + Sender + BeefNet. No `dofile` of Store / UI / DB / Popes / Gora. Standalone wrap is still **11** nils (Store, UI, DB, Popes, Officer, Ranks, Archive, Recognition, Gora, Decree, Confession). Reviewer probe: those keys are nil at load. B17-B re-pins Store / Gora nil after the in-file stub. Main-chunk locals stay **86** (new pins nested in a `do` block). Wrap is load-time only (unchanged).

**Send — Pass.** Not Pope-gated. Missing / empty target is still `"no target"`. Non-empty string `opponent` is copied; `namedOpponentId` is not. Encode + whisper + 240 cap stay. No `LookupPope`.

**Recv — Pass.** WHISPER + `_LocalPope()` stay. No opponent → `Petition(characterId, nil)`. Opponent present: first `Names.Same` hit on `Snapshot().characters` → `Petition(characterId, row.id)`. Miss / no Store / no list → `"unknown opponent"` and no `Petition`. GUILD INPUT stays unknown before `_HandlePetition`.

---

## Strengths

- Resolve is a local helper in front of `Petition`. Failed path cannot call `Gora`. Comparator is `namedOpponentId == nil`, so a numeric `0` would pass through; production `listCopy` ids are `>= 1`.
- Wire stays a name. The existing `namedOpponentId = 99` four-part pin was left in place; the new pin covers opponent + id together.
- Store nil and empty `characters` are both pinned, and GUILD is re-pinned on the five-part payload. Isolation wrap was not rewritten. Store is never `dofile`d.
- `Names.Same` matches the `bindLocalCharacter` walk (`#chars`, first hit) and inherits Key's case / realm fold. Production Snapshot is an id-sorted list, not a hash.
- Writer-reported **551 / 0** and **11** isolation pins matched the re-run. Main-chunk locals **86** matched.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Populated-list miss is unpinned.** Brief asked Store nil or empty `characters`. A wrong name in a non-empty list takes the same refuse path. Reviewer probe: `"unknown opponent"`; spy count unchanged. Cleanup is test-only.

### Nit

1. **`Names.Key` is required but not called.** `resolveOpponentId` gates on `Names.Key` and `Names.Same`, then walks with `Same` only. `Same` is `Key(a) == Key(b)`. `bindLocalCharacter` compares `Key` values. Reviewer spy: `Same` without `Key`, or `Key` without `Same`, refuses `"unknown opponent"` and does not `Petition`. Missing `Names` on `OnAddonMessage` dies earlier (`nameKey` nil → `"sender is talking too fast"`); direct `_HandlePetition` still names `"unknown opponent"`.

2. **`row.id` is not type-checked.** A name hit with `id = "7"` calls `Petition(12, "7")`. Production Store ids are integers; Gora then `isId`-checks. A name hit with `id == nil` is treated as a miss (fail-closed).

3. **First-match is array order.** Duplicate `Names.Same` rows pick `chars[1]`. Production `listCopy` sorts by id (lowest id wins). An unsorted stub does not.

4. **A characters hash stub refuses.** `#chars == 0`. Writer disclosed. Not a production `Store:Snapshot()` shape.

5. **Isolation wrap is load-only.** Eleven pins under `if standalone then` at file load, plus two Store / Gora re-pins after the stub. There is no end wrap after later Runtime / Gora stubs. Brief said the wrap stays; it did.

6. **Exclusive-pair diff is not a vs-HEAD BeefNet delta.** Packet is the B17-B-only header + opponent copy + resolve + pins. `git diff HEAD` on the two files still includes earlier net batches. Report already says this.

7. **No `/reload` / two-client smoke and no full `lua tests/run.lua`.** Isolated **551 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **551 passed, 0 failed.** Isolation wrap: **11**.

`SendPetition` may copy a non-empty opponent **name** onto `EncodeInput` and whisper it. It does not copy `namedOpponentId`, does not look up a Pope name, and still fails missing target with `"no target"`. `_HandlePetition` with no opponent still `Petition`s the character id only. A present name resolves first-match on `Store:Snapshot().characters` via `Names.Same`; miss / no Store / no list is `"unknown opponent"` and does not `Petition`. GUILD INPUT stays unknown. Isolation stays Common + Runtime + Codec + Snapshot + Sender + BeefNet and does not `dofile` Store. Isolated `lua tests/test_net_v2.lua` **551 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
