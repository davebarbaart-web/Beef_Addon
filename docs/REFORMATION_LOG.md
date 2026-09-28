# Reformation Log

Mission: **THE REFORMATION** (2026-08-14). Orchestrator: Cursor workspace agent. Product owner: David Barba.

Authority order: Design Bible v1.1.1 → Peer Review Adjudication → Demo Build Audit → Reformation handoff. Retired workspace law is historical only.

## Phase 0 — Replace the Workspace Law

**Status:** GATE CLOSED  
**Branch:** `reformation/phase-0-workspace-law` (uncommitted working tree; no commit unless David asks)  
**Gate:** **PASSED 2026-08-14**

### Lanes (exclusive files; writers do not commit)

| Lane | Agent role | Owns | Bible sections |
|------|------------|------|----------------|
| A | Archive | `docs/archive/pre-reformation/**`, retired specs/plans/canon/domain rules | Audit §2, §6.1 |
| B | Ten Laws | `.cursor/rules/ten-laws.mdc` | Handoff §2; Bible §4, §5, §6, §10, §12, §13, §19 |
| C | Architecture | `.cursor/rules/architecture-overview.mdc` | §3, §13.1, §20; layers |
| D | Gora sanction | `.cursor/rules/gora-sanction.mdc` | §10 |
| E | Pope authority | `.cursor/rules/pope-authority.mdc`, `.cursor/rules/officer-guild-roster.mdc` | §5–6, §8, §13, §18 |
| F | Identity / records | `.cursor/rules/identity-records.mdc` | §12, §13.5, §17 |
| G | Ceremony runtime | `.cursor/rules/ceremony-runtime.mdc` | §20, §13.4 |
| H | Quiet / Event | `.cursor/rules/quiet-event-modes.mdc` | §4.8, §14.1, §19 |
| I | Records not points | `.cursor/rules/records-not-points.mdc` | §4.6, §4.9, §10.9, §15, §17 |
| J | Engineering keepers | surviving engineering `.mdc` files | Audit §4 keepers |
| K | Visual juice rewrite | `.cursor/rules/ui-juice-standards.mdc` | §19.3–19.4; Law 10 |
| L | Maps | `README.md`, `AGENTS.md`, skill pointer | Handoff §3 Phase 0 |

### Agents spawned

Writer squad (Grok 4.6, exclusive files, no commits):

| Lane | Agent | Role |
|------|-------|------|
| A | [Archive](995bd1cc-5e97-4493-afe3-f7d69590e489) | Move retired law; write WHY.md |
| B | [Ten Laws](eb784b51-4680-4ec8-84d2-39a7734c19c9) | `ten-laws.mdc` |
| C | [Architecture](eed6f356-c9a4-41ac-9f46-6b533335c452) | Rewrite `architecture-overview.mdc` |
| D | [Gora sanction](d1edbe47-8e31-49f6-bba3-9417133beaf3) | `gora-sanction.mdc` |
| E | [Pope authority](2c2ee6d8-7c6c-4975-a3a6-8b7c7641c80f) | `pope-authority.mdc` + officer-roster rewrite |
| F | [Identity](0fdd805f-3e93-44f1-8ee1-0ce91d28b0e7) | `identity-records.mdc` |
| G | [Runtime](73460701-ee5c-484b-8844-04dd6d1a9352) | `ceremony-runtime.mdc` |
| H | [Quiet/Event](69e016cb-00c7-4047-ae0b-92b288c408dd) | `quiet-event-modes.mdc` |
| I | [Records≠points](969cb07d-706e-4ec3-8365-bfaceee888be) | `records-not-points.mdc` |
| J | [Engineering](b54e8aff-427a-4b41-84c3-9288ee8a6f16) | Light-edit surviving engineering rules |
| K | [Visual law](594be56f-351a-4bce-95b1-025233136e5b) | Rewrite `ui-juice-standards.mdc` |
| L | [Maps](6536fd5c-dd84-4399-9a74-b0d1b89cfa4f) | README.md + AGENTS.md |

Reviewers: spawned for all twelve writer lanes. **All writers DONE.** Integrator note: `addon-module-layers.mdc` still banned all guild promote APIs; aligned to Bible §8 / Lane E (`KNIGHT THIS BEEF` where permitted). J reviewer must confirm.

### Verdicts

- Lane A ([Archive](995bd1cc-5e97-4493-afe3-f7d69590e489)): writer DONE. [Archive review](8c9b50bb-7a5e-4ad1-831e-4eb8af9b32c7): Spec PASS; Quality was Changes required. Critical Butcher-as-invented sentence fixed in review. Integrator fixed Important leftover (“invented ranks” / Audit stack) in WHY.md — Bible §5: Butcher is canon as a raid-team role; Prophet is the invented rank. **Lane A signed.**
- Lane I ([Records≠points](969cb07d-706e-4ec3-8365-bfaceee888be)): writer DONE. [Records review](b762f9d0-973b-479a-8d91-22e914f1b052): Spec PASS; Quality Changes required. Integrator locked streaks to sanctioned-Gora W/L only (engagement/favor/login streaks stay banned). Knight/Lord lines name the Pope and the Knight starting rank. **Lane I signed.**
- Lane H ([Quiet/Event](69e016cb-00c7-4047-ae0b-92b288c408dd)): writer DONE. [Quiet review](3d328eda-4e83-4ddd-bd62-14c39137b1cd): Spec PASS; Quality Changes required. Integrator: only Quiet notice is §13.4 version-mismatch; player-opened Quiet is profile/records only (no Standing/Ladder/Officer shell); Event chrome dies on return to QUIET. **Lane H signed.**
- Lane D ([Gora sanction](d1edbe47-8e31-49f6-bba3-9417133beaf3)): writer DONE. [Gora review](a0d66c9f-d0b9-43d6-85e5-05a351ba6d3c): Spec PASS; Quality Changes required. Integrator: streaks = sanctioned-Gora W/L only; Famous Upsets are Pope-flagged; no pairing score / auto-sanction; defenses are a named field, not sit-the-champ (OPEN_QUESTIONS #9). **Lane D signed.**
- Lane F ([Identity](0fdd805f-3e93-44f1-8ee1-0ce91d28b0e7)): writer DONE. [Identity review](3046e34a-097e-4c4f-affc-0ba41a558969): Spec PASS; Quality Changes required. Integrator: `Names.Key` is not durable character identity; Rite restored to kneel / ~thirty seconds / formally bound; Curtain is display-only (never a store purge); Church rank lives on the human row only. **Lane F signed.**
- Lane K ([Visual law](594be56f-351a-4bce-95b1-025233136e5b)): writer DONE. [Visual review](420674b2-0d4d-49df-a0f8-47d11d162d7c): Spec PASS; Quality Changes required. Integrator: Quiet names the §13.4 notice only; “no center-screen pulses” does not ban the Fight HUD. **Lane K signed.**
- Lane B ([Ten Laws](eb784b51-4680-4ec8-84d2-39a7734c19c9)): writer DONE. [Ten Laws review](509592a6-eba5-494b-9ada-3d4b56a3febc): Spec FAIL (bare “streaks” / “no pruning”). Reviewer added Bible-faithful clauses; integrator added Law 6 dashboards/bars/sound and Law 1 currencies ≠ honorifics. **Lane B signed.**
- Lane E ([Pope authority](2c2ee6d8-7c6c-4975-a3a6-8b7c7641c80f)): writer DONE. [Pope review](71e05466-2d5a-4f44-9a52-01a62fd9994b): Spec PASS; Quality Changes required. Integrator: `rankIndex` is display/drift only — not Church id. **Lane E signed.**
- Lane C ([Architecture](eed6f356-c9a4-41ac-9f46-6b533335c452)): writer DONE. [Architecture review](2ce426b1-4bf1-45ef-b7dd-c7fde363e13a): Spec PASS; Quality Changes required. §13.1 per-client + account-level SV compatible. Integrator: Decree/Console/Records Book no longer labeled Event Mode. **Lane C signed.**
- Lane G ([Runtime](73460701-ee5c-484b-8844-04dd6d1a9352)): writer DONE. [Runtime review](b1d9fedc-b334-4ce6-aa13-d380da46a199): Spec PASS; Quality Changes required. Integrator: no peer SYNC even as gossip; Net discards non-Pope senders; snapshot is whisper-to-Pope only; Tuesday start is one zero-config action; “awaiting the Pope” is Event Mode degraded. **Lane G signed.**
- Lane J ([Engineering](b54e8aff-427a-4b41-84c3-9288ee8a6f16)): writer DONE. [Engineering review](3dc5f317-af26-4169-a6f0-e6b7b4036406): Spec PASS; Quality Changes required. Integrator corrected the lane report’s leftover blanket promote-ban and the packaging “identity is per human” flatten. **Lane J signed.**
- Lane L ([Maps](6536fd5c-dd84-4399-9a74-b0d1b89cfa4f)): writer DONE. [Maps review](31bf67dc-f9a6-4d47-8397-a07aec70dbd2): Spec PASS; Quality Changes required. Integrator: Law 7 identity on README/AGENTS; skill polish loop must ignore research pages that restore archived spec as law. **Lane L signed.**

### Gate status

- **Gate 0: PASSED.**
  1. All twelve lanes signed (writers + adversarial review + integrator Important fixes).
  2. Conformance grep ([grep](8aaef1d5-dc3a-4185-8908-9c5406e0bc0e)): **0 leftover-law, 0 Criticals** in live `.cursor/rules`, README, AGENTS, skill. Report: `docs/reformation/phase-0/reports/GATE0-conformance-grep.md`.
  3. Fresh-context ([Gate 0](26704cb3-ac89-4fae-aee8-976a4730d36d)): **GATE0_PASS.** Given only the workspace, the agent named the Bible product and refused the demo product. Report: `docs/reformation/phase-0/reports/GATE0-fresh-context.md`.
  4. Orchestrator summary for David: workspace law now describes Church of Beef as ceremony / sanctioned Gora / memory under the Design Bible. The points-ladder machine is archived. Addon Lua is still the demo — that is Phase 1.

### Fresh-context conformance verdict (Gate protocol §5.3)

A fresh agent reading README, AGENTS, `ten-laws.mdc`, `architecture-overview.mdc`, and the Bible answered: this is a social ceremony, sanctioned-Gora, and memory layer; the Pope performs; the add-on is the stage manager. Banned: points/XP/thresholds/Grant/standing, Officer+ rituals, Beef Prophet, per-character “alts start fresh,” ELO, activity leaderboards, auto-narration. Would not rebuild the demo product. **Checked:** Laws 1–10; Bible §4–6, §10, §12, §13, §19.

## Phase 1 — The Excision

**Status:** GATE CLOSED  
**Branch:** `reformation/phase-1-excision` (from Phase 0 working tree; uncommitted)  
**Gate:** **PASSED 2026-08-14**

### Lanes (exclusive files; writers do not edit TOC / `ChurchOfBeef.lua` / `tests/run.lua`)

| Lane | Owns | Bible / Audit |
|------|------|----------------|
| P1-A | `Core/Scoring.lua`, `tests/test_scoring.lua` (delete) | V1; Law 1 |
| P1-B | `Core/Ladder.lua`, `tests/test_ladder.lua` (delete) | V1, V6; Law 1, 7 |
| P1-C | Attic `Core/Instance.lua`, `Core/Quest.lua` + their scoring tests | Audit §4 shelve |
| P1-D | `Data/Ranks.lua`, `tests/test_ranks.lua` | Law 9; §5 |
| P1-E | `UI/StandingTab.lua`, `tests/test_standing_ui.lua`; toast grant kinds; minimap pip | V8, V9; Law 6 |
| P1-F | `UI/MainFrame.lua`, `UI/LadderTab.lua`, `UI/OfficerTab.lua`, `UI/Status.lua`, `UI/Announce.lua` — strip ladder/standing IA | Law 6; Audit MainFrame rework |
| P1-G | `Core/Gora.lua`, `Core/Ceremony.lua`, `Core/DB.lua` — cut Scoring/Ladder calls so load does not error. Do not rebuild Gora/Ceremony product. | V4, V5 |

Integrator owns: `ChurchOfBeef.toc`, `ChurchOfBeef.lua`, `tests/run.lua`.

### Verdicts

- P1-A ([Scoring delete](2a6f3d0d-7cd1-4cba-aa8e-108b2e019c54)): writer DONE. [Scoring review](2024d7f3-3505-4ac5-99e6-f194f56aa8d7): Spec PASS; Quality Approved. No replacement scorer. Residual Grant callers were other lanes (G cut them). **Lane A signed.**
- P1-B ([Ladder delete](fb8a4699-db8a-4925-9ba7-bcb924f30e81)): writer DONE. [Ladder review](7507b5c4-b786-4432-8253-409b27712a89): Spec PASS; Quality Approved. Standing engine deleted, not relocated. No lite ladder / SweepDeparted implementation. Leftover callers are other lanes. **Lane B signed.**
- P1-C ([Instance Quest attic](9e5111ff-31b0-405b-957b-da56d3b0dcac)): writer DONE. [Attic review](5e7e48f5-c7de-4493-9617-0e53de52e2c0): Spec PASS; Quality Approved. Sensing is attic-only; TOC/bootstrap/`run.lua` do not load it. Attic `_Grant` still calls deleted Scoring and pays nothing. No Expedition product. **Lane C signed.**
- P1-D ([Ranks rewrite](d0638249-a43a-4ea8-b3ea-5c92cef42846)): writer DONE. [Ranks review](652c7b0f-9f23-459b-b350-5869eb6b0bc5): Spec PASS; Quality Approved. Six ranks, ids 1–6; no Prophet / thresholds / CouncilSeats; guild-index map is a nil stub. Isolated ranks 49/0. Officer/Roster leftovers are other lanes. **Lane D signed.**
- P1-E ([Quiet UI](acef8830-33e7-45e5-8505-8c50497bfd9d)): writer DONE. [Quiet review](4e3fd56f-4a4f-4e6c-beac-1355eeb64475): Spec PASS; Quality Approved. Standing tab, grant toast kinds, and minimap pip gone. Leftover BeefNet `Celebrate("suggest")` no-ops. **Lane E signed.**
- P1-F ([Shell IA](a57732e0-666b-43a7-811c-5af8444b4336)): writer DONE. [Shell review](975d5340-be59-4525-9887-3c3abc8bfc1c): Spec PASS; Quality Approved. Guild-management tabs gone; `/beef` is a tabless drag/resize shell. No Director Console or Decree. Leftover empty tab registry and dead `ClassColorCode` are plumbing, not presented IA. **Lane F signed.**
- P1-G ([Core cut](697bb416-ce5a-42dd-8055-8747b680acae)): writer DONE. [Core-cut review](4f9b5199-6d17-4483-8352-ec039378eb63): Spec PASS; Quality Approved. No points faucet inlined. `RecordResult` and officer session flags are Phase 3/4 leftovers, not a rebuild. **Lane G signed.**

All seven Phase 1 lanes signed.

**Client smoke (Design Lead §3e / §5.5), owner David, 2026-08-14:** live on Anniversary. Minimap presence; `/beef` is a tabless empty shell. Integrator mid-smoke: Roster no longer drops members when `ChurchRankIdForGuildIndex` is nil (was stuck on “Reading the guild roster…”); Law 10 footer “Eternal Grazing.” removed. Player `WTF/` untouched.

**Sweep lanes H–M all signed.** Full harness **489/0** (`lua tests/run.lua` exit 0).

### Gate status

- **Gate 1: PASSED.**
  1. Lanes A–G signed; leftover sweep H–M signed (Design Lead `GATE1_DESIGN_LEAD_DIRECTIVE.md` §5.1).
  2. Full harness green: **489 passed, 0 failed.** No skipped-as-red suites.
  3. Conformance grep: **0 Criticals** on live `addon/` + TOC. `SUGGESTION` is a retired discard name only. Benign hits waived one-by-one in `docs/reformation/phase-1/reports/GATE1-conformance-grep.md`.
  4. Fresh-context ([Gate 1](fbb84087-8481-4731-ad58-d88cdf6cb48f)): **GATE1_PASS.** Bible + shipped code only. Report: `docs/reformation/phase-1/reports/GATE1-fresh-context.md`.
  5. Human client smoke **PASSED 2026-08-14 (owner: David)** — Anniversary install, minimap present, `/beef` is an empty Quiet shell. Player `WTF/` untouched.
  6. This verdict. Phase 2 opens below. No commit (David has not asked). Design Lead still recommends a Gate 0 + Gate 1 pair of commits if David authorizes.

### Fresh-context conformance verdict (Gate protocol §5.3)

A fresh agent reading the Bible, Ten Laws, and live TOC Lua answered: the shipped addon is a **Quiet shell**, not the points-ladder demo and not the Bible MVP. No Grant, standing, suggestion, Scoring, Ladder, Prophet, Officer+ rituals, or activity leaderboards. Residuals (unused Toasts engine, unused `CountGuildmates`, `SavedVariablesPerCharacter`, tombstone names like `RefreshLadder`) are revive risks, not a running demo. **Checked:** Laws 1–10 against live symbols.

### Orchestrator summary for David

Phase 1 excised the points-ladder machine. What loads is a hideable minimap and an empty `/beef` frame. Church history, the Pope store, and the Sacred Archive are Phase 2 — that work starts now. The client already smoked this shell; `/reload` after the BeefNet cut if you have not since. No git commit until you ask.

### Sweep lanes (Gate 1 close)

| Lane | Owns |
|------|------|
| P1-H | `Core/Roster.lua`, `tests/test_roster.lua` — sensing only; no GetLadderView / SweepDeparted |
| P1-I | `Core/Officer.lua`, `tests/test_officer.lua` — fail-closed stub; Phase 4 comment |
| P1-J | `Net/BeefNet.lua`, net suites — keep HELLO + transport; delete SUGGESTION |
| P1-K | `tests/test_db.lua` — current `{ version, ui }` only |
| P1-L | `UI/MainFrame.lua`, `UI/Toasts.lua`, `tests/test_ui.lua` — cut tab registry / ClassColorCode / promote-rite builders |
| P1-M | `Core/Gora.lua`, `Core/Ceremony.lua` — sever unused RecordResult / session stubs; keep pair-key |

Writers dispatched. No commits.

### Sweep verdicts

- P1-H ([Roster cut](d4fa3e9c-5dd8-46a9-ad0e-cf66a1815e57)): writer DONE. [Roster review](b06d755f-ef22-4a8a-aa48-d889d18c45a9): Spec PASS; Quality Approved. Sensing only; `GetLadderView` / SweepDeparted gone. Isolated 46/0. **Lane H signed.**
- P1-I ([Officer stub](b3cc42a8-9462-4794-9e59-329ee3101350)): writer DONE. [Officer review](a88d221f-1d24-4ade-81f3-b26700e96c72): Spec PASS; Quality Approved. Authority always false. Isolated 27/0. BeefNet SUGGESTION leftover is P1-J. **Lane I signed.**
- P1-J ([BeefNet cut](d416a189-24bf-4a73-b8bb-7022d7b5091b)): writer DONE. [BeefNet review](38ece7a0-ec0b-47a3-b13a-e5f1be88f1be): Spec PASS; Quality Approved. HELLO + transport kept; SUGGESTION retired discard only. Isolated net 70/0 and 35/0. No v2. **Lane J signed.**
- P1-K ([DB tests](96a69503-9177-4d76-91f0-f1ca0051e79b)): writer DONE. [DB-test review](0482c679-b3b1-4292-90ff-dd82d3cccf85): Spec PASS; Quality Approved. `{ version, ui }` only; leftover keys survive. Isolated 36/0. **Lane K signed.**
- P1-L ([UI leftovers](12cafee3-5836-496e-9c5b-298ae34f1ab0)): writer DONE. [UI leftovers review](a3e79d26-45a5-4972-9595-3a831970f8ab): Spec PASS; Quality Approved. Tab registry / ClassColorCode / promote-rite kinds gone. Isolated `test_ui` 135/0. **Lane L signed.**
- P1-M ([Stub containment](632f80f1-30c7-46c5-9ddc-49d0aed77b73)): writer DONE. [Stub review](02352869-1a93-480d-ad56-676d338ebe65): Spec PASS; Quality Approved. `RecordResult` and `Ceremony.lua` gone; pair-key salvage kept. **Lane M signed.**

### Open questions

- See `docs/design/OPEN_QUESTIONS.md` (Appendix B carry-forward only).

## Phase 2 — Re-Found the Data Layer

**Status:** GATE CLOSED  
**Branch:** same working tree as Phase 1 (`reformation/phase-1-excision`; uncommitted). No rewrite of the handoff Phase 2 text.  
**Cited:** Bible §12, §13.1, §13.5, §10.9, §15, §16; Law 5, 7; Audit V6 / rework step 3; Design Lead §4 (elevation timestamps; #8 do not code).  
**Gate:** **PASSED 2026-08-15**

Handoff (verbatim scope): account-level `ChurchOfBeefDB`; Pope-authoritative store (identities, linked characters, ranks, character Gora records, ceremony log, marked moments, honorifics); never-delete (tombstones, no sweeps); Sacred Archive export/import/restore/integrity; reuse `Core/Common.lua` Names/Clock; test-first on the offline harness.

### Lanes (exclusive files; writers do not edit TOC / `ChurchOfBeef.lua` / `tests/run.lua`)

| Lane | Owns | When |
|------|------|------|
| P2-A | `Core/Store.lua`, `tests/test_store.lua` — Pope store schema | now |
| P2-B | `Core/Archive.lua`, `tests/test_archive.lua` — Sacred Archive codec | after A signed |
| P2-C | `Core/Recognition.lua`, `tests/test_recognition.lua` — Rite of Recognition Core flow | after A signed |
| P2-D | `Core/DB.lua`, `tests/test_db.lua` — account SV hook; ignore old ladder/scoring | now |
| P2-E | `Core/DB.lua`, `tests/test_db.lua` — persist `Store:Snapshot` into `ChurchOfBeefDB.store` | after A–D signed |

Integrator owns: TOC (`## SavedVariables: ChurchOfBeefDB` when flipping; add Store/Archive/Recognition only after those files exist), bootstrap, `tests/run.lua`.

### Do not invent (all lanes)

Director Console, Decree, sanctioned Gora loop, BeefNet v2, registered-Pope data file (#8), Archive reminder widgets, Curtain UX, Fallen memorials, activity witnessing, Grant/standing/suggestion, Prophet, defenses as a stored counter (derived later from elevation timestamp + Gora record).

Integrator: TOC flipped to `## SavedVariables: ChurchOfBeefDB` (account-level; Design Lead §3d). Store/Archive/Recognition not listed until those files exist.

Writers: [Pope store](465ecfeb-fb5c-4acf-8bcf-7d9a6965fec2) (A), [Sacred Archive](a02c68d2-d0f5-4bfe-a620-367dfb4488e2) (B), [Recognition](e3c25aed-3e66-4a59-ba2a-f0360697c813) (C), [SV migration](c5812b82-3e52-4888-8c21-77ab16c29621) (D), [Store persist](05fb857d-7e24-49dc-9e0a-66ec5eb1d2cf) (E). No commits.

Integrator: `Core/Store.lua`, `Core/Archive.lua`, and `Core/Recognition.lua` listed in TOC; `test_store`, `test_archive`, and `test_recognition` listed in `tests/run.lua`.

### Verdicts

- P2-A ([Pope store](465ecfeb-fb5c-4acf-8bcf-7d9a6965fec2)): writer DONE. [Pope store review](5ad64930-289a-4213-94c5-09066fe82cc4): Spec PASS; Quality Approved. Integer ids; rank on human; Gora on character; first-Lord `elevationAt`; no defense counter. Isolated 277/0. Restore can hold a crafted Prophet rank — Lane B fail-closed. **Lane A signed.**
- P2-B ([Sacred Archive](a02c68d2-d0f5-4bfe-a620-367dfb4488e2)): writer DONE. [Archive review](dc5c1007-302c-491c-b68e-7612f1904eba): Spec PASS; Quality Approved. Codec only; fail-closed Import. Isolated 490/0. **Lane B signed.**
- P2-C ([Recognition](e3c25aed-3e66-4a59-ba2a-f0360697c813)): writer DONE. [Recognition review](3c1155bb-e079-446d-a6e8-2225a9534a71): Spec PASS; Quality Approved. Core rite only; no self-service. Isolated 163/0. **Lane C signed.**
- P2-D ([SV migration](c5812b82-3e52-4888-8c21-77ab16c29621)): writer DONE. [SV migration review](eb2cdf5f-3c74-412a-861a-31ac1dbf6b71): Spec PASS; Quality Approved. Schema 5; empty `store` hook; leftovers not imported. Isolated 109/0. **Lane D signed.**
- P2-E ([Store persist](05fb857d-7e24-49dc-9e0a-66ec5eb1d2cf)): writer DONE. [Persist review](635f055c-65a3-4282-b3da-919ac114e22d): Spec PASS; Quality Approved. Snapshot ↔ account SV; `{}` does not Restore. Isolated 206/0. **Lane E signed.**

### Gate status

- **Gate 2: PASSED.**
  1. Lanes A–E signed (schema, Archive, Recognition, SV hook, persist).
  2. Full harness green: **1589 passed, 0 failed.**
  3. Conformance grep: **0 Criticals** on live `addon/` + TOC. Account `SavedVariables`; no Grant/standing/Prophet. Report: `docs/reformation/phase-2/reports/GATE2-conformance-grep.md`.
  4. Fresh-context ([Gate 2](ad2aa18d-c16b-43e9-a40d-8219c5e07ff4)): **GATE2_PASS.** Bible + shipped code only. Report: `docs/reformation/phase-2/reports/GATE2-fresh-context.md`.
  5. This verdict. Phase 3 opens below. No commit (David has not asked).

### Fresh-context conformance verdict (Gate protocol §5.3)

A fresh agent reading the Bible, Ten Laws, and live TOC Lua answered: shipped code is a **Quiet shell plus an account-level Pope store**, Archive codec, Recognition rite, and SV persist. Not a points ladder. Not Bible MVP. Rank on the human; Gora on the character; tombstone not delete; Archive fail-closed; persist Snapshot-shaped only. Residuals (unused Toasts, unused `CountGuildmates`, `RefreshLadder` name, no writer-role gate) are revive risks. **Checked:** Laws 1–10; Bible §12, §13.1, §13.5.

### Orchestrator summary for David

Phase 2 re-founded the data layer. Church history can live on the account SV and leave the machine via the Sacred Archive. Linking is a Core rite, not a silent bind. The client is still a Quiet shell — no Director Console, no ceremony night, no BeefNet v2. That is Phase 3. `/reload` picks up persist. No git commit until you ask.

## Phase 3 — Ceremony Runtime + BeefNet v2

**Status:** GATE CLOSED  
**Branch:** same working tree (`reformation/phase-1-excision`; uncommitted). No rewrite of the handoff Phase 3 text.  
**Cited:** Bible §20, §13.1, §13.4, §4.11; Laws 4, 5, 6; `.cursor/rules/ceremony-runtime.mdc`; Design Lead §4 (#8 do not code registered-Pope file).  
**Gate:** PASSED. Do not claim V1/MVP complete. Phase 4 opens below.

Handoff (verbatim scope): event state machine QUIET → ASSEMBLY → RITE (typed) → CONSEQUENCE → ASSEMBLY or QUIET; Pope owns every transition; zero-setup Tuesday start; BeefNet v2 on the kept transport (state broadcasts, whisper snapshot, congregation inputs to Pope console only); registered-Pope sender validation; protocol version; stale clients Quiet; Pope-disconnect hold then “awaiting the Pope”; persist event object; offline-testable.

### Lanes (exclusive files; writers do not edit TOC / `ChurchOfBeef.lua` / `tests/run.lua`)

| Lane | Owns | When |
|------|------|------|
| P3-A | `Core/Runtime.lua`, `tests/test_runtime.lua` — ceremony state machine | now |
| P3-B | `Net/Codec.lua`, `tests/test_net_codec.lua` — encode/decode Bible kinds only | now |
| P3-C | snapshot request/response over whisper (after A+B) | after A+B signed |
| P3-D | sender-auth stub (after B) — no `#8` data file | after B signed |
| P3-E | Pope-disconnect / version degrade (after A+B) | after A+B signed |
| P3-F | chaos tests (after A–E) | after A–E signed |

### Do not invent (all lanes)

Director Console, Decree UI, sanctioned Gora loop, Fight HUD, opcode kitchen-sink, hold-timeout seconds, snapshot fields beyond Bible-named broadcast state, registered-Pope `Data/*.lua` (#8), Grant/standing, peer SYNC, generic ceremony builder, auto-advance, narration.

Writers: [Runtime](de5570e2-ea2c-4913-bfef-af6400ef7a6d) (A), [Codec](8ecaf0c9-f4dd-4f4c-b55c-a327e15f30d6) (B), [Snapshot](626d8b02-d282-4e68-a7a7-17769bd35a9f) (C), [Sender](aafab8f3-07bb-4f74-b098-8064ffafba1f) (D), [Degrade](dbc64275-59b2-4f4f-9b7d-2628f7e12922) (E), [Chaos](c91fd2d8-dbb1-4676-9503-200458969de4) (F). No commits.

Integrator: `UI/Console.lua`, `UI/Hud.lua`, and `UI/RecordsBook.lua` listed in TOC. `test_console`, `test_hud`, and `test_records` listed in `tests/run.lua`.

### Verdicts

- P3-A ([Runtime](de5570e2-ea2c-4913-bfef-af6400ef7a6d)): writer DONE. [Runtime review](8e7c1816-4e68-4678-b8a3-ca8b25da374b): Spec PASS; Quality Approved. Closed four-state machine; zero-config StartEvent; no auto-advance. Isolated 492/0. **Lane A signed.**
- P3-B ([Codec](8ecaf0c9-f4dd-4f4c-b55c-a327e15f30d6)): writer DONE. [Codec review](e638aea9-164b-4f98-ac1b-85dea2785462): Spec PASS; Quality Approved. STATE / SNAPSHOT / INPUT only; no extra snapshot schema. Isolated 371/0. **Lane B signed.**
- P3-C ([Snapshot](626d8b02-d282-4e68-a7a7-17769bd35a9f)): writer DONE. [Snapshot review](efd49eb7-dbdb-42d7-b3bc-5ae3f6ed7251): Spec PASS; Quality Approved. Request / BuildResponse / ApplyResponse; Bible fields only; no peer SYNC. Isolated 471/0. **Lane C signed.**
- P3-D ([Sender](aafab8f3-07bb-4f74-b098-8064ffafba1f)): writer DONE. [Sender review](2b47a298-5c43-40b2-9e68-dda401121b01): Spec PASS; Quality Approved. IsRegisteredPope always false; Accept INPUT-only; no Pope list. Isolated 193/0. **Lane D signed.**
- P3-E ([Degrade](dbc64275-59b2-4f4f-9b7d-2628f7e12922)): writer DONE. [Degrade review](29b5934f-7975-4911-9b85-c8154e3e9481): Spec PASS; Quality Approved. `awaitingPope` flag only; not a sixth state; no holdSeconds. Isolated 648/0. **Lane E signed.**
- P3-F ([Chaos](c91fd2d8-dbb1-4676-9503-200458969de4)): writer DONE. [Chaos review](282e064f-301b-441d-8525-53cbf19f1820): Spec PASS; Quality Approved. Compose-only §20.4 suite; no holdSeconds; older snapshots Restore (named leftover). Isolated 481/0. **Lane F signed.**

### Gate status

- **Gate 3: PASSED.**
  1. Lanes A–F signed (runtime, codecs, snapshot, sender stub, degrade, chaos).
  2. Full harness green: **3727 passed, 0 failed.**
  3. Conformance grep: **0 Criticals** on live `addon/` + TOC. No Grant/standing/Prophet; no peer SYNC; no sixth state; no `Data/Popes.lua`. Report: `docs/reformation/phase-3/reports/GATE3-conformance-grep.md`.
  4. Fresh-context ([Gate 3](935d968d-76f8-4f34-8f63-a83a263855c2)): **GATE3_PASS.** Bible + shipped code only. Report: `docs/reformation/phase-3/reports/GATE3-fresh-context.md`.
  5. This verdict. Phase 4 opens below. No commit (David has not asked).

### Fresh-context conformance verdict (Gate protocol §5.3)

A fresh agent reading the Bible, Ten Laws, and live TOC Lua answered: shipped code is a **Quiet shell plus a ceremony-runtime / BeefNet v2 skeleton**. Four-state Pope-owned machine. STATE / SNAPSHOT / INPUT codecs. Catch-up is not peer SYNC. Not a points ladder. Not Bible MVP. Leftovers: codecs unwired (HELLO only), Runtime not in `ChurchOfBeefDB`, #8 uncoded. **Checked:** Laws 1–10; Bible §20, §13.1, §13.4, §4.11.

### Orchestrator summary for David

Phase 3 landed the skeleton a Gathering hangs on: QUIET → ASSEMBLY → RITE → CONSEQUENCE, codecs, snapshot apply, fail-closed sender, `awaitingPope` as Event Mode degraded. The client is still a Quiet shell — no Director Console, no sanctioned Gora night, no v2 on the wire. Those leftovers start Phase 4. `#8` (registered-Pope file) remains spec, not license to build. No git commit until you ask.

## Phase 4 — The Centerpiece: Beef Gora + Director Console + Knighting

**Status:** GATE CLOSED  
**Branch:** same working tree (`reformation/phase-1-excision`; uncommitted). No rewrite of the handoff Phase 4 text.  
**Cited:** Bible §10, §18, §8, §10.9, §20.3, §13.1, §13.4; Laws 3, 4, 5, 6, 8, 10; `.cursor/rules/ceremony-runtime.mdc`; Design Lead §4 (#8 is Phase 4 *spec*, not license to code `Data/Popes.lua`).  
**Gate:** PASSED. Do not claim V1/MVP complete. Phase 5 opens below.

Handoff (verbatim scope): Gora flow (petition → sanction → mute cards → favor → WoW duel → Pope-ratified verdict → records → elevation); Fight HUD; Director Console desks; KNIGHT THIS BEEF; Records Book superlatives, no ranked ladder. Reuse Toasts / MainFrame plumbing / Roster sensing / Officer→authority.

Phase 3 leftovers that must land before theater: persist the Runtime event object into account SV (§20.3); put STATE (GUILD, Pope-only) and SNAPSHOT (whisper-to-Pope) on the kept BeefNet transport. INPUT channel is unspecified — do not invent one. `#8` exact file / edit path / override UX stay uncoded.

### Lanes (exclusive files; writers do not edit TOC / `ChurchOfBeef.lua` / `tests/run.lua`)

| Lane | Owns | When |
|------|------|------|
| P4-A | `Core/DB.lua`, `tests/test_db.lua` — persist Runtime event object | now |
| P4-B | `Net/BeefNet.lua`, `tests/test_net_v2.lua` — STATE GUILD + SNAPSHOT whisper recv/send gates | now |
| P4-C | `Core/Gora.lua`, `tests/test_gora.lua` — sanction + verdict Core | after A+B signed |
| P4-D | `Core/Knighting.lua`, `tests/test_knighting.lua` — KNIGHT / elevate verbs | after A+B signed |
| P4-E | `UI/Console.lua`, `tests/test_console.lua` — Director Console desks (stock) | after C+D signed |
| P4-F | `UI/Hud.lua`, `tests/test_hud.lua` — Fight HUD, no live health | after C+D signed |
| P4-G | `UI/RecordsBook.lua`, `tests/test_records.lua` — Records Book superlatives | after C+D signed |

### Do not invent (all lanes)

Fight HUD live-health (Appendix A #1 open), Records Book category veto (#3), Curtain UX (#4), Decree deputy (#5), Council Chronicle flag (#7), registered-Pope `Data/*.lua` / override UX (#8), INPUT channel, hold-timeout seconds, peer SYNC, Grant/standing, auto-advance, narration, generic ceremony builder, opcode kitchen-sink.

Writers: [Persist](9a838146-ab3c-4ecb-a342-224117dadbdb) (A), [Wire](e6dccf4a-5e77-45bb-ab29-fe7cd8a1ee87) (B), [Gora](16506793-dc48-467f-89a6-0a010107bb42) (C), [Knighting](1511d548-db04-4ce3-b6c8-74858cfa4433) (D), [Console](a6853f45-0b46-4d4b-92c8-6f766575545f) (E), [HUD](f5e7b876-de7a-4b48-9243-87111a88b7f9) (F), [Records](f1369ae1-2568-402f-8fdf-79d8a08fc12e) (G). No commits.

### Verdicts

- P4-A ([Persist](9a838146-ab3c-4ecb-a342-224117dadbdb)): writer DONE. [Persist review](58733ce9-ec28-4f67-8eec-6dc2f336959c): Spec PASS; Quality Approved. Schema 6; `event` = Runtime Snapshot; leftovers stay. Isolated 369/0. **Lane A signed.**
- P4-B ([Wire](e6dccf4a-5e77-45bb-ab29-fe7cd8a1ee87)): writer DONE. [Wire review](1a13c196-f79c-44f1-ab53-69f465e9f48d): Spec PASS; Quality Approved. STATE GUILD + SNAPSHOT whisper; fail-closed; no INPUT channel. Isolated 298/0. **Lane B signed.**
- P4-C ([Gora](16506793-dc48-467f-89a6-0a010107bb42)): writer DONE. [Gora review](cf0052e9-6dd2-4bc2-8720-2f4a795668e4): Spec PASS; Quality Approved. Sanction-only Gora; no TTL; four Pope rulings. Isolated 304/0. **Lane C signed.**
- P4-D ([Knighting](1511d548-db04-4ce3-b6c8-74858cfa4433)): writer DONE. [Knighting review](00a0892b-c6b2-4bf3-8783-7e21aa6ddc2c): Spec PASS; Quality Approved. KnightThisBeef → rank 3; ElevateToLord → rank 4; no guild promote. Isolated 134/0. **Lane D signed.**
- P4-E ([Console](a6853f45-0b46-4d4b-92c8-6f766575545f)): writer DONE. [Console review](073b2589-d483-4f19-9d87-ffc8011b8f54): Spec PASS; Quality Approved. Stock Event Mode desks; rituals fail-closed; no slash. Isolated 215/0. **Lane E signed.**
- P4-F ([HUD](f5e7b876-de7a-4b48-9243-87111a88b7f9)): writer DONE. [HUD review](de7ac100-daf3-437f-8b38-85b5d14ed9c0): Spec PASS; Quality Approved. Event Mode only; no health scrape; no favor. Isolated 226/0. **Lane F signed.**
- P4-G ([Records](f1369ae1-2568-402f-8fdf-79d8a08fc12e)): writer DONE. [Records review](d93e943b-2447-4ca5-ae69-d8f0853be9d4): Spec PASS; Quality Approved. Quiet parchment; Bible pages; Famous Upsets flagged only. Isolated 248/0. **Lane G signed.**

### Gate status

- **Gate 4: PASSED.**
  1. Lanes A–G signed (persist Runtime, STATE/SNAPSHOT wire, Gora Core, Knighting Core, Console, HUD, Records Book).
  2. Full harness green: **5248 passed, 0 failed.**
  3. Conformance grep: **0 Criticals** on live `addon/` + TOC. No Grant/standing/Prophet; no peer SYNC; no `Data/Popes.lua`; no ranked ladder. Report: `docs/reformation/phase-4/reports/GATE4-conformance-grep.md`.
  4. Fresh-context ([Gate 4](33c63d26-cdfd-43b7-b33f-2f569feeff62)): **GATE4_PASS.** Bible + shipped code only. Report: `docs/reformation/phase-4/reports/GATE4-fresh-context.md`.
  5. This verdict. Phase 5 opens below. No commit (David has not asked).

### Fresh-context conformance verdict (Gate protocol §5.3)

A fresh agent reading the Bible, Ten Laws, and live TOC Lua answered: shipped code is a **Gora + Knighting + Console/HUD/Records skeleton**, not a points-ladder demo and not a live Gathering. Sanction / four Pope rulings write the store. KnightThisBeef / ElevateToLord write Church rank only. Console / HUD / Records modules exist and are **unhosted**. `#8` is uncoded, so rituals and STATE / SNAPSHOT stay fail-closed. No favor, no Decree, no live HUD health. **Checked:** Laws 1–10; Bible §10, §18, §8, §10.9, §14.2, §20, §13.1, §13.4.

### Orchestrator summary for David

Phase 4 landed the centerpiece **skeleton**, not a Gathering. `/beef` is still the empty Quiet shell. Console, Fight HUD, and Records Book load and are never shown. Rituals refuse because there is no registered-Pope list. That is honest leftover, not a missing host invented here. Phase 5 starts the everyday layer the handoff named: the Decree, then Event-Mode sound. SUMMON, Confession transport, clipboard, onboarding, guild-rank map, and `#8` stay uncoded. No git commit until you ask.

## Phase 5 — Ceremony Completeness + Everyday Layer

**Status:** GATE CLOSED  
**Branch:** same working tree (`reformation/phase-1-excision`; uncommitted). No rewrite of the handoff Phase 5 text.  
**Cited:** Bible §14.1, §14.2, §19.4, §19.5, §7, §5; Laws 3, 4, 6, 10; `.cursor/rules/quiet-event-modes.mdc`; `.cursor/rules/ceremony-runtime.mdc` (SUMMON is stretch — do not invent a protocol).  
**Gate:** PASSED. Do not claim V1/MVP complete. Phase 6 opens below.

Handoff (verbatim scope): The Decree (§14.1: single active proclamation, login banner, minimap access, hard-bounded — no calendar/RSVP), SUMMON THE FAITHFUL one-button broadcast, Beef Confession queue support (text renders on Pope console only), sound cues (§19.4: sanction bell, verdict, elevation, knighting, cowardice — Event Mode only, Quiet Mode silent), post-show clipboard summary, near-invisible onboarding (§19.5), guild-rank reconciliation (§5 display-vs-truth).

Phase 4 leftovers that may land only when specified: host Records Book as player-opened Quiet (`/beef`); HUD `Init` (hides in QUIET). Do **not** host the Director Console (no slash; `#8` still false). Do **not** invent a SUMMON protocol, an INPUT / Confession channel, a clipboard schema, onboarding beyond one parchment, a guild-rank map, Decree deputy UX (#5), or `Data/Popes.lua` (#8).

### Lanes (exclusive files; writers do not edit TOC / `ChurchOfBeef.lua` / `tests/run.lua`)

| Lane | Owns | When |
|------|------|------|
| P5-A | `Core/Decree.lua`, `tests/test_decree.lua`, `Core/DB.lua`, `tests/test_db.lua` — single Decree + persist | now |
| P5-B | `UI/Decree.lua`, `tests/test_decree_ui.lua`, `UI/Minimap.lua`, `tests/test_minimap.lua` — login banner + minimap replay | after A signed |
| P5-C | `UI/Sound.lua`, `tests/test_sound.lua` — Event Mode cues only | now |

### Do not invent (all lanes)

Decree deputy (#5), calendar / RSVP / reminders / recurrence / attendance, Decree wire kind / STATE field, SUMMON protocol, INPUT channel, Confession fan-out, post-show clipboard schema, onboarding config wall, guild-rank map, `#8` / `Data/Popes.lua`, Console slash, favor, live HUD health, Grant/standing, narration, extra sound cues, Canonization seal (later).

Writers: [Decree](c4ee49cf-e160-497e-9874-fc1f2c8e49ff) (A), [Banner](a252dd60-bba4-46bb-af45-a14d41c56669) (B), [Sound](6fec9432-0cf5-41d7-8966-883748542570) (C). No commits.

### Verdicts

- P5-A ([Decree](c4ee49cf-e160-497e-9874-fc1f2c8e49ff)): writer DONE. [Decree review](18ad3c18-fa01-414b-b1a2-46f9f4c92eff): Spec PASS; Quality Approved. Single `line` + optional `flavor`; schema 7; empty `{}` does not wipe. Isolated 129/0 and 515/0. Integrator lists `Core/Decree.lua` (before `DB.lua`). `test_decree` already in the harness. **Lane A signed.**
- P5-B ([Banner](a252dd60-bba4-46bb-af45-a14d41c56669)): writer DONE. [Banner review](3d2b6c0e-0675-4c65-8e64-bf79b7b80487): Spec PASS; Quality Approved. Quiet parchment; session once; left-click replay; no Core clobber. Isolated 218/0 and 92/0. Integrator lists `UI/Decree.lua` + `test_decree_ui`. **Lane B signed.**
- P5-C ([Sound](6fec9432-0cf5-41d7-8966-883748542570)): writer DONE. [Sound review](6fd684eb-58f3-4183-957a-483a0916fafc): Spec PASS; Quality Approved. Event Mode allow-list; Quiet silent; no media; no callers. Isolated 177/0. Integrator lists `UI/Sound.lua` + `test_sound`. **Lane C signed.**

### Gate status

- **Gate 5: PASSED.**
  1. Lanes A–C signed (Decree persist, banner + minimap replay, Event Mode Sound verb).
  2. Full harness green: **5885 passed, 0 failed.**
  3. Conformance grep ([Conformance](c6e4d1a1-0d9a-4af1-a08a-6af9a5350372)): **0 Criticals** on live `addon/` + TOC. No Grant/standing/Prophet; no calendar/RSVP; no Quiet sound; no `Data/Popes.lua`. Report: `docs/reformation/phase-5/reports/GATE5-conformance-grep.md`.
  4. Fresh-context ([Gate 5](5a1efee2-2d10-444f-939b-1086273f2cbc)): **GATE5_PASS.** Bible + shipped code only. Report: `docs/reformation/phase-5/reports/GATE5-fresh-context.md`.
  5. This verdict. Phase 6 opens below. No commit (David has not asked).

### Fresh-context conformance verdict (Gate protocol §5.3)

A fresh agent reading the Bible, Ten Laws, and live TOC Lua answered: shipped code is an **everyday-layer skeleton** — one persisted Decree, login parchment plus minimap replay, Event-only Sound verb. Not a points ladder. Not a live Gathering. `#8` uncoded. Console / HUD / Records unhosted. Sound callers unwired. No Console Post. SUMMON / Confession / clipboard / onboarding / guild-rank stay out. **Checked:** Laws 1–10; Bible §14.1, §14.2, §19.4, §13.1, §13.4, §20.

### Orchestrator summary for David

Phase 5 landed the Tuesday quiet the Bible named: almost nothing, plus the Decree. `/reload` loads the banner; it stays hidden until a Decree is `Set`. There is still no Console Post, so a live login will not show a parchment unless you set one. Sound exists and nothing rings it. That is honest leftover. Phase 6 is validation and rehearsal prep — Appendix A written results, a §22.3 checklist, a dress-rehearsal script. It is not a license to code `#8`, SUMMON, or favor. No git commit until you ask.

## Phase 6 — Validation, Hardening, Rehearsal Prep

**Status:** OPEN  
**Branch:** same working tree (`reformation/phase-1-excision`; uncommitted). No rewrite of the handoff Phase 6 text.  
**Cited:** Bible Appendix A, §22.3, §21, §10.7, §13.4; Laws 4, 6, 8; Design Lead: do not invent `#8`.  
**Gate:** lanes A–C signed. Close waits on David walking Appendix A items 1–4 in-game (`docs/validation/A01`–`A04`, Result still NOT RUN). Do not claim V1/MVP complete.

Handoff (verbatim scope): Appendix A execution — every API validation item becomes a task with a written result in `docs/validation/`. Items 1–4 are load-bearing (HUD health, duel system messages, sender integrity + rate limits at 40 clients, roster write permissions) — validate in-game early, not last. Rewrite `docs/phases/` checklists against Bible §22.3; author the dress-rehearsal script (late arrival, UI reload, Pope disconnect, no-show petitioner, disputed Gora — all deliberate). Polish pass per §21 MVP component list; packaging for CurseForge/Wago dual publish.

Phase 5 leftovers that stay named, not invented here: unhosted Console / HUD / Records, no Console Post, Sound callers unwired, `#8`, SUMMON protocol, INPUT / Confession channel, clipboard, onboarding wall, guild-rank map, Decree deputy.

### Lanes (exclusive files; writers do not edit TOC / `ChurchOfBeef.lua` / `tests/run.lua` / addon Lua)

| Lane | Owns | When |
|------|------|------|
| P6-A | `docs/validation/**` — Appendix A inventory + items 1–4 method sheets | now |
| P6-B | `docs/phases/v1-checklist.md` — rewrite against Bible §22.3 | now |
| P6-C | `docs/phases/dress-rehearsal.md` — §22.3 chaos script | now |

### Do not invent (all lanes)

In-game Appendix A **results** (write method + NOT RUN; owner David). HUD live-health as product (#2). Auto-propose from duel chat. `Data/Popes.lua` (#8). SUMMON protocol. INPUT channel. Favor. Calendar/RSVP. Grant/standing. CurseForge/Wago upload. POLISH:PASS. V1/MVP complete.

Writers: [Appendix A](19e09984-21c9-421d-858f-620dfb37e6a2) (A), [Checklist](b673c9b9-2ef2-46a1-95b8-b032145f0c0d) (B), [Rehearsal](39940c31-f2b0-4dc6-bb31-e98a27b42467) (C). No commits.

### Verdicts

- P6-A ([Appendix A](19e09984-21c9-421d-858f-620dfb37e6a2)): writer DONE. [Appendix A review](4ff7745a-50e2-42ae-855b-a156481dc89e): Spec PASS; Quality Approved. A01–A04 method only; Result NOT RUN; owner David. No HUD-as-pass, no `#8`. **Lane A signed.**
- P6-B ([Checklist](b673c9b9-2ef2-46a1-95b8-b032145f0c0d)): writer DONE. [Checklist review](81e4cbc5-f070-4b05-989a-66d9851fa52a): Spec PASS; Quality Approved. §22.3 walk; 39 unchecked boxes; leftovers not ticked. **Lane B signed.**
- P6-C ([Rehearsal](39940c31-f2b0-4dc6-bb31-e98a27b42467)): writer DONE. [Rehearsal review](d26b4558-f9d5-47d1-9c34-c58175cfe61e): Spec PASS; Quality Approved. Five failures; NOT RUN; no invented pass path. **Lane C signed.**

Lanes A–C are signed. Gate 6 stays **OPEN** until David writes Results on A01–A04. Named leftovers still out of this close: polish pass, CurseForge/Wago upload. No commit.

### Named leftovers — 2026-08-15 (David: proceed with all)

David licensed the leftover set from `docs/reformation/CONTINUE_2026-08-15.md`. **A01–A04 Results stay owner David** — agents do not fill them. `#8` is licensed as workspace data + local SV override only; designated-Council UX stays open (`OPEN_QUESTIONS` #8). `/beef console` is the requested host (`OPEN_QUESTIONS` #11). Do not invent SUMMON, INPUT/Confession, favor, live HUD health, calendar/RSVP, Grant, or POLISH:PASS.

| Lane | Owns | When |
|------|------|------|
| P6-D | `docs/validation/A05`–`A13` method sheets + README ledger | now |
| P6-E | `docs/phases/solo-smoke.md` rewrite (Bible, not roster-backed) | now |
| P6-F | `docs/phases/two-client-smoke.md` rewrite (star, not standing) | now |
| P6-G | `docs/phases/guild-night-playtest.md` rewrite (Gathering, not ladder) | now |
| P6-H | `Data/Popes.lua` + `Core/Sender.lua` + `tests/test_sender.lua` | now |
| P6-I | `UI/Console.lua` + `tests/test_console.lua` — Post Decree, Sound callers, `Hud:Refresh` | now |
| P6-J | `UI/Hud.lua` verify only unless the pair contract is broken | now |

Writers do not edit TOC / `ChurchOfBeef.lua` / `tests/run.lua` / `OPEN_QUESTIONS.md` / this log. Integrator lists `Data/Popes.lua` and adds `/beef console` after files exist. No commits.

### Verdicts (leftover wave)

- P6-J ([Fight HUD](f1fd2b5c-30f7-47ef-ae8c-bc906088d074)): writer DONE. [HUD review](3dea5b22-a5a0-4fbc-9989-0c68cac4175c): Spec PASS; Quality Approved. No Lua edits; pair contract holds; A01 still NOT RUN. **Lane J signed.**
- P6-E ([Solo smoke](3b7ffad2-ab13-46c0-bbb4-ae7b1d5e6617)): writer DONE. [Solo-smoke review](0947bf64-bd60-465e-8e3d-0504883c0a72): Spec PASS; Quality Approved. Integrator updated leftover honesty after P6-H/I landed (Post Decree exists; TOC lists empty `Popes.lua`). **Lane E signed.**
- P6-G ([Guild night](b45efbda-4b39-4d59-a013-5c7f199de8ea)): writer DONE. [Guild-night review](b1f6d17b-bc1c-49a5-9700-3f6c1a87623b): Spec PASS; Quality Approved. Integrator named the congregation-HUD / no-`SendState` leftover and refreshed companion honesty. **Lane G signed.**
- P6-D ([Appendix A 5–13](2a6a16fc-0fa0-421b-ace9-176c10005ce1)): writer DONE. [Appendix A 5–13 review](688e347d-d5d3-46b4-a597-56c4da0c8184): Spec PASS; Quality Approved. Nine method sheets; every Result NOT RUN. **Lane D signed.**
- P6-F ([Two-client smoke](4a58ca8f-c7d5-4dd0-88f5-36a2ed381d9c)): writer DONE. [Two-client review](70195899-ddcc-418c-a73a-0cf67decd2db): Spec PASS; Quality Approved. Integrator fixed the stale solo-smoke ladder cite. **Lane F signed.**
- P6-H ([Registered Pope](1b1f6d65-640d-426b-b338-d9445ea0ecd9)): writer DONE. [Pope-list review](468cad4c-fd5f-45d3-9326-2887f468bff9): Spec PASS; Quality Approved. Empty list; STATE/SNAPSHOT Accept; isolated 263/0. Integrator listed TOC and re-keys `IsListed` so a Display-case file entry is not a silent miss. **Lane H signed.**
- P6-I ([Console verbs](875fdd5e-934e-4e93-bde6-317590b1531f)): writer DONE. [Console review](ffe6677b-4dba-45d5-80b8-a084c24ed781): Spec PASS; Quality Approved. Post Decree, Event cues, Hud:Refresh; isolated 293/0. **Lane I signed.**

Leftover wave D–J is signed. Harness **6,043 passed, 0 failed** (live count; 6035 was stale). Gate 6 stays **OPEN** until David writes A01–A04 Results. Named leftovers that this closer still correctly parked: designated-Council UX, SUMMON, Confession fan-out, live HUD health, polish pass, CurseForge/Wago. SendState / favor / Decree wire moved to the Wire wave below.

## Wire & Vestments wave

**Status:** OPEN (Stage 1 signed. Stage 2 Vestments Batch 2 through Batch 33 signed — stock textures only, license 4. Gate W still awaits David's two-client smoke; Gate V stays OPEN. Do not treat either as closed.)  
**Branch:** `reformation/phase-1-excision`  
**Cited:** CONTINUE 2026-08-18 licenses 1–3; Bible §10.6, §13.1, §14.1; Laws 1, 4, 5, 6.  
**Gate W:** six exclusive lanes + integrator glue; harness green; then David walks `docs/phases/two-client-smoke.md`. Vestments stay closed until Gate W.

Writers do not commit and do not edit TOC / `ChurchOfBeef.lua` / `tests/run.lua` / `OPEN_QUESTIONS.md` / this log except the integrator.

| Lane | Owns | When |
|------|------|------|
| W-A | `Net/Codec.lua`, `tests/test_net_codec.lua` | now |
| W-B | `Core/Gora.lua`, `tests/test_gora.lua` | now |
| W-C | `Core/Store.lua`, `tests/test_store.lua` | now |
| W-D | `Net/BeefNet.lua`, `tests/test_net_v2.lua` | after W-A |
| W-E | `UI/Console.lua`, `tests/test_console.lua` | after W-B, W-C, W-D |
| W-F | `UI/Hud.lua`, `tests/test_hud.lua` | after W-B, W-D |

### Verdicts

- W-A ([Codec](109d0845-f1f2-48ee-b69c-4d1c1ec7c911)): writer DONE. [Codec review](16952c2b-f8c2-4cb4-9691-ea262048b18f): Spec PASS. Closed types are four (`DECREE`); favor INPUT requires `pick`; optional STATE / SNAPSHOT-response favor omitted when off. Integrator follow-on: encode refuses `"\n"` in decree `line` / `flavor`. Isolated codec 441/0. **Lane A signed.**
- W-B ([Gora](b7f8e09e-bd5d-477a-876c-fe82a4c604d1)): writer DONE. First [Gora review](47e48e7a-b991-4684-9be0-8ccebe3c9819): Spec FAIL on event-scope expire. Fix ([expire](b23ccf86-38b2-41ae-ac6b-243dfd1c1a0f)). [Rereview](9771575a-138d-4a96-b997-208a339719f3): Spec PASS; Quality Approved. Memory-only standing pick; `favorEventId` wipe on missing/different event; FreeRuling writes no `won`. Isolated gora 401/0. Minors only. **Lane B signed.**
- W-C ([Store](7e19204e-ad81-44dd-966c-3ee0830b4560)): writer DONE. [Store review](123cfffe-fa42-43f9-a30d-055bc6c53707): Spec PASS; Quality Approved. `free` without `won`; optional Pope text on bout + `AppendCeremony` 4th arg; Void/Victor/Cowardice unchanged. Isolated store 330/0. Minors only. **Lane C signed.**
- W-D ([BeefNet](1184a87d-9224-43b7-97db-ea906a9f2cb5)): writer DONE. [BeefNet review](996d7393-87c4-418a-894f-f5aaf7c8c7cd): Spec PASS; Quality Approved. Pope-gated `SendDecree`; congregation `SendFavor` whisper; inbound DECREE via `IsRegisteredPope`; favor INPUT live only as whisper-to-Pope. Isolated net_v2 403/0. Minors only. **Lane D signed.**
- W-E ([Console](2a3b7ef8-2467-4663-97bc-29f2594e050d)): writer DONE. [Console review](0160d6dd-f2fd-4324-971a-856482f6221f): Spec PASS; Quality Approved. Stock FAVOR pane; memory-only congregation toggle default on; Post Decree stays `Decree:Set`; FREE RULING text box, no winner. Isolated console 393/0. Minors only. **Lane E signed.**
- W-F ([HUD](02f56b54-9513-4abe-a83e-03bc681db499)): writer DONE. [HUD review](4cb80564-44d1-4387-b39a-b8538f21a5d9): Spec PASS; Quality Approved. Pope split from Gora; congregation from `SetBroadcastFavor` only; plate click → `SendFavor` after target + local id. Isolated hud 320/0. Minors only. **Lane F signed.**
- Integrator ([glue](adb28d84-07d5-489d-914b-ba3987676920)): DONE. [Glue review](c63fe5b8-1bab-4d94-900c-59cb2b55e072): Spec PASS; Quality Approved. `InstallWire` OnLogin-only; Runtime/favor/toggle → SendState; PostDecree → SendDecree; inbound STATE paints HUD favor. Isolated glue 133/0. Full harness **6677 passed, 0 failed**. Conformance: favor is memory-only (not in DB); no history/streak/economy; toggle-off omits STATE favor. **Do not treat Gate W as closed.** Hand David `docs/phases/two-client-smoke.md`.

### Vestments verdicts

- V-A ([Decree](e28eb2ee-cd84-43f9-843a-36e739ace78f)): [review](ac0740c2-a806-4961-963e-0f596effc8c4) Spec PASS. Line is headline; church name by seal; stock QuestBG; no Media. Isolated 241/0. **Lane V-A signed.** POLISH:CANDIDATE.
- V-B ([Toasts](1ea4f00d-ac82-48cc-a266-edd0f63136f3)): [review](4c7ebc52-38d5-4bfa-af16-da49e4ec06b2) Spec PASS. Proclaim sanction/verdict/cowardice; Quiet refuse; dim 0.45; clerical copy. Isolated 237/0. **Lane V-B signed.** POLISH:CANDIDATE.
- V-C ([Records](1458e4c0-4f0f-47b5-b275-07fe76ed62e8)): [review](13ecca27-cb56-4277-a478-fdb958c52df9) Spec PASS. Roman paint; PAGE_TITLES unchanged; no generated prose. Isolated 286/0. **Lane V-C signed.** POLISH:CANDIDATE.
- V-D ([HUD](414a67e1-c30f-4c2d-a0a8-c654af8a5afe)): [review](137b0baa-ba87-4808-9951-f3b376e6672a) Spec PASS. Stock QuestBG; EmptySlot ring (no faction); mute class rails; W-F favor intact; health nil. Isolated 358/0. **Lane V-D signed.** POLISH:CANDIDATE.
- V-INT ([Proclaim glue](d99ed642-23df-40c9-8bdf-baaabcde7fca)): [review](59326fdd-922e-48e1-a481-c083467ddf81) Spec PASS. Gora verbs → `Toasts:Proclaim`; Store names; inspect silent. Full harness **6958 passed, 0 failed**. **Gate V stays OPEN** (David eyeballs Batch 2). **Do not claim POLISH:PASS.**

### Batch 3 verdicts

- B3-A (Knighting / elevation proclamation): `docs/reformation/vestments/briefs/B3-A-knighting-review.md` Spec PASS; Quality Approved. `Proclaim` kinds `knighting` / `elevation`; Quiet refuse; fixed `RISE, BEEF KNIGHT` / `RISE, BEEF LORD`. Isolated `test_ui` 302/0. Integrator interop: cue-name pin now watches `Sound:Play` so B3-C kit ids do not red the suite. **Lane B3-A signed.** POLISH:CANDIDATE.
- B3-B (Mute fighter cards): `docs/reformation/vestments/briefs/B3-B-fightercard-review.md` Spec PASS; Quality Approved. Event Mode mute tape; no `UnitHealth`; defenses omitted. Isolated `test_fighter_card` 263/0. Integrator listed `UI\FighterCard.lua` and `test_fighter_card`. **Lane B3-B signed.** POLISH:CANDIDATE.
- B3-C (§19.4 SoundKit cues): `docs/reformation/vestments/briefs/B3-C-sound-review.md` Spec PASS; Quality Approved. Five cue names; `PlaySound` gets a number. Isolated `test_sound` 202/0. **Lane B3-C signed.** POLISH:CANDIDATE.
- B3-D (Console proposed bout): `docs/reformation/vestments/briefs/B3-D-console-bout-review.md` Spec PASS; Quality Approved. Stock pairing + stipulation; `Sanction` reads the box. Isolated `test_console` 439/0. **Lane B3-D signed.**
- B3-E (Congregation Snapshot request): `docs/reformation/vestments/briefs/B3-E-snapshot-review.md` Spec PASS; Quality Approved. `Net:RequestSnapshot(target)` whisper; needs a target; no Pope name. Isolated `test_net_v2` 433/0. Honesty table updated. **Lane B3-E signed.**
- Integrator (B3-INT): Knighting / elevation → `Toasts:Proclaim` with `Store:GetHuman` name; successful Sanction also `FighterCard:Show` / `Refresh`; inspect silent. Isolated glue 302/0. Full harness **7448 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 4 verdicts

- B4-A (Petition / confession INPUT on the wire): `docs/reformation/vestments/briefs/B4-A-inputs-wire-review.md` Spec PASS; Quality Approved. `SendPetition` / `SendConfession` whisper-to-Pope; GUILD INPUT stays unknown. Isolated `test_net_v2` 523/0. **Lane B4-A signed.**
- B4-C (Private confession inbox): `docs/reformation/vestments/briefs/B4-C-confession-review.md` Spec PASS; Quality Approved-with-nits. Memory-only; event-scoped expire; no fan-out. Isolated `test_confession` 158/0. Integrator listed `Core\Confession.lua`. **Lane B4-C signed.**
- B4-D (Console petition H2H + confession inbox): `docs/reformation/vestments/briefs/B4-D-console-inbox-review.md` Spec PASS; Quality Approved. Mute H2H `1-0`; confession text on the Pope desk only; stock Dismiss. Isolated `test_console` 499/0. **Lane B4-D signed.**
- B4-E (Fighter card left dock): `docs/reformation/vestments/briefs/B4-E-fightercard-dock-review.md` Spec PASS; Quality Approved-with-nits. LEFT third; MORPHEUS names; keep `1-0`. Isolated `test_fighter_card` 276/0. **Lane B4-E signed.** POLISH:CANDIDATE.
- B4-F (HUD parchment name fields): `docs/reformation/vestments/briefs/B4-F-hud-parchment-review.md` Spec PASS; Quality Approved-with-nits. Thin QuestBG behind name/title; health nil; W-F favor intact. Isolated `test_hud` 370/0. **Lane B4-F signed.** POLISH:CANDIDATE.
- B4-G (Congregation petition / confess): `docs/reformation/vestments/briefs/B4-G-congregation-inputs-review.md` Spec PASS; Quality Approved. Event-only Inputs; injected target; Net only. Isolated `test_inputs` 209/0. Integrator listed `UI\Inputs.lua` and `test_inputs`. **Lane B4-G signed.** POLISH:CANDIDATE.
- B4-H (Director Console dock): `docs/reformation/vestments/briefs/B4-H-console-dock-review.md` Spec PASS; Quality Approved-with-nits. Event + local Pope only; title `DIRECTOR CONSOLE`; SANCTION / Expand. Isolated `test_console_dock` 156/0. Integrator listed `UI\ConsoleDock.lua` and `test_console_dock`. **Lane B4-H signed.** POLISH:CANDIDATE.
- Integrator (B4-INT): `bindLocalCharacter` also binds Inputs; inbound STATE sets Inputs target and refreshes Inputs / ConsoleDock; Runtime StartEvent / OpenRite / Continue / EndEvent refresh those surfaces; EndEvent Hides the fighter card; `/beef petition` and `/beef confess` bind `UnitName("target")` only. Honesty: whisper-to-Pope `SendPetition` / `SendConfession` still need a caller-supplied target. Isolated glue 364/0. Full harness **8139 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 5 verdicts

- B5-A (Knighting line): `docs/reformation/vestments/briefs/B5-A-knighting-line-review.md` Spec PASS; Quality Approved-with-nits. Memory-only line; no `queue` / `AdvanceQueue`; `KnightThisBeef` dequeues that human. Isolated `test_knighting` 306/0. **Lane B5-A signed.**
- B5-B (Candidate / fighter raid marks): `docs/reformation/vestments/briefs/B5-B-markers-review.md` Spec PASS; Quality Approved-with-nits. Event + Pope + grouped; Quiet refuse; no GuildPromote. Isolated `test_markers` 251/0. Integrator listed `UI\Markers.lua` and `test_markers`. **Lane B5-B signed.**
- B5-C (Console line / Recommend / CallForward / FlagMoment): `docs/reformation/vestments/briefs/B5-C-console-verbs-review.md` Spec PASS; Quality Approved-with-nits. Stock desk; Recommend never Sanctions. Isolated `test_console` 630/0. **Lane B5-C signed.**
- B5-D (Theater toast display face): `docs/reformation/vestments/briefs/B5-D-toast-face-review.md` Spec PASS; Quality Approved-with-nits. MORPHEUS headlines; clerical copy unchanged. Isolated `test_ui` 321/0. **Lane B5-D signed.** POLISH:CANDIDATE.
- B5-E (Congregation snapshot catch-up): `docs/reformation/vestments/briefs/B5-E-catchup-review.md` Spec PASS; Quality Approved. Event `Inputs:Catchup` → `Net:RequestSnapshot(target)`; needs a target; no Pope name. Isolated `test_inputs` 241/0. Honesty table updated. **Lane B5-E signed.**
- Integrator (B5-INT): successful `KnightThisBeef` also `Markers:Target` / `MarkCandidate` from Store human/character name; successful Sanction also `MarkFighters` from Store character names; `/beef catchup` binds `UnitName("target")` then `Inputs:Catchup`. Honesty: `Inputs:Catchup` / `RequestSnapshot(target)` still need a caller-supplied target. Isolated glue 423/0. Full harness **8776 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 6 verdicts

- B6-A (Console honorific + Recognition): `docs/reformation/vestments/briefs/B6-A-console-identity-review.md` Spec PASS; Quality Approved-with-nits. `GrantHonorific` → `Store:AddHonorific`; Begin confirmer `"pope"`; Complete/Cancel no theater; `SaveNote` nil; no Council button. Isolated `test_console` 744/0. **Lane B6-A signed.**
- B6-B (Records Book identity leaf): `docs/reformation/vestments/briefs/B6-B-records-identity-review.md` Spec PASS; Quality Approved. Right leaf paints local honorifics + marked-moment locations; `PAGE_TITLES` unchanged. Isolated `test_records` 331/0. **Lane B6-B signed.** POLISH:CANDIDATE.
- B6-C (ElevateToLord leaves the knighting line): `docs/reformation/vestments/briefs/B6-C-lord-line-review.md` Spec PASS; Quality Approved-with-nits. Successful `ElevateToLord` removes that human from the line; no `queue` / `AdvanceQueue`; no GuildPromote. Isolated `test_knighting` 336/0. **Lane B6-C signed.**
- B6-D (Mute fighter-card honorifics): `docs/reformation/vestments/briefs/B6-D-card-honorific-review.md` Spec PASS; Quality Approved-with-nits. First Store honorific as mute line; empty/unlinked hide; keep `1-0`. Isolated `test_fighter_card` 329/0. **Lane B6-D signed.** POLISH:CANDIDATE.
- Integrator (B6-INT): no new TOC files; exclusive sources unopened; no compose fix; no honorific / Recognition Proclaim wraps (Law 4). Isolated lanes 744/331/336/329. Glue 423/0 unchanged. Full harness **9017 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 7 verdicts

- B7-A (Store Canonize + Famous Upset flag): `docs/reformation/vestments/briefs/B7-A-store-chronicle-review.md` Spec PASS; Quality Approved-with-nits. `CanonizeMoment` writes Pope `scripture` only; `FlagFamousUpset` flags the latest matching win and never computes an upset. Snapshot/Restore keep both. Isolated `test_store` 416/0. **Lane B7-A signed.**
- B7-B (Console Archive + Canonize + Flag Upset): `docs/reformation/vestments/briefs/B7-B-console-archive-review.md` Spec PASS; Quality Approved-with-nits. Stock EXPORT / IMPORT ARCHIVE (CopyToClipboard for the Archive blob only); CANONIZE; FLAG UPSET. `SaveNote` nil. No post-show summary. Isolated `test_console` 887/0. **Lane B7-B signed.**
- B7-C (Records Book canonized scripture): `docs/reformation/vestments/briefs/B7-C-records-scripture-review.md` Spec PASS; Quality Approved. Right leaf paints `scripture` after location; `PAGE_TITLES` unchanged. Isolated `test_records` 356/0. **Lane B7-C signed.** POLISH:CANDIDATE.
- Integrator (B7-INT): no new TOC files; exclusive sources unopened; no compose fix; no Canonize / Flag Upset Proclaim wraps (Law 4). Archive is Pope-local (`Core/Archive.lua` already TOC-listed). Isolated lanes 416/887/356. Full harness **9258 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 8 verdicts

- B8-A (Store derived defenses): `docs/reformation/vestments/briefs/B8-A-defenses-review.md` Spec PASS; Quality Approved-with-nits. `CountDefenses` is a derived read (`won == true` after `elevationAt`); never writes `gora.defenses`. Isolated `test_store` 450/0. **Lane B8-A signed.**
- B8-B (Records Most Successful Defenses): `docs/reformation/vestments/briefs/B8-B-records-defenses-review.md` Spec PASS. Fills from `CountDefenses` via `maxHolders`; `PAGE_TITLES` unchanged. Isolated `test_records` 372/0. **Lane B8-B signed.** POLISH:CANDIDATE.
- B8-C (Fighter card mute defense count): `docs/reformation/vestments/briefs/B8-C-card-defenses-review.md` Spec PASS. Mute integer; hide at 0; keep `1-0`. Isolated `test_fighter_card` 388/0. **Lane B8-C signed.** POLISH:CANDIDATE.
- B8-D (HUD mute defense count): `docs/reformation/vestments/briefs/B8-D-hud-defenses-review.md` Spec PASS. Mute integer; health nil; favor W-F intact. Isolated `test_hud` 421/0. **Lane B8-D signed.** POLISH:CANDIDATE.
- B8-E (Console Archive box): `docs/reformation/vestments/briefs/B8-E-archive-box-review.md` Spec PASS. Type-guarded `SetMultiLine`; stock ARCHIVE / CANONIZE labels; `SaveNote` nil. Isolated `test_console` 936/0. **Lane B8-E signed.**
- Integrator (B8-INT): no new TOC files; exclusive sources unopened; no compose fix; no defense Proclaim. Isolated lanes 450/372/388/421/936. Glue 423/0 unchanged. Full harness **9465 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 9 verdicts

- B9-A (Knighting ceremony log): `docs/reformation/vestments/briefs/B9-A-knighting-log-review.md` Spec PASS. Type-only `Knighting` / `Elevation` append after successful SetRank. Isolated `test_knighting` 361/0. **Lane B9-A signed.**
- B9-B (Gora ceremony log): `docs/reformation/vestments/briefs/B9-B-gora-log-review.md` Spec PASS. Type-only `victor` / `cowardice` / `void` after writeBoth; Famous Upsets still not computed. Isolated `test_gora` 432/0. **Lane B9-B signed.**
- B9-C (Console ceremony log desk): first review FAIL (id collision). Fix + rereview PASS. Type-routed names; newest first; `SaveNote` nil. Isolated `test_console` 1021/0. **Lane B9-C signed.**
- B9-D (Victor clerical close): `docs/reformation/vestments/briefs/B9-D-victor-copy-review.md` Spec PASS. `Victor declared: <name>. So ruled by the Beef Pope.` Isolated `test_ui` 321/0. **Lane B9-D signed.** POLISH:CANDIDATE.
- B9-E (HUD persist through verdict): `docs/reformation/vestments/briefs/B9-E-hud-persist-review.md` Spec PASS. Last pair stays painted until QUIET. Isolated `test_hud` 466/0. **Lane B9-E signed.** POLISH:CANDIDATE.
- Integrator (B9-INT): no new TOC files; exclusive sources unopened after the B9-C fix; no compose fix. Isolated lanes 361/432/1021/321/466. Glue 423/0 unchanged. Full harness **9648 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 10 verdicts

- B10-A (Gora last pair / last favor): first review FAIL (event scope). Fix + rereview PASS. `GetLastSanctioned` / `GetLastFavorSplit` are event-scoped; `GetSanctioned` stays nil after a ruling. Isolated `test_gora` 505/0. **Lane B10-A signed.**
- B10-B (HUD Runtime subjects): `docs/reformation/vestments/briefs/B10-B-hud-subjects-review.md` Spec PASS. Congregation pair from `subjects.fighters`. Isolated `test_hud` 539/0. **Lane B10-B signed.** POLISH:CANDIDATE.
- B10-C (Fighter card persist): `docs/reformation/vestments/briefs/B10-C-card-persist-review.md` Spec PASS. Card stays through the verdict; Runtime subjects accepted. Isolated `test_fighter_card` 441/0. **Lane B10-C signed.** POLISH:CANDIDATE.
- B10-D (Console scroll): `docs/reformation/vestments/briefs/B10-D-console-scroll-review.md` Spec PASS. Stock `UIPanelScrollFrameTemplate`; outer height 780. Isolated `test_console` 1081/0. **Lane B10-D signed.**
- Integrator (B10-INT): `stateFields` copies last pair + last favor while the event is live; Sanction / verdicts `SendState`; inbound STATE with fighters Shows the card. Isolated lanes 505/539/441/1081. Glue **455/0**. Full harness **9936 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 11 verdicts

- B11-A (SNAPSHOT last pair / last favor): `docs/reformation/vestments/briefs/B11-A-snapshot-review.md` Spec PASS. Encode-only overlay; last pair CONSEQUENCE-only; favor toggle-gated. Isolated `test_net_snapshot` 610/0. **Lane B11-A signed.**
- B11-B (HUD leftover plate clicks): `docs/reformation/vestments/briefs/B11-B-hud-picks-review.md` Spec PASS. Plate `OnClick` never uses lastPair; Pope needs live `GetSanctioned`; congregation Runtime pair only in RITE. Isolated `test_hud` 624/0. **Lane B11-B signed.** POLISH:CANDIDATE.
- B11-C (Console wheel + Open Gora): `docs/reformation/vestments/briefs/B11-C-console-wheel-review.md` Spec PASS. Type-guarded `EnableMouseWheel`; Open Gora falls back to live then last pair. Isolated `test_console` 1175/0. **Lane B11-C signed.**
- Integrator (B11-INT): STATE overlay is RITE / CONSEQUENCE only so congregation Restore succeeds; toggle-off still omits favor. Isolated lanes 610/624/1175. Glue **467/0**. Full harness **10257 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 12 verdicts

- B12-A (ASSEMBLY subjects): `docs/reformation/vestments/briefs/B12-A-runtime-assembly-review.md` Spec PASS. Restore ASSEMBLY may keep candidate / fighters; QUIET still empty. Isolated `test_runtime` 688/0. **Lane B12-A signed.**
- B12-B (Open Knighting fallback): `docs/reformation/vestments/briefs/B12-B-knighting-open-review.md` Spec PASS. Line head when no selection; SelectHuman wins. Isolated `test_console` 1232/0. **Lane B12-B signed.**
- B12-C (Fighter card ESC): `docs/reformation/vestments/briefs/B12-C-card-esc-review.md` Spec PASS. `UISpecialFrames` deduped; lastPair until QUIET. Isolated `test_fighter_card` 448/0. **Lane B12-C signed.** POLISH:CANDIDATE.
- B12-D (Proclaim ESC): `docs/reformation/vestments/briefs/B12-D-toast-esc-review.md` Spec PASS. `ChurchOfBeefProclaim` on `UISpecialFrames`; OnHide tears theater down. Isolated `test_ui` 345/0. **Lane B12-D signed.** POLISH:CANDIDATE.
- Integrator (B12-INT): live pair overlays ASSEMBLY STATE; last pair still not post-Continue. Isolated lanes 688/1232/448/345. Glue **472/0**. Full harness **10387 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 13 verdicts

- B13-A (ASSEMBLY overlay Apply): `docs/reformation/vestments/briefs/B13-A-snapshot-apply-review.md` Spec PASS. ApplyResponse of live ASSEMBLY overlay Restores fighters. Isolated `test_net_snapshot` 640/0. **Lane B13-A signed.**
- B13-B (Fighter card OnHide): `docs/reformation/vestments/briefs/B13-B-card-onhide-review.md` Spec PASS. Widget Hide syncs lastView; lastPair until QUIET. Isolated `test_fighter_card` 482/0. **Lane B13-B signed.** POLISH:CANDIDATE.
- B13-C (Records wheel): `docs/reformation/vestments/briefs/B13-C-records-wheel-review.md` Spec PASS. Wheel up Previous, down Next. Isolated `test_records` 391/0. **Lane B13-C signed.** POLISH:CANDIDATE.
- B13-D (Console EditBox ESC): `docs/reformation/vestments/briefs/B13-D-console-esc-review.md` Spec PASS. stockEdit ClearFocus on OnEscapePressed. Isolated `test_console` 1286/0. **Lane B13-D signed.**
- Integrator (B13-INT): no glue. Isolated lanes 640/482/391/1286. Full harness **10521 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 14 verdicts

- B14-A (SNAPSHOT Knighting candidate): `docs/reformation/vestments/briefs/B14-A-snapshot-candidate-review.md` Spec PASS. Encode-only line-head overlay on ASSEMBLY / RITE Knighting. Isolated `test_net_snapshot` 800/0. **Lane B14-A signed.**
- B14-B (Inputs ESC ClearFocus): `docs/reformation/vestments/briefs/B14-B-inputs-esc-review.md` Spec PASS. Confess box `OnEscapePressed` ClearFocus; `SetMultiLine(true)`; not on `UISpecialFrames`. Isolated `test_inputs` 294/0. **Lane B14-B signed.** POLISH:CANDIDATE.
- B14-C (ConsoleDock persist): `docs/reformation/vestments/briefs/B14-C-dock-persist-review.md` Spec PASS. Title-bar drop saves `ChurchOfBeefDB.ui.consoleDock`. Isolated `test_console_dock` 207/0. **Lane B14-C signed.** POLISH:CANDIDATE.
- B14-D (Console UISpecialFrames dedupe): `docs/reformation/vestments/briefs/B14-D-console-special-review.md` Spec PASS. Decree-style `rememberSpecial` for `ChurchOfBeefConsoleFrame`. Isolated `test_console` 1332/0. **Lane B14-D signed.**
- Integrator (B14-INT): STATE overlays Knighting line-head candidate when Runtime lacks one (ASSEMBLY / RITE Knighting only). No Enqueue `sendState`. Isolated lanes 800/294/207/1332. Glue **505/0**. Full harness **10851 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 15 verdicts

- B15-A (Inputs drag persist): `docs/reformation/vestments/briefs/B15-A-inputs-persist-review.md` Spec PASS. `ChurchOfBeefDB.ui.inputs` HUD pattern. Isolated `test_inputs` 386/0. **Lane B15-A signed.** POLISH:CANDIDATE.
- B15-B (Records wheel on chrome): `docs/reformation/vestments/briefs/B15-B-records-wheel-review.md` Spec PASS. TitleBar / Close / ribbons / Prev / Next share the outer wheel handler. Isolated `test_records` 420/0. **Lane B15-B signed.** POLISH:CANDIDATE.
- B15-C (Quiet shell UISpecialFrames): `docs/reformation/vestments/briefs/B15-C-shell-special-review.md` Spec PASS. `rememberSpecial` for `ChurchOfBeefFrame`. Isolated `test_ui` 368/0. **Lane B15-C signed.**
- B15-D (KnightThisBeef refuses Lord+): `docs/reformation/vestments/briefs/B15-D-knight-lord-review.md` Spec PASS. Rank ≥ 4 returns `already elevated`; re-knight of Knight stays. Isolated `test_knighting` 394/0. **Lane B15-D signed.**
- Integrator (B15-INT): successful Enqueue / Skip / Insert / KnightThisBeef / ElevateToLord send STATE. Failed Enqueue does not. Console pin updated so KNIGHT THIS BEEF no longer expects a Lord demotion. Isolated lanes 386/420/368/394. Glue **540/0**. Full harness **11055 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 16 verdicts

- B16-A (ElevateToLord refuses Butcher / Council): `docs/reformation/vestments/briefs/B16-A-elevate-refuse-review.md` Spec PASS. Rank > 4 returns `already elevated`; re-elevate of Lord stays. Isolated `test_knighting` 419/0. **Lane B16-A signed.**
- B16-B (Inputs TitleBar drag): `docs/reformation/vestments/briefs/B16-B-inputs-handle-review.md` Spec PASS. 12px handle; persist still `ui.inputs`. Isolated `test_inputs` 419/0. **Lane B16-B signed.** POLISH:CANDIDATE.
- B16-C (Congregation Gora-only picks): `docs/reformation/vestments/briefs/B16-C-hud-gora-review.md` Spec PASS. `pickPair` needs RITE and `riteType == "Gora"`. Isolated `test_hud` 646/0. **Lane B16-C signed.** POLISH:CANDIDATE.
- B16-D (Markers local player): `docs/reformation/vestments/briefs/B16-D-markers-player-review.md` Spec PASS. `resolveUnit` returns `"player"` on names-same. Isolated `test_markers` 319/0. **Lane B16-D signed.**
- Integrator (B16-INT): no glue. Isolated lanes 419/419/646/319. Glue **540/0**. Full harness **11197 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 17 verdicts

- B17-A (Petition opponent on Codec): `docs/reformation/vestments/briefs/B17-A-codec-opponent-review.md` Spec PASS. Optional name field on existing petition INPUT. Isolated `test_net_codec` 480/0. **Lane B17-A signed.**
- B17-B (Send/recv petition opponent): `docs/reformation/vestments/briefs/B17-B-petition-opponent-review.md` Spec PASS. Name → Snapshot first-match; miss does not Petition. Isolated `test_net_v2` 551/0. **Lane B17-B signed.**
- B17-C (Inputs target as opponent): `docs/reformation/vestments/briefs/B17-C-inputs-challenge-review.md` Spec PASS. `UnitName("target")` when not whisper dest / not player. Isolated `test_inputs` 505/0. **Lane B17-C signed.** POLISH:CANDIDATE.
- B17-D (HUD hide leftover Knighting pair): `docs/reformation/vestments/briefs/B17-D-hud-hide-review.md` Spec PASS. `livePair` runtime arm is RITE+Gora. Isolated `test_hud` 672/0. **Lane B17-D signed.** POLISH:CANDIDATE.
- Integrator (B17-INT): no glue. Isolated lanes 480/551/505/672. Glue **540/0**. Full harness **11368 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 18 verdicts

- B18-A (Inputs box + trim): `docs/reformation/vestments/briefs/B18-A-inputs-gap-review.md` Spec PASS. Confess box TOP -14; opponent trimmed. Isolated `test_inputs` 599/0. **Lane B18-A signed.** POLISH:CANDIDATE.
- B18-B (Console petition names): `docs/reformation/vestments/briefs/B18-B-console-names-review.md` Spec PASS. Tests-only pin of `"  names  "` + SelectFighters. Isolated `test_console` 1388/0. **Lane B18-B signed.**
- B18-C (HideAll theaterGen): `docs/reformation/vestments/briefs/B18-C-toast-gen-review.md` Spec PASS. One bump per dismiss. Isolated `test_ui` 382/0. **Lane B18-C signed.** POLISH:CANDIDATE.
- B18-D (Markers Clear player): `docs/reformation/vestments/briefs/B18-D-markers-clear-review.md` Spec PASS. `Clear` spies `"player", 0`. Isolated `test_markers` 342/0. **Lane B18-D signed.**
- Integrator (B18-INT): no glue. Isolated lanes 599/1388/382/342. Glue **540/0**. Full harness **11544 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 19 verdicts

- B19-A (Petitions until Roster complete): `docs/reformation/vestments/briefs/B19-A-roster-complete-review.md` Spec PASS. Fail-open Store ids while not complete. Isolated `test_console` 1438/0. **Lane B19-A signed.**
- B19-B (Small toast ESC): `docs/reformation/vestments/briefs/B19-B-toast-esc-review.md` Spec PASS. `ChurchOfBeefToast` on `UISpecialFrames`. Isolated `test_ui` 415/0. **Lane B19-B signed.** POLISH:CANDIDATE.
- B19-C (lastPair rite gate): `docs/reformation/vestments/briefs/B19-C-hud-rite-review.md` Spec PASS. lastPair does not paint through a non-Gora RITE. Isolated `test_hud` 714/0. **Lane B19-C signed.** POLISH:CANDIDATE.
- B19-D (Decree Morpheus path): `docs/reformation/vestments/briefs/B19-D-decree-font-review.md` Spec PASS. `Fonts\\MORPHEUS.ttf`. Isolated `test_decree_ui` 246/0. **Lane B19-D signed.** POLISH:CANDIDATE.
- Integrator (B19-INT): no glue. Isolated lanes 1438/415/714/246. Glue **540/0**. Full harness **11671 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 20 verdicts

- B20-A (Confession click + called token): `docs/reformation/vestments/briefs/B20-A-confession-click-review.md` Spec PASS. Click `SelectCharacter`; mute `"  called"`. Isolated `test_console` 1514/0. **Lane B20-A signed.**
- B20-B (Records Morpheus path): `docs/reformation/vestments/briefs/B20-B-records-font-review.md` Spec PASS. `PAGE_TITLE_FONT` `Fonts\\MORPHEUS.ttf`. Isolated `test_records` 425/0. **Lane B20-B signed.** POLISH:CANDIDATE.
- B20-C (Fighter card Morpheus path): `docs/reformation/vestments/briefs/B20-C-card-font-review.md` Spec PASS. `NAME_FONT` `Fonts\\MORPHEUS.ttf`. Isolated `test_fighter_card` 486/0. **Lane B20-C signed.** POLISH:CANDIDATE.
- B20-D (Small toast ESC pump): `docs/reformation/vestments/briefs/B20-D-toast-pump-review.md` Spec PASS. OnHide `bumpGen` then `pump`. Isolated `test_ui` 455/0. **Lane B20-D signed.** POLISH:CANDIDATE.
- Integrator (B20-INT): no glue. Isolated lanes 1514/425/486/455. Glue **540/0**. Full harness **11792 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 21 verdicts

- B21-A (Presence seed fail-open): `docs/reformation/vestments/briefs/B21-A-presence-seed-review.md` Spec PASS. Store names append `here = false` until complete. Isolated `test_console` 1585/0. **Lane B21-A signed.**
- B21-B (lastPair CONSEQUENCE gate): `docs/reformation/vestments/briefs/B21-B-hud-consequence-review.md` Spec PASS. Non-Gora CONSEQUENCE does not paint lastPair. Isolated `test_hud` 729/0. **Lane B21-B signed.** POLISH:CANDIDATE.
- B21-C (Toast interrupt idle): `docs/reformation/vestments/briefs/B21-C-toast-interrupt-review.md` Spec PASS. OnHide returns when `showing` is already nil. Isolated `test_ui` 473/0. **Lane B21-C signed.** POLISH:CANDIDATE.
- B21-D (Inputs player fail-closed): `docs/reformation/vestments/briefs/B21-D-inputs-player-review.md` Spec PASS. Player pcall fail omits opponent. Isolated `test_inputs` 676/0. **Lane B21-D signed.** POLISH:CANDIDATE.
- Integrator (B21-INT): no glue. Isolated lanes 1585/729/473/676. Glue **540/0**. Full harness **11963 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 22 verdicts

- B22-A (Recommend names token): `docs/reformation/vestments/briefs/B22-A-recommend-names-review.md` Spec PASS. Mute `"  names  "` when Core flags a named opponent. Isolated `test_console` 1645/0. **Lane B22-A signed.**
- B22-B (HUD Morpheus names): `docs/reformation/vestments/briefs/B22-B-hud-font-review.md` Spec PASS. `nameA` / `nameB` `Fonts\\MORPHEUS.ttf`. Isolated `test_hud` 741/0. **Lane B22-B signed.** POLISH:CANDIDATE.
- B22-C (Markers player without count API): `docs/reformation/vestments/briefs/B22-C-markers-grouped-review.md` Spec PASS. Player token does not need `GetNumGroupMembers`. Isolated `test_markers` 349/0. **Lane B22-C signed.**
- B22-D (Dock ESC): `docs/reformation/vestments/briefs/B22-D-dock-esc-review.md` Spec PASS. `ChurchOfBeefConsoleDock` on `UISpecialFrames`. Isolated `test_console_dock` 233/0. **Lane B22-D signed.** POLISH:CANDIDATE.
- Integrator (B22-INT): no glue. Isolated lanes 1645/741/349/233. Glue **540/0**. Full harness **12064 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 23 verdicts

- B23-A (Theater owns cues): `docs/reformation/vestments/briefs/B23-A-after-cue-review.md` Spec PASS. `playCue` no-ops when `Toasts.Proclaim` exists. Isolated `test_console` 1693/0. **Lane B23-A signed.**
- B23-B (Dock ESC stay): `docs/reformation/vestments/briefs/B23-B-dock-dismiss-review.md` Spec PASS. OnHide dismiss until Show or QUIET. Isolated `test_console_dock` 280/0. **Lane B23-B signed.** POLISH:CANDIDATE.
- B23-C (Toast special re-register): `docs/reformation/vestments/briefs/B23-C-toast-special-review.md` Spec PASS. Init early-return `rememberSpecial`. Isolated `test_ui` 489/0. **Lane B23-C signed.** POLISH:CANDIDATE.
- B23-D (Empty player omit): `docs/reformation/vestments/briefs/B23-D-inputs-empty-player-review.md` Spec PASS. Trimmed empty player name omits opponent. Isolated `test_inputs` 756/0. **Lane B23-D signed.** POLISH:CANDIDATE.
- Integrator (B23-INT): no production glue. Legacy Sound-spy block nils Toasts under full harness (`do` block). Isolated lanes 1693/280/489/756. Glue **540/0**. Full harness **12245 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 24 verdicts

- B24-A (Recommendation lifetime): `docs/reformation/vestments/briefs/B24-A-rec-lifetime-review.md` Spec PASS. Clears on successful Start/End. Isolated `test_console` 1766/0. **Lane B24-A signed.**
- B24-B (Dock per-event dismiss): `docs/reformation/vestments/briefs/B24-B-dock-event-review.md` Spec PASS. Dismiss keyed to Runtime `eventId`. Isolated `test_console_dock` 314/0. **Lane B24-B signed.** POLISH:CANDIDATE.
- B24-C (Quiet shell ESC re-register): `docs/reformation/vestments/briefs/B24-C-shell-special-review.md` Spec PASS. Init early-return `rememberSpecial`. Isolated `test_ui` 507/0. **Lane B24-C signed.** POLISH:CANDIDATE.
- B24-D (Decree ESC re-register): `docs/reformation/vestments/briefs/B24-D-decree-special-review.md` Spec PASS. `ensureFrame` early-return `rememberSpecial`. Isolated `test_decree_ui` 265/0. **Lane B24-D signed.** POLISH:CANDIDATE.
- Integrator (B24-INT): no glue. Isolated lanes 1766/314/507/265. Glue **540/0**. Full harness **12385 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 25 verdicts

- B25-A (Selected Recommend): `docs/reformation/vestments/briefs/B25-A-rec-selected-review.md` Spec PASS. Store `namedOpponent` only when Recommend did not already have a selected pair. Isolated `test_console` 1841/0. **Lane B25-A signed.**
- B25-B (Empty Decree Show): `docs/reformation/vestments/briefs/B25-B-decree-show-review.md` Spec PASS. Empty `Show()` `ensureFrame`s then Hide. Isolated `test_decree_ui` 280/0. **Lane B25-B signed.** POLISH:CANDIDATE.
- B25-C (Records ESC remount): `docs/reformation/vestments/briefs/B25-C-records-special-review.md` Spec PASS. Init early-return `rememberSpecial`. Isolated `test_records` 453/0. **Lane B25-C signed.** POLISH:CANDIDATE.
- B25-D (HUD Refresh font): `docs/reformation/vestments/briefs/B25-D-hud-font-refresh-review.md` Spec PASS. `paintShown` re-applies `applyNameFont`. Isolated `test_hud` 747/0. **Lane B25-D signed.** POLISH:CANDIDATE.
- Integrator (B25-INT): no glue. Isolated lanes 1841/280/453/747. Glue **540/0**. Full harness **12500 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 26 verdicts

- B26-A (Selection lifetime): `docs/reformation/vestments/briefs/B26-A-sel-lifetime-review.md` Spec PASS. Successful Start/End also clear the selected pair. Isolated `test_console` 1922/0. **Lane B26-A signed.**
- B26-B (Toast OnHide remount): `docs/reformation/vestments/briefs/B26-B-toast-onhide-review.md` Spec PASS. Init early-return restores a missing OnHide. Isolated `test_ui` 528/0. **Lane B26-B signed.** POLISH:CANDIDATE.
- B26-C (Decree leftover wipe): `docs/reformation/vestments/briefs/B26-C-decree-wipe-review.md` Spec PASS. Empty Show blanks leftover Line/Flavor. Isolated `test_decree_ui` 302/0. **Lane B26-C signed.** POLISH:CANDIDATE.
- B26-D (Dock ESC remount): `docs/reformation/vestments/briefs/B26-D-dock-special-review.md` Spec PASS. Init remounts `rememberSpecial`. Isolated `test_console_dock` 353/0. **Lane B26-D signed.** POLISH:CANDIDATE.
- Integrator (B26-INT): no glue. Isolated lanes 1922/528/302/353. Glue **540/0**. Full harness **12654 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 27 verdicts

- B27-A (Console ESC remount): `docs/reformation/vestments/briefs/B27-A-console-special-review.md` Spec PASS. Init early-return `rememberSpecial`. Isolated `test_console` 1970/0. **Lane B27-A signed.**
- B27-B (Decree Hide wipe): `docs/reformation/vestments/briefs/B27-B-decree-hide-review.md` Spec PASS. Hide blanks leftover Line/Flavor when the Decree is gone. Isolated `test_decree_ui` 328/0. **Lane B27-B signed.** POLISH:CANDIDATE.
- B27-C (Quiet-shell OnHide): `docs/reformation/vestments/briefs/B27-C-shell-onhide-review.md` Spec PASS. Init early-return restores a missing OnHide. Isolated `test_ui` 548/0. **Lane B27-C signed.** POLISH:CANDIDATE.
- B27-D (Dock Refresh remount): `docs/reformation/vestments/briefs/B27-D-dock-refresh-review.md` Spec PASS. Refresh / Show remount `rememberSpecial`. Isolated `test_console_dock` 414/0. **Lane B27-D signed.** POLISH:CANDIDATE.
- Integrator (B27-INT): no glue. Isolated lanes 1970/548/328/414. Glue **540/0**. Full harness **12800 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 28 verdicts

- B28-A (Console Show remount): `docs/reformation/vestments/briefs/B28-A-console-show-review.md` Spec PASS. Show / Refresh remount `rememberSpecial`. Isolated `test_console` 2026/0. **Lane B28-A signed.**
- B28-B (Decree Refresh): `docs/reformation/vestments/briefs/B28-B-decree-refresh-review.md` Spec PASS. Refresh wipe+Hide when the line is gone. Isolated `test_decree_ui` 369/0. **Lane B28-B signed.** POLISH:CANDIDATE.
- B28-C (Records Hide remount): `docs/reformation/vestments/briefs/B28-C-records-hide-review.md` Spec PASS. Hide remounts ESC. Isolated `test_records` 487/0. **Lane B28-C signed.** POLISH:CANDIDATE.
- B28-D (Card OnHide remount): `docs/reformation/vestments/briefs/B28-D-card-onhide-review.md` Spec PASS. Init restores a missing OnHide. Isolated `test_fighter_card` 528/0. **Lane B28-D signed.** POLISH:CANDIDATE.
- Integrator (B28-INT): `wrapAlways` on `Decree:Clear` → `DecreeBanner:Refresh`. Isolated lanes 2026/369/487/528. Glue **552/0**. Full harness **12981 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 29 verdicts

- B29-A (Console Hide remount): `docs/reformation/vestments/briefs/B29-A-console-hide-review.md` Spec PASS. Hide / Toggle-hide remount `rememberSpecial`. Isolated `test_console` 2085/0. **Lane B29-A signed.**
- B29-B (Decree OnHide wipe): `docs/reformation/vestments/briefs/B29-B-decree-onhide-review.md` Spec PASS. Widget Hide after Clear blanks leftover Goldshire. Isolated `test_decree_ui` 427/0. **Lane B29-B signed.** POLISH:CANDIDATE.
- B29-C (Card Show OnHide): `docs/reformation/vestments/briefs/B29-C-card-show-onhide-review.md` Spec PASS. Show / Refresh restore a missing OnHide. Isolated `test_fighter_card` 574/0. **Lane B29-C signed.** POLISH:CANDIDATE.
- B29-D (Proclaim font): `docs/reformation/vestments/briefs/B29-D-toast-font-review.md` Spec PASS. Shown-beat Proclaim re-applies Morpheus. Isolated `test_ui` 558/0. **Lane B29-D signed.** POLISH:CANDIDATE.
- Integrator (B29-INT): no glue. Isolated lanes 2085/427/574/558. Glue **552/0**. Full harness **13150 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 30 verdicts

- B30-A (Decree remount OnHide): `docs/reformation/vestments/briefs/B30-A-decree-remount-review.md` Spec PASS. `ensureFrame` remounts a missing OnHide. Isolated `test_decree_ui` 494/0. **Lane B30-A signed.** POLISH:CANDIDATE.
- B30-B (Card Hide OnHide): `docs/reformation/vestments/briefs/B30-B-card-hide-onhide-review.md` Spec PASS. Hide remounts a missing OnHide. Isolated `test_fighter_card` 613/0. **Lane B30-B signed.** POLISH:CANDIDATE.
- B30-C (Records paint font): `docs/reformation/vestments/briefs/B30-C-records-font-review.md` Spec PASS. `paint()` re-applies Morpheus on PageTitle. Isolated `test_records` 511/0. **Lane B30-C signed.** POLISH:CANDIDATE.
- B30-D (Dock Hide remount): `docs/reformation/vestments/briefs/B30-D-dock-hide-review.md` Spec PASS. Hide remounts `rememberSpecial`. Isolated `test_console_dock` 476/0. **Lane B30-D signed.** POLISH:CANDIDATE.
- Integrator (B30-INT): no glue. Isolated lanes 494/613/511/476. Glue **552/0**. Full harness **13337 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 31 verdicts

- B31-A (QUIET Recommend drop): `docs/reformation/vestments/briefs/B31-A-quiet-recommend-review.md` Spec PASS. Refresh in QUIET nils `lastRecommendation`. Isolated `test_console` 2145/0. **Lane B31-A signed.**
- B31-B (Decree Hide OnHide): `docs/reformation/vestments/briefs/B31-B-decree-hide-onhide-review.md` Spec PASS. Hide remounts a missing OnHide. Isolated `test_decree_ui` 565/0. **Lane B31-B signed.** POLISH:CANDIDATE.
- B31-C (Quiet-shell Show OnHide): `docs/reformation/vestments/briefs/B31-C-shell-show-onhide-review.md` Spec PASS. Show remounts a missing OnHide. Isolated `test_ui` 582/0. **Lane B31-C signed.** POLISH:CANDIDATE.
- B31-D (Records title font): `docs/reformation/vestments/briefs/B31-D-records-title-review.md` Spec PASS. `paint()` re-applies Morpheus on TitleText. Isolated `test_records` 536/0. **Lane B31-D signed.** POLISH:CANDIDATE.
- Integrator (B31-INT): `afterEndEvent` Refreshs Console (Pope-local; no send). Isolated lanes 2145/565/582/536. Glue **561/0**. Full harness **13522 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 32 verdicts

- B32-A (HUD lastPair forget): `docs/reformation/vestments/briefs/B32-A-hud-forget-review.md` Spec PASS. Non-Gora hide forgets lastPair. Isolated `test_hud` 764/0. **Lane B32-A signed.** POLISH:CANDIDATE.
- B32-B (Console confession Dismiss): `docs/reformation/vestments/briefs/B32-B-console-dismiss-review.md` Spec PASS. Dismiss also reaches `Confession:Dismiss`. Isolated `test_console` 2220/0. **Lane B32-B signed.**
- B32-C (called reset): `docs/reformation/vestments/briefs/B32-C-called-reset-review.md` Spec PASS. Latest Receive clears `called`. Isolated `test_confession` 184/0. **Lane B32-C signed.**
- B32-D (marker clear-prior): `docs/reformation/vestments/briefs/B32-D-marker-prior-review.md` Spec PASS. New Mark* clears the previous unit. Isolated `test_markers` 438/0. **Lane B32-D signed.** POLISH:CANDIDATE.
- Integrator (B32-INT): `refreshEventFurniture` Refreshs Hud (skip inspect). Isolated lanes 764/2220/184/438. Glue **571/0**. Full harness **13735 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 33 verdicts

- B33-A (Inputs dest trim): `docs/reformation/vestments/briefs/B33-A-inputs-dest-review.md` Spec PASS. `SetInputTarget` trims dest. Isolated `test_inputs` 848/0. **Lane B33-A signed.**
- B33-B (Presence here dim): `docs/reformation/vestments/briefs/B33-B-presence-here-review.md` Spec PASS. Fail-open rows `SetAlpha(0.45)`. Isolated `test_console` 2297/0. **Lane B33-B signed.**
- B33-C (Markers keep-last): `docs/reformation/vestments/briefs/B33-C-markers-keep-review.md` Spec PASS. Gate refuse keeps remembered units. Isolated `test_markers` 491/0. **Lane B33-C signed.**
- B33-D (BeefNet dest refuse): `docs/reformation/vestments/briefs/B33-D-net-dest-review.md` Spec PASS. Whitespace dest is `"no target"`. Isolated `test_net_v2` 632/0. **Lane B33-D signed.**
- Integrator (B33-INT): no glue. Isolated lanes 848/2297/491/632. Glue **571/0**. Full harness **14023 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 34 verdicts

- B34-A (HUD re-tint): `docs/reformation/vestments/briefs/B34-A-hud-tint-review.md` Spec PASS. `paintShown` re-tints names after `applyNameFont`. Isolated `test_hud` 779/0. **Lane B34-A signed.** POLISH:CANDIDATE.
- B34-B (leftover Presence alpha): `docs/reformation/vestments/briefs/B34-B-presence-alpha-review.md` Spec PASS. Hidden leftover Presence buttons `SetAlpha(1)`. Isolated `test_console` 2398/0. **Lane B34-B signed.**
- B34-C (Target keep-last): `docs/reformation/vestments/briefs/B34-C-target-keep-review.md` Spec PASS. Successful Target keeps omitted mark units. Isolated `test_markers` 543/0. **Lane B34-C signed.**
- B34-D (SendSnapshot dest): `docs/reformation/vestments/briefs/B34-D-snapshot-dest-review.md` Spec PASS. Pope-gated `SendSnapshot` dest-trims before encode. Isolated `test_net_v2` 682/0. **Lane B34-D signed.**
- Integrator (B34-INT): no glue. Isolated lanes 779/2398/543/682. Glue **571/0**. Full harness **14232 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 35 verdicts

- B35-A (HUD defense width): `docs/reformation/vestments/briefs/B35-A-defense-width-review.md` Spec PASS. Defense labels `SetWidth(28)`. Isolated `test_hud` 814/0. **Lane B35-A signed.** POLISH:CANDIDATE.
- B35-B (Confess trim): `docs/reformation/vestments/briefs/B35-B-confess-trim-review.md` Spec PASS. Optional confess text is trimmed; empty omits. Isolated `test_inputs` 937/0. **Lane B35-B signed.**
- B35-C (Target name keep): `docs/reformation/vestments/briefs/B35-C-target-names-review.md` Spec PASS. `keepLastUnits` keeps omitted fighter names. Isolated `test_markers` 563/0. **Lane B35-C signed.**
- B35-D (shell Hide persist): `docs/reformation/vestments/briefs/B35-D-shell-hide-review.md` Spec PASS. Existing-frame Hide remounts OnHide + persist. Isolated `test_ui` 607/0. **Lane B35-D signed.**
- Integrator (B35-INT): no glue. Isolated lanes 814/937/563/607. Glue **571/0**. Full harness **14395 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 36 verdicts

- B36-A (SendConfession trim): `docs/reformation/vestments/briefs/B36-A-confess-trim-review.md` Spec PASS. Optional confess text is trimmed on the wire. Isolated `test_net_v2` 727/0. **Lane B36-A signed.**
- B36-B (End selection): `docs/reformation/vestments/briefs/B36-B-end-select-review.md` Spec PASS. EndEvent nils leftover human / character selection. Isolated `test_console` 2490/0. **Lane B36-B signed.**
- B36-C (dock OnHide): `docs/reformation/vestments/briefs/B36-C-dock-onhide-review.md` Spec PASS. Existing-frame Hide remounts missing OnHide. Isolated `test_console_dock` 563/0. **Lane B36-C signed.**
- B36-D (Decree ESC list): `docs/reformation/vestments/briefs/B36-D-decree-special-review.md` Spec PASS. Hide remounts `ChurchOfBeefDecree` on `UISpecialFrames`. Isolated `test_decree_ui` 615/0. **Lane B36-D signed.**
- Integrator (B36-INT): no glue. Isolated lanes 727/2490/563/615. Glue **571/0**. Full harness **14655 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 37 verdicts

- B37-A (Dismiss pick): `docs/reformation/vestments/briefs/B37-A-dismiss-pick-review.md` Spec PASS. Successful Dismiss nils leftover character pick. Isolated `test_console` 2573/0. **Lane B37-A signed.**
- B37-B (Quiet favor forget): `docs/reformation/vestments/briefs/B37-B-favor-forget-review.md` Spec PASS. `forgetPersist` nils leftover congregation favor. Isolated `test_hud` 854/0. **Lane B37-B signed.**
- B37-C (card ESC list): `docs/reformation/vestments/briefs/B37-C-card-special-review.md` Spec PASS. Hide remounts `ChurchOfBeefFighterCard` on `UISpecialFrames`. Isolated `test_fighter_card` 660/0. **Lane B37-C signed.**
- B37-D (confess wipe): `docs/reformation/vestments/briefs/B37-D-confess-wipe-review.md` Spec PASS. Quiet Hide blanks leftover confess text. Isolated `test_inputs` 995/0. **Lane B37-D signed.**
- Integrator (B37-INT): no glue. Isolated lanes 2573/854/660/995. Glue **571/0**. Full harness **14873 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 38 verdicts

- B38-A (Dismiss pair): `docs/reformation/vestments/briefs/B38-A-dismiss-pair-review.md` Spec PASS. Successful Dismiss of A or B nils leftover pair + Recommend. Isolated `test_console` 2674/0. **Lane B38-A signed.**
- B38-B (Gora last overlay): `docs/reformation/vestments/briefs/B38-B-gora-last-review.md` Spec PASS. SNAPSHOT last-pair overlay is Gora CONSEQUENCE only. Isolated `test_net_snapshot` 826/0. **Lane B38-B signed.**
- B38-C (mark Forget): `docs/reformation/vestments/briefs/B38-C-mark-forget-review.md` Spec PASS. Quiet `Forget` sweeps leftover raid marks. Isolated `test_markers` 634/0. **Lane B38-C signed.**
- B38-D (Records OnHide): `docs/reformation/vestments/briefs/B38-D-records-onhide-review.md` Spec PASS. Existing-frame Hide remounts missing OnHide. Isolated `test_records` 620/0. **Lane B38-D signed.**
- Integrator (B38-INT): `afterEndEvent` pcalls `Markers:Forget` (skip inspect). Isolated lanes 2674/826/634/620. Glue **602/0**. Full harness **15177 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 39 verdicts

- B39-A (OpenRite last): `docs/reformation/vestments/briefs/B39-A-openrite-last-review.md` Spec PASS. OpenRite Gora does not fall back to `GetLastSanctioned`. Isolated `test_console` 2798/0. **Lane B39-A signed.**
- B39-B (card remember): `docs/reformation/vestments/briefs/B39-B-card-remember-review.md` Spec PASS. Show / Refresh remount `ChurchOfBeefFighterCard`. Isolated `test_fighter_card` 731/0. **Lane B39-B signed.**
- B39-C (toast HideAll): `docs/reformation/vestments/briefs/B39-C-toast-hideall-review.md` Spec PASS. HideAll remounts toast + proclaim ESC names. Isolated `test_ui` 621/0. **Lane B39-C signed.**
- B39-D (dock Show OnHide): `docs/reformation/vestments/briefs/B39-D-dock-show-onhide-review.md` Spec PASS. Show remounts missing OnHide. Isolated `test_console_dock` 630/0. **Lane B39-D signed.**
- Integrator (B39-INT): live STATE last-pair overlay is Gora-only. Isolated lanes 2798/731/621/630. Glue **627/0**. Full harness **15466 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 40 verdicts

- B40-A (Console OnHide): `docs/reformation/vestments/briefs/B40-A-console-onhide-review.md` Spec PASS. Hide remounts missing OnHide. Isolated `test_console` 2930/0. **Lane B40-A signed.**
- B40-B (Records Show OnHide): `docs/reformation/vestments/briefs/B40-B-records-show-onhide-review.md` Spec PASS. Show remounts missing OnHide. Isolated `test_records` 682/0. **Lane B40-B signed.**
- B40-C (dock Refresh OnHide): `docs/reformation/vestments/briefs/B40-C-dock-refresh-onhide-review.md` Spec PASS. Refresh remounts missing OnHide. Isolated `test_console_dock` 702/0. **Lane B40-C signed.**
- B40-D (already-hidden persist): `docs/reformation/vestments/briefs/B40-D-shell-hidden-persist-review.md` Spec PASS. Already-hidden Hide writes `shown = false`. Isolated `test_ui` 642/0. **Lane B40-D signed.**
- Integrator (B40-INT): no glue. Isolated lanes 2930/682/702/642. Glue **627/0**. Full harness **15739 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Batch 41 verdicts

- B41-A (Console Refresh OnHide): `docs/reformation/vestments/briefs/B41-A-console-refresh-onhide-review.md` Spec PASS. Refresh remounts missing OnHide. Isolated `test_console` 3045/0. **Lane B41-A signed.**
- B41-B (Records Init OnHide): `docs/reformation/vestments/briefs/B41-B-records-init-onhide-review.md` Spec PASS. Init remounts missing OnHide. Isolated `test_records` 744/0. **Lane B41-B signed.**
- B41-C (dock Init OnHide): `docs/reformation/vestments/briefs/B41-C-dock-init-onhide-review.md` Spec PASS. Init remounts missing OnHide. Isolated `test_console_dock` 775/0. **Lane B41-C signed.**
- B41-D (toast Init proclaim): `docs/reformation/vestments/briefs/B41-D-toast-init-proclaim-review.md` Spec PASS. Init remounts `ChurchOfBeefProclaim`. Isolated `test_ui` 664/0. **Lane B41-D signed.**
- Integrator (B41-INT): no glue. Isolated lanes 3045/744/775/664. Glue **627/0**. Full harness **15997 passed, 0 failed**. **Gate W stays OPEN.** **Gate V stays OPEN.** **Do not claim POLISH:PASS.**

### Pope list (David, 2026-08-18)

David named the Pope character **Thedave**. `Data/Popes.lua` `LIST = { "Thedave" }`. `tests/test_sender.lua` pins the shipped name; Beefina and other unlisted names stay refuse. Do not invent more names. **Gate W stays OPEN.** **Gate V stays OPEN.**

## UI Overhaul wave

**Status:** OPEN  
**Branch:** `reformation/phase-1-excision` (uncommitted working tree; no commit unless David asks)  
**Cited:** `docs/reformation/MASTER_UI_OVERHAUL_PROMPT_2026-08-18.md`; critique pack Batches 1–4; `docs/design/Asset_Production_Spec_2026-08-18.md`; Bible §10.6–10.8, §18, §19, §20; Laws 1, 4, 6, 10.  
**Step 0 (2026-08-18):** Wire lanes W-A…W-F signed — dress lanes open. Harness green at **16,006 passed, 0 failed**. Four keeper renders placed in `docs/design/renders/` (`R10-seals`, `rise-beef-knight`, `R3-fightercard`, `victor-declared`); the Quiet-mode dock render was discarded per Batch 4 §3. Five keepers (`R2-hud`, `R8-console-v3`, `R4-cowardice`, `decree`, `records-tome`) remain David's export. David licensed building all lanes immediately in stock materials: Theme's per-name stock fallback table is curated from existing WoW UI art so every surface lays out today and becomes the render as `Media/` assets land.

| Lane | Owns | When |
|------|------|------|
| U-A | `Core/Common.lua`, `tests/test_common.lua` | now |
| U-B | `UI/Theme.lua`, `tests/test_theme.lua`, `Media/Fonts/**` | now |
| U-C | `scripts/import-assets.py`, `docs/design/renders/ASSET_LOG.md`, `Media/manifest.lua` (generated) | now |
| U-D | `UI/Toasts.lua`, `tests/test_ui.lua` | after U-A, U-B |
| U-E | `UI/Hud.lua`, `tests/test_hud.lua` | after U-A, U-B |
| U-F | `UI/FighterCard.lua`, `tests/test_fighter_card.lua` | after U-A, U-B |
| U-G | `UI/Decree.lua`, `tests/test_decree_ui.lua` | after U-A, U-B |
| U-H | `UI/RecordsBook.lua`, `tests/test_records.lua` | after U-A, U-B |
| U-I | `UI/Console.lua`, `tests/test_console.lua` (audit covers `UI/ConsoleDock.lua`) | after U-A, U-B |
| U-J | `UI/Minimap.lua`, `tests/test_minimap.lua` | after U-B |

Writers do not commit and do not edit TOC / `ChurchOfBeef.lua` / `tests/run.lua` / `OPEN_QUESTIONS.md` / this log. Integrator owns TOC (`UI\Theme.lua`, `Media\manifest.lua`), `tests/run.lua` (`test_common`, `test_theme`), bootstrap glue, cross-lane conflicts. **Gate U** closes on David's in-client screenshot pass per surface, not on green tests. POLISH:CANDIDATE at most.

### Verdicts

- U-A ([Roman numerals](0dfb4711-d483-4fab-95d3-ca2e8614627c)): writer DONE. [Review](d9f5d690-b0a8-4f34-9563-c0ca3f0696a2): Spec PASS; Quality Approved. `COB.Common.RomanNumeral` (1–3999 subtractive; `nil, "out of range"` otherwise) and `COB.Common.RomanPair` (en dash U+2013) on a new `COB.Common` table; Names/Clock/Group unchanged. Reviewer hand-probed 44/99/444/999/3888 — no IIII/VIV. Isolated 40/0. Integrator listed `test_common`. Full harness **16046 passed, 0 failed**. **Lane U-A signed.**
- U-B ([Theme + fonts](eda7f551-7659-43e4-83fc-c1961eae6fa1)): writer DONE. [Review](1d371945-cb9d-4643-a63b-ef3918d5e983): Spec PASS; Quality Approved-with-nits. `COB.Theme`: 7 palette tokens (exact /255 math verified), `Color` / `ClassColor` (RAID_CLASS_COLORS passthrough only), `FontPath` (display/label/body; stock MORPHEUS/FRIZQT fallback), `FontSize`, `Texture(name)` (manifest → curated stock → nil; 39 names, 18 unique paths, zero faction/skull/class-icon hits, all FrameXML-cited). OFL families on disk with licenses: UnifrakturMaguntia (static; display default), Grenze Gotisch (variable), EB Garamond (variable; label/body default), Alegreya (variable). Nits riding: variable-font SetFont risk on 20506 until David's 16/22/30px pick; test guards walk a duplicated name list; empty-string fallback pinned for display only. Isolated 168/0. Integrator listed `UI\Theme.lua` (TOC) + `test_theme` + Theme in the run.lua preamble. Full harness **16214 passed, 0 failed**. **Lane U-B signed.**
- U-C ([asset pipeline](4c99f204-6b0e-4241-a05d-a4d18a9fdd8e)): writer DONE. [Review](5a3b1362-3132-44c6-9dc5-1f4362c3e136): Spec PASS; Quality Changes required → integrator fixed both Importants. (1) Corrupt/0-byte masters aborted the batch — per-file try/except now fails that file, continues, exits 1; selftest locks it. (2) Theme-key contract — hyphens normalize to underscores (`corner-TL` → `corner_tl`); `KEY_ALIASES` produce the non-category Theme keys (`banner_knighting`, `rays_sunburst`, `tome_records`, `ribbon_bookmark`, `plate_verb*`) from canonical category-prefixed filenames; INVENTORY gained `frame_proclamation_pin` (64²) and `ornament_bullhorn` (512×128); README documents the Theme-name table, reserved suffixes, Pillow, selftest. Selftest PASS (incl. corrupt-batch, alias, hyphen probes); empty run writes a valid empty manifest; prune blast radius verified limited to tracked category TGAs (Fonts untouched). Integrator listed `Media\manifest.lua` in the TOC before `UI\Theme.lua`. Full harness **16228 passed, 0 failed**. **Lane U-C signed.**
- U-J ([Minimap roundel](09525b38-c9bb-4889-93e6-951b8330c227)): writer DONE. [Review](3c16c109-0f98-4180-93ab-abde393a877f): Spec PASS; Quality Approved-with-nits. Icon/highlight/pushed route through `Theme:Texture` (`roundel_minimap` / `roundel_minimap_highlight` / `roundel_minimap_pushed`) — the steak icon is gone; tracking border stays stock chrome; click/drag/tooltip/SV/Quiet behavior untouched. Nits riding: no Theme-nil Init pin; pushed texture is new vs HEAD (visual only); steak-gone pin is weakly shaped. Isolated test_minimap 106/0 (was 92). Concurrent-lane reds in the full run did not involve Minimap. **Lane U-J signed.** POLISH:CANDIDATE.
- U-H ([RecordsBook tome](7a42df37-f5ae-4121-919a-d6127be00439)): writer DONE. [Review](701fd889-c5e7-4e9b-b3dd-d3eabbc98fbf): Spec PASS; Quality Approved-with-nits. Tome dress Theme-routed: `tome_records` parchment, `seal_papal` medallion pool (8, created once — no per-paint rebuild), `ribbon_bookmark` nav, label/body font roles (page titles are NOT blackletter — typography rule held), oxblood page title / charcoal ink / gold chrome via Theme. Local `ROMAN_MAP` dead; `RecordsBook.toRoman` wraps `Common.RomanNumeral` preserving the `""`-on-invalid contract. Citations still render only from store fields. Nits riding: leftover Morpheus comments in tests; paint re-dresses medallion slots; drag persist untested (pre-existing hole). Isolated 831/0. Full harness **16748 passed, 0 failed** (twice). **Lane U-H signed.** POLISH:CANDIDATE.
- U-G ([Decree dress](8fd258fe-23f4-4541-b7c8-cb43fb76c975)): writer DONE. [Review](da47981b-d28d-4978-b764-e66b789e804a): Spec PASS; Quality Approved-with-nits. Decree line is the blackletter headline (`FontPath("display")` at headline 22, charcoal ink); header/church name label-role gold by the `seal_papal` seal; `parchment_decree` body; four `ornament_nail` studs (TR inset clears Close). Copy byte-identical ("A GATHERING HAS BEEN DECREED" / "Church of Beef"). Quiet contract, login-once, minimap replay, ESC, wipe-on-clear, drag persist, Close all green. Nits riding: extra GoldRule chrome strip; alpha args not tokenized; FontSize fallback 16. Isolated 679/0; test_minimap 106/0 and test_decree 129/0 held. Full harness **16748 passed, 0 failed** (twice). **Lane U-G signed.** POLISH:CANDIDATE.
- U-F ([FighterCard dress](567bfe46-cd09-4b83-a7be-bd7fbe1079f6)): writer DONE. [Review](c17301ac-81cb-4bf3-beb4-d006c65b6163): Spec PASS; Quality Approved-with-nits → integrator fixed the one Important (both-nonzero RomanPair path was implemented but unpinned — added the III–II / II–III / H2H III–II bout-history pin; view model stays numeric). Card re-dressed per R3: `ornament_bullhorn` header, blackletter names via Theme display ≥16, serif ledger (Record/Defenses/Head-to-head/Stipulation + glyph slots), `seal_papal`, left-third dock, no close chrome. Roman paint via Common with the documented nulla fork: `RomanNumeral`/`RomanPair` refuse 0, so a zero side paints "N" (en dash U+2013, same bytes as Common). ESC/persist/lastPair/honorific/defenses-hide pins all green. Nits riding: single centered bullhorn (not paired horns); seal bottom-center; goldRule strip extra; level stays arabic. Isolated 797/0 → 819/0 with the integrator pin. Full harness **16770 passed, 0 failed**. **Lane U-F signed.** POLISH:CANDIDATE.
- U-D ([Toasts beats](8adcfc4f-1ccd-4c5a-8b0d-d4027da02158)): writer DONE. [Review](5e5fba60-b8e3-4a44-9698-b84db28a81a9): Spec PASS; Quality Approved-with-nits. Four beats dressed via Theme only: SANCTION (9-slice `frame_proclamation_*` + `seal_papal`), VICTOR (`seal_victor` + gold), COWARDICE (`seal_cowardice` + oxblood), KNIGHTING/ELEVATION (`banner_knighting` + additive `rays_sunburst` behind the panel). Copy byte-verified: B9-D chat echo "Victor declared: <name>. So ruled by the Beef Pope." intact; panel shows "VICTOR DECLARED" + "<name>. So ruled by the Beef Pope."; cowardice/knighting/elevation/sanction/void/free lines unchanged. Dim 0.45, center-third, no close chrome, ESC, §19.4 cue calls, Quiet gate, queue engine untouched. Nits riding: small-toast backdrop borrows theatrical Theme keys (no functional fill token exists); numeric font-size fallbacks 22/12; PANEL_FALLBACK_W 420. Isolated test_ui grew 135 → 701 asserts. Full harness **16748 passed, 0 failed** (twice). **Lane U-D signed.** POLISH:CANDIDATE.
- U-I ([Console audit + plates](e184ffc4-12da-4696-9c5c-087bf56e718a)): writer DONE. [Review](5bb8c809-ebad-49e1-a412-6129a89eb206): Spec PASS; Quality Approved-with-nits. Ornament census clean: title-bar `seal_papal` (20px) + `plate_verb`/`_hover`/`_pressed` on exactly SANCTION BEEF GORA, KNIGHT THIS BEEF, and the dock SANCTION — every other button stock. No SendChatMessage/whisper/announce; SKIP and secondaries untinted stock gray (red means nothing); petitioner cards keep the mute arabic H2H (`1-0`); dock gated event-live AND registered-Pope, titled DIRECTOR CONSOLE; the last color literal (0.08 bg) now Theme charcoal. Arabic numerals kept. Nits riding: working-tree diff is large from accumulated desk work (not ornament creep); plates render stock until iron art lands; tooltip-background stock path left as furniture. Isolated console 3158/0, dock 814/0. Full harness **16748 passed, 0 failed** (twice). **Lane U-I signed.**
- U-E ([HUD dress](70a0d34b-9b5d-4d99-8e2f-30baf7e25a3e)): writer DONE. [Review](32b65226-45f9-489b-9a01-7a70772c238f): Spec PASS; Quality Approved-with-nits. HUD-B structure: `Name · Level · Title · Class` format line (label serif, empty parts omitted), blackletter names ≥16 with class tint via Theme:ClassColor, class-tinted `bar_stainedglass_fill` mute rails, `sigil_gora` crest (never a faction crest), `bar_favor_fill` + `sigil_favor` on the labeled FAVOR gauge with outboard arabic percentages, parchment name fields via `frame_proclamation_center`, ≤12% height, movable. Roman tallies via Common with the same nulla convention as the card ("N–N"/"I–N", en dash U+2013); favor stays arabic; GetView stays numeric. W-F favor gates, plate-click rules, lastPair memory, verdict persist, QUIET exit — all behavior pins audited intact. Nits riding: Hud's romanGlyph helper differs in shape from the card's (painted output matches); hidden level FontStrings rewritten every paint. Isolated 894/0. Full harness **16748 passed, 0 failed** (twice). **Lane U-E signed.** POLISH:CANDIDATE.

### Gate U status

- **Gate U: OPEN — items 1–4 PASS; item 5 (David's in-client screenshot pass) is the close.**
  1. All eleven lanes signed (U-A…U-J + integrator): writers + adversarial reviews + integrator Important fixes (U-C batch resilience + Theme-key contract; U-F both-nonzero roman pin).
  2. Full harness green: **16770 passed, 0 failed** (`lua tests/run.lua`, exit 0). No skipped-as-red suites.
  3. Conformance grep, **0 Criticals**: no hardcoded `Media/` or font paths outside Theme; no color literals on surfaces (integrator excised the dead `UI.Palette` literal table from MainFrame — its only live consumer was the shell hairline, now Theme gold — and routed Inputs' `0.08` ground through Theme charcoal); no prose/qualifier strings; no faction-crest references; no invented ranks (only the "No Beef Prophet" law comment); console carries only the title seal + verb plates (U-I census); QUIET renders minimap + Decree only (MODE declarations verified; Records Book is player-opened §14.2). Benign: BeefNet throttle-delay number table (timing, not color); stock tooltip-background furniture on functional surfaces.
  4. Fresh-context ([Gate U](227edfc4-3546-44ba-814f-a403a5bb7b5b)): **GATE_U_FRESH_CONTEXT: PASS.** Bible + Ten Laws + shipped code only. Named the product (ceremony, sanctioned Gora, memory — not a points ladder) and the hybrid visual law (Theme on theater, stock on desks), cited the palette semantics, typography rule, and roman/arabic split. Zero Ten-Law contradictions.
  5. **David's in-client screenshot pass — the wave closes on his acceptance**, surface by surface vs the REFERENCE renders in `docs/design/renders/`. POLISH:CANDIDATE at most until then.
  6. This verdict. No commit (David has not asked; wave-boundary commit question comes at gate close).

### Typography lock (David delegated the pick; revised after stream-size preview, 2026-08-20)

- **display = Grenze Gotisch Regular** (`GrenzeGotisch-Regular.ttf`, static OFL instance). The deterministic 1024×768 preview showed that Unifraktur's dense capitals lost too much information at the 18–22px stream floor; Grenze retains the ecclesiastical voice with materially clearer word shapes.
- **label/body = EB Garamond Regular** (`EBGaramond-Regular.ttf`, static OFL instance). The book-serif read remains the ledger-surface default. Alegreya stays on disk as the alternate.
- Both alternates remain under `Media/Fonts/` with OFL licenses; a swap is a one-line `SHIPPED_FONTS` edit in `UI/Theme.lua`. If David's in-client look disagrees, the pick revisits — this is a decision, not a gate.

### Legibility audit (David's in-client report, 2026-08-18)

David's first in-client look: "still VERY far away from actually being legible." He asked for agents to review with eyes before ship. Two responses:

1. **Contrast math (WCAG relative luminance, computed):** the failures are structural, not taste. Class colors on the fighter card's parchment plates run **1.17:1–3.33:1** (Hunter 1.17 — near-invisible). Gold small text on parchment is **1.62:1** (Decree header/church name). Silver on parchment 2.04:1. Meanwhile class colors on the HUD's dark iron run 3.13:1–15:1 (fine), and charcoal/iron ink on parchment is 10.4–12:1. Fixes must move fighter names onto dark grounds (or confine class tint to accents on parchment) and take small gold text off parchment.
2. **Lane U-L (orchestrator-added):** offline preview renderer — harness scene dump (`tests/preview_dump.lua`) → Pillow compositor (`scripts/render-preview.py`) → PNGs in `docs/design/renders/preview/` that agents read with image tools before any human screenshot. Not pixel-faithful to the WoW rasterizer; covers the legibility class (contrast, size floors, overflow, busy-ground-behind-text).

- U-L ([preview renderer](5c75f2e6-b9f6-4f45-930a-1a6a04b0f759)): writer DONE. [Review](3bc004ab-1743-4a77-a731-33dc0613c850): Spec PASS; Quality Approved-with-nits → integrator fixed the one Important (compositor defaulted uncolored GameFont strings to parchment; they now inherit stock template colors — GameFont* gold, GameFontHighlight* white — so the HUD favor row can't be mis-scored as invisible). 11 scenario JSONs + theme.json, 11 PNGs + contact sheet, deterministic, real shipped TTFs for Theme roles, no Blizzard font downloads, stub changes record-only. Harness **16774 passed, 0 failed**. Nits riding: live-after-set stub getters; subLayer not z-sorted; texcoords not cropped. Preview dir gitignored (generated artifacts). **Lane U-L signed.**
- Orchestrator review of the first previews confirmed the audit and added one finding: the HUD chassis paints a near-full QuestBG slab (cream), so class-tinted/silver text on it fails the ink discipline — folded into the U-M legibility lane as a required chassis fix (dark iron bar per HUD-B).
- U-M ([legibility fixes](e9021ccd-c776-4cf4-b820-b78aaf4c30e3)): writer DONE. [Review](1b2c8687-34c2-4228-bfc6-c752c63be56e): Spec PASS; Quality Approved-with-nits. Ink discipline applied: FighterCard plates carry class-tinted blackletter names on dark charcoal header bands (gold hairline), ledger all-charcoal; HUD chassis is dark iron (QuestBG slab gone dark), one class-tinted serif name per fighter (label role — blackletter fighter names live on the card), dark name fields, format line carries `Level · Title · Class`; Decree header/church/Close charcoal (the blackletter decree line was already legible, untouched); Records ribbons/Prev/Next/Close are dark plates with gold text, chrome title gold on a charcoal band, page-title oxblood rubrication kept. Toasts audited clean, no edit. Orchestrator read the after-renders: all four surfaces pass. Integrator nit fix: HUD favor percents silver → parchment (5.1:1 → 10.4:1; they carry live information). Nits riding: hidden QuestBG slot remains as an art drop target (nothing shows it); Decree Close cramped at 20×20. Harness **16795 passed, 0 failed** (twice + after the percent fix). **Lane U-M signed.** POLISH:CANDIDATE.

### Wave-boundary commit (David asked, 2026-08-18)

`41d2da6` — "feat: UI Overhaul wave — Theme design system, dressed theater, plain console" on `reformation/phase-1-excision`. Lands the UI Overhaul wave plus the previously uncommitted Wire + Vestments work (the tree had been uncommitted since Phase 0). Gate U stays OPEN for David's in-client screenshot pass; Gate W stays OPEN for his two-client smoke; Gate 6 stays OPEN for A01–A04.

### U-N Tightness (David: "still incredibly loose", 2026-08-18)

The token/ink wave dressed colors. It did not compose. `/beef` (Records Book) and Event theater still read as prototype boxes: 8px-tiled QuestBG, bag-slot seals, 1px leftover rules, and — the load-bearing bug — **variable TTFs with `[wght]` in the filename**. Anniversary `SetFont` does not reliably load those; every label/body string fell back to Friz.

- Theme now ships **static Regular** (`EBGaramond-Regular.ttf`, plus Alegreya/Grenze Regular instances). `Theme.Space` is the 4/8/16/24/2/48/40 rhythm.
- Geometric placeholders generated via `scripts/make-geometry-placeholders.py` → `import-assets.py` (gold-ring seals, iron nails, parchment fields, engraved glyphs). Manifest 29 entries. Not ChatGPT art — honest geometry until masters land.
- Records Book: title band / two leaves / footer tabs. Page title lives on the left leaf. Medallions stride with the body.
- Fighter card: stacked A-over-B tape (R3 is one fighter; both sit in one left-third ledger), fallback height 360.
- HUD: 2px class rails, no 8px tile, format line does not wrap onto the favor row.
- Decree/Toasts: 8px nail / 12px proclamation inset.

Harness **16804 passed, 0 failed** at the composition cut (recount after the wrap fixes). Gate U item 5 still David's screenshot pass. POLISH:CANDIDATE.

### U-O Console IA (David: "Beef console is very busy and not intuitive", 2026-08-18)

The Director Console was one 780×1050 dump of every Pope verb at equal weight. Law 10 stays: stock desk, no parchment, no Blizzard tab strip.

- Phase strip follows Runtime: QUIET shows **Start Event**; ASSEMBLY shows the four Open rites plus **End Event** (right-aligned, not under Knighting); RITE shows **Close Rite**; CONSEQUENCE shows **Continue** / **End Event**. Mute `Next:` hint names the decision.
- Gora verdict plates (DECLARE VICTOR / COWARDICE / VOID / FREE RULING) Show only during a Gora RITE or CONSEQUENCE.
- ARCHIVE / CANONIZE / Recognition / Decree / GRANT HONORIFIC sit on a stock **Records & archive** fold (default hidden). Presence, Knighting, Gora, Confession, CeremonyLog, and MARK THIS MOMENT stay on the ceremony desk. Widgets stay created.

Harness **16870 passed, 0 failed**. Gate U item 5 still David's screenshot pass. POLISH:CANDIDATE.

### U-P Parallel surface pass (David asked for a swarm, 2026-08-18)

Eight exclusive-file writers plus sixteen read-only critics. Integrator kept roman W–L on the fighter card (theater), two-line Decree wrap, parchment fills under Records leaves, and filed Presence “here” as OPEN_QUESTIONS #13. Do not invent an online bit.

Harness **16909 passed, 0 failed**. Gate U item 5 still David's screenshot pass. POLISH:CANDIDATE.

### U-Q Legibility swarm (David asked to continue, 2026-08-19)

Theme caption floor is 12. Exclusive writers plus critics: charcoal/iron on parchment, class/gold on dark only, leftover 6/10/14 onto Theme.Space where unpinned, Petitions labeled, dock mute refuse, HUD format width, Decree Close 24×24. Presence “here” stays OPEN_QUESTIONS #13. `Toasts:Show` stays ungated (harness). Congregation Proclaim fan-out not invented.

Harness **17496 passed, 0 failed**. Gate U item 5 still David's screenshot pass. POLISH:CANDIDATE.

### U-R Navigation + layout-responsive (David: finish a named goal, 2026-08-19)

Named goal: every player-facing surface is clear to scan, easy to navigate, and layout-responsive (clamp, guest `uiScale`, wrap, labeled paths). Not a CSS/web layout. POLISH:CANDIDATE only; David signs PASS.

- Director Console: stock grip-resize (default 780×780, floor 740×520), size persist in `ChurchOfBeefDB.ui.console`, desk columns / list wells / compose boxes follow the frame. Compose fold header is **Decree** (theatrical **A GATHERING HAS BEEN DECREED** stays on the banner). Ceremony log header is **Ceremony log**.
- Records Book: stock grip-resize (default 720 × `tomeHeight()`, floor 480×320), persist `ChurchOfBeefDB.ui.recordsBook` `w`/`h`. Leaves already stretch.
- Decree, HUD, Fighter Card, Console Dock, Inputs, Toasts: `DISPLAY_SIZE_CHANGED` / `UI_SCALE_CHANGED` re-clamp or re-budget. Guest on player `uiScale` — never write it.
- Presence `here` stays OPEN_QUESTIONS #13. Congregation Proclaim fan-out not invented.

Harness **17546 passed, 0 failed**. Gate U item 5 still David's screenshot pass. POLISH:CANDIDATE.

### U-S Generated identity assets + responsive release candidate (2026-08-20)

- Built-in ImageGen produced four identity masters in transparent asset mode: papal wax bull seal, Gora bull-and-axes shield, victor gold seal, and a simplified 20px bull roundel. Source PNGs retain 10% safety margins; prompt sidecars and `ASSET_LOG.md` preserve provenance. The importer clears alpha=1 quantization noise only, then exports the defined 32-bit TGA sizes with stock fallbacks still present.
- Full-surface parchment/frame art now crops the production safety margin at render time. Proclamation copy, fighter-card ledger rows, and the Decree remain on their intended parchment instead of drifting into transparent master padding.
- The preview compositor now honors `SetTexCoord`, intrinsic/nested ScrollFrame clipping, and the offset Blizzard tracking-button border. The 20px minimap bull is visible instead of being hidden by an inaccurate centered-ring approximation.
- Responsive verification is repeatable through `scripts/render-responsive-previews.py`: **3 screen sizes × 11 scenarios**, at compact 800×600, stream 1024×768, and widescreen 1920×1080. All 33 scenes pass non-scroll screen-bound checks. The compact pass found and fixed the HUD's crushed 72px layout; the live HUD now preserves a 92-unit typography floor and fixed ledger-row heights.
- Harness **17547 passed, 0 failed**. Importer selftest PASS. Candidate ZIP rebuilt and exact source installed under Anniversary `Interface/AddOns/ChurchOfBeef`.

Gate U item 5 remains the in-client `/reload` interaction and screenshot pass. **POLISH:CANDIDATE**, not POLISH:PASS.

### U-T Live Event Input correction (2026-08-20)

The first successful live window capture exposed a surface the offline matrix did not include: the Event Mode congregation input strip. In the client it presented an unlabeled empty field over three equal-weight buttons, so the functional intent was not self-evident.

- The strip remains stock-template pragmatic: Blizzard tooltip backdrop and border, stock input and button templates, no custom Media, no sound, and no Quiet chrome.
- It now identifies itself as **EVENT INPUT**, displays the injected recipient (or **No recipient**), labels the field **Confession (optional)**, disables actions until their required recipient/character context exists, and provides stock tooltips for Petition, Catch up, and Confess.
- `event_inputs` is now a first-class deterministic preview scenario. Responsive verification is **3 screen sizes × 12 scenarios**: all **36 scenes** pass screen-bound checks at 800×600, 1024×768, and 1920×1080.
- Harness **17562 passed, 0 failed**. The exact build was repackaged and reinstalled for the final in-client `/reload` screenshot check.

**Final live smoke (2026-08-20):** after reinstall and `/reload`, `/beef` opened the corrected Records Book in the Anniversary client. The empty superlative and identity states were readable; both right-page sections aligned inside the inset parchment column; Close rendered in full; the frame stayed within the viewport; and no Lua error dialog was visible. The Event Input strip had already passed the same live capture check with explicit recipient state and disabled actions. **POLISH:CANDIDATE** is shipped; David retains the `POLISH:PASS` taste sign-off.

### U-U Live Records Book empty-state correction (2026-08-20)

The first live `/beef` capture found two seeded-preview blind spots: the real account had no recorded outcomes, producing a blank two-page spread, and the 24-unit Close plate truncated its label to `Cl…` at the player's UI scale.

- Empty superlative pages now state **No entries recorded.** without inventing history or outcomes.
- The identity leaf is permanently structured as **Your Record**, with labeled **Honorifics** and **Marked moments** sections; each honestly states **None recorded.** when empty.
- Live follow-up found Classic's default centered FontString justification on those two headings; both are now explicitly left-aligned and inset 24 units into the parchment content column.
- The stock dark Close plate now has a 56-unit text-safe width.
- Added a deterministic `records_empty` scenario. Responsive verification is now **3 screen sizes × 13 scenarios**; all **39 scenes** pass bounds checks.
- Harness **17569 passed, 0 failed**. Repackaged and reinstalled for the post-reload live capture.

Gate U item 5 remains David's post-reload interaction and screenshot acceptance. **POLISH:CANDIDATE**, not POLISH:PASS.

### U-V `/beef` congregation overview overhaul (2026-08-20)

The Records Book previously opened on a single archive ranking, which made the main command feel empty and gave little context about the congregation. `/beef` now opens on a dedicated two-page **Church Overview** without turning Quiet into an officer console, points board, or invented online-presence tracker.

- The left leaf identifies the actual guild, current Church state, active Decree, and authoritative counts for the latest roster snapshot, ceremonies, Goras, and marked moments.
- The right leaf answers **Your Place** with the local character and class, Church rank, separate Blizzard guild role, sanctioned Gora record, and recorded honorifics. Missing data is stated honestly rather than inferred.
- Overview is a landing spread, not a tenth archive page. Explicit footer paths jump to Overview, Victories, Rivalries, and Martyrs; Previous/Next continue through the nine canonical record pages.
- The layout reflows its typography and detail budget for the saved Records Book size. The compact presentation suppresses Decree flavor copy before it can collide with the metrics while preserving all primary context.
- Deterministic `dashboard` fixtures cover state, Decree, roster, archive, identity, and navigation behavior. Responsive verification is now **3 screen sizes × 14 scenarios**; all **42 scenes** pass screen-bound checks.
- Harness **17604 passed, 0 failed**. No sound, polling loop, Quiet ambient chrome, standings, points, fabricated permissions, or guessed presence was added.

The candidate is packaged for a final in-client `/reload` and `/beef` capture. **POLISH:CANDIDATE**, not POLISH:PASS.

### U-W `/beef` frontispiece legibility correction (2026-08-20)

David rejected U-V in the live client as still weak in legibility and UI execution. The captured screen also showed that an archive leaf could still be mistaken for the main route. The candidate was reopened for the skill's maximum two critique→revise rounds.

- `/beef` now returns an already-open archive leaf to Home; only `/beef` from Home closes the book. Home is therefore the unambiguous entry surface.
- The saved oversized ledger is migrated once to a focused **680×520** default, with a **620×500** readability floor and ordinary user resizing thereafter.
- Records parchment crops the generated master's safety margin, removing the translucent inset rectangles exposed by the live screenshot.
- Typography was rebuilt around in-client floors: 26px display masthead, 24px congregation identity, 22px player identity, 20px leaf titles, 16px Decree/history lines, and 14px body/navigation copy.
- The frontispiece now uses the papal seal and Gora sigil as focal objects; groups information into congregation state, active Decree, four durable archive totals, personal Church/guild identity, and the latest ceremony/marked moment; and visibly selects the current footer route.
- Previous/Next are hidden on Home and restored for the nine canonical archive leaves. No new mechanic, feed, ladder, point system, online-presence inference, sound, or ambient Quiet surface was introduced.
- Harness **17625 passed, 0 failed**. Responsive verification remains **3 screen sizes × 14 scenarios**; all **42 scenes** pass screen-bound checks.

The two-round visual loop is complete and clean offline. Final status remains **POLISH:CANDIDATE** pending David's post-reload live taste sign-off.

### U-X Minimap / Decree comprehension pass (2026-08-20)

David reported that clicking the minimap roundel unpredictably opened a small "Decree" window whose purpose was unclear. The interaction and the theatrical card were reopened as one focused UX slice.

- The minimap roundel now has stable navigation: left-click always opens the Church overview; right-click explicitly opens the active gathering notice. Its tooltip says **GUILD GATHERING**, shows the posted line, and labels both actions in plain language.
- The Decree is now a 440×280 explanatory card with a dark ceremonial title band, full-color papal seal, high-contrast parchment body, and a dedicated action footer. The canonical **A GATHERING HAS BEEN DECREED** proclamation remains intact.
- Plain-language purpose copy identifies the surface as the guild's current meetup notice and explains that it carries where and when to gather. The posted line remains the primary 24px headline; optional flavor is visually subordinate and capped at two lines.
- **OPEN CHURCH BOOK** dismisses the notice and returns directly to the overview. **CLOSE** remains explicit, text-safe, and inside the title band.
- No calendar, RSVP, reminders, recurrence, attendance, new Decree fields, sound, toast, pip, polling loop, or ambient Quiet surface was added. Once-per-login reveal and minimap replay remain intact.
- Focused coverage verifies direct Records Book navigation and its fallback, stable left-click behavior, explicit right-click replay, explanatory copy, and tooltip language. Harness **17635 passed, 0 failed**. Responsive verification remains **3 screen sizes × 14 scenarios**; all **42 scenes** pass screen-bound checks.

The two-round critique loop is complete and clean offline. Final status remains **POLISH:CANDIDATE** pending the installed `/reload` interaction and live taste sign-off.

## UX Rebuild wave — re-assessment, then rebuild (2026-09-13)

**Status:** COMPLETE (harness). **POLISH:CANDIDATE** at most — David's in-client pass is the close.
**Branch:** `reformation/phase-1-excision` (uncommitted; no commit — David has not asked).
**Trigger:** David, after the installed U-wave: the addon is visible but "still very much looking like a dev test"; asked for a re-assessment of what the addon needs to be, not just UI polish.
**Plan:** re-assessment against Bible §22.3 (one complete Gathering) — the console had grown 47 public verbs from reading §18 instead of from the paper-prototype run §22.3 orders before console code. David's forks decided 2026-09-13: **target-driven Pope kit**; petitions and the Knighting line stay as secondary strips; **cold tools leave the UI**; both surfaces must succeed on the first night.

### Lanes (implementer + adversarial reviewer each; briefs and reports in `docs/reformation/ux-rebuild/briefs/`)

| Lane | Owns | Verdict |
|------|------|---------|
| W — wire | `Net/BeefNet.lua` default whisper dest (last STATE sender → `Popes.List[1]`); Pope re-broadcasts STATE on guildmate HELLO while live; `/beef petition|confess|catchup` retired; Inputs = one Petition button; HUD favor plates use the Net default | Spec PASS; Approved. 17280/0 |
| K — Pope kit | `UI/Console.lua` rebuilt target-driven (working subject from `PLAYER_TARGET_CHANGED` or strip click; ensure-on-verb recognition via new `Store:EnsureCharacterByName`; human copy; Knighting/Gora rites only; cold tools cut); ConsoleDock retired (file, suite, TOC) | Spec PASS; Approved after fix wave (target listener sleeps while hidden; `UnitIsPlayer` guard; ensure Pope-gated; Elevate non-QUIET). 15907/0 |
| C — Church card | `UI/RecordsBook.lua` Home = identity + Decree card (no counters); **Chronicle** leaf (dated ceremony log, newest first, no medallions, 2-line stride); superlatives only when held; footer Home/Chronicle/Prev/Next | Spec PASS; Approved after fix wave (no misattributing degrade lines; chronicle geometry; perf; pins). 15905/0 |
| T — theater | Fighter card = sanction beat (hides on verdict / CloseRite / EndEvent; self-echo skip); HUD stays the persistent Gora surface; `MainFrame.lua` + `Status.lua` + small-toast engine retired; bootstrap owns UI init; `/beef` + minimap + OPEN CHURCH BOOK → `RecordsBook:ToggleHome`; `Decree:Set` wrap shows the banner on post and inbound; verdict wraps refresh the Pope's HUD | Spec PASS; Approved after fix wave (self-echo skip pinned; initUi order/pcall pinned). 15637/0 |
| H — honesty | `test_inputs` dest-persist pins restored; stale `COB.UI` shell text fixed in `architecture-overview.mdc` / `addon-module-layers.mdc`; `solo-smoke.md` rewritten for the new surfaces; `v1-checklist.md` + `two-client-smoke.md` honesty updated; `OPEN_QUESTIONS.md` #14–19 appended | this row |

### What the addon is now

- **Quiet:** minimap roundel + the Decree. `/beef` is a five-second Church card; Records behind it are a dated Chronicle plus held superlatives only.
- **Pope:** `/beef console` answers "what do I do next?" — one primary verb per phase, driven by whoever David is targeting. Target the kneeling Beef → KNIGHT THIS BEEF (creates their record — that is the recognition). Target two fighters → SANCTION. Verdicts on target or fighter plates. Elevate appears when earned.
- **Wire:** congregation sends default to the Pope (last STATE sender, else `Data/Popes.lua`); late joiners are caught up by the Pope's HELLO-triggered re-broadcast — no catch-up UX.
- **Theater:** fighter card introduces the bout and dies at the ruling; the HUD carries the fight through the verdict; one toast engine (Proclaim); five Event cues; Quiet stays silent.

### Gates and leftovers (unchanged unless named)

- Gate U item 5 (David's screenshot pass), Gate W (two-client smoke), and Gate 6 (A01–A04) remain **OPEN** and owner-David. The two-client smoke now also watches: default-dest sends, HELLO re-broadcast, the Pope-echo card skip.
- Named leftovers: SUMMON; live HUD health; confession inbox UI; cold-tools UI (Archive/Canonize/Recognition/Honorific/Notebook — Core-only); post-show clipboard; CurseForge/Wago.
- `OPEN_QUESTIONS.md` #14 (target-verb guild scope) and #15 (name-reuse tie-break) are new and open.
- Known accepted edges: OPEN CHURCH BOOK on an already-open Home card closes the book; chronicle leaf paints the newest 7 entries (no scrolling); `Roster:SetOnChanged` is callerless (future Core lane).
- Harness at wave close: **15637 passed, 0 failed** (`lua tests/run.lua`, exit 0). `preview_dump` 13 scenarios exit 0. Installed to Anniversary for David's pass.

### Player card (2026-09-13)

David: the `/beef` main window "doesn't serve any actual useful purpose … should be much more of a player card". Rebuilt as `UI/PlayerCard.lua` (320×540, fixed, movable, Quiet): class-colored name, Church rank plate with the Bible §5 relationship line (`Data/Ranks.lua` `relationship`), Knighting date, guild / Blizzard rank, roman Gora record + longest streak + defenses, three rivalries, distinctions (held superlatives then honorifics), the Decree in the footer, one button (**CHURCH RECORDS**) to the Records Book. Superlative math moved to pure `Core/Records.lua` (`Pages`, `Summary`, `HeldBy`). Records Book lost its Home spread and identity leaf; opens on a two-leaf Chronicle (14 rows); footer is a leaf caption with edge-aware **‹ PREVIOUS** / **NEXT ›**; superlative leaves carry a faint papal watermark. `/beef`, minimap left-click, and the Decree's **YOUR CARD** all land on the card. No position among members (§10.9; OPEN_QUESTIONS #20). Plan: `docs/reformation/ux-rebuild/plans/2026-09-13-player-card.md`; per-task reports under `briefs/PC-task-*`. Harness at close: see ledger. **POLISH:CANDIDATE** — David's in-client pass is the close; the first live check is whether four distinction lines clear the CHURCH RECORDS button at default scale.

### Guild titles + presence census (2026-09-13)

David named the in-game guild ranks to Church titles and asked that they show without a Knighting. When the store has no human row, the player-card gold plate and the console presence census show the live Blizzard rank **name** (not slot index). A name that matches a canon title also gets the §5 relationship line; any other live name is labeled "Guild rank." The plate does not invent "Beef Pope." Display only; `ChurchRankIdForGuildIndex` stays nil; store rows still win. `/beef console` Presence is a count-by-title glance plus Unrecorded; **Add to the line** moved onto the working subject. OPEN_QUESTIONS #21.

### Gathering headline (2026-09-13)

`/beef` now reads as identity + a Gathering plate under rank (live Decree line, or muted `No gathering is posted.`). Empty **BEEF GORA** / **BEEF RIVALS** / **BEEF LEGACY** collapse; height 380 with no story, 580 with a story. Thin empty charcoal close band — no footer Decree. **CHURCH RECORDS** remains the one door. No feed; no position among members. **POLISH:CANDIDATE**.

### Pope's Desk rework (2026-09-14)

Director Console rebuilt as a state-driven Pope's Desk (Gathering / Decrees / Chronicle / Church). Rites are modes, not stacked controls. Candidate and fighter locks, structured verdicts, Favor module, End/Close confirms, census off the live page. Record: `docs/design/POPES_DESK_REWORK.md`. Harness **18990 passed, 0 failed**. Installed to Anniversary. `/reload` session locks and verdicts are covered by `SimulateReloadForTests`; a live client pass is still owner-David. **POLISH:CANDIDATE**.
