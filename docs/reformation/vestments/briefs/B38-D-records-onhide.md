# B38-D — RecordsBook Hide remounts missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

**Do not edit** glue, MainFrame. Do not commit. No Records remap. No `PlaySound`. pageIndex persist stays.

## Law

Wiki: ESC closes a **named** frame on `UISpecialFrames`. `FRAME_NAME` is `ChurchOfBeefRecordsBook`. Hide (~854–859) remounts `rememberSpecial` then `frame:Hide()`. ESC / `CloseSpecialWindows` bypass `RecordsBook:Hide` and there is no OnHide, so a wiped list stays idle until Show / Init.

Extract `wireBookOnHide` (never replace an existing script). Existing-frame Hide: remount missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `frame:Hide()`. OnHide remounts `rememberSpecial` so ESC still re-lists. Do **not** reset `pageIndex`. No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`.

## Tests

Nest after `runB31D()` inside `runB25C()`. Source pin: Hide remounts OnHide before `frame:Hide()`. Wipe list, nil OnHide, Show, Hide: OnHide restored, `ChurchOfBeefRecordsBook` re-listed once, pageIndex unchanged, no sound. Third Hide does not replace OnHide. Isolation wrap stays.

`lua tests/test_records.lua` exit 0.

Report `docs/reformation/vestments/briefs/B38-D-records-onhide-report.md` + diff.
