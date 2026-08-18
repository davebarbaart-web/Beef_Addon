Spec PASS

# B5-E — Congregation snapshot catch-up control (review)

**Quality:** Approved

**Lane:** B5-E Congregation snapshot catch-up control
**Brief:** `docs/reformation/vestments/briefs/B5-E-catchup.md`
**Writer report:** `docs/reformation/vestments/briefs/B5-E-catchup-report.md`
**Diff:** `docs/reformation/vestments/briefs/B5-E-catchup.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, `UI/Inputs.lua`, and `tests/test_inputs.lua`; then ran `lua tests/test_inputs.lua` (241 passed, 0 failed, exit 0). Did not mutate the working tree except this review file. Did not commit. Did not edit TOC, `run.lua`, bootstrap, BeefNet, or `ChurchOfBeef.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Catchup` → `Net:RequestSnapshot(injected target)` | **Pass.** `Inputs:Catchup()` returns `COB.Net:RequestSnapshot(inputTarget)` only. No second argument. No character id. No Pope name. Suite spies `sentSnapshots[1].target == "Host"` after `SetInputTarget("Host")`, including the no-id path and the stock-button `OnClick`. |
| Event only | **Pass.** `MODE = "Event"`. `eventLive()` is a Runtime snapshot whose `state` is present and not `"QUIET"`. Missing Runtime is Quiet. Quiet `Catchup` is false and does not grow `#sentSnapshots`. `EndEvent` + `Refresh` hides; Quiet Catchup after EndEvent stays false. |
| No Pope lookup | **Pass.** Source has no `Popes.lua`, `Data/Popes`, `COB.Popes`, `LookupPope`, or `FindPope`. Isolation pins `COB.Popes` nil. Whisper destination is `SetInputTarget` only. Suite fixture remains `"Host"` (B4-G), not a listed Pope. |
| Stock `Catch up` | **Pass.** `UIPanelButtonTemplate` label `"Catch up"` (space, not `Catchup`). Centered between Petition and Confess. Suite finds the button by `GetText() == "Catch up"` and fires `OnClick`. No jokes, no custom Media. |
| Isolated green | **Pass.** Load list is wow_ui_stub + Common + Runtime + Inputs. Isolation (23 nil-module + slash = **24**) stays under `if standalone then`. Re-ran: **241 passed, 0 failed**, exit 0. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no TOC / `run.lua` / `ChurchOfBeef.lua` / BeefNet / commit; do not invent a Pope name | **Pass.** Provided diff is two `diff --git` hunks: `UI/Inputs.lua` and `tests/test_inputs.lua`. |
| `Inputs:Catchup()` calls `Net:RequestSnapshot(inputTarget)` only | **Pass.** Named-risk check. Does not go through `readyToSend` (that helper still demands a local character id for Petition / Confess). |
| Event only. Quiet → `false` | **Pass.** Named-risk check. Quiet Init / Show stay hidden. Quiet Catchup does not send. |
| Missing / empty target → `false, "no target"` | **Pass.** Nil and `""` refuse before Net. Suite pins both. |
| Do not look up `Popes.lua` | **Pass.** Named-risk check. |
| Stock button label `Catch up` | **Pass.** Named-risk check. Method name is `Catchup`; chrome copy is `Catch up`. |
| No Sound, no Proclaim, no Gora | **Pass.** Source has none of `PlaySound`, `PlaySoundFile`, `Proclaim`, `Gora:Petition`, `Gora.Petition`. Planted `Gora.Petition` / `Toasts.Proclaim` spies stay at zero on Catchup. Suite sound / `stub.chat` / `stub.addonMessages` stay 0. |
| Stub `Net.RequestSnapshot`. Quiet refuse. StartEvent + target → Catchup spies the target. Isolation wrap stays | **Pass.** All present. Isolation print and nil cluster still gated. |
| `lua tests/test_inputs.lua` exit 0 | **Pass.** Verified 241 / 0. Writer-reported count matches. |

Bible §20.3 (late-join / reload ask is a whisper snapshot from the Pope's client), §13.1 / §18.5 (congregation is a display terminal plus input device; inputs never trigger public theater), §19.1 / Law 6 (Event chrome; Quiet stays quiet), and Law 10 (functional stock; UI never tells jokes) are met on the exclusive pair. B5 overview: Event `Catchup()` → `Net:RequestSnapshot(target)`.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; TOC / `run.lua` already list Inputs (B4-INT). This lane did not edit them | **Not a miss.** Brief forbade those edits and forbade inventing a Pope name. Target still comes from the injected bind. |
| Extra `false, "no net"` when `RequestSnapshot` is missing | **Not a miss.** Brief named only Quiet refuse and `"no target"`. Fail-closed extra reason does not send and does not throw. Same pattern as Petition / Confess. |
| Catchup does not require `SetLocalCharacterId` | **Not a miss.** Brief is `RequestSnapshot(inputTarget)` only. Character id is a petition / confession field, not a snapshot destination. |
| Frame widened 280 → 328 so three stock 96px buttons fit | **Not a miss.** Brief named the label, not the layout. Catch up is centered between Petition and Confess. |
| Quiet Catchup returns `false` with no named reason | **Not a miss.** Brief requires `false`, not a Quiet reason string. |
| Stock tooltip-background strip; **POLISH:CANDIDATE** only | **Not a miss.** Functional surface. Ceiling is correct. |

---

## Strengths

- Catchup is a Net ask, not a writer. It stores an injected target and calls `RequestSnapshot` on that string only. It does not petition Gora, proclaim, chat, play sound, or read `Popes.lua`.
- Event refuse is real, not a comment: Quiet Catchup does not send; missing Runtime does not send; EndEvent + Refresh hides and Catchup stays false.
- The no-id path is load-bearing. Petition still demands `SetLocalCharacterId`; Catchup with target `"Host"` and no id still spies one `RequestSnapshot("Host")`. That is the B3-E send contract on a congregation button.
- Isolation stayed gated. Shared-body remainder can keep running under `tests/run.lua` without the nil-module cluster firing.
- Writer report matched the re-run (241 / 0). Exclusive packet matches the diff.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **§20.3 late join from Quiet cannot press this button.** Brief required Event only, so a reload that lands in QUIET hides the strip and `Catchup()` returns false. Integrator already injects the last accepted STATE sender into `SetInputTarget`; a Quiet-side auto-ask (if wanted) is a later glue decision, not this lane. Do not invent a Pope name to paper over it.

2. **No live Runtime listener.** `EndEvent` without `Refresh` / `Show` / a verb leaves the last painted frame up until something calls `eventLive()`. Same leftover as B4-G. Brief kept `Refresh` as the paint path.

3. **Whitespace-only target is stored.** `SetInputTarget(" ")` is a non-empty string, so Catchup will call Net. Pre-existing B4-G hole. Brief did not ask for trim.

4. **Frame width 328 is unpinned.** Three 96px stock buttons plus 12px side pads need the extra width. Suite does not assert `GetWidth()`. Brief named the label, not the dock.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated suite was re-run here. Two-client snapshot whisper remains a human walk.

---

## Assessment

**Spec PASS. Quality Approved.**

This is the B5-E congregation catch-up contract: Event Mode only, `Catchup()` spies `Net:RequestSnapshot` on the injected target, Quiet is false and does not send, missing target is `"no target"`, no Pope lookup, stock `Catch up` button, isolated suite green (241 / 0, exit 0). Named risks are clean. Minors are Quiet-reload leftover, integrator Refresh, whitespace target, and unsmoked dock — not trust-breakers.

Expected leftover (not a miss): live send still needs the already-injected STATE sender (or slash target bind). This lane does not invent a Pope name. Inbound snapshot answer still requires a registered Pope on the far client (B3-E). No `/beef catchup` was asked.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
