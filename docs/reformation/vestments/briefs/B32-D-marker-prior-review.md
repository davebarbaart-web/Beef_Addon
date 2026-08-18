Spec PASS

# B32-D — New raid mark clears the previous subject (review)

**Quality:** Approved-with-nits

**Lane:** B32-D New raid mark clears the previous subject
**Brief:** `docs/reformation/vestments/briefs/B32-D-marker-prior.md`
**Writer report:** `docs/reformation/vestments/briefs/B32-D-marker-prior-report.md`
**Diff:** `docs/reformation/vestments/briefs/B32-D-marker-prior.diff` (B32-D-only exclusive-pair packet; live `Markers.lua` / `test_markers.lua` are still untracked vs HEAD and also carry earlier Markers batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Markers.lua` (`clearPrior`, `MarkCandidate` / `MarkFighters` call sites after resolve, `applyMark`, `Clear` / `Target` / `resolveUnit` / `remember` / `refuse`), and `tests/test_markers.lua` (source `clearPrior` / no `UnitIsDead` / Mark* body extract, first-mark one spy, same-name remake, A then B, MarkFighters after outsider, MarkCandidate after fighters, in-pair keep-set, player prior, Quiet / ungrouped refuse-after-live, B16-D / B18-D / B22-C pins, isolation wrap); then ran `lua tests/test_markers.lua` (**438 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §8 (marks on the **current** candidate / fighters); Law 5 (Pope client); Law 6 (Quiet refuse); B22-C leftover (Mark* never cleared the remembered prior unit). New mark `applyMark`s index `0` on remembered `last.unit` / `last.unitA` / `last.unitB` that are not in the new keep-set. Do **not** call `Markers:Clear` (it overwrites `last` first). Same-unit remake does not extra-clear. First Mark* with no prior memory still one spy. No `UnitIsDead`. No SecureActionButton. No combat automation. Anniversary `SetRaidTarget(target, userIndex)` — index `0` already clears (existing `Clear`). Isolation wow_ui_stub + Common + Runtime + Markers only. Did not mutate `Markers.lua` or `test_markers.lua`. Did not commit. Did not edit glue, Console, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| New Mark* does not clear the remembered prior (missing clear) | **Pass. Verified.** Live `clearPrior(keepUnits)` sweeps `last.unit` / `last.unitA` / `last.unitB` through existing `applyMark(unit, 0)` when the token is not in the keep-set. `MarkCandidate` / `MarkFighters` call it after resolve, before the new `applyMark`. Pin: A then B spies `{raid2, 0}` then `{raid3, 1}`. MarkFighters after outsider candidate spies `{raid4, 0}` then 2 / 3. MarkCandidate after fighters spies both fighters at `0` then the new star. Reviewer probe: same three sequences; Chuckroast then Beefina spies `{raid2, 0}` then `{player, 1}`; fighters A+B then A+C spies `{raid3, 0}` then `{raid2, 2}` `{raid4, 3}`; fighters then candidate-A spies `{raid3, 0}` then `{raid2, 1}` (B cleared, A remade, no extra `0` on A). |
| Mark* calls `Markers:Clear` and overwrites `last` | **Pass. Verified.** `debug.getupvalue`: `clearPrior` is an upvalue of `MarkCandidate` and `MarkFighters` only. `Clear` has `applyMark` / `remember`, not `clearPrior`. Mark* bodies have no `:Clear(`, `Markers.Clear`, or `self:Clear`. Reviewer wrap of `Markers.Clear` stayed **0** across first mark, remake, A then B, outsider fighters, overlapping keep-set, player prior, and refuse-after-live. `SetRaidTarget` still lives only in `applyMark`. |
| Same-unit remake extra-clears / first mark extra spy | **Pass. Verified.** Keep-set includes the new token, so remake skips that sweep. First `MarkCandidate` is still one spy (`raid2`, 1). Same-name remake is a second `{raid2, 1}` with `#raidTargets == 2`. First `MarkFighters` is still two spies (2 then 3), no extra `0`. In-pair candidate then fighters is two spies (2 / 3), no extra `0`. Reviewer probe: fighters remake of the same pair is two spies; candidate-B then fighters keeps B (no extra `0`); `Target` then `MarkCandidate` is still one spy. |
| Fail-closed gates now clear a live prior | **Pass. Verified.** `clearPrior` sits after Quiet / Pope / name / grouped / resolve. Pins: Ghost remake, Quiet after a live mark, and ungrouped after a live mark leave the spy count unchanged. Reviewer probe: unlisted Pope after a live mark is `"not a registered pope"`, no spy; `MarkFighters("Chuckroast", "Ghost")` after a live candidate is `"unit not found"`, no spy. |
| `UnitIsDead` / SecureActionButton / combat automation | **Pass.** Source has none of `UnitIsDead`, `SecureActionButton`, `StartAttack`, `AttackTarget`, `AssistUnit`, `CastSpell`, `UseAction`, `GuildPromote`, `SetGuildMemberRank`, or `CreateFrame`. Suite `combatCalls` / chat / addon / sounds stay 0. Reviewer probe: combat flag + A then B still `combatCalls == 0`. |
| `"player"` resolve / existing Quiet / ungrouped / party / B16-D / B18-D / B22-C pins drop | **Pass.** `resolveUnit` player return and `Clear` / `Target` are unchanged in the packet. Existing pins stay above or beside the B32-D block. Player prior pin: `{player, 0}` then `{raid2, 1}`. |
| Isolated suite not exit 0 | **Pass. Verified.** 438 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Provided packet is two hunks: `clearPrior` + two Mark* call sites, and the test pins (`UnitIsDead` refuse, `clearPrior` helper, Mark* body extract, B32-D behavior). Sibling dirt vs HEAD (Console, Hud, Confession, TOC, bootstrap, `run.lua`) is other lanes, not this packet. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue / Console; no commit | **Pass.** Named-risk check. |
| Isolation stays wow_ui_stub + Common + Runtime + Markers | **Pass.** Three `dofile`s unchanged. Wrap is still **27** nil-module / slash pins under `if standalone then`. |
| Before a successful new mark, `applyMark` index `0` on remembered `last.unit` / `last.unitA` / `last.unitB` not in the keep-set | **Pass.** Named-risk check. |
| Do not call `Markers:Clear` (it overwrites `last` first) | **Pass.** Named-risk check. |
| Same-unit remake does not clear-then-mark | **Pass.** Named-risk check. |
| First Mark* with no prior memory still one spy | **Pass.** First `MarkCandidate` is one spy. First `MarkFighters` stays two apply spies (no extra `0`). |
| Fail-closed gates stay (quiet / not pope / ungrouped / unit not found) | **Pass.** Named-risk check. |
| `"player"` resolve stays; B16-D / B18-D / B22-C / party / Quiet / ungrouped pins stay | **Pass.** Named-risk check. |
| No `UnitIsDead`; no SecureActionButton; no combat automation; existing `pcall(SetRaidTarget, …)` stays | **Pass.** Named-risk check. `applyMark` body is unchanged. |
| `lua tests/test_markers.lua` exit 0 | **Pass.** **438 / 0.** |

Bible §8 (marks on the current candidate / fighters) and Law 5 / Law 6 hold on the exclusive pair. The B22-C leftover (Mark* never cleared the remembered prior) is closed on the happy path the brief named. wow-api `classic_anniversary`: `SetRaidTarget(target, userIndex)` and `GetRaidTargetIndex(target)` exist. Index `0` is the existing `Clear` path. Wiki `API SetRaidTarget` documents Retail `#protected` / SecureActionButton as of Patch 12.0.0 — not Anniversary `20506`. Brief forbids `SecureActionButton`; they kept `pcall`.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; Anniversary `SetRaidTarget(unit, 0)` on a remembered prior token is unsmoked | **Not a miss.** Brief asked the isolated suite. Reviewer spy proves the `0` then new-index order; it does not prove pixels or raid-assist. |
| `refuse` overwrites `last`, so A then Ghost then B cannot clear A | **On contract.** Brief clears *remembered* tokens. Fail-closed unit-not-found must not clear. A-then-B is a fresh `reset()` after the Ghost pin. Out of this lane's `refuse` / `remember` rewrite. |
| `clearPrior` ignores `applyMark(0)` failure and still applies the new mark; if the new `applyMark` then fails, the prior is already `0` and `refuse` overwrites `last` | **On contract.** Brief asked clear-then-mark after gates, not a two-phase commit. Reviewer probe: `0`-throw still marks B; new-index-throw leaves prior at `0` and `last` on the refuse. |
| Remembered tokens, not names; roster shuffle may `applyMark` `0` on a different person | **On contract.** Brief named `last.unit` / `last.unitA` / `last.unitB`. |
| Full `lua tests/run.lua` was not run | **Not a miss.** Brief asked the isolated suite. |
| Gate W / Gate V stay OPEN; not signed | **On contract.** This review does not sign the lane. |

B32-INT glue is not required. Mark* already go through `applyMark`.

---

## Isolation / clearPrior / gates

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Runtime + Markers. No `dofile` of Knighting / Gora / Store / UI shell / Net / Console. Standalone wrap is still **27** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Decree, slash). Wrap is load-time only (unchanged).

**clearPrior — Pass.** Helper is `local function clearPrior`. It does not call `Markers:Clear`. `seen` skips a token already swept. Keep-set is the newly resolved UnitToken(s). `SetRaidTarget` still lives only in `applyMark`. `Clear` still `applyMark(unit, 0)` and still overwrites `last`. Target is unchanged.

**Gates — Pass.** Quiet / missing Runtime / unlisted Pope / ungrouped / invalid name / unit-not-found still refuse before `clearPrior`. Event + Pope + grouped still required. `"player"` resolve stays.

---

## Strengths

- The leftover is closed on the existing apply path: one helper, index `0` through `applyMark`, keep-set so remake is not clear-then-mark. `Markers:Clear` is left alone so `last` still holds the prior tokens until the new mark remembers.
- First mark is still one spy. A then B, outsider-candidate then fighters, fighters then outsider candidate, in-pair keep, and player prior are pinned. Fail-closed remakes do not clear.
- `debug.getupvalue` shows `clearPrior` on Mark* only. A runtime wrap of `Markers.Clear` stayed at 0.
- B16-D / B18-D / B22-C / party / Quiet / ungrouped pins stay. Isolation wrap stays. No new main-chunk test locals (source extract is a `do`/`end`; `ok` / `err` reused).
- Packet does not rewrite `resolveUnit`, `applyMark`, `Clear`, `Target`, or `isGrouped`.
- Writer-reported **438 / 0** matched the re-run. Writer-reported red (**407 / 27**) matches a block that old Mark* (no `clearPrior`) would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Client `SetRaidTarget(unit, 0)` on a remembered prior token is unsmoked.** The suite cannot prove Anniversary clears the old raid icon, or that the Pope client has raid-assist. `wow_ui_stub` `SetRaidTarget` is a spy list. Brief scoped this lane to the isolated suite. Reviewer spy proves the `0` then new-index order; it does not prove pixels.

2. **`refuse` overwrites `last`.** A successful mark, then a fail-closed remake (`unit not found` / Quiet / ungrouped / unlisted Pope), then a new Mark* cannot clear the forgotten prior. Reviewer probe: Chuckroast then Ghost then Tendermage spies only `{raid3, 1}`. Out of this lane's `refuse` / `remember` rewrite.

### Nit

1. **`clearPrior` ignores `applyMark(0)` failure** and still applies the new mark. If the new `applyMark` then fails, the prior token is already index `0` and `refuse` overwrites `last`. Reviewer probe: `0`-throw still marks B; new-index-throw leaves prior at `0`.

2. **Remembered tokens, not names.** If the raid roster shuffles, `last.unit` may `applyMark` index `0` on a different person.

3. **Source pins are substrings.** `local function clearPrior` and Mark* `clearPrior` / no `:Clear(` would pass on a comment inside the extract. Live call is real (`clearPrior({ [unit] = true })`); reviewer upvalue + Clear wrap close the hole.

4. **Overlapping keep-set (fighters then candidate-A; A+B then A+C; fighters remake) is unpinned.** Brief named A then B, outsider fighters, and in-pair keep. Reviewer probe: those overlapping paths keep the in-set token and clear the rest.

5. **Successful `Clear` then Mark* of another unit re-applies `0` on the already-cleared remembered token.** Harmless. `Clear` still overwrites `last` with that unit.

6. **Wiki `API SetRaidTarget` toggle / Retail `#protected`.** Current wiki says the API toggles when the same icon is already assigned, and marks SetRaidTarget `#protected` as of Patch 12.0.0 with SecureActionButton. Anniversary `20506` catalog does not require that button. Brief forbids it. Same-icon remake is unsmoked.

7. **Isolation wrap is load-only.** Twenty-seven pins under `if standalone then` at file load. Brief said the wrap stays; it did.

8. **Exclusive-pair diff is not a vs-HEAD Markers delta.** Both exclusive files are untracked. Packet is the B32-D-only helper + pins. Report already says this.

9. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **438 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **438 passed, 0 failed.** Isolation wrap: **27**.

**Leftovers:**
- Client Anniversary `SetRaidTarget(unit, 0)` on a remembered prior token is unsmoked (Important, not must-fix).
- `refuse` overwrites `last`; A then Ghost then B cannot clear A (Important, not must-fix).
- `clearPrior` ignores `applyMark(0)` failure; a failed new `applyMark` has already cleared the prior.
- Remembered tokens, not names; roster shuffle may clear the wrong person.
- Source pins are substrings, not a `SetRaidTarget` spy on `clearPrior`.
- Overlapping keep-set paths are unpinned (reviewer probed; they hold).
- Successful `Clear` then Mark* of another unit re-applies `0` on the already-cleared token.
- Wiki toggle / Retail `#protected` / SecureActionButton is out of this Anniversary lane.
- Isolation wrap is load-only.
- Exclusive-pair packet is not a vs-HEAD Markers delta.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

Before a successful new Mark*, `clearPrior` `applyMark`s index `0` on remembered `last.unit` / `last.unitA` / `last.unitB` that are not in the new keep-set. Mark* do not call `Markers:Clear`. Same-unit remake does not extra-clear. First `MarkCandidate` is still one spy. Fail-closed gates do not clear. `"player"` resolve stays. No `UnitIsDead`. No SecureActionButton. No combat automation. Isolated `lua tests/test_markers.lua` **438 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
