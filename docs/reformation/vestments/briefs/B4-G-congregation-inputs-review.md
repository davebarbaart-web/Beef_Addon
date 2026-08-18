Spec PASS

# B4-G — Event congregation petition / confess (review)

**Quality:** Approved

**Lane:** B4-G Event congregation petition / confess
**Brief:** `docs/reformation/vestments/briefs/B4-G-congregation-inputs.md`
**Writer report:** `docs/reformation/vestments/briefs/B4-G-congregation-inputs-report.md`
**Diff:** `docs/reformation/vestments/briefs/B4-G-congregation-inputs.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Inputs.lua`, `tests/test_inputs.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, `UI/Inputs.lua`, and `tests/test_inputs.lua`; then ran `lua tests/test_inputs.lua` (209 passed, 0 failed, exit 0). Did not mutate the working tree except this review file. Did not commit. Did not edit TOC, `run.lua`, bootstrap, BeefNet, Console, or Hud.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Event-only (Quiet refuse) | **Pass.** `MODE = "Event"`. `eventLive()` is a Runtime snapshot whose `state` is present and not `"QUIET"`. Missing Runtime is Quiet. Quiet `Show` / `Petition` / `Confess` return false and leave the widget hidden. `EndEvent` + `Refresh` hides. Suite pins Quiet Init / Show / send / sound / chat at zero. |
| `SetInputTarget` / `SetLocalCharacterId` | **Pass.** Non-empty string target; number character id. Empty / nil clears. No roster, `UnitName`, `Data/Popes.lua`, or `COB.Popes` read. Whisper destination is injected only. |
| Petition / Confess call Net, not Gora | **Pass.** `Net:SendPetition({ characterId }, target)` and `Net:SendConfession({ characterId, text }, target)`. No `Gora:Petition`. Planted `Gora.Petition` / `Toasts.Proclaim` spies stay at zero. No opponent / kind fields invented. |
| No Pope lookup | **Pass.** Source has no `Popes.lua`, `Data/Popes`, `COB.Popes`, `LookupPope`, or `FindPope`. Isolation pins `COB.Popes` nil. |
| No Proclaim / Sound / `SendChatMessage` | **Pass.** Source has none of `Proclaim`, `PlaySound`, `PlaySoundFile`, `SendChatMessage`, or `SendAddonMessage`. Suite sound / `stub.chat` / `stub.addonMessages` stay 0 through Quiet, send, and teardown. |
| Stock buttons | **Pass.** `UIPanelButtonTemplate` labels `Petition` / `Confess`. Optional `InputBoxTemplate`, `SetAutoFocus(false)`. Tooltip-background strip is stock functional chrome, not theater. No jokes, no custom Media. |
| Isolated green | **Pass.** Load list is wow_ui_stub + Common + Runtime + Inputs. Isolation (23 nil-module + slash) stays under `if standalone then`. Re-ran: **209 passed, 0 failed**, exit 0. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no TOC / `run.lua` / `ChurchOfBeef.lua` / BeefNet / Console / Hud / OPEN_QUESTIONS / REFORMATION_LOG / commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/Inputs.lua` and `tests/test_inputs.lua`. Current TOC does not list `Inputs.lua`. Current `tests/run.lua` does not list `test_inputs`. Bootstrap has no `Inputs` symbol. |
| API: `Init` / `SetInputTarget` / `SetLocalCharacterId` / `Petition` / `Confess` / `Show` / `Hide` / `Refresh` / `GetView` (copy) / `ResetForTests` | **Pass.** All present. `GetView` is `deepcopy(lastView)`. Out-of-harness `ResetForTests` returns false and does not hide. Missing `CreateFrame` → `Init` nil, `Show` false. |
| `MODE = "Event"`. Quiet or missing Runtime → Show / Petition / Confess false; frame hidden. No Quiet chrome | **Pass.** Named-risk check. Hidden named frame after Quiet Init is the same Event-surface pattern as Hud / FighterCard, not painted chrome. |
| Missing target → `false, "no target"`. Missing local character id → `false, "no character"` | **Pass.** Empty string target is `"no target"`. Nil id is `"no character"`. Suite pins both verbs. |
| Call Net only. Do not call `Gora:Petition`. Do not Proclaim. Do not PlaySound. Do not SendChatMessage | **Pass.** Named-risk check. |
| Stock `UIPanelButtonTemplate` `Petition` / `Confess`. Optional stock EditBox. No jokes | **Pass.** Named-risk check. Explicit `Confess(text)` wins over the box; `Confess()` reads the box. |
| Do not look up `Data/Popes.lua` | **Pass.** Named-risk check. |
| Isolated suite + named pins + `lua tests/test_inputs.lua` exit 0 | **Pass.** Re-run verified. Writer-reported 209 / 0 matches. |

Bible §13.1 / §18.5 (congregation is a display terminal plus input device; inputs never trigger public theater), §19.1 / Law 6 (Event chrome; Quiet stays quiet), and Law 10 (functional stock; UI never tells jokes) are met on the exclusive pair. B4 overview: no named-opponent field, no Pope-name lookup, no custom media.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; integrator still lists TOC / `run.lua` and wires `SetInputTarget` from the last accepted STATE sender | **Not a miss.** Brief forbade those edits and forbade inventing a Pope name. |
| Extra `false, "no net"` when `SendPetition` / `SendConfession` are missing | **Not a miss.** Brief named only target / character. Fail-closed extra reason does not send and does not throw. |
| EditBox included (brief: optional); explicit `Confess(text)` wins | **Not a miss.** Optional chrome is allowed. Suite pins the win rule. |
| Quiet verbs return `false` with no named reason | **Not a miss.** Brief requires false + hidden, not a Quiet reason string. |
| Stock tooltip-background strip; **POLISH:CANDIDATE** only | **Not a miss.** Functional surface. Ceiling is correct. |

---

## Strengths

- The surface is an input device, not a writer. It stores an injected target and id, then calls Net. It does not petition Gora, proclaim, chat, or play sound.
- Quiet is actually refused, not only commented: Init / Show stay hidden; Petition / Confess do not send; EndEvent + Refresh hides.
- Pope name is not in this file. Isolation pins `COB.Popes` nil. Source greps cover the lookup spellings.
- Isolation stayed gated. Shared-body remainder can join `run.lua` later without the nil-module cluster firing under the full harness.
- Writer report matched the re-run (209 / 0). Exclusive packet matches the diff.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **No live Runtime listener.** `EndEvent` without `Refresh` / `Show` / a send leaves the last painted frame up until a verb runs (`readyToSend` / `Show` / `Refresh` then hide). Brief named `Refresh` as the paint path. Integrator must hook it. Same leftover as other Event furniture.

2. **Empty-box `Confess()` still sends.** A nil / empty `GetText` omits `fields.text` or sends `""`. B4-A already treats confession text as optional; Core `parseText` collapses empty to nil. Not a theater leak.

3. **Whitespace-only target is stored.** `SetInputTarget(" ")` is a non-empty string, so the lane will call Net. Net’s own empty-string check will not catch spaces. Brief did not ask for trim.

4. **Hardcoded bottom-center dock (280×72 at y=80).** Clamped, not movable, not saved. Brief did not name position. Unsmoked against action bars.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated suite was re-run here. Client path and runner listing remain integrator work.

---

## Assessment

**Spec PASS. Quality Approved.**

This is the B4-G congregation-input contract: Event Mode only, Quiet Show / Petition / Confess are false and hidden, target and character id are injected, Petition / Confess spy Net and not Gora, no Pope lookup, no Proclaim / sound / chat, stock `Petition` / `Confess` buttons, isolated suite green (209 / 0, exit 0). Named risks are clean. Minors are integrator Refresh, empty-text Confess, whitespace target, and unsmoked dock — not trust-breakers.

Expected leftover (not a miss): integrator lists `UI/Inputs.lua` in the TOC and `test_inputs` in `tests/run.lua`, then wires `SetInputTarget` from the last accepted STATE sender and `SetLocalCharacterId` from the local character. Until that list lands, the runner’s on-disk discovery contract will fail because `tests/test_inputs.lua` exists and is unlisted.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
