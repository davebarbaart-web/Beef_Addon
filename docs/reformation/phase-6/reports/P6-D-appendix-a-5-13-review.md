# Phase 6 Lane D — Adversarial Review

**Lane:** Appendix A validation sheets (items 5–13)
**Exclusive files:** `docs/validation/A05-raid-markers.md` … `A13-login-reload.md`, `docs/validation/README.md` (ledger rows 5–13), `docs/reformation/phase-6/reports/P6-D-appendix-a-5-13.md`
**Lane report:** `docs/reformation/phase-6/reports/P6-D-appendix-a-5-13.md`
**Cited law:** Bible Appendix A items 5–13 (verbatim titles and fallbacks); §8, §3.1, §3.2, §12, §13.1, §13.2, §13.4, §13.5, §14.1, §14.3, §16, §17, §19.1, §19.4, §20.3; Laws 6, 7, 8; Adjudication (raid-marker assist; guild-bank Important Later); Audit V6; sheet pattern A01 / A04
**Writer:** [Appendix A 5–13](2a6a16fc-0fa0-421b-ace9-176c10005ce1)
**Format example:** `docs/reformation/phase-6/reports/P6-A-appendix-a-review.md`

**Spec:** PASS
**Quality:** Approved

Nine method sheets exist. Every Result is **NOT RUN**. Owner is **David**. A01–A04 are still **NOT RUN** and were not rewritten (mtime 08:07; leftover on A01 still says “sheet later”). Ledger rows 1–13 are **NOT RUN**; rows 5–13 link the new files. Titles match Appendix A bold titles. `UI/Sound.lua` `PlaySound` and the existing Decree banner are named as **not** a pass. No SUMMON, favor, live-health workaround, `GuildPromote`, or Expeditions UX invented as product. Writer Writes were exclusive files only. This review did not invent Results, did not walk the client, did not edit the sheets, and does not claim V1/MVP.

## Verdict

Refutation of “invented in-game Result / Sound.lua-as-A08-pass / Decree-banner-as-A13-pass / rewritten A01–A04 / invented SUMMON / favor / live health / GuildPromote / Expeditions UX / addon Lua edit” **fails** for this lane’s exclusive files.

Appendix A items 5–13 are method sheets. Item 5 names the only Bible fallback in the set (**target-assist only**). Items 6–13 name **no** standalone fallback and cite the Appendix A closer. Later-phase dependents (Expeditions, Campaigns, profession directory, tithe) are quoted from §14.3 and then forbidden as specs.

Law 6 is intact on the sheets. A08: Quiet Mode stays silent; a FAIL is not a license for Quiet clicks; stock `PlaySound` is not the fallback decision. A13: calendar / RSVP stay banned (§14.1).

Law 7 is intact on A07. No prune, expiry, or per-character split “to keep SV small.” Agents do not touch `WTF/`.

Law 8 is intact. A12 is unmodified dungeon combat observation. A05 does not invent a health workaround. No fifth Gora outcome.

This review did not invent a Result, a marker-index scheme, a SecureActionButton, a SUMMON protocol, favor, `GuildPromote`, or Expeditions UX, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| Nine files exist; each Result is NOT RUN; Owner is David | **Yes.** `A05`–`A13` on disk. Each header: `Owner: David`, `Result: NOT RUN`. No `PASS` / `FAIL` / `PARTIAL` in any Result field. No invented walk facts (no file sizes, no copied profession-link strings, no marker-index product, no event-order timings recorded as findings). |
| A01–A04 still NOT RUN and not rewritten | **Yes.** Headers unchanged. Mtimes 08:07:00–08:07:19 (P6-A). New sheets 08:54:41–08:55:27. A01 leftover still: “Raid markers are Appendix A item 5 (sheet later).” Writer transcript: no Write/StrReplace on A01–A04. |
| README rows 1–13 NOT RUN; rows 5–13 point at the new files | **Yes.** Rows 1–4 still link A01–A04, Result NOT RUN. Rows 5–13 replaced `sheet later` / `—` with `[A0N-….md](A0N-….md)` / `NOT RUN`. Writer StrReplace touched only those nine table rows. “How a Result is written” still: agents do not tick. |
| Each sheet title matches the Bible item | **Yes.** Verbatim Appendix A bold titles: raid target markers; targeting by name from UI; SavedVariables size and write behavior; PlaySoundFile / custom sound assets; party/raid composition and raid-leader detection; profession/tradeskill links on TBC client; guild bank transaction log queryability; dungeon “completion” signals; login/reload event timing. Dependent arrows match (§8 marking; console targeting assist; records/Chronicle/Archive; §19.4 cues; later Expeditions/Campaigns; later profession directory; later tithe; later Expeditions; Decree banner + snapshot requests). |
| No addon Lua / OPEN_QUESTIONS / A01 Results edits | **Yes.** Writer Writes: `A05`–`A13`, README rows 5–13, this lane’s report. `UI/Sound.lua` 07:42:30; `UI/Decree.lua` 07:54:06; `Core/DB.lua` 07:42:29. `OPEN_QUESTIONS.md` 08:52:43 is the leftover-wave integrator (#8 / #11) **before** this writer (08:53). `Data/Popes.lua` 08:56:09 is P6-H, not this writer. A01 Result still NOT RUN. |
| Sound.lua / Decree banner not treated as a pass; no invented SUMMON / favor / live health / GuildPromote / Expeditions UX | **Yes.** A08: “`UI/Sound.lua`'s existing `PlaySound` fallback is not a validation pass.” Not-a-pass lists `pcall(PlaySound, name)` and InspectProgress `sanction`. A13: “The existing Decree banner on login is not a pass of timing facts.” “Seeing today's banner is not the Result.” SUMMON / favor / live HUD health / INPUT / `#8` override UX / `GuildPromote` / SecureActionButton / marker-index scheme / Archive format / Expeditions-Campaigns-directory-tithe UX appear only as do-not-invent or leftovers. A09/A12: **method only**; “do not spec.” |

## Attack results

| Attack | Result |
|---|---|
| Any A05–A13 Result is PASS / FAIL / PARTIAL? | **No.** Headers and ledger are NOT RUN. Prose has no recorded client facts. |
| A01–A04 rewritten or Results filled? | **No.** Mtimes and leftover text prove isolation. All four still NOT RUN. |
| A08 treats `UI/Sound.lua` `PlaySound` as item 8 PASS? | **No.** Named as the shipped stub. Explicit “not a validation pass.” Step 3 may observe `Sound:Play`; that observation is forbidden as the Result. |
| A13 treats the existing Decree banner as item 13 PASS? | **No.** Banner existence is not timing facts. Not-a-pass: `DecreeBanner:Init`, bootstrap `PLAYER_LOGIN` init, `test_decree` / `test_snapshot`, InspectProgress opening the banner. |
| Invents SUMMON / favor / live health / `GuildPromote` / Expeditions UX? | **No.** Named only to forbid. A09 quotes §14.3 Campaign majority/supermajority then “Those systems are not specified here.” A12 quotes the ~3-of-5 Expedition line then “Do not spec Expeditions.” A09 not-a-pass: “Any invented ~3-of-5 or majority rule.” |
| Invents a fallback for items 6–13? | **No.** Each says Appendix A names no standalone fallback; closer applies. A06: item 5’s “target-assist only” is not a substitute if this item FAILs. A08: do not treat stock `PlaySound` as the decision. A11: a FAIL does not invent a tithe ledger or gold-in-mail parser. A13: do not invent a hold-timer, sixth runtime state, or snapshot schema; version-mismatch Quiet is a different degrade. |
| Invents a marker-index scheme or SecureActionButton product? | **No.** A05 leftover: which index for candidate vs fighters — do not invent. A06: “does not invent SecureActionButton product.” “Do not add secure templates to the addon.” |
| Invents Archive format / prune / Grant / extra cues / Canonization / calendar? | **No.** A07 forbids prune and Archive format. A08 forbids extra cues and shipping the seal. A13 forbids calendar/RSVP (`#5` leftover). |
| Writer edited addon Lua / TOC / tests / `OPEN_QUESTIONS.md` / `REFORMATION_LOG.md` / `docs/phases/**`? | **No** for this writer. Parallel leftover-wave owns `OPEN_QUESTIONS.md` (08:52), `Data/Popes.lua` (P6-H), `docs/phases/**` (P6-E/F/G), and the log (orchestrator). |
| Writer claimed V1/MVP complete, or this review walked the client? | **No.** Lane status is DONE for sheets. Results remain NOT RUN. This review did not install or `/reload`. |

Refutation of Laws 6 (no Quiet sound / calendar from a sheet), 7 (no prune), 8 (no combat-log product / fifth outcome), Appendix A closer (no improvised fallback-as-pass), and the contract “NOT RUN / David / A01–A04 untouched / Sound and Decree are not a pass” **fails** for the exclusive files.

## Leftovers (other lanes / David — not fixed)

Writer leftovers are current.

### David (in-game close)

- Walk A01–A13 on Anniversary `20506` and write Results (`PASS` / `FAIL` / `PARTIAL`). Agents do not tick these.
- Items 1–4 remain load-bearing and still NOT RUN.
- Item 6 must still be walked; it is the named fallback for item 5, not a pass of item 5.
- Items 9–12 stay later-phase dependents after their Results exist. Do not spec them from a sheet.

### Do not invent

- Marker-index scheme; `SetRaidTarget` product from this sheet
- SecureActionButton widget (design after A06’s Result)
- Archive file/string format; weekly cold reminder widgets
- Extra sound cues; Canonization seal
- Expeditions / Campaigns / profession directory / tithe UX / per-dungeon boss table
- Snapshot schema; hold-timer; sixth runtime state
- SUMMON; INPUT; favor; calendar/RSVP; Grant/standing
- `GuildPromote` from Core (A04 leftover; this lane did not code it)
- OPEN_QUESTIONS #8 override UX / designated-Council store (licensed data file is P6-H, not this lane)
- Treating `PlaySound` or today’s Decree banner as A08 / A13 PASS

### Other leftover-wave lanes (not this exclusive set)

- P6-E/F/G: `docs/phases/**`
- P6-H: `Data/Popes.lua` + Sender Accept
- P6-I: Console Post / Sound callers
- P6-J: HUD verify (A01 still NOT RUN)

## Findings

### Critical

None.

### Important

1. **A05 fallback prose maps “target-assist only” onto item 6.** Appendix A item 5’s fallback is three words. “The console still targets the current candidate/fighter where the API allows (item 6)” is the correct coupling, but it is one clause past the Bible — same class as P6-A’s A04 “not a ritual gate.” Do not treat that sentence as a design decision if item 6 FAILs. The sheet also says do not invent a third marking scheme. Do not “fix” it here.

2. **A08 step 2 pre-asserts a live fact.** “Missing media must not fail load” is packaging / §19.3 law, not a recorded Anniversary result. David writes what the client did. Do not promote the sentence into a PASS. Same class as P6-A’s A02 “it should not” parenthetical.

### Nit

1. **A01 leftover still says “sheet later.”** Correct isolation. Stale now. Do not rewrite A01 from this lane.

2. **A06 “Product windows stay insecure” vs leftover “whether a secure button is required in combat.”** The first is existing panel law (`wow-ui-taint-lockdown`). The second is the item-6 design after the Result. Do not read the first as a silent FAIL of combat name-targeting.

3. **A07 names schema 7 keys** (`version`, `ui`, `store`, `event`, `decree`). Those are the shipped persist shape, not Appendix A text. Observation targets. David records what is present. Not a Result.

4. **A05 / A06 / A12 name `SetRaidTarget`, `TargetUnit`, `GetInstanceInfo`.** Not in Appendix A. Same pattern as A01’s `UnitHealth`: “or the equivalent this client actually exposes.” David records what `20506` has.

5. **A13 leftover “theater snapshot stays fail-closed until licensed.”** The leftover wave licensed `Data/Popes.lua` + `popeOverrides` in parallel (P6-H; empty list). The method is still conditional (“If `#8` is still fail-closed, record request timing only”). Do not invent a Pope list from this sheet.

6. **A08 step 1 `/run PlaySoundFile` may make a sound on a Tuesday.** That is owner observation of the API, not Quiet chrome. Step 4 still forbids a Quiet leak as product.

## Brief contract

| Requirement | Result |
|---|---|
| Nine method sheets for Appendix A items 5–13 | Met |
| Each sheet: Bible title, dependent feature, fallback or closer, live `20506` method, Owner David, Result NOT RUN | Met |
| A01–A04 untouched; still NOT RUN | Met |
| README rows 1–13 NOT RUN; rows 5–13 linked | Met |
| Titles match Bible items 5–13 | Met |
| Do not invent in-game Results | Met |
| Do not treat `UI/Sound.lua` `PlaySound` as A08 pass | Met |
| Do not treat existing Decree banner as A13 pass | Met |
| Do not invent SUMMON / favor / live health / GuildPromote / Expeditions UX | Met |
| Do not edit addon Lua, TOC, tests, `OPEN_QUESTIONS.md`, A01 Results | Met (this writer) |
| No commit; do not claim V1/MVP | Met |

## Sections checked

- Writer report `docs/reformation/phase-6/reports/P6-D-appendix-a-5-13.md`
- `docs/validation/README.md`, `A01`–`A13` (full)
- Bible Appendix A items 5–13; §8 auto-mark line; §14.1 Decree; §14.3 later-phase systems; §19.4 cues; §13.2 worth-observing; §20.3 snapshot; Appendix A closer
- Adjudication: raid-marker and targeting assist; guild-bank Important Later (no donation leaderboard)
- Sheet pattern A01 / A04
- `docs/design/OPEN_QUESTIONS.md` (mtime 08:52 — integrator leftover wave, not this writer; #2 still waits on A01)
- Writer transcript ([Appendix A 5–13](2a6a16fc-0fa0-421b-ace9-176c10005ce1)) — exclusive Writes only
- Read-only confirm: `UI/Sound.lua` `pcall(PlaySound, name)` for the five cue names; `Core/DB.lua` schema 7 keys; A01–A04 mtimes 08:07
- Parallel: `Data/Popes.lua` is P6-H; this review does not sign that lane
- Format: `docs/reformation/phase-6/reports/P6-A-appendix-a-review.md`
