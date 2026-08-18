Spec PASS

# B16-D — Markers resolve local player (review)

**Quality:** Approved-with-nits

**Lane:** B16-D Markers resolve local player
**Brief:** `docs/reformation/vestments/briefs/B16-D-markers-player.md`
**Writer report:** `docs/reformation/vestments/briefs/B16-D-markers-player-report.md`
**Diff:** `docs/reformation/vestments/briefs/B16-D-markers-player.diff` (B16-D-only exclusive-pair packet; live files are untracked vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Markers.lua` (`resolveUnit`), and `tests/test_markers.lua` (source pins + grouped player `MarkCandidate` / `MarkFighters` + party scan stay + Quiet / ungrouped / unlisted refuse); then ran `lua tests/test_markers.lua` (**319 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §8 (candidate / fighter marks); Law 5 (Pope client); Law 6 (Quiet refuse); Anniversary `SetRaidTarget(target, userIndex)` takes a UnitToken — `"player"` is valid. Isolation wow_ui_stub + Common + Runtime + Markers only. Did not mutate `Markers.lua` or `test_markers.lua`. Did not commit. Did not edit Knighting, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `resolveUnit` still never returns `"player"` when `UnitName("player")` names-same | **Pass. Verified.** After the API type-guard, `pcall(UnitName, "player")` then `namesSame(me, name)` returns `"player"` before `GetNumGroupMembers` / `partyN` / `raidN`. Pin: grouped + Pope + Event `MarkCandidate("Beefina")` spies `SetRaidTarget("player", 1)` and `unit ~= "raid1"`. Reviewer probe: same, index 1. |
| Event + Pope + grouped no longer required | **Pass.** `MarkCandidate` / `MarkFighters` still refuse Quiet / unlisted Pope / ungrouped before resolve. Pins cover Beefina on all three. Reviewer probe: same three strings, `#raidTargets == 0`. |
| Quiet / ungrouped Mark on the local name now `SetRaidTarget`s | **Pass.** Ungrouped Beefina is `"not in a group"`; Quiet Beefina is `"quiet"`. No spy. `isGrouped` still runs before `resolveUnit`. |
| `SetRaidTarget` called with a name token | **Pass.** `applyMark(unit, index)` still `pcall(SetRaidTarget, unit, index)`. Player path passes `"player"`. Other names stay `raidN` / `partyN`. Target still `TargetUnit(trimmed, true)` — reviewer probe: `Target("Beefina")` spies the name, `SetRaidTarget` count 0. |
| Party scan pins lost | **Pass.** Pre-lane `Chuckroast` → `party1` pin stays. B16-D re-pins it, then Beefina → `"player"` not `partyN`. |
| Isolated suite not exit 0 | **Pass. Verified.** 319 passed, 0 failed. Writer-reported count matches. |
| GuildPromote / combat automation / CreateFrame | **Pass.** Source has none. Suite `combatCalls` / chat / addon / sounds stay 0. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two `diff --git` hunks (four-line `resolveUnit` insert; suite source pins + B16-D block). Sibling dirt in this workspace is other lanes (Knighting, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Knighting / glue; no commit; no GuildPromote; no combat automation | **Pass.** Named-risk check. |
| Isolation stays wow_ui_stub + Common + Runtime + Markers | **Pass.** Three `dofile`s unchanged. Load wrap still **27** nil-module / slash pins under `if standalone then`. |
| `resolveUnit` returns `"player"` when `UnitName("player")` names-same | **Pass.** Named-risk check. Case / realm fold pins use `Names.Same`. |
| pcall the player read; missing `UnitName` stays fail-closed | **Pass.** Type-guard still requires `UnitName` as a function. Reviewer probe: `UnitName = nil` → `false, "unit not found"`, no `SetRaidTarget`. |
| Event + Pope + grouped still required | **Pass.** Named-risk check. |
| Quiet / ungrouped / unlisted Pope still refuse | **Pass.** Named-risk check. |
| Ungrouped Mark still refuses (`isGrouped`) | **Pass.** `isGrouped` before resolve on Mark / Clear. Target stays ungrouped-legal. |
| Target verb unchanged | **Pass.** Named-risk check. Existing ungrouped Target pin stays. |
| Party scan pins stay | **Pass.** Named-risk check. |
| Grouped + Pope + Event `MarkCandidate` / `MarkFighters` spy `SetRaidTarget("player", …)` | **Pass.** Star 1; fighters 2 / 3; other side stays `raid2` / `party1`. |
| Isolation wrap stays; no new main-chunk locals | **Pass.** Wrap untouched. B16-D block reuses `ok` / `err` / `view`. |
| `lua tests/test_markers.lua` exit 0 | **Pass.** **319 / 0.** |

Bible §8 (candidate / fighter marks on the Pope client) and Law 5 / Law 6 hold on the exclusive pair. Anniversary `SetRaidTarget` takes a UnitToken; `"player"` is a base token. `partyN` still excludes the player (Common `Group.CountGuildmates` already documents that); the new read is what makes a self-mark resolve.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| `Clear` inherits `resolveUnit` but is unpinned | **On contract.** Brief asked `MarkCandidate` / `MarkFighters`. Reviewer probe: grouped `Clear("Beefina")` spies `SetRaidTarget("player", 0)`. |
| No client / two-client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Gate W / Gate V stay OPEN; not signed | **On contract.** This review does not sign either. |

---

## Isolation / resolve / gates

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Runtime + Markers. No `dofile` of Knighting / Gora / Store / UI shell / Net. Standalone wrap is still 27 nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Decree, slash). Reviewer probe: UI / DB / Net / Gora / Knighting / Console / Store are nil at load. Wrap is load-time only (unchanged).

**Resolve — Pass.** Player token is tried after the existing `GetNumGroupMembers` / `UnitName` type-guard and before the party/raid scan. `namesSame` is `COB.Names.Same`. Raid self-mark no longer uses `raid1`. Party self-mark no longer `"unit not found"`. Other names still scan.

**Gates — Pass.** Quiet / missing Runtime / unlisted Pope / ungrouped still refuse before resolve. `isGrouped` is unchanged (`IsInRaid` / `IsInGroup` / `GetNumGroupMembers`). Target does not call `resolveUnit`.

---

## Strengths

- Four production lines, in the right function, before the scan. No new verb, no Target rewrite, no glue.
- Grouped self-mark is pinned on both raid and party, both `MarkCandidate` and `MarkFighters` (A and B), plus case / realm fold.
- Refuse pins re-use the local name Beefina so the new return cannot skip Quiet / ungrouped / unlisted Pope.
- Party `Chuckroast` → `party1` pin was left in place, then re-asserted.
- Isolation wrap, combat / GuildPromote source bans, and Target ungrouped pin stay. No new main-chunk locals.
- Writer-reported **319 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

None.

### Minor

1. **Source pin `pcall(UnitName, "player")` is not unique.** Live file has two hits: `localSender` (pre-lane) and `resolveUnit` (this lane). `src:find` would stay green if the resolveUnit read lost its pcall spelling. `return "player"` and `namesSame(me, name)` are unique.

2. **`Clear` player token is unpinned.** Probe: grouped `Clear("Beefina")` spies `"player", 0`. Brief scoped `MarkCandidate` / `MarkFighters`.

3. **Type-guard still requires `GetNumGroupMembers` before the player return.** Probe: `GetNumGroupMembers = nil` with `IsInRaid` true is grouped, then `false, "unit not found"`. Brief allowed fail-closed missing `UnitName`; this leftover guard also blocks a self-mark when only the count API is missing.

4. **Isolation wrap is load-only.** Twenty-seven pins under `if standalone then` at file load. There is no end wrap after Sender / API stubs. Brief said the wrap stays; it did.

5. **Party `MarkFighters` pin does not clear `raidTargets` first.** It reads `#raidTargets - 1` after two prior `MarkCandidate` spies. The values match; the index is brittle.

6. **Exclusive-pair diff is not a vs-HEAD add.** Both exclusive files are untracked. Packet is the B16-D-only hunk. Report already says this.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **319 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **319 passed, 0 failed.** Isolation wrap: **27**.

`resolveUnit` returns `"player"` when a pcalled `UnitName("player")` names-same the target. Event + Pope + grouped still required. Quiet / ungrouped / unlisted Pope still refuse. `SetRaidTarget` still takes the UnitToken. Party scan pins stay. Target is unchanged. Isolation stays wow_ui_stub + Common + Runtime + Markers. Isolated `lua tests/test_markers.lua` **319 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
