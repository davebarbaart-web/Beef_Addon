Spec PASS

# B32-B — Console Dismiss also reaches the confession inbox (review)

**Quality:** Approved-with-nits

**Lane:** B32-B Console Dismiss also reaches the confession inbox
**Brief:** `docs/reformation/vestments/briefs/B32-B-console-dismiss.md`
**Writer report:** `docs/reformation/vestments/briefs/B32-B-console-dismiss-report.md`
**Diff:** `docs/reformation/vestments/briefs/B32-B-console-dismiss.diff` (B32-B-only exclusive-pair packet; live `Console.lua` also carries earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`Dismiss` ~1672–1684 / stock Dismiss ~710 / `CallForward` / `Refresh` / `paintConfessions` / `SaveNote`), and `tests/test_console.lua` (isolation wrap, nested `runB32B()` inside `runB8E()` after `runB31A()`); then ran `lua tests/test_console.lua` (**2220 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: Bible §9 confession queue on the Pope console only; `Confession:Dismiss` already exists; one stock Dismiss; Gora path and `"gora is not available"` stay; also call `Confession:Dismiss` with the same id when that function exists; Refresh / true if either succeeded; isolated Gora-only when Confession is nil; no second button; no fan-out; no theater; `SaveNote` stays nil. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit Confession.lua, Dock, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Console:Dismiss` does not reach `Confession:Dismiss` when that function exists | **Pass. Verified.** Live body type-guards `COB.Confession` and `type(COB.Confession.Dismiss) == "function"`, then `COB.Confession:Dismiss(id)` with the same `id` as Gora. Nested stub records that id. Reviewer probe: `SelectCharacter` then `Console:Dismiss()` (no arg) and stock-button `OnClick` both pass the same id to Confession and Gora. |
| Gora path / `"gora is not available"` dropped; Confession called when Gora is missing | **Pass. Verified.** Early return still requires `COB.Gora.Dismiss`. Nested pin: `Gora.Dismiss = nil` → `nil, "gora is not available"`. Reviewer probe: Confession present and Gora missing does **not** call Confession. |
| Isolated Gora-only Dismiss broken when Confession is nil or has no `Dismiss` | **Pass.** Nested: `COB.Confession = nil` still returns true on a live petition; Confession table without `Dismiss` stays Gora-only and does not call a prior stub. |
| Second Dismiss button / per-row Dismiss / fan-out through `after()` | **Pass.** One `stockButton(right, "Dismiss", …)`. Walk count is 1. Confession rows stay click-select (`paintRowButtons` on `ConfessionChild`). Dismiss body has no `after(`. |
| Theater: `PlaySound` / `playCue` / Sound / Toasts / chat on Dismiss | **Pass.** Dismiss body has no `PlaySound` / `playCue`. Nested spies: Sound / Toasts / `SendChatMessage` stay 0 on dual-reach, either-succeeded, and Gora-only. |
| `SaveNote` defined; SUMMON / parchment / tabs | **Pass.** `Console.SaveNote` nil before and after the nested block. Source has no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `Parchment`, no `PanelTabButtonTemplate`. |
| CallForward pins dropped | **Pass.** Nested source pins `function Console:CallForward(characterId)` and `Confession:CallForward`. Live `CallForward` is unchanged. |
| New main-chunk locals / not nested in `runB8E()` after `runB31A()` | **Pass.** `runB32B()` is a nested `local function` inside `runB8E()` after `runB31A()`. Packet adds no main-chunk `local`. Header comment only at file top. `local id` is Dismiss-scoped. No new file locals in `Console.lua`. |
| Isolated suite not exit 0 / isolation wrap rewritten | **Pass. Verified.** 2220 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**17** nil pins). `runB32B()` re-pins 4 of them plus `COB.Popes`. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is header note + Dismiss dual-reach + nested `runB32B()`. Confession.lua remains untracked sibling dirt (B32-C exclusive); writer did not edit it. Dock / glue have no `Console:Dismiss`. Sibling dirt vs HEAD is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Confession.lua, glue; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| One stock Dismiss; no second button | **Pass.** Named-risk check. |
| `Dismiss` still requires Gora; `"gora is not available"` stays | **Pass.** Named-risk check. |
| If `COB.Confession.Dismiss` exists, call it with the same id | **Pass.** Named-risk check. |
| Refresh if either returns true; return true if either succeeded | **Pass.** Live: `if Confession:Dismiss(id) then ok = true end` then `if ok then self:Refresh()`. Nested: Confession success still returns true when Gora has no petition. |
| Missing Confession: Gora Dismiss still true | **Pass.** Named-risk check. |
| CallForward pins stay | **Pass.** Named-risk check. |
| No `PlaySound` / Toasts / chat / theater | **Pass.** Named-risk check. |
| `SaveNote` stays nil | **Pass.** Named-risk check. |
| Nest `runB32B()` inside `runB8E()` after `runB31A()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **2220 / 0.** |

Bible §9 holds on the exclusive pair: the confession queue is organized on the Pope console only. One stock Dismiss reaches `Confession:Dismiss` when that function exists. Law 4 / Law 6 hold: Dismiss does not invent `after()` theater, Sound, Toasts, chat, SUMMON, or `SaveNote`. Gora petition dismiss and the `"gora is not available"` refuse stay.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Confession.lua was not loaded or edited; isolated suite stubs Confession | **On contract.** Brief said stub `Dismiss` that records the id; isolated suite often has Confession nil. Real inbox removal is B32-C / a later Core pin. Reviewer probe (not in-lane): loading the sibling `Confession.lua`, `Receive`, then `Console:Dismiss` empties that queue. |
| Either-succeeded Refresh when Gora has no petition is console-only | **On contract.** Brief said Refresh / true if either succeeded. Desk does not grow a confession-only plate. |
| No client smoke; full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / reach / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Dock, glue, UI shell, Net, DB, or Confession. Standalone wrap is still **17** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Wrap is load-time only (unchanged). Nested B32-B re-pins Archive / UI / Toasts / Confession / Popes after restore.

**Reach — Pass.** `Dismiss` resolves one `id` (`characterId` or `selectedCharacterId`), calls `Gora:Dismiss(id)`, then `Confession:Dismiss(id)` when that function exists. Refresh / true if either succeeded. Stock button still calls `Console:Dismiss()` with no arg (selection path). Reviewer probe closed that path and the stock `OnClick`.

**Keep — Pass.** Gora-missing refuse stays and does not call Confession. Confession nil / Confession without `Dismiss` stays Gora-only. CallForward stays. One `UIPanelButtonTemplate` Dismiss. `SaveNote` nil. No SUMMON / parchment / tabs. No `after()` / Sound / Toasts / chat on Dismiss.

---

## Strengths

- The delta is the brief: one `local id`, Gora first, type-guarded Confession with the same id, Refresh / true if either succeeded. The Gora-missing refuse was left as an early return.
- Dual-reach, either-succeeded, Confession-without-`Dismiss`, missing Confession, and `"gora is not available"` sit next to each other, so a Gora-only rewrite or a Confession-only rewrite would fail.
- Dismiss still does not go through `after()`. One stock button. No second plate on the confession list.
- `runB32B()` is nested inside `runB8E()` after `runB31A()`. Isolation wrap was not rewritten. Writer-reported **2220 / 0** matched the re-run. Writer-reported red (**2210 / 10**) matches a missing `local id` / Confession type-guard / either-succeeded true.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Isolated suite still stubs Confession.** Brief asked a recording stub and a Gora-only keep when Confession is nil. Real `Confession:Dismiss` inbox removal is not an in-lane pin. Do not expand this exclusive pair to Confession.lua.

### Nit

1. **B32-B does not behaviorally pin `selectedCharacterId` or stock-button `OnClick`.** Source pin has `local id = characterId or self.selectedCharacterId`. Nested behavioral pins pass an explicit id. Reviewer probe closed both: selection and `OnClick` reach Confession and Gora with that id.

2. **Gora-missing + Confession-present is not an in-lane pin.** Nested refuse test runs after `COB.Confession = nil`. Reviewer probe: Confession present and `Gora.Dismiss` nil still returns `"gora is not available"` and does not call Confession.

3. **Both-false (Gora false and Confession false) is not pinned.** Reviewer probe: returns false. On contract with either-succeeded.

4. **Several “does not X” pins are string finds on the Dismiss body.** They would miss a computed `after` call. Reviewer walk of the live body closes that hole.

5. **Isolation wrap is load-only.** Seventeen pins under the first `if standalone then`. Nested B32-B re-pins four of them plus Popes. Brief said the wrap stays; it did.

6. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B32-B-only Dismiss reach + nested pins. `git diff HEAD` on the two files still includes earlier console batches. Report already says this.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **2220 / 0** was re-run here. Stock Dismiss on Anniversary (petition + inbox, same id) is unproven.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **2220 passed, 0 failed.** Isolation wrap: **17**.

`Console:Dismiss` still refuses `"gora is not available"` when Gora is missing. It resolves one id, calls `Gora:Dismiss(id)`, and calls `Confession:Dismiss(id)` when that function exists. Refresh / true if either succeeded. Isolated Gora-only stays when Confession is nil. One stock Dismiss. No `after()` / Sound / Toasts / chat. `SaveNote` stays nil. Isolated `lua tests/test_console.lua` **2220 passed, 0 failed**, exit 0.

Leftovers: isolated suite stubs Confession (real inbox removal is not an in-lane pin; do not expand exclusive to Confession.lua); selected-id / stock-button `OnClick` and Gora-missing-plus-Confession-present are unpinned in-lane (reviewer probes closed both); no client smoke; full harness not run.

Do not claim V1 / MVP complete. This review does not sign the lane.
