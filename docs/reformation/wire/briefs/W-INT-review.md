# W-INT — bootstrap SendState / Decree glue (review)

**Spec:** PASS
**Quality:** Approved

**Lane:** W-INT integrator glue — bootstrap `InstallWire`
**Brief:** `docs/reformation/wire/briefs/W-INT-bootstrap.md`
**Writer report (unverified):** `docs/reformation/wire/briefs/W-INT-report.md`
**Diff:** `docs/reformation/wire/briefs/W-INT.diff`
**Exclusive files:** `addon/ChurchOfBeef/ChurchOfBeef.lua`, `tests/test_wire_glue.lua`, `tests/run.lua` (suite add only), `docs/phases/two-client-smoke.md` (honesty table), `docs/REFORMATION_LOG.md`

Task-scoped gate only. Reviewer read the brief, the writer report, and the provided diff once; then made one focused check per named risk plus the writer’s `stateFields()` fighter-copy concern (Codec `validateFavor`, Runtime `Restore`, BeefNet self-echo, `Gora:_Expire`). Did not mutate the working tree except this review file. Did not re-run the harness. Writer-reported **133 / 0** and **6677 / 0** are claims — do not treat them as verified.

**Gate W is not signed.**

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only (bootstrap, new `test_wire_glue`, `run.lua` add, honesty table, log). No lane-owned Codec / Gora / Store / BeefNet / Console / Hud / Sender / Runtime / Decree Core / TOC / `Data/Popes.lua` / commit | **Pass.** Provided diff touches those five paths only. TOC is unlisted (no new addon file). |
| UI and Core stay Net-free **in their files** | **Pass.** Diff does not edit UI or Core. Focused grep: `Console.lua` and `Core/` have no `COB.Net` / `SendState` / `SendDecree`. HUD `SendFavor` is prior W-F, not this glue. |
| `InstallWire` from `OnLogin`; idempotent; not at file-load (minimap dofile) | **Pass.** Named-risk check: `OnLogin` calls `self:InstallWire()` after UI / Net Init. `_wireInstalled` early-returns. File load defines the function and the event frame only. `wow_ui_stub` `RegisterEvent` does not fire `PLAYER_LOGIN`. Suite pins unwrapped `StartEvent` after `dofile` and a second `InstallWire` that does not double-send. |
| Runtime `StartEvent` / `OpenRite` / `CloseRite` / `Continue` / `EndEvent` → `Net:SendState` after success | **Pass.** One `wrapAfter` helper: `result ~= nil` then `sendState`. Those verbs return a snapshot on success and `nil, err` on refuse, so a failed verb does not send. |
| Successful `Gora:RecordFavor` and `Console:SetCongregationFavorVisible` → `SendState` | **Pass.** Same helper. Both return `nil, err` on refuse and `true` on success (`false` is not a success token). |
| Bible fields from `Runtime:Snapshot()`; `favor` only when congregation toggle is on **and** `GetSanctioned()` is a live pair | **Pass.** Named-risk check: toggle-off and no-pair omit `favor`. `EndEvent` → QUIET expires the pair (`liveEventId` is nil), so the QUIET STATE does not keep favor or copy fighters. Suite pins StartEvent without a pair, RecordFavor with toggle on, toggle-off, and a later pick with toggle still off. |
| Wrap `Console.PostDecree`, not `Decree.Set` (no inbound rebroadcast loop) | **Pass.** Named-risk check: only `Console.PostDecree` is wrapped. Inbound `_HandleDecree` still `Decree:Set`. InspectProgress still `Decree:Set`. |
| `InspectProgress` sets `_inspecting`; skip all sends while set | **Pass.** Named-risk check: flag is set before the existing body, cleared after `pcall`, then the original error is rethrown. `skipSend()` gates `sendState` / `sendDecree`. Suite: InspectProgress sends neither DECREE nor STATE and leaves the flag false. |
| Inbound accepted STATE / SNAPSHOT-response → `Hud:SetFavorTarget` + `SetBroadcastFavor(decoded.favor or nil)` + `Refresh` | **Pass.** Wraps live on Net objects from bootstrap (Net file untouched). Toggle-off / missing field nils the broadcast. SNAPSHOT paints only `role == "response"`. |
| Local picker id from Store name ↔ `UnitName("player")` via `Names.Key`; no invented Pope name | **Pass.** Named-risk check: `Data/Popes.lua` is not in the diff; `LIST` stays `{}`. Isolated suite does not load that file. Pope predicate is stubbed name-aware to Beefina and restored. `bindLocalCharacter` on `InstallWire` and `Store:Restore`. |
| Isolation asserts under `if standalone then` | **Pass** (with a Minor). Scoring / Ladder / Officer / DB / Archive / Ranks / Recognition / Popes cluster is gated. One extra `COB.Popes == nil` sits in the shared load-surface block. |
| Honesty table: DECREE live; favor INPUT whisper-to-Pope only. Walk boxes untouched. Do not claim Gate W closed | **Pass.** Walk `[ ]` boxes and **NOT RUN** are unchanged. Log and report leave Gate W **OPEN**. Vestments not opened. |

CONTINUE licenses 1–2 as they apply to glue (Pope `SendState` / Decree wire; congregation favor on STATE only while the toggle is on; favor INPUT stays whisper-to-Pope) are met.

---

## Writer concern — `stateFields()` fighter copy

**Judgment: acceptable glue. Not a layer miss. Not a spec fail.**

W-A Codec `validateFavor` errors unless `subjects.fighters` length is 2. Runtime ASSEMBLY subjects are empty until `OpenRite`. Sanction is legal in ASSEMBLY, and the brief still requires `favor` on the next successful `RecordFavor` / toggle when the pair is live. The only in-scope way to satisfy both contracts is to put the sanctioned pair on the **outbound** STATE subjects when favor is included.

That is interop, not a Core rewrite: `Runtime:Snapshot()` is not written; Gora is not written; Codec and BeefNet files are not edited. The pair is Pope-authoritative Gora state, not an invented combatant. `pcall(SendState)` would otherwise swallow the encode and silently drop the live-split send the brief named.

Side effects to live with (not blockers):

- Accepted STATE `Restore` applies those subjects. Guild self-echo does **not** skip STATE (HELLO does). After the first favor STATE in ASSEMBLY, Pope and congregation Runtime can show fighters the Pope’s ceremony verbs have not yet written.
- The copy runs whenever favor is included and Runtime fighter count ≠ 2, so a live Gora pair during a Knighting / Confession / Proclamation rite would project Gora fighters onto that rite’s wire subjects.
- Writer’s “Runtime is not mutated” is true of the outbound builder only.

A later Core or Codec change could remove the shim. This glue does not need to invent that change.

---

## Strengths

- Layer law holds. Sends and HUD paint live in bootstrap wraps. UI / Core files stay Net-free. Net is not edited for a last-sender cache.
- Double refuse on inspect: `_inspecting` skips every send, and Decree broadcast is `PostDecree` only, so inbound Set and the inspect `Decree:Set` cannot loop.
- Favor omit is a conjunction (toggle **and** live pair), not “zeros on the wire.” QUIET expire clears the pair before `EndEvent`’s STATE is built.
- Fail-closed: missing Net, unlisted Pope (`SendState` / `SendDecree` already refuse), and `pcall` so glue does not throw. Empty `Data/Popes.lua` is untouched.
- Suite matches the brief’s named paths (unstubbed silent StartEvent, stubbed Start/End STATE, PostDecree DECREE, InspectProgress silent, favor on/off, inbound STATE HUD, petition unknown, Restore local id) and unwraps keepers so a later harness file is not left wrapped.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Shared-body `COB.Popes == nil`.** The isolation cluster is under `if standalone then`. Line 173 of the new suite is not. `test_sender` restores `Popes` to its prior value (nil in a normal harness run), so this is not a known poison today. It is the exact assert the global constraint asked to gate.

2. **SNAPSHOT-response HUD paint is implemented, not pinned.** `Snapshot:BuildResponse` still emits Bible fields only (no favor). The wrap therefore `SetBroadcastFavor(nil)` on every accepted response. Late-join / mid-event catch-up will not carry the split until the next RecordFavor / toggle / Runtime send. Out of exclusive scope; writer already named it.

3. **Congregation `Hud:Refresh` still requires a local `Gora:GetSanctioned()` pair.** Inbound glue calls the three setters the brief named. W-F then hides the frame without a local pair, so a congregation client stores the broadcast and paints nothing. Cross-lane leftover, not a W-INT exclusive miss.

4. **Coverage gaps on wrapped verbs.** `OpenRite` / `CloseRite` / `Continue` share `wrapAfter` with the tested Start/End path and are not asserted. Direct `Decree:Set` and toggle-off inbound STATE → `SetBroadcastFavor(nil)` are implemented, not pinned.

5. **Walk step 7 still says INPUT is not routed.** The brief said leave walk boxes. Honesty table is the truthful one (favor whisper-to-Pope; petition/confession unknown). Step 7 still forges petition, so the walk itself is not wrong.

---

## Assessment

**Spec PASS. Quality: Approved.**

This is the licensed bootstrap glue: OnLogin-only idempotent wraps, Runtime / RecordFavor / congregation toggle → `SendState`, `PostDecree` → `SendDecree`, inspect and inbound Set stay off the Decree wire, inbound STATE paints HUD setters, local character id from Store, no Pope name. The sanctioned-pair copy onto outbound STATE subjects is acceptable Codec interop, not a layer or product-law miss.

Writer-reported isolated `tests/test_wire_glue.lua` **133 / 0** and full harness **6677 / 0** were **not** re-run here.

No Critical or Important findings. Do not block on the Minors. **Do not sign Gate W.** Two-client smoke and Vestments stay closed. Do not claim V1 / MVP complete.
