Spec PASS

# B19-A — Petitions fail-open until Roster is complete (review)

**Quality:** Approved-with-nits

**Lane:** B19-A Petitions fail-open until Roster is complete
**Brief:** `docs/reformation/vestments/briefs/B19-A-roster-complete.md`
**Writer report:** `docs/reformation/vestments/briefs/B19-A-roster-complete-report.md`
**Diff:** `docs/reformation/vestments/briefs/B19-A-roster-complete.diff` (B19-A-only exclusive-pair packet; live `Console.lua` also carries earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`presentCharacterIds` after the ready / members empty return), and `tests/test_console.lua` (`runB19A()` nested in `runB8E()` after `runB18B()`, plus earlier `ready = true` petition pins that omit `complete`); then ran `lua tests/test_console.lua` (**1438 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.2 (present-and-alive pool); `Roster:IsComplete` so “not in members” is not a refusal during the login seed; fail-open Store character ids while Roster is not complete; complete keeps the member-name filter; not-ready `{}`; no `UnitIsDead`; `SaveNote` nil; nested pins. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit Roster, Gora, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Seed snapshot still hides every petitioner who is not the local player | **Pass. Verified.** After ready / members, complete is `IsComplete() == true` when that method exists, else `Roster.complete == true`. `complete ~= true` marks every Store snapshot character id and returns. Pins: `complete = false` and ready-without-complete, members only `beefina`, two petitions. Reviewer probe: a third Store petitioner who is not a member also appears until complete. |
| Complete path drops the member-name filter | **Pass.** `complete = true` (field) and `IsComplete` → true both keep one of two. Probe: three petitioners, members only Beefina → `#GetPetitions() == 1` and that id is the member. `byKey` / `Roster.members` walk is unchanged after the new return. |
| Missing / `ready ~= true` / non-table `members` no longer `{}` | **Pass.** Those three returns sit before complete detection. Pins: `Roster = nil`, `ready = false`, `members = "nope"` → `#GetPetitions() == 0`. |
| `GetPresence` rewritten or fail-opens | **Pass. Verified.** Exclusive-pair diff does not touch `GetPresence`. Live function still walks `Roster.members` only; no `IsComplete` / `complete`. Pins and probes: fail-open petitions are 2 (or 3); Presence stays the member row(s). Empty copy `"No one on the roster yet."` stays. |
| `UnitIsDead` / invented alive scrape | **Pass.** Source has no `UnitIsDead`. Fail-open is Store ids only. No new empty-state copy. No `"DEMANDED"`. |
| `SaveNote` defined | **Pass.** `Console.SaveNote` is nil at the start and end of `runB19A`. Source has no `function Console:SaveNote`. Probe: still nil. |
| Nested pins / main-chunk locals / Lua 5.1 200-local cap | **Pass.** `local function runB19A()` sits inside `runB8E()` after `runB18B()`. Packet adds no main-chunk `local`. Suite still exits 0. |
| Isolated suite not exit 0 | **Pass. Verified.** 1438 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two `diff --git` hunks (complete detection + Store-id fail-open; nested `runB19A` pins). `Roster.lua` is clean vs HEAD. Sibling dirt in this workspace is other lanes (Gora favor / last-sanctioned, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Roster / Gora / glue; no commit; `SaveNote` stays nil; no `UnitIsDead`; no new empty copy | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** Load list unchanged: wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. Load wrap still **17** nil-module pins under `if standalone then`. |
| Missing / `ready ~= true` / `members` not a table → `{}` | **Pass.** Named-risk check. |
| Ready but not complete → every Store snapshot character id | **Pass.** `complete ~= true` walks `#chars` and sets `set[id] = true`. Pins cover `complete = false` and ready-without-complete. |
| Complete → current member-name filter | **Pass.** Named-risk check. |
| Complete detection: `type(Roster.IsComplete) == "function"` and `Roster:IsComplete() == true`, else `Roster.complete == true` | **Pass.** Live source matches the brief. Field pin and method pin both sit in `runB19A`. Source pins name both gates. |
| Existing `ready = true` petition pins that omit `complete` stay green | **Pass.** Pre-B19-A desks at the named-petition / Recommend / rite-verb blocks still expect present petitioners. Fail-open keeps them visible. Reviewer probe: ready-without-complete with all three names still returns 3. |
| Do not rewrite `GetPresence`; do not change `"No one on the roster yet."`; do not invent `"DEMANDED"` | **Pass.** Named-risk check. `"No petitions."` also stays. |
| Nest new pins in `runB8E()` / a nested function; no new main-chunk locals | **Pass.** Named-risk check. |
| `lua tests/test_console.lua` exit 0 | **Pass.** **1438 / 0.** |

Bible §10.2 (present-and-alive pool) holds as the brief scoped it: the login seed must not refuse “not in members.” `Roster:IsComplete` exists so that window is detectable. Fail-open is Store ids, not an alive scrape. Law 4 holds: the desk does not invent petitions, copy, or `"DEMANDED"`.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client / two-client smoke; login seed vs `GUILD_ROSTER_UPDATE` complete flip unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. |
| Fail-open is not an alive scrape; dead Store petitioners can still show until complete | **On contract.** Brief: do not invent an alive scrape; no `UnitIsDead`. |
| `GetPresence` still member-filters while incomplete | **On contract.** Brief: do not rewrite `GetPresence`. |
| Empty Store snapshot still yields `{}` | **On contract.** Fail-open walks `snap.characters`; it does not invent ids. Probe: ResetForTests store + ready-not-complete → 0. Missing `Snapshot` also → 0. |
| Isolation does not load `Roster.lua`; complete is stubbed | **On contract.** Brief said the wrap stays. Real `Roster:IsComplete` is `ready and complete`; the method pin stubs the return. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

`GetPetitions` is still `Gora:GetPetitions(presentCharacterIds())`. Unpetitioned Store ids in the fail-open set do not appear as rows. B19-INT glue is not required.

---

## Isolation / fail-open / complete

**Isolation wrap — Pass.** Standalone wrap is still 17 nils at file load (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). `runB19A` re-pins Archive / UI / Toasts / Popes.

**Fail-open — Pass.** Ready + table `members` + not complete marks every snapshot `id`. Two Store characters petitioned; members only the local name → both petitions. Ready-without-complete (the harness shape of the login seed) is the same. Probe: `IsComplete` returning false / nil / `"true"` fail-opens even when the `complete` field is true (method wins, gate is `== true`).

**Complete / not-ready — Pass.** Field `complete = true` and `IsComplete` → true keep the member filter. Missing Roster, `ready = false`, and non-table `members` still return `{}` before the new branch. `GetPresence` is unchanged.

---

## Strengths

- The new branch is thirteen lines after the existing empty return and before `byKey`. Failed-open path cannot reach the member filter; complete path cannot skip it.
- Detection matches the brief exactly: method `== true` first, else `Roster.complete == true`. Harness stubs that set the field keep working; a live `Roster:IsComplete` is used when the function exists.
- `runB19A()` is nested after `runB18B()` the way the 200-local cap requires. No new main-chunk locals. `SaveNote` / SUMMON / parchment / tabs / `DEMANDED` source pins stay.
- Existing `ready = true` petition pins were left in place and stay green under fail-open.
- Writer-reported **1438 / 0** matched the re-run. Writer-reported red count (**1431 / 7**) matches the four fail-open asserts plus the three complete-detection source pins; not-ready `{}` and the complete filter were already green.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`GetPresence` still lists only seed members while petitions fail-open.** Reviewer probe: two or three Store petitioners, Presence stays one row (`Beefina`). Brief forbade a `GetPresence` rewrite. The seed window can still look empty on Presence.

2. **Fail-open is not present-and-alive.** Every Store snapshot character id is marked until complete. Dead or offline petitioners with a live petition can still show in that window. Brief banned `UnitIsDead`. That is the hole this lane was told not to close.

### Nit

1. **`IsComplete` false / nil / non-true while `complete = true` is unpinned.** Probe: method wins and fail-opens. Live `Roster:IsComplete` is `ready and complete`, so a real snapshot will not disagree with the field. Isolated stubs can.

2. **Empty / missing snapshot is unpinned.** Probe: ResetForTests store, or `Store.Snapshot` nil, ready-not-complete → `#GetPetitions() == 0`. Writer leftover already names this.

3. **Fail-open uses `if id then`, not `isId`.** Store `listCopy` rows carry numeric ids. A row without `id` is skipped. A hole in `chars` would error on `chars[i].id`. Not a Store path.

4. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. `runB19A` assigns `COB.Roster` stubs; `reset()` nils Roster again. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B19-A-only complete branch + pins. `git diff HEAD` on the two files still includes earlier console batches. Report already says this. `Gora.lua` is dirty vs HEAD (favor / last-sanctioned) and is not in the packet.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **1438 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **1438 passed, 0 failed.** Isolation wrap: **17**.

`presentCharacterIds` still returns `{}` when Roster is missing, not ready, or `members` is not a table. Ready but not complete fail-opens every Store snapshot character id. Complete (`IsComplete() == true`, else `complete == true`) keeps the member-name filter. `GetPresence` is unchanged. `SaveNote` stays nil. No `UnitIsDead`. New pins are nested in `runB8E()`. Isolated `lua tests/test_console.lua` **1438 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
