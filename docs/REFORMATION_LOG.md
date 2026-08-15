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

Leftover wave D–J is signed. Harness **6035 passed, 0 failed**. Gate 6 stays **OPEN** until David writes A01–A04 Results. Still out: designated-Council UX, Console `SendState`, favor, SUMMON, INPUT/Confession, Decree wire, live HUD health, polish pass, CurseForge/Wago. David authorized the commit for in-game smoke.

