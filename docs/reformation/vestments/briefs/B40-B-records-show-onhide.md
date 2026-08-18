# B40-B — RecordsBook Show remounts missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

**Do not edit** glue, MainFrame. Do not commit. No Records remap. No `PlaySound`. pageIndex persist stays.

## Law

Wiki: ESC via `UISpecialFrames`. `FRAME_NAME` is `ChurchOfBeefRecordsBook`. Hide remounts missing OnHide (B38-D). Show skips `wireBookOnHide`, so a niled OnHide stays idle until Hide. B38-D source pin currently forbids `wireBookOnHide` in Show — update that keep-string in this exclusive test file.

Existing-frame Show: remount missing OnHide (`wireBookOnHide`), then `rememberSpecial` if you already remount it, then paint / `frame:Show()`. Never replace an existing script. Do **not** reset `pageIndex`. No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`.

## Tests

Nest `runB40B()` after `runB38D()` inside `runB25C()`. Wipe list, nil OnHide, Show: OnHide restored, `ChurchOfBeefRecordsBook` re-listed once, pageIndex unchanged, no sound. Third Show does not replace OnHide. Isolation wrap stays.

`lua tests/test_records.lua` exit 0.

Report `docs/reformation/vestments/briefs/B40-B-records-show-onhide-report.md` + diff.
