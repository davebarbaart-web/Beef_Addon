Spec PASS

# B26-D — Console dock Init remounts ESC (review)

**Quality:** Approved-with-nits

**Lane:** B26-D Console dock Init remounts ESC
**Brief:** `docs/reformation/vestments/briefs/B26-D-dock-special.md`
**Writer report:** `docs/reformation/vestments/briefs/B26-D-dock-special-report.md`
**Diff:** `docs/reformation/vestments/briefs/B26-D-dock-special.diff` (B26-D-only exclusive-pair packet; live `ConsoleDock.lua` / `test_console_dock.lua` are still untracked vs HEAD and also carry earlier dock batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/ConsoleDock.lua` (`Init` existing-frame: `rememberSpecial(FRAME_NAME)` then `self:Refresh()`; create-path `build()` still `rememberSpecial(FRAME_NAME)` once; `rememberSpecial` still scan-then-append), and `tests/test_console_dock.lua` (isolation wrap, persist / ESC / B24-B per-event dismiss pins, `runB26D()` after B24-B); then ran `lua tests/test_console_dock.lua` (**353 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames` (named frame); B22-D leftover (`rememberSpecial` lived only in `build()`; a wiped list then second Init never put `ChurchOfBeefConsoleDock` back); existing-frame `Init` still `rememberSpecial(FRAME_NAME)` then Refresh; do not rebuild; B24-B `eventId` dismiss stays. Law 6 / §19.4 (Quiet silent; no `PlaySound` / `IG_CHARACTER_INFO_*`); Law 10 / Bible §19.3 (functional / stock dock; no parchment); Bible §18.1 collapsible Director Console. Title stays `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. Did not mutate `ConsoleDock.lua` or `test_console_dock.lua`. Did not commit. Did not edit Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Existing-frame `Init` still skips `rememberSpecial` (B22-D leftover) | **Pass. Verified.** Live order after `if not frame then return nil end` is `rememberSpecial(FRAME_NAME)` then `self:Refresh()` then `return frame`. Pins: wipe `UISpecialFrames` to `{}`, second Init lists `ChurchOfBeefConsoleDock` once. Reviewer probe: wipe leaves count 0; second Init returns the same pointer and count is 1; third Init still 1. Source capture of that remount body is the call then Refresh. |
| Existing-frame `Init` rebuilds | **Pass. Verified.** Remount body has no `build()` / `CreateFrame` / `PlaySound`. Pins: second Init returns the existing frame; wrapped `CreateFrame` saw 0 calls. Reviewer spy: wrapped `CreateFrame` saw **0** calls on wipe+Init, third Init, Init-while-shown, and Init after dismiss. |
| Wipe remount duplicates `ChurchOfBeefConsoleDock` | **Pass. Verified.** `rememberSpecial` still dedupes (`UISpecialFrames[i] == name` then return; else `# + 1`). First Init lists once even though create-path `build()` and `Init` both register. Pins: once before wipe; once after wipe+Init; third Init still once. Reviewer probe: first Init stays 1; wipe+Init+Init stays 1. Live source has **2** `rememberSpecial(FRAME_NAME)` sites (`build()` + existing-frame `Init`). |
| B24-B per-event dismiss dies on remount / Refresh | **Pass. Verified.** Same-event Hide + Refresh stays hidden inside `runB26D()`. B24-B block above the nest is intact. Reviewer probe: live Hide then wipe then Init remounts the name once, returns the same pointer, stays hidden, and is not `EndEvent`; same-event Refresh stays hidden; `EndEvent` then `StartEvent` + Refresh **shows** on the new `eventId`. |
| Title / CloseButton / persist / SANCTION + Expand / sound / parchment | **Pass.** `TITLE` is still exactly `DIRECTOR CONSOLE`. CloseButton stays `Hide()`d. `ui.consoleDock` / `ANCHORS` / stock `BasicFrameTemplate` / SANCTION + Expand pins stay after the nest. Source has no `PlaySound`, `IG_CHARACTER_INFO`, `parchment`, or `cooldown`. Suite `sounds == 0`. Reviewer spy: remount / dismiss / new-event path stays 0. |
| New main-chunk local (`runB26D`) breaks the Lua 5.1 200-local cap | **Pass. Leftover / nit, not must-fix.** `runB26D` is one new main-chunk `local function` after the B24-B pins. Wipe-remount locals sit inside it. `luac -l -p tests/test_console_dock.lua`: main chunk **55 locals** (cap 200). Brief did not require zero new main-chunk locals. |
| Isolated suite not exit 0 / exclusive file breach | **Pass. Verified.** 353 passed, 0 failed. Writer-reported count matches. Lane implementation is the two named files. Packet is two hunks (header remount note + existing-frame `rememberSpecial`; header comment + `runB26D()`). Both exclusive files are still untracked vs HEAD. Sibling dirt in this workspace is other lanes (Console, TOC, bootstrap, `run.lua`). Reviewer did not mutate the exclusive pair. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Console, glue; no commit | **Pass.** Named-risk check. |
| When the frame already exists, `Init` still calls `rememberSpecial(FRAME_NAME)` then Refresh | **Pass.** Live order. Source pin in `runB26D()`. Reviewer capture is that call then `self:Refresh()` then `return frame`. |
| Do not rebuild | **Pass.** Named-risk check. |
| B24-B per-event dismiss stays | **Pass.** Named-risk check. Same-event Hide + Refresh stays hidden. New `eventId` still shows. |
| Init, wipe `UISpecialFrames` to `{}`, second Init: `ChurchOfBeefConsoleDock` listed exactly once. Same frame pointer | **Pass.** Named-risk check. Third Init is an extra keep-pin. |
| Existing persist / per-event dismiss / ESC pins stay | **Pass.** Persist remount / title / hidden CloseButton / SANCTION + Expand / `eventId` / no-cooldown pins below the nest stay green. B22-D uniqueness-once and missing-table pins above the nest stay. |
| Isolation wrap stays; `lua tests/test_console_dock.lua` exit 0 | **Pass.** **353 / 0.** Wrap still **24** under `if standalone then`. |

The leftover (`rememberSpecial` lived only in `build()`; a wiped list then second Init never put `ChurchOfBeefConsoleDock` back) is closed on the existing-frame `Init` path. Law 6 (no panel whoosh), Law 10 / license 4 (stock dock, hidden CloseButton), wiki ESC via `UISpecialFrames`, and B24-B `eventId` dismiss hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| `Refresh` / `Show` on an existing frame still skip `rememberSpecial` | **On contract / leftover.** Brief scoped `Init`. Production `MainFrame` calls `Init`; event furniture (`ChurchOfBeef.lua`) calls `Refresh` only. A wipe then Refresh-only or Show-only does not put the name back until the next `Init`. Glue is not required. |
| No client smoke; real ESC vs `CloseSpecialWindows` on Anniversary is unproven | **Not a miss.** Brief asked isolated green + wipe-to-`{}` then second Init lists once. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key; membership counts are pinned, the client's special-frame walk is not | **Not a miss.** Brief asked membership counts. |
| Parked Console leftover (selected-pair inherit of Core `namedOpponent`) | **Not this lane.** Batch 26 overview parks it on B26-A. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / remount / dismiss

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + ConsoleDock. Stub Sender / Console only. No `dofile` of Console / Hud / Toasts / Net / DB / glue. Standalone wrap is still **24** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Decree, slash). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). `runB26D()` re-pins **5** (Hud, Toasts, DecreeBanner, RecordsBook, slash). New remount locals sit in `runB26D()`.

**Existing-frame remount — Pass.** `if not frame then frame = build() end` then, when the widget exists, `rememberSpecial(FRAME_NAME)` then `Refresh`. It does not `build()`, does not `CreateFrame`, and does not `PlaySound`. Create-path `build()` still calls `rememberSpecial(FRAME_NAME)` once after Expand. `rememberSpecial` still type-guards a missing table and returns when the name is already listed. First Init lists once despite both sites firing.

**Dismiss / uniqueness — Pass.** Wipe-to-empty then Init lists `ChurchOfBeefConsoleDock` once and returns the same pointer. Third Init stays once. Same-event Hide + Refresh stays hidden. Reviewer probe: dismiss then wipe then Init remounts once, stays hidden, and keeps the live `eventId`; next StartEvent + Refresh shows. First-create ESC membership pin and persist uniqueness-once pin stay above / below the nest.

---

## Strengths

- The delta is the brief: one existing-frame `rememberSpecial(FRAME_NAME)` before Refresh. Create-path register, B24-B `eventId` dismiss, title, persist, SANCTION + Expand, and hidden CloseButton were left alone. ConsoleDock gained no new file local (`luac`: **34** locals).
- Wipe-to-`{}` then second Init is the leftover close, not only a source `find`. Frame identity and wrapped `CreateFrame` 0 are pinned. The first-create uniqueness-once pin was left in place above the nest.
- Same-event dismiss is re-pinned after the remount, so a remount that cleared `dismissedEventId` would fail. B24-B new-event show stays above the nest.
- Isolation stayed gated. Remount locals are inside `runB26D()`. Writer-reported **353 / 0** matched the re-run. Writer-reported red (**349 / 4**) matches the four asserts old existing-frame `Init` (Refresh only) would fail: remount `rememberSpecial` string; wiped + second Init lists once; third Init lists once; dismiss-after-wipe count stays 0.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`Refresh` / `Show` still skip `rememberSpecial` when the frame exists.** Reviewer probe: wipe the list, `Refresh` leaves count 0; wipe then `Show` paints the same widget and leaves count 0. `Show` only calls `Init` when `frame` is nil. Production event furniture calls `Refresh`, not `Init`. Brief scoped `Init`. A dropped name does not come back until the next `Init` (typically `MainFrame` / `/reload`). **POLISH:CANDIDATE** is the ceiling if anyone claims feel. Glue is not required.

2. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the dock together with other named Beef frames. Brief asked `Init` remount + uniqueness once, not a client walk.

### Nit

1. **One new main-chunk local (`runB26D`).** Wipe-remount locals are nested (correct 200-local hygiene). Main chunk is **55 / 200**. Not a cap break. Brief did not require zero new main-chunk locals. Leftover / nit only.

2. **`src:find("rememberSpecial(FRAME_NAME)")` as “build still rememberSpecial” matches either site.** Live `build()` still has the call before `return widget` (first find is that site). The remount capture is the pin that actually proves the new site.

3. **`UISpecialFrames = nil` is unpinned inside `runB26D()`.** Older pin above the nest still proves `Init` survives a missing table. Probe: `Init` with nil leaves it nil; assigning `{}` then Init lists the name once. Brief asked wipe to `{}`.

4. **Harness `Hide()` is not ESC. Stub `CreateFrame` does not mint `_G["ChurchOfBeefConsoleDock"]`.** Reviewer probe: `_G.ChurchOfBeefConsoleDock == nil`. Production `CreateFrame("Frame", FRAME_NAME, …)` does. Same stub gap other named-special-frame lanes named.

5. **Exclusive-pair diff is not a vs-HEAD ConsoleDock delta.** Packet is the B26-D-only remount + pins. Both exclusive files are still untracked vs HEAD and also carry earlier dock batches. Report already says this.

6. **Isolation wrap is load-only.** Twenty-four pins under the load-time `if standalone then`. `runB26D()` re-pins five. Brief said the wrap stays; it did.

7. **No full `lua tests/run.lua`.** Isolated **353 / 0** was re-run here.

8. **Parked Batch 26 Console leftover** (selected-pair inherit of Core `namedOpponent`) is other work. Not this exclusive pair.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **353 passed, 0 failed.** Isolation wrap: **24**. `runB26D()` re-pins: **5**. Main-chunk locals: **55 / 200**.

`ConsoleDock:Init` on an existing frame calls `rememberSpecial(FRAME_NAME)` then Refresh. It does not rebuild and does not `PlaySound`. Wipe `UISpecialFrames` to `{}` then second Init lists `ChurchOfBeefConsoleDock` exactly once and returns the same pointer. B24-B per-event dismiss stays. Persist / title / SANCTION + Expand / hidden CloseButton stay. One new main-chunk local (`runB26D`) is leftover / nit, not a 200-local break. Isolated `lua tests/test_console_dock.lua` **353 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
