Spec PASS

# B30-D — Event dock Hide remounts ESC (review)

**Quality:** Approved-with-nits

**Lane:** B30-D Event dock Hide remounts ESC
**Brief:** `docs/reformation/vestments/briefs/B30-D-dock-hide.md`
**Writer report:** `docs/reformation/vestments/briefs/B30-D-dock-hide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B30-D-dock-hide.diff` (B30-D-only exclusive-pair packet; live `ConsoleDock.lua` / `test_console_dock.lua` are still untracked vs HEAD and also carry earlier dock batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/ConsoleDock.lua` (`Hide` existing-frame remount `rememberSpecial(FRAME_NAME)` when `frame` exists, then `paint(false)`; `Init` / `Show` / `Refresh` remount + `build()` register stay; `rememberSpecial` still scan-then-append), and `tests/test_console_dock.lua` (isolation wrap, persist / ESC / B24-B per-event dismiss / B26-D Init remount / B27-D Show / Refresh remount pins, `runB30D()` nested inside `runB27D()` after the B27-D isolation wrap); then ran `lua tests/test_console_dock.lua` (**476 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames` (named frame; do not PlaySound `IG_CHARACTER_INFO_*`); B27 leftover (`Hide` skipped `rememberSpecial`; a wiped list then Hide-only never put `ChurchOfBeefConsoleDock` back); existing-frame `Hide` still `rememberSpecial(FRAME_NAME)` then `paint(false)`; do not rebuild; do not Show; B24-B `eventId` dismiss stays; same-event Refresh still does not pop a dismissed dock; B27-D Show / Refresh remount stays; B26-D Init remount stays. Law 6 / §19.4 (Quiet silent; no `PlaySound` / `IG_CHARACTER_INFO_*`); Law 10 / Bible §19.3 (functional / stock dock; no parchment); Bible §18.1 collapsible Director Console. Title stays `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. Did not mutate `ConsoleDock.lua` or `test_console_dock.lua`. Did not commit. Did not edit Console, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Existing-frame `Hide` still skips `rememberSpecial` (B27 leftover) | **Pass. Verified.** Live order is `if frame then rememberSpecial(FRAME_NAME) end` then `paint(false)`. Pins: Init, wipe `UISpecialFrames` to `{}`, Hide lists `ChurchOfBeefConsoleDock` once. Reviewer probe: wipe leaves count 0; Hide-only returns the same pointer and count is 1; second Hide stays 1. Source capture of that remount body is the call then `paint(false)`. |
| Existing-frame `Hide` rebuilds or Shows | **Pass. Verified.** Hide remount body has no `build()` / `CreateFrame` / `PlaySound` / `:Show()` / `self:Show`. Pins: wrapped `CreateFrame` saw 0 calls on wipe+Hide; Quiet widget stays hidden. Reviewer spy: wrapped `CreateFrame` saw **0** calls on wipe+Hide, wipe-while-shown+Hide, and Show-after-dismiss. `showCalls` stayed **0** (stub `Console.Show` not invoked). `paint(false)` still uses `frame:Hide()`. |
| Wipe remount duplicates `ChurchOfBeefConsoleDock` | **Pass. Verified.** `rememberSpecial` still dedupes (`UISpecialFrames[i] == name` then return; else `# + 1`). Pins: once before wipe; once after wipe+Hide; second Hide still once. Reviewer probe: first Init stays 1; wipe+Hide+Hide stays 1. Live source has **5** `rememberSpecial(FRAME_NAME)` sites (`build()` + existing-frame `Init` + `Refresh` + `Show` + `Hide`). |
| Same-event Refresh pops a dismissed dock | **Pass. Verified.** Same-event `ConsoleDock:Hide` + Refresh stays hidden inside `runB30D()`. B24-B block above `runB26D()` is intact. B26-D / B27-D nests still re-pin widget-Hide + Refresh. Reviewer probe: live Show then wipe then Hide remounts the name once, returns the same pointer, stays hidden, and is not `EndEvent`; same-event Refresh stays hidden; `Init()` after that remount stays hidden; `Show()` after dismiss remounts and **shows**; `EndEvent` then `StartEvent` + Refresh **shows** on the new `eventId`. |
| B27-D Show / Refresh remount or B26-D Init remount dies | **Pass. Verified.** Existing-frame Refresh / Show / Init bodies still `rememberSpecial(FRAME_NAME)`. Pins inside `runB30D()`: wipe then Init / Refresh / Show list once and keep the same pointer. `runB27D()` / `runB26D()` above the nest stay green. Reviewer probe: wipe+Init / wipe+Refresh / wipe+Show CreateFrame 0, count 1. |
| Title / CloseButton / persist / SANCTION + Expand / sound / parchment | **Pass.** `TITLE` is still exactly `DIRECTOR CONSOLE`. CloseButton stays `Hide()`d. `ui.consoleDock` / `ANCHORS` / stock `BasicFrameTemplate` / SANCTION + Expand pins stay after the nest. Source has no `PlaySound`, `IG_CHARACTER_INFO`, `parchment`, or `cooldown`. Suite `sounds == 0`. Reviewer spy: remount / dismiss / new-event path stays 0. |
| New main-chunk local breaks the Lua 5.1 200-local cap | **Pass.** `runB30D` is a nested `local function` inside `runB27D()` after the B27-D isolation wrap. No new main-chunk local. `luac -l -p tests/test_console_dock.lua`: main chunk **56 locals** (cap 200), same as B27-D. ConsoleDock file locals stay **34**. |
| Isolated suite not exit 0 / exclusive file breach | **Pass. Verified.** 476 passed, 0 failed. Writer-reported count matches. Lane implementation is the two named files. Packet is two hunks (header remount note + existing-frame `rememberSpecial` on Hide; header comment + `runB30D()` nest). Both exclusive files are still untracked vs HEAD. Sibling dirt in this workspace is other lanes (Console, TOC, bootstrap, `run.lua`). Reviewer did not mutate the exclusive pair. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Console, glue; no commit | **Pass.** Named-risk check. B30-D packet does not touch `Console.lua`. |
| When the frame already exists, `Hide` calls `rememberSpecial(FRAME_NAME)` then `paint(false)` | **Pass.** Live order. Source pin in `runB30D()`. Reviewer capture is that call then `paint(false)`. No-frame `Hide` still `paint(false)` only. |
| Do not rebuild. Do not Show | **Pass.** Named-risk check. |
| Same-event Refresh still does not pop a dismissed dock | **Pass.** Named-risk check. |
| B27-D Show / Refresh remount stays. B26-D Init remount stays | **Pass.** Named-risk check. |
| Init, wipe `UISpecialFrames` to `{}`, Hide: `ChurchOfBeefConsoleDock` listed exactly once. Same frame pointer | **Pass.** Named-risk check. Second Hide is an extra keep-pin. |
| No parchment. No `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. |
| Isolation wrap stays; nest after `runB27D()`; `lua tests/test_console_dock.lua` exit 0 | **Pass.** **476 / 0.** Wrap still **24** under `if standalone then`. `runB30D()` sits inside `runB27D()` after that function's isolation wrap. |

The leftover (`Hide` skipped `rememberSpecial`; a wiped list then Hide-only never put `ChurchOfBeefConsoleDock` back) is closed on the existing-frame `Hide` path. Create-via-`build()` still registers; the extra call is deduped. Law 6 (no panel whoosh), Law 10 / license 4 (stock dock, hidden CloseButton), wiki ESC via `UISpecialFrames`, B24-B `eventId` dismiss, B27-D Show / Refresh remount, and B26-D Init remount hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; real ESC vs `CloseSpecialWindows` on Anniversary is unproven | **Not a miss.** Brief asked isolated green + wipe-to-`{}` then Hide lists once. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key; membership counts are pinned, the client's special-frame walk is not; ESC still walks names and calls `Frame:Hide`, not `ConsoleDock:Hide` | **Not a miss.** Brief asked membership counts on `ConsoleDock:Hide`. |
| Parked Console leftover (overview): no Console leftover this batch | **Not this lane.** Sibling lanes own Decree / card / Records. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / remount / dismiss

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + ConsoleDock. Stub Sender / Console only. No `dofile` of Console / Hud / Toasts / Net / DB / glue. Standalone wrap is still **24** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Decree, slash). Wrap is load-time only (unchanged). `runB30D()` re-pins **5** (Hud, Toasts, DecreeBanner, RecordsBook, slash). New remount locals sit in `runB30D()` inside `runB27D()`.

**Existing-frame remount — Pass.** `Hide` calls `rememberSpecial(FRAME_NAME)` when `frame` exists, then `paint(false)`. It does not `build()`, does not `CreateFrame`, does not `PlaySound`, and does not `Show`. Create-path `build()` still calls `rememberSpecial(FRAME_NAME)` once after Expand. B26-D Init remount still calls it then Refresh. B27-D Refresh / Show remount still call it then `mayShow`. `rememberSpecial` still type-guards a missing table and returns when the name is already listed. First Init lists once despite create + Init both registering. Reviewer probe: `UISpecialFrames = nil` then Hide leaves the table nil; assigning `{}` then Hide lists the name once. No-frame Hide (after `ResetForTests`) leaves a wiped list at 0.

**Dismiss / uniqueness — Pass.** Wipe-to-empty then Hide lists `ChurchOfBeefConsoleDock` once and keeps the same pointer. Second Hide stays once. Same-event Hide + Refresh stays hidden. Reviewer probe: dismiss then wipe then Hide remounts once, stays hidden, and keeps the live `eventId`; `Show()` after that remounts and shows; next StartEvent + Refresh shows. First-create ESC membership pin, B26-D wipe+Init pin, B27-D wipe+Refresh / wipe+Show pins, and persist uniqueness-once pin stay above / below the nest.

---

## Strengths

- The delta is the brief: one existing-frame `rememberSpecial(FRAME_NAME)` on `Hide` before `paint(false)`. Create-path register, B26-D Init remount, B27-D Show / Refresh remount, B24-B `eventId` dismiss, title, persist, SANCTION + Expand, and hidden CloseButton were left alone. ConsoleDock gained no new file local (`luac`: **34** locals). No new main-chunk test local.
- Wipe-to-`{}` then Hide is the leftover close, not only a source `find`. Frame identity and wrapped `CreateFrame` 0 are pinned. The B27-D wipe+Refresh / wipe+Show and B26-D wipe+Init uniqueness-once pins were left in place above the nest and re-pinned inside it.
- Same-event dismiss is re-pinned after the remount via `ConsoleDock:Hide` (not only widget `:Hide`), so a remount that cleared `dismissedEventId` would fail. B24-B new-event show stays above the nest.
- Isolation stayed gated. Remount locals are inside `runB30D()` inside `runB27D()`. Writer-reported **476 / 0** matched the re-run. Writer-reported red (**474 / 2**) matches the two asserts old existing-frame Hide (no remount) would fail: Hide remount `rememberSpecial` string; wiped + Hide lists once.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames` and calls `Frame:Hide`, not `ConsoleDock:Hide`. One real ESC may still hide the dock together with other named Beef frames. Brief asked Hide remount + uniqueness once, not a client walk. Production furniture that already calls `ConsoleDock:Hide` now remounts. Glue is not required.

### Nit

1. **`src:find("rememberSpecial(FRAME_NAME)")` as “build still rememberSpecial” matches any of the five sites.** Live `build()` still has the call before `return widget` (first find is that site). The remount captures are the pins that actually prove the new site.

2. **Second Hide uniqueness after wipe is not independent.** The suite calls `Init()` (which remounts) before the second Hide count pin. The first wipe+Hide count is the leftover close. Reviewer probe: wipe+Hide+Hide without an intervening Init stays 1.

3. **Wipe-then-Hide while shown is unpinned inside `runB30D()`.** Suite wipe+Hide runs after Quiet Init (widget already hidden). Live dismiss later does not empty the list between Show and Hide. Reviewer probe: wipe after a shown dock, then Hide remounts once, hides, and same-event Refresh stays hidden. Brief asked Init, wipe, Hide lists once; that pin is green.

4. **`UISpecialFrames = nil` is unpinned inside `runB30D()`.** Older pin above the nest still proves `Init` survives a missing table. Probe: Hide with nil leaves it nil; assigning `{}` then Hide lists the name once. Brief asked wipe to `{}`.

5. **Harness `Hide()` is not ESC. Stub `CreateFrame` does not mint `_G["ChurchOfBeefConsoleDock"]`.** Reviewer probe: `_G.ChurchOfBeefConsoleDock == nil`. Production `CreateFrame("Frame", FRAME_NAME, …)` does. Same stub gap other named-special-frame lanes named.

6. **Exclusive-pair diff is not a vs-HEAD ConsoleDock delta.** Packet is the B30-D-only remount + pins. Both exclusive files are still untracked vs HEAD and also carry earlier dock batches. Report already says this.

7. **Isolation wrap is load-only.** Twenty-four pins under the load-time `if standalone then`. `runB30D()` re-pins five. Brief said the wrap stays; it did.

8. **No full `lua tests/run.lua`.** Isolated **476 / 0** was re-run here.

9. **Parked Batch 30 Console leftover** is other work. Overview: no Console leftover this batch. Not this exclusive pair.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **476 passed, 0 failed.** Isolation wrap: **24**. `runB30D()` re-pins: **5**. Main-chunk locals: **56 / 200**.

`ConsoleDock:Hide` on an existing frame calls `rememberSpecial(FRAME_NAME)` then `paint(false)`. It does not rebuild, does not Show, and does not `PlaySound`. Wipe `UISpecialFrames` to `{}` then Hide lists `ChurchOfBeefConsoleDock` exactly once and keeps the same pointer. Same-event Hide + Refresh stays hidden. B27-D Show / Refresh remount stays. B26-D Init remount stays. Persist / title / SANCTION + Expand / hidden CloseButton stay. No new main-chunk local. Isolated `lua tests/test_console_dock.lua` **476 passed, 0 failed**, exit 0.

### Leftovers

- No `/reload` smoke; real ESC vs `CloseSpecialWindows` is unproven. ESC walks names and calls `Frame:Hide`, not `ConsoleDock:Hide`.
- Full `lua tests/run.lua` not run.
- Harness membership counts are pinned; the client's special-frame walk is not. Stub `CreateFrame` does not mint `_G["ChurchOfBeefConsoleDock"]`.
- `UISpecialFrames = nil` and wipe-then-Hide while shown are unpinned inside `runB30D()` (reviewer probes passed).
- Exclusive-pair diff is the B30-D-only delta, not vs HEAD.

Do not claim V1 / MVP complete. This review does not sign the lane.
