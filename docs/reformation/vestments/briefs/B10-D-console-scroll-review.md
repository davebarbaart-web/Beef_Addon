Spec PASS

# B10-D — Glanceable Console scroll (review)

**Quality:** Approved-with-nits

**Lane:** B10-D Glanceable Console scroll (stock)
**Brief:** `docs/reformation/vestments/briefs/B10-D-console-scroll.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B10-D-console-scroll-report.md`
**Diff:** `docs/reformation/vestments/briefs/B10-D-console-scroll.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the exclusive-pair diff, live `UI/Console.lua` (`DEFAULT_HEIGHT` / `DESK_CHILD_H` / `buildFrame` desk `ScrollFrame` / `SaveNote` / SUMMON / tab / parchment), and `tests/test_console.lua` (early height pin + `runB8E` B10-D block); then ran `lua tests/test_console.lua`. Law cited: Bible §18.1 (glanceable, movable, large targets; keep desks; no window switching); Law 10 / §19.3 (Director Console stays stock-pragmatic); CONTINUE 2026-08-18 (no SUMMON; no post-show clipboard; `SaveNote` stays nil; Console stays plain). Anniversary SimpleScrollFrameAPI (`SetScrollChild`, `SetVerticalScroll`) confirmed on `classic_anniversary`. Did not mutate addon code. Did not edit Store or Gora. Did not commit. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Stock `ScrollFrame` around the desk body | **Pass.** `CreateFrame("ScrollFrame", FRAME_NAME .. "DeskScroll", frame, "UIPanelScrollFrameTemplate")` — same constructor + stock template as Presence / Knighting / Confession / Petition / CeremonyLog `scrollList`. Named `ChurchOfBeefConsoleFrameDeskScroll`. Viewport is `TOPLEFT (14, -30)` / `BOTTOMRIGHT (-14, 12)` under the title bar. Child is `Content` / `DeskChild`, width `DEFAULT_WIDTH - 28`, height `DESK_CHILD_H` (1050). Every desk is parented to that child, not hidden behind a switcher. |
| `SetScrollChild` / `SetVerticalScroll` type-guarded | **Pass.** Both calls sit behind `type(...) == "function"`. Vertical scroll starts at 0. Anniversary SimpleScrollFrameAPI lists both methods. Inner `scrollList` still calls `SetScrollChild` unguarded (pre-existing Presence pattern); the new desk scroll is the guarded site the brief asked for. |
| Outer frame height 780 | **Pass.** `DEFAULT_HEIGHT` is 780. `buildFrame` `SetHeight(DEFAULT_HEIGHT)`. `restorePoint` writes only point/x/y — it does not restore a stale 1050 height. Early suite pin and the B10-D block both `assert_eq(frame:GetHeight(), 780)`. Title bar / close / movable / clamped stay on the outer `BasicFrameTemplate`. |
| `SaveNote` nil; no SUMMON; no post-show summary | **Pass.** `Console.SaveNote` / `GetNotes` / `CopyCeremonySummary` / `CeremonySummary` are nil. Source has no `function Console:SaveNote`, `SUMMON THE FAITHFUL`, `WHISPER ALL`, or `CopyCeremonySummary`. No `SUMMON` / `COPY SUMMARY` / `WHISPER ALL` / `RSVP` chrome. `CopyToClipboard` is still the Archive-export blob only. Notebook is still a `GameFontNormal` label. |
| No tabs; no parchment | **Pass.** Source has no `PanelTabButtonTemplate` / `TabButton` / `OptionsFrameTab` / `FriendsFrameTab`. All eight desk headers still paint on one child (Presence, Knighting, Gora, Confession, CeremonyLog, ARCHIVE, CANONIZE, Notebook). No `Parchment`, `QuestBG`, `OnUpdate`, `UIParent:SetScale`, or custom `Media\`. New chrome is one stock `UIPanelScrollFrameTemplate`. |
| Isolated green | **Pass.** Reviewer ran `lua tests/test_console.lua`: **1081 passed, 0 failed**, exit 0. Matches the writer report. Isolation cluster is still `if standalone then` (17 nil-module pins at file load). B10-D re-pins Archive + Quiet shell + Toasts inside `runB8E()`. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Store, Gora; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/Console.lua` and `tests/test_console.lua`. Live B10-D hunks match that slice (`DEFAULT_HEIGHT` 780, `DESK_CHILD_H`, desk `ScrollFrame`, B10-D suite block). Store / Gora are dirty from other exclusive lanes, not this packet. |
| Console stays stock; `SaveNote` stays nil; no SUMMON; no post-show summary | **Pass.** Named-risk check. |
| Stock `ScrollFrame` for the desk body; same pattern as Presence / CeremonyLog lists; type-guard missing APIs | **Pass.** Named-risk check. |
| Outer height **780**; child can stay tall | **Pass.** Outer 780. Child 1050 and taller than the frame. Notebook header lands at y≈930 inside that child — it fits. |
| Do not collapse desks into tabs; do not parchment the console | **Pass.** Named-risk check. |
| Tests: frame height 780; a ScrollFrame exists for the desk body; CeremonyLog / Archive / Canonize / SaveNote pins stay; isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** Early pin + B10-D block. CeremonyLog list / ArchiveBox multiline / CanonizeText / ritual plates / EditBox count 7 stay. Isolated **1081 / 0**. |

Bible §18.1 (glanceable shorter frame, desks kept, no window switching), Law 10 / §19.3 (stock desk), and CONTINUE (no SUMMON; no post-show clipboard; `SaveNote` nil) are met. §18.1 also wants to minimize scrolling; the brief explicitly chooses a stock body scroll over tabs. That tension is leftover, not a miss.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; mouse-wheel and stock scrollbar thumb unproven on Anniversary | **Not a spec miss.** Brief asked isolated `tests/test_console.lua`. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| §18.1 also wants to minimize scrolling; Archive / Canonize / Notebook sit below the 780 viewport | **Not a miss.** Brief said keep every desk and put the content on a `ScrollFrame`. Those three sit at y≈758 / 886 / 930 on a 738px viewport (`780 - 30 - 12`). Intended fold. |
| `UIPanelScrollFrameTemplate` scrollbar may overlap the right Gora column; width was not changed | **Not a miss.** Brief froze outer width and asked the Presence-style stock template. Right-column ritual plates (`Post Decree` / `MARK THIS MOMENT` / `GRANT HONORIFIC` / `EXPORT ARCHIVE` / `CANONIZE` at x=572, width 172) lose ~10px under a typical −18px inside scrollbar. Still large targets. See leftover. |
| `DESK_CHILD_H` is a fixed 1050; a later desk row will clip inside the child | **Not a miss.** Brief said the child can stay tall. Current last header fits. See leftover. |
| Harness `SetScrollChild` / `GetScrollChild` is a stub noop; tests pin parentage and height, not `GetScrollChild()` | **Not a miss.** Brief asked a ScrollFrame and type-guards. Parent is `deskScroll` via `CreateFrame`. Production still calls the guarded client method. See leftover. |
| B10-D tests live inside `runB8E()` (Lua 5.1 200-local cap) | **Not a miss.** Suite still ran. See leftover. |

---

## Strengths

- The height cut is real, not a comment: `DEFAULT_HEIGHT` 780, `SetHeight` on the outer frame, saved UI point does not restore the old 1050.
- Desk scroll is one stock `UIPanelScrollFrameTemplate`, named, type-guarded on the two Anniversary APIs the brief named. Title bar stays on the frame so the desk can move without eating the drag handle.
- Desks were not tabbed and were not parchment. All prior furniture still exists on `Content`.
- `SaveNote` is still absent. There is no SUMMON chrome and no second clipboard.
- Isolation stayed gated. Isolated **1081 / 0** was re-run here and matches the writer report.

---

## Must-fix

None.

---

## Leftover (Minor)

1. **No `/reload` smoke.** Nested `ScrollFrame`s (desk + five list scrolls) will eat mouse-wheel when the cursor is over Presence / Gora / Confession / CeremonyLog. Archive / Canonize / Notebook then need the right-edge thumb. Stock template scripts are unproven in this harness. **POLISH:CANDIDATE** only.

2. **Stock scrollbar inset.** Desk child is `DEFAULT_WIDTH - 28` with no Presence-style 22px gutter. Right-edge verbs at x=572 can sit a few pixels under `UIPanelScrollFrameTemplate`'s inside scrollbar. Not a spec miss; worth a right inset if a later polish lane touches this frame.

3. **`DESK_CHILD_H = 1050` is a frozen former outer height.** Notebook fits today. The next added row will clip inside the child unless this constant moves.

4. **Suite does not pin `deskScroll:SetScrollChild(content)` as a call**, only the type-guard string and `DeskChild:GetParent() == DeskScroll`. A deleted call with the guard left in would still go green. Harness `SetScrollChild` remains a noop.

5. **Parchment source pin is `find("Parchment")`.** Comments already say lowercase `parchment`. A real `QuestBG` / `QuestParchment` texture would also miss that pin. Live file has neither.

6. **EditBoxes now live inside the outer `ScrollFrame`** (Decree, Honorific, Stipulation, FreeRuling, ArchiveBox, Canonize). Classic focus / wheel interaction with that pairing is unsmoked.

7. **Nested `runB8E()`** is still the Lua 5.1 local-cap workaround. Fine as long as the next console lane does not add another 80 locals to that function.

8. **Header comment still says CeremonyLog is click-to-select.** Pre-existing. `frame.CeremonyLogRows` is still an unpainted pool.

9. **No full `lua tests/run.lua`.** Isolated **1081 / 0** was re-run here. That does not prove the client path.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

This is the B10-D vestment contract: stock desk-body `ScrollFrame`, outer height 780, child stays tall, every desk kept (no tabs), Console stays plain, `SaveNote` nil, no SUMMON, no post-show summary. Named risks are clean. Isolated suite is green.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
