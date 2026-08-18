Spec PASS

# B18-D — Markers Clear uses the player token (review)

**Quality:** Approved-with-nits

**Lane:** B18-D Markers Clear uses the player token
**Brief:** `docs/reformation/vestments/briefs/B18-D-markers-clear.md`
**Writer report:** `docs/reformation/vestments/briefs/B18-D-markers-clear-report.md`
**Diff:** `docs/reformation/vestments/briefs/B18-D-markers-clear.diff` (B18-D-only exclusive-pair packet; live files are untracked vs HEAD. Packet is the test hunk only — `Markers.lua` has no B18-D production delta.)
**Exclusive files:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Markers.lua` (`Clear` after `isGrouped`, `resolveUnit` player return), and `tests/test_markers.lua` (B16-D Mark player pins, then B18-D grouped `Clear("Beefina")` + Quiet / ungrouped refuse); then ran `lua tests/test_markers.lua` (**342 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §8 (candidate / fighter marks); Law 5 (Pope client); Law 6 (Quiet refuse); B16-D leftover (`Clear` inherits `resolveUnit` but was unpinned); Anniversary `SetRaidTarget(target, userIndex)` — index `0` clears; `"player"` is a valid UnitToken. Isolation wow_ui_stub + Common + Runtime + Markers only. Did not mutate `Markers.lua` or `test_markers.lua`. Did not commit. Did not edit Knighting, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Grouped + Pope + Event `Clear("Beefina")` still spies `raid1` (or a name token) | **Pass. Verified.** `Clear` still `resolveUnit` then `applyMark(unit, 0)`. Player return is the B16-D `namesSame(me, name)` arm before the `raidN` / `partyN` scan. Pin: `SetRaidTarget("player", 0)` and `unit ~= "raid1"` even though `armRaid` pins Beefina on `raid1`. Reviewer probe: same spy; `Clear("Chuckroast")` still `raid2`, 0. `Clear` has no hardcoded `"player"` / `Beefina`. |
| Quiet / ungrouped `Clear` of the local name now `SetRaidTarget`s | **Pass. Verified.** `isGrouped` still runs before `resolveUnit`. Pins: ungrouped Beefina is `"not in a group"`; Quiet Beefina is `"quiet"`; `#raidTargets == 0`. Reviewer probe: same two strings, no spy. |
| B16-D Mark player pins lost | **Pass.** `MarkCandidate("Beefina")` / `MarkFighters` player pins sit immediately above the new Clear block and still pass. Reviewer probe: star 1; fighters 2 / 3 with the other side still `raid2`. |
| Target verb changed / now requires a group | **Pass.** No Target edit in the packet. Existing ungrouped Target pin stays. Reviewer probe: `Target("Beefina")` spies `TargetUnit("Beefina", true)`; `SetRaidTarget` count 0. |
| Party scan pins lost | **Pass.** Pre-lane `Chuckroast` → `party1` pin stays. B16-D re-pin stays. Reviewer probe: party Mark of Chuckroast is still `party1` after a party self-clear. |
| Event + Pope + grouped no longer required | **Pass.** `Clear` still refuses Quiet / unlisted Pope / ungrouped / invalid name before resolve. Reviewer probe: unlisted Pope `Clear("Beefina")` is `"not a registered pope"`, no spy. RITE / CONSEQUENCE still clear; `EndEvent` is `"quiet"`. |
| GuildPromote / combat automation / CreateFrame | **Pass.** Source has none. Suite `combatCalls` / chat / addon / sounds stay 0. Reviewer probe: combat flag still clears; `combatCalls == 0`. |
| Isolated suite not exit 0 | **Pass. Verified.** 342 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is one `diff --git` hunk (B18-D Clear pins after the B16-D Mark block). Sibling dirt in this workspace is other lanes (Knighting, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Knighting / glue; no commit; no GuildPromote; no combat automation | **Pass.** Named-risk check. |
| Isolation stays wow_ui_stub + Common + Runtime + Markers | **Pass.** Three `dofile`s unchanged. Load wrap still **27** nil-module / slash pins under `if standalone then`. |
| Grouped + Pope + Event `Clear("Beefina")` spies `SetRaidTarget("player", 0)` | **Pass.** Named-risk check. View also records `verb == "Clear"`, `unit == "player"`, `index == 0`. |
| Quiet / ungrouped Clear still refuse | **Pass.** Named-risk check. |
| `resolveUnit` player return (B16-D) stays | **Pass.** Live helper is unchanged. `return "player"` / `namesSame(me, name)` source pins stay. |
| B16-D Mark player pins stay (`MarkCandidate` / `MarkFighters` → `"player"`) | **Pass.** Named-risk check. |
| Target verb unchanged (name-based; no group) | **Pass.** Named-risk check. |
| Party scan pins stay | **Pass.** Named-risk check. |
| Event + Pope + grouped still required | **Pass.** Named-risk check. |
| Isolation wrap stays; no new main-chunk locals | **Pass.** Wrap untouched. B18-D block reuses `ok` / `err` / `view`. |
| `lua tests/test_markers.lua` exit 0 | **Pass.** **342 / 0.** |

Bible §8 (candidate / fighter marks on the Pope client) and Law 5 / Law 6 hold on the exclusive pair. Anniversary `SetRaidTarget` takes a UnitToken; `"player"` is a base token; index `0` is the existing Clear contract. The B16-D leftover (Clear inherited the player return but was unpinned) is closed on the same stub name.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Party `Clear("Beefina")` is not a separate pin | **On contract.** Brief asked raid `armRaid` plus "party scan pins stay" (Mark). Reviewer probe: party self-clear spies `"player", 0`, not `partyN`. |
| Unlisted Pope `Clear("Beefina")` is not a separate pin | **On contract.** Brief named Quiet / ungrouped refuse. Earlier unlisted Clear of other names stays. Reviewer probe: Beefina is `"not a registered pope"`, no spy. |
| Type-guard still requires `GetNumGroupMembers` before the player return | **Leftover.** B16-D named this. Brief said the player return stays. Reviewer probe: `IsInRaid` true + count API nil → grouped, then `false, "unit not found"`. |
| No client / two-client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. A05 stays NOT RUN. |
| Gate W / Gate V stay OPEN; not signed | **On contract.** This review does not sign either. |

B18-INT glue is not required. `Clear` already went through `resolveUnit`; this lane pins that path.

---

## Isolation / Clear / gates

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Runtime + Markers. No `dofile` of Knighting / Gora / Store / UI shell / Net. Standalone wrap is still 27 nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Decree, slash). Reviewer probe: UI / DB / Net / Gora / Knighting / Console / Store / Hud / Inputs / FighterCard are nil at load. Wrap is load-time only (unchanged).

**Clear — Pass.** After Event / Pope / name / grouped, `Clear` calls `resolveUnit(trimmed)` then `applyMark(unit, 0)`. The player token is the B16-D return, not a Clear special-case. Raid self-clear no longer depends on `raid1`. Other names still scan. `pcall(SetRaidTarget, unit, 0)`.

**Gates — Pass.** Quiet / missing Runtime / unlisted Pope / ungrouped still refuse before resolve. `isGrouped` is unchanged (`IsInRaid` / `IsInGroup` / `GetNumGroupMembers`). Target does not call `resolveUnit`.

---

## Strengths

- Pin-only lane. Production already inherited `resolveUnit`; the packet does not rewrite Mark, Target, or glue.
- Grouped self-clear is pinned against the `raid1` alias `armRaid` installs, so a scan-only regression cannot hide.
- Quiet / ungrouped refuse re-uses the local name Beefina so the player return cannot skip those gates.
- B16-D `MarkCandidate` / `MarkFighters` player pins were left in place immediately above the new block. Party `Chuckroast` → `party1` stays.
- Isolation wrap, combat / GuildPromote source bans, and Target ungrouped pin stay. No new main-chunk locals.
- Writer-reported **342 / 0** matched the re-run. Pre-lane **319 / 0** plus the new block (**23** asserts, including three `reset()` pairs) is the arithmetic.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

None.

### Nit

1. **Party `Clear("Beefina")` is unpinned.** Probe: grouped party self-clear spies `"player", 0`. Brief scoped raid `armRaid` plus existing party Mark pins.

2. **Unlisted Pope `Clear("Beefina")` is unpinned.** Probe: `"not a registered pope"`, no spy. Brief named Quiet / ungrouped.

3. **Type-guard still requires `GetNumGroupMembers` before the player return.** Probe: `GetNumGroupMembers = nil` with `IsInRaid` true is grouped, then `false, "unit not found"`. B16-D leftover; brief said that return stays.

4. **Case / realm / trim on Clear are unpinned.** Probe: `"beefina"`, `Beefina-Whitemane`, and `"  Beefina  "` still spy `"player", 0` and record the trimmed name. Inherited from `namesSame` / `parseName`.

5. **Isolation wrap is load-only.** Twenty-seven pins under `if standalone then` at file load. There is no end wrap after Sender / API stubs. Brief said the wrap stays; it did.

6. **Exclusive-pair diff is not a vs-HEAD add.** Both exclusive files are untracked. Packet is the B18-D-only test hunk. `Markers.lua` is listed exclusive and correctly unchanged. Report already says this.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **342 / 0** was re-run here. A05 (Anniversary marker write) stays NOT RUN.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **342 passed, 0 failed.** Isolation wrap: **27**.

Grouped + Pope + Event `Clear("Beefina")` spies `SetRaidTarget("player", 0)`. Quiet / ungrouped Clear of that name still refuse and do not spy. B16-D Mark player pins stay. `resolveUnit` player return stays. Target is unchanged. Party scan pins stay. Event + Pope + grouped still required. Isolation stays wow_ui_stub + Common + Runtime + Markers. Isolated `lua tests/test_markers.lua` **342 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
