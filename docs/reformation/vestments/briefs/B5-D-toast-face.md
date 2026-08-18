# B5-D — Theater toast display face

**Exclusive:** `addon/ChurchOfBeef/UI/Toasts.lua`, `tests/test_ui.lua`

**Do not edit** Sound.lua, Console, Hud. Do not commit. Stock fonts only. No new cue names. No SendChatMessage.

## Law

Bible §19.3. Batch 4 critique: one display face for proclamation headlines. Stock path `Fonts\\MORPHEUS.ttf` (FrameXML lowercase) via `pcall` `SetFont` on the **headline** FontString of Proclaim overlays. Fallback remains the existing GameFont/template. Body stays serif/`GameFont*`.

Do not change clerical copy (`RISE, BEEF KNIGHT`, `A Beef Gora is Sanctioned`, `Victor declared:`, etc.). Quiet still refuses. Dim ≤ 0.5. No close button.

If the stub SetFont is a no-op, tests may source-pin `MORPHEUS` and soft-pin the path.

## Tests

`lua tests/test_ui.lua` exit 0. Keep B3-A kind pins and Sound:Play name pins (not PlaySound string). Isolation wrap stays.

Report `docs/reformation/vestments/briefs/B5-D-toast-face-report.md` + diff. POLISH:CANDIDATE.
