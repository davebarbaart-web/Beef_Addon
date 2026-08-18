Spec PASS

# B20-A — Confession inbox click + called token (review)

**Quality:** Approved-with-nits

**Lane:** B20-A Confession inbox click + called token
**Brief:** `docs/reformation/vestments/briefs/B20-A-confession-click.md`
**Writer report:** `docs/reformation/vestments/briefs/B20-A-confession-click-report.md`
**Diff:** `docs/reformation/vestments/briefs/B20-A-confession-click.diff` (B20-A-only exclusive-pair packet; live `Console.lua` also carries earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`confessionLine` / `onConfessionClick` / `paintConfessions` / `ConfessionRows` on build / `CallForward` / `Dismiss`), and `tests/test_console.lua` (`runB20A()` nested inside `runB8E()` after `runB19A()`, plus the older B4-D inbox FontString walk and B5-C CallForward no-sound pins); then ran `lua tests/test_console.lua` (**1514 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §9 (queue + call the next participant); §13.4 (text stays on the Pope desk); §18.1; click `SelectCharacter` then Refresh; mute `"  called"` when `row.called == true` (same mechanical token as `"  needs Knighting"`); no new Dismiss (`Console:Dismiss` stays Gora); no fan-out; nested pins; `SaveNote` stays nil. Isolation stays the console suite. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit Confession.lua, Gora, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Click does not `SelectCharacter` / does not Refresh | **Pass. Verified.** Live `onConfessionClick`: `SelectCharacter(row.characterId)` then Refresh. Pin: `stub.fire` OnClick sets `selectedCharacterId`. Source pin names that call. Reviewer spy: one `SelectCharacter` with the confessor id; Refresh ≥ 1. |
| Click auto-`CallForward` or fans out Sound / Toasts / chat | **Pass. Verified.** Click is select only. Pin: click Sound / Toasts / `SendChatMessage` stay 0. Existing B5-C CallForward pins stay (Pope gate, no sound, no chat). Reviewer spy: click leaves `CallForward` count 0; `CallForward()` after select is one mark on the selected id. |
| Mute `"  called"` missing, or "DEMANDED" / "CALLED FORWARD" invented | **Pass. Verified.** Live `confessionLine` appends `line .. "  called"` only when `row.called == true`. Pins: uncalled FontString and row have no token; after CallForward + Refresh both contain `"  called"`; no CALLED FORWARD / DEMANDED on paint or source. Reviewer probe: exact selected called line is `> Beefina  I ate the sacred brisket  called`. |
| Second Dismiss plate / `Console:Dismiss` no longer Gora | **Pass.** Walk pin: one Dismiss after Init. Source still `COB.Gora:Dismiss`. No `Confession:Dismiss` plate. Reviewer probe: one Dismiss with rows painted; `Console:Dismiss` still removes a Gora petition. |
| `paintConfessions` stays FontString-only (no `ConfessionRows` / no `paintRowButtons`) | **Pass.** Build seeds `ConfessionRows = {}`. Empty: show list, `"No confessions."`, `acquireRows(..., 0, 100)`. Rows: hide list, `paintRowButtons` on `ConfessionChild` via `confessionLine` / `onConfessionClick`. Mirrors Presence / Petition / Knighting. |
| New main-chunk locals / Lua 5.1 200-local | **Pass.** Packet adds a file-header comment and `local function runB20A()` nested inside `runB8E()` after `runB19A()`. No new main-chunk locals in the suite. Isolated suite loaded on Lua **5.1.5** with no `too many local variables`. |
| Isolation wrap broken | **Pass.** Load list unchanged: wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. Standalone wrap is still **17** nils at file load. `runB20A` re-pins Archive + Quiet shell + Toasts + Confession + `COB.Popes`. Reviewer probe: those 17 keys are nil at load. |
| Exclusive file breach (Confession.lua / Gora / glue) | **Pass.** Provided packet is two `diff --git` hunks (confessionLine token + `ConfessionRows` + `onConfessionClick` + `paintConfessions` rows; nested `runB20A` pins). `CallForward` / `Dismiss` bodies are not in the packet. Sibling dirt vs HEAD (Gora, TOC, bootstrap, `run.lua`, untracked `Confession.lua`) is other lanes. |
| Isolated suite not exit 0 | **Pass. Verified.** 1514 passed, 0 failed. Writer-reported count matches. |
| Existing CallForward Pope / no-sound pins broken | **Pass.** B5-C block still fires `CallForward(a.id)` and the Call Forward button, pins refuse when not Pope, and pins Sound / Toasts / chat 0. Live `CallForward` is still Pope-gated, marks Core, Refresh on ok. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Confession.lua / Gora / glue; no commit | **Pass.** Named-risk check. |
| `SaveNote` stays nil | **Pass.** `Console.SaveNote` is nil at the start and end of `runB20A`. Source has no `function Console:SaveNote`. Probe: still nil. |
| Mirror Presence / Petition / Knighting: `ConfessionRows = {}` on build | **Pass.** Named-risk check. |
| `paintConfessions` uses `paintRowButtons` on `ConfessionChild` when `#rows > 0` (hide `ConfessionList`) | **Pass.** Named-risk check. |
| Empty stays `"No confessions."` on the list | **Pass.** Pin after Init + Refresh. Probe: list shown, copy present. |
| Click: `SelectCharacter(row.characterId)` then Refresh | **Pass.** Named-risk check. |
| `confessionLine` appends mute `"  called"` when `row.called == true` | **Pass.** Named-risk check. Same `line = line .. "  …"` shape as `"  needs Knighting"`. |
| Do not write "DEMANDED", "CALLED FORWARD", or any oratory | **Pass.** Named-risk check. |
| No new Dismiss plate; `Console:Dismiss` stays Gora | **Pass.** Named-risk check. |
| No fan-out; no Sound / Toasts / SendChatMessage on CallForward | **Pass.** Click and CallForward pins both stay 0. B5-C keep-pins stay. |
| Existing CallForward pins stay (Pope gate, no sound, no chat) | **Pass.** Named-risk check. |
| Nest new pins in `runB8E()`; no new main-chunk locals | **Pass.** `runB20A()` inside `runB8E()` after `runB19A()`. |
| Isolation wrap stays | **Pass.** **17** nil pins under `if standalone then` at file load. |
| Init + stub queue with one row: row button exists; click sets `selectedCharacterId`; after CallForward + Refresh, painted line contains `"  called"` | **Pass.** All three pins in `runB20A`. |
| `lua tests/test_console.lua` exit 0 | **Pass.** **1514 / 0.** |

Bible §9 / §13.4 / §18.1 hold on the exclusive pair: the inbox is a Pope-desk queue; click selects the next participant; Call Forward is still the Pope verb that marks Core. The desk paints a mute token. It does not proclaim. Law 4 holds: click does not auto-call, auto-announce, or invent oratory. Law 10 holds: stock desk. `SaveNote` stays nil.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; harness `OnClick` is a stub fire; live `"> "` prefix after Refresh unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. |
| Confession is stubbed; real Core `called` is unproven here | **On contract.** Brief: this file does not load Confession.lua. Core already stores `called` (`entry.called = true`; getter copies `called == true`). |
| `ConfessionList` is Hidden when rows exist; `SetText` still runs via `confessionLine` | **On contract.** Brief said hide the list and paint row buttons when `#rows > 0`. Visible paint is the row button, also pinned. |
| `GetConfessions` is data, not the painted string | **On contract.** Brief's slash is a row button + painted line. Rows keep `called`. |
| CallForward still needs the Pope gate; click only selects | **On contract.** Brief: Call Forward needs `selectedCharacterId`; existing CallForward pins stay. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

B20-INT glue is not required. `CallForward` already reads `characterId or self.selectedCharacterId`.

---

## Isolation / paint / click

**Isolation wrap — Pass.** Nine `dofile`s unchanged. Standalone wrap is still 17 nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Wrap is load-time only (unchanged). `runB20A` assigns a fixture `COB.Confession` for paint / CallForward, same as B4-D / B5-C. It does not `dofile` `Confession.lua`.

**Paint — Pass.** Empty shows the FontString and `"No confessions."`. Rows hide the FontString and paint `ConfessionChild` buttons through `confessionLine`. Token is `"  called"` only when `called == true`. No DEMANDED / CALLED FORWARD. `GetConfessions` still returns a shallow copy; the token lives on paint.

**Click — Pass.** OnClick selects the row `characterId` and Refresh. It does not CallForward, play Sound, toast, or chat. After CallForward (Pope-gated furniture), Refresh paints `"  called"` on the selected row. `Console:Dismiss` is still the Gora plate.

---

## Strengths

- The click handler is four lines and matches Petition's select-then-Refresh shape without inheriting `SelectFighters` or Presence's `SelectHuman`. Call Forward stays a separate verb.
- `confessionLine` was early-return; the rewrite to a `line` local exists only so the mute token can append. Uncalled copy is unchanged (name + text).
- `paintConfessions` copies the Presence / Petition / Knighting empty-vs-rows branch. Build seeds `ConfessionRows`. Empty copy and the single Gora Dismiss stay.
- `runB20A()` is nested inside `runB8E()` after `runB19A()`. No new main-chunk locals in the suite. Isolation wrap and `SaveNote` / SUMMON / parchment / tab pins stay.
- Writer-reported **1514 / 0** matched the re-run. Writer-reported red (**1497 / 17**) matches the new ConfessionRows / hide / row-button / click / `"  called"` / source-token asserts that a FontString-only inbox would fail. Source `SelectCharacter(row.characterId)` was already green (Petition).

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

None that the brief required this lane to close.

### Nit

1. **`ConfessionList` is Hidden when rows exist.** `SetText` via `confessionLine` still runs; the pin reads `GetText` after Hide. Visible paint is the row button. Writer already named this.

2. **`GetConfessions` does not contain `"  called"`.** It is a queue copy with a `called` boolean. The token lives on paint. Brief allowed that reading.

3. **After click, Refresh prefixes the selected row with `"> "`.** Probe: select-only row is `> Beefina  I ate the sacred brisket`; after CallForward it is `> Beefina  I ate the sacred brisket  called`. FontString stays without the prefix. Unpinned. Live Anniversary click vs Refresh is still unproven.

4. **Source pin `Console:SelectCharacter(row.characterId)` also matches `onPetitionClick`.** The unique pins are `onConfessionClick` and the click `selectedCharacterId` assert.

5. **`called == true` is strict.** Probe: stub `called = 1` or `"true"` does not append the token; `true` does. Live Core getter already copies `entry.called == true`, and `CallForward` writes `true`. Not a Store path this suite loads.

6. **Opening chrome pins in `runB20A` duplicate `runB8E` / `runB19A`.** Harmless. Two `reset()` / `Init()` calls. Pope-predicate wrap sits between them and is restored fail-closed.

7. **Nil `characterId` click clears selection.** Probe: a row with only `text` calls `SelectCharacter(nil)`, which is a valid clear. Queue rows from Core carry `characterId`. Unpinned.

8. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. Brief said the wrap stays; it did.

9. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B20-A paint / click / token + nested pins. `git diff HEAD` on the two files still includes earlier console batches. Report already says this.

10. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **1514 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **1514 passed, 0 failed.** Isolation wrap: **17**.

Confession rows click `SelectCharacter` then Refresh. `confessionLine` appends mute `"  called"` when `row.called == true`. Empty inbox stays `"No confessions."`. Rows hide the FontString and `paintRowButtons` on `ConfessionChild`. One Dismiss plate; `Console:Dismiss` stays Gora. No fan-out. No DEMANDED / CALLED FORWARD. `SaveNote` stays nil. Pins live in `runB20A()` inside `runB8E()` with no new main-chunk locals. Isolated `lua tests/test_console.lua` **1514 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
