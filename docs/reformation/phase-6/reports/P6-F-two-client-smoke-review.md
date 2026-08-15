# Phase 6 Lane F — Adversarial Review

**Lane:** Rewrite `docs/phases/two-client-smoke.md` against the Pope-authoritative star
**Exclusive files:** `docs/phases/two-client-smoke.md`, `docs/reformation/phase-6/reports/P6-F-two-client-smoke.md`
**Lane report:** `docs/reformation/phase-6/reports/P6-F-two-client-smoke.md`
**Cited law:** Bible §13.1, §13.4, §20.3, §21.3; Ten Laws 5 and 6; `.cursor/rules/ceremony-runtime.mdc`
**Writer:** [Two-client smoke](4a58ca8f-c7d5-4dd0-88f5-36a2ed381d9c)
**No P6-F brief** in `docs/reformation/phase-6/briefs/`. Reviewed against the lane job + live wire.

**Spec:** PASS
**Quality:** Approved

The exclusive file is a Pope-writer + congregation-display walk. Status line is **NOT RUN**. Every box is `[ ]` (28). No `[x]` row. No dated pass. No V1 / MVP complete claim. No `POLISH:PASS`. Standing / Grant / Officer queue / SUGGESTION-as-product are cut text, gone-product regression boxes, or retired-kind discards — not this walk’s pass. `/run` lines name live BeefNet / Codec / Snapshot / Runtime APIs. No `RequestSnapshot`, no live INPUT channel, no SUMMON, no favor path, no invented Pope character. This review did not edit the smoke, addon Lua, `OPEN_QUESTIONS.md`, or `REFORMATION_LOG.md`, and does not claim V1 / MVP.

## Verdict

Refutation of “this is still a standing / SUGGESTION / Officer-queue smoke” **fails** for the exclusive file.

The attack that would FAIL this lane is: keep petition-on-the-officer-desk as pass; invent `Net:RequestSnapshot` / a live INPUT channel / SUMMON / favor / a Pope name; tick the walk; or treat a green harness as two-client proof. The script does the opposite. Pass is Accept / refuse / whisper-to-Pope / retired discard. Fail is congregation Restore, C answering a snapshot, GUILD treated as catch-up, unlisted send succeeding, a stubbed `IsRegisteredPope`, retired traffic answered, version-warn spam, or a standing surface returning.

Law 5 holds as the cast and the walk: one writer (P, after David lists the name); C is display; C `SendState` / `SendSnapshot` stay `not a registered pope`; C STATE on GUILD is traffic, not authority. Law 6 holds as the Quiet contract on this walk: the only allowed Quiet notice is the step-2 `_WarnVersion` line; INPUT must not paint a feed / toast / pip / sound.

Writer report **Status: DONE** is lane authoring. The smoke file stays **NOT RUN**.

`solo-smoke.md` no longer describes the deleted ladder (P6-E, Quiet Tuesday + hosted surfaces). Line 7 of this smoke still says it does. That is a **doc-staleness finding**, not a Spec FAIL: the walk itself is the star.

## Confirmations

| Check | Result |
|---|---|
| Exclusive writes only (smoke + this lane’s report) | **Yes.** Reviewer mtimes: smoke `08:56:09`, writer report `08:56:01`. `OPEN_QUESTIONS.md` `08:52:43` (before). `ChurchOfBeef.lua` `08:52:52`. `Net/BeefNet.lua` `07:02:15`. `Data/Popes.lua` `08:56:09` is P6-H, not this lane’s prose. `REFORMATION_LOG.md` `08:57:44` is orchestrator status after F, not a F product edit. |
| Status is **NOT RUN**; no `[x]`; no dated pass | **Yes.** Line 3 and closer: **NOT RUN. Do not tick this file as done. Do not date a pass.** Reviewer: **28** `- [ ]` rows; **0** `- [x]` rows. No `YYYY-MM-DD` pass stamp. The only `[x]` string is the tick-instruction sentence. |
| Cast is Pope writer + congregation display | **Yes.** Client **P** / Client **C**. Same guild. Two Anniversary clients. Script does not name a character. |
| Deleted-product tokens are not this walk’s pass | **Yes.** `standing` / `Grant` / `Officer queue` appear as “do not walk,” “product is gone,” or Fail-if-returns. `SUGGESTION` is retired discard (`RETIRED_TYPES`) plus a gone-surface fail. No `threshold`. Pass paragraph is the star. |
| `/run` APIs match the live wire | **Yes.** See API table below. |
| No invented `RequestSnapshot` / INPUT channel / SUMMON / favor / Pope name | **Yes.** `Snapshot:Request()` encode-only. INPUT named codec-only. SUMMON / favor are Out of scope. Placeholders `<congregation character>` / `<Pope character>`. `SomeoneElse` is a retired dummy payload. |
| No addon Lua / `OPEN_QUESTIONS.md` / `REFORMATION_LOG.md` from this writer | **Yes.** Those files were not F’s exclusive writes. `#8` in `OPEN_QUESTIONS.md` already licenses `Data/Popes.lua` + `popeOverrides` (08:52). F names that path; it does not resolve the leftover Council/UX questions. |
| No V1 / MVP complete; no `POLISH:PASS` | **Yes.** Both appear only as **Do not claim**. Writer report repeats the ban. |
| `_WarnVersion` copy is the shipped sentence, not the Bible sentence | **Yes.** Quoted from `Net:_WarnVersion` + `chat()`. Bible §13.4 “the Church's software has advanced” is named as what **not** to look for. |

## API honesty (live wire)

Read: `Net/BeefNet.lua`, `Net/Codec.lua`, `Net/Snapshot.lua`, `Core/Sender.lua`, `Core/Runtime.lua`, `UI/Status.lua`, `Data/Popes.lua`.

| Smoke claim | Wire |
|---|---|
| `Net:SendState(fields)` GUILD only if `_LocalPope`; else `false, "not a registered pope"` | `SendState` lines 325–337. Refuse string exact. |
| `Net:SendSnapshot(fields, target)` whisper if Pope; else same refuse; does not look up a Pope name | `SendSnapshot` 339–351; `_TransmitWhisper` comment + impl. |
| `Net:_WarnVersion` one chat line / session; `warnedVersion` | 357–364. Copy: `a guildmate is running BeefNet v%s; this client speaks v%d. Update for matching addon messages.` Prefix `Church of Beef:`. Does not toast. Does not `NotifyStatus`. |
| `Net:Send` / `Net:Encode` not Pope-gated; Encode stamps protocol `1` | `Send` 300–311; `Encode` 128–135. Congregation STATE / INPUT bytes on GUILD are possible. Theater is `Accept` / Restore. |
| `Snapshot:Request()` is `1:SNAPSHOT:request` | `EncodeSnapshot({ role = "request" })` → `1:SNAPSHOT:request`. No `Net:RequestSnapshot` in the addon. |
| `SendSnapshot` Pope-gated even for `role = "request"` | `_LocalPope` runs before encode. C cannot ask through that API. |
| Forged whisper uses prefix `COB`, body `Snapshot:Request()`, channel `WHISPER` | `Prefix = "COB"`. Fallback `SendAddonMessage` exists. |
| Inbound SNAPSHOT requires WHISPER; request answered only if `_LocalPope`; C does not answer | `_HandleSnapshot` 495–525. GUILD snapshot returns false. |
| `BuildResponse` is `nil, "no event"` while Runtime is `QUIET` | `Snapshot:BuildResponse` 25–28. Step 4 STATE echo is what leaves P able to answer. |
| `Codec:EncodeInput({kind="petition",characterId=1})` → `1:INPUT:petition:1` | Exact. `_HandleV2` drops non-STATE / non-SNAPSHOT. |
| Retired `SUGGESTION` / `SYNC_REQUEST` / `SYNC_STATE` / `RANK_COMMIT` discarded unread | `RETIRED_TYPES` 62–67; `OnAddonMessage` 437. |
| `Runtime:Snapshot()` Quiet start is `QUIET`, `nil` event id, sequence `0` | `newEvent()`. |
| Step 4 `SendState({eventId=1,state="ASSEMBLY",sequence=1})` Restores on an Accepting client | Codec encodes `1:STATE:1:ASSEMBLY::::1`. Decode yields numeric ids. `Runtime:Restore` accepts ASSEMBLY with event id 1, sequence 1, empty subjects. |
| Chip: Ready empty; wait `Reading the guild roster…`; unguilded `Not in a guild`; version `BeefNet version mismatch`; never “syncing” / “synced” | `UI/Status.lua` CHIP / SOFT_CHIP. No `syncing` / `synced` string in `addon/ChurchOfBeef/`. |
| List path: `Data/Popes.lua` or `ChurchOfBeefDB.ui.popeOverrides` | `Sender:IsRegisteredPope` + `Popes.IsListed` + `ui.popeOverrides`. No settings panel. No `/run` stub of the predicate. |
| Inbound burst 5, then one / five seconds | `InboundBurst = 5`, `InboundPerSecond = 0.2`. Drop is not a star fail. |
| Sender self-warns on guild echo; version gate is before the self-check | `TYPES` HELLO mismatch calls `_WarnVersion` before `HandleHello`’s `IsSelf`. |

`99:HELLO:9.9.9` is a hand-written mismatch (`Encode` would stamp `1`). Compatible login HELLOs do not warn. Second mismatch stays quiet. Honest.

## Attack results

| Attack | Result |
|---|---|
| Walk still passes on standing sync / SUGGESTION fan-out / Officer queue / Grant? | **No.** Those are cut. Pass is the star. Fail if a standing / SUGGESTION / Officer-queue surface returns. |
| Any box `[x]` / dated pass / walk claimed run? | **No.** 28 `[ ]`. **NOT RUN.** Writer report: walk **NOT RUN.** |
| Invents `Net:RequestSnapshot` or a new opcode? | **No.** Named as absent. Forges the existing SNAPSHOT request body on WHISPER. |
| Invents a live INPUT / favor / Confession / SUMMON channel? | **No.** INPUT is codec-only and then discarded. Favor / Confession / SUMMON are Out of scope. |
| Invents a Pope character name or stubs `IsRegisteredPope`? | **No.** David lists. Fail-closed until then. Stub is a Fail. |
| Treats congregation `Net:Send` bytes as C becoming a writer? | **No.** Honesty block says the opposite. Step 3 forge must **not** Restore. |
| Claims V1 / MVP complete or `POLISH:PASS`? | **No.** Explicit bans. §22.3 Gathering is Not a pass. |
| Green harness / one client / missing HUD substituted for the star? | **No.** Harness is a setup box, “not this smoke.” HUD leftover; missing HUD is not a star fail. One client is Not a pass. |
| GUILD snapshot treated as catch-up? | **No.** Step 5 first box: neither client answers. Fail paragraph names GUILD-as-catch-up as Fail. |
| Rebuilds `SYNC_STATE` / `SYNC_REQUEST` as gossip? | **No.** Retired discard. ceremony-runtime V7 ban held. |
| Quiet Mode “fixed” with a feed / toast / pip? | **No.** Step 2: one chat line, no toast. Step 7: INPUT must not paint. Only Quiet notice is the version line. |
| Writer edited addon Lua, TOC, tests, `OPEN_QUESTIONS.md`, or `REFORMATION_LOG.md`? | **No** as F exclusive writes. Parallel P6-H owns `Data/Popes.lua`. |
| `solo-smoke.md` still the deleted ladder, so F’s pointer is current? | **Stale.** See Findings. Walk remains the star. Not a Spec FAIL. |

Refutation of Laws 5 and 6, Bible §13.1 (one writer; GUILD state; congregation display), §13.4 (registered-Pope theater; shipped version notice), §20.3 (whisper snapshot to the Pope; version degrade notice), §21.3 (protocol version), and ceremony-runtime (no invented opcode / GUILD snapshot fan-out / peer SYNC / INPUT theater) **fails** for the exclusive files.

## Leftovers (other lanes — expected; not fixed)

Named in the smoke. This review does not host them and does not tick them.

1. **P6-H list live on the installed client** — step 4 cannot pass until David’s name is listed and the install has that list. Steps 1–3 and 6–7 stay walkable fail-closed.
2. **Hosted rite theater** (Fight HUD, mute cards) — leftover; needs a sanctioned pair. Not a star fail.
3. **Favor, Confession, SUMMON, live INPUT** — out of scope.
4. **A03 40-client rate limits** — David’s sheet. Inbound drop is not a star fail.
5. **Dress rehearsal / §22.3 Gathering** — different nights.
6. **`guild-night-playtest.md`** — writer leftover called it still a ladder. That file was already rewritten (P6-G, `08:55:15`) as a star night. Out of lane either way.

## Findings

### Critical

None.

### Important

1. **`solo-smoke.md` pointer is stale in the exclusive file.** Line 7: “That file still describes the deleted standing ladder.” P6-E (`08:54:37`) already rewrote it as Quiet Tuesday + hosted surfaces. Status **NOT RUN**. No standing / Grant / Officer-queue walk remains there. The second clause (“do not walk standing, Grant, or an Officer queue **as this smoke**”) is still the right prohibition. Do not “fix” in this review. Not a Spec FAIL.

2. **Writer leftover repeats the same stale claim, and adds a second.** Report leftovers: “`solo-smoke.md` and `guild-night-playtest.md` still describe the deleted ladder.” Guild-night was rewritten at `08:55:15` (P6-G) against the star. Quality note on the report, not a walk defect.

3. **Status-chip boxes are barely observable on the documented `/beef` path.** Chip copy matches `UI/Status.lua`. `/beef` is `UI:Toggle` → `RecordsBook:Toggle`. The chip lives on the leftover MainFrame shell (`UI.statusChip`). Records Book has no chip. “If the shell is open” is a hedge, not a lie. A walker who only `/beef`s will not see Ready / wait / unguilded / version-mismatch words. The no-“syncing”/“synced” guard still holds (those strings are gone from the addon). Do not invent a `/run UI:Show` so the chip can be ticked.

4. **Step 5 is whisper-to-Pope, not a late-join reload.** After step 4, C is already `ASSEMBLY` / event 1 / sequence 1. A snapshot response Restores the same fields. Bible §20.3’s “reload, then land in the right theater” is unwalked. The star rules that are walked (WHISPER only; C does not answer; P answers when not `QUIET`; Accept) are enough for this smoke. Dress rehearsal owns reload chaos. Do not “fix” by adding a C `/reload` box in review.

5. **Step 7 talks Quiet chrome after step 4 left Runtime in ASSEMBLY.** INPUT still must not paint. That is the star test. Calling the client “Quiet” after a successful STATE Restore is sloppy mode language. UI theater is leftover, so the chrome sentence is accidentally true. Do not `/run` back to QUIET to make the adjective tidy.

### Nit

1. **`print(ok, err)` is tab-separated.** The smoke shows `false    not a registered pope` as spaces. Lua 5.1 prints a tab. Same refuse string.

2. **`[x]` appears in the tick-instruction sentence.** Not a ticked box.

3. **“Load / install half of solo-smoke” is now a long hosted-surface file.** Preconditions + Load still exist. A walker who keeps going will walk Records / Console / InspectProgress, which are not this smoke. The “do not walk standing” clause no longer matches what they will find.

4. **HELLO mismatch is walked; mismatched STATE discard is not.** `_HandleV2` does discard incompatible STATE after `_WarnVersion`. Unwalked, not dishonest.

5. **Sender self-echo also warns once.** Prose says so. The step-2 box only requires the other client. A walker who counts two chat lines (self + peer) must not call that spam. Fail is “version-warn spam” on the *second* send.

6. **Optional step-5 `SendSnapshot({role="response",...})` is an ellipsis, not a pasteable `/run`.** Helpers already have the full line.

## Job contract

| Requirement | Result |
|---|---|
| Replace standing / SUGGESTION / Officer-queue smoke with Pope-writer + congregation-display star walk | Met |
| All boxes `[ ]`; Status **NOT RUN** | Met (28 `[ ]`) |
| Two-client cast is Pope + congregation | Met |
| `/run` lines match real APIs; no invented `RequestSnapshot` / INPUT channel / SUMMON / favor / Pope name | Met |
| INPUT named codec-only; retired kinds discarded | Met |
| `_WarnVersion` copy from code, not the Bible sentence | Met |
| No addon Lua / `OPEN_QUESTIONS.md` / `REFORMATION_LOG.md` edits by this writer | Met |
| No commit; do not claim V1 / MVP | Met |
| `solo-smoke` staleness reported, not treated as automatic FAIL | Met (Finding 1) |

## Sections checked

- Writer report `docs/reformation/phase-6/reports/P6-F-two-client-smoke.md`
- Exclusive file `docs/phases/two-client-smoke.md` (28 `[ ]`, 0 `[x]`, Status **NOT RUN**)
- Bible §13.1, §13.4, §13.6, §20.3, §21.3
- Ten Laws 5 and 6
- `.cursor/rules/ceremony-runtime.mdc`
- Live wire: `Net/BeefNet.lua`, `Net/Codec.lua`, `Net/Snapshot.lua`, `Core/Sender.lua`, `Core/Runtime.lua`, `UI/Status.lua`, `UI/MainFrame.lua` (`Toggle` → Records Book), `Data/Popes.lua`
- `docs/phases/solo-smoke.md` (P6-E Quiet Tuesday — staleness target)
- `docs/phases/guild-night-playtest.md` (P6-G star night — writer leftover stale)
- `docs/design/OPEN_QUESTIONS.md` (#8 licensed list path; not edited by F)
- Format: `docs/reformation/phase-6/reports/P6-B-checklist-review.md`, `P6-C-rehearsal-review.md`

Do not claim V1 / MVP complete. Do not claim `POLISH:PASS`.
