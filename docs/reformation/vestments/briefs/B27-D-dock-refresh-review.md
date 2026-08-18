Spec PASS

# B27-D — Dock Refresh / Show remount ESC (review)

**Quality:** Approved-with-nits

**Lane:** B27-D Dock Refresh / Show remount ESC
**Brief:** `docs/reformation/vestments/briefs/B27-D-dock-refresh.md`
**Writer report:** `docs/reformation/vestments/briefs/B27-D-dock-refresh-report.md`
**Diff:** `docs/reformation/vestments/briefs/B27-D-dock-refresh.diff` (B27-D-only exclusive-pair packet; live `ConsoleDock.lua` / `test_console_dock.lua` are still untracked vs HEAD and also carry earlier dock batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/ConsoleDock.lua` (`Refresh` / `Show` existing-frame remount `rememberSpecial(FRAME_NAME)` after the nil-frame return and before `mayShow`; `Init` remount + `build()` register stay; `rememberSpecial` still scan-then-append), and `tests/test_console_dock.lua` (isolation wrap, persist / ESC / B24-B per-event dismiss / B26-D Init remount pins, `runB27D()` after `runB26D()`); then ran `lua tests/test_console_dock.lua` (**414 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames` (named frame); B26 leftover (`Refresh` / `Show` skipped `rememberSpecial`; a wiped list then Refresh-only or Show-only never put `ChurchOfBeefConsoleDock` back); existing-frame `Refresh` / `Show` still `rememberSpecial(FRAME_NAME)`; do not rebuild; B24-B `eventId` dismiss stays; B26-D Init remount stays. Law 6 / §19.4 (Quiet silent; no `PlaySound` / `IG_CHARACTER_INFO_*`); Law 10 / Bible §19.3 (functional / stock dock; no parchment); Bible §18.1 collapsible Director Console. Title stays `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. Did not mutate `ConsoleDock.lua` or `test_console_dock.lua`. Did not commit. Did not edit Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Existing-frame `Refresh` / `Show` still skip `rememberSpecial` (B26 leftover) | **Pass. Verified.** Live order after the nil-frame `GetView` / `return false` is `rememberSpecial(FRAME_NAME)` then `if not mayShow()`. Pins: Init, wipe `UISpecialFrames` to `{}`, Refresh-only lists `ChurchOfBeefConsoleDock` once; wipe again, Show-only lists once. Reviewer probe: wipe leaves count 0; Refresh-only returns the same pointer and count is 1; wipe then Show-only is 1; second Refresh / second Show stay 1. Source captures of those remount bodies are the call then `mayShow`. |
| Existing-frame `Refresh` / `Show` rebuild | **Pass. Verified.** Remount bodies have no `build()` / `CreateFrame` / `PlaySound`. Show remount has no `Init()`. Pins: wrapped `CreateFrame` saw 0 calls on wipe+Refresh-only and wipe+Show-only. Reviewer spy: wrapped `CreateFrame` saw **0** calls on those paths, wipe+Init, wipe+Refresh while dismissed, and Show after dismiss. |
| Wipe remount duplicates `ChurchOfBeefConsoleDock` | **Pass. Verified.** `rememberSpecial` still dedupes (`UISpecialFrames[i] == name` then return; else `# + 1`). Pins: once before wipe; once after wipe+Refresh; once after wipe+Show; second Refresh / second Show still once. Reviewer probe: first Init stays 1; wipe+Refresh+Refresh stays 1; wipe+Show+Show stays 1. Live source has **4** `rememberSpecial(FRAME_NAME)` sites (`build()` + existing-frame `Init` + `Refresh` + `Show`). |
| B24-B per-event dismiss dies on remount / Refresh | **Pass. Verified.** Same-event Hide + Refresh stays hidden inside `runB27D()`. B24-B block above `runB26D()` is intact. B26-D nest still re-pins same-event Hide + Refresh. Reviewer probe: live Hide then wipe then Refresh remounts the name once, returns the same pointer, stays hidden, and is not `EndEvent`; same-event Refresh stays hidden; `Show()` after dismiss remounts and **shows**; `EndEvent` then `StartEvent` + Refresh **shows** on the new `eventId`. |
| B26-D Init remount dies | **Pass. Verified.** Existing-frame Init body is still `rememberSpecial(FRAME_NAME)` then `self:Refresh()` then `return frame`. Pins inside `runB27D()`: wipe then Init same pointer, lists once. `runB26D()` above the nest stays green. Reviewer probe: wipe+Init CreateFrame 0, count 1. |
| Title / CloseButton / persist / SANCTION + Expand / sound / parchment | **Pass.** `TITLE` is still exactly `DIRECTOR CONSOLE`. CloseButton stays `Hide()`d. `ui.consoleDock` / `ANCHORS` / stock `BasicFrameTemplate` / SANCTION + Expand pins stay after the nest. Source has no `PlaySound`, `IG_CHARACTER_INFO`, `parchment`, or `cooldown`. Suite `sounds == 0`. Reviewer spy: remount / dismiss / new-event path stays 0. |
| New main-chunk local (`runB27D`) breaks the Lua 5.1 200-local cap | **Pass. Leftover / nit, not must-fix.** `runB27D` is one new main-chunk `local function` after `runB26D()`. Wipe-remount locals sit inside it. `luac -l -p tests/test_console_dock.lua`: main chunk **56 locals** (cap 200). Brief did not require zero new main-chunk locals. |
| Isolated suite not exit 0 / exclusive file breach | **Pass. Verified.** 414 passed, 0 failed. Writer-reported count matches. Lane implementation is the two named files. Packet is two hunks (header remount note + existing-frame `rememberSpecial` on Refresh / Show; header comment + `runB27D()`). Both exclusive files are still untracked vs HEAD. Sibling dirt in this workspace is other lanes (Console, TOC, bootstrap, `run.lua`). Reviewer did not mutate the exclusive pair. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Console, glue; no commit | **Pass.** Named-risk check. |
| When the frame already exists, `Refresh` and `Show` call `rememberSpecial(FRAME_NAME)` | **Pass.** Live order after the nil-frame return. Source pins in `runB27D()`. Reviewer captures are that call then `if not mayShow`. |
| Do not rebuild | **Pass.** Named-risk check. |
| B24-B per-event dismiss stays | **Pass.** Named-risk check. Same-event Hide + Refresh stays hidden. New `eventId` still shows. |
| B26-D Init remount stays | **Pass.** Named-risk check. |
| Init, wipe `UISpecialFrames` to `{}`, Refresh-only: `ChurchOfBeefConsoleDock` listed exactly once. Wipe again, Show-only: listed once. Same frame pointer | **Pass.** Named-risk check. Second Refresh / second Show are extra keep-pins. |
| Isolation wrap stays; `lua tests/test_console_dock.lua` exit 0 | **Pass.** **414 / 0.** Wrap still **24** under `if standalone then`. |

The leftover (`Refresh` / `Show` skipped `rememberSpecial`; a wiped list then Refresh-only or Show-only never put `ChurchOfBeefConsoleDock` back) is closed on the existing-frame paths. Create-via-Refresh still registers in `build()`; the extra call is deduped. Law 6 (no panel whoosh), Law 10 / license 4 (stock dock, hidden CloseButton), wiki ESC via `UISpecialFrames`, B24-B `eventId` dismiss, and B26-D Init remount hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; real ESC vs `CloseSpecialWindows` on Anniversary is unproven | **Not a miss.** Brief asked isolated green + wipe-to-`{}` then Refresh-only / Show-only lists once. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key; membership counts are pinned, the client's special-frame walk is not | **Not a miss.** Brief asked membership counts. |
| Parked Console leftover (selected-pair inherit of Core `namedOpponent`) | **Not this lane.** Batch 27 overview parks it on B27-A. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / remount / dismiss

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + ConsoleDock. Stub Sender / Console only. No `dofile` of Console / Hud / Toasts / Net / DB / glue. Standalone wrap is still **24** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Decree, slash). Reviewer probe: those keys stay nil in a throwaway load. Wrap is load-time only (unchanged). `runB27D()` re-pins **5** (Hud, Toasts, DecreeBanner, RecordsBook, slash). New remount locals sit in `runB27D()`.

**Existing-frame remount — Pass.** After the nil-frame return, `Refresh` and `Show` call `rememberSpecial(FRAME_NAME)` then gate on `mayShow`. They do not `build()`, do not `CreateFrame`, and do not `PlaySound`. Existing-frame Show does not `Init()`. Create-path `build()` still calls `rememberSpecial(FRAME_NAME)` once after Expand. B26-D Init remount still calls it then Refresh. `rememberSpecial` still type-guards a missing table and returns when the name is already listed. First Init lists once despite create + Init both registering.

**Dismiss / uniqueness — Pass.** Wipe-to-empty then Refresh-only lists `ChurchOfBeefConsoleDock` once and keeps the same pointer. Wipe again, Show-only lists once. Second Refresh / second Show stay once. Same-event Hide + Refresh stays hidden. Reviewer probe: dismiss then wipe then Refresh remounts once, stays hidden, and keeps the live `eventId`; `Show()` after that remounts and shows; next StartEvent + Refresh shows. First-create ESC membership pin, B26-D wipe+Init pin, and persist uniqueness-once pin stay above / below the nest.

---

## Strengths

- The delta is the brief: one existing-frame `rememberSpecial(FRAME_NAME)` on `Refresh` and one on `Show`. Create-path register, B26-D Init remount, B24-B `eventId` dismiss, title, persist, SANCTION + Expand, and hidden CloseButton were left alone. ConsoleDock gained no new file local (`luac`: **34** locals).
- Wipe-to-`{}` then Refresh-only / Show-only is the leftover close, not only a source `find`. Frame identity and wrapped `CreateFrame` 0 are pinned. The B26-D wipe+Init uniqueness-once pin was left in place above the nest.
- Same-event dismiss is re-pinned after both remounts, so a remount that cleared `dismissedEventId` would fail. B24-B new-event show stays above the nest.
- Isolation stayed gated. Remount locals are inside `runB27D()`. Writer-reported **414 / 0** matched the re-run. Writer-reported red (**408 / 6**) matches the six asserts old existing-frame Refresh / Show (no remount) would fail: Refresh remount `rememberSpecial` string; Show remount `rememberSpecial` string; wiped + Refresh-only lists once; second Refresh lists once; wiped + Show-only lists once; second Show lists once.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the dock together with other named Beef frames. Brief asked Refresh / Show remount + uniqueness once, not a client walk. Production furniture (`ChurchOfBeef.lua`) already calls `ConsoleDock:Refresh`; that path now remounts. Glue is not required.

### Nit

1. **One new main-chunk local (`runB27D`).** Wipe-remount locals are nested (correct 200-local hygiene). Main chunk is **56 / 200**. Not a cap break. Brief did not require zero new main-chunk locals. Leftover / nit only.

2. **`src:find("rememberSpecial(FRAME_NAME)")` as “build still rememberSpecial” matches any of the four sites.** Live `build()` still has the call before `return widget` (first find is that site). The remount captures are the pins that actually prove the new sites.

3. **Wipe-then-Refresh while dismissed is unpinned inside `runB27D()`.** Suite Hide + Refresh does not empty the list between those calls. Reviewer probe: wipe after widget Hide, then Refresh remounts once and stays hidden. Brief asked same-event Hide + Refresh stays hidden; that pin is green.

4. **`UISpecialFrames = nil` is unpinned inside `runB27D()`.** Older pin above the nest still proves `Init` survives a missing table. Probe: Refresh / Show with nil leave it nil; assigning `{}` then Refresh lists the name once. Brief asked wipe to `{}`.

5. **Harness `Hide()` is not ESC. Stub `CreateFrame` does not mint `_G["ChurchOfBeefConsoleDock"]`.** Reviewer probe: `_G.ChurchOfBeefConsoleDock == nil`. Production `CreateFrame("Frame", FRAME_NAME, …)` does. Same stub gap other named-special-frame lanes named.

6. **Exclusive-pair diff is not a vs-HEAD ConsoleDock delta.** Packet is the B27-D-only remount + pins. Both exclusive files are still untracked vs HEAD and also carry earlier dock batches. Report already says this.

7. **Isolation wrap is load-only.** Twenty-four pins under the load-time `if standalone then`. `runB27D()` re-pins five. Brief said the wrap stays; it did.

8. **No full `lua tests/run.lua`.** Isolated **414 / 0** was re-run here.

9. **Parked Batch 27 Console leftover** (selected-pair inherit of Core `namedOpponent`) is other work. Not this exclusive pair.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **414 passed, 0 failed.** Isolation wrap: **24**. `runB27D()` re-pins: **5**. Main-chunk locals: **56 / 200**.

`ConsoleDock:Refresh` and `ConsoleDock:Show` on an existing frame call `rememberSpecial(FRAME_NAME)`. They do not rebuild and do not `PlaySound`. Wipe `UISpecialFrames` to `{}` then Refresh-only lists `ChurchOfBeefConsoleDock` exactly once and keeps the same pointer. Wipe again, Show-only lists it once. B24-B same-event Hide + Refresh stays hidden. B26-D Init remount stays. Persist / title / SANCTION + Expand / hidden CloseButton stay. One new main-chunk local (`runB27D`) is leftover / nit, not a 200-local break. Isolated `lua tests/test_console_dock.lua` **414 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
