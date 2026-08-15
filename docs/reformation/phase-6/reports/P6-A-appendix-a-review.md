# Phase 6 Lane A — Adversarial Review

**Lane:** Appendix A validation sheets (items 1–4)
**Exclusive files:** `docs/validation/README.md`, `docs/validation/A01-live-health.md`, `docs/validation/A02-duel-messages.md`, `docs/validation/A03-sender-integrity.md`, `docs/validation/A04-guild-roster.md`, `docs/reformation/phase-6/reports/P6-A-appendix-a.md`
**Lane report:** `docs/reformation/phase-6/reports/P6-A-appendix-a.md`
**Cited law:** Bible Appendix A items 1–13; §10.7, §10.8, §13.1, §13.4, §20.3, §5, §8, §18.1, §22.1 item 2; Laws 4, 5, 8; `docs/design/OPEN_QUESTIONS.md` (#2, #8); brief `docs/reformation/phase-6/briefs/P6-A-appendix-a.md`
**Writer:** [Appendix A](19e09984-21c9-421d-858f-620dfb37e6a2)
**Format example:** `docs/reformation/phase-5/reports/P5-A-decree-review.md` (`P6-B-checklist-review.md` was not present)

**Spec:** PASS
**Quality:** Approved

Ledger of Appendix A items 1–13 exists. Items 1–4 are method sheets. Every Result is **NOT RUN**. Owner is **David**. Items 5–13 are title + "sheet later" only — no method sheets, no `A05`–`A13` files. The coded no-health HUD is named as the §10.7 fallback surface and is **not** an A01 pass. `#2` and `#8` stay open; `OPEN_QUESTIONS.md` was not edited (mtime 07:23; writer files 08:06–08:07). No auto-propose, no 40-client proof, no `Data/Popes.lua`, no guild-rank map, no `GuildPromote` in addon code. Writer Writes were exclusive files only. Parallel Lanes B/C touched `docs/phases/**`; this writer did not. This review did not invent Results, did not walk the client, did not edit the sheets, and does not claim V1/MVP.

## Verdict

Refutation of “invented in-game Result / HUD-as-pass / resolved #2 or #8 / invented auto-propose / 40-client proof / guild-rank map / GuildPromote / addon Lua edit” **fails** for this lane’s exclusive files.

Law 4 is intact on the sheets. A02’s dependent feature is Bible auto-proposed verdicts; the fallback is the already-required one-tap override; the sheet forbids a chat parser and says a later PASS would unlock a proposer, not ship one. A02 does not fill a Result.

Law 5 / §13.4 are intact on the sheets. A03 validates the sender primitive and named channels. `#8` is leftover. `Sender:IsRegisteredPope` staying fail-closed is named as **not** a pass. No Pope list file.

Law 8 is intact on the sheets. A01 forbids a health hack, nameplate scrape shipped as product, and a combat-log HP estimator. A02 is an unmodified duel; no combat-log substitute.

Appendix A’s closer is quoted on the ledger: a fail triggers a design fallback decision *before* implementation improvises one. Item 3 has no Bible-named fallback; the sheet says so. Item 4 has no standalone fallback; the sheet derives “where the API permits” from §5 / §8 and still cites the closer.

This review did not invent a Result, a HUD final form, a parser, a 40-client proof, a guild-rank map, or `GuildPromote`, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| A01–A04 Result is NOT RUN; Owner is David | **Yes.** Each sheet header: `Owner: David`, `Result: NOT RUN`. Ledger rows 1–4 match. README: agents do not tick Results. |
| Each sheet names dependent feature, Bible fallback, live-client method from the Bible | **Yes.** Features match Appendix A arrows. Fallbacks: A01 = HUD without live health (§10.7); A02 = pure manual one-tap verdict; A03 = no named fallback, closer applies; A04 = no standalone fallback, §5/§8 “where the API permits,” closer still applies. Methods are Anniversary `20506` walks of the Bible’s named constraints (nameplate/target; formats/locale/range; GUILD/RAID/WHISPER/sender/rate; rank read/write + refresh). |
| Coded no-health HUD is not an A01 pass; #2 stays open | **Yes.** A01 “Not a pass”: harness `test_hud`, `GetView().health == nil`, cards without bars. `#2` quoted, not answered. `OPEN_QUESTIONS.md` #2 still: “Appendix A item 1 result decides HUD final form.” Read-only: `UI/Hud.lua` `health = nil` at lines 46 and 236 — fallback surface, not a walk. |
| A02 does not invent a chat parser or auto-propose; fallback is the shipped one-tap | **Yes.** “No chat parser.” “Do not invent auto-propose from duel chat.” `Gora:Propose` is caller-supplied (read-only confirm). Not-a-pass: Console buttons, `Propose` accepting a table, harness `DeclareVictor` / `CowardiceRecorded`. |
| A03 does not invent a 40-client proof or `Data/Popes.lua` | **Yes.** “40-client scale is the Bible target, not a number this sheet fabricates.” “Do not add `Data/Popes.lua`.” No workspace `Data/Popes.lua`. `#8` uncoded. `IsRegisteredPope` always `false` is not-a-pass. |
| A04 does not invent a guild-rank map or ship `GuildPromote` | **Yes.** “No mapping table.” Write check is default guild UI, then restore. “Do not add `GuildPromote` / `SetGuildRank` to the addon.” Read-only: `Knighting.lua` still Church-store only. Not-a-pass: `Store:SetRank` / `KnightThisBeef` writing Church rank only. |
| README lists all 13 items; 5–13 have no method sheets | **Yes.** Titles match Appendix A bold titles. Rows 5–13: Sheet = `sheet later`, Result = `—`. No `A05`–`A13` files. README adds no methods, fallbacks, or APIs for 5–13. |
| Writer stayed inside exclusive files; `OPEN_QUESTIONS.md` / addon Lua / TOC / tests / `docs/phases/**` not edited by this writer | **Yes.** Transcript Writes: the six exclusive paths only. `OPEN_QUESTIONS.md` mtime 07:23 (24 lines; `#2` and `#8` unchanged). Writer files 08:06:56–08:07:29. `docs/phases/v1-checklist.md` (08:07:08) and `dress-rehearsal.md` (08:07:37) are Lanes B/C exclusive files. TOC / `tests/run.lua` 08:00:33 are earlier, not this writer. No commit. |

## Attack results

| Attack | Result |
|---|---|
| Any A01–A04 Result is PASS / FAIL / PARTIAL? | **No.** Headers and ledger are NOT RUN. Prose has no invented walk facts (no copied system-message strings, no `UnitHealth` numbers, no sender-argument captures). |
| A01 treats `UI/Hud.lua` (`health` always nil) as item 1 PASS? | **No.** Named as the shipped §10.7 fallback. Explicit “not a validation pass.” `#2` waits on David’s Result. |
| Sheets resolve OPEN_QUESTIONS #2 or #8, or edit that file? | **No.** File untouched. #2 still waits on item 1. #8 still “Do not code now.” A03: validate sender primitive, not a Pope list. |
| A02 invents a chat parser / auto-propose / extra outcome enums? | **No.** Parser forbidden. PASS “would unlock a proposer later” restates Appendix A’s dependent feature; it does not ship one. VOID / free ruling stay Pope judgment. |
| A03 invents a 40-client proof, throttle-library choice, or `Data/Popes.lua`? | **No.** Honest-scale leftover. RAID = “RAID not exercised” if no raid. No spoof tool. No Pope file. |
| A04 invents a 10-slot guild-rank map or codes `GuildPromote`? | **No.** §5 mapping quoted as later design. Promote is Blizzard UI on a willing alt. Addon path unchanged. |
| Items 5–13 grew method sheets (raid markers, targeting, SV, sound, …)? | **No.** Title + “sheet later” only. A01 leftover correctly points raid markers at item 5. |
| Writer edited addon Lua / TOC / tests / `OPEN_QUESTIONS.md` / `docs/phases/**`? | **No** for this writer. Parallel B/C own the `docs/phases/` mtimes in the same minute. |
| Writer claimed V1/MVP complete, or this review walked the client? | **No.** Lane status is DONE for sheets. Results remain NOT RUN. This review did not install or `/reload`. |
| A04 “not a ritual gate” / A02 “it should not” are silent Results? | **No as Spec.** Result fields stay NOT RUN. Those asides are method color, not ticks. Named under Findings; not fixed. |

Refutation of Law 4 (no invented parser / auto-declare), Law 5 (no Pope list / `#8`), Law 8 (no health workaround / combat-log substitute), Appendix A closer (no improvised fallback-as-pass), and the brief’s “NOT RUN / David / items 5–13 later” contract **fails** for the exclusive files.

## Leftovers (other lanes / David — not fixed)

Writer leftovers are current.

### David (in-game close)

- Walk A01–A04 on Anniversary `20506` and write Results (`PASS` / `FAIL` / `PARTIAL`). Agents do not tick these.
- Locale coverage beyond the clients David actually has (A02).
- RAID channel and 40-client rate-limit proof (A03) when those conditions exist.

### Later lane (items 5–13)

- Raid target markers; targeting by name; SavedVariables; PlaySoundFile; party/raid; professions; guild bank; dungeon completion; login/reload timing.
- Title + “sheet later” only until that lane.

### #2 / #8 / do not invent

- **#2** HUD final form waits on A01’s Result. The shipped no-health HUD is not the answer.
- **#8** registered-Pope list, edit path, override UX. Do not create `Data/Popes.lua`.
- Auto-propose from duel chat (A02 PASS would unlock a later proposer).
- Guild-rank map; `GuildPromote` / `SetGuildRank` on KNIGHT THIS BEEF (later UI, only if A04’s Result says the API permits).
- Presence desk wiring; silent vs one-question §5 reconcile.
- Favor INPUT channel (unspecified). A01 leftover is correct: this item does not invent it.
- Throttle-library choice if the live client needs more than the shipped bucket.

### Other Phase 6 lanes (not this exclusive set)

- Lane B: `docs/phases/v1-checklist.md`
- Lane C: `docs/phases/dress-rehearsal.md`

## Findings

### Critical

None.

### Important

1. **A04 fallback prose goes one clause past the Bible.** Item 4 names no standalone fallback. “Where the API permits” is §5 / §8. “Presence without a fresh roster snapshot is empty / unknown — not a ritual gate” is method color, not Appendix A. The sheet still cites the closer. Do not treat that clause as a design decision. Do not “fix” it here.

2. **A02 step 4 parenthetical pre-asserts a live fact.** “whether a distant /reload client sees it after the fact (it should not — this is a live system message, not a log replay).” The Result field is still NOT RUN. David writes what the client did. Do not promote the parenthetical into a PASS.

### Nit

1. **A01 / A03 say `#2` / `#8` are “unread here” and then quote them.** Harmless. The file was not edited.

2. **A04 names `C_GuildInfo.GuildRoster()`** with “or the client’s equivalent.” Anniversary method should record whatever the `20506` client actually exposes (`GuildRoster()` or otherwise). Not a Retail API in addon code.

3. **A03 “otherwise a one-shot prefix ping”** could be misread as a new send helper. The same step says existing BeefNet traffic is enough and “Do not change addon Lua.” Do not add a ping module from this sheet.

4. **A04 “0-based `rankIndex`”** assumes Classic `GetGuildRosterInfo` shape. David records what the client returned.

5. **A01 names `UnitHealth` / `UnitHealthMax`.** Those strings are not in Appendix A; they are the obvious target-scan reads. The sheet allows “the equivalent unit-token read the client actually exposes.” Not a Result.

## Brief contract

| Requirement | Result |
|---|---|
| Create `docs/validation/` ledger + A01–A04 method sheets | Met |
| Each item 1–4 names dependent feature, Bible fallback, live `20506` method, Owner David, Result NOT RUN | Met (item 3/4: no named fallback → closer) |
| Do not invent in-game Results | Met |
| Do not resolve `#2`; do not treat coded no-health HUD as A01 pass | Met |
| Do not invent auto-propose from duel chat; A02 fallback is shipped one-tap | Met |
| Do not invent a 40-client proof (A03) | Met |
| Do not invent a guild-rank map or code `GuildPromote` (A04) | Met |
| Do not code `#8` | Met |
| README lists all 13 items; 5–13 title + “sheet later” only | Met |
| Do not edit addon Lua, TOC, tests, `OPEN_QUESTIONS.md`, `docs/phases/**` | Met (this writer) |
| No commit; do not claim V1/MVP | Met |

## Sections checked

- Brief `docs/reformation/phase-6/briefs/P6-A-appendix-a.md`
- Writer report `docs/reformation/phase-6/reports/P6-A-appendix-a.md`
- `docs/validation/README.md`, `A01`–`A04` (full)
- Bible Appendix A items 1–13; §10.7, §10.8, §10.3 flee line; §13.1, §13.4, §20.3; §5, §8, §18.1; §22.1 item 2
- `docs/design/OPEN_QUESTIONS.md` (#2 and #8 unchanged; mtime 07:23)
- Writer transcript ([Appendix A](19e09984-21c9-421d-858f-620dfb37e6a2)) — exclusive Writes only
- Read-only confirm: `UI/Hud.lua` (`health` nil), `Core/Sender.lua` (`IsRegisteredPope` false), `Core/Gora.lua` (`Propose` caller-supplied), `Core/Knighting.lua` (no `GuildPromote`), no `Data/Popes.lua`
- `docs/phases/**` mtimes (Lane B/C, not this writer)
- Format: `docs/reformation/phase-5/reports/P5-A-decree-review.md` (`P6-B-checklist-review.md` absent)
