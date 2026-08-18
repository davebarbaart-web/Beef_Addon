# B41-B — RecordsBook Init remounts missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

**Do not edit** glue, MainFrame. Do not commit. No Records remap. No `PlaySound`. pageIndex persist stays.

## Law

Wiki: ESC via `UISpecialFrames`. `FRAME_NAME` is `ChurchOfBeefRecordsBook`. Hide remounts missing OnHide (B38-D). Show remounts it (B40-B). Existing-frame Init remounts `rememberSpecial` but skips `wireBookOnHide`. B38-D / B40-B source pins currently forbid `wireBookOnHide` in Init — update those keep-strings in this exclusive test file.

Existing-frame Init: remount missing OnHide (`wireBookOnHide`), then `rememberSpecial(FRAME_NAME)`. Never replace an existing script. Do **not** reset `pageIndex`. No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`.

## Tests

Nest `runB41B()` after `runB40B()` inside `runB25C()`. Wipe list, nil OnHide, Init: OnHide restored, `ChurchOfBeefRecordsBook` re-listed once, pageIndex unchanged, no sound. Third Init does not replace OnHide. Isolation wrap stays.

`lua tests/test_records.lua` exit 0.

Report `docs/reformation/vestments/briefs/B41-B-records-init-onhide-report.md` + diff.
