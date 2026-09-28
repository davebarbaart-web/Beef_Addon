# Stale render inventory — `docs/design/renders/responsive/`

**100-point item 97.** Wave 7–8 is parked until first-night lands. This file is the inventory only: no PNG regen, no ImageGen, no Lua edits.

Item 97 (Wave 8): regenerate this tree from current `tests/preview_dump.lua`; **delete** stale `dashboard` / `dock`; **add** `card` / `card_empty`.

Evidence is the sibling `.json` scene graph (widget `name` / `text`). Each PNG is treated as the same scene. All three size folders carry the same retired chrome; only `screen` width/height changes.

**Sizes:** `compact_800x600/` · `stream_1024x768/` · `widescreen_1920x1080/`

---

## Current `preview_dump.lua` vs this tree

| Scenario in dump today | On-disk stem | Notes |
|------------------------|--------------|--------|
| `decree`, `proclaim_*`, `fightercard`, `hud`, `console`, `minimap` | present | Not in the retired-product list below |
| `event_inputs` | present, **stale** | Dump still has the scenario; JSON is the old 3-verb strip |
| `records`, `records_empty` | present, **stale** | Dump still has the scenarios; JSON is the Home-tabbed book |
| `card`, `card_empty` | **absent** | Dump has them; item 97 says add on regen |
| — | `dashboard`, `dock` | **Orphans.** Dump no longer has these names |

`summary.json` still claims 14 scenarios per size. That count is the old set (`dashboard` + `dock`, no player card). Live dump is still 14 names, but the pair is now `card` + `card_empty` instead of `dashboard` + `dock`.

---

## Delete — scenario gone from `preview_dump.lua`

Retired product. Do not regenerate these stems.

### `dashboard` — Records Home spread (not a separate dashboard frame)

| Path | Why stale | Dump still has it? |
|------|-----------|--------------------|
| `compact_800x600/dashboard.json` | `scenario":"dashboard"`. Frame `ChurchOfBeefRecordsBook`. Paints **Church Overview** / **Your Place**, roster/gora/moments tiles, identity + Decree on the book, ribbon tabs **HOME / RECORDS / RIVALRIES / MARTYRS**. That Home spread is retired (`RecordsBook.ShowHome` is nil; `/beef` is the player card). | **No** |
| `compact_800x600/dashboard.png` | Same scene. | **No** |
| `stream_1024x768/dashboard.json` | Same widgets as compact. | **No** |
| `stream_1024x768/dashboard.png` | Same scene. | **No** |
| `widescreen_1920x1080/dashboard.json` | Same widgets as compact. | **No** |
| `widescreen_1920x1080/dashboard.png` | Same scene. | **No** |

**Recommend: delete** all six. Item 97 names this stem. Identity/Decree now live on `card` / `card_empty`.

### `dock` — retired `ConsoleDock`

| Path | Why stale | Dump still has it? |
|------|-----------|--------------------|
| `compact_800x600/dock.json` | `scenario":"dock"`. Frame **`ChurchOfBeefConsoleDock`**. Title **DIRECTOR CONSOLE**, **Expand** + iron **SANCTION**. `UI/ConsoleDock.lua` is deleted. | **No** |
| `compact_800x600/dock.png` | Same scene. | **No** |
| `stream_1024x768/dock.json` | Same widgets as compact. | **No** |
| `stream_1024x768/dock.png` | Same scene. | **No** |
| `widescreen_1920x1080/dock.json` | Same widgets as compact. | **No** |
| `widescreen_1920x1080/dock.png` | Same scene. | **No** |

**Recommend: delete** all six. Item 97 names this stem. Live Pope desk is `console` (`ChurchOfBeefConsoleFrame`).

---

## Regenerate — dump still has the scenario; on-disk JSON is old product

Do not delete the stem. When Wave 8 runs, overwrite from current `preview_dump.lua`.

### Records Home spread (still named `records` / `records_empty`)

Live book is Chronicle-first: no Home tab, no **Your Record** / identity / Decree leaf (`tests/test_records.lua`). On-disk dumps are the tabbed Home-era book.

| Path | Why stale | Dump still has it? |
|------|-----------|--------------------|
| `compact_800x600/records.json` | Ribbon **HOME / RECORDS / RIVALRIES / MARTYRS**. Left leaf **Most Sanctioned Victories**; right leaf **Your Record**. Not Chronicle-first. | **Yes** (`records`) |
| `compact_800x600/records.png` | Same scene. | **Yes** |
| `stream_1024x768/records.json` | Same Home-era chrome. | **Yes** |
| `stream_1024x768/records.png` | Same scene. | **Yes** |
| `widescreen_1920x1080/records.json` | Same Home-era chrome. | **Yes** |
| `widescreen_1920x1080/records.png` | Same scene. | **Yes** |
| `compact_800x600/records_empty.json` | Same HOME/RIVALRIES/MARTYRS tabs + **Your Record**. Empty line is “No entries recorded.” on the old victories leaf — not “Nothing has been written yet.” on Chronicle. | **Yes** (`records_empty`) |
| `compact_800x600/records_empty.png` | Same scene. | **Yes** |
| `stream_1024x768/records_empty.json` | Same Home-era chrome. | **Yes** |
| `stream_1024x768/records_empty.png` | Same scene. | **Yes** |
| `widescreen_1920x1080/records_empty.json` | Same Home-era chrome. | **Yes** |
| `widescreen_1920x1080/records_empty.png` | Same scene. | **Yes** |

**Recommend: regenerate** (12 files). Current dump asserts Chronicle first / empty Chronicle line.

### `EVENT INPUT` label (and the old 3-verb strip)

| Path | Why stale | Dump still has it? |
|------|-----------|--------------------|
| `compact_800x600/event_inputs.json` | Header text **`EVENT INPUT`**. Also paints retired **Catch up**, **Confess**, and a confession EditBox. Live `Inputs.lua` is a Petition-only strip (item 31 still wants the title renamed; that is not this ticket). | **Yes** (`event_inputs`) |
| `compact_800x600/event_inputs.png` | Same scene. | **Yes** |
| `stream_1024x768/event_inputs.json` | Same **EVENT INPUT** + Catch up / Confess. | **Yes** |
| `stream_1024x768/event_inputs.png` | Same scene. | **Yes** |
| `widescreen_1920x1080/event_inputs.json` | Same **EVENT INPUT** + Catch up / Confess. | **Yes** |
| `widescreen_1920x1080/event_inputs.png` | Same scene. | **Yes** |

**Recommend: regenerate** (6 files). A dump run *today* would still show `EVENT INPUT` until item 31 lands; it would drop Catch up / Confess / the EditBox. Do not delete the stem.

---

## Composites that still show the retired tiles

These are not product surfaces. They include `dashboard` and `dock` (and the stale records / event-inputs tiles).

| Path | Why stale | Dump still has it? |
|------|-----------|--------------------|
| `responsive/contact-sheet.png` | Contact sheet of the old 14-scenario set. | N/A (compositor, not a dump scenario) |
| `compact_800x600/contact-sheet.png` | Same. | N/A |
| `stream_1024x768/contact-sheet.png` | Same. | N/A |
| `widescreen_1920x1080/contact-sheet.png` | Same. | N/A |
| `responsive/summary.json` | `"scenarios": 14` for the old names. | N/A |

**Recommend: regenerate** with Wave 8 (after `dashboard`/`dock` are gone and `card`/`card_empty` exist). Do not delete the contact-sheet files.

---

## Not found under `responsive/`

| Retired product | Result |
|-----------------|--------|
| **MainFrame** | No `ChurchOfBeefMainFrame` widget, no `mainframe` stem. `console.json` is `ChurchOfBeefConsoleFrame` (live Director Console). |
| **Status** (`UI/Status.lua`) | No `ChurchOfBeefStatus` widget, no `status` stem. Console `GateStatus` is current desk chrome, not the deleted Status chip. |
| **ConsoleDock** | No live module. Only the `dock` stem above (delete). |

`UI/MainFrame.lua`, `UI/Status.lua`, and `UI/ConsoleDock.lua` are already gone from `addon/ChurchOfBeef/`.

---

## Missing on disk (item 97 add — not stale)

`preview_dump.lua` already runs `card` and `card_empty` (player card / empty card). None of the three size folders have `card.json`, `card.png`, `card_empty.json`, or `card_empty.png`.

**Recommend: generate on Wave 8 regen.** Not a delete. Not this inventory’s job.

---

## Parked action (do not do until first-night lands)

1. Delete the 12 `dashboard` / `dock` files.
2. Re-run `tests/preview_dump.lua` at the three sizes into these folders.
3. Recompose PNGs and contact sheets from the new JSON (no ImageGen).
4. Expect new `card` / `card_empty`; expect Chronicle `records` / `records_empty`; expect Petition-only `event_inputs` (title still `EVENT INPUT` until item 31).
5. Rewrite `summary.json` against the live scenario list.
