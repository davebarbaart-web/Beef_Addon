# W-D — BeefNet: DECREE + FAVOR whisper + SendState (review)

**Lane:** W-D BeefNet — DECREE + FAVOR whisper + SendState
**Brief:** `docs/reformation/wire/briefs/W-D-beefnet.md`
**Writer report (unverified):** `docs/reformation/wire/briefs/W-D-beefnet-report.md`
**Diff:** `docs/reformation/wire/briefs/W-D-beefnet.diff`
**Exclusive files:** `addon/ChurchOfBeef/Net/BeefNet.lua`, `tests/test_net_v2.lua`

**Spec:** PASS
**Quality:** Approved

Task-scoped gate only. Reviewer read the brief, the writer report, and the provided diff; then made one focused check per named risk (`Sender:Accept` vs `IsRegisteredPope`; isolated loads / no `Data/Popes.lua`; Codec already has `EncodeDecree` and favor+pick) plus the `Decree:Set` / `Gora:RecordFavor` return contracts the new handlers depend on. Did not mutate the working tree, did not re-run the harness, and did not treat writer counts as verified.

---

## Spec Compliance

- **Spec PASS**
- **Quality Approved**

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Codec / Gora / Store / UI / TOC / bootstrap / Sender / Snapshot / Runtime / `run.lua` / OPEN_QUESTIONS / REFORMATION_LOG / `Data/Popes.lua` / commit | **Pass.** Provided diff touches only the two exclusive files. |
| `SendState` / `SendSnapshot` stay Pope-gated via `_LocalPope()` | **Pass.** Unchanged. Empty Popes list still fail-closed. Stubbed predicate opens both. |
| `SendDecree(fields, nowSeconds)`: `EncodeDecree`; GUILD via `Send`; `_LocalPope()` or `false, "not a registered pope"` | **Pass.** Codec errors (`invalid line`, …) pass through. Size cap 240 is `Send`’s existing `MAX_BODY`. |
| `SendFavor(fields, target, nowSeconds)`: not Pope-gated; WHISPER; requires target; favor+pick only | **Pass.** Forces `kind = "favor"` plus `characterId` / `pick`. No `SendInput`. `_TransmitWhisper` applies the same 240 cap. |
| Recv `DECREE` on GUILD: `Sender:IsRegisteredPope(sender)`, then `Decree:Set({ line, flavor })` | **Pass.** Named-risk check: `Accept(sender, "DECREE")` is false today (only INPUT / STATE / SNAPSHOT are accepted). Impl does not call `Accept`. |
| Wrong-channel DECREE discard; non-Pope `"not accepted"`; no Runtime Restore | **Pass.** Suite pins whisper discard, congregation discard, and unchanged Runtime. |
| Recv favor `INPUT` on WHISPER only, and only if `_LocalPope()`; then `Gora:RecordFavor(characterId, pick)` | **Pass.** Non-Pope whisper → `"not a registered pope"`. Pope-side stub calls `RecordFavor` with the decoded ids. |
| Missing pick / `RecordFavor` error → no inbox; never Restore; never fan out | **Pass.** Error path is tested (`no sanctioned gora`). Nil pick fail-closes in code (returns `false`, no queue). |
| Petition / confession / favor-on-GUILD stay `"unknown message type"`; no inbox | **Pass.** Filtered in `_HandleV2` before `_HandleFavor`. Re-tested on a Pope client. |
| No HELLO type; no `holdSeconds`; no sequence / latest-wins gate | **Pass.** Transport `TYPES` stays `{ HELLO = true }`. DECREE / INPUT have no sequence check. |
| Isolation asserts stay under `if standalone then`; empty Popes fail-closed; do not invent a Pope name | **Pass.** Standalone loads are Common + Runtime + Codec + Snapshot + Sender + BeefNet. New Gora / Decree nil asserts are under `standalone`. Pope predicate is stubbed to the suite’s existing `Beefina` / `PlayerName` and restored. `COB.Popes` stays nil. |
| Named tests (SendState empty list, stubbed SendDecree / inbound Set / congregation refuse, favor whisper RecordFavor, favor GUILD discard, petition/confession unknown, non-Pope SendDecree) | **Pass.** All present. Existing `guild` / `whisper` / `reset` / wire spies reused. |
| Codec already signed; this lane must not edit it | **Pass.** Focused check: `EncodeDecree` and `EncodeInput` favor+pick already exist. Diff does not touch Codec. |

CONTINUE licenses 1–2 and the brief’s live-channel rule are met: STATE / SNAPSHOT / DECREE send only from a local registered Pope; favor is congregation whisper; only the Pope’s client tallies.

---

## Strengths

- Recv DECREE uses `IsRegisteredPope` and documents why: the suite still asserts `Accept("Beefina", "DECREE") == false`. That is the exact named trap.
- `SendFavor` cannot be turned into petition/confession. It rebuilds the body as favor+pick only, then whispers. Congregation send is not Pope-gated; Pope-side recv is.
- `_HandleV2` keeps petition / confession / favor-on-GUILD as `"unknown message type"` *before* the version gate, so they stay not-a-live-channel rather than growing a second refuse vocabulary.
- Sibling handlers stay clean: no Runtime Restore, no inbox, no fan-out. `RecordFavor` errors are returned and not queued. `Decree:Set({ line, flavor })` matches Core’s parse contract (required line, optional trimmed flavor; success is a copy, failure is `nil, err`).
- Fail-closed today: empty Popes list still blocks `SendState` / `SendDecree` / inbound DECREE / Pope-side tally. The stub is name-aware, re-applied after `reset()`, and restored; it does not write `Data/Popes.lua` or a `popeOverrides` list.
- Isolation discipline holds: new Gora / Decree nil pins stay under `if standalone then`. Header now says INPUT is live only for favor whisper-to-Pope.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Gora / Decree stubs are assigned, then niled, not restored.** `Sender.IsRegisteredPope` is saved and put back. `COB.Decree` / `COB.Gora` are overwritten and set to `nil`. Later harness suites re-`dofile` those modules (`test_console`, `test_hud`, `test_gora`, `test_decree`), so this is not a poison today. Same save/restore as the predicate would be cheaper hygiene.

2. **Nil-pick inbound is implemented, not pinned.** `_HandleFavor` returns `false` when `decoded.pick == nil` and does not invent a queue. Codec encode already requires pick, so a well-formed favor body will not hit this. Coverage-could-be-broader.

3. **`_HandleDecree` returns `true` when `Decree.Set` is absent.** `_HandleState` / `_HandleFavor` fail-close if Runtime / Gora is missing. Production TOC loads Decree, and the accept-path tests always stub `Set`. Isolation-only looseness; not a product miss.

---

## Assessment

**Spec PASS. Quality Approved.**

This is the W-D transport contract: Pope-gated `SendDecree` on GUILD, congregation `SendFavor` whisper, inbound DECREE only from `IsRegisteredPope` into `Decree:Set`, favor INPUT live only as whisper-to-Pope into `RecordFavor`. Petition, confession, and favor-on-GUILD stay unknown. No inbox, no Restore, no HELLO type, no hold timer, no sequence gate, no Pope name invented in `Data/Popes.lua`. Exclusive files only.

Writer-reported isolated `lua tests/test_net_v2.lua` **403 / 0** and full harness **6366 / 0** were **not** re-run here.

No Critical or Important findings. Integrator can sign W-D on this diff; do not block on the Minors. This review does not sign the lane.
