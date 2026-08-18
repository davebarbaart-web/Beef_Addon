Spec PASS

# B4-D — Console petition H2H + confession inbox (review)

**Quality:** Approved

**Lane:** B4-D Console petition H2H + confession inbox (stock)
**Brief:** `docs/reformation/vestments/briefs/B4-D-console-inbox.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B4-D-console-inbox-report.md`
**Diff:** `docs/reformation/vestments/briefs/B4-D-console-inbox.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, `UI/Console.lua`, and `tests/test_console.lua`; then ran `lua tests/test_console.lua`. Law cited: Bible §10.2 / §10.5 / §18.1–18.2 / §9; Law 10 / §19.3; CONTINUE 2026-08-18 license 4 (Console stays plain); Batch 3 critique (restore petitioner H2H; SKIP/Dismiss is furniture). Did not mutate addon code. Did not commit. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Petition H2H mute numeric when history exists | **Pass.** `h2hScore` reads `Store:GetCharacter(petitioner).gora.headToHeads` for `namedOpponentId` and appends `wins-losses`. No row → names only. Unnamed petition → name only. Source has no `meeting` / `demanded` / `odds`. Suite pins `Chuckroast  names  Tendermage  1-0` plus the two negative cases. |
| `GetConfessions` copies or `{}` | **Pass.** Missing module / missing `GetQueue` / non-table queue → `{}`. Else a new array of shallow row copies. Suite mutates a copy’s `.text`; live stub and next read stay. |
| Confession text on the Pope desk only | **Pass.** `paintConfessions` writes `frame.ConfessionList` only. `Refresh` does not call Toasts, Hud, Decree, or Net. Suite stubs those surfaces on the inbox paint path and pins 0 / unchanged Decree. |
| Dismiss is `stockButton`, not `ritual` | **Pass.** Created with `stockButton(right, "Dismiss", ...)`. Not pushed into `RitualButtons`. Label `Dismiss`. `Console:Dismiss` still pope-gates and still calls `Gora:Dismiss`. Suite pins template, furniture, button click, and Core reach. |
| `SaveNote` nil; no WHISPER ALL; desk verbs kept | **Pass.** `Console.SaveNote` is nil. Source has no `WHISPER ALL`. Proposed Bout, SANCTION, favor pane, Post Decree, FREE RULING, and MARK THIS MOMENT remain and are re-pinned. |
| Isolated green | **Pass.** Reviewer ran `lua tests/test_console.lua`: **499 passed, 0 failed**, exit 0. Isolation cluster is still `if standalone then` and gained `COB.Confession == nil`. Suite does not `dofile` `Confession.lua`. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Gora, Confession source, BeefNet, Toasts, Hud; no slash; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/Console.lua` and `tests/test_console.lua`. |
| Console stays plain / stock forever; no custom media; no Notebook persist | **Pass.** Inbox is `scrollList` + `GameFontHighlightSmall` on the existing left-column tooltip panel. Notebook is still a label. `SaveNote` stays nil. No parchment, QuestBG, custom media, jokes, `OnUpdate`, or `UIParent:SetScale`. |
| Petition line keeps Store names; named opponent + petitioner H2H row → mute `1-0`; no named opponent → name only; no `meeting` / `demanded` / `odds` | **Pass.** Named-risk check. `characterName` still walks Store. `paintPetitions` now uses `petitionLine` for both the hidden FontString body and the clickable rows (diff dropped the raw-id concat). |
| `GetConfessions()` returns `Confession:GetQueue()` copies when the module exists, else `{}` | **Pass.** Named-risk check. |
| Paint name + text on the Pope console only; never send confession text to Toasts / HUD / Decree / Net | **Pass.** Named-risk check. Inbox header `Confession` + 70px stock scroll under Knighting. |
| Dismiss via existing `stockButton` (`UIPanelButtonTemplate`), not `ritual`; label `Dismiss`; behavior unchanged (`Gora:Dismiss`) | **Pass.** Named-risk check. Leaving `RitualButtons` means `applyGate` no longer Disable-s it. `Console:Dismiss` is still refuse-closed. That is the furniture brief, not a miss. |
| Do not add WHISPER ALL, SUMMON, clipboard, or Notebook persist | **Pass.** No those strings in `Console.lua`. Suite greps `WHISPER ALL` and pins no SUMMON chrome. |
| Keep Proposed Bout, Sanction, favor pane, Post Decree, FREE RULING, MARK THIS MOMENT | **Pass.** Build + B4-D pins. EditBox count stays 4. W-E / B3-D blocks still in the file. |
| Tests: H2H on a named petition when Store has history; GetConfessions empty without module; stubbed queue paint includes the text; Dismiss still reaches Gora; `SaveNote` nil; source has no `WHISPER ALL`; isolation wrap stays | **Pass.** B4-D block covers the list. Isolation stayed gated. `lua tests/test_console.lua` exit 0. |

CONTINUE license 4 (Director Console stays plain), Bible §10.2 / §10.5 (petition hygiene; H2H as mute context, not odds), §18.1–18.2 / §9 (confession text private to the Pope desk), Law 10 functional desk, and Batch 3 (restore petitioner H2H; Dismiss is furniture) are met.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; 70px inbox may clip long text | **Not a spec miss.** Brief asked isolated `tests/test_console.lua`. **POLISH:CANDIDATE** is the ceiling. |
| `Confession.lua` not loaded; paint proven against a stub | **Not a miss.** Brief said stub the queue. Integrator still wires B4-C. |
| H2H reads the petitioner Store row only | **Not a miss.** Brief named `Store:GetCharacter(petitioner).gora.headToHeads`. |
| A Void H2H row would paint `0-0` | **Not a miss.** Store `h2hFor` creates a row on any recorded result; the brief paints whenever a row exists. Mute numeric, not a story line. |
| Dismiss looks live when not Pope | **Not a miss.** Brief took it off `ritual` / `applyGate`. Click still refuse-closes in `Console:Dismiss`. |

---

## Strengths

- H2H is a readout, not a matchmaker. It appends digits only when the petitioner already has a Store row, and it does not invent pairing scores or prose.
- Confession stays a desk FontString. `GetConfessions` never hands out the live queue. Refresh does not fan the text into theater or the wire.
- Dismiss is the same size and seat next to SANCTION, but it is furniture: `UIPanelButtonTemplate` via `stockButton`, not a ritual plate.
- Suite covers the brief list plus copy safety, missing-`GetQueue`, unnamed / no-history negatives, Toasts / Hud / Net / Decree leak counters, stock Dismiss, and a source grep. Isolation stayed under `if standalone then`.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **GetConfessions copies are shallow `pairs`.** Mutating `.text` is pinned. A nested table on a future queue row would still alias. B4-C `GetQueue` already returns a flat `{ characterId, text, called }` copy, so this is defensive-double, not a leak today.

2. **Early `#GetConfessions() == 0` sits in the shared body.** Correct while this file does not load Confession. If an integrator later `dofile`s `Confession.lua` ahead of this suite and leaves a live queue, that pin flakes. The isolation `COB.Confession == nil` pin is correctly gated.

3. **70px left-column inbox.** Header at −238, scroll at −256, `DESK_H` still 336. Long lines wrap inside a short scroller. Writer disclosed it. Unsmoked on Anniversary.

4. **Suite header is still stale.** It still says the Pope predicate is always false and the suite does not stub a Pope list. The B4-D Dismiss reach uses the existing `Sender.IsRegisteredPope` wrap. Isolation itself stayed gated.

5. **Leak pin counts `Toasts.Show` / `Hud.Refresh` / `Net.SendDecree` / `SendState` only.** That is what the brief named. This file has no Toasts references and does not pass confession text into `after()` / `refreshHud`.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **499 / 0** was re-run here. Client path was not.

---

## Assessment

**Spec PASS. Quality Approved.**

This is the B4-D vestment contract: mute numeric petitioner H2H on named cards, a stock confession inbox that paints name + text on the Pope desk only, Dismiss as furniture, `SaveNote` still nil, no WHISPER ALL, prior desk verbs kept. Named risks are clean. Minors are shallow copy, a shared-body empty pin, clip, and unsmoked height — not trust-breakers.

Isolated `lua tests/test_console.lua` **499 passed, 0 failed**, exit 0. Do not claim V1 / MVP complete. This review does not sign the lane.
