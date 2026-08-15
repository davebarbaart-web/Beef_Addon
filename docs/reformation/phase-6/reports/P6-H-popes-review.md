# Phase 6 Lane H — Adversarial Review

**Lane:** Registered-Pope list (#8)
**Exclusive files:** `addon/ChurchOfBeef/Data/Popes.lua`, `addon/ChurchOfBeef/Core/Sender.lua`, `tests/test_sender.lua`, `docs/reformation/phase-6/reports/P6-H-popes.md`
**Lane report:** `docs/reformation/phase-6/reports/P6-H-popes.md`
**Cited law:** Bible §13.1, §13.4; Law 5; `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4; `.cursor/rules/pope-authority.mdc`; `.cursor/rules/identity-records.mdc` (Data never reads SV); David license 2026-08-15 (`Data/Popes.lua` + `ChurchOfBeefDB.ui.popeOverrides` via `/run`)
**Writer:** [Registered Pope](1b1f6d65-640d-426b-b338-d9445ea0ecd9)
**Format example:** `docs/reformation/phase-6/reports/P6-A-appendix-a-review.md`

**Spec:** PASS
**Quality:** Approved

Workspace list ships **empty**. No invented character name. `IsRegisteredPope` is listed **or** `ChurchOfBeefDB.ui.popeOverrides` (both via `Names.Key`). `Accept`: INPUT unchanged (identity presence); STATE / SNAPSHOT consult the predicate; every other kind false. Data does not read `ChurchOfBeefDB`. No RegisterPope / settings panel / slash / guild-rank map. No Council designation store or broadcast. Isolated `lua tests/test_sender.lua`: **263 passed, 0 failed** (reviewer rerun, Lua 5.1.5, exit 0). Under `tests/run.lua` the suite restores the prior `COB.Popes` slot (nil today). Later leftover `COB.Popes == nil` asserts are other suites, not a product unload. Writer Writes are the four exclusive files. TOC `Data\Popes.lua` after `Ranks.lua` is integrator (mtime after this report). This review did not invent a shipped name, Council UX, or a settings panel, and did not commit.

## Verdict

Refutation of “invented Pope name / Data reads SV / INPUT now gated / STATE-SNAPSHOT ignore the predicate / RegisterPope or settings UX / guild-rank as Church / invented Council store / leftover nil-asserts are this lane unloading Popes” **fails** for this lane’s exclusive files.

Law 5 / §13.1 are intact. One writer remains a registered Pope **character**. Congregation INPUT is still identity presence, not authority. `IsRegisteredPope` stays false for `"Pope"`, `"GM"`, Officer, Council, `rankIndex` 0, and an accepted INPUT sender. Witnesses still cannot rule. A local `/run` override fools only that client — David licensed it. Other clients with an empty list still discard that sender.

§13.4 is the discard gate, now with something that can be true. Theatrical / state / snapshot kinds that are not `STATE` or `SNAPSHOT` still die, including from a listed Pope. Discarded messages are not stored. Player-typed free text is not read and not performed.

GATE1 §4 / the 2026-08-15 license hold: workspace data in the Ranks.lua pattern (a small Data file), locally overridable on `ui.popeOverrides`. Council designations stay uncoded. `OPEN_QUESTIONS.md` #8 remainder is untouched (mtime 08:52:43; writer files 08:56:09–08:57:18).

`pope-authority.mdc` holds: no settings panel, no slash, no “I am the Pope” button. `identity-records.mdc` holds: `Popes.lua` never reads SV. Sender may, and does.

This review did not invent a character name, a Council field, or override UX beyond the licensed table, and did not commit.

## Claims vs evidence

| Writer claim | Evidence | Holds? |
|---|---|---|
| `COB.Popes.List` ships empty; no invented character name | `Data/Popes.lua`: `local LIST = {}`. No quoted name tokens in the file. Suite: `#List == 0`. Reviewer: `#List == 0`; `IsListed("Beefina")` false. | **Yes.** |
| `IsListed` keys via `Names.Key`; fail-closed if Common is missing | `isListed` returns false without `COB.Names.Key`. Compares `LIST[i] == key` (raw entry vs keyed query). Suite appends `Names.Key("Beefina")` then matches realm / pad / case. Reviewer: no Names → false. | **Yes** for the stated name-key contract. Display-case file entries fail — Important below. |
| Data never reads `ChurchOfBeefDB` | `Popes.lua` has the SV path only in comments. No `ChurchOfBeefDB` read. Suite: override set, `IsListed("Beefina")` stays false, `#List` stays 0. | **Yes.** |
| `IsRegisteredPope` is listed **or** `ui.popeOverrides` | `Sender:IsRegisteredPope` calls `IsListed` then `overrideHas`. Override walks `#overrides` and re-keys each entry. Missing DB / `ui` / override / non-table override → false. | **Yes.** |
| `Accept`: INPUT unchanged; STATE / SNAPSHOT consult the predicate; other kinds false | INPUT uses `Names.Trim` presence only — P3-D contract. STATE / SNAPSHOT return `IsRegisteredPope`. Else false. Suite: INPUT true for non-Popes; `input` / `Input` false; listed/override Pope Accepts STATE / SNAPSHOT; THEATER / HELLO / SYNC_* / petition still false. | **Yes.** |
| No Register / Add / Set / config UX APIs | `Sender` public methods are `IsRegisteredPope` and `Accept` only. `Popes` is `List` + `IsListed`. Suite nils `RegisterPope` / `SetPope` / `LoadPopes` / `OverridePope` / `Configure` / `OpenConfig` / `popes`. No `SLASH_`. No `CreateFrame`. | **Yes.** |
| Isolated suite 263/0; `lua tests/test_sender.lua` exits 0 | Reviewer rerun, Lua 5.1.5, workspace root: **263 passed, 0 failed**, exit 0. Isolation asserts remain in `if standalone then` (7 of them — harness-style run is 256). | **Yes.** |
| Guild-rank stubs 0 reads; no send; no frames | Suite installs `GetNumGuildMembers` / `GetGuildRosterInfo` / `GetGuildInfo` / `UnitIsGuildLeader` / `GuildControlGetRankName` / `CanEditOfficerNote` / `IsGuildLeader` / `SendAddonMessage` / `CreateFrame`. `guildReads` / `sent` / `framed` stay 0. Source has none of those call tokens. | **Yes.** |
| Empty List: Beefina / Pope / GM / nil stay false; STATE / SNAPSHOT refuse | Suite locks those senders and the theater-kind list. Reviewer: empty List + no override → `IsRegisteredPope` false; `Accept(..., "STATE")` false. | **Yes.** |
| Test-only append then restore empty | Suite appends keyed `"Beefina"`, asserts variants, `clearList()`, `#List == 0`, predicates false again. Product file is still `LIST = {}`. | **Yes.** |
| Override with empty List; `IsListed` stays false; cleared after | Suite sets `ChurchOfBeefDB.ui.popeOverrides = { "Beefina" }`, restores `priorDB`. Missing `ui` / override / string-not-array ignored. | **Yes.** |
| Under `run.lua`, restore prior `COB.Popes` so leftover nil-asserts stay green; that is isolation, not a product unload | `priorPopes` captured before `dofile` Popes. `if not standalone then COB.Popes = priorPopes end`. `run.lua` does not load `Popes.lua`. Reviewer harness-style require: prior nil, after nil; `IsRegisteredPope("Beefina")` false; INPUT still true. `test_net_v2:216`, `test_ceremony_chaos:399`, `test_console:534` remain other-suite leftovers. | **Yes.** |
| No Council designation store / broadcast | Exclusive files have zero `Council` / `designat` tokens. No store field. No wire kind. `#8` remainder unread-as-answered. | **Yes.** |
| Writer stayed inside exclusive files; no TOC / bootstrap / `run.lua` / BeefNet / `OPEN_QUESTIONS.md` / `REFORMATION_LOG.md` | Transcript Writes: Popes, Sender, `test_sender`, this lane’s report. `OPEN_QUESTIONS.md` 08:52:43 (license text, leftover-wave). Writer files 08:56:09–08:57:18. TOC `08:57:32` is integrator (user: do not treat as writer). `run.lua` 08:00:33. BeefNet 07:02:15. `ChurchOfBeef.lua` 08:52:52. `REFORMATION_LOG.md` 09:00:20. DB 07:42:29. No commit. | **Yes.** |
| Full harness 1 failed in `test_console` (EditBox count) is P6-I, not this lane | Writer investigated, did not edit Console. `test_console` uses `wow_ui_stub.install()` (replaces this suite’s `CreateFrame` stub). EditBox assert is Console chrome. Exclusive files here were not edited to chase it. | **Yes** as attribution. This review did not rerun the full harness. |

## Confirmations

| Check | Result |
|---|---|
| List ships empty; no invented character name | **Yes.** `LIST = {}`. No name string in `Popes.lua`. |
| Data does not read `ChurchOfBeefDB` | **Yes.** Comments only. `IsListed` ignores the override. |
| Sender may read `ui.popeOverrides` | **Yes.** `overrideHas` only. Missing / wrong type ignored. |
| `Accept` INPUT unchanged | **Yes.** `Names.Trim` presence. Independent of `IsRegisteredPope`. P3-D contract. |
| `Accept` STATE / SNAPSHOT consult `IsRegisteredPope` | **Yes.** |
| `Accept` other kinds false (including a listed Pope) | **Yes.** Allowlist, not a theater denylist. |
| No RegisterPope / settings UI / slash / guild-rank reads | **Yes.** |
| No Council designation store / broadcast | **Yes.** |
| Isolated `lua tests/test_sender.lua` exits 0 | **Yes.** 263/0, Lua 5.1.5. |
| Under `run.lua`, suite restores prior `COB.Popes` | **Yes.** Today that prior is nil. Leftover nil-asserts are not a product unload. |
| Writer did not edit TOC / BeefNet / `OPEN_QUESTIONS.md` / `REFORMATION_LOG.md` / bootstrap / `run.lua` | **Yes.** TOC line after `Ranks.lua` is integrator. |
| No V1 / MVP complete claim | **Yes.** Report: not a Gathering. |

## Attack results

| Attack | Result |
|---|---|
| Law 5 — empty List means the star has no writer? | **No.** Licensed empty ship. Fail-closed until a keyed name or a local override. Writer disclosed it. Not a bug. |
| Law 5 — `Accept(INPUT)` for any present sender is peer authority? | **No.** Congregation input only. `IsRegisteredPope` stays false for that sender. No send, no paint. |
| Law 5 — `/run` `popeOverrides` is self-reported wire authority? | **No as star.** Other clients with an empty list still discard. Local override is the licensed escape. UI “I am the Pope” was not added. |
| Law 5 — GM / Officer+ / `rankIndex` 0 / the name `"Pope"` is the Church? | **No.** Those senders are false. Guild APIs are not called. |
| §13.4 — STATE / SNAPSHOT from a listed or override Pope still discarded? | **No.** They Accept. That is this lane. |
| §13.4 — THEATER / PROCLAMATION / HELLO / SYNC_* / petition from a listed Pope Accept? | **No.** Other kinds stay false. Wire kinds are STATE / SNAPSHOT / INPUT. Do not invent opcodes here. |
| §13.4 — rejected STATE is stored and painted later? | **No.** No `discarded` / `held` / `inbox` / `queue` / `pending`. |
| §13.4 — SNAPSHOT **request** (congregation → Pope) now Accepts? | **No.** `Accept("SNAPSHOT")` still requires a registered Pope. Congregation requests were already false under P3-D. BeefNet must not use `Accept` as a blanket inbound gate — leftover, not a regression. |
| identity-records — `Popes.lua` reads SV? | **No.** Sender reads the override. Data does not. |
| GATE1 — this is not the Ranks.lua pattern (string keys vs `{id,title}`)? | **No as miss.** Direction is a small workspace data file, locally overridable. Element shape is name-key strings. Ranks is also a live `List` upvalue. Empty ship is the license (do not invent David’s name). |
| `pope-authority` — settings panel, slash, or “I am the Pope”? | **No.** Comments document `/run`. No `SLASH_`. No frames. |
| Council designations invented (store field / broadcast)? | **No.** Uncoded. `#8` remainder open. |
| Display-case `"Beefina"` in `List` registers a Pope? | **Yes as footgun, not as shipped name.** `IsListed` compares raw `LIST[i]` to the keyed query. `overrideHas` re-keys. Suite never appends `"Beefina"` unkeyed. Comment requires `Names.Key` spellings. Important below. Not a shipped character. |
| Writer secretly edited TOC / BeefNet / `OPEN_QUESTIONS.md` / Console to chase EditBox? | **No.** Transcript Writes are exclusive files only. TOC is integrator. Console is P6-I. |
| Harness restore **is** the product unloading `COB.Popes`? | **No.** Isolation. In-game TOC loads `Popes.lua` once. `run.lua` does not. Restoring nil keeps stale other-suite asserts green. |
| Writer claimed V1 / MVP / a live Gathering? | **No.** |

Refutation of Law 5 (one Pope-character writer; INPUT is not rule; no guild-rank Church), Bible §13.1 / §13.4 (STATE / SNAPSHOT only from a registered Pope; other kinds die; no later-paint store), GATE1 §4 + the 2026-08-15 license (empty workspace file + local SV override; Council uncoded), `pope-authority.mdc` (no invented config UX), and `identity-records.mdc` (Data never reads SV) **fails** for the exclusive files.

## Isolated rerun

Reviewer rerun, Lua 5.1.5, workspace root. No `tests/run.lua` edit. No writer-file edit.

| Suite | Result |
|---|---|
| `lua tests/test_sender.lua` | **263 passed, 0 failed** (exit 0) |

Writer count matches. Harness-style require (assert helpers already defined): **256 passed, 0 failed**; `COB.Popes` after suite is **nil**. The extra 7 are standalone isolation asserts.

## Leftovers (other lanes / David — not fixed)

### Other suites (not this writer)

- `test_net_v2`, `test_ceremony_chaos`, `test_console` still assert `COB.Popes == nil` as if #8 were uncoded. Update those writers when they load the list. Do not treat this suite’s restore as the product.
- `test_console` EditBox count — P6-I exclusive file. Do not chase it here.

### Integrator (already landing / not this writer)

- `ChurchOfBeef.toc` lists `Data\Popes.lua` after `Data\Ranks.lua`. User: not a writer violation. Writer report leftover is stale by ~14s.
- `tests/run.lua` still does not `dofile` `Popes.lua`. Correct until a suite needs the product table for the whole process.

### David (in-game)

- A live Gathering still needs a **Names.Key** spelling in `Popes.lua` or a local `ChurchOfBeefDB.ui.popeOverrides` entry. Shipping empty is the license. Console rituals and BeefNet STATE / SNAPSHOT stay fail-closed until then.
- Do not invent a settings panel. `#8` remainder (Council store / broadcast; override UX beyond the SV table) stays open.

### DB (not this lane)

- `applyDefaults` does not strip unknown `ui` keys. A `/run` override survives `Init` / `Save` without a DB.lua edit. `defaultUi()` does not document `popeOverrides`. Do not invent a schema bump here.

## Findings

### Critical

None.

### Important

1. **`IsListed` does not re-key `LIST` entries.** Query side uses `Names.Key`. File side is raw `LIST[i] == key`. Reviewer: `List[1] = "Beefina"` → `IsListed("Beefina")` **false**; `List[1] = "beefina"` → true. `overrideHas` re-keys `/run` strings, so the secondary path is the forgiving one. The suite only appends `Names.Key(...)`, so it never sees the Display-case miss. Comment says “Add Names.Key spellings.” Data is machine-readable. This is a first-edit footgun, not a shipped name, not invented UX. Do not “fix” with a settings panel. Do not treat it as a Spec miss against the writer’s stated contract.

### Nit

1. **`CreateFrame` / guild / `SendAddonMessage` stubs are not restored.** Pre-existing suite pattern. `test_console` reinstalls `wow_ui_stub`. Not the EditBox miss.

2. **“Popes not loaded → override only” is code-true, suite-untested.** Reviewer probed: `COB.Popes = nil` + override → true; no override → false.

3. **`COB.Popes.List` is the live upvalue** (Ranks.lua pattern). `/run ChurchOfBeef.Popes.List[1] = "x"` is a third, undocumented, non-persisted path. Replacing the field (not mutating it) would desync `IsListed` from `List`. Do not invent a setter.

4. **Writer report leftover “integrator must list TOC” aged immediately.** Integrator listed it. Expected parallel. Do not fail the writer for a sentence that was true when written.

## Brief contract

| Requirement | Result |
|---|---|
| List ships empty; no invented character name | Met |
| Data does not read `ChurchOfBeefDB`; Sender may read `ui.popeOverrides` | Met |
| INPUT unchanged; STATE / SNAPSHOT consult `IsRegisteredPope`; other kinds false | Met |
| No RegisterPope / settings UI / slash / guild-rank reads | Met |
| No Council designation store / broadcast | Met |
| `lua tests/test_sender.lua` exits 0 | Met (263/0) |
| Under `run.lua`, restore prior `COB.Popes` | Met (nil → nil) |
| No TOC / BeefNet / `OPEN_QUESTIONS.md` / `REFORMATION_LOG.md` / bootstrap / `run.lua` edits | Met (this writer) |
| No commit; do not claim V1 / MVP | Met |

## Sections checked

- Writer report `docs/reformation/phase-6/reports/P6-H-popes.md`
- `addon/ChurchOfBeef/Data/Popes.lua` (full)
- `addon/ChurchOfBeef/Core/Sender.lua` (full)
- `tests/test_sender.lua` (full)
- Bible §13.1, §13.4; Law 5
- `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4
- `.cursor/rules/pope-authority.mdc`; `.cursor/rules/identity-records.mdc`
- `docs/design/OPEN_QUESTIONS.md` #8 (license + Council remainder; not edited by this writer)
- P3-D Sender report + review (INPUT contract)
- `Data/Ranks.lua` (pattern)
- `Core/DB.lua` `applyDefaults` / `defaultUi` (unknown `ui` keys kept; read-only)
- `tests/run.lua` suite order (does not load `Popes.lua`)
- Leftover `COB.Popes == nil` asserts: `test_net_v2`, `test_ceremony_chaos`, `test_console`
- Writer transcript Writes vs mtimes
- Isolated rerun `lua tests/test_sender.lua`
- Reviewer probes: empty List; Display-case vs keyed List; override vs `IsListed`; Names missing; Popes-nil + override; harness-style restore

**Spec PASS**
**Quality Approved**
