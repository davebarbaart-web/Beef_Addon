# B4-D — Console petition H2H + confession inbox

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Gora, Confession source, BeefNet, Toasts, Hud. Do not commit. Console stays **plain / stock forever**. No custom media. No Notebook persist (`SaveNote` stays nil). No WHISPER ALL. No slash.

## Law

Bible §10.2, §10.5, §18.1–18.2, §9. Batch 3 critique: restore head-to-head on petitioner cards; SKIP/Dismiss is furniture, not a sacred iron plate.

1. **Petition line** — keep Store names. When `Store:GetCharacter(petitioner).gora.headToHeads` has a row for `namedOpponentId`, append a mute numeric H2H (`1-0`), no prose (`meeting`, `demanded`, `odds`). No named opponent → name only (existing).
2. **Confession inbox** — stock list on the desk (small scroll or fontstring). `Console:GetConfessions()` returns `Confession:GetQueue()` copies when the module exists, else `{}`. Paint **name + text** here only (Pope console). Never send confession text to Toasts / HUD / Decree / Net.
3. **Dismiss** — create with the existing `stockButton` helper (UIPanelButtonTemplate), not `ritual`. Label stays `Dismiss`. Behavior unchanged (`Gora:Dismiss`).
4. Do not add WHISPER ALL, SUMMON, clipboard, or Notebook persist.

Keep Proposed Bout, Sanction, favor pane, Post Decree, FREE RULING, MARK THIS MOMENT.

## Tests

Extend `tests/test_console.lua`. Pin H2H on a named petition when Store has history. Pin GetConfessions empty without module; with a stubbed queue, paint includes the text. Dismiss still reaches Gora. `SaveNote` still nil. Source must not contain `WHISPER ALL`. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B4-D-console-inbox-report.md` + diff.
