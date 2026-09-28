# Task 10 review — Login restore + Pope rebroadcast

**Scope (this gate only):** live `ChurchOfBeef.lua` `dropCongregationEventIfNeeded` before `initUi` (nil-eventId Quiet, not same-id seq 0); Pope `sendState` once after `InstallWire`; `maybeRequestSnapshot` gates; `Core/DB.lua` Init has no `UnitName` / `IsRegisteredPope` gate; SCHEMA 7; pins in `tests/test_wire_glue.lua` / `tests/test_db.lua`. Task 4 Welcome order, Task 8 stash / #111, and Task 1 `initModule` must still hold.

Must hold: SCHEMA 7, Interface 20506, no schema 8, Decree leftover left alone, no commit.

Read: `.superpowers/sdd/task-10-brief.md`, `.superpowers/sdd/task-10-report.md`, `docs/superpowers/plans/2026-09-14-shared-account-sv.md` §§3–4. Live `ChurchOfBeef.lua`, `Core/DB.lua`, `Core/Runtime.lua` `DropToQuietForVersion` / `newEvent`, `Net/BeefNet.lua` `RequestSnapshot` / `HandleHello` / `_HandleState`, the two test files. Full `lua tests/run.lua` was not re-run (per gate instruction). Working tree was not mutated except this review file.

**Spec-compliance:** PASS

**Task quality:** Approved

The implementer report matches the live tree. `DB:Init` still Restores a string-`state` event for whoever loads. Congregation `OnLogin` drops that leftover Event Mode to a nil-eventId Quiet **before** `initUi`. Listed Pope keeps the restored event and `sendState()`s once after `InstallWire` when ≠ QUIET. `RequestSnapshot` is not an OnLogin ask; it fires once per login after an accepted Pope HELLO or accepted live STATE while local is still QUIET. Tuesday no-response is not a failure. Welcome after DecreeBanner, `initModule` `pcall`, stash, and #111 were not unwrapped.

---

## Verdict

Task 10 matches the brief, shared-account plan §§3–4, and first-night Task 10. The role split is `PLAYER_LOGIN`, not `ADDON_LOADED`. Pew leftover SV is not a second ceremony machine. Catch-up is a whisper after live Pope traffic this session. SCHEMA stays 7.

---

## Spec Compliance

| Pin | Result | Evidence |
|-----|--------|----------|
| Do **not** gate `restoreEventFromSv` on `UnitName` inside `DB:Init` | Met | `restoreEventFromSv` Restores when `event.state` is a string. Comment only: Init does not look up the local character. `DB:Init` is `applyDefaults` → store → event → decree. Source scan + runtime pin in `test_db.lua`: `UnitName("player")` Pewalt + `IsRegisteredPope` false still Restores RITE and keeps the saved `eventId`. `src:find("UnitName")` / `IsRegisteredPope` are nil. `DB.IsRegisteredPope` is nil |
| Congregation OnLogin: Quiet **before** `initUi`; Pope keeps the restored event | Met | `OnLogin` resets `_snapshotAsked`, then `dropCongregationEventIfNeeded()`, then `initUi()`. Drop no-ops when `isLocalPope()`. Pew pin: first UI Init spy (and DecreeBanner / Welcome) see `QUIET`. Pope pin: first Init spy is still `RITE`; same `eventId` kept |
| Quiet drop is **nil-eventId** (`newEvent` / `DropToQuietForVersion`), not `{ state="QUIET", eventId=<same>, sequence=0 }` | Met | Drop calls `Runtime:DropToQuietForVersion` (fallback Restore is the same `newEvent` shape: `eventId` nil, `sequence` 0). After Task 9, same-`eventId` seq 0 against a live seq would be `"stale sequence"` and the pew would keep RITE. Nil vs integer id is a different `eventId`, so Restore applies. Pew pin: `eventId` nil, `sequence` 0. Do not `EndEvent` from RITE |
| `RequestSnapshot` only after accepted Pope HELLO or live STATE this session; local still QUIET; once per login; not from OnLogin | Met | `maybeRequestSnapshot`: `_snapshotAsked`, not local Pope, `Snapshot().state == "QUIET"`, then set the flag and `pcall(Net.RequestSnapshot)`. Callers: `_OnPeerHello` only if `IsRegisteredPope(sender)`; `_HandleState` wrap only if `ok` (Accept) and `decoded.state ~= "QUIET"`. OnLogin never asks. Pins: pew HELLO 0; Pope HELLO 1 then 1; inbound `HandleHello` stays 1; Event Mode + Pope HELLO 0; live STATE that Restores RITE 0; Restore no-op leaving QUIET 1 then 1; cold Tuesday OnLogin with `Popes.List[1]` set 0 |
| Listed Pope + Runtime ≠ QUIET after `InstallWire`: `sendState()` once (#48) | Met | After `Net:Init` + `self:InstallWire()`, `isLocalPope()` and `snap.state ~= "QUIET"` call `sendState()` once. Peer HELLO rebroadcast stays on `_OnPeerHello`. QUIET Pope pin: 0 STATE. Live Pope pin: 1 STATE, decoded `RITE`. `SendState` is still `_LocalPope()`-gated |
| Congregation Decree: prefer not expanding | Met | `restoreDecreeFromSv` unchanged (string `line` still Restores for everyone). No Decree / InspectProgress / leftover-chrome work in this slice |
| SCHEMA 7; Interface 20506; no schema 8 | Met | `DB.lua` `SCHEMA_VERSION = 7`. Task 10 Init pin + existing version pins stay 7. TOC `## Interface: 20506`. No version 8 |
| Task 4 Welcome order | Met | `initUi` still `DecreeBanner` then `Welcome`. Pew OnLogin concat pin lists that order. Drop is before the first Init, so Welcome's Quiet skip sees congregation Quiet, not leftover RITE |
| Task 8 stash / #111 | Met | `_HandleState` wrap still `stashInboundCast` then paint then card branch. CONSEQUENCE Hide + `_fighterCardDismissed = true`; later RITE + two fighters Shows only if dismissed is not true. Stash pin: names on `_lastCastNames`, `Runtime:Snapshot().names` nil, Store counts unchanged. #111 pin: Show count stays 1 |
| Task 1 `initModule` not unwrapped | Met | `initModule` is still `pcall(mod.Init, mod)` + one chat line. `initUi` still goes through it. Hud-fail pin (`Hud failed to start.`) still in `test_wire_glue.lua`. `Net:Init` still after `initUi` |
| Plan §3–4: role split at `PLAYER_LOGIN`; Init must not look up the local name; pew must not keep Event Mode from SV | Met | Init Restores; login drops pew to Quiet before UI. Catch-up is whisper after live Pope traffic, not leftover `ChurchOfBeefDB.event`. Tuesday no-response is not a failure |
| Do-not: commit; gate Save; stamp 8; expand Decree | Met | Report: no commit. `OnLogout` still `DB:Save()` for every client (Task 10 was not allowed to gate Save). SCHEMA 7. Decree left alone |

---

## Strengths

- The drop shape is the Task 9-aware one. Nil-eventId Quiet is a different id, so leftover RITE actually leaves. Same-id seq 0 would have been a silent no-op.
- `DB:Init` stays character-blind. The Pewalt + false-Pope runtime pin plus the source scan make the forbidden `ADDON_LOADED` gate hard to reintroduce.
- Snapshot ask is not a cold-login spray. OnLogin with `List[1]` set still does not ask. HELLO is the real catch-up; the live-STATE gate only asks when Restore left local Quiet.
- Pope login send is a direct `sendState()` after `InstallWire`, not a verb wrap. The pew OnLogin test stubs `InstallWire`, so that one STATE cannot be a wrap side effect.
- Neighbors held. Welcome still follows DecreeBanner. `initModule` is still the Task 1 `pcall`. Stash and #111 still sit on the inbound wrap that Task 10 extended.

---

## Issues

### Critical

None.

### Important

None that miss a Task 10 pin.

1. **Shared-account `event` Save is now the lawful wipe.** Congregation `OnLogout` still `DB:Save()`s the now-QUIET Runtime over the same `ChurchOfBeefDB.event` the Pope restored. Same-account pew logout can persist Quiet over Thedave’s ceremony. Plan §3 convicted this shape for `gora`; Task 10 was not allowed to gate Save. Task 11 must not repeat it. Night walk stays two Account trees (plan §6).

### Minor

1. **`_snapshotAsked` is set before `RequestSnapshot`.** A `no target` return still burns the once-flag. A Pope HELLO before `_lastStateSender` / `Popes.List[1]` is resolvable will not retry this login. TOC loads `Data/Popes.lua`, so production usually has a dest; the suite spies the call. Report concern 2 is accurate. Tuesday no-response is still not a failure.

2. **Missing `UnitName` at `PLAYER_LOGIN` is treated as pew** (`isLocalPope` is false) and drops Event Mode. In-game the name is available at login; Init stays ungated so the Pope’s `ADDON_LOADED` restore still happens first. Report concern 4.

3. **No single Init-then-OnLogin integration pin.** `test_db.lua` Restores RITE with no Pope predicate; `test_wire_glue.lua` drops a live in-memory RITE on OnLogin. Together they match the split. One `DB:Init` + `OnLogin` walk is not in the suite.

4. **Pope login test stubs `InstallWire`.** That proves the OnLogin `sendState()` (a stubbed InstallWire cannot wrap-send). It does not prove wraps are live before the rebroadcast. Source order is `InstallWire` then `sendState`. Peer HELLO rebroadcast is unchanged.

5. **Live STATE ask is the leftover-Quiet path.** A successful live Restore leaves Event Mode, so the ask no-ops. The STATE gate is covered by a Restore no-op stub. HELLO is the real catch-up. Report concern 3.

6. **Leftover Decree still Restores for everyone in Init.** Brief said prefer not expanding. Pew first-login can still see Pope parchment from the shared file. Deferred #113, not a miss.

7. **Full harness counts (16655 / 0) and in-game `/reload` / two-client HELLO → snapshot were not re-checked.** Bootstrap + DB were touched. Isolated counts in the report were not re-run this pass.

---

## Assessment

**PASS / Approved.**

Login restore is the PLAYER_LOGIN role split. Init does not look up the local character. Pew leftover Event Mode becomes a nil-eventId Quiet before UI Init. Listed Pope keeps the event and rebroadcasts STATE once after InstallWire. Snapshot ask is gated, once, not a Tuesday spray. SCHEMA 7. Interface 20506. Welcome order, `initModule`, stash, and #111 were not unwrapped. The shared-account Quiet Save is Task 11’s warning, not a Task 10 miss.

Do not claim `POLISH:PASS`.
