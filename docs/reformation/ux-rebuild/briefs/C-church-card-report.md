# Lane C — Church card + chronicle-first Records: report

Lane: `C-church-card.md` (UX rebuild). `/beef` Home is now a Church card (who I
am, when we gather) with zero counters; records are chronicle-first with
superlatives only when held. TDD: suite rewritten first, watched red (614
passed / 165 failed against the old build, run to completion), implemented,
green (783 / 0).

## What changed, per file

### `addon/ChurchOfBeef/UI/RecordsBook.lua` (full rewrite, 1733 → ~1560 lines)

**Home (pageIndex 0) — the Church card.** `overviewModel()` now returns only:
`playerName`, `class`, `classKey`, `churchRank` ("Not entered in the archive"
without a human row), `guildName` / `guildRole` (raw `GetGuildInfo` values, may
be nil), `record` (`W–L` en dash, else "No sanctioned record"), `honorifics`
(comma list, else "None recorded"), `decreeLine` (`COB.Decree:Get()` line, else
"No gathering is posted."), `decreeFlavor`. Removed from the model and the
surface: roster/ceremony/Gora/marked-moment counters, the runtime state word,
the "latest ceremony" / "latest marked moment" rows. The module no longer
references `COB.Runtime`, `COB.Roster`, or `Store:GetMarkedMoments` at all.
Masthead on Home is the constant "Church of Beef"; left leaf title is "The
Gathering"; right leaf is "Your Place" with the retained dark player plate
(class-colored display name, class line), then CHURCH RANK / GUILD
("Name — Role", else "No guild") / SANCTIONED GORA / HONORIFICS cells. The
Decree block keeps its dark plate (gold head, parchment line, optional silver
flavor gated on height ≥ 460). One labeled path: an **OPEN THE RECORDS** button
(ribbon-dressed) that turns to the Chronicle leaf. `ShowHome` no longer pokes
`Roster.Refresh` (the card reads nothing from the roster).

**Chronicle leaf.** `chroniclePage()` is always records page 1 and renders
`Store:GetCeremonyLog()` rows newest-first (reverse append order), one dated
line each. Date prefix is `date("%b %d", at) .. " — "`; WoW's global `date` is
used when present, `os.date` otherwise, pcall-guarded; a missing/non-numeric
`at` renders with no prefix, not an error. Type-routed record lines (Law 4 —
fixed patterns, never narration), resolving via `Store:GetHuman` /
`Store:GetCharacter`: `Knighting`/`Elevation` (human ids) → "<name> was
Knighted." / "<name> rose to Beef Lord."; `victor` (character ids,
winner-then-loser per `Core/Gora.lua`) → "<winner> declared victor over
<loser>.", degrading to "<winner> declared victor."; `cowardice` → "Cowardice
recorded: <name>.", degrading to "Cowardice recorded."; `void` → "A bout was
voided: <a>, <b>." when fighters resolve, else "A bout was voided."; `free` →
"Free ruling: <text>" when the Pope's text is present, else "Free ruling.";
`Recognition` (character-then-human per `Core/Recognition.lua`) and unknown
future types → the type token plus resolved names ("Recognition: Chuckroast,
Chuck."). Empty store → one line: "Nothing has been written yet."

**Superlatives only when held.** The nine §10.9 computations
(`buildSuperlatives()`, formerly `buildPages`) are byte-identical; `buildPages`
now returns `{ Chronicle } + ` the categories with ≥ 1 entry, canonical order
preserved. Unheld pages are absent from `GetPages()` and unreachable by
Prev/Next/wheel (turn clamps to the dynamic page count). "Tournament
Champions" never renders until data exists.

**Navigation / footer.** Footer tabs are Home, Chronicle, Previous, Next. The
fixed Victories/Rivalries/Martyrs shortcut ribbons and `jumpToTitle` are gone;
`jumpToChronicle` (pageIndex 1) serves the Chronicle tab and Open the Records.
Prev/Next hide on Home and hide in the records area when the Chronicle is the
only records page. Ribbon highlight: Home oxblood on the card, Chronicle
oxblood on records leaves. Marked moments left the book entirely (the records
right leaf keeps "Your Record" + Honorifics only; the Moments section is
deleted) — the Store keeps them; a later phase owns their display.

**Retained verbatim:** tome art routing (`tome_records` leaves, opaque leaf
fills, gold gutter/rules, `seal_papal` masthead seal + medallions, `sigil_gora`
player focal, `ribbon_bookmark` tabs), fixed 8-slot medallion pool created once
(`paint` only shows/hides), 680×520 default / 620×500 floor, grip resize +
`ChurchOfBeefDB.ui.recordsBook` persist (layoutVersion 2 shape unchanged),
wheel-turns-leaf including over chrome, page-turn face re-apply in `paint`,
ESC/`OnHide` remount + `rememberSpecial` contract (all source shapes the old
pins regex for are preserved), `ToggleHome` semantics (records leaf → card;
card → closed), `MODE = "QUIET"`, Theme-routed dress and ink discipline
(charcoal/iron ink on parchment; class color only on the dark band; gold/silver
text only on dark grounds), roman-numeral paint on superlative entries via
`Common.RomanNumeral`, `toRoman` public alias. `GetOverview()`/`GetPages()`
return deep copies. No Core edits — Store reads only (`GetCeremonyLog`,
`GetHuman`, `GetCharacter`, `Snapshot`, `CountDefenses`).

### `tests/test_records.lua` (rewritten, 2004 → ~1590 lines)

Retained pins kept: tome dress and Theme routing, medallion pool, resize
persist/clamps, wheel on frame + chrome, ESC/OnHide remount source-and-behavior
blocks (B25-C/B28-C/B38-D/B40-B/B41-D ported), paint face re-apply
(B30-C/B31-D ported), ToggleHome semantics, ink discipline, roman paint,
class-colored name, copy/no-write, tombstone permanence, silence, ResetForTests
guard, superlative content rules per category. New pins: card shows identity +
Decree with zero counter widgets/model fields (source pins + `rawget` absence
pins — the strict stub hard-errors on capitalized reads of absent fields);
"No gathering is posted." (both `COB.Decree` absent and `Get()` → nil);
Open the Records lands on Chronicle; chronicle line formats per type including
degraded missing-participant forms, Recognition character-then-human,
unknown-type token+names, date guard via hand-restored SV rows; newest-first;
empty chronicle line; unheld superlatives absent from `GetPages()` and
unreachable by Next; held superlatives in canonical §10.9 order after the
Chronicle; footer tab set (HOME/CHRONICLE/PREV/NEXT present;
RECORDS/RIVALRIES/MARTYRS gone); marked moments never render anywhere in the
book even when the Store holds them (full-widget-text scan).

### `tests/preview_dump.lua`

Scenario names kept. `dashboard` seeds identity + honorific + active Decree and
drops the counter/runtime/moment seeding (the card has none). `records` seeds a
small ceremony log (Knighting, three victor rulings, Recognition) plus held
superlatives via real bouts, asserts the Chronicle paints dated lines newest
first, proves a held superlative leaf renders, then rests on the Chronicle for
the dump. `records_empty` asserts the empty Chronicle line and the card's
honest empty states, then dumps the empty card.

## Test counts

| Stage | Result |
|---|---|
| Suite vs old build (TDD red) | 614 passed, **165 failed**, ran to completion |
| Suite vs new build (green) | **783 passed, 0 failed** |
| Full harness `lua tests/run.lua` | **15738 passed, 0 failed**, exit 0 |
| `COB_PREVIEW_DIR=$(mktemp -d) lua tests/preview_dump.lua` | 13 scenarios, exit 0 |

(Assertion totals differ red vs green by 4 because the Prev/Next walk loops
assert per hop and the page list length changed — expected.)

## Concerns

- **`Refresh` does not exist** on RecordsBook and never did (checked the
  committed file and the pre-lane working tree); nothing calls it. The brief's
  retained-methods list mentions it — treated as descriptive, not added
  (adding API would be inventing).
- **Unknown-type participant resolution order** is not pinned by the brief.
  Implemented best-effort character-first, human fallback; Recognition is
  character-then-human per the brief. Because human and character ids are
  separate 1..n sequences, an unknown-type id that exists as both resolves as
  the character. Documented by suite pins ("Canonization: Chuckroast.").
- **Chronicle length:** all rows render joined newest-first; the leaf's
  existing geometry (8-line medallion stride / maxLines) shows the most recent
  8. No scrolling invented — out of brief scope; flag if a later lane wants it.
- **Masthead on Home** is the constant "Church of Beef" (the card names the
  Church); the actual guild name lives in the small secondary GUILD cell per
  the brief. Old behavior used the guild name as the masthead.
- **Responsive renders not regenerated** — `scripts/render-responsive-previews.py`
  writes under `docs/design/renders/`, and the brief forbids `docs/` edits
  beyond this report. Scenario names are unchanged so the script consumes the
  new dumps as-is whenever it next runs.
- **No in-game smoke from this lane** — harness + preview_dump only. Per
  `verification.mdc`, `/reload` + `/beef` client smoke (and POLISH:PASS) remain
  human/client passes. POLISH:CANDIDATE at most.
- Working tree carried uncommitted Lane W/K changes throughout; left untouched.
  Footprint: `UI/RecordsBook.lua`, `tests/test_records.lua`,
  `tests/preview_dump.lua`, this report. Nothing committed.

## Fix wave 1

Review follow-up: two Important findings plus minors, fixed TDD (failing pins
first — 840 passed / 39 failed against the unfixed build, every failure on a
new pin — then implementation to green). Footprint unchanged:
`UI/RecordsBook.lua`, `tests/test_records.lua`, `tests/preview_dump.lua`,
this report. No Core edits. Nothing committed.

### 1. IMPORTANT — victor-line fallthrough misattribution

`ceremonyLine` victor/Knighting/Elevation branches no longer fall out of the
if/elseif chain into the generic token path when their expected participants
do not resolve. Bare non-attributing lines instead: "A victor was declared."
(winner unresolved — the loser is never named on a victor line; both ids
missing never renders a bare lowercase "victor." token), "A Knighting was
held.", "An elevation was held." The brief's "<winner> declared victor."
degrade (winner resolves, loser missing) is unchanged. Pins:
`runCeremonyDegradation` — six seeded rows covering winner-missing,
both-missing, loser-missing, human-missing, and a Knighting id that resolves
only as a character; red pre-fix ("victor: Tendermage.", "victor.",
"Knighting: Tendermage."), green after.

### 2. IMPORTANT — Chronicle geometry

The Chronicle leaf now renders **no medallions** (the papal seal marks a
superlative holder, not a ledger bullet) and paints one FontString per entry
from a fixed pool (`frame.ChronicleEntries`, created once in `buildFrame`;
`paint` only shows/hides and sets text). Each entry owns a fixed two-line
stride — `CHRONICLE_STRIDE = CHRONICLE_LINE_PX * 2` = 44px against the
measured 22px line pitch of the 14px serif body face — so one wrap never
collides with the next entry. The pool holds the 7 slots that fit the
620×500 floor's ~309px body column (7 × 44 = 308); rows past the pool are
simply not painted, newest-first preserved. Each slot: word wrap on,
`SetMaxLines(2)`, 14px body face, charcoal ink, anchored to the body column.
The body well carries only the honest empty line ("Nothing has been written
yet."); superlative pages keep the joined body text, `SetMaxLines(8)`, and
the 8-slot medallion pool unchanged. Pins: pool structure at Init (count,
stride offsets, maxLines, wrap, font, ink, hidden-at-create, source pin that
the stride is defined as two lines), `runChronicleFormats` paint block
(13 seeded rows → newest 7 painted, no medallions, empty body well),
`runChronicleGeometry` (9 rows → 7 painted, newest-first, no medallions).
Render check: `records.json` shows slots at 0/−44/−88/−132/−176 with a
wrapped victor line not touching the next entry.

### 3. Minor — Home paint perf

`paint(pages)` now builds pages only on records leaves; the Home branch never
calls `buildPages`. Pin: `runHomePaintPerf` spies `Store.Snapshot` —
`ShowHome` takes exactly 1 Snapshot (was 2: nine-category walk + card model);
a records-leaf paint still walks the store. Red pre-fix (2), green after.

### 4. Minor — records_empty dump rests on the Chronicle

`tests/preview_dump.lua` `records_empty` (name kept) still proves the card's
honest empty states via `GetOverview()`, then fires the Chronicle ribbon and
rests on the leaf so "Nothing has been written yet." renders into
`records_empty.json`. Evidence: pre-fix dump had zero visible widgets with
that text; post-fix exactly one, shown. The `records` scenario now reads the
entry slot pool instead of the body well for its chronicle asserts.

### 5. Minor — dropped retained-behavior pins restored

Ported to the new suite shape: U-Q leftover-offset source pins (`, 6)`,
`, 6,`, `, 10)`, `, 10,` all absent — surfaces read Theme.Space); create-time
`applyInk(pageTitle, "oxblood")` present and `applyInk(frame.PageTitle,
"charcoal")` absent in `buildFrame`; `("display", 20)` absent from `paint`;
the Greatest Rivalry leaf paint pin (walk Next to the leaf, body paints
roman "II", never raw "2").

### 6. Minor — brittle class-color pin

The Home card name-color pin now compares r/g/b against
`COB.Theme:ClassColor("WARRIOR")` instead of a hardcoded 0.78.

### 7. Minor — held-only walk strengthened

`runUnheldMidOrderSkip`: no elevations → Most Successful Defenses unheld
while canonical neighbors (Longest Streak, The Iron Chin) are held. A full
Next walk never lands on it, and from Longest Streak one Next hop lands
directly on The Iron Chin.

### 8. Adjudication — unknown-type attribution rule

Unknown future ceremony types now name a participant only when **exactly
one** of character/human resolution succeeds for that id; both (an id
collision across the two 1..n sequences) or neither → no name, and a row
with no names renders the type token alone. Recognition keeps its defined
character-then-human positional routing. The old pin enshrining
"Canonization: Chuckroast." for a human-scoped id is replaced:
`runChronicleFormats` now pins the colliding id rendering "Canonization.",
and `runUnknownTypeAttribution` pins all four cases (both → token alone,
character-only → named, neither → token alone, human-only → named) plus a
mixed row where the ambiguous id contributes nothing.

### Test evidence (exact commands)

| Command | Result |
|---|---|
| `lua tests/test_records.lua` (pins vs unfixed build, TDD red) | 840 passed, **39 failed** — every failure on a new pin |
| `lua tests/test_records.lua` (fixed build) | **950 passed, 0 failed** |
| `lua tests/run.lua` (full harness) | **15905 passed, 0 failed**, exit 0 |
| `COB_PREVIEW_DIR=$(mktemp -d) lua tests/preview_dump.lua` | 13 scenarios, exit 0; `records_empty.json` contains the visible empty Chronicle line |
| `COB_PREVIEW_DIR=<dump> python3 scripts/render-preview.py` | `records.png` / `records_empty.png` render the fixed-stride ledger cleanly (temp dirs only; committed renders untouched) |

Suite delta 783 → 950 assertions (+167); harness delta 15738 → 15905
matches. No in-game smoke from this wave — per `verification.mdc`, `/reload`
+ `/beef` client smoke remains a human/client pass. POLISH:CANDIDATE at most.
