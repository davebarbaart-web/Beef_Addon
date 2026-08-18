Spec PASS

# B18-B — Console petition challenge line is pinned (review)

**Quality:** Approved-with-nits

**Lane:** B18-B Console petition challenge line is pinned
**Brief:** `docs/reformation/vestments/briefs/B18-B-console-names.md`
**Writer report:** `docs/reformation/vestments/briefs/B18-B-console-names-report.md`
**Diff:** `docs/reformation/vestments/briefs/B18-B-console-names.diff` (B18-B-only exclusive-pair packet; tests-only — live `Console.lua` also carries earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`petitionLine` / `onPetitionClick` / `paintPetitions` / `SelectFighters` / `SaveNote`), and `tests/test_console.lua` (`runB18B()` nested inside `runB8E()` after `runB14D()`, plus the older B4-D walk that already finds a `names` substring); then ran `lua tests/test_console.lua` (**1388 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §10.2 / §18.1 (`petitionLine` already paints `left .. "  names  " .. right` plus mute H2H; click already `SelectFighters`; pin the desk path; do not invent "DEMANDED" / flavor); Law 4; Law 10 / §19.3 (stock desk); `SaveNote` stays nil. Isolation stays the console suite. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit Gora, Inputs, Net, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Named petition paint missing `"  names  "` or copy rewritten | **Pass. Verified.** Live `petitionLine`: when `namedOpponentId` is set, `left .. "  names  " .. right`, then optional mute `  W-L` from Store H2H. `paintPetitions` `SetText`s `PetitionsList` via `petitionLine` and paints row buttons with the same helper. Pins: FontString and row button contain `"  names  "`, Chuckroast, Tendermage. Source pin: `left .. "  names  " .. right`. Reviewer probe: exact list body is `Chuckroast  names  Tendermage\nBrisket`. |
| Click does not `SelectFighters` both ids | **Pass. Verified.** Live `onPetitionClick`: `SelectCharacter` the petitioner; when `namedOpponentId ~= nil`, `Console:SelectFighters(row.characterId, row.namedOpponentId)`; then Refresh. Pin: after `stub.fire` OnClick, `selectedFighterA` / `selectedFighterB` are both ids. Source pin names that call. Reviewer spy: one `SelectFighters` with petitioner then opponent. |
| "DEMANDED" / narration / odds copy invented | **Pass.** Painted-line pins: no DEMANDED / demanded / odds / meeting. Source pin: no `DEMANDED`. Live `Console.lua` has no those strings (DecreeFlavor is a stock box name, not petition prose). Probe: named line and H2H line stay names-only / names-plus-numeric. |
| `SaveNote` defined | **Pass.** `Console.SaveNote` is nil before and after the block. Source pin: no `function Console:SaveNote`. Live file only mentions SaveNote in comments. |
| New main-chunk locals / Lua 5.1 200-local | **Pass.** Packet adds a file-header comment and `local function runB18B()` nested inside `runB8E()` after `runB14D()`. No new main-chunk locals. Isolated suite loaded on Lua **5.1.5** with no `too many local variables`. |
| Isolation wrap broken | **Pass.** Load list unchanged: wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. Standalone wrap is still **17** nils at file load. B18-B re-pins Archive + Quiet shell + Toasts + `COB.Popes`. Reviewer probe: those 17 keys are nil at load. |
| Exclusive file breach (Gora / Inputs / Net / glue) | **Pass.** Provided packet is one `diff --git` hunk on `tests/test_console.lua`. `Console.lua` is exclusive and unchanged (tests-only allowed). Sibling dirt vs HEAD on Console / Gora is other lanes. |
| Isolated suite not exit 0 | **Pass. Verified.** 1388 passed, 0 failed. Writer-reported count matches. |
| `GetPetitions` drops `namedOpponentId` / presence filter hides the row | **Pass.** Pin: one present named row keeps both ids. Live `GetPetitions` returns `Gora:GetPetitions(presentCharacterIds())`; `copyPetition` keeps `namedOpponentId`. Probe: no roster → 0 rows; roster present → named + unnamed. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Gora / Inputs / Net / glue; no commit | **Pass.** Named-risk check. |
| Pin `"  names  "` + `SelectFighters`; do not change the copy | **Pass.** Named-risk check. Tests-only; live `petitionLine` / `onPetitionClick` already matched. |
| No "DEMANDED" / narration | **Pass.** Named-risk check. |
| `SaveNote` stays nil | **Pass.** Named-risk check. |
| Stock desk; no new codec kind | **Pass.** Source pins: no SUMMON / Parchment / `PanelTabButtonTemplate`. Packet does not touch Codec / Net. |
| Nest new pins in `runB8E()` or a `do` block; no new main-chunk locals | **Pass.** `runB18B()` inside `runB8E()` after `runB14D()`. |
| Isolation wrap stays | **Pass.** **17** nil pins under `if standalone then` at file load. |
| After StartEvent + two known characters + `Gora:Petition(a, b)`, `GetPetitions` / painted line contains `"  names  "` | **Pass.** Painted FontString and row button. `GetPetitions` is data (ids), not the token — see leftover. |
| Clicking that row selects both fighter ids (existing `SelectFighters`) | **Pass.** Named-risk check. |
| If Refresh FontString path is missing the line, wire existing `petitionLine` — do not write new prose | **Pass.** `paintPetitions` already `SetText`s via `petitionLine` before Hide. No Console.lua edit. |
| `lua tests/test_console.lua` exit 0 | **Pass.** **1388 / 0.** |

Bible §10.2 / §18.1 hold on the exclusive pair: a named petition is a desk fact (`"  names  "`), not software narration, and the Pope still picks the pair. Law 4 holds: no DEMANDED / flavor. Law 10 holds: stock desk. `SaveNote` stays nil.

Writer may land tests-only if paint already existed. That is on contract, not a miss.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; harness `OnClick` is a stub fire; live `"> "` prefix after Refresh unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. |
| `GetPetitions` is data, not the painted string | **On contract.** Brief's slash is `GetPetitions` / painted line. Pins keep both ids and put `"  names  "` on the FontString and the row. |
| `PetitionsList` is Hidden when rows exist; `SetText` still runs | **On contract.** Brief said wire `petitionLine` if the FontString path was missing. It was not missing. Visible paint is the row button, also pinned. |
| Unnamed petition click still `SelectCharacter` only | **On contract.** This pin is the named row. Probe: unnamed click does not call `SelectFighters`; fighters stay nil. |
| Presence filter stays (roster ready + name-key members) | **On contract.** Same desk rule as B4-D. Probe: no roster → `#GetPetitions() == 0`. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / paint / click

**Isolation wrap — Pass.** Nine `dofile`s unchanged. Standalone wrap is still 17 nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Wrap is load-time only (unchanged). `runB18B` assigns a fixture `COB.Roster` for the presence filter, same as the existing petition desk. It does not `dofile` `Roster.lua`.

**Paint — Pass.** `petitionLine` copy is unchanged. Named row is `left .. "  names  " .. right`. Mute numeric H2H still appends only when Store has history (B4-D pins stay; this fixture has no H2H, so names only). `paintPetitions` writes that string onto `PetitionsList` and the row button. No DEMANDED.

**Click — Pass.** Named-row OnClick calls existing `SelectFighters` with both ids, then Refresh. Selected fighters survive Refresh. Unnamed click is still petitioner-only (`SelectCharacter`).

---

## Strengths

- The lane is the pin the brief asked for. `petitionLine` and `onPetitionClick` already did the work; the writer did not invent copy or a second paint helper.
- Exact token is `"  names  "` (plain find), not the weaker B4-D `find("names")` walk. Both the hidden FontString and the visible row button are pinned.
- Click is the missing B4-D piece: `stub.fire` OnClick → both fighter ids, plus a source pin for `Console:SelectFighters(row.characterId, row.namedOpponentId)`.
- `runB18B()` is nested inside `runB8E()` after `runB14D()`. No new main-chunk locals. Isolation wrap and `SaveNote` / SUMMON / parchment / tab pins stay.
- Writer-reported **1388 / 0** matched the re-run. TDD "no new fail" is allowed when paint already existed.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

None that the brief required this lane to close.

### Nit

1. **`PetitionsList` is Hidden when rows exist.** `SetText` via `petitionLine` still runs; the pin reads `GetText` after Hide. Visible paint is the row button. Writer already named this.

2. **`GetPetitions` does not contain `"  names  "`.** It is a present-and-alive copy with `namedOpponentId`. The token lives on paint. Brief allowed that reading.

3. **After click, Refresh prefixes the selected row with `"> "`.** Probe: row becomes `> Chuckroast  names  Tendermage`; FontString stays without the prefix. Unpinned. Live Anniversary click vs Refresh is still unproven.

4. **`Console:StartEvent` forced a temporary `IsRegisteredPope` wrap.** B4-D used `Runtime:StartEvent` and avoided that. They restore the predicate and pin it fail-closed. Not a Pope-list stub.

5. **Opening chrome pins in `runB18B` duplicate `runB8E` / `runB14D`.** Harmless. Two `reset()` calls.

6. **Unnamed "no `"  names  "`" keep-pin is not in this block.** B4-D still walks Brisket without `names`. Probe: unnamed line is `Brisket`.

7. **Mute H2H is not re-pinned here.** Copy still appends `  1-0` when Store has history. B4-D already covers that.

8. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. Brief said the wrap stays; it did.

9. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B18-B test nest + header comment. `git diff HEAD` on the two files still includes earlier console batches. Report already says this.

10. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **1388 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **1388 passed, 0 failed.** Isolation wrap: **17**.

`petitionLine` still paints `left .. "  names  " .. right` (plus mute H2H when Store has history). Refresh still `SetText`s `PetitionsList` via that helper and paints the row button the same way. Named-row click still `SelectFighters` both ids. No DEMANDED. `SaveNote` stays nil. Stock desk. No new codec. Pins live in `runB18B()` inside `runB8E()` with no new main-chunk locals. `Console.lua` was correctly left unchanged. Isolated `lua tests/test_console.lua` **1388 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
