# Slash Commands vs GUI Options

**Last updated:** 2026-07-25

---

## 1. Ecosystem convention

Well-behaved Classic addons expose a **short slash command** as the primary keyboard entry. The dominant convention (documented in Ace tutorials and mirrored everywhere):

- **Empty / whitespace input → open GUI** (Blizzard options category or custom frame)
- **Non-empty input → parse as CLI** (subcommands or AceConfigCmd path)

Canonical tutorial pattern from [Ace3 for Dummies](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies):

```text
/wh          → opens WelcomeHome options (Settings.OpenToCategory)
/wh <msg>    → handled as chat command body
```

[Ace3 Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started) notes you can either hand-code `RegisterChatCommand` handlers or let AceConfig generate slash parsing from the options table via `RegisterOptionsTable(..., { "myslash", "myslashtwo" })` — slash names **without** a leading `/`.

Community comment on the AceConfig API: when using AceConfigCmd, slash tokens should not include the leading slash ([AceConfig-3.0 API page comments](https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0)).

---

## 2. Slash vs GUI: one source of truth

When options are declared once (AceConfig table or equivalent handlers):

- GUI widgets and slash parser call the same `get` / `set`
- Changing a toggle in GUI and via `/addon option on` stay consistent
- AceConfigCmd walks the options tree for path matching ([deep research](.raw/onboarding-settings-ux-deep.md); framework behavior from [Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started))

Without Ace, the same product rule applies: **do not maintain two settings systems.**

---

## 3. Discoverability stack (minimum viable)

| Layer | Role | Ace / common API |
|-------|------|------------------|
| Slash | Keyboard power users + streamers typing live | `RegisterChatCommand` / AceConfig slash list |
| Minimap | Visual discoverability | LibDBIcon (see [minimap-vs-libdbicon.md](minimap-vs-libdbicon.md)) |
| Blizzard AddOns panel | ESC → Options path players expect | `AceConfigDialog:AddToBlizOptions` ([API](https://www.wowace.com/projects/ace3/pages/api/ace-config-dialog-3-0)) |
| Custom main frame | Product surface (ladder, not just prefs) | Own `CreateFrame` UI |

AceConfigDialog methods that matter for settings UX ([AceConfigDialog-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-config-dialog-3-0)):

| Method | Use |
|--------|-----|
| `AddToBlizOptions(appName, name, parent, ...)` | Register under Interface Options / Settings tree |
| `Open(appName [, path…])` | Standalone AceGUI options window |
| `SelectGroup(appName, …)` | Deep-link a subgroup |
| `SetDefaultSize` | Remember sane default window size |

Retail tutorial uses `Settings.OpenToCategory` for empty slash ([Ace3 for Dummies](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies)); Classic Anniversary may still use the older Interface Options open APIs — isolate this behind a small helper when Beef adds Bliz options later.

---

## 4. Exemplar command surfaces (*ecosystem observation* + primary where noted)

| Addon | Slash | Notes |
|-------|-------|-------|
| Questie | `/questie`, `/questie journey` | Config via shift+left minimap or `/questie`; Journey/search via `/questie journey` ([Questie README](https://github.com/Questie/Questie)) |
| ElvUI | `/ec`, `/elvui` | Config; community guides use `/ec` → Profiles for import/export |
| WeakAuras | `/wa` | Custom editor; import/export culture around share strings |
| TomTom | `/way`, options slash | Action-oriented slash (`/way x y`) separate from settings |
| Church of Beef (spec) | `/beef` | Opens **main product frame**, not only options ([spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |

---

## 5. Help / usage text patterns

| Pattern | Where | Steal for Beef |
|---------|-------|----------------|
| `usage` field on Ace options | Shown in CLI help ([options tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables)) | `/beef help` prints short command card |
| `desc` tooltips | GUI hover help | Officer actions need plain-language `desc` |
| Subcommand list on unknown input | Chat print | Unknown → print help, do not silent-fail |
| Alias short + long | `/wh` + `/welcomehome` ([wiki](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies)) | Optional `/churchofbeef` alias later |

Suggested V1 slash family (design-facing, not implementation):

```text
/beef              → toggle/open main frame
/beef help         → one-screen command list
/beef standing     → focus My Standing (later)
/beef officer      → focus Officer tab if Officer+ (later)
```

Keep V1 tiny: **open frame + help** is enough.

---

## 6. Church of Beef relevance

- Spec already treats `/beef` as the ladder UI entry — align with empty-input → **product GUI**, not a hidden options-only panel.
- Prefer **GUI for ceremony/Gora/officer actions**; slash for open/help/deep-link.
- Destructive officer actions (demote, wipe standing, Prophet bestowal) should require **GUI confirm**, not a bare slash (Ace `confirm` pattern — [options tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables)).
- Chat announces on promotion are product, not settings — but officer **opt-out** belongs in a small Settings group when settings exist (spec §10).

---

## Sources

- [Ace3 Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started)
- [Ace3 for Dummies — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies)
- [AceConfig-3.0 API](https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0)
- [AceConfigDialog-3.0 API](https://www.wowace.com/projects/ace3/pages/api/ace-config-dialog-3-0)
- [AceConfig-3.0 Options Tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables)
- [Questie README](https://github.com/Questie/Questie)
- Design spec §10
