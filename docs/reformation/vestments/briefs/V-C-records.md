# V-C — Records Book tome dress (stock textures only)

**Exclusive files:**
- `addon/ChurchOfBeef/UI/RecordsBook.lua`
- `tests/test_records.lua`

**Do not edit** Console, Decree, Toasts, HUD, Store, TOC, bootstrap, OPEN_QUESTIONS, REFORMATION_LOG.

**Do not commit.** No custom media. Drop required `Media\\RecordsTitle.ttf` / `Media\\records-seal` (they do not exist) — stock fallback only.

## Law

Bible §10.9, §14.2, §19.3. Batch 2 §E. Law 1 (not a ladder). Law 4 (addon never generates prose).

OPEN_QUESTIONS **#3** (Records categories) stays parked: **do not add, rename, or delete** `PAGE_TITLES`. Navigation may jump among the existing nine pages.

## Dress

Player-opened Quiet window. Movable. World visible. About **70% of `UIParent` height** (cap if parent height unknown: ~480). Two-page-ish spread: stock parchment (`Interface\\QuestFrame\\QuestBG` or stationery) + iron/gold `WHITE8X8` rules. `Fonts\\MORPHEUS.TTF` or `FRIZQT__.TTF` for the page title via `pcall`; `GameFont*` fallback.

Ribbon bookmarks: four stock buttons or fontstrings that jump to an existing page (e.g. Victories → Most Sanctioned Victories, Rivalries → Greatest Rivalry, Martyrs → The Glorious Martyr, Cowardice → keep using an existing title — **do not invent a Cowardice superlative page**). If a fourth landing page is unclear, three ribbons + prev/next is enough. Label them clerically. Prev/next page-turn stays.

## Counts = roman numerals on theatrical text

Add a helper `toRoman(n)` for positive integers (1–3999). Body lines that today print `%d` for wins/streak/defenses/losses/rivalry scores paint the count in roman (e.g. `Highbeef — XIV`). GetPages **data** may still carry arabic integers (tests pin numbers). Only the painted body / a `displayCount` string uses roman.

## No generated prose

Do not add epithets, scripture, or “his victories are ordained.” Entries stay `title + holder + optional human citation` if a citation field already exists on the row — do not invent a citation generator. Famous Upsets stay `Name over Opponent`.

Quiet: no sound. Not a sortable ladder. No search box.

## Tests

Keep: nine Bible titles; Tournament Champions empty; GetPages copies; Show/Hide do not write Store; no slash.

Add: `toRoman(14) == "XIV"` (or the public helper you choose); painted body for Most Sanctioned Victories contains roman, not a raw `14` if you can read the FontString; source grep has no `ordained` / `This is not hatred`; no required `Media\\` path. Isolation under `if standalone then`.

## Verify

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_records.lua
```

Must exit 0. Report `docs/reformation/vestments/briefs/V-C-records-report.md` + `V-C-records.diff`. **POLISH:CANDIDATE** at most.
