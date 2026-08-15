# Church of Beef — Large-guild Ladder UI (design amendment)

**Date:** 2026-07-26 (revised 2026-07-26, "900-member reality" pass; amended 2026-08-01, layout-truth pass)
**Status:** Implemented · **Accept-candidate** for parent §15 — pending in-game `/reload` smoke of expand / filter / scroll / resize at a realistic roster (Phase 6.2). Offline invariants are harness-enforced.
**Scale target:** up to **1200** roster rows, with **≥900 in a single band** (Fresh Beef)

**Amends:** [2026-07-25-church-of-beef-design.md](2026-07-25-church-of-beef-design.md) (§10 Ladder / Officer tab presentation), [2026-07-25-roster-backed-ladder-design.md](2026-07-25-roster-backed-ladder-design.md) (§8 UI copy / empty states — presentation only)
**Does not amend:** Roster as title authority, standing → suggestions only, no auto guild promote/demote, Officer+ gate via `rankIndex`, Interface `20506`, layer rules (UI→Core→Data), announce deferral, eligibility/rites model

---

## 1. Intent

The roster-backed Ladder mirrors the live guild roster. That is correct authority — and at real guild size it breaks the Ladder **presentation**.

Live evidence (Anniversary, 2026-07-26 screenshot): `Beef Council 9/4`, `Cooked Beef 61 · +53 more`, `Fresh Beef 880 · +872 more`. Every band is a comma list terminating in a dead-end count; the Council preview wraps and paints **over** the Beef Butcher header. The institutional ladder reads as a corrupted paragraph, not a church.

This amendment redesigns **Ladder and Officer queue presentation** so a ~900-member flock stays scannable, stream-safe, resizable, and Classic-chrome-first — without turning the Church ladder into a flat spreadsheet or inventing a second rank authority.

### 1.1 What changed in this revision

| Δ | Why |
|---|-----|
| Scale target 200–500 → **900+ in one band** | Live roster reality; sizing constants were tuned an order of magnitude too small |
| Added **§6 Responsive resize** (was absent) | 7 bands + a scroll viewport cannot live in one fixed 480×420 box; the user must be able to grow the window |
| Layout math promoted to a **pure `LayoutPlan` helper** | Height-driven layout is the part most likely to regress; it must be harness-testable, not buried in `OnRefresh` |
| Row pools redefined as **bounded grow-only** | A resizable window needs more than 12 rows; "fixed 12" and "resizable" are incompatible |
| Named the **`Testing` export contract** (§7.4) | Two harness suites already assert `LadderTab.Testing.*`; the contract was implied, not written |
| Single-line clipping mandated (§8.2) | The overlap in the screenshot is a wrapping FontString, not a spacing bug |
| Seat-overflow honesty rule (`9/4`) | Roster is authority; `CouncilSeats` is Church ideal. The UI must show the conflict, not hide or "fix" it |
| Normalization centralized on `COB.Roster.NameKey` | Three copies of `nameKey` had already appeared across UI files |

### 1.2 What changed on 2026-08-01 (layout-truth pass)

| Δ | Why |
|---|-----|
| Added the **`inline`** mode (§4.3) | An expanded band narrowed by Find has no viewport to scroll; it was drawn into a header-height row and the next band landed on top of it |
| **`focus` keeps all seven headers** (§4.3, §7.2) | The spec said "expanded band header only", the paint path did the opposite, and the tested invariant was written to match the spec — so nothing was checking the frame that was actually drawn |
| Reserve invariant re-derived over the **reachable** height range (§7.2) | The old sweep ran `[320, 760]` against a formula the paint path did not use; the new one runs the real function from the minimum draggable content height up |
| `LayoutPlan` gained `heavy`, `previewHeight`, `hintShown`, `overflow` | The plan now decides everything the paint path used to re-decide for itself |
| Band buckets memoized per roster generation; sort keys precomputed | A 900-name band re-normalized roughly two keys per comparison, ~17k throwaway strings per repaint |
| Officer queue cached per `(Ladder revision, needle)` | Scrolling a long queue re-copied and re-sorted every petition in the guild |
| `Roster:GetOccupantCount()` | The status chip built the full sorted ladder view to compare a count against zero |

---

## 2. Decisions (locked for Accept)

### 2.1 Information architecture

| Topic | Decision |
|-------|----------|
| IA shape | **Institutional bands 7→1** remain the primary chrome — not a flat name spreadsheet |
| Overflow model | **Hybrid per-band:** collapsed summary + expand/collapse + bounded-pool scroll inside the expanded band |
| Default collapse | All bands start **collapsed**; a band renders inline (no viewport) whenever its occupant count ≤ preview cap |
| Preview cap | Default **8** names per collapsed band (module constant; not SavedVariables in first ship) |
| Expand affordance | Chevron glyph in the band title (`▶` collapsed / `▼` expanded, text only — no Media) **and** the `+N more` control; the whole band header is the click target |
| No-overflow bands | No chevron, no click target — a band that fits is not a disclosure widget |
| "+N more" | Clickable; expands that band in place. Never opens a second window |
| Detail view | Expanded band = scrollable name list in a height-derived viewport backed by a bounded row pool |
| Heavy-band budget | At most **one** expanded scroll viewport mounted at a time (§5.1) |
| Find / filter | Single `InputBoxTemplate` "Find name" above the band stack; filters occupant lists client-side; Escape / empty text clears |
| Filter semantics | Case-insensitive substring on the **normalized** name (casefold + strip `-Realm`); empty filter = full flock; filter never hides institutional bands |
| Sort | Within a band: **alpha by name** only. Never sort bands or members by standing |
| Self encoding | `Name (You)` + gold tint; self's band title gold-tints; self always appears in the preview slice even when collapsed |
| Class color | Names only; self gold wins over class tint |
| Seat fractions | Council / Prophet `taken/max` unchanged; **over-seat honesty** rule in §2.4 |
| Band-stack scroll | **Rejected.** Seven headers always fit inside the minimum window; adding an outer scroll on top of an inner scroll is the classic nested-scroll trap |
| Multi-column name grid | **Rejected for first ship** (open-if-playtest, §12) |
| Flat list mode | **Rejected** for this amendment (revisit only if playtest proves bands fail at 900+) |

### 2.2 Widgets, APIs, and pools

| Topic | Decision |
|-------|----------|
| Frame chrome | Plain Classic `BasicFrameTemplate`; insecure `CreateFrame`; no custom Media |
| Scroll widgets | `FauxScrollFrameTemplate` (or a plain frame + owned integer offset + mousewheel) |
| HybridScrollFrame | **Banned**, even on clients that ship it. Larger template/API surface with no benefit over faux offset + pooled rows |
| Retail-only APIs | Banned. Every widget call that is not universally present in `20506` must be feature-detected (§6.2) |
| Row pools | **Bounded grow-only.** Allocate an initial pool; grow on demand up to a hard ceiling when the layout plan asks for more visible rows; **never** free, **never** allocate per member |
| Pool growth driver | **Viewport height only** — never occupant count. A 900-member band and a 12-member band use the same pool at the same window size |
| Officer queue | Same doctrine: bounded grow-only pool + `FauxScrollFrame`; "+N more" becomes a scroll affordance, never a dead label |
| Officer evidence | Keep select-row → evidence pane; scrolling and filtering the queue must preserve selection |
| Standing correction | Unchanged (name + delta + Apply). Ladder Find does not auto-fill the Officer subject |
| Name normalization | Single law: `COB.Roster.NameKey(name)` (pure static on Core). UI keeps a local fallback for load order only — it must not diverge |
| Class colors | Cached in the Core roster snapshot (`entry.classFile`), not rescanned by the UI per paint |
| `SetGuildRosterShowOffline` | Still never toggled as a validation / UI side effect |
| LibGuildRoster | Soft-dep OK if present; solo load mandatory (no hard `Dependencies`) |
| Motion / juice | Show/Hide + short alpha only; no permanent `OnUpdate`; expand/collapse is instant or ≤~200 ms self-clearing |

### 2.3 Resize (new)

| Topic | Decision |
|-------|----------|
| Resizable MainFrame | **Yes.** Bottom-right grip; movable behavior unchanged |
| Bounds | Min **420×320**, max **900×760**, further clamped to `UIParent` effective size |
| Default | **480×420** (unchanged — existing users see no jump) |
| Persistence | `ChurchOfBeefDB.ui.size = { w, h }`, validated and re-clamped on restore |
| Scale | Guest on player `uiScale`. Never `UIParent:SetScale`, never write `uiScale` |
| Repaint policy | `OnSizeChanged` sets dirty and coalesces (≤10 Hz); pool growth and SV write happen on **sizing stop** only |
| Layout response | Height drives band mode + visible row counts; width drives Officer column split and text clipping |
| Preview cap vs width | Preview cap stays **8** at every width (deterministic; open-if-playtest) |

### 2.4 Honesty rules

| Situation | Rule |
|-----------|------|
| Guild rank map puts more members in Council than `Ranks.CouncilSeats` (`9/4`) | Show `9/4` verbatim. Append a muted `— over seats —` hint in the band. **Never** clamp, hide, recolor as an error, or reorder. The roster is authority; `CouncilSeats` is Church ideal, and a mismatch is real information for the Prophet |
| Filter active | Seat fraction and member count are **always unfiltered**; only the name list narrows |
| Band with 0 occupants | `—`; scarce seats may add vacancy copy |
| Self missing from client roster | Do not invent. Fall back to the last known roster map, else the Fresh Beef default story |

---

## 3. Problem statement (current build)

| Surface | Failure at scale | Root cause |
|---------|------------------|------------|
| Band preview | Council preview wraps to 2 lines and paints over the next band header | Occupant `FontString` word-wraps inside a fixed-height 40 px band |
| Band preview | Comma soup terminating in `+872 more` | Preview is a single concatenated string, not a list |
| Overflow control | `+872 more` reads as a dead label | Affordance is a bare `FontString`-styled button with no chevron and no hover copy |
| Window | Fixed 480×420 | The user cannot trade screen space for readability |
| Paint cost | `buildClassColorCache()` walks the entire guild roster **every paint**; `occupantsForRank` walks the whole view **7×** | UI is doing Core's caching job; O(7N + M) per dirty paint at N≈900 |
| Officer queue | Pool fixed at 10 regardless of window height | No height-derived sizing |
| Harness | 2 failures: `LadderTab.Testing` table absent | Pure helpers were written as file-locals; the contract in §7.4 was never published |
| Mental model | Institutional ladder is right; density and disclosure are wrong | — |

---

## 4. Information architecture & wireflow

### 4.1 Ladder tab (target)

```
┌─ /beef · Ladder ─────────────────────────────────────┐
│ [learning banner — optional, existing]               │
│ Find name: [______________________]                  │
│                                                      │
│   Beef Prophet                                1/1    │
│     Thedave (You)                                    │
│ ▶ Beef Council             — over seats —     9/4    │
│     Beefbank, Bladeofbeef, … ·        +1 more        │
│   Beef Butcher                                       │
│     Sisterbeef                                       │
│ ▶ Beef Lord                                    7     │
│     Dangoldave, Gashesleon, … ·       +2 more        │
│   Beef Knight                                        │
│     —                                                │
│ ▶ Cooked Beef                                 61     │
│     Abigstick, Amaraniri, … ·        +53 more        │
│ ▼ Fresh Beef                                 880     │
│     ┌────────────────────────────────────────┐       │
│     │ 1–24 of 880  (mousewheel)              │       │
│     │ Aalaera                                │       │
│     │ Abbinorma                              │       │
│     │ …                          [scrollbar] │       │
│     └────────────────────────────────────────┘       │
│                                                      │
│ Your title: Beef Prophet                        ◢    │
└──────────────────────────────────────────────────────┘
```

**Wireflow**

1. `/beef` → Ladder (default). Roster not ready → loading copy, bands hidden.
2. Roster ready → seven bands in institutional order **7→1**; each shows title, chevron (if it overflows), seat fraction or count, and a **single-line clipped** preview.
3. Click a band header or its `+N more` → that band expands into the heavy viewport; any previously expanded band collapses; sibling bands compress to header-only (§5.1).
4. Type in Find → bands remain; occupant lists shrink to matches; the band title gains `· N matches`. Seat fractions do not move.
5. Escape or clear Find → full flock returns; expand state is preserved for the session.
6. Drag the bottom-right grip → the band stack and heavy viewport re-derive their row counts from the new height (§6).
7. Officer promotes in the Blizzard guild UI → `GUILD_ROSTER_UPDATE` → Core snapshot → Ladder dirty → the name moves bands. **This is the social criterion; nothing in this amendment may break it.**

### 4.2 Officer tab (target)

```
┌─ Officer ─────────────────┬─ Evidence ───────────────┐
│ Promote prompts (14)      │ Promote Name → Title…    │
│ Filter [__________]       │ Standing / rite lines    │
│ ┌───────────────────────┐ │ [Dismiss]                │
│ │ · row              ▲  │ │                          │
│ │ · row (selected)   █  │ │ Standing correction      │
│ │ · …                ▼  │ │ [name] [±N] [Apply]      │
│ └───────────────────────┘ │                          │
└───────────────────────────┴──────────────────────────┘
```

Queue length is unbounded in Core; the UI shows a **window** into it. No second "queue page" modal. The column split is width-derived (§6.4).

### 4.3 Layout modes

The Ladder has exactly **five** layout modes, chosen by a pure function of available height and of whether the open band still overflows (§7.2). No other mode may be invented in Lua.

| Mode | When | Bands | Heavy viewport |
|------|------|-------|----------------|
| `normal` | No band expanded, and 7 full bands fit | 7 × full (title + preview), height-shared | none |
| `compact` | No band expanded, but 7 full bands do **not** fit | 7 × header-only | none |
| `inline` | A band is expanded but holds ≤ the preview cap — typically because Find narrowed it | 7 × header-only, **except** the open band at preview height | none |
| `compressed` | A band is expanded and overflows, and 7 headers + the **6-row floor** viewport fit | 7 × header-only | height-derived, ≥ 6 rows |
| `focus` | A band is expanded and overflows, and 7 headers + the floor viewport do **not** fit | 7 × header-only | whatever height remains, ≥ 1 row |

**`inline` (added 2026-08-01).** An expanded band whose contents fit in a preview has no viewport to scroll. It draws its matches under its own header at preview height. Previously such a band was given a header's height while a preview was drawn into it, so the next band was positioned on top of the names — the F8 overlap. Covered by a paint-level geometry regression in `tests/test_ui.lua` (band below starts at or under the open band's bottom edge).

**`focus` keeps all seven headers (amended 2026-08-01).** It was originally specified as "expanded band header only". The paint path never implemented that — it re-derived a keep-all-headers rule for itself after `LayoutPlan` had already decided otherwise, and overran the footer reserve by a few pixels at the smallest window. The rule now lives in `LayoutPlan`, and the institutional stack is preserved in every expanded mode: hiding six of the seven bands would be a different tab wearing this one's name. `focus` now differs from `compressed` only in that its viewport is below the 6-row floor, and it sacrifices the viewport's hint caption before it sacrifices a name row.

`focus` remains the degenerate mode for a window dragged near minimum. The footer-reserve invariant is asserted across the whole draggable range — from the smallest content height the frame can produce (`MIN_HEIGHT − CONTENT_TOP − FOOTER_HEIGHT`) up to the default budget, with and without the learning banner, in both heavy and inline states. No reachable size may set `plan.overflow`.

---

## 5. Component map (files & ownership)

Three implementers work in parallel. **Ownership is exclusive** — do not edit another owner's file to "just fix one thing"; raise it against the contract in §7 instead.

| File | Owner | Change |
|------|-------|--------|
| `UI/LadderTab.lua` | **Ladder implementer** — owns the list engine | Band headers + chevrons, collapse/expand, single-line clipped previews, `+N more`, heavy viewport + bounded pool, Find, empty/loading copy, `LayoutPlan`, `Testing` exports |
| `UI/MainFrame.lua` | **Chrome implementer** — owns shell & resize | Resize grip, bounds, size persistence, coalesced `OnSizeChanged` → dirty, content geometry, `UI:GetContentSize()`. **No tab-internal layout** |
| `UI/OfficerTab.lua` | **Officer implementer** — mirrors list patterns | Height-derived queue pool, `FauxScrollFrame` sync, width-derived column split, filter parity, selection preservation, `Testing` exports |
| `UI/Status.lua` | Chrome implementer | No IA change; keep hard-gate / learning banners coordinating with Ladder empty states |
| `Core/Roster.lua` | Ladder implementer | Add `classFile` to snapshot entries and `GetLadderView()` records; add `NameKey` pure static and `GetGeneration()`. Presentation *inputs* only — still no `CreateFrame`, still no points |
| `Core/Ladder.lua` | — | No authority change. `GetSuggestions()` already returns the full list; the UI windows it |
| `Data/Ranks.lua` | — | **Unchanged** (titles / thresholds / seats / map) |
| `ChurchOfBeef.toc` | — | Unchanged. Do not extract a shared UI helper file for this amendment; duplication of two 5-line normalizers is cheaper than a new load-order edge |
| `tests/test_ui.lua`, `tests/test_officer_ui.lua` | Test owner | Cover the §7.4 pure helpers and the §7.2 layout plan. Layout *pixels* remain client smoke |

**Layer rule:** UI reads Core copies; UI never awards points; Core never `CreateFrame`.

### 5.1 Single heavy viewport (rationale)

One expanded scroll viewport at a time, because:

- Seven nested scrollframes inside a 420 px panel is unreadable at any size.
- A single shared pool means the worst-case frame count is a constant, independent of guild size.
- Mousewheel routing is unambiguous — there is exactly one scrollable region.

Expanding Fresh Beef therefore collapses an expanded Cooked Beef, and vice versa. Bands at or under the preview cap render inline and never mount the viewport.

---

## 6. Responsive resize rules

### 6.1 Bounds and persistence

| Constant | Value |
|----------|-------|
| `FRAME_MIN_W` / `FRAME_MIN_H` | `420` / `320` |
| `FRAME_MAX_W` / `FRAME_MAX_H` | `900` / `760`, each further clamped to `UIParent:GetWidth()` / `GetHeight()` |
| `FRAME_WIDTH` / `FRAME_HEIGHT` (default) | `480` / `420` |
| Content width | `frameW − 24` |
| Content height | `frameH − CONTENT_TOP(58) − 28` |

Persist as `ChurchOfBeefDB.ui.size = { w = <number>, h = <number> }`. On restore: reject non-numbers, then clamp into bounds **and** into the current `UIParent` size (a user who changed resolution or `uiScale` must not get an off-screen window). Never store a frame reference in SV.

### 6.2 TBC-safe resize API (feature-detect, do not assume)

`SetResizeBounds` is a newer client API; `SetMinResize` / `SetMaxResize` are the `20506`-era pair. Neither exists in the desktop harness stub. Detect all three and always keep a manual clamp as the floor of correctness:

```lua
frame:SetResizable(true)
if frame.SetResizeBounds then
  frame:SetResizeBounds(FRAME_MIN_W, FRAME_MIN_H, FRAME_MAX_W, FRAME_MAX_H)
elseif frame.SetMinResize then
  frame:SetMinResize(FRAME_MIN_W, FRAME_MIN_H)
  if frame.SetMaxResize then frame:SetMaxResize(FRAME_MAX_W, FRAME_MAX_H) end
end
-- Belt and braces: clamp in OnSizeChanged regardless of which (if any) API existed.
```

Grip: a plain `Button` at `BOTTOMRIGHT` using stock TBC textures
`Interface\ChatFrame\UI-ChatIM-SizeGrabber-Up` / `-Down` / `-Highlight`,
driving `frame:StartSizing("BOTTOMRIGHT")` and `frame:StopMovingOrSizing()`.
If the texture is missing the button must still work (packaging rule: missing media never fails load).

Resizing an insecure Beef frame is combat-safe and requires no deferral.

### 6.3 Repaint policy while dragging

| Event | Action |
|-------|--------|
| `OnSizeChanged` | Clamp; set a `_resizePending` flag; coalesce a dirty mark at ≤10 Hz (`C_Timer.After(0.05)` guarded by the flag). **No** pool growth, **no** SV write |
| Sizing stop | Final `MarkDirty`, allow pool growth, write `ui.size` |
| No `OnUpdate` | Ever. Sizing is event-driven |

Rationale: pool growth allocates frames. Allocating during a drag would create dozens of `FontString`s on the way to the final size.

### 6.4 What each axis controls

| Axis | Ladder | Officer |
|------|--------|---------|
| **Height** | Layout mode + band height + heavy `visibleRows` (§7.2) | `QUEUE_VISIBLE` = `clamp(floor(listHeight / ROW_HEIGHT), 6, 32)` |
| **Width** | Preview clipping width and `+N more` gutter only. Preview cap stays 8 | `COL_SPLIT = max(168, floor(contentWidth * 0.40))`, evidence column min 220 px |

Tab buttons stay left-aligned at fixed width; extra width is slack. Do not re-flow the tab bar.

### 6.5 Pool sizing under resize

| Pool | Initial | Ceiling | Grows when |
|------|---------|---------|-----------|
| Ladder heavy rows | `DETAIL_ROW_POOL = 12` | `DETAIL_ROW_MAX = 48` | The layout plan requests more visible rows than are allocated, at sizing stop |
| Officer queue rows | `QUEUE_VISIBLE = 10` | `QUEUE_ROW_MAX = 32` | Same |

Pools are **grow-only** — never freed, never shrunk. Excess rows are hidden, not destroyed. At the default window size no growth occurs, so existing harness assertions on the initial pool size stay valid.

---

## 7. API surfaces & contracts for implementers

Everything in this section is a **contract**. Changing a name here is a spec edit, not a refactor.

### 7.1 Core (Ladder implementer adds; everyone consumes)

| Surface | Signature | Contract |
|---------|-----------|----------|
| `COB.Roster.NameKey(name)` | `(string?) -> string?` | Pure static (dot-call, no `self`). Casefold, trim, strip `-Realm`. **The single normalization law** for roster keys, Ladder Find, and Officer filter |
| `COB.Roster:GetLadderView()` | `-> { { name, rankId, standing, classFile?, revision, updatedAt, updatedBy } }` | Existing shape **plus** optional `classFile`. Sorted `rankId` desc, then name asc. Returns copies |
| `COB.Roster:GetGeneration()` | `-> number` | Monotonic counter bumped on every accepted snapshot. Lets the UI memoize band buckets and skip rebuilds. Optional — UI must work without it |
| `COB.Roster:IsReady()` | `-> boolean` | Unchanged |
| `COB.Ladder:GetLadderView()` | facade → `Roster:GetLadderView()` | Unchanged |
| `COB.Ladder:GetSuggestions()` | `-> { suggestion }` | Unchanged; returns the **full** list. The Officer tab windows it |

`classFile` is optional because the LibGuildRoster path may not supply it. Consumers must be nil-safe and fall back to no class tint — never to a per-paint roster walk.

### 7.2 `LadderTab.Testing.LayoutPlan` (pure — the load-bearing helper)

```lua
LadderTab.Testing.LayoutPlan({
  contentHeight = <number>,   -- panel height in px
  bannerShown   = <boolean>,  -- learning / hard-gate banner occupies top chrome
  expanded      = <boolean>,  -- a band is expanded
  heavy         = <boolean>,  -- that band still overflows after Find (default true)
}) -> {
  mode          = "normal" | "compact" | "inline" | "compressed" | "focus",
  topChrome     = <number>,   -- banner + Find strip
  bandHeight    = <number>,   -- HEADER_HEIGHT in every expanded mode
  heavyHeight   = <number>,   -- 0 unless mode is compressed/focus
  visibleRows   = <number>,   -- 0 unless mode is compressed/focus
  previewHeight = <number>,   -- 0 unless mode is inline; height of the open band
  hintShown     = <boolean>,  -- false when the viewport gave up its caption for a row
  overflow      = <boolean>,  -- the plan could not fit the reserve; unreachable by drag
}
```

`heavy` defaults to true so a caller that only knows "a band is open" gets the pre-amendment answer. The paint path passes the real state: it reads the band contents and applies the Find filter *before* planning, because whether the open band still overflows is what decides which layout it needs.

**Constants.** `BAND_HEIGHT 40`, `BAND_MIN_PREVIEW 32`, `HEADER_HEIGHT 18`, `FILTER_HEIGHT 26`, `BANNER_HEIGHT 34`, `FOOTER_RESERVE 18`, `DETAIL_ROW_HEIGHT 14`, `HEAVY_HINT_HEIGHT 18`, `DETAIL_ROW_MAX 48`, and two distinct row counts:

| Constant | Value | Meaning |
|----------|-------|---------|
| `HEAVY_FLOOR_VISIBLE_ROWS` | **6** | Hard floor. Below this the stack is sacrificed (`focus`) |
| `HEAVY_MIN_VISIBLE_ROWS` | **10** | Comfort target. Met at the default window size and above; **not** a mode gate |

Using the comfort target as the mode gate was the original error — it pushed the default 480×420 window into `focus` (whole institutional stack hidden) as soon as the learning banner appeared, i.e. exactly for new members.

**Algorithm (normative).**

```
topChrome = (bannerShown and BANNER_HEIGHT or 0) + FILTER_HEIGHT
avail     = contentHeight - topChrome - FOOTER_RESERVE

if not expanded:
    share = floor(avail / 7)
    if share >= BAND_HEIGHT          -> mode "normal",  bandHeight = BAND_HEIGHT
    elseif share >= BAND_MIN_PREVIEW -> mode "normal",  bandHeight = share
    else                             -> mode "compact", bandHeight = max(HEADER_HEIGHT, share)
    heavyHeight, visibleRows = 0, 0
else:
    bandHeight = HEADER_HEIGHT               -- every expanded mode keeps 7 headers
    leftover   = avail - 7 * HEADER_HEIGHT
    if leftover < 0: overflow = true; leftover = 0

    if not heavy:                            -- Find narrowed the band below the cap
        mode = "inline"
        previewHeight = min(max(leftover, 0), BAND_HEIGHT)
        if previewHeight < BAND_MIN_PREVIEW: previewHeight = min(BAND_MIN_PREVIEW, leftover)
    else:
        heavyFloor = HEAVY_HINT_HEIGHT + HEAVY_FLOOR_VISIBLE_ROWS * DETAIL_ROW_HEIGHT
        mode = (leftover >= heavyFloor) and "compressed" or "focus"

        -- The caption goes before the last name row does.
        rows = floor((leftover - HEAVY_HINT_HEIGHT) / DETAIL_ROW_HEIGHT)
        if rows >= 1: hintShown = true
        else:         hintShown = false; rows = floor(leftover / DETAIL_ROW_HEIGHT)
        if rows < 1:  overflow = true; rows = 1

        visibleRows = clamp(rows, 1, DETAIL_ROW_MAX)
        heavyHeight = (hintShown and HEAVY_HINT_HEIGHT or 0) + visibleRows * DETAIL_ROW_HEIGHT
```

**Invariant (harness-enforced, `tests/test_ui.lua`).** At every reachable content height — from `MIN_HEIGHT − CONTENT_TOP − FOOTER_HEIGHT` (234 px) to the default budget — with the banner on and off, and with the open band heavy and inline:

- `topChrome + 7*bandHeight + heavyHeight + previewHeight ≤ contentHeight − FOOTER_RESERVE`
- `bandHeight == HEADER_HEIGHT` in every expanded mode (the stack always survives)
- `overflow == false` (a reachable size that sets it is a bug, not a degraded mode)

Nothing may ever be laid out over the footer reserve. The invariant is now checked against the same function the paint path uses; the previous formulation exempted `focus` from the seven-header term because the paint path was overriding the plan.

**Reference behavior** (`contentHeight = frameH − 86`), expanded column measured with the banner shown:

| contentHeight | expanded + banner | rows | caption |
|---------------|-------------------|------|---------|
| 234 (min drag) | `focus` | 1 | dropped |
| 260 | `focus` | 2 | shown |
| 300 | `focus` | 5 | shown |
| 334 (default) | `compressed` | 8 | shown |
| 420 | `compressed` | 14 | shown |
| 640 | `compressed` | 29 | shown |

**Known, accepted discontinuity — now removed.** The original `focus` mode hid six headers, so growing the window across the `focus` → `compressed` boundary *reduced* visible rows once as the stack reclaimed its space. With `focus` keeping all seven headers, the two modes differ only in whether the viewport clears the 6-row floor, and row count is monotonic in height across the whole range.

### 7.3 `LadderTab` public methods (UI-callable)

| Method | Contract |
|--------|----------|
| `LadderTab:ExpandBand(rankId)` | Expands that band; collapses any other. Calling it on the already-expanded band collapses it. Resets scroll offset. Returns boolean |
| `LadderTab:CollapseDetail()` | Collapses the heavy viewport; restores `normal`/`compact`. Returns boolean |
| `LadderTab:ScrollDetail(delta)` | Moves the offset by `delta` rows, clamped. Repaints rows only — never re-runs the full band pass. Returns boolean |

### 7.4 `Testing` export contract (harness-facing)

Both tabs must publish their pure helpers on a `Testing` table. These are **pure functions** — no `self`, no frames, no globals.

```lua
LadderTab.Testing = {
  NameKey     = function(name)                 -> string?          end,
  FilterNames = function(names, needle)        -> { string }       end,
  VisibleSlice= function(names, selfName, cap) -> { string }, hidden end,
  WindowSlice = function(names, offset, size)  -> { string }       end,
  LayoutPlan  = function(opts)                 -> plan             end,
}

OfficerTab.Testing = {
  NameKey           = function(name)                     -> string?       end,
  FilterSuggestions = function(list, needle)             -> { suggestion } end,
  ClampOffset       = function(offset, count, visible)   -> number        end,
}
```

Semantics the harness relies on:

| Helper | Contract |
|--------|----------|
| `FilterNames` | Empty/nil needle returns the input list. Matches on `NameKey(name)` substring **and** on the raw lowercased name, deduplicated, order preserved. A realm suffix must **not** match (`FilterNames(names, "realm")` finds nothing when the only realm text is a `-Realm` suffix) |
| `VisibleSlice` | Returns at most `cap` names plus the hidden count. If `selfName` exists in the list but falls outside the cap, it **replaces the last visible slot**. Hidden count is `#names - cap` — the true remainder, not the post-substitution count |
| `WindowSlice` | Returns exactly `min(size, #names)` names starting at `offset`, clamping `offset` into `[0, #names - size]`. Never returns nils inside the slice |
| `ClampOffset` | Clamps into `[0, max(0, count - visible)]` |

Exporting these does not make them public API for other modules — nothing outside `tests/` may call `Testing.*`.

### 7.5 `MainFrame` surfaces (chrome implementer publishes)

| Surface | Contract |
|---------|----------|
| `UI:GetContentSize()` | `-> width, height` of the tab content panel. Tabs use this instead of reading the frame or hardcoding a budget. Must return sane defaults before `Init` |
| `UI:MarkDirty(name)` | Unchanged. Resize handling routes through this — no new refresh channel |
| `UI:RefreshLadder()` | Unchanged fan-out to ladder / standing / officer / minimap |

Tabs must **not** call `UI.frame:GetWidth()` or reach into `UI.content`.

---

## 8. Presentation details (implementer checklist)

Aligned with [`ui-polished-direction-for-agents.md`](../ui-polished-direction-for-agents.md).

### 8.1 Templates and tone

- `BasicFrameTemplate` shell (existing); `InputBoxTemplate` for Find; `UIPanelButtonTemplate` for real buttons; `FauxScrollFrameTemplate` for scroll chrome; `GameFont*` hierarchy (title large, occupants highlight, meta small/disable).
- Opaque high-contrast; no glass panels; no item-quality rainbow for ranks.
- Dual-encode: self = the word `(You)` **and** gold; pending officer rows keep the rite `(!)` cue.
- Stream-safe: no center pulses; expand/collapse is local panel motion only.
- Silent (no SFX). Guest on `uiScale`.
- Tooltip is acceptable for a truncated single name or a standing peek — never a substitute for expand/scroll.

### 8.2 Single-line clipping (fixes the screenshot overlap)

Every occupant preview line and every heavy pool row is **exactly one line**:

- `fs:SetWordWrap(false)` and, where available, `fs:SetMaxLines(1)` (feature-detect both).
- The preview anchors must reserve the right gutter for the `+N more` control (`≥ 76 px`) so the two never overlap.
- Band frames are positioned from the layout plan's `bandHeight`. A `FontString` must never be allowed to determine band height.
- If the preview would overflow the width, it clips — it does not wrap and does not push the next band.

This is the single highest-value fix in the amendment: the observed Council-over-Butcher overlap is a wrapping FontString, and no amount of spacing tuning fixes it.

### 8.3 Copy

| Element | Copy |
|---------|------|
| Collapsed preview | `Alice, Bob, Carol, …` + right-aligned `+304 more`; self pinned into the visible slice |
| Expanded header control | `Collapse` |
| Chevron | `▶` collapsed / `▼` expanded, prefixed to the band title with a trailing space |
| Heavy scroll hint | `1–24 of 880  (mousewheel)` |
| Over-seat hint | `— over seats —` (muted, band header, alongside the honest `9/4`) |
| Vacancy | `— seat open —` / `— N seats open —` (unchanged) |
| Band match count | `Fresh Beef · 12 matches` while Find is active |
| Footer | `Your title: <title>`, or `No members match.` when a Find matches nothing anywhere |

---

## 9. Performance budget

| Phase | Budget |
|-------|--------|
| UI closed | Events only — no Ladder/Officer paint, no filter work, no resize work |
| UI open, idle | Dirty-flag; coalesce refreshes ≤ **10 Hz** under `GUILD_ROSTER_UPDATE` storms |
| Band bucketing | **One** pass over the ladder view per paint (bucket into 7 arrays), not one pass per band. At N=900 that is 900 comparisons, not 6300 |
| Class colors | Read from the Core snapshot. **Zero** `GetGuildRosterInfo` calls in the UI paint path |
| Memoization | If `Roster:GetGeneration()` is available, cache the bucketed + sorted band arrays per generation and reuse them across paints (filter and layout still recompute) |
| Paint cost | Repaint visible rows only: ≤7 band headers + ≤`visibleRows` name rows. Never one frame per member |
| Scroll | `ScrollDetail` repaints the row pool only — it must not re-run bucketing, filtering, or layout |
| Filter | Recompute match lists on text change, debounced ~120 ms via `C_Timer`; no permanent `OnUpdate` |
| Resize | Coalesced ≤10 Hz while dragging; pool growth and SV write at sizing stop only |
| Combat | Updating FontStrings on insecure Beef frames is fine. No reparent/create storms |
| SV | No new unbounded logs. Expand state is session-local; only `ui.size` and `ui.point` persist |

**Anti-patterns (reject in review)**

- Permanent `OnUpdate` for scroll math, filter, or resize
- `CreateFrame` inside `OnRefresh` without pool reuse; any allocation proportional to guild size
- Scanning the guild roster inside `formatName`, or once per paint for class colors
- Growing pools during a resize drag
- Toggling `SetGuildRosterShowOffline`
- A flat virtual list of all 900 names as the only view (abandons institutional order)
- Nested scrollframes (outer band stack + inner band viewport)

---

## 10. Empty / loading / edge states

| Situation | Ladder copy / behavior |
|-----------|------------------------|
| Not in guild (or hard gate) | "You are outside the flock. Join a guild to earn standing." — bands, Find, and viewport hidden |
| In guild, roster not ready | "Waiting for guild roster…" — bands, Find, and viewport hidden |
| Roster ready, 0 members (shouldn't happen) | Bands visible with `—` |
| Band has 0 occupants | `—`; scarce seats may show vacancy copy |
| Band over its seat count | Honest `taken/max` + `— over seats —` (§2.4) |
| Filter with 0 matches in a band | "No matches" (disable font); band header still shown; no `+N more` |
| Filter with 0 matches globally | Every band shows no matches; footer reads "No members match." |
| Filter narrows an expanded band to ≤ cap | The heavy viewport auto-collapses to an inline list; expand state is remembered so clearing Find restores it |
| Self offline / missing from client roster | Do not invent; fall back to the last known roster map, else the Fresh Beef default story |
| Learning / sync banner | Sits above Find; the layout plan absorbs it via `topChrome` — it must never push content past the footer reserve |
| Window at minimum height | `compact` (or `focus` when expanded); no clipping of the footer, no scrollbar on the band stack |

Officer empty: "No pending suggestions." Filtered-empty: "No matching petitioners." Long queue: scrollbar appears; there is no dead "+N more".

---

## 11. Acceptance criteria

1. With a roster of **≥900** members (majority Fresh Beef), the Ladder remains readable: no single `FontString` holds more than the preview cap, and no band paints over another at any window size in `[420×320, 900×760]`.
2. Institutional order **7→1** is preserved; bands are not replaced by a standing-sorted grid.
3. Collapsed oversized bands show a single-line preview + a **clickable** chevron / `+N more`; bands that fit show neither.
4. Expanding a band shows a **scrollable** name list backed by a **bounded grow-only** pool; the pool never exceeds `DETAIL_ROW_MAX` and never scales with guild size.
5. Find narrows occupants without leaving the Ladder tab; Escape/clear restores the flock; seat fractions and counts stay unfiltered.
6. Self is dual-encoded (`(You)` + gold) and remains visible in the preview when collapsed in that band.
7. Officer queue with **>10** suggestions is fully reachable via scroll; selection, filter, Dismiss, and standing correction all still work, and selection survives scrolling and filtering.
8. The window resizes between the bounds, remembers its size across `/reload`, and re-clamps into `UIParent` on restore.
9. `LayoutPlan` satisfies the §7.2 footer-reserve invariant at every integer height in `[320, 760]`, with and without the banner, expanded and collapsed.
9a. At the **default** 480×420 window the seven institutional band headers stay visible while a band is expanded — with **and** without the learning banner (i.e. `mode == "compressed"`, never `focus`).
10. UI closed ⇒ no Ladder/Officer paint work; open dirty path coalesces ≤10 Hz under roster spam and under resize drag.
11. The UI paint path makes **zero** `GetGuildRosterInfo` calls.
12. `lua tests/run.lua` exits 0, including the §7.4 `Testing` helper suites.
13. No `SetGuildRosterShowOffline` side effect; no Retail-only APIs (all resize APIs feature-detected); no Core→UI; UI never awards points.
14. Soft-dep LibGuildRoster still optional; the addon loads solo; missing grip texture does not fail load.
15. In-game: `/console scriptErrors 1` → `/reload` → `/beef` smoke on Anniversary `20506` covering expand, filter, scroll, resize, and Officer scroll.
16. Agents may claim **POLISH:CANDIDATE** only after smoke; **POLISH:PASS** and V1 complete remain human-only.

---

## 12. Out of scope

- Flat spreadsheet / standing-sorted guild browser as primary IA
- Multi-column name grids at wide widths (open-if-playtest, §13)
- Outer scroll on the band stack
- `HybridScrollFrame`, AceGUI, DataBroker hard dependencies
- Configurable rank mapping UI
- Roster-diff guild-chat spectacle / announce checkbox revival
- Click-name → whisper / inspect / Blizzard guild roster jump
- Persisted per-band expand prefs (first ship = session-local; **size** does persist)
- Custom Media, SFX, center-screen celebration
- Virtualizing the Standing tab history
- Changing suggestion enqueue rules, rites checklists, or Core authority
- Auto `GuildPromote` / demote APIs
- Classic+

---

## 13. Open only if playtest fails

- Preview cap 8 too aggressive/loose on stream → tune the constant after one guild night.
- Single heavy viewport feels awkward → allow two light inline expands for mid-tier bands without scroll.
- 900 names in one alpha column is still a haystack → add an A–Z jump strip **inside** the heavy viewport (not a new window).
- Wide windows waste horizontal space → two-column name flow inside the heavy viewport at `contentWidth > 700`.
- Officers want the Ladder Find to seed the Officer subject → add an explicit click-through, never an implicit auto-fill.
- Bands still fail at 900+ → revisit an optional "Fresh Beef directory" subpanel **secondary** to bands, never a replacement.

---

## 14. Decisions log

Dated, append-only. Entries here are amendment-local; promotion into the parent spec §15 happens at Accept (§15 below).

| Date | ID | Decision | Rationale | Status |
|------|-----|----------|-----------|--------|
| 2026-07-26 | LG-01 | Keep institutional bands 7→1 as primary IA | The ladder *is* the product; a flat roster browser is Details!-dense and abandons the Church frame | Locked |
| 2026-07-26 | LG-02 | Hybrid overflow: collapsed preview + expand + bounded-pool scroll | Preserves bands while making every member reachable | Locked |
| 2026-07-26 | LG-03 | Preview cap 8, self always pinned into the slice | Readable at a glance; self-location is the first question a member asks | Locked |
| 2026-07-26 | LG-04 | One heavy viewport at a time | Bounds worst-case frame count; removes nested-scroll and wheel-routing ambiguity | Locked |
| 2026-07-26 | LG-05 | In-tab Find with normalized substring matching | Only way to reach a specific member in a 900-name band without a new window | Locked |
| 2026-07-26 | LG-06 | Alpha sort within bands only; never sort by standing | Standing is advisory; sorting by it would imply a second rank authority | Locked |
| 2026-07-26 | LG-07 | `FauxScrollFrame` / owned-offset pattern; `HybridScrollFrame` banned | `20506`-safe with the smallest API surface | Locked |
| 2026-07-26 | LG-08 | Officer queue mirrors the Ladder overflow doctrine (pool + scroll + filter) | One list engine idiom across tabs; kills the dead "+N more" | Locked |
| 2026-07-26 | LG-09 | Session-local expand state; no SV pref | Avoids a settings-budget expansion for a low-value pref | Locked |
| 2026-07-26 | LG-10 | Flat-list mode rejected | See LG-01 | Rejected |
| 2026-07-26 | LG-11 | **Scale target raised to 900+ in one band** | Live Anniversary roster shows `Fresh Beef 880`; the 200–500 assumption produced constants an order of magnitude too small | Locked (revision) |
| 2026-07-26 | LG-12 | **MainFrame becomes resizable** (420×320 → 900×760, size persisted) | Seven bands plus a scroll viewport cannot be readable in one fixed 480×420 box; the user must be able to trade screen space for density | Locked (revision) |
| 2026-07-26 | LG-13 | **Row pools redefined as bounded grow-only** (12→48 ladder, 10→32 officer), driven by viewport height and never by member count | "Fixed pool" and "resizable window" are contradictory; height-driven growth keeps the guild-size independence that actually matters | Locked (revision) |
| 2026-07-26 | LG-14 | **Four named layout modes** (`normal` / `compact` / `compressed` / `focus`) produced by a pure `LayoutPlan` | The old two-mode rule overflowed the panel below ~380 px frame height; making the math pure makes the footer-reserve invariant harness-testable | Locked (revision) |
| 2026-07-26 | LG-15 | **Occupant lines are single-line clipped**; band height comes from the layout plan, never from text | The observed Council-over-Butcher overlap is a wrapping `FontString`; spacing tuning cannot fix it | Locked (revision) |
| 2026-07-26 | LG-16 | **Seat overflow shown honestly** (`9/4` + `— over seats —`), never clamped or hidden | Roster is title authority; `Ranks.CouncilSeats` is the Church ideal. The gap is real information, and hiding it would be the UI quietly asserting a second authority | Locked (revision) |
| 2026-07-26 | LG-17 | **Class colors move into the Core roster snapshot**; UI makes zero `GetGuildRosterInfo` calls | The UI was walking ~900 roster rows on every dirty paint; caching belongs in the layer that already owns the roster | Locked (revision) |
| 2026-07-26 | LG-18 | **`COB.Roster.NameKey` is the single normalization law** | Three divergent copies of `nameKey` had already appeared; Find and roster keys silently disagreeing is a data bug waiting to happen | Locked (revision) |
| 2026-07-26 | LG-19 | **`Testing` export contract published** for both tabs (§7.4) | Two harness suites already assert `LadderTab.Testing.*`; the contract existed only in test code | Locked (revision) |
| 2026-07-26 | LG-20 | Resize APIs **feature-detected**, with a manual clamp as the floor | `SetResizeBounds` vs `SetMinResize`/`SetMaxResize` differ by client, and neither exists in the desktop stub | Locked (revision) |
| 2026-07-26 | LG-23 | **Mode gate uses a 6-row floor, not the 10-row comfort target** | Gating on 10 rows dropped the *default* 480×420 window into `focus` — hiding the whole institutional stack — the moment the learning banner appeared, i.e. for exactly the new members who need the ladder explained. The floor keeps `compressed` down to ~358 px and confines `focus` to genuinely tiny windows | Locked (revision) |
| 2026-07-26 | LG-21 | Multi-column name flow and A–Z jump strip **deferred** to open-if-playtest | Real fixes, but they multiply layout cases; ship the disclosure model first and measure | Deferred |
| 2026-07-26 | LG-22 | No new TOC file for shared UI helpers | Two 5-line normalizers are cheaper than a new load-order edge; revisit if a third consumer appears | Locked |

---

## 15. Parent spec §15 stub (paste into the design log at Accept)

```markdown
### 2026-07-26 — Large-guild Ladder UI Accepted

User **Accepted** [2026-07-26-large-guild-ladder-ui-design.md](2026-07-26-large-guild-ladder-ui-design.md).
Ladder keeps institutional bands (7→1) but adds per-band collapse/expand, a clickable
chevron / "+N more", a bounded-pool scroll viewport for oversized bands (Fresh Beef at
900+), and an in-tab Find/filter. The MainFrame becomes resizable (420×320–900×760, size
persisted) and all tab layout is derived from a pure LayoutPlan. The Officer promote-prompt
queue becomes a height-derived pooled scroller. Presentation-only — the roster remains title
authority; no flat spreadsheet; no Retail-only APIs; UI closed stays idle.

| Topic | Decision |
|-------|----------|
| Large-guild Ladder IA | Bands 7→1 + per-band overflow (collapse / +N more / bounded-pool scroll) |
| Ladder Find | In-tab name filter on the normalized name; alpha within band only |
| MainFrame resize | Resizable 420×320–900×760; size persisted; layout derived from height/width |
| Row pools | Bounded grow-only, driven by viewport height, never by guild size |
| Seat overflow | Shown honestly (e.g. 9/4 + "over seats") — roster stays authority |
| Officer queue scale | Height-derived pooled scroller (not a hard 6- or 10-row cap) |
```

---

## 16. Implementation sequencing

Ordered so each step is independently shippable and independently smokeable.

| # | Step | Owner | Unblocks |
|---|------|-------|----------|
| 1 | Single-line clipping + layout-plan-driven band heights | Ladder | Kills the visible overlap; makes every later step safe |
| 2 | Publish `LayoutPlan` + `Testing` exports; add the harness suites | Ladder + Test | Turns the harness green; makes resize provable |
| 3 | Chevron + clickable band header + honest seat-overflow copy | Ladder | Disclosure reads as a control, not a label |
| 4 | Resize grip, bounds, persistence, coalesced dirty, `UI:GetContentSize()` | Chrome | Height/width become real inputs |
| 5 | Bounded grow-only pools wired to `LayoutPlan.visibleRows` | Ladder | Large windows show more names |
| 6 | `Roster` `classFile` + `NameKey` + `GetGeneration`; UI drops its roster walk | Ladder | Removes the O(N)-per-paint cost at 900 |
| 7 | Officer height-derived pool + width-derived column split + filter parity | Officer | Tab parity |
| 8 | Anniversary smoke (expand / filter / scroll / resize / Officer) + polish critique | All | **POLISH:CANDIDATE** |

Steps 1–3 and 4 can proceed in parallel across owners; step 5 depends on 2 and 4; step 7 depends on 4.

Do not claim V1 complete from this amendment alone. `POLISH:PASS` and V1 complete are human-only.
