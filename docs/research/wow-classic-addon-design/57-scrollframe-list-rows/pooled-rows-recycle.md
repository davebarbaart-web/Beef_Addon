# Pooled rows, recycle, and list performance

**Track:** [57-scrollframe-list-rows](README.md)  
**Last updated:** 2026-07-25

## 1. Why pooling is non-negotiable

Wiki / author consensus:

- Frames created with `CreateFrame` **cannot be deleted or garbage-collected**; reuse is preferred ([CreateFrame](https://warcraft.wiki.gg/wiki/API_CreateFrame)).  
- Practical pool: `table.remove(pool) or CreateFrame(...)` to acquire; hide + `table.insert(pool, frame)` to release ([SDPhantom, t=58069](https://www.wowinterface.com/forums/showthread.php?t=58069)).  
- Keep **separate pools per template / row shape** so Approve-button rows never mix with simple text rows.

For scroll lists, the pool is usually **fixed at create time** to `numVisible` (Faux/Hybrid style), not an acquire/release stack that grows with guild size. Both are “pooling”; scroll lists prefer the fixed viewport pool.

## 2. Recycle = rebind data, don’t rebuild widgets

On every paint (open tab, scroll, dirty refresh):

1. Know `data[1..N]` (ladder view or suggestion queue — owned by Core).  
2. Know `offset` (0 if no scroll; else Faux/Hybrid GetOffset).  
3. For `i = 1 .. numVisible`:  
   - `index = i + offset`  
   - if `index ≤ N`: fill FontStrings / button state / stored `row.record` or `row.suggestionId`; `:Show()`  
   - else `:Hide()`  
4. Update scrollbar math if using Faux/Hybrid.

**Do not:** `CreateFrame` inside the paint loop for each data row.  
**Do not:** destroy and recreate the whole list on `CHAT_MSG_ADDON`.  
**Do:** clear stale click payloads when hiding (`row.suggestionId = nil`) so recycled rows cannot approve the wrong person.

## 3. Anonymous frames vs globals

| Pattern | Use |
|---------|-----|
| Named globals `MyModEntry1`… | Classic HOWTO; works; pollutes `_G` |
| `parent.rows[i]` anonymous frames | Prefer for Beef (track 35 antipattern: “new global name per ladder row”) |
| XML `$parent` children | Fine if/when a virtual row template exists |

Store per-row UI refs once at create (`row.Name`, `row.Rank`, `row.Approve`) — avoid `getglobal` / `_G[name.."Text"]` in hot paint if you can.

## 4. Performance rules for list paint

Aligned with [54](../54-memory-fps-budgets/) without restating its full budget table:

| Rule | Why |
|------|-----|
| Pool size = visible slots only | O(viewport) widgets, not O(guild) |
| Dirty-flag → one paint | Sync storms must not rebuild N times |
| Rebind strings; avoid `{}` alloc in paint | GC hitch ([54 garbage-patterns](../54-memory-fps-budgets/garbage-patterns.md)) |
| No permanent `OnUpdate` for lists | Scroll events + explicit Refresh |
| Open `/beef` creates pool once | Subsequent opens rebind only |
| Cap work in Approve OnClick | Core commit + Net send; UI just marks dirty |

Target mental model from 54: cold open ladder &lt; ~5 ms wall for typical guild; dirty refresh &lt; ~2 ms. Fixed 7-band ladder is trivially under that if paint is rebind-only.

## 5. Variable-height rows

Faux HOWTO assumes constant `valueStep` (row pixel height). Hybrid can express total pixel height (`#items * buttonHeight`). For Beef V1:

- Ladder bands: fixed height (even if occupant string wraps — prefer truncate + tooltip over variable band height).  
- Officer rows: fixed height with Approve/Reject on the row.  
- If occupant lists explode (everyone stuck at Fresh Beef), prefer **secondary detail** (Standing tab / tooltip / click → filter) over mega variable-height scroll rows.

## 6. Acquire/release pools (non-scroll)

Useful when the number of *simultaneous* widgets is unpredictable (toasts, temporary dialogs) — not the main ladder pattern. Toast singleton from 54 is stricter and better for promotions. Officer confirm dialogs can be one reused modal frame.

## 7. Checklist for list PRs (research criteria)

- [ ] No `CreateFrame` in scroll/update paint path after first build  
- [ ] Hidden rows clear action identity (no stale Approve target)  
- [ ] `OnVerticalScroll` passes function reference if Faux is used  
- [ ] Refresh coalesced under chatty events  
- [ ] Pool growth bounded (visible slots or documented max acquire)  
- [ ] No true ScrollChild wrapping a column of action buttons  
