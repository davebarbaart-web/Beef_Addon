Spec PASS

# B10-C — Fighter card persists through the verdict (review)

**Quality:** Approved-with-nits

**Lane:** B10-C Fighter card persists through the verdict
**Brief:** `docs/reformation/vestments/briefs/B10-C-card-persist.md`
**Writer report:** `docs/reformation/vestments/briefs/B10-C-card-persist-report.md`
**Diff:** `docs/reformation/vestments/briefs/B10-C-card-persist.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, `UI/FighterCard.lua`, and `tests/test_fighter_card.lua`; then ran `lua tests/test_fighter_card.lua` (**441 passed, 0 failed**, exit 0, Lua 5.1.5). Law cited: Bible §10.7 (persist through the verdict beat; same composition as the HUD), Law 6 / §19.1 (Quiet hides Event chrome), B3-B / B8-C mute tape (`1-0`, no `UnitHealth`). Did not mutate FighterCard or the suite. Did not commit. Did not edit Hud, Gora, Console, TOC, bootstrap, or `run.lua`.

This review does not sign the lane.

---

## Named gates

| Gate | Verdict |
|---|---|
| Persist through the verdict (Bible §10.7) | **Pass.** `displayPair` remembers `{ fighterA, fighterB, stipulation }` while `GetSanctioned()` is a live pair. After the pair is nil, `Refresh` / `Show` still `paintShown` that pair when `eventLive()` (`Runtime` state `~= "QUIET"`). Flipped pin: `DeclareVictor` + still-live event → `view.shown == true`, widget shown, names still painted. A later `Sanction` overwrites `lastPair` (rematch path). No `view.verdict`. |
| Runtime `subjects.fighters` (congregation) | **Pass.** When Gora has no live pair, `subjectsPair` reads snapshot `subjects.fighters[1]` / `[2]` and remembers that pair. Isolated `StartEvent` + `OpenRite("Gora", { fighters })` with `GetSanctioned() == nil` → Show true, those ids, those names. `CloseRite` → CONSEQUENCE still shown. `Continue` clears fighters → lastPair persist. One missing slot (`[1]` or `[2]` nil) returns nil — does not invent a pair. |
| Keep `1-0` | **Pass.** `recordText` is still `wins-losses` arabic. Persist `Refresh` after the first ruling pins plate A `1-0`, plate B `0-1`, H2H `1-0`. Rematch / honorific / defenses pins of the same three strings stay. No `toRoman`. Persist does not invent a verdict qualifier; the tape re-reads Store. |
| No `UnitHealth`; `health` stays nil | **Pass.** `FighterCard.lua` has no `UnitHealth`, `UnitHealthMax`, combat-log, or nameplate scrape. `hiddenView` and `paintShown` both set `health = nil`. Persist and subjects pins re-assert nil. Suite stubs those APIs; Show / subjects / Hide / suite end pin `healthReads == 0`. No `StatusBar`. No `GetHealth` / `ScrapeHealth`. |
| Hide on QUIET / Hide() / EndEvent; no revive | **Pass.** `Refresh` / `Show` call `forgetPersist` + `paintHidden` when not `eventLive`. `Hide()` dismisses the widget and does not clear a live or remembered pair — `Refresh` while the event is live restores (existing Hide contract, now pinned on the subjects path). `EndEvent` then `Refresh` hides. `StartEvent` after that QUIET forget does not revive the last pair (Pope rematch block and subjects block). |
| Isolated green | **Pass.** Reviewer ran `lua tests/test_fighter_card.lua`: **441 passed, 0 failed**, exit 0. Isolation nil-module block (**17** pins) and the standalone summary stay under `if standalone then`. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Hud, Gora; no commit | **Pass.** Provided packet is two `diff --git` hunks: `UI/FighterCard.lua` and `tests/test_fighter_card.lua`. Hud / Gora / Console are not in the packet. No `Gora:GetLastSanctioned` (B10-A exclusive). |
| Same persist rule as the HUD: remember last pair; stay painted after `GetSanctioned()` is nil while Runtime is not QUIET | **Pass.** Named-gate check. Old pin `card hides when the pair clears` is gone. Precedence is live Gora pair, then Runtime subjects, then `lastPair`. |
| Accept Runtime `subjects.fighters` when Gora has no live pair (congregation) | **Pass.** Named-gate check. |
| Hide on QUIET / Hide() / EndEvent; new Sanction replaces; forget on QUIET so later ASSEMBLY does not revive | **Pass.** Named-gate check. `forgetPersist` on QUIET `Refresh` / `Show` and on `ResetForTests`. |
| Flip the mid-event hide pin; QUIET / Hide hidden; Runtime-subjects-only shows; isolation wrap stays | **Pass.** First flipped pin sits in the existing head-to-head / stipulation block. Dedicated subjects block covers OpenRite-only, CONSEQUENCE, Continue persist, Hide+Refresh restore, QUIET hide, and no-revive. Isolation stayed gated. |
| Keep `1-0`; no `UnitHealth`; no flavor | **Pass.** Named-gate checks. Source greps for `rubber` / `ordained` / `one apiece` / `Duke of` / `defenses of the realm` stay. LEFT dock and Morpheus names unchanged. |
| `lua tests/test_fighter_card.lua` exit 0; **POLISH:CANDIDATE** at most | **Pass. Verified.** 441 / 0. Writer claimed that polish ceiling and no more. |

Bible §10.7 (persist through the verdict beat; defined no-live-health fallback), Law 6 (Quiet hides Event chrome), Law 4 (no invented verdict copy), Law 8 (no health hack), and the B3-B / B6-D / B8-C mute-tape pins (`1-0`, honorifics, defense integers) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; **POLISH:CANDIDATE** only | **Not a spec miss.** Brief asked isolated green. See Minor. |
| `lastPair` is card-local; first paint after `DeclareVictor` with no remembered pair and no subjects stays hidden | **Matches the brief + B9-E.** This lane does not edit Gora. Catch-up / `GetLastSanctioned` is not this exclusive pair. |
| Store W/L updates on persist paint (`1-0` at the ruling) | **Not a verdict qualifier.** Tape re-reads Store. Brief said keep `1-0`. No `view.verdict`, no “Victor declared” copy. |
| `Hide()` does not forget `lastPair`; Refresh while the event is live restores | **Matches the existing Hide contract** and the subjects pin. Forget is the QUIET path. |
| Cowardice / Void share the persist path; only `DeclareVictor` is pinned | **Not a miss.** Brief keys off `GetSanctioned()` nil + not QUIET. See Minor. |
| A01 still NOT RUN; no `UnitHealth` | **Not a miss.** Brief forbade opening it. |
| Hud / Gora were not edited | **Not a miss.** Exclusive card-only persist. |
| Integrator still lists the files in the TOC and `run.lua` | **Not a miss.** Brief forbade those edits. Already listed. |

---

## Strengths

- Exclusive pair is small and on-contract. Dress, LEFT dock, Morpheus names, honorifics, mute defense integers, and A01 were not reopened.
- Persist is fail-closed on Quiet: `forgetPersist` runs before `paintHidden` in `Refresh` / `Show`, so a later ASSEMBLY cannot revive the last pair once a QUIET paint has run. `ResetForTests` uses the same forget.
- Remembered pair is ids + the Pope stipulation. Paint still goes through `fighterFrom` / Store. The card does not keep a stale name table and does not invent a congregation stipulation.
- Congregation capability is real: no `Gora:Sanction`, two Runtime fighter ids, card shown. Empty Gora + empty subjects + no `lastPair` stays hidden.
- Isolation stayed gated (17). Writer-reported 441 / 0 matches the reviewer run.

---

## Issues

### Critical

None.

### Important (must-fix)

None.

### Minor

1. **Forget is Refresh-lazy, and production EndEvent only `Hide()`s.** `forgetPersist` runs inside `Refresh` / `Show` when not `eventLive`. Glue `afterEndEvent` calls `FighterCard:Hide()` and does not `Refresh`. `Hide()` never forgets. A later ASSEMBLY `Refresh` with no new pair would revive the last event’s fighters. The suite hides that hole by `Refresh`ing during QUIET before `StartEvent`. HUD persist is saved because Console `EndEvent` `refreshHud`s. Exclusive-legal hardening: `Hide()` should `forgetPersist` when not `eventLive` (mid-event Hide still restores). Integrator alternative: `Refresh` on QUIET STATE, not only `Hide`.

2. **Subjects overwrite can drop a remembered stipulation.** After `DeclareVictor`, `displayPair` prefers `subjectsPair` over `lastPair`. `rememberPair(subjects)` copies `stipulation = nil` and wipes a Pope line that was stored from the live `GetSanctioned` pair. The first persist block never `OpenRite`s, so the suite does not see the wipe. Typical Pope path is Open Gora (fighters) then Sanction (optional line). Merge: keep `lastPair.stipulation` when subjects name the same ids.

3. **`subjectsPair` type-check is looser than HUD B10-B.** HUD requires two numbers. The card accepts any non-nil `[1]` / `[2]`. Production Runtime / Codec already refuse non-integer fighter lists, so this does not invent a pair on the star. A stubbed snapshot with strings would `paintShown` empty-name plates.

4. **Cowardice / Void / FreeRuling persist is implemented, not pinned.** All three clear the live pair. Only `DeclareVictor` is in the suite.

5. **A new different pair replacing `lastPair` is unpinned.** Rematch is the same ids. `rememberPair` overwrites on any live `GetSanctioned` or two-id subjects list.

6. **Head-to-head and W/L can appear at the ruling.** First persist `Refresh` re-reads Store, so `1-0` / H2H can land on the card at the same beat as `DeclareVictor`. Writer disclosed it. Not a qualifier; it can still read as the card announcing the winner. Brief required keep `1-0`.

7. **`lastPair` is module-local.** `/reload` or a late join during CONSEQUENCE with `GetSanctioned()` already nil and subjects already cleared has nothing to remember. Catch-up / `GetLastSanctioned` / integrator `stateFields` last pair is not this lane.

8. **Congregation subjects path is capability, not wire.** Glue `showFighterCard` runs on `Gora:Sanction` only (Pope). Inbound STATE Refreshs the HUD, not the card. Isolated `OpenRite` + `Show` is what the brief asked. A logged-in congregation client will not paint subjects until something calls `Show` / `Refresh` (Init on login / reload is the current hook).

9. **One-id refuse is implemented, not pinned.** `fighters[2] == nil` returns nil. B10-B pinned the sibling on the HUD.

10. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated suite was re-run here. Do not treat this as **POLISH:PASS**.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

The exclusive pair does what the brief asked: after `DeclareVictor` the card stays shown while the event is live; Quiet / EndEvent hides and a later ASSEMBLY does not revive once QUIET has been painted; Runtime `subjects.fighters` show the card when Gora has no live pair; `health` stays nil; no `UnitHealth`; painted W–L / H2H stay `1-0`; isolated suite green (441 / 0). Named gates are clean. Nits are Refresh-lazy forget versus glue Hide-only on EndEvent, subjects overwriting a remembered stipulation, unpinned Cowardice/Void/new-pair/one-id paths, and unsmoked theater — not trust-breakers.

Must-fix list: **none.**

Do not sign. Do not claim **POLISH:PASS**. Do not claim V1 / MVP complete.
