# AceConfig Layouts and Options UI Conventions

**Last updated:** 2026-07-25

V1 Church of Beef may ship plain Classic frames ([library note on Ace](../04-ace3-and-libraries.md)). This doc captures AceConfig layout norms so Beef can either adopt Ace later or **copy the information architecture** without the library.

---

## 1. Core model

Authors declare a **declarative options table**; AceConfigDialog / AceConfigCmd / Blizzard panel generate UI ([Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started); [Options Tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables)).

Root shape:

- `type = "group"`
- `name`, optional `handler`
- `args = { key = { type = … }, … }`

Registration:

```text
AceConfig:RegisterOptionsTable(appName, options [, slashList])
AceConfigDialog:AddToBlizOptions(appName, displayName [, parent][, path…])
```

([AceConfig-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-config-3-0), [AceConfigDialog-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-config-dialog-3-0))

---

## 2. Widget types (cheat sheet)

From [Options Tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables):

| Type | Typical use |
|------|-------------|
| `toggle` | Boolean prefs |
| `range` | Sliders (scale, density) |
| `input` | Text fields |
| `select` / `multiselect` | Enums / multi-pick |
| `execute` | Buttons (Reset, Open UI, Export) |
| `color` | Color pickers |
| `keybind` | Hotkeys |
| `header` / `description` | Section labels / help prose |
| `group` | Nested tabs / pages |

---

## 3. Layout and progressive-disclosure fields

Common parameters ([Options Tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables)):

| Field | Effect |
|-------|--------|
| `order` | Sort (default 100; `0` first; `-1` last) |
| `desc` | Tooltip / help; `descStyle = "inline"` for toggle inline help |
| `width` | `full`, `double`, `half`, number |
| `disabled` / `hidden` | Gate controls (bool or function) |
| `guiHidden` / `dialogHidden` / `cmdHidden` | Hide from GUI, dialog, or CLI only |
| `confirm` / `confirmText` | Confirm before set/execute |
| `validate` | Reject bad input |

Inheritance: `set`, `get`, `func`, `confirm`, `validate`, `disabled`, `hidden` inherit down the group tree unless overridden ([Options Tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables)).

**Layout practice used across addons:**

1. Top-level groups = product areas (General, Announcements, Officer, Profiles).
2. Low `order` = daily-use toggles; bury rare knobs.
3. `hidden` functions hide Officer-only groups for non-officers (mirrors Beef Officer tab visibility).
4. Destructive `execute` always `confirm = true`.

---

## 4. Where options live: Bliz panel vs standalone dialog

| Surface | API | Pros | Cons |
|---------|-----|------|------|
| Blizzard AddOns / Settings | `AddToBlizOptions` | Discoverable via ESC; familiar | Classic options UI is cramped |
| Ace standalone dialog | `Open(appName)` | Larger; path select | Extra window chrome |
| Custom product frame | Own UI | Best for ladder/theater | Must not duplicate every setting |

WeakAuras is the cautionary tale: when options outgrow AceConfig’s row-of-rows model, ship a **custom editor** (*ecosystem observation* from [deep research](.raw/onboarding-settings-ux-deep.md)). Church of Beef’s ladder/officer queue already needs a custom frame — keep **prefs** shallow so AceConfig (or a tiny Settings tab) stays readable.

---

## 5. Profiles group embedding

Standard one-liner ([Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started)):

```text
options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(db)
```

Or register Profiles as a **child Bliz page** under the addon root ([Ace3 for Dummies](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies)). App names for `RegisterOptionsTable` must be **unique across addons** (WowAce comment on reusing `"Profiles"` as appName — [AceConfigDialog comments](https://www.wowace.com/projects/ace3/pages/api/ace-config-dialog-3-0)).

Details: [profiles-import-export.md](profiles-import-export.md).

---

## 6. Church of Beef relevance

| V1 (plain frames) | Steal without Ace |
|-------------------|-------------------|
| Tabs: Ladder / My Standing / Officer | Matches Ace “top-level groups” IA |
| Few prefs | Announce opt-out, hide minimap, maybe toast mute |
| Officer gates | `hidden`/disable analogue: don’t show controls |
| Demote / Prophet / wipe | Modal confirm before commit |

| V2+ if Ace adopted | |
|--------------------|--|
| AceConfig for prefs only | Keep ladder as custom UI |
| `AddToBlizOptions("ChurchOfBeef", …)` | Discoverability for streamer alts |
| Profiles for **UI prefs only** | Never profile-swap official ladder commits |

---

## Sources

- [AceConfig-3.0 Options Tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables)
- [Ace3 Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started)
- [AceConfigDialog-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-config-dialog-3-0)
- [Ace3 for Dummies](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies)
- [04-ace3-and-libraries.md](../04-ace3-and-libraries.md)
