Spec PASS

# B21-A — Presence fail-opens until Roster is complete (review)

**Quality:** Approved-with-nits

**Lane:** B21-A Presence fail-opens until Roster is complete
**Brief:** `docs/reformation/vestments/briefs/B21-A-presence-seed.md`
**Writer report:** `docs/reformation/vestments/briefs/B21-A-presence-seed-report.md`
**Diff:** `docs/reformation/vestments/briefs/B21-A-presence-seed.diff` (B21-A-only exclusive-pair packet; live `Console.lua` also carries earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`GetPresence` after the member walk, `presentCharacterIds` left as the B19-A Store-id fail-open, `presenceLine` / `onPresenceClick` / empty copy), and `tests/test_console.lua` (flipped B19-A incomplete Presence pins, `runB21A()` nested inside `runB8E()` after `runB20A()`); then ran `lua tests/test_console.lua` (**1585 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.2 (present-and-alive pool); B19-A leftover (`presentCharacterIds` fail-opens Store ids while Roster is ready but not complete; `GetPresence` still listed seed members only); `GetPresence` fail-open Store append `here = false`; complete member walk stays; flip the two B19-A not-fail-open pins; no `UnitIsDead`; nested pins. Isolation stays the console suite. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit Roster, Gora, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Incomplete seed still lists members only (B19-A leftover) | **Pass. Verified.** After the member walk, complete is `IsComplete() == true` when that method exists, else `Roster.complete == true`. `complete ~= true` appends Store snapshot characters whose `nameKey` is not already in the rows, `here = false`. Flipped B19-A pins and `runB21A`: members only Beefina, Store also Chuckroast → `#GetPresence() == 2`, Chuckroast `here == false` and carries `characterId`. Reviewer probe: unlinked Store `Orphan` also appends `here = false`. |
| Complete path fail-opens or drops the member walk | **Pass.** Field `complete = true` and `IsComplete` → true skip the append. Pins: one member, `here == true`, seed `characterId` kept. B19-A complete pin still `# == 1` / Beefina. Reviewer probe: complete roster with Ghostbeef (unlinked) + extra Store chars still lists only the two members; Chuckroast / Orphan stay off. |
| Missing / `ready ~= true` / non-table `members` no longer `{}` | **Pass.** Those three returns sit before the walk and the append. Pins: `Roster = nil`, `ready = false`, `members = "nope"` → `#GetPresence() == 0`. |
| Store-only rows invented as `here = true`, or ranks / guild rank invented | **Pass. Verified.** Appended rows set `here = false`, `guildRankIndex = nil`, and copy Store human rank the same way the member walk does (`rankId` / `rankTitle` / `needsKnighting` / `humanId`). Pins: Chuckroast rank 3 / Beef Knight / `needsKnighting == false`. Reviewer probe: unlinked Store char has `rankId` / `humanId` nil. |
| Complete member walk lost (unlinked roster names dropped) | **Pass.** The existing `pairs(Roster.members)` walk still runs first and still sets `here = true`. Reviewer probe: Ghostbeef stays on both complete and fail-open; `characterId` nil. |
| B19-A not-fail-open pins not flipped | **Pass.** Packet replaces the two incomplete asserts (`# == 1` / "members only") with `# == 2`, seed `here == true`, Chuckroast `here == false` + `characterId`. Complete-path `# == 1` stays. |
| `presentCharacterIds` rewritten | **Pass.** Exclusive-pair diff does not touch it. Live helper is still the B19-A Store-id fail-open (all snapshot ids, then return) vs member-name filter when complete. Reviewer probe: incomplete still yields three petitions; complete filters to the member. |
| `UnitIsDead` / invented alive scrape | **Pass.** Source has no `UnitIsDead`. Fail-open is Store snapshot names, `here = false`. No new empty-state copy. No `"DEMANDED"`. |
| `SaveNote` defined / second Dismiss / `"  names  "` rewritten | **Pass.** `Console.SaveNote` is nil at the start and end of `runB21A`. Source has no `function Console:SaveNote`. Walk pin: one Dismiss. Source pin: `left .. "  names  " .. right` stays. Empty copy `"No one on the roster yet."` stays. |
| Click does not select the fail-open Store `characterId` | **Pass. Verified.** Live `onPresenceClick` is `SelectHuman` then `SelectCharacter` then Refresh. Pin: `stub.fire` OnClick sets `selectedCharacterId` and `selectedHumanId`. Reviewer spy: one `SelectCharacter` with Chuckroast's id; one `SelectHuman` with the Store human; Refresh ≥ 1. |
| New main-chunk locals / Lua 5.1 200-local | **Pass.** Packet adds a file-header comment and `local function runB21A()` nested inside `runB8E()` after `runB20A()`. No new main-chunk locals in the suite. Isolated suite loaded on Lua **5.1.5** with no `too many local variables`. |
| Isolation wrap broken | **Pass.** Load list unchanged: wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. Standalone wrap is still **17** nils at file load. `runB21A` re-pins Archive + Quiet shell + Toasts + Confession + `COB.Popes`. Reviewer probe: those 17 keys are nil at load. |
| Exclusive file breach (Roster / Gora / glue) | **Pass.** Provided packet is two `diff --git` hunks (GetPresence append + header comment; flipped B19-A pins + nested `runB21A`). `presentCharacterIds` / `presenceLine` / Dismiss bodies are not in the packet. `Roster.lua` is clean vs HEAD. Sibling dirt vs HEAD (`Gora.lua`, earlier Console batches) is other lanes. |
| Isolated suite not exit 0 | **Pass. Verified.** 1585 passed, 0 failed. Writer-reported count matches. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Roster / Gora / glue; no commit; `SaveNote` stays nil; no `UnitIsDead`; no new empty copy; no `"DEMANDED"` | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** Load list unchanged. Load wrap still **17** nil-module pins under `if standalone then`. |
| Missing / `ready ~= true` / `members` not a table → `{}` | **Pass.** Named-risk check. |
| Roster complete: keep the current member walk (`here = true`, unlinked roster names stay) | **Pass.** Named-risk check. Complete-path Presence stays one member when members only Beefina. |
| Ready but not complete: keep that member walk, then append Store snapshot characters whose name key is not already in the rows (`here = false`) | **Pass.** Named-risk check. Ready-without-complete (seed) is the same append. |
| Complete detection: `type(Roster.IsComplete) == "function"` and `Roster:IsComplete() == true`, else `Roster.complete == true` | **Pass.** Live source matches `presentCharacterIds`. Field pin and method pin both sit in `runB21A`. Source pins name both gates. |
| Copy Store human rank the same way the member walk does; do not invent they are in the room; do not invent guild rank; no alive scrape | **Pass.** Named-risk check. |
| Do not rewrite `presentCharacterIds`; do not change `"No one on the roster yet."`; do not add a second Dismiss; Recommend `"  names  "` stays parked | **Pass.** Named-risk check. |
| Flip the two B19-A asserts that say GetPresence is not fail-open; complete-path Presence stays one member | **Pass.** Named-risk check. |
| Incomplete seed (members only Beefina, Store also Chuckroast): `GetPresence` lists both; Chuckroast `here == false` and carries `characterId` | **Pass.** Flipped B19-A pins and `runB21A` both cover it. |
| Clicking a fail-open Store row selects that `characterId` | **Pass.** Named-risk check. |
| Nest new pins in `runB8E()` / a nested function; no new main-chunk locals | **Pass.** `runB21A()` inside `runB8E()` after `runB20A()`. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **1585 / 0.** |

Bible §10.2 holds as the brief scoped it: the login seed must not leave Presence looking empty while petitions already show Store people. `Roster:IsComplete` exists so that window is detectable. Fail-open is Store snapshot names with `here = false`, not an alive scrape. Law 4 holds: the desk does not invent presence, ranks, or `"DEMANDED"`. Law 10 holds: stock desk.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Recommend `"  names  "` stays parked | **On contract.** Brief: recommend it stays parked. Source pin names the token. |
| Desk `after()` double cue stays parked | **On contract.** Batch 21 overview parks it. This lane did not touch it. |
| No client smoke; login seed vs `GUILD_ROSTER_UPDATE` complete flip unproven on Anniversary; harness `OnClick` is a stub fire | **Not a miss.** Brief asked the isolated suite. |
| Fail-open is not an alive scrape; Store-only rows can appear `here = false` even if dead or not in the room | **On contract.** Brief: do not invent an alive scrape; no `UnitIsDead`. |
| Empty Store snapshot still yields members only | **On contract.** Append walks `snap.characters`; it does not invent ids. Probe: missing `Snapshot` → members only. |
| Isolation does not load `Roster.lua`; complete is stubbed | **On contract.** Brief said the wrap stays. Real `Roster:IsComplete` is not loaded here. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

B21-INT glue is not required. `onPresenceClick` already selects `row.characterId`. `GetPetitions` still uses `presentCharacterIds()`, which this lane was told not to rewrite.

---

## Isolation / fail-open / complete

**Isolation wrap — Pass.** Nine `dofile`s unchanged. Standalone wrap is still 17 nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). `runB21A` assigns `COB.Roster` stubs; `reset()` nils Roster again.

**Fail-open — Pass.** Ready + table `members` + not complete walks members (`here = true`), then appends unseen Store snapshot names (`here = false`). Incomplete seed and ready-without-complete both list Beefina + Chuckroast. Reviewer probe: name-key collision does not duplicate Beefina; empty `members` fail-opens every Store char as `here = false`; `IsComplete` returning false / `"true"` fail-opens even when the `complete` field is true (method wins, gate is `== true`).

**Complete / not-ready — Pass.** Field `complete = true` and `IsComplete` → true keep the member walk and skip the append. Missing Roster, `ready = false`, and non-table `members` still return `{}` before the walk. `presentCharacterIds` is unchanged.

---

## Strengths

- The append sits after the existing member walk and before `table.sort`. Complete path cannot reach Store-only rows; the walk cannot be skipped on the seed path.
- Detection is a copy of `presentCharacterIds`: method `== true` first, else `Roster.complete == true`. Harness stubs that set the field keep working.
- Store-only rows refuse to invent the room (`here = false`) and refuse to invent a guild rank. Rank copy matches the member walk, including the name fallback when `humanId` is missing.
- The two B19-A leftover asserts were flipped in place, then `runB21A()` re-pins the same seed plus rank / click / empty / `"  names  "`. Complete-path Presence stays one member.
- `runB21A()` is nested inside `runB8E()` after `runB20A()` the way the 200-local cap requires. No new main-chunk locals. Isolation wrap and `SaveNote` / SUMMON / parchment / tabs / `DEMANDED` / `UnitIsDead` source pins stay.
- Writer-reported **1585 / 0** matched the re-run. Writer-reported red (**1566 / 19**) matches 1566+19=1585: the fail-open count / Chuckroast `here` / click / `here = false` source pins that member-only `GetPresence` would fail. Missing / not-ready / complete `{}` / one-member pins were already green.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Fail-open is not present-and-alive.** Every unseen Store snapshot character can appear on Presence with `here = false` until complete, including dead or offline people. Brief banned `UnitIsDead`. That is the hole this lane was told not to close. B19-A leftover #1 (Presence still member-only while petitions fail-open) is closed.

### Nit

1. **`presenceLine` ignores `here`.** Painted Store-only is `Chuckroast  Beef Knight` with no away token. Brief scoped the `here = false` field and forbade new empty-state copy; it did not ask to paint `here`. Probe: label has no `here` / `away`.

2. **`IsComplete` false / nil / non-true while `complete = true` is unpinned.** Probe: method wins and fail-opens. Live `Roster:IsComplete` is `ready and complete`, so a real snapshot will not disagree with the field. Isolated stubs can.

3. **Empty `members` and missing snapshot are unpinned.** Probe: ready-not-complete + `members = {}` → three Store rows, all `here = false`. Missing `Snapshot` → members only. Writer leftover already names the empty snapshot.

4. **Unlinked roster stay and unlinked Store char (no human) are unpinned.** Probe: Ghostbeef stays `here = true` with nil `characterId` on both complete and fail-open; Orphan appends `here = false` with nil `rankId` / `humanId`.

5. **B19-A complete-path message still says `"GetPresence is not fail-open"`.** That is the complete pin, not one of the two incomplete leftover asserts the brief said to flip. Accurate for complete.

6. **Source pin `here = false` also matches the file-header comment** added in this packet. The assign in `GetPresence` is live.

7. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. `runB21A` assigns `COB.Roster` stubs. Brief said the wrap stays; it did.

8. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B21-A-only append + flipped / nested pins. `git diff HEAD` on the two files still includes earlier console batches. Report already says this. `Gora.lua` is dirty vs HEAD and is not in the packet.

9. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **1585 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **1585 passed, 0 failed.** Isolation wrap: **17**.

`GetPresence` still returns `{}` when Roster is missing, not ready, or `members` is not a table. Complete keeps the member walk (`here = true`). Ready but not complete keeps that walk, then appends unseen Store snapshot characters with `here = false` and copied Store human rank. The two B19-A not-fail-open pins are flipped. `presentCharacterIds` is unchanged. `SaveNote` stays nil. No `UnitIsDead`. New pins are nested in `runB8E()`. Isolated `lua tests/test_console.lua` **1585 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
