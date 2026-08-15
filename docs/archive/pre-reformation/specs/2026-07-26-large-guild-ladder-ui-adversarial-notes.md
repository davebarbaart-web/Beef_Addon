# Large-guild Ladder UI — adversarial UX/performance/taint notes

**Date:** 2026-07-26
**Status:** Read-only review notes — **not** product law, does not amend the design spec
**Reviewed:** [`2026-07-26-large-guild-ladder-ui-design.md`](2026-07-26-large-guild-ladder-ui-design.md), [`ui-polished-direction-for-agents.md`](../ui-polished-direction-for-agents.md), `addon/ChurchOfBeef/UI/{LadderTab,MainFrame,OfficerTab}.lua`, `Core/{Roster,Ladder}.lua`, `wow-performance.mdc`, `wow-ui-taint-lockdown.mdc`
**Evidence screenshot:** live Ladder tab showing `Beef Council 9/4`, `Cooked Beef … +53 more`, `Fresh Beef 880 … +872 more`
**Purpose:** Flag concrete traps in the *current* implementation and in the *redesign direction* before an implementer claims `POLISH:CANDIDATE` on this surface.

> **Caveat on timing:** `addon/ChurchOfBeef/UI/OfficerTab.lua` was being actively refactored (fixed `COL_SPLIT`/`QUEUE_VISIBLE` → responsive `colSplitFor()`/`visibleRowsFor()`) while this review was in progress — `lua tests/run.lua` flipped between red and green three times in ~15 minutes during this pass. `LadderTab.lua` and `Core/Roster.lua`/`Core/Ladder.lua` were stable throughout. Treat OfficerTab.lua line numbers below as illustrative of the pattern, not a frozen defect list — **re-run the harness before acting on anything below.**

---

## Headline finding (read this one first)

**The "+N more" control is wired but visually inert — it will still look like the old dead trap.**

In `addon/ChurchOfBeef/UI/LadderTab.lua` (`OnCreate`, the `more` button), the overflow/expand control is a bare `CreateFrame("Button", nil, row)` with a `FontString` overlay and an `OnClick` handler — no `SetHighlightTexture`, no `UIPanelButtonTemplate`/`UIPanelButtonTemplate2` inheritance, no `OnEnter`/`OnLeave` cursor or tooltip cue, no pushed/disabled state. The design brief itself says to use `UIPanelButtonTemplate` for this exact control (`ui-polished-direction-for-agents.md` presentation checklist), and the sibling `OfficerTab` queue rows *do* get `SetHighlightTexture("Interface\QuestFrame\UI-QuestTitleHighlight")`.

Net effect: `+872 more` is now *functionally* clickable, but nothing on screen tells a player that. A member staring at the screenshot in this review has no visual reason to believe `+872 more` differs from the old dead label it replaced. This is the single highest-value fix an implementer can make — it is exactly the failure mode the mission called out, just moved from "not clickable" to "clickable but looks unclickable."

**Fix shape:** give `more` a highlight texture (or build it from `UIPanelButtonTemplate`), and/or render the whole overflow phrase as a distinct color/underline so its affordance survives a screenshot, not just a mouseover.

---

## 1. Failure modes at 1000 roster

1. **No coalescing on `GUILD_ROSTER_UPDATE` bursts, despite the spec requiring it.** `UI/MainFrame.lua` `UI:Init()` registers `GUILD_ROSTER_UPDATE`/`PLAYER_GUILD_UPDATE` and, on **every** event fire, synchronously runs `COB.Roster:Refresh()` (a full `O(members)` `GetGuildRosterInfo` walk) then `UI:RefreshLadder()` → `MarkDirty` → an immediate repaint of whichever tab is open. There is no debounce/coalesce timer anywhere in this path. Spec §6 explicitly requires "coalesce refreshes ≤10 Hz when bursty (`GUILD_ROSTER_UPDATE` storms)" and lists "Toggling... without pool reuse" style storms as an anti-pattern to reject — this is the literal storm case, currently un-coalesced. At 1000 members, a login/zone burst of 5–10 `GUILD_ROSTER_UPDATE` events in under a second means 5–10 full roster walks + 5–10 full Ladder repaints back-to-back.
2. **Class-color cache rebuilds once per *paint*, not once per *snapshot*.** `buildClassColorCache()` in `LadderTab.lua` calls `GetGuildRosterInfo()` for **every** guild member on **every** `OnRefresh` — that includes every debounced Find keystroke, every tab return, every Dismiss/CorrectStanding-triggered `RefreshLadder()`, and every roster event from (1). Spec §6 asks for "cache on roster refresh... invalidated on `GUILD_ROSTER_UPDATE`... once per snapshot, not O(names×members) per paint." The current code is `O(members)` per paint (not `O(names×members)`, so it's not the worst anti-pattern), but it is not the "once per snapshot" cache the spec describes — it is a fresh 1000-entry roster walk on every dirty repaint, including ones that have nothing to do with roster changes (typing in Find).
3. **`Roster:GetLadderView()` rebuilds and sorts the full member array on every call**, and `LadderTab:OnRefresh` calls it once per paint, then does a further 7× `O(members)` `occupantsForRank` scan on top. Individually cheap; combined with (1) and (2) during a roster storm this is the multiplicative cost that will actually show up on a profiler at 1000 members, even though no single line looks alarming in isolation.
4. **Officer suggestion queue re-sorts + re-filters the full pending list on every dirty repaint** (`sortByAge`/`filterList` in `OfficerTab.lua`), and — see §3 below — the Officer Find box has **no debounce**, unlike Ladder's. A guild with a few hundred pending petitions and an officer who types fast will re-sort that list on every keystroke.
5. **`Beef Council 9/4` in the evidence screenshot is a real over-capacity case the UI does not explain.** `vacancyCopy()` only returns copy when `open > 0`; when `taken > maxSeats` it silently falls through to just printing the raw fraction. A council with 9 members against a 4-seat cap (`Data/Ranks.lua` `CouncilSeats`) reads as a possible display bug to a player, not an intentional state. Either the seat cap needs reconciling with live guild practice, or the UI needs explicit "over capacity" copy — right now it's neither.

## 2. Scroll/pool pitfalls on TBC 20506

1. **The Ladder heavy viewport has no scrollbar — only a mousewheel handler that moves exactly one row per notch.** `LadderTab.lua`'s `heavy` frame is `EnableMouseWheel(true)` + `OnMouseWheel` → `ScrollDetail(±1)`; there is no `FauxScrollFrameTemplate`, no draggable thumb, no Page Up/Down, no Home/End. For the `Fresh Beef · 880 members` band in the screenshot, reaching a name near the end of the alphabet from a cold expand is roughly 860+ wheel notches. This is a scroll pit one layer inside the fixed "+N more" trap the redesign exists to remove — acceptance criterion 4 ("scrollable name list backed by a fixed row pool") is technically met, the *experience* of scrolling it is not. Compare this to `OfficerTab.lua`, which **does** wire a real `FauxScrollFrameTemplate` (draggable thumb) for its queue — the two "large list" surfaces in the same addon have inconsistent scroll affordances.
2. **Verify `FauxScrollFrameTemplate`/`FauxScrollFrame_Update`/`FauxScrollFrame_OnVerticalScroll`/`FauxScrollFrame_GetOffset`/`FauxScrollFrame_SetOffset` in-client on Anniversary `20506`.** These are old FrameXML globals, not the Retail/Dragonflight `ScrollBox`/`ScrollUtil` API — they should exist on Classic, but this is exactly the kind of assumption `wow-ui-taint-lockdown.mdc`/`wow-performance.mdc` want verified with a real client smoke, not assumed from Retail muscle memory. The design status line ("harness green; in-game Accept still human") means nobody has actually confirmed this on `20506` for the *current* OfficerTab shape yet.
3. **Officer tab's `listFrame` is mid-migration off fixed `SetWidth`/`SetHeight`** toward values implied by `colSplitFor()`/`visibleRowsFor()`, but as observed during this review the explicit `listFrame:SetWidth(...)`/`SetHeight(...)` calls were not consistently present across edits. If the list frame's own width/height aren't re-derived every layout pass (not just at `OnCreate`), the `FauxScrollFrame` will clip against stale bounds the moment the panel size differs from the `CONTENT_BUDGET`/`CONTENT_WIDTH` fallback constants.
4. **`DETAIL_ROW_HEIGHT = 14` with `GameFontHighlight` is tight.** Nothing in the offline harness checks vertical text clipping/leading at real UI scale; this needs an eyeball check in client, particularly at non-100% `uiScale` (the addon must guest on player scale per doctrine, so it cannot compensate by changing scale itself).

## 3. Search UX traps

1. **Scroll position silently resets when you filter, and does not restore when you clear the filter.** `paintHeavyRows()` clamps `heavy.offset` to `math.max(0, #names - visible)` on every paint. Scroll deep into an 880-member Fresh Beef band (`offset = 500`), type a Find query that narrows it to 3 matches, and `offset` is clamped down to `0`. Clear the filter and you're back at the top of the list, not where you were. For the exact "browse a huge band" workflow the heavy viewport exists for, Find quietly punishes you for using it mid-scroll.
2. **The Officer queue Find box has no debounce; the Ladder Find box does.** `LadderTab.lua`'s filter explicitly comments "Debounce Find paints (~120 ms) so typing does not rebuild seven bands every key" and uses `C_Timer.After`. `OfficerTab.lua`'s `nameFilter` `OnTextChanged` calls `_RefreshQueue()`/`_RefreshEvidence()` directly, every keystroke, no timer. Same feature, same file family, inconsistent perf treatment — and the Officer surface is the one an officer is most likely to be typing in *during* a promote-decision session.
3. **The two Find boxes have different matching semantics for realm suffixes.** `LadderTab.lua`'s `filterNames()` now only matches on the realm-stripped `nameKey`, so typing a realm name deliberately does **not** match (confirmed by its own test: `"realm"` finds 0 of 900). `OfficerTab.lua`'s `filterList()` still has a fallback branch (`elseif name:lower():find(needle...)`) that **does** match on the raw, un-stripped name — so a realm-suffix query behaves differently in the two tabs of the same window. A player who learns "Find ignores realms" on the Ladder tab will be confused when the Officer queue filter behaves differently.
4. **No global "N total matches" anywhere except the per-band `· N matches` title suffix and a binary "No members match." footer.** Typing a common letter across a 1000-member roster gives no sense of how many results exist in bands you haven't expanded — minor, but worth a design decision either way rather than an accident of implementation.
5. **Case-folding is ASCII-only** (`string.lower` only folds A–Z); non-Latin guild member names will match case-sensitively for non-ASCII characters. Likely acceptable for V1, but worth a one-line acknowledgment so it isn't "discovered" as a bug report from an international realm later.

## 4. Expand/collapse defaults ("Fresh Beef open = death")

**The direct trap is avoided:** `expandedRankId` starts `nil`, small bands (≤ `VISIBLE_CAP` = 8) always render inline without needing an expand action, and large bands start collapsed with self always pinned into the visible preview. Session-local expand state (module field, not tab-table) correctly survives tab switches and resets cleanly on `/reload`. Credit where due — this part of the redesign does what §2 of the design doc asks.

**The indirect trap is not avoided — it's just currently dormant.** `LadderTab.lua`'s `OnRefresh` computes a `layoutMode` of `"normal"` / `"compressed"` / `"focus"` from the available content height. In `"focus"` mode, **every non-expanded institutional band is `:Hide()`d** (`hideBand = layoutMode == "focus" and not isHeavy`) — Prophet, Council, Butcher, Lord, Knight, and Cooked can all vanish from the Ladder tab while a single expanded band is shown. This directly contradicts the design's own acceptance criterion #2 ("Institutional order 7→1 is preserved; bands are not replaced by a standing-sorted grid") in exactly the moment it matters most — when a huge band is expanded.

With the current fixed 480×420 frame this branch is reachable only in a narrow combination (learning banner + heavy expand, computed: `compressedNeed=284 > avail=256` when the learning banner is shown). Because `Status:ShowsLearningBanner()` requires zero roster occupants, this specific combination is unlikely for an already-populated 1000-member guild — but:

- The existing test for this path (`tests/test_ui.lua`, "Optional learning banner must not push heavy past the content budget") **accepts either `"compressed"` or `"focus"`** without asserting the other six bands stay visible. It currently cannot catch a regression of AC #2.
- The `OfficerTab.lua` WIP is visibly laying groundwork for a resizable `MainFrame` (`colSplitFor(width)`, `visibleRowsFor(height)` both take dynamic panel dimensions with defensive floors). **The day `MainFrame` gets `SetResizable(true)`, "focus" mode becomes trivially reachable** by any user who shrinks the window while a heavy band is open, and institutional bands will disappear on purpose-built user action, not just a rare state combination. Decide *before* shipping resize whether hiding institutional headers below some height is acceptable UX — if not, the fallback needs a different shape (e.g., refuse to shrink the frame below the height that fits all 7 headers + a minimum-height heavy pool, or use a horizontal split instead of only compressing vertically).

## 5. Resize / min size

- **`MainFrame.lua` has no `SetResizable`, no resize grip, no `SetMinResize`/`SetMaxResize`.** The frame is a hardcoded 480×420 today. Users cannot make the window bigger to see more of a huge Fresh Beef band, nor smaller to reclaim screen space — despite `OfficerTab.lua` already being refactored toward panel-size-driven layout math (`_PanelHeight()`/`_PanelWidth()`, `colSplitFor()`, `visibleRowsFor()`), which is currently dead flexibility because nothing can change the panel's size.
- **When resize does ship, the defensive floors already present are a good sign** — `QUEUE_MIN_VISIBLE = 4`, `COL_SPLIT_MIN/MAX = 150/240` in `OfficerTab.lua` already clamp degenerate small sizes. `LadderTab.lua` has no equivalent floor concept yet (`CONTENT_BUDGET` is a fallback constant, not a clamp), and its `"focus"` mode (§4 above) is effectively the *only* current small-height behavior, and it's the wrong one for the institutional-bands doctrine.
- **No minimum-size contract is written down anywhere** (design spec, brief, or code comment) for what happens at the smallest supported frame size. Recommend the redesign spec state a concrete minimum content height/width and an explicit small-height Ladder behavior (e.g., "below N px, collapse ALL bands to header-only rows including the expanded one's occupant preview, but never hide a band entirely") before resize code lands, not after.

## 6. What must NOT be called "polished" without `/reload` smoke

None of the following are provable by `lua tests/run.lua` or by this desktop review — they need a live Anniversary `20506` client per `verification.mdc` / the skill's Polish loop, and none of them should be waved through on "the harness is green":

1. **The "+N more"/"Collapse" click affordance** (headline finding) — does it read as clickable on a real screen at real UI scale, mouse cursor included?
2. **Mousewheel feel scrolling an 800+ member heavy viewport** — is 1 row/notch tolerable, or does it need multi-row-per-notch, a real scrollbar thumb, or Page Up/Down before anyone calls this "readable"?
3. **`FauxScrollFrameTemplate` behavior on the Officer queue on `20506` specifically** — thumb drag, `OnVerticalScroll` offset math, and interaction with the (still-being-refactored) responsive row count.
4. **The `"focus"` layout mode** — force it (small frame once resizable, or a synthetic learning-banner+heavy-expand state) and visually confirm whether losing 6 of 7 institutional bands is acceptable, not just "does it not error."
5. **`GUILD_ROSTER_UPDATE` storm behavior against a real large guild** — the offline harness cannot fire real event bursts at real frequency; confirm the ≤10 Hz budget is actually met (it currently has no coalescing code to meet it with) rather than trusting the spec prose.
6. **Combat interactions specific to this redesign** — `docs/phases/solo-smoke.md` step 8 only says "open/close `/beef` mid-trash." It does not yet exercise: expanding/collapsing a heavy band in combat, scrolling the heavy viewport in combat, or typing into either Find box in combat. Add these explicitly before signing off — none should taint (insecure frames, `Show/Hide`/`SetPoint` only), but "should" is not "confirmed."
7. **Two-Find-box behavioral drift** (§3.3) — a human needs to notice and decide whether the realm-suffix inconsistency between Ladder Find and Officer Filter is intentional, because no test currently asserts either way for the Officer side.
8. **Class color rendering at real roster scale** — confirm no visible flash/white-name storm while `buildClassColorCache()` re-scans on every keystroke-driven repaint.

Per `docs/superpowers/ui-polished-direction-for-agents.md`, only a human may sign `POLISH:PASS`/V1-complete; agents may claim `POLISH:CANDIDATE` **after** the above are actually walked in client, not inferred from this document.

## 7. Concrete acceptance checklist for the redesign

In addition to design spec §9's existing 12 criteria, an implementer should be able to check every box below before claiming `POLISH:CANDIDATE` on this surface:

- [ ] `lua tests/run.lua` exits 0 on a clean, non-concurrent checkout (this review hit a red harness three times from live edits — confirm green on a settled tree, not mid-refactor).
- [ ] The Ladder "+N more"/"Collapse" control has a visible hover/highlight state (texture, color change, or `UIPanelButtonTemplate`-derived chrome) — a screenshot alone should suggest it's clickable.
- [ ] The Ladder heavy viewport has *some* jump mechanism beyond 1-row-per-wheel-notch for bands over ~100 members (real scrollbar thumb, Page Up/Down, or an explicit "type to find, don't scroll to browse" affordance called out in the UI copy).
- [ ] Scrolling the heavy viewport, then filtering, then clearing the filter, restores (or explicitly and intentionally resets, documented as such) the prior scroll position.
- [ ] Officer queue Find box is debounced the same way Ladder Find is (or a documented reason exists for the difference).
- [ ] Ladder Find and Officer Filter agree on whether a realm suffix can match (currently they disagree).
- [ ] `GUILD_ROSTER_UPDATE`/`PLAYER_GUILD_UPDATE` handling in `MainFrame.lua` coalesces bursts (timer-debounced or dirty-flag-deferred) instead of synchronously re-walking the roster and repainting on every single event.
- [ ] Class-color cache is invalidated on roster-change, not rebuilt unconditionally on every dirty repaint (or the cost of the current approach is measured and accepted in writing).
- [ ] `layoutMode == "focus"` is exercised in a manual test (small frame or forced state) and a human has confirmed hiding 6 of 7 institutional bands is acceptable — or the fallback is redesigned so institutional bands are never fully hidden, before `MainFrame` gains `SetResizable`.
- [ ] If/when `MainFrame` becomes resizable: `SetMinResize`/`SetMaxResize` are set, and the minimum size is chosen so at least the 7 band headers stay visible at all times (tie this to the `"focus"` decision above).
- [ ] Over-capacity seats (`taken > maxSeats`, e.g. the observed `Beef Council 9/4`) render explicit copy rather than a bare fraction that can read as a bug.
- [ ] `docs/phases/solo-smoke.md` (or its successor) is extended to explicitly exercise: expand/collapse in combat, heavy-viewport scroll in combat, Find/Filter typing in combat, and a ≥500-member live-guild pass (not just the ≥200 synthetic roster the offline harness uses).
- [ ] A human has visually confirmed `FauxScrollFrameTemplate` behavior on Anniversary `20506` for the *current* (post-refactor) Officer queue shape — not carried over from an earlier accepted screenshot of a now-changed implementation.
- [ ] The design spec's "Officer queue: fixed visible pool (raise to 10)" language is reconciled with the in-progress responsive `visibleRowsFor()` implementation (pool of up to 16, minimum 4, actual count derived from panel height) — pick one and update the doc or the code so they agree.

---

## Related

- Spec under review: [`2026-07-26-large-guild-ladder-ui-design.md`](2026-07-26-large-guild-ladder-ui-design.md)
- UI doctrine: [`../ui-polished-direction-for-agents.md`](../ui-polished-direction-for-agents.md)
- Perf/taint rules: `.cursor/rules/wow-performance.mdc`, `.cursor/rules/wow-ui-taint-lockdown.mdc`
- Solo smoke walk: `docs/phases/solo-smoke.md`
- Research (guidance, not law): `docs/research/agent-polish-vision/00-SYNTHESIS.md`
