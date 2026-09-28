# Lane C — Church card + chronicle-first Records (UX rebuild)

You are working in `/Volumes/AI_Design_Drive/Beef_Addon`, a WoW TBC Classic Anniversary addon (Lua 5.1, plain global `ChurchOfBeef` / `COB`). Read these first, they are binding:

- `.cursor/rules/ten-laws.mdc`, `.cursor/rules/architecture-overview.mdc`, `.cursor/rules/verification.mdc`
- `.cursor/rules/lua-cob-modules.mdc`, `.cursor/rules/quiet-event-modes.mdc`, `.cursor/rules/ui-juice-standards.mdc`, `.cursor/rules/records-not-points.mdc`, `.cursor/rules/identity-records.mdc`, `.cursor/rules/testing.mdc`
- `.agents/skills/church-of-beef-dev/SKILL.md`

## Where this fits

Lanes W (wire) and K (Pope kit) are done. This lane rebuilds the congregation-facing `/beef` surface (`UI/RecordsBook.lua`). David's binding direction:

- `/beef` Home becomes a **Church card**: who I am, and when we gather. Five-second read. Not a dashboard.
- Records become **chronicle-first**: a dated list of what actually happened, then superlatives **only when someone holds them**. Nine empty parchment pages do not ship.
- Empty zeros read as a prototype: **no counters on the card** (no roster/ceremony/Gora/marked-moment totals, no "latest ceremony" rows).

## Binding contract

### 1. Home — the Church card (pageIndex 0)

Keep everything structural that exists: the tome art and parchment leaves, masthead typography, seal/sigil focals, the 680×520 default with 620×500 floor, grip resize + `ChurchOfBeefDB.ui.recordsBook` persist, wheel navigation, ESC/OnHide remount pattern, `ToggleHome` / `Toggle` / `ShowHome` contracts (`/beef` from a records leaf returns Home; from Home it closes), `MODE = "QUIET"`, Theme-routed dress, ink discipline (charcoal/iron ink on parchment; class color on dark grounds only; gold/silver is ornament on parchment).

Card content (replace the current overview metrics):

- Player character name (display typography) and class (class-colored name on a dark band, per the established ink discipline).
- Church rank title, or "Not entered in the archive" when the player has no human row.
- Guild name and Blizzard guild role, small and secondary (keep the existing guildIdentity source).
- Sanctioned record: `W–L` (en dash) when the character has bouts, else "No sanctioned record".
- Honorifics: comma list, or "None recorded".
- **The Decree block**: the active Decree line + optional flavor (from `COB.Decree:Get()`), or the honest line "No gathering is posted." This is the card's second job — when we gather.
- One labeled path: an **Open the Records** button that turns to the Chronicle leaf.

Remove from Home: all archive/congregation counters, the runtime state word line, "latest ceremony" / "latest marked moment" rows, and any other at-a-glance metric. Marked moments leave the Home surface entirely (they stay in the Store; a later phase owns their display).

### 2. Chronicle leaf — the first records page

A new records page titled **Chronicle**, always present as the first page of the records area. It renders `Store:GetCeremonyLog()` rows — `{ id, type, at, participantIds, text? }` — newest first, one dated line each:

- Date prefix from the wall `at` (e.g. `date("%b %d", at)`), guarded when `at` is missing/not a number (then no prefix, not an error).
- Type-routed lines, resolving participant names through `Store:GetHuman` / `Store:GetCharacter` (Knighting/Elevation participants are human ids; Gora ruling participants are character ids — read `Store:RecordGoraResult` and `Core/Gora.lua` for the exact participant order; Recognition rows are character-then-human when present):
  - `Knighting` → "<name> was Knighted."
  - `Elevation` → "<name> rose to Beef Lord."
  - `victor` → "<winner> declared victor over <loser>." (two participants; degrade to "<winner> declared victor." when the second is missing)
  - `cowardice` → "Cowardice recorded: <name>."
  - `void` → "A bout was voided." (name the fighters when participant ids resolve)
  - `free` → "Free ruling." plus the Pope's `text` when present
  - Unknown future types → the type token plus resolved names. Never invent prose beyond these patterns; the UI never narrates (Law 4) — these are record lines, not flavor.
- Empty store → one line: "Nothing has been written yet."
- No ranked ordering, no scores, no analytics. This is a dated ledger.

### 3. Superlatives — only when held

The nine §10.9 categories keep their existing computation (`buildPages` / `maxHolders` machinery) and their existing parchment presentation (roman W–L paint, medallions, class-colored names). Change: **a superlative page exists only when it has at least one entry.** Categories with no holder do not render, are not in the page list, and are not reachable by Prev/Next. "Tournament Champions" will simply not exist until data does.

The records area page list is therefore: `Chronicle` + held superlatives in the canonical §10.9 order. **Open the Records** lands on Chronicle.

### 4. Navigation and footer

- Footer: **Home**, **Chronicle**, **Previous**, **Next**. Remove the fixed Victories / Rivalries / Martyrs shortcut tabs.
- Previous/Next walk the records pages (Chronicle ↔ held superlatives). Hidden on Home; hidden in the records area when Chronicle is the only records page.
- Keep the current wheel-turns-leaf behavior (including over chrome), the current page-turn face re-apply, and the current pageIndex persistence semantics where they still apply.
- `GetOverview()` keeps its name and returns the new card model (a copy). `GetPages()` returns the records pages including Chronicle (a copy). Other public methods (`Init`, `Show`, `Hide`, `Toggle`, `ToggleHome`, `ShowHome`, `IsShown`, `Refresh`, `ResetForTests`, `toRoman`) keep their names and contracts.

### 5. Preview scenarios

Update `tests/preview_dump.lua` so the `dashboard` (Home), `records`, and `records_empty` scenarios dump the new structure (keep the scenario names — the responsive script expects them). Seed the `records` scenario with a small ceremony log + one held superlative so the Chronicle and a superlative page both render; `records_empty` proves the empty Chronicle line and the card's honest empty states. Verify: `COB_PREVIEW_DIR=$(mktemp -d) lua tests/preview_dump.lua` exits 0.

## Tests (TDD: rewrite `tests/test_records.lua` first, watch fail, implement, green)

Rewrite the suite around the new contract. Keep every pin for retained behavior (tome art routing, medallion pool created once, resize persist shape, wheel on chrome, ESC/OnHide remount, ToggleHome semantics, Theme fonts/colors, ink discipline, roman numeral paint on superlative entries, class colors on names). New pins: card shows identity + Decree and zero counter strings; "No gathering is posted." empty state; Open the Records lands on Chronicle; chronicle line formats per type (each pattern above, incl. degraded missing-participant forms and the date guard); newest-first; empty chronicle line; unheld superlatives absent from `GetPages()` and unreachable by Next; held superlatives present in canonical order; footer tab set.

Full harness `lua tests/run.lua` exits 0 at the end.

## Hard rules

- Lua 5.1. Multi-return errors. Getters return copies. No Core edits in this lane (Store reads only).
- Ten Laws: no points/standings; superlatives stay superlatives (no sortable ladder, no "#1"); no activity metrics; Quiet Mode — the book is player-opened Quiet identity/history, no feeds.
- Law 10: this is the theatrical surface — full ecclesiastical dress via Theme. The UI never tells jokes; chronicle lines are record lines.
- Do not touch other UI modules, the glue (`ChurchOfBeef.lua`), TOC, or Net. Do not commit. Do not touch `WTF/`. Do not edit `docs/` except your report.
- Presence "here" is OPEN_QUESTIONS #13 — do not add presence/online anything to the card.

## Report

Write your full report to `docs/reformation/ux-rebuild/briefs/C-church-card-report.md`: what changed per file, test counts before/after, full-harness result, preview_dump result, concerns. Return only: status (DONE / DONE_WITH_CONCERNS / BLOCKED / NEEDS_CONTEXT), one-line test summary, and concerns if any.
