# Player Card — Tasks 4 & 5 implementation report

Date: 2026-09-13. Plan: `docs/reformation/ux-rebuild/plans/2026-09-13-player-card.md`
(Task 4: "`/beef` opens the card; the book loses its Home spread"; Task 5:
"Records Book navigation — leaf caption, edge-aware turns, two-leaf Chronicle").

Both tasks done TDD (failing assertions written and watched red, then
implementation, then green). No commits made; ledger lines appended to
`.superpowers/sdd/progress.md` per the plan's commit rule:

```
Plan Task 4: complete (harness 15802/0)
Plan Task 5: complete (harness 15872/0)
```

## Suite counts

| Point | Harness |
|---|---|
| Baseline (Tasks 1–3 landed) | 15932 passed, 0 failed |
| After Task 4 | 15802 passed, 0 failed |
| After Task 5 (final) | 15872 passed, 0 failed |

The net drop vs baseline is the retired Home-surface pin mass (below). Task 5
adds `runNavigation` and re-expands the ledger-pool coverage, recovering some.

## Final command outputs

`lua tests/run.lua` → exit 0:

```
Tests finished: 15872 passed, 0 failed
```

`COB_PREVIEW_DIR=$(mktemp -d) lua tests/preview_dump.lua` → exit 0:

```
preview_dump finished: 14 scenarios at 1024x768
```

`rg -n "ToggleHome|ShowHome|GetOverview|OverviewWidgets|HomeRibbon|ChronicleRibbon" addon/ tests/`:

```
tests/test_records.lua:477:assert_eq(Book.ShowHome, nil, "the book has no Home spread — /beef is the player card")
tests/test_records.lua:478:assert_eq(Book.ToggleHome, nil, "no ToggleHome")
tests/test_records.lua:479:assert_eq(Book.GetOverview, nil, "no overview model — identity lives on the player card")
tests/test_records.lua:482:assert_eq(rawget(Book.frame, "OverviewWidgets"), nil, "no overview widgets")
tests/test_records.lua:1083:  assert_eq(rawget(frame, "HomeRibbon"), nil, "no Home tab")
tests/test_records.lua:1084:  assert_eq(rawget(frame, "ChronicleRibbon"), nil, "no Chronicle tab — the Chronicle is leaf I")
```

Only the `== nil` retirement pins, as required.

## Per file: what changed

### `addon/ChurchOfBeef/ChurchOfBeef.lua`

- `initUi`: added the bare `COB.PlayerCard:Init()` guard after `RecordsBook`
  (order pinned as `Minimap,RecordsBook,PlayerCard,Hud,…`); comment updated to
  list PlayerCard among the bare-run modules.
- Slash handler: the fall-through block now toggles `COB.PlayerCard`
  (`card:Toggle()`) with the fallback chat line `player card not ready yet.`;
  the comment above the handler now reads "Unrecognised arguments open the
  player card."
- `InspectProgress`: the `COB.RecordsBook:Show()` block became
  `COB.PlayerCard:Show()`; both chat notes now read "Player card, Decree, and
  Director Console are open. …".

### `addon/ChurchOfBeef/UI/Minimap.lua`

- Left-click body replaced: `COB.PlayerCard:Toggle()` guarded by
  `type(card.Toggle) == "function"`; inline comment updated.
- Header comment: "Left-click always opens the player card".
- Tooltip copy: "Left-click: Church overview" → "Left-click: your card"
  (both the empty and posted-Decree tooltip branches).

### `addon/ChurchOfBeef/UI/Decree.lua`

- Book button label `"OPEN CHURCH BOOK"` → `"YOUR CARD"`; OnClick now hides the
  banner and calls `COB.PlayerCard:Show()` guarded; header comment line now
  reads "The footer opens the player card."

### `addon/ChurchOfBeef/UI/RecordsBook.lua`

Task 4:

- Deleted functions: `overviewModel`, `paintOverview`, `guildIdentity`,
  `localHonorifics`, `identityText`, `jumpHome`, `RecordsBook:ShowHome`,
  `RecordsBook:ToggleHome`, `RecordsBook:GetOverview` — plus the now-dead
  `localPlayerKey` and `guildLine` helpers (only the deleted functions called
  them).
- `buildFrame`: deleted the right-leaf identity block (`IdentityTitle`,
  `IdentityRule`, `HonorificsHeading`, `Honorifics`) and the whole overview
  block (`OverviewWidgets`/`trackOverview`/`overviewText`, guild seal, Decree
  plate/head/line/flavor, `OverviewOpenRecords`, player plate/sigil/name/class,
  and the four profile cells). Kept `rightLeaf`/`frame.RightLeaf`, `body`,
  `rule`, `pageTitle` per plan.
- `buildFrame`: deleted the `homeRibbon` creation block and
  `wireChildWheel(frame.HomeRibbon)`; `ChronicleRibbon` remained until Task 5.
- `paint(pages)`: removed `isOverview` and every branch keyed on it
  (OverviewWidgets loop, Body/HonorificsHeading/Honorifics setShown loop, the
  `paintOverview` early return, the `IdentityTitle`/`Honorifics` SetText
  calls, the `activeRibbon` loop). Pages always build; `pageIndex` clamps to
  `[1, n]` unconditionally; Prev/Next kept on the `walkable` rule (Task 5
  replaced it).
- `turn(delta)`: lower clamp `nextIndex < 1 → 1`.
- `OnSizeChanged` hook: dropped the `pageIndex == 0` repaint line.
- `RecordsBook:Show()`: added `if pageIndex < 1 then pageIndex = 1 end` before
  `paint()`.
- Header comment rewritten: the book is the Church's records behind the player
  card — Chronicle first, superlatives only when held; "Your Record"/identity
  sentences removed.

Task 5:

- Constants: `CHRONICLE_POOL = 7` → `CHRONICLE_POOL_PER_LEAF = 7` +
  `CHRONICLE_POOL = CHRONICLE_POOL_PER_LEAF * 2`; geometry comment updated.
- Deleted `jumpToChronicle`, the `homeRibbon`/`chronicleRibbon` creation
  blocks, `tabW`/`tabPitch`, and the ribbons' two `wireChildWheel` lines.
- Chronicle slot pool: 14 slots — 1–7 anchored to the left `body`, 8–14 to
  `frame.RightLeaf` (inset by `md`); added `frame.RightSeal` (160×160
  low-alpha `seal_papal` watermark, centered on the right leaf, hidden at
  creation).
- Footer: added `frame.FooterBar` (mouse-enabled Frame over the footer band),
  `frame.LeafCaption` (FontString, centered, `label` 14px, gold ink), and
  re-labeled the turn buttons: `‹ PREVIOUS` / `NEXT ›` at 112px wide.
  `wireChildWheel` now covers TitleBar, CloseButton, FooterBar, PrevButton,
  NextButton.
- `paint(pages)`: visibility is edge-aware — `PrevButton` shown only when
  `pageIndex > 1`, `NextButton` only when `pageIndex < n`; the caption reads
  `Leaf {roman} of {roman} · {page title}`; `RightSeal` shows on superlative
  leaves only. Caption/seal lines sit after `page`/`isChronicle` are computed,
  per the plan note.
- Header comment: footer = leaf caption + edge-aware Previous/Next; Chronicle
  spans both leaves; the ribbon sentence removed.

Public API is now exactly `Init, Show, Hide, Toggle, IsShown, GetPages,
ResetForTests, toRoman` (+ `MODE`).

### `tests/test_wire_glue.lua`

- initUi block: added `PlayerCard` to the stubbed modules with save/restore;
  contract order string is now
  `Minimap,RecordsBook,PlayerCard,Hud,Console,Toasts,DecreeBanner,Sound,FighterCard,Inputs,Markers`;
  comment and assertion message updated "ten" → "eleven".
- Slash section: the `RecordsBook.ToggleHome` spy became the plan's
  `PlayerCard.Toggle` spy verbatim (`/beef`, `anything`, `petition` → 3
  toggles). The four Inputs no-touch pins kept. The not-ready fallback block
  now nils `COB.PlayerCard` and pins the `player card` fallback text (the old
  block pinned the retired "Records Book" fallback message that Step 3
  replaced).

### `tests/test_minimap.lua`

- The `RecordsBook.ToggleHome` spy became `PlayerCard.Toggle`
  (save/restore renamed accordingly); comment updated.
- The three named assertion messages: "a plain click drives
  PlayerCard:Toggle" (×2) and "after Clear, a plain click still drives
  PlayerCard:Toggle".
- Tooltip pins: "Left-click: your card" ×3 (empty / posted / cleared).
- Message-only truthfulness updates (assertions unchanged): "left-click always
  opens the player card", and the "Everything else is still just the player
  card" block messages.

### `tests/test_decree_ui.lua`

- The `bookOpens` spy moved to `COB.PlayerCard` with **both** `Show` and
  `Toggle` incrementing the counter (see deviations).
- Added `assert_eq(frame.BookButton:GetText(), "YOUR CARD", "the Decree's
  action names the card")` next to the existing BookButton pin.
- Source-contract pin: `src:find("COB.RecordsBook")` → `src:find("COB.PlayerCard")`.
- Named messages: "Church book action drives PlayerCard:Show", "left-click
  always opens the player card"; analogous message-only updates for the other
  minimap/banner assertions ("a plain click drives PlayerCard:Toggle when no
  Decree is set", "after Clear, left-click drives PlayerCard:Toggle again",
  "right-click replay does not open the player card", and the no-module block,
  which now nils `COB.PlayerCard`).
- Tooltip pins: "Left-click: your card" ×2.

### `tests/test_records.lua`

Task 4 — pins deleted under the retirement rule, listed by message:

- Surface type pins: "Records Book exposes the /beef home spread", "Records
  Book toggles the /beef home spread", "card data is inspectable without
  reading widgets".
- Init block: "right-leaf honorifics FontString exists"; "right leaf
  identifies the player-history section"; "right leaf labels honorifics";
  "Honorifics heading aligns to the inset column"; "right-page sections use
  the same inner inset as left-page entries"; "honorific values use Theme body
  role"; "honorifics use Theme charcoal on parchment"; "Home ribbon exists";
  "Home ribbon is Theme ribbon_bookmark"; "Home ribbon sits on a dark plate";
  "the card carries an Open the Records button"; "the labeled path is named";
  "Open the Records sits on a dark plate"; "the card carries a Decree plate";
  "the Decree plate is a dark ground"; "Decree line is parchment ink on the
  dark plate"; "the Decree block is labeled"; "the card keeps the papal seal
  as its focal point"; "the card keeps the Gora sigil as its player focal
  point"; "the player name sits on a dark band (class-color ground
  discipline)"; "footer has a Home tab".
- Source contract: "roster counter widget is gone", "ceremony counter widget
  is gone", "gora counter widget is gone", "moment counter widget is gone",
  "runtime state word widget is gone", "latest-ceremony row is gone",
  "latest-moment row is gone" (all `Overview*` per the rule); "the card's
  empty Decree line is honest", "the card's empty record line stays", "the
  card's unentered rank line stays", "the card's empty honorifics line stays",
  "the card names its one labeled path" (their strings left the source with
  the deleted overview model).
- `runPaintReapply`: "paint keeps honorifics charcoal"; "the card masthead
  names the Church" (and the `Book:ShowHome()` call driving it).
- Empty-store block: "empty honorifics state is explicit".
- `runHeldOnlyAndOrder`: "Previous past the Chronicle returns to the Church
  card".
- Wheel section: "wheel up past the Chronicle lands on the card", "wheel up
  clamps on the card" (plus the now-assertionless second wheel-up fire).
- Marked-moments block: "missing bind has an explicit honorific state".
- Local-honorifics block: "right leaf paints the granted honorific", "right
  leaf lists honorifics as given", "identity paint does not invent ordained
  prose", "identity paint does not invent folk hero prose", "honorific text is
  titles, not a roman count" (and the `honors` local they read).
- Unbound block: "unlinked local character has an explicit honorific state",
  "another human's honorific is not borrowed".
- Copies block: "mutating a GetOverview copy does not rewrite the card", "the
  card model copy is deep" (and the `ovMut` setup lines).
- `runHomeCard` and `runHomeCardEmpty`: both functions and their calls deleted
  wholesale — every pin inside referenced the retired Home surface
  ("ShowHome opens the Church card", "left leaf is when we gather", "right
  leaf is who I am", the Overview* paint pins, the GetOverview model pins, the
  ribbon-activation pins, the ToggleHome routing pins, "an empty Church card
  opens", and the honest-empty-state pins, among others).
- Wheel-chrome block: "HomeRibbon exists", "HomeRibbon has OnMouseWheel".
- `runHomePaintPerf` rewritten as the Chronicle-paint perf pin: `Book:Show()`
  performs at most two `Store:Snapshot` calls (actual: one — the pages walk;
  the Chronicle reads `GetCeremonyLog`, not `Snapshot`).

Task 4 — pins added (plan verbatim, placed after the Init block so `Book:Show()`
cannot redden the Init-is-hidden pins): the ten retirement pins
(`ShowHome`/`ToggleHome`/`GetOverview` nil, Show opens on the Chronicle, no
OverviewWidgets/IdentityTitle/Honorifics, no "Your Record"/"THE DECREE" in
`allText()`).

Task 5 — remaining ribbon references deleted, by message: "Chronicle ribbon
exists", "Chronicle ribbon is Theme ribbon_bookmark", "Chronicle ribbon path
is Theme ribbon_bookmark", "Chronicle ribbon sits on a dark plate", "footer
has a Chronicle tab", "Chronicle tab is wired" (runPaintReapply),
"ChronicleRibbon exists", "ChronicleRibbon has OnMouseWheel".

Task 5 — added: `runNavigation()` (plan block; two deviations below), called
after `runChronicleGeometry()`.

Task 5 — updated for the new interface (not deletions):

- Init-block pool pins: 7 → 14 slots; slots 1–7 keep the body-column anchor
  and 44px-stride pins; slots 8–14 pin the `frame.RightLeaf` anchor.
- `runChronicleFormats`: 13 seeded rows now all paint (14-slot pool);
  "the oldest seeded row paints last" and "the fourteen-slot pool holds the
  whole seeded ledger" replace the seven-slot overflow pins.
- `runChronicleGeometry`: seeds 15 rows (was 9) so the overflow coverage
  survives the larger pool: 14 paint, newest-first, row 15 off-leaf.
- All `buttonFor("PREV")` / `buttonFor("NEXT")` walk helpers became direct
  `frame.PrevButton` / `frame.NextButton` references (the buttons are
  relabeled `‹ PREVIOUS` / `NEXT ›`, so the label lookup finds nothing);
  "footer has a Previous/Next tab" pins likewise read the widgets directly.

### `tests/preview_dump.lua`

- Added `UnitClass`/`UnitLevel` stubs after `stub.install()`;
  `dofile("addon/ChurchOfBeef/UI/PlayerCard.lua")` after the RecordsBook
  dofile; `COB.PlayerCard:ResetForTests()` in `resetCores`.
- Replaced the `dashboard` scenario with the plan's `card` and `card_empty`
  scenarios verbatim (14 scenarios total).
- `records_empty`: deleted the `ShowHome()` line and the four `overview.*`
  asserts; the scenario rests on the Chronicle directly after `Show()`.
- `records` (Task 5): the `ChronicleRibbon` fire became
  `for _ = 1, 3 do stub.fire(COB.RecordsBook.frame.PrevButton, "OnClick") end`;
  the "rests on the Chronicle" assert kept.
- `records_empty` (Task 5): deleted its `ChronicleRibbon` fire line too (see
  deviations).

## Deviations from plan text, and why

1. **`runNavigation` fixture count.** The plan's block seeds 9 Knightings but
   pins `assert_eq(#painted, 10, "ten ledger rows paint across both leaves")`.
   Only `Store:AppendCeremony` writes the Chronicle log — `bout()` and
   `LinkCharacter` do not — so 9 seedings paint 9 rows. I seeded 10 Knightings
   (and updated the fixture comment to match) so every assertion line in the
   plan's block stays byte-identical. The behavioral requirement (overflow
   onto the right leaf) is unchanged.
2. **Task 5 wheel pin targets `frame.FooterBar`**, per the plan's own
   parenthetical (the caption is a FontString; the FooterBar Frame receives
   the wheel). Confirmed by the task briefing.
3. **`test_records.lua` Show source pin refined, not deleted.** The old pin
   forbade any `pageIndex` mention inside `RecordsBook:Show()`, which the
   plan's Step 3.6 (`if pageIndex < 1 then pageIndex = 1 end` in Show)
   necessarily violates. The pin now caps Show at exactly the clamp's two
   `pageIndex` mentions (`gsub` count == 2), keeping the "Show does not reset
   pageIndex" guard; the property also remains pinned behaviorally in
   `runRemountBehavior` ("Show does not reset pageIndex" × 2).
4. **Clamp-target pins added where retired asserts were deleted.** The wheel
   section and `runHeldOnlyAndOrder` lost their "The Gathering" terminal
   asserts under the rule; both walks now assert the new clamp target
   ("wheel up past the first leaf clamps on the Chronicle" / "Previous past
   the first leaf clamps on the Chronicle") so no walk is left without a
   terminal behavioral assertion. The assertionless second wheel-up fire was
   dropped.
5. **Honorifics anti-borrow coverage moved to `allText()`.** The deleted
   `frame.Honorifics` pins ("another human's honorific is not borrowed" etc.)
   were replaced with whole-book absence pins ("granted honorifics never paint
   in the book", "another human's honorific never paints in the book") —
   stronger in scope, and they fail pre-implementation (verified in the red
   run).
6. **`test_decree_ui.lua` spy carries `Show` and `Toggle`.** The plan moves
   the `bookOpens` spy to `COB.PlayerCard.Show`, but the same spy also serves
   the suite's minimap left-click pins, and the minimap drives
   `PlayerCard:Toggle`. A Show-only spy would leave those pins unreadable
   (0 opens). Both methods increment the same counter; the plan's two named
   messages are used verbatim.
7. **Fallback block in `test_wire_glue.lua` adapted.** The plan's slash
   snippet ends at the toggle assertions; the pre-existing not-ready fallback
   block pinned the old "Records Book not ready yet" message that Step 3
   replaces, so it now nils `COB.PlayerCard` and pins "player card". The four
   Inputs no-touch pins were kept (they reference no retired symbol).
8. **`records_empty` lost its `ChronicleRibbon` fire in Task 5.** The plan's
   Files line names only the `records` scenario, but `records_empty` also
   fired the deleted ribbon; left in place it would error on a nil widget.
   The two "rests on the Chronicle" asserts are kept.
9. **Message-only truthfulness updates** in `test_minimap.lua` /
   `test_decree_ui.lua` beyond the named messages (e.g. "bare /beef toggles
   the player card", section comments). Assertions unchanged.
10. **`dressRibbon` kept, now unused.** Task 5 Step 3.2 deletes the ribbon
    creation blocks but not the helper; deleting it would also retire the
    `ribbon_bookmark` source pin, which the plan does not sanction. Flagged as
    a follow-up candidate for Task 6's honesty pass.
11. **File-header comments** in `tests/test_records.lua` and
    `RecordsBook.lua` updated to stop describing the retired Home spread
    (Task 4 Step 7 / Task 5 Step 6 cover the source header; the test header
    described the same retired surface).

## Red-run evidence

Task 4 red run (before implementation) failed with, among others: the eight
retirement pins ("the book has no Home spread …", "no overview widgets", …),
"Show does not reset pageIndex expected 2 got 0" (the refined pin, red until
the clamp landed), both clamp pins ("expected Chronicle got The Gathering"),
"the Decree's action names the card expected YOUR CARD got OPEN CHURCH BOOK",
"/beef toggles the player card expected 1 got 0", the tooltip pins, and the
initUi order pin; exit 1.

Task 5 red run (before implementation): "the pool holds the two-line entries
that fit both leaves expected 14 got 7", the chronicle paint-count pins,
"no Chronicle tab — the Chronicle is leaf I expected nil got table", and the
strict-stub abort on `frame.LeafCaption` ("does not exist on a TBC Classic
2.5.x Frame" — the plan's "footer carries a leaf caption" pin); exit 1.

## Not done / follow-ups

- In-game `/reload` smoke is a separate human pass (POLISH:CANDIDATE at most
  from the harness).
- `dressRibbon` is dead code after Task 5; retire it together with the
  `ribbon_bookmark` source pin when the plan sanctions it.
