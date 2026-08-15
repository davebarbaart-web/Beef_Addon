# Phase 1 Lane C — Adversarial Review

**Lane:** Attic Instance and Quest  
**Exclusive files:** `addon/ChurchOfBeef/Core/Instance.lua` → `attic/Core/Instance.lua`; `addon/ChurchOfBeef/Core/Quest.lua` → `attic/Core/Quest.lua`; `tests/test_instance.lua` / `tests/test_quest.lua` → `attic/tests/`  
**Lane report:** `docs/reformation/phase-1/reports/P1-C-attic.md`  
**Cited law:** Ten Laws 1–2; Audit §4 shelve row; Bible §14.3 later-phase Expeditions (checked, not invented)

**Spec:** PASS  
**Quality:** Approved

Sensing was shelved, not shipped, and not rebuilt as a live tracker or a new points faucet. Live `addon/ChurchOfBeef/Core/` has no `Instance.lua` / `Quest.lua`. Attic holds the moved modules and their sensing tests. Integrator dropped TOC / bootstrap / `tests/run.lua` listings. Scoring `_Grant` paths in attic still call deleted `COB.Scoring` and mint nothing. No Expedition product was written.

## Verdict

Lane C put instance/group sensing on the attic shelf and left it off the load graph. The live addon cannot start the old co-play tickers: bootstrap no longer defines `WireInstanceEvents` / `WireQuestEvents` or calls `COB.Instance` / `COB.Quest`, and the TOC does not list the modules. Attic `_Grant` still asks a missing scorer (`GrantInstanceBucket` / `GrantBattlegroundEnd` / `GrantQuestBucket`) and returns 0. That is a dead faucet on a shelf, not a replacement economy. Bible §14.3 Church Expeditions remain later-phase; this lane did not implement ~3-of-5 qualification, witnessed completion, or an Expedition UI. Law 1 / Law 2 hold for the live tree.

Git status is `RM` (renamed and modified) versus last commit, not a delete and not a dual copy. Writer transcript is `git mv` plus `attic/README.md` and this lane’s report — not TOC / bootstrap / `run.lua`, and not a new scorer.

## Confirmations

| Check | Result |
|---|---|
| Live `addon/ChurchOfBeef/Core/Instance.lua` and `Core/Quest.lua` gone | **Yes.** Glob: only `attic/Core/Instance.lua` and `attic/Core/Quest.lua`. Live Core listing: Common, Officer, Roster, Gora, Ceremony, DB. |
| Exist under `attic/Core/` (moved, not deleted) | **Yes.** `git status`: `RM addon/ChurchOfBeef/Core/Instance.lua -> attic/Core/Instance.lua` and the same for Quest. |
| Live `tests/test_instance.lua` and `tests/test_quest.lua` gone | **Yes.** Not among `tests/test_*.lua`. |
| Exist under `attic/tests/` (moved; they test sensing, not only grants) | **Yes.** Suites cover Qualifies, tracking lifecycle, rest grace, live sampler, event wiring, and grants. Brief: prefer attic if they test sensing. |
| `attic/README.md` says not shipped; Expedition witnessing later; do not load from TOC | **Yes.** One paragraph. No ship / TOC-load / Phase 1 Expedition UI invitation. |
| `ChurchOfBeef.toc` does not list `Core\Instance.lua` or `Core\Quest.lua` | **Yes.** No `Instance`, `Quest`, or `attic` string. Interface remains `20506`. |
| `ChurchOfBeef.lua` has no `WireInstanceEvents`, `WireQuestEvents`, `COB.Instance`, or `COB.Quest` | **Yes.** `OnLogin` is UI + Net only. No instance/quest frames. |
| `tests/run.lua` does not list `test_instance` or `test_quest` | **Yes.** Suite list and `ls tests/test_*.lua` discovery both miss attic. `package.path` does not include `attic/`. |
| No live Lua under `addon/` or `tests/` calls `COB.Instance` or `COB.Quest` | **Yes.** Zero matches. `wow_ui_stub.lua` still stubs `IsInInstance` / `GetInstanceInfo` (allowed). `tests/test_db.lua` still asserts `GrantInstanceBucket` against deleted Scoring (other-lane leftover). |
| Attic files not in TOC and not loaded by bootstrap | **Yes.** No `dofile` / `loadfile` / `require` of attic from `addon/`. |
| Scoring wiring in attic remains dead; no new scorer | **Yes.** `_Grant` nil-guards `COB.Scoring` and calls `GrantBattlegroundEnd` / `GrantInstanceBucket` / `GrantQuestBucket`. No `COB.Scoring =` in attic or live addon. |
| No Expedition product, points, XP, thresholds, or live tracker invented | **Yes.** No Expedition strings in live Lua. `OPEN_QUESTIONS.md` untouched. Qualifies is still the old 1-guildmate scoring rule, not §14.3 ~3-of-5. |

Writer brief forbade TOC / bootstrap / `run.lua` edits. Integrator owns those files (`docs/REFORMATION_LOG.md`). Writer report leftover rows for those three files are stale against the current tree; the live tree matches the review contract.

## Attack results

| Attack | Result |
|---|---|
| Deleted instead of attic’d? | **No.** `git mv` recorded as `RM`. Files exist under `attic/`. |
| Copied so live + attic both exist? | **No.** Live paths are gone. One copy each. |
| README invite shipping / TOC load / Phase 1 Expedition UI? | **No.** Explicitly not shipped; witnessing later; do not list in TOC or load from bootstrap. |
| `_Grant` rebuilt as a new economy? | **No.** Still `COB.Scoring:*`. Scoring.lua is gone (Lane A). Calls return 0. |
| Bootstrap still wires instance/quest frames after integrator? | **No.** No Wire* helpers, no Init, no extra event frame for those modules. |
| `tests/run.lua` still requires missing suites, or discovers attic as live? | **No.** Names absent from `suites`. Discovery is `ls tests/test_*.lua` only. |
| Writer edited TOC / bootstrap / `run.lua` (forbidden) in a way that conflicts with integrator? | **No.** Writer transcript: `git mv` + README + report only. Integrator dropped the listings. No leftover Instance/Quest strings in those files. |
| Leftover live caller that would load attic at runtime? | **No.** Nothing in `addon/` or live `tests/` dofiles attic or names `COB.Instance` / `COB.Quest`. |

Refutation of the shelf contract **fails**. Sensing is off the ship path. The banned mechanism (a paying instance/quest faucet) cannot run.

### Attic content vs last commit (not a Lane C rewrite)

`git diff HEAD:addon/ChurchOfBeef/Core/Instance.lua -- attic/Core/Instance.lua` (and Quest/tests) is non-empty: `COB.Group` / `COB.Clock` delegation, `TickPeriod` half-bucket sampling, `GrantInstanceComplete` → `GrantBattlegroundEnd`, Quest `RestGraceSeconds = 180` / `_Continues`, bucket-boundary carry, and matching attic-test updates.

That is **not** this writer inventing a faucet. Writer transcript is `git mv` of whatever was on disk. The writer report already treats “rest grace” as existing sensing coverage. Lane A’s leftover map already named `GrantBattlegroundEnd` on Instance while the file still lived under `addon/`. The shelf is the dirty working-tree snapshot, not a byte-identical HEAD freeze. The wiring remains Scoring-shaped and dead.

## Leftover-caller notes (other lanes — expected; not fixed)

Writer leftover table is stale (TOC / bootstrap / `run.lua` already cleaned). Current leftovers:

### Other lanes (live)

- `tests/test_db.lua` — `S:GrantInstanceBucket(...)` and `dofile` of deleted `Scoring.lua` / `Ladder.lua`. P1-A / P1-G / P1-B. Not an Instance/Quest caller.
- `addon/ChurchOfBeef/Core/Common.lua` — live `COB.Group.CountGuildmates` / `Clock.Mono` (“co-play bucket” comments). Not exclusive to Lane C; writer did not add this file. `Gora.lua` uses `Group.PlayerName()` only. Not a load of attic.
- `ChurchOfBeef.toc` still lists other-lane missing files (`Core\Ladder.lua`, `UI\Announce.lua`, `UI\LadderTab.lua`, `UI\StandingTab.lua`, `UI\OfficerTab.lua`). Not Instance/Quest.
- TOC still has `## SavedVariablesPerCharacter` (identity / Phase 2). Not this lane.

### Attic shelf (not live)

- `attic/Core/Instance.lua` — `_Grant` → `GrantBattlegroundEnd` / `GrantInstanceBucket` (nil-guarded). Header still describes 60s combat buckets and daily caps.
- `attic/Core/Quest.lua` — `_Grant` → `GrantQuestBucket` (nil-guarded). `RestGraceSeconds` continues a scoring session in town.
- `attic/tests/test_instance.lua`, `attic/tests/test_quest.lua` — `dofile("addon/ChurchOfBeef/Core/Instance.lua")` / `Quest.lua` / deleted `Scoring.lua` / `Ladder.lua`; call `COB:WireInstanceEvents()` / `WireQuestEvents()`. Shelf only. Would abort if someone ran them as a live suite; `run.lua` does not.

Historical mentions in `docs/archive/`, `docs/research/`, and Audit §4 were left in place.

## Findings

### Critical

None.

### Important

None for this lane’s exclusive ship/shelf contract.

### Nit

1. **Writer report leftover map is stale** (`P1-C-attic.md`). It still says TOC lists `Core\Instance.lua` / `Core\Quest.lua`, bootstrap still wires Init, and `tests/run.lua` still lists the suites. Integrator already dropped those. Does not reopen Spec. This review’s leftover list is the current map.

2. **Attic is `RM` versus last commit, not a pure rename.** Pre-existing uncommitted faucet/sensing edits rode along with the move (rest grace, half-bucket ticker, `GrantBattlegroundEnd`, `COB.Group`). Writer did not apply those diffs in-lane. Do not treat them as a new scorer. Do not “fix” them into Expedition product.

3. **Attic tests still dofile live addon paths** that no longer exist. Correct for a shelf; they are not a hidden live suite.

## Brief contract

| Requirement | Result |
|---|---|
| Move (do not delete) `Core/Instance.lua` and `Core/Quest.lua` to `attic/Core/` | Met |
| Move sensing tests to `attic/tests/` (or delete if grants-only) | Met (moved) |
| Write `attic/README.md` (not shipped; Expedition witnessing later; do not load from TOC) | Met |
| Do not edit TOC / bootstrap / `tests/run.lua` (writer) | Met (integrator dropped listings) |
| Do not ship attic in the TOC | Met |
| Scoring wiring dies; do not fix attic grants into a new scorer | Met |
| Do not invent Expedition product / points / XP / thresholds / a live tracker | Met |
| Report leftover callers; do not fix them | Met (table now stale; callers were integrator-owned) |
| No commit | Met |
| Instance/Quest not restored this review | Met |

## Sections checked

- Brief `docs/reformation/phase-1/briefs/P1-C-attic.md`
- Writer report `docs/reformation/phase-1/reports/P1-C-attic.md`
- `docs/reformation/phase-0/TEN_LAWS.md` Laws 1–2 (and 3–10 for product invention)
- Audit §4 shelve row for `Core/Instance.lua` / `Core/Quest.lua`
- Bible §14.3 later-phase Church Expeditions (enough to check; no product invented)
- `attic/README.md`, `attic/Core/Instance.lua`, `attic/Core/Quest.lua`, `attic/tests/test_*.lua`
- `ChurchOfBeef.toc`, `ChurchOfBeef.lua`, `tests/run.lua`
- Live `addon/` and `tests/` Lua for `COB.Instance`, `COB.Quest`, Wire* , attic loads
- `docs/design/OPEN_QUESTIONS.md` (unchanged)
- `docs/REFORMATION_LOG.md` P1-C integrator note
- Writer transcript: `git mv` only on exclusive Lua
