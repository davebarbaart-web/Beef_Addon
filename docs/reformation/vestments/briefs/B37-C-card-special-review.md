Spec PASS

# B37-C — FighterCard Hide remounts UISpecialFrames membership (review)

**Quality:** Approved-with-nits

**Lane:** B37-C FighterCard Hide remounts UISpecialFrames membership
**Brief:** `docs/reformation/vestments/briefs/B37-C-card-special.md`
**Writer report:** `docs/reformation/vestments/briefs/B37-C-card-special-report.md`
**Diff:** `docs/reformation/vestments/briefs/B37-C-card-special.diff` (B37-C-only exclusive-pair packet; live `FighterCard.lua` also carries earlier card batches vs HEAD / untracked tree)
**Exclusive files:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/FighterCard.lua` (`rememberSpecial` / `wireCardOnHide` / `build` / `FighterCard:Init` / `Refresh` / `Show` / `Hide` / `paintHidden` / `hiddenView` / `forgetPersist` / `FRAME_NAME` / `NAME_FONT`), and `tests/test_fighter_card.lua` (isolation wrap, persist / health-nil / Morpheus / B28-D Init / B29-C Show/Refresh / B30-B Hide OnHide remount pins, nested `runB37C()` inside `runB28D()` after `runB30B()`); then ran `lua tests/test_fighter_card.lua` (**660 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); Bible §10.6 (mute tape), §10.7 (persist through the verdict beat); Law 6 / §19.1 (Quiet hides Event chrome); Law 10 / §19.3 (theatrical card, no close ✕); B30 leftover: `Hide` remounted `wireCardOnHide` only; `rememberSpecial` was Init-only; wiped list + Hide-only left ESC idle until Init. Existing-frame `Hide`: `rememberSpecial(FRAME_NAME)` then existing OnHide remount + `paintHidden()`. `FRAME_NAME` is `ChurchOfBeefFighterCard`. Never replace an existing OnHide. No OnShow re-wire. No rebuild. No `PlaySound`. lastPair until QUIET stays. Did not mutate `FighterCard.lua` or `test_fighter_card.lua`. Did not commit. Did not edit Hud, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Existing-frame `Hide` still skips `rememberSpecial` (B30 leftover) | **Pass. Verified.** Live `Hide` is `if frame then rememberSpecial(FRAME_NAME)` then `wireCardOnHide(frame)` then `paintHidden()`. Pins: Hide body `rememberSpecial(FRAME_NAME)` before `wireCardOnHide` before `paintHidden`; wipe `UISpecialFrames` to `{}`, Hide lists `ChurchOfBeefFighterCard` once. Reviewer probe: wipe leaves count 0; Hide lists once; a neighbor `OtherFrame` stays; no-frame Hide does not `rememberSpecial` and does not `CreateFrame`. |
| `Hide` / helper replaces an existing OnHide | **Pass. Verified.** Helper is `if existing then return`. Pins: existing OnHide identity after Hide / second Hide / third Hide. Reviewer spy: wrapped `SetScript` saw **0** calls on Hide with the live script and with a sentinel OnHide. Sentinel identity stayed. Niled Hide still restores via the B30-B helper (`SetScript` delta **1** named `OnHide`). |
| Restore rebuilds, wires OnShow, or plays sound | **Pass. Verified.** Hide remount body has no `SetScript` / `OnShow` / `CreateFrame` / `PlaySound` / `IG_CHARACTER_INFO` / `UnitHealth` / `forgetPersist`. Pins: wrapped `CreateFrame` 0; `OnShow` stays nil; `sounds` unchanged across remount. Reviewer probe: `CreateFrame` delta **0** on remount Hide, third Hide, and no-frame Hide. Source has no `PlaySound`. |
| Wipe remount duplicates `ChurchOfBeefFighterCard`; `FRAME_NAME` drifts | **Pass. Verified.** `rememberSpecial` still scan-then-append. Pins: live card listed once before wipe; wipe+Hide once; second Hide once; third Hide once. `GetName()` stays `ChurchOfBeefFighterCard`. Reviewer probe: wipe to `{ "OtherFrame" }` then Hide keeps the neighbor and lists the card once. `rememberSpecial(FRAME_NAME)` sites are **2** (Init + Hide). |
| lastPair forgotten; ASSEMBLY after QUIET revives; `NAME_FONT` / `UnitHealth` / close ✕ / drag persist | **Pass. Verified.** Hide does not `forgetPersist`. Pins: Refresh after remount Hide still paints Chuckroast / Tendermage; `health` nil; suite persist / ASSEMBLY-after-QUIET pins sit above the nest. Reviewer probe: EndEvent then Refresh is hidden; later StartEvent still hidden. Live `NAME_FONT` is `Fonts\\MORPHEUS.ttf`. Source has no `UnitHealth`, `PlaySound`, `CloseButton`, `✕`, `CreateFrame("Button"`, `MORPHEUS_CYR`, `RegisterForDrag`, or `savePoint`. Reviewer probe: `countType(widget, "Button")` is **0**. |
| Show / Refresh / Init remount dropped; isolation / persist pins drop | **Pass. Verified.** Live Init still `wireCardOnHide` then `rememberSpecial` then `Refresh`. Show / Refresh still remount OnHide only (no `rememberSpecial`). Pins: B28-D / B29-C / B30-B blocks sit above `runB37C()`; B37-C re-reads Init `rememberSpecial` + `wireCardOnHide`. Isolation wrap is still **17** nils under `if standalone then`. Reviewer probe: wrap keys (Net / UI / Hud / Toasts / Console / Decree / RecordsBook / Sound) are nil at load. |
| Isolated suite not exit 0 / new main-chunk pin block | **Pass. Verified.** 660 passed, 0 failed. Writer-reported count matches. New pin locals live in `runB37C()` nested inside `runB28D()` after `runB30B()`. Isolation wrap stays under the load-time standalone block. `luac -l -p`: main chunk **59** locals (cap 200; same as B30-B). FighterCard file locals **52**. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two unified hunks (Hide exists-path `rememberSpecial(FRAME_NAME)` before OnHide remount; header comment + nested `runB37C()`). Both exclusive files are still untracked vs HEAD. Sibling dirt in this workspace is other lanes (`Hud.lua`, `ChurchOfBeef.lua`, TOC, `tests/run.lua`, OPEN_QUESTIONS, REFORMATION_LOG). Reviewer did not mutate the exclusive pair. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Hud, glue; no commit; no `PlaySound`; no drag persist | **Pass.** Named-risk check. `build()` still `EnableMouse(false)`. No `RegisterForDrag` / `savePoint`. |
| Existing-frame `Hide`: `rememberSpecial(FRAME_NAME)` then OnHide remount + `paintHidden` | **Pass.** Live order. Source pin in `runB37C()`: `rememberSpecial(FRAME_NAME)` before `wireCardOnHide` before `paintHidden`. No-frame `Hide` still `paintHidden()` only. |
| `FRAME_NAME` is `ChurchOfBeefFighterCard`. Never replace an existing OnHide. No OnShow re-wire. No rebuild | **Pass.** Named-risk check. |
| Wipe `UISpecialFrames`, Hide: name re-listed once. Third Hide does not duplicate | **Pass.** Nested runtime pins. Reviewer probe matches. |
| lastPair until QUIET stays | **Pass.** Named-risk check. Hide does not `forgetPersist`. ASSEMBLY after QUIET stays hidden. |
| Tests after `runB30B()` inside `runB28D()`. Isolation wrap stays. `lua tests/test_fighter_card.lua` exit 0 | **Pass.** **660 / 0.** Wrap still **17** under `if standalone then`. `runB37C()` sits inside `runB28D()` after `runB30B()`. |

B30 leftover (`Hide` remounted `wireCardOnHide` only; `rememberSpecial` was Init-only; a wiped list + Hide-only left ESC idle until Init) is closed on the existing-frame `FighterCard:Hide` path. Init remount from B28-D stays. Show / Refresh remount OnHide from B29-C stay and still skip `rememberSpecial`. Law 6 (Quiet after End does not keep the card), Law 10 (no close ✕), §10.6 mute tape (no `UnitHealth`, no `PlaySound`), lastPair until QUIET, wiki ESC via a named `UISpecialFrames` entry, and B20-C Morpheus hold on the exclusive pair.

### Law check

| Law | Verdict |
|---|---|
| Wiki ESC — named frame on `UISpecialFrames`; do not PlaySound `IG_CHARACTER_INFO_*` | **Hold.** `FRAME_NAME` stays `ChurchOfBeefFighterCard`. Hide remounts that name. Source has no `PlaySound` / `IG_CHARACTER_INFO`. |
| Bible §10.6 mute tape / §10.7 persist through the verdict | **Hold.** No `UnitHealth`. Hide does not `forgetPersist`. Refresh while the event is live still paints the pair. `health` stays nil. |
| Law 6 / §19.1 Quiet hides Event chrome | **Hold.** EndEvent then Refresh is hidden. ASSEMBLY after QUIET does not revive lastPair. Card `MODE` stays Event. |
| Law 10 / §19.3 theatrical card, no close ✕ | **Hold.** No close button. `countType(..., "Button")` is **0**. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. |
| Law 4 — software never narrates | **Hold.** No new flavor. Existing mute-tape source pins stay. |

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Widget Hide / ESC does not remount `rememberSpecial`. `CloseSpecialWindows` / `frame:Hide()` bypass `FighterCard:Hide`. A wiped list that never hits Hide / Show / Refresh / Init stays idle | **Allowed leftover.** Brief scoped remount on `FighterCard:Hide`. Reviewer probe: wipe then `widget:Hide()` leaves count 0; lastView still syncs via the existing OnHide. |
| Show / Refresh still skip `rememberSpecial`. A wipe then Show-only or Refresh-only still leaves ESC idle until Init or Hide | **Allowed leftover.** Brief asked Hide remount only. Reviewer probe: wipe then Show / Refresh leave count 0 and still paint Chuckroast / Tendermage. |
| `ResetForTests` still `paintHidden()` and does not remount | **On contract.** Harness-only. Reviewer probe: wipe then `ResetForTests` leaves count 0. |
| `UISpecialFrames = nil` still no-ops `rememberSpecial` | **On contract.** Brief asked wipe-to-empty uniqueness. Reviewer probe: Hide with nil leaves it nil; assigning `{}` then Hide lists the name once. |
| No client smoke; a live remount that dropped the name is simulated by `UISpecialFrames = {}` | **Not a miss.** Brief asked isolated green + wipe-to-`{}` then Hide lists once. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key. Stub `CreateFrame` does not mint `_G["ChurchOfBeefFighterCard"]` | **Not a miss.** Reviewer probe: `_G.ChurchOfBeefFighterCard == nil`. Production `CreateFrame("Frame", FRAME_NAME, …)` does. Membership counts are pinned; the client's special-frame walk is not. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / remount / persist

**Isolation wrap — Pass.** Load list is still Common + Ranks + Store + Runtime + Gora + FighterCard. No `dofile` of Hud, UI shell, Net, DB, or glue. Standalone wrap is still **17** nils (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Sound, DecreeBanner, RecordsBook). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). New asserts sit in `runB37C()` inside `runB28D()` after `runB30B()` so Lua 5.1's 200-local cap does not fire.

**Existing-frame remount — Pass.** `Hide` calls `rememberSpecial(FRAME_NAME)` when `frame` exists, then `wireCardOnHide(frame)`, then `paintHidden()`. The helper no-ops when a script exists and writes `lastView = hiddenView()` then `paintHidden` unless `hiding` only when OnHide is nil. It does not `build()`, does not `CreateFrame`, does not `PlaySound`, and does not wire OnShow. Init remount still calls `rememberSpecial`. Show / Refresh remount OnHide only. Reviewer spy: existing / sentinel / third Hide `SetScript` delta 0; niled Hide delta 1 named OnHide. `CreateFrame` delta 0 on remounts. Hide with no frame does not `Init` and does not `rememberSpecial`.

**Persist / uniqueness — Pass.** Wipe-to-empty then Hide lists `ChurchOfBeefFighterCard` once and keeps the same OnHide pointer. Third Hide stays once and keeps identity. Refresh while the event is live still paints Chuckroast / Tendermage. Reviewer probe: remount Hide is not `EndEvent`; ASSEMBLY after QUIET stays hidden. `health` stays nil. Suite persist / OnHide lastView / B28-D / B29-C / B30-B pins stay above the nest.

---

## Strengths

- The delta is the brief: one `rememberSpecial(FRAME_NAME)` call on the Hide exists-path, before the existing OnHide remount + `paintHidden`. An existing script is not replaced. The widget is not rebuilt. Init remount stays. Show / Refresh were not taught `rememberSpecial`. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`.
- B30 leftover (wiped list stayed empty across Hide; ESC idle until Init) is closed with a runtime remount, not only a source `find`. Third-Hide uniqueness would fail a scan-less append.
- Existing OnHide identity, `CreateFrame` 0, no OnShow, no `forgetPersist`, and Refresh lastPair / health-nil sit next to the wipe pins, so a rebuild, a replace-every-Hide helper, or a persist wipe would fail.
- Persist / health-nil / Morpheus / B28-D Init / B29-C Show/Refresh / B30-B Hide OnHide / isolation pins were left above the nest. Isolation stayed gated. New locals are inside `runB37C()` inside `runB28D()` after `runB30B()`.
- Writer-reported **660 / 0** matched the re-run. Writer-reported red (**654 / 6**) matches the Hide-body-missing-`rememberSpecial` + wiped-list-stayed-0 cluster that pre-B37-C Hide would fail.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Widget Hide / ESC does not remount `rememberSpecial`.** Reviewer probe: wipe then `widget:Hide()` leaves count 0. `CloseSpecialWindows` walks names and calls `Frame:Hide`, not `FighterCard:Hide`. A wiped list that never hits Hide / Init stays idle. Brief scoped remount on `FighterCard:Hide`.

2. **Show / Refresh still skip `rememberSpecial`.** Reviewer probe: wipe then Show / Refresh leave count 0 and still paint the live pair. Brief asked Hide remount only.

3. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the card with other listed chrome. Brief asked isolated remount + uniqueness once, not a client walk.

### Nit

1. **Third-Hide identity is a keep after the existing-OnHide pin.** `runB37C()` asserts `existingOnHide ~= nil` before Hide, so `nil == nil` cannot pass the identity pin. Uniqueness is the pin that would fail a scan-less append.

2. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. `runB37C()` does not re-pin them. Brief said the wrap stays; it did.

3. **Exclusive-pair diff is not a vs-HEAD FighterCard delta.** Packet is the B37-C-only exists-path call + nested pins. Both exclusive files are still untracked vs HEAD and also carry earlier card batches. Report already says this.

4. **`runB37C()` adds no new main-chunk local.** Brief asked isolation wrap stays, not zero new chunk locals. Pin locals sit inside the nest. `luac` main chunk is **59 / 200**.

5. **`UISpecialFrames = nil` is unpinned inside `runB37C()`.** Older Init-survives-missing-table behavior stays. Probe: Hide with nil leaves it nil. Brief asked wipe to `{}`.

6. **Harness `Hide()` is not ESC. Stub `CreateFrame` does not mint `_G["ChurchOfBeefFighterCard"]`.** Reviewer probe: `_G.ChurchOfBeefFighterCard == nil`. Same stub gap other named-special-frame lanes named.

7. **Stub `IsMouseEnabled` is unmodeled.** `build()` still calls `EnableMouse(false)` and has no `RegisterForDrag`. Brief said no drag persist; that holds on source.

8. **No full `lua tests/run.lua`.** Isolated **660 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **660 passed, 0 failed.** Isolation wrap: **17**. Main-chunk locals: **59 / 200**. FighterCard file locals: **52**.

Existing-frame `FighterCard:Hide` calls `rememberSpecial(FRAME_NAME)` then `wireCardOnHide(frame)` then `paintHidden()`. The helper does not replace an existing script and does not wire OnShow. Wipe `UISpecialFrames` to `{}`, Hide lists `ChurchOfBeefFighterCard` exactly once and keeps the same OnHide pointer. Third Hide stays once. No rebuild. No `PlaySound`. lastPair until QUIET stays. `FRAME_NAME` stays `ChurchOfBeefFighterCard`. B30-B Hide OnHide remount stays. B29-C Show / Refresh remount stay and still skip `rememberSpecial`. B28-D Init remount stays. No new main-chunk local. Isolated `lua tests/test_fighter_card.lua` **660 passed, 0 failed**, exit 0.

### Leftovers

- Widget Hide / ESC does not remount `rememberSpecial`. A wiped list that never hits `FighterCard:Hide` / Init stays idle.
- Show / Refresh still skip `rememberSpecial`.
- `ResetForTests` does not remount. `UISpecialFrames = nil` still no-ops.
- No `/reload` smoke; real ESC vs `CloseSpecialWindows` is unproven. ESC walks names and calls `Frame:Hide`, not `FighterCard:Hide`.
- Full `lua tests/run.lua` not run.
- Harness membership counts are pinned; the client's special-frame walk is not. Stub `CreateFrame` does not mint `_G["ChurchOfBeefFighterCard"]`.
- Exclusive-pair diff is the B37-C-only delta, not vs HEAD.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W / Gate V / POLISH:PASS.
