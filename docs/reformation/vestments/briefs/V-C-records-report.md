# V-C — Records Book tome dress (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** CONTINUE 2026-08-18 license 4 (stock textures/fonts only); Bible §10.9, §14.2, §19.3; Batch 2 critique §E; brief `docs/reformation/vestments/briefs/V-C-records.md`.

Player-opened Quiet tome. Stock parchment spread, roman painted counts, three clerical ribbons that jump among existing Bible pages. GetPages stays arabic. No generated prose. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_records.lua` | TDD first. Source grep (no `Media\\`, no `ordained` / `This is not hatred`). Height cap 480. `toRoman(14) == "XIV"`. Painted victories show XIV not `14`. Ribbons jump to existing titles. Isolation stays under `if standalone then`. |
| `addon/ChurchOfBeef/UI/RecordsBook.lua` | Dropped required Media font/seal paths. Stock QuestBG leaves + WHITE8X8 iron/gold. `toRoman` 1–3999. Painted counts roman. Three ribbons + prev/next. Height 70% of `UIParent` or 480. |
| `docs/reformation/vestments/briefs/V-C-records-report.md` | This file |
| `docs/reformation/vestments/briefs/V-C-records.diff` | `git diff -- addon/ChurchOfBeef/UI/RecordsBook.lua tests/test_records.lua` |

Did not edit Console, Decree, Toasts, HUD, Store, TOC, bootstrap, OPEN_QUESTIONS, REFORMATION_LOG. Did not add Media files. Did not add, rename, or delete `PAGE_TITLES`.

## Contract

### Dress

- Quiet, movable, clamped, world visible (DIALOG, no screen dim). No sound. No search. Not a ladder.
- Height: `floor(UIParent:GetHeight() * 0.7 + 0.5)` when parent height is a positive number; else **480**.
- Two-page-ish spread: left `Parchment` + `RightLeaf` via `pcall` `SetTexture` `Interface\QuestFrame\QuestBG`; fill fallback. Iron field + gold edge + gutter + title rule via `WHITE8X8` tints.
- Page title: `Fonts\MORPHEUS.TTF` then `Fonts\FRIZQT__.TTF` via `pcall` `SetFont`, then `GameFont*`.
- Seal: stock `Interface\Buttons\UI-Quickslot2`, gold-tinted. No required addon Media path.

### Counts

| Surface | Form |
|---------|------|
| `RecordsBook.toRoman(n)` | Positive integers 1–3999. `14` → `XIV`. Else `""`. |
| Painted body | Wins / streak / fought / losses / rivalry scores as roman (`Highbeef — XIV`). |
| `GetPages` | Arabic integers unchanged. Tests still pin `wins == 14`. |

Famous Upsets stay `Name over Opponent`. Optional `citation` on a row is painted only if the field is already a non-empty string — no citation generator.

### Ribbons

Three clerical buttons. Jump only to an existing `PAGE_TITLES` entry.

| Ribbon | Lands on |
|--------|----------|
| Victories | Most Sanctioned Victories |
| Rivalries | Greatest Rivalry |
| Martyrs | The Glorious Martyr |

No Cowardice ribbon (fourth landing page is unclear; prev/next stay). Prev/next still turn leaves.

## TDD

1. Extended `test_records.lua` first (source grep, height, `toRoman`, painted XIV, ribbons). Isolation unchanged.
2. Red: Media paths present; no QuestBG/MORPHEUS; height 400; `toRoman` nil; body printed `14`; ribbons missing.
3. Implemented `RecordsBook.lua`.
4. Green: `lua tests/test_records.lua` — **286 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_records.lua   # 286 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_records.lua` standalone | 286 passed, 0 failed. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive files only. Nine Bible titles unchanged. Tournament Champions stays empty. Show/Hide still do not write Store. No slash.
- Source has no `Media\\`, no `ordained`, no `This is not hatred`, no `PlaySound`.
- Ribbons refuse unknown titles (`jumpToTitle` no-ops).
- Quiet: no sound, no search EditBox, no Sort / Ladder chrome.

## Concerns

- **No client smoke.** Stock QuestBG on two leaves plus `UI-Quickslot2` as a seal may read as quest-log chrome, not a tome. **POLISH:CANDIDATE** only.
- **Height is sampled once** at first `Init` (idempotent). Later `UIParent` size changes do not resize the book.
- **Cowardice ribbon omitted.** Brief allowed three ribbons when the fourth landing page is unclear. Did not invent a Cowardice superlative page.
- **Right leaf is empty dress.** Superlative body sits on the left page only. Batch 2 facing-spread (rivalry portraits, medallions) is not in this stock-only lane.
- `toRoman(0)` and out-of-range values return `""` (brief named 1–3999 only).

## Status

**DONE_WITH_CONCERNS.** Not signed. **POLISH:CANDIDATE.**
