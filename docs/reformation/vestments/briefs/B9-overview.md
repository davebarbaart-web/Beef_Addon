# Batch 9 — Ceremony log + HUD persist + victor copy

**Cited:** Bible §10.7, §18.1, §18.2; Law 4. CONTINUE: no SUMMON, no post-show clipboard, no custom media, `SaveNote` nil. Ceremony log is type + ids + optional Pope text — never generated narration.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B9-A | `Core/Knighting.lua`, `tests/test_knighting.lua` | Type-only ceremony append |
| B9-B | `Core/Gora.lua`, `tests/test_gora.lua` | Type-only ceremony append on rulings |
| B9-C | `UI/Console.lua`, `tests/test_console.lua` | Stock ceremony-log desk |
| B9-D | `UI/Toasts.lua`, `tests/test_ui.lua` | Victor clerical close |
| B9-E | `UI/Hud.lua`, `tests/test_hud.lua` | Persist through verdict |
