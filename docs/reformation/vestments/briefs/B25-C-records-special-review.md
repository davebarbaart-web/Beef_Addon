Spec PASS

# B25-C — Records Book Init early-return re-registers ESC (review)

**Quality:** Approved-with-nits

**Lane:** B25-C Records Book Init early-return re-registers ESC
**Brief:** `docs/reformation/vestments/briefs/B25-C-records-special.md`
**Writer report:** `docs/reformation/vestments/briefs/B25-C-records-special-report.md`
**Diff:** `docs/reformation/vestments/briefs/B25-C-records-special.diff` (B25-C-only exclusive-pair packet; live `RecordsBook.lua` / `test_records.lua` also carry earlier Records Book batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/RecordsBook.lua` (`Init` early-return: `rememberSpecial(FRAME_NAME)` then `return self.frame`; create-path still `buildFrame` + `rememberSpecial(FRAME_NAME)`; `rememberSpecial` still scan-then-append), and `tests/test_records.lua` (first-create ESC membership pin, nested `runB25C()` wipe remount + uniqueness + PAGE_TITLES / Morpheus / wheel / roman / isolation re-pins); then ran `lua tests/test_records.lua` (**453 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames`; leftover shape (`Init` returned the existing frame and skipped `rememberSpecial`; a wiped list never got `ChurchOfBeefRecordsBook` back); early-return `rememberSpecial(FRAME_NAME)`; no rebuild; PAGE_TITLES stay 9; `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`; no category remap (#3); no custom media; Law 6 / §14.2 (player-opened Quiet identity/history; no Init sound); Law 10 / Bible §19.3 (theatrical parchment). Isolation wow_ui_stub + Common + Ranks + Store + RecordsBook only. Did not mutate `RecordsBook.lua` or `test_records.lua`. Did not commit. Did not edit Decree, Toasts, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Init` early-return still skips `rememberSpecial` | **Pass. Verified.** Live early-return is `rememberSpecial(FRAME_NAME)` then `return self.frame`. Pins: wipe `UISpecialFrames` to `{}`, second Init lists `ChurchOfBeefRecordsBook` once. Reviewer probe: wipe leaves count 0; second Init returns the same frame and count is 1. Source capture of the early-return body is that call then return. `Show` / closed `Toggle` call `Init`, so a later open remounts. |
| Early-return rebuilds the tome | **Pass. Verified.** Early-return body has no `buildFrame` / `CreateFrame` / `PlaySound`. Pins: second Init returns the existing frame; `Book.frame` stays that widget; `#GetPages()` stays 9. Reviewer spy: wrapped `CreateFrame` saw **0** calls on second Init (no wipe), wipe+Init, third Init, Show-after-wipe, and closed Toggle-after-wipe. |
| Wipe remount duplicates `ChurchOfBeefRecordsBook` | **Pass. Verified.** `rememberSpecial` still dedupes (`UISpecialFrames[i] == name` then return; else `# + 1`). Pins: once before wipe; once after wipe+Init; third Init still once. Reviewer probe: second Init with the name already listed stays 1; wipe+Init+Init stays 1; fourth Init stays 1. Live source has **2** `rememberSpecial(FRAME_NAME)` sites (early-return + `buildFrame`). |
| `PAGE_TITLES` / Morpheus / category remap / custom media / Init sound | **Pass.** Live `PAGE_TITLES` is still the nine Bible titles. `PAGE_TITLE_FONT` is still `Fonts\\MORPHEUS.ttf`. Source has no `Media\\`, no `PlaySound`. `MODE` is still `"QUIET"`. Pins: `#GetPages()==9`, `Fonts\\MORPHEUS.ttf`, refuse uppercase TTF, no `PlaySound` on early-return or the whole file. Reviewer probe: GetPages titles match the Bible list; remount create-delta 0; `toRoman(14)` is still `"XIV"`. |
| New main-chunk local (`runB25C`) breaks the Lua 5.1 200-local cap | **Pass. Leftover / nit, not must-fix.** `runB25C` is one new main-chunk `local function`. Wipe-remount locals sit inside it. `luac -l -p tests/test_records.lua`: main chunk **123 locals** (cap 200). Brief did not require zero new main-chunk locals. |
| Isolated suite not exit 0 / exclusive file breach | **Pass. Verified.** 453 passed, 0 failed. Writer-reported count matches. Lane implementation is the two named files. Packet is two hunks (early-return `rememberSpecial` + return; header comment + nested `runB25C()`). Sibling dirt in this workspace is other lanes (Decree, Toasts, MainFrame, TOC, bootstrap, `run.lua`). Reviewer did not mutate the exclusive pair. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Decree, Toasts, glue; no commit | **Pass.** Named-risk check. |
| On `Init` early-return, call `rememberSpecial(FRAME_NAME)` then return the existing frame | **Pass.** Live order. Source pin in `runB25C()`. Reviewer capture is exactly that call then return. |
| Do not rebuild | **Pass.** Named-risk check. |
| PAGE_TITLES stay 9; `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`; no category remap (#3); no custom media | **Pass.** Named-risk check. |
| Wheel / roman tallies stay | **Pass.** `EnableMouseWheel` source pin stays; `Book.toRoman(14) == "XIV"`. Same-frame remount keeps the wired wheel. |
| Init, wipe `UISpecialFrames` to `{}`, second Init: `ChurchOfBeefRecordsBook` listed exactly once | **Pass.** Named-risk check. Third Init is an extra keep-pin. First-create membership pin above the nest stays. |
| Isolation wrap stays; `lua tests/test_records.lua` exit 0 | **Pass.** **453 / 0.** |

The leftover (`Init` returned the existing frame and skipped `rememberSpecial`) is closed on the early-return path. Law 6 (Quiet identity/history; no Init sound), Law 10 (theatrical parchment; Morpheus stays), wiki ESC via `UISpecialFrames`, and the nine Bible PAGE_TITLES hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| One new main-chunk local (`runB25C`) | **Leftover / nit, not must-fix.** Main chunk is **123** locals. Cap is 200. Does not break the cap. |
| No client smoke; real ESC vs `CloseSpecialWindows` on the named tome is unproven on Anniversary | **Not a miss.** Brief asked isolated green + early-return `rememberSpecial` + uniqueness once. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key; membership counts are pinned, the client's special-frame walk is not | **Not a miss.** Brief asked membership counts. |
| OPEN_QUESTIONS #3 (category remap) stays parked | **On contract.** Brief forbade a remap. Nine Bible titles stay. |
| Parked Console leftover (selected-pair inherit of Core `namedOpponent`) | **Not this lane.** Batch 25 overview parks it on B25-A / later Console work. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / early-return / uniqueness

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Ranks + Store + RecordsBook. No `dofile` of Decree / Toasts / Console / MainFrame / glue / DB / Runtime / Net / Gora. Standalone wrap is still **11** nils (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). `runB25C()` re-pins **5** (Runtime, UI, Toasts, Console, Hud). New remount locals sit in `runB25C()`.

**Early-return — Pass.** `if self.frame then` → `rememberSpecial(FRAME_NAME)` then returns the existing frame. It does not `buildFrame`, does not `CreateFrame`, and does not `PlaySound`. Create-path `buildFrame` still calls `rememberSpecial(FRAME_NAME)` once after `restorePoint`. `rememberSpecial` still type-guards a missing table and returns when the name is already listed.

**Uniqueness — Pass.** Wipe-to-empty then Init lists `ChurchOfBeefRecordsBook` once. Third Init stays once. First-create ESC membership pin stays above the nest. Reviewer probe: Show after a wipe lists once (Show calls `Init`); closed Toggle after a wipe lists once; `UISpecialFrames = nil` then Init leaves the global nil; assigning `{}` then Init lists once.

---

## Strengths

- The delta is the brief: one early-return `rememberSpecial(FRAME_NAME)` before `return self.frame`. Create-path register, PAGE_TITLES, Morpheus, wheel, and roman were left alone. RecordsBook gained no new file local (`luac`: **44** locals).
- Wipe-to-`{}` then second Init is the leftover close, not only a source `find`. Frame identity and `#GetPages()==9` are pinned. The first-create ESC membership pin was left in place above the nest.
- `Show` and closed `Toggle` already call `Init`, so production `/beef` → `RecordsBook:Toggle` remounts when opening a hidden tome.
- Isolation stayed gated. Runtime pins are inside `runB25C()`. Writer-reported **453 / 0** matched the re-run. Writer-reported red (**450 / 3**) matches the three asserts old `if self.frame then return self.frame end` would fail: early-return `rememberSpecial` string; wiped + second Init lists once; third Init lists once.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the tome together with other named Beef frames. Brief asked early-return `rememberSpecial` + uniqueness once, not a client walk. **POLISH:CANDIDATE** is the ceiling if anyone claims feel.

### Nit

1. **One new main-chunk local (`runB25C`).** Wipe-remount locals are nested (correct 200-local hygiene). Main chunk is **123 / 200**. Not a cap break. Brief did not require zero new main-chunk locals. Leftover / nit only.

2. **`Hide` / Toggle-while-shown do not call `Init`.** Reviewer probe: wipe the list, `Hide`, count stays 0; Toggle on an already-shown tome Hides and leaves count 0. Brief scoped `Init`. `Show` and closed `Toggle` remount. An open tome whose name was dropped does not get the name back until the next `Init`.

3. **`UISpecialFrames = nil` is unpinned.** `rememberSpecial` no-ops when the global is not a table. Probe: Init with nil leaves it nil; assigning `{}` then Init lists the name once. Brief asked wipe to `{}`.

4. **Harness `Hide()` is not ESC. Stub `CreateFrame` does not mint `_G["ChurchOfBeefRecordsBook"]`.** Reviewer probe: `_G.ChurchOfBeefRecordsBook == nil`. Production `CreateFrame("Frame", FRAME_NAME, …)` does. Same stub gap other named-special-frame lanes named.

5. **`src:find("rememberSpecial(FRAME_NAME)")` as “buildFrame still rememberSpecial” matches either site.** Live still has the create-path call after `restorePoint`. The early-return capture is the pin that actually proves the new site.

6. **First-create pin above the nest is membership-or, not uniqueness-once.** `Escape can close the book` still passes if the name were listed twice. Uniqueness-once lives inside `runB25C()`.

7. **Exclusive-pair diff is not a vs-HEAD Records Book delta.** Packet is the B25-C-only early-return + pins. `git diff HEAD` on the two files still includes earlier Records Book batches. Report already says this.

8. **Isolation wrap is load-only.** Eleven pins under the load-time `if standalone then`. `runB25C()` re-pins five. Brief said the wrap stays; it did.

9. **No full `lua tests/run.lua`.** Isolated **453 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **453 passed, 0 failed.** Isolation wrap: **11**. `runB25C()` re-pins: **5**. Main-chunk locals: **123 / 200**.

`RecordsBook:Init` early-return calls `rememberSpecial(FRAME_NAME)` then returns the existing frame. It does not rebuild and does not `PlaySound`. Wipe `UISpecialFrames` to `{}` then second Init lists `ChurchOfBeefRecordsBook` exactly once. PAGE_TITLES stay 9. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. Wheel / roman stay. One new main-chunk local (`runB25C`) is leftover / nit, not a 200-local break. Isolated `lua tests/test_records.lua` **453 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
