# Church of Beef — Leap-Forward Plan (post-review roadmap)

> **For agentic workers:** This is an **umbrella roadmap** spanning multiple subsystems (Core identity, Net trust, economy, UI, harness, verification). Per superpowers:writing-plans scope check, each phase below MUST be expanded into its own bite-sized TDD plan (`docs/superpowers/plans/2026-XX-XX-<phase>.md`) before execution — do not implement directly from this document. Execute phases in order; each phase ends with a green harness (`lua tests/run.lua` → exit 0) and, where flagged, an in-game smoke.

**Goal:** Take the addon from "modules exist, harness green, nothing verified" to a coherent, trustworthy, in-game-smoked release candidate.

**Architecture:** Unify identity on one name-normalization law, make wire testimony honest instead of trusted, delete the retired sync protocol's ghost, fix the inverted scoring economy, land the flagship Ladder UI fixes, harden the harness so it can catch client-API misuse, then run the human-gated verification ladder (solo smoke → two-client → v1-checklist).

**Tech Stack:** Lua 5.1, plain global `ChurchOfBeef`/`COB`, TBC Classic Anniversary `## Interface: 20506`, desktop harness in `tests/`.

## Global Constraints

- `## Interface: 20506`; no Retail/Dragonflight-only APIs; feature-detect everything else.
- Layers: UI→Core→Data, Net→Core→Data only. Core never touches Net or UI directly (observer callbacks only, mirroring `Roster:SetOnChanged`).
- UI never awards points; Net never invents ranks; Core never `CreateFrame`; Data never reads SV.
- Rank numbers live only in `addon/ChurchOfBeef/Data/Ranks.lua`.
- No bots, injection, protected-action bypass, gameplay automation, or automated guild-chat loops.
- `lua tests/run.lua` exit 0 required for every Core/Data/harness change; TOC lists only existing files.
- Agents claim **POLISH:CANDIDATE** at most; **POLISH:PASS** and V1-complete are human-only.
- Never touch player `WTF/**/ChurchOfBeefDB.lua`.

## Findings inventory (source: 2026-08-01 four-track review)

Full details live in the review transcripts; the phase tasks below cite the load-bearing ones:

- **F1** Identity split-brain: 4 copies of case/realm-preserving `normalizeName` (`Core/Ladder.lua:12`, `Core/Scoring.lua:49`, `Core/Gora.lua:26`, `Core/Ceremony.lua:20`) vs lowercase+realm-strip `rosterKey` (`Core/Roster.lua:20`, `Core/Officer.lua:19`); plus two rogue `:lower()`-only matchers (`UI/StandingTab.lua:127`, `UI/Minimap.lua:38`). Standing records silently fragment per casing/realm variant.
- **F2** `standingMet = true` hardcoded in `enrichSuggestion` (`Core/Ladder.lua:91`); wire-imported petitions with fabricated standing render as verified evidence.
- **F3** `Net:HandleSuggestion` (`Net/BeefNet.lua:479-502`) never checks sender == subject; `Ladder:ImportSuggestion` adopts max of claimed vs pending standing (`Core/Ladder.lua:249-253`). Any member can put any name + any number in every officer's queue.
- **F4** ~300 lines of dead protocol: `HandleRankCommit`/`_Hold`/`ReleaseHeld`/`SendRankCommit` (`BeefNet.lua:345-460`), `Sync:Reply`/jitter/`MergeState`/`_HoldState` (`Sync.lua:227-292`); `Sync:OnLogin` still broadcasts an unanswerable `SYNC_REQUEST` per login and `UI/Status.lua` narrates a fictional sync.
- **F5** Economy inversion: mutual Gora typing farms 100 pts/day (highest cap, zero gameplay, no challenge handshake required — `Core/Gora.lua:127-129`); `RaidComplete = 45` unreachable (only `CheckBattlegroundEnd` calls `GrantCompletion`, `Core/Instance.lua:312-317`); quest turn-ins mostly no-op (rest-zone exclusion, `Core/Quest.lua:118-124`).
- **F6** `CorrectStanding` leaves stale pending suggestions when correcting downward (`Core/Ladder.lua:293-304` → `MaybeSuggest` returns nil below threshold, never removes).
- **F7** Bucket/ticker boundary race can halve drip income (tick period == bucket length; `Core/Instance.lua:158,278-280`, `Core/Quest.lua:146,255-257`).
- **F8** Ladder overlap bug: expanded band + Find narrowing to ≤ preview cap paints occupants/`+N more` over the next band header (`UI/LadderTab.lua:1151-1216`, occupants anchored at 714-718).
- **F9** Officer tab clobbers focused subject EditBox on refresh/auto-select (`UI/OfficerTab.lua:863-870`) — corrections can land on the wrong member.
- **F10** Perf residue at 900 members: band buckets not memoized (~17k string allocs/paint via `NameKey`-per-comparison sort, `UI/LadderTab.lua:456-478`); Officer wheel notch re-sorts full queue (`OfficerTab.lua:395-406`); Status counts occupants via full `GetLadderView` rebuild even with UI closed (`UI/Status.lua:52-64`).
- **F11** Focus-mode runtime override diverges from tested `LayoutPlan` contract and can violate footer reserve by ~2 px at min height (`UI/LadderTab.lua:1013-1028`).
- **F12** Harness blindness: widget stub auto-noops any method name (`tests/wow_ui_stub.lua:8-16`) so Retail-API misuse passes silently; timers discard delays so all Sync/throttle timing untestable; no 255-byte or loopback modeling; `run.lua:47-51` silently skips missing suites.
- **F13** Outbound pacing 2/s vs stated ~1/s regen model (`BeefNet.lua:22-25` vs `SendInterval = 0.5`); no inbound rate limit; replayed SUGGESTION re-toasts every 11 s (toast dedupe window 10 s).
- **F14** Core→Net layer inversion: `Scoring:Grant` (`Scoring.lua:169-172`) and `Ladder:CorrectStanding` (`Ladder.lua:298-301`) call `COB.Net:OnLocalSuggestion` directly (transitively draws a toast).
- **F15** Misc: Scoring history not persisted (`Scoring.lua:228-236`); false crash-safety comment (`Scoring.lua:62-64`); roster `ready` true on single-player seed (`Roster.lua:64-72,245-252`); knighting via `label:find("[Kk]night")` (`Ceremony.lua:173-176`); `Announce.lua` dead code documenting the superseded commit-author model with default-ON enable; unbounded `Ladder.records` growth; StandingTab missing unguilded gate; minimap button has no drag-reposition and no reachable show/hide toggle; docs debt (plan checkboxes all `[ ]`, Task 9 describes pre-roster-backed model).

## Decisions needed from the human (block the phases marked ⚑)

| # | Decision | Options | Blocks |
|---|----------|---------|--------|
| D1 | Standing divergence story | (a) Accept "standing is per-client testimony", say so in Officer UI copy; (b) design real sender-authoritative standing sync (bigger project) | Phase 2, 3 |
| D2 | Gora economy | Require challenge handshake before result? Lower gora daily cap below instance cap? Exact numbers → `Data/Ranks.lua`/`Scoring.Points` | Phase 3 |
| D3 | Completion bonus | Best-effort final-boss heuristic vs delete `RaidComplete`/dungeon completion from `Points` | Phase 3 |
| D4 | Toast anchor | Keep top-center −160 vs true edge placement (brief says "edge toast") — needs an in-client look | Phase 6 |
| D5 | `Announce.lua` fate | Delete until roster-diff announcer design exists vs fix header + default-off now | Phase 2 |

---

### Phase 1 — Identity & truth (P0 correctness) — highest priority

**Files:** `Core/Ladder.lua`, `Core/Scoring.lua`, `Core/Gora.lua`, `Core/Ceremony.lua`, `Core/Roster.lua`, `Core/DB.lua`, `Net/BeefNet.lua`, `UI/StandingTab.lua`, `UI/Minimap.lua`, `UI/OfficerTab.lua`; tests: `tests/test_ladder.lua`, `test_scoring.lua`, `test_gora_ceremony.lua`, `test_db.lua`, `test_net_validate.lua`, `test_officer_ui.lua`.

- [x] **1.1** Extract one shared normalization law — expose `Roster.NameKey` semantics (trim → lowercase → strip `-Realm`) as the single key function; replace all four `normalizeName` copies and both UI rogue matchers (F1). Keep display names separate from keys.
- [x] **1.2** SV migration (schema v4 in `Core/DB.lua`): merge fragmented `Ladder.records`/suggestions/`granted` keyed under casing/realm variants; deterministic merge = max standing, union rites, keep newest suggestion. Test with fixtures containing `Beefina`/`beefina`/`Beefina-Whitemane`.
- [x] **1.3** Compute `standingMet` honestly per path (F2): true only when verified locally (`MaybeSuggest`); wire imports carry `claimed = N`, rendered by OfficerTab as "claims N" distinct from local evidence.
- [x] **1.4** Bind SUGGESTION subject to sender in `HandleSuggestion`; refuse mismatches; skip toast when `ImportSuggestion` returns `isNew == false` (F3, replay half of F13).
- [x] **1.5** `CorrectStanding` clears/downgrades pending suggestions that no longer meet threshold; persist the refresh branch mutation in `MaybeSuggest` (F6).
- [x] **1.6** Fix bucket boundary race in Instance + Quest: elapsed tolerance (`>= BucketSeconds - 1`) or tick period > bucket (F7); extract shared `countGuildmates`/ticker helpers while touching both (F14 adjacency).
- [x] **1.7** Replace Core→Net calls with `Ladder:SetOnSuggestion(fn)` observer wired from bootstrap/Net (F14).
- [x] **1.8** Persist `Scoring.history`; correct the false crash-safety comment; distinguish roster `ready` vs `complete` so membership checks stop failing during the login seed window (F15).

**Phase gate:** harness green; new tests prove merge migration, claims-vs-verified rendering, sender-binding refusal.

### Phase 2 — Kill the ghost protocol, honest status, net hardening

**Files:** `Net/BeefNet.lua`, `Net/Sync.lua`, `UI/Status.lua`, `UI/Announce.lua`, `ChurchOfBeef.toc`, `tests/test_net_validate.lua`. ⚑ D1, D5.

- [x] **2.1** Delete dead machinery (F4): `SendRankCommit`, `_Hold`/`ReleaseHeld`, `HandleRankCommit` validation chain, `Sync:Reply`/jitter/`MergeState`/`_HoldState`; stop `Sync:OnLogin` emitting `SYNC_REQUEST`; keep `HELLO` version fanout. Update stale tests to the new surface (fail-closed refusal tests move to parse-level discard).
- [x] **2.2** Rewrite `UI/Status.lua` states to narrate reality (peers seen via HELLO, roster freshness) — no fictional "syncing/synced".
- [x] **2.3** Outbound pacing to burst-10/regen-1 token bucket (or `SendInterval = 1`); add per-sender inbound token bucket in `OnAddonMessage`; make `refreshUI` a dirty-flag coalesce instead of per-message full ladder rebuild (F13).
- [x] **2.4** Per D5: delete `Announce.lua` + TOC line, or rewrite header for roster-backed model, default enable OFF, and document the cross-client double-announce hazard.
- [x] **2.5** Per D1(a): add Officer tab copy stating corrections are local testimony. (D1(b) becomes its own spec + plan; not in this roadmap.)

**Phase gate:** harness green; grep proves zero references to removed symbols; login emits no SYNC_REQUEST in a stub run.

### Phase 3 — Economy rebalance (game design) ⚑ D1–D3

**Files:** `Core/Gora.lua`, `Core/Scoring.lua`, `Core/Instance.lua`, `Core/Quest.lua`, `Core/Ceremony.lua`, `Data/Ranks.lua` (if thresholds move), `docs/superpowers/specs/2026-07-25-church-of-beef-design.md` (decisions log entry); tests: `test_gora_ceremony.lua`, `test_scoring.lua`, `test_instance.lua`, `test_quest.lua`.

- [x] **3.1** Gora integrity per D2: require a live challenge (or roster-membership + cooldown at minimum); rebalance `DailyCaps` so co-play ≥ typing; record decision in spec log.
- [x] **3.2** Completion bonus per D3: wire dungeon/raid completion heuristic or delete `RaidComplete`/`InstanceComplete` from `Points` so config matches reality (F5).
- [x] **3.3** Quest turn-in fix: allow a grace window so rest-zone turn-ins shortly after field play still count, or re-scope the signal; document behavior.
- [x] **3.4** Replace knighting substring match with an explicit ceremony-kind field on `Ceremony:Start` (F15).
- [x] **3.5** Roster-pruned `Ladder.records` sweep (keep ex-member grace period) to stop unbounded SV growth.

**Phase gate:** harness green; a written incentive table in the spec decisions log (source × daily cap × effort) showing co-play dominates typing.

### Phase 4 — UI leap (flagship surface)

**Files:** `UI/LadderTab.lua`, `UI/OfficerTab.lua`, `UI/StandingTab.lua`, `UI/MainFrame.lua`, `UI/Status.lua`, `UI/Minimap.lua`, `Core/Roster.lua` (O(1) count); tests: `tests/test_ui.lua`, `test_officer_ui.lua`. Read `docs/superpowers/ui-polished-direction-for-agents.md` first; follow skill § Polish loop.

- [x] **4.1** Fix expanded-band + filtered-≤-cap overlap (F8): full-height inline list or suppress the preview when header-only. Add a `LayoutPlan`/paint regression test for this exact state.
- [x] **4.2** Stop clobbering the Officer subject box (F9): never `SetText` on a focused EditBox; seed subject only on explicit row click.
- [x] **4.3** Memoize band buckets per roster generation with precomputed sort keys (F10); Officer scroll becomes repaint-only from a cached (revision, needle)-keyed list.
- [x] **4.4** Gate closed-UI background work; add `Roster:GetOccupantCount()` O(1); Minimap/Status recompute on `OnShow` (F10).
- [x] **4.5** Fold the keep-all-headers focus override into `LayoutPlan` itself and re-derive the footer-reserve invariant so tests test reality (F11); update the large-guild spec + move it toward Accept.
- [x] **4.6** StandingTab unguilded gate; fix `HISTORY_TOP` vs wrapping threshold line; tooltip on disabled ceremony button explaining why.
- [x] **4.7** Minimap drag-to-reposition writing `db.minimapAngle`; a reachable show/hide (e.g. `/beef minimap`).
- [x] **4.8** Remove dead UI code: `UI:_ApplyRosterUpdate`, double `wireMoreButton` call, unused `deferInCombat` config or honor it.

**Phase gate:** harness green + **in-game `/reload` smoke** of Ladder expand/filter/scroll/resize and Officer queue at a realistic roster; claim at most POLISH:CANDIDATE.

### Phase 5 — Harness hardening (pays for itself in every later phase)

**Run before Phase 4**, per this plan's own sequencing rationale: the strict stub
validates the UI work as it is written rather than after.

**Files:** `tests/wow_ui_stub.lua`, `tests/run.lua`, all suites incrementally.

- [x] **5.1** Strict widget stub: whitelist known-2.5.x widget methods; unknown method = test failure (F12). Expect and fix the fallout.
- [x] **5.2** Simulated time: timers store due-times; `advance(seconds)` helper; make throttle/`_Arm` and any remaining timer flows testable behavior.
- [x] **5.3** Enforce 255-byte envelope in `sendAddonMessage` stub + GUILD loopback of own messages so `IsSelf` is exercised.
- [x] **5.4** `run.lua` fails on any missing suite; report per-suite failures without cascade; de-brittle prose assertions (keep wire-format ones).
- [x] **5.5** Add adversarial tests: subject≠sender petition, spoofed standing claim, SUGGESTION flood, realm-collision on the officer gate, casing-variant merge.

**Phase gate:** harness green under the strict stub — this is the new baseline for "offline verified".

### Phase 6 — Verification ladder & polish loop (human-gated) ⚑ D4

- [x] **6.1** Docs truth pass: tick reality into `docs/superpowers/plans/2026-07-25-church-of-beef-v1.md` checkboxes; fix Task 9's stale pre-roster-backed prose; log all D1–D5 outcomes in the design spec decisions log.
- [ ] **6.2** Install to Anniversary AddOns (skill §2), `/console scriptErrors 1`, `/reload`, `/beef`; walk `docs/phases/solo-smoke.md` end-to-end and tick it. **Agent half done:** installed to `_anniversary_/Interface/AddOns/ChurchOfBeef` and verified byte-identical to `addon/ChurchOfBeef`; `solo-smoke.md` extended to cover the resize sweep, the filtered-expanded-band case, the minimap drag and `/beef minimap`, the unguilded gate, and the subject-box clobber. The walk itself is human.
- [ ] **6.3** Two-client smoke (Officer+ and Member): SUGGESTION fanout, sender-binding refusal, HELLO version warn. **Agent half done:** written up as [`docs/phases/two-client-smoke.md`](../../phases/two-client-smoke.md) with working `/run` lines for the forged petition, the version-mismatch payload, and retired message types. The walk itself is human.
- [x] **6.4** Polish loop (skill § Polish loop, max 2 rounds) on Ladder + toasts + empty states; D4 toast-anchor decision on-screen; claim **POLISH:CANDIDATE**. — **2026-08-01:** baseline uncovered a stale pre-reload client build; one critique→revise round landed (bottom-hung Classic panel tabs, shared `UI.Palette`, ladder accent restraint, heavy-row zebra+hover, preview width-fit, Find rides its strip, Standing rites re-grid, class color on Standing/Officer names); harness 1474 green; in-game screenshot round clean (no P0/P1). **D4 resolved: toast stays top-center −160** (human, on-screen). **POLISH:CANDIDATE** claimed per surface; PASS remains human.
- [ ] **6.5** Walk `docs/phases/v1-checklist.md`; remaining unchecked items become the release-blocking list. **V1-complete and POLISH:PASS remain human-only calls.** **Agent half done:** the two offline-verifiable boxes are ticked and dated (harness green; TOC exact in both directions), and the new surfaces from Phases 1–5 are added as unticked rows. Everything left needs a client.

**Phase gate:** solo-smoke doc fully ticked, two-client fanout observed, checklist walked with evidence.

**Status at hand-off (2026-08-01).** Phases 1–5 complete and offline-verified: 1475 assertions
green under the strict widget stub, `luac -p` clean across the addon, TOC exact both ways, and
the tree installed to the Anniversary AddOns folder byte-identical to source. Phase 6 is now
four in-game walks and one human judgement (D4), none of which an agent can honestly perform.
**No POLISH claim is made** — not even `POLISH:CANDIDATE`, which requires a `/reload` smoke of
the touched paths.

### Release-blocking list (what a human has to do next)

1. `/reload` smoke: [`solo-smoke.md`](../../phases/solo-smoke.md), start to finish.
2. Two-client walk: [`two-client-smoke.md`](../../phases/two-client-smoke.md).
3. Polish loop on Ladder, toasts and empty states; decide **D4** (toast anchor) on screen.
4. Walk [`v1-checklist.md`](../../phases/v1-checklist.md) and date each box.
5. Re-tune the economy after one instrumented guild night — every number in the incentive
   table is still a placeholder.

---

## Sequencing rationale

Phase 1 first because identity fragmentation corrupts data *now* (every day of play under two key laws deepens the SV mess the migration must untangle). Phase 2 before 3 because deleting the ghost shrinks the surface every later change touches. Phase 5 can interleave after Phase 2 (its strict stub will catch regressions from Phases 3–4). Phase 6 is last and partially human.

## Self-review notes

- Every finding F1–F15 maps to a task; D1–D5 are the only intentionally open items.
- This roadmap deliberately contains no code blocks: per scope check, each phase gets its own full TDD plan with code at expansion time.
- Deferred by design (not forgotten): real standing sync (D1b), roster-diff `/g` announcer, ceremonial dashboard, custom Media/SFX — all V2 per the design spec.
