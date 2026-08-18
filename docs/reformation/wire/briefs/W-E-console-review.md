# W-E — Director Console favor pane + congregation toggle + free-ruling text (review)

**Spec:** PASS
**Quality:** Approved

**Lane:** W-E Director Console — favor pane + congregation toggle + free-ruling text
**Brief:** `docs/reformation/wire/briefs/W-E-console.md`
**API pin:** `docs/reformation/wire/briefs/W-EF-wow-api.md`
**Writer report (unverified):** `docs/reformation/wire/briefs/W-E-console-report.md`
**Diff:** `docs/reformation/wire/briefs/W-E-console.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the API pin, the writer report, and the provided diff once. `after()` / `PostDecree` were cut off mid-function in the diff, so those two functions were read in `Console.lua` along with `Runtime:EndEvent` / `succeed` (named-risk check: eventId including QUIET nil). Did not mutate the working tree, did not re-run git or the suite, and did not treat writer counts as verified.

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Gora / Store / Codec / BeefNet / HUD / TOC / bootstrap / Sender / Runtime / Decree Core / `run.lua` / OPEN_QUESTIONS / REFORMATION_LOG / `Data/Popes.lua` / commit | **Pass.** Provided diff touches only the two exclusive files. |
| Stock pragmatic Console: `UIPanelButtonTemplate` / `InputBoxTemplate` / `UICheckButtonTemplate` / `GameFont*`; no parchment, custom media, jokes, or Pope name | **Pass.** New chrome is `stockCheck` (`UICheckButtonTemplate` with no-template `pcall` fallback), `stockEdit` (`InputBoxTemplate`, `SetAutoFocus(false)`), and `GameFont*` strings. Labels are `FAVOR` and `Congregation sees favor`. Existing joke/RSVP/calendar nils stay. No `OnUpdate`, no `UIParent:SetScale`, no custom media. |
| UI → Core only; do not call `COB.Net`; `after()` must not `SendState` / `SendDecree`; Post Decree is `Decree:Set` + local banner | **Pass.** Named-risk read: `after()` is Refresh / `playCue` / `refreshHud` only. `PostDecree` is `Decree:Set`, Refresh, `showDecreeBanner`. No `COB.Net`, `SendDecree`, `SendState`, or `SendFavor` in this file. Header now says broadcast is bootstrap glue. |
| `GetFavorSplit()` copy `{ a, b }` from Gora, or zeros; mutating the copy must not change Gora; no public `Console.Favor` economy table | **Pass.** Fresh `{ a = n, b = n }` with non-number coerced to 0. Suite mutates the copy; Gora stays. Leftover `assert_eq(Console.Favor, nil)` kept — it does not block the pane. |
| `GetFavorCount()` is standing-pick map size, or 0 if Gora missing | **Pass.** `pairs` on `Gora:GetFavor()`, else 0. |
| Favor pane always on the Gora desk; Refresh paints clerical counts | **Pass.** `FAVOR` + `a / b` + count. `paintFavor` runs from `Refresh`. Not congregation theater. |
| Toggle: memory only; default true; boolean setter; non-boolean refused; `ResetForTests` → true; never SV | **Pass.** File-local `congregationFavorVisible`. Setter refuses non-boolean with `nil` + string and leaves the flag. `uiDb()` still writes only console position. |
| Per-event reset when `Runtime:Snapshot().eventId` changes, including QUIET `nil`; do not carry off-state into the next Gathering | **Pass.** `syncCongregationToggle` in `Refresh` resets on `eventId ~= lastSeenEventId` (nil is a distinct value). Current `Runtime:EndEvent` does not pass `eventId`, and `succeed` only writes that field when non-nil, so QUIET keeps the ended id. Off-state therefore survives that QUIET until the next `StartEvent` id. That matches the brief’s named test (reset on the next Gathering), not a miss. |
| Stock `CheckButton`; label `Congregation sees favor`; click no-ops when not Pope (`applyGate`); getter still returns the flag | **Pass.** Checkbox starts checked. `applyGate` Enable/Disable. OnClick restores `SetChecked` and returns when `isRegisteredPope()` is false. Suite fires that path. |
| FREE RULING box; button reads the box when `text` is omitted; do not pass `selectedCharacterId` as a winner; no fighter dropdown; empty box still `ruling == "free"` and `won == nil`; explicit arg still wins; trim stays Gora’s | **Pass.** Named-risk read: `Gora:FreeRuling(text)` only. Box read is `if text == nil`. No dropdown. Empty `""` is forwarded; Gora trims to nil. Suite pins box text, leftover-box vs explicit `"so ruled"`, empty-box no W/L / no `won`. |
| Named tests (favor copy + paint, toggle + Reset, Start/End/Start reset, PostDecree Net counters, box vs explicit vs empty FREE RULING); isolation stays under `if standalone then` | **Pass.** All present. Existing Pope-gate, PostDecree Set, and no-Sound blocks are untouched. Isolation block at the top is still `if standalone then`. |
| W-EF: stock Anniversary templates; no Net; no `OnUpdate`; no `UIParent:SetScale` | **Pass.** |

CONTINUE licenses 1–3 as they apply to this desk (Pope sees the split; congregation display is a per-event memory toggle default on; Post Decree is Core Set; free ruling is text, not a winner) are met.

---

## Strengths

- Layers stay UI → Core. The Net boundary is real, not a comment: `after()` and `PostDecree` have no send path, and the new APIs do not grow one.
- Favor getters hand out copies and tolerate a missing Gora. The pane is a readout, not a `Console.Favor` table.
- Toggle state is one boolean plus last-seen `eventId`, reset in `Refresh` (and `ResetForTests`). `applyGate` plus OnClick restore matches other desk chrome.
- FREE RULING is a stock box on the same desk. The verb still has no winner picker; `selectedCharacterId` is not an argument.
- Suite work matches the brief’s list and keeps the existing Sender stub pattern. Isolation asserts were not pulled out of `if standalone then`.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Gora-desk packing is tight.** Petition scroller is 70px (was 92). The checkbox (`TOPLEFT` −46, height 26) overlaps the petition scroll (`TOPLEFT` −70) by 2px. The left Presence desk grew to 300px without using the extra height. Content still fits a 600px frame (Notebook lands around content y=500 in a ~558px content box). Writer already notes client `/reload` smoke was not run. Polish, not a contract miss.

2. **Event reset lives only in `Refresh`.** `Console:StartEvent` / `EndEvent` go through `after()` → `Refresh`, so the desk verbs are covered. A raw `Runtime:StartEvent` that never hits Console `Refresh` would keep the last off-state until the next paint. Integrator still has to read `GetCongregationFavorVisible()` after a Console refresh (or the Console verb), not off a stale flag.

3. **PostDecree Net pin counts only `SendDecree` / `SendState`.** That is what the brief named. The file has no Net references at all; a generic Net touch is not asserted.

4. **QUIET-`nil` reset is implemented, not directly tested.** The suite locks today’s Runtime contract (EndEvent keeps the id; next StartEvent restores). A stubbed `eventId = nil` after an event is not pinned. The `~=` compare would reset if Runtime later nils the id.

5. **Suite header is stale.** It still says the Pope predicate is always false and the suite does not stub a Pope list. The W-E block uses the existing `Sender.IsRegisteredPope` wrap. A trailing `COB.Popes == nil` in the shared body matches a pre-existing pin in this file; the isolation cluster itself stayed under `if standalone then`.

---

## Assessment

**Spec PASS. Quality: Approved. Gate PASS.**

The exclusive pair does what the brief asked: Pope-desk FAVOR readout from Gora copies, memory-only congregation toggle that returns to on for a new `eventId`, Post Decree still Core Set, FREE RULING text without a winner. Named risks are clean. Minors are layout slack, Refresh-only reset glue, and coverage that could be broader — not trust-breakers.

Writer-reported isolated `tests/test_console.lua` **393 / 0** was **not** re-run here. Do not treat that count as verified. Do not claim V1 / MVP complete. This review does not sign the lane.
