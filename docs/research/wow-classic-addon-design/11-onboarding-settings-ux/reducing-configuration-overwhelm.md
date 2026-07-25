# Reducing Configuration Overwhelm

**Last updated:** 2026-07-25

---

## 1. Why social addons die in options hell

Combat UIs (ElvUI, WeakAuras) *must* expose depth. Guild social tools that mirror that depth train members to ignore the addon. Church of Beef’s V1 success metric is a **visible guild reaction to a promotion** ([spec §13](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) — not a perfect preferences taxonomy.

---

## 2. Techniques used by mature addons

Grounded in AceConfig capabilities ([Options Tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables)) and observed product choices:

| Technique | Mechanism | Effect |
|-----------|-----------|--------|
| **Sensible defaults** | AceDB defaults / aggressive enable | Skip options entirely on first night |
| **Order by frequency** | `order` low for daily toggles | Important controls surface first |
| **Progressive disclosure** | `hidden` / Advanced group / `guiHidden` | Power features stay available, not ambient |
| **Role-gated UI** | `disabled`/`hidden` funcs | Officers see officer tools; members don’t |
| **Confirm destructive acts** | `confirm` | Prevents fat-finger demotes |
| **Presets over knobs** | Named layouts (installer / profile presets) | One choice replaces twenty sliders |
| **Opt-in noise** | Plugins/features off until wanted | HandyNotes-style data packs (*ecosystem observation*) |
| **Reset escape hatch** | AceDBOptions Reset Profile | Recover from bad experiments |
| **Separate product UI from prefs** | Main frame ≠ options tree | Ladder stays readable |
| **Inline help** | `desc`, empty states | Fewer wiki trips |

Deep research synthesis lists the same floor: Bliz options + slash + minimap + defaults + advanced gating ([`.raw/onboarding-settings-ux-deep.md`](.raw/onboarding-settings-ux-deep.md)).

---

## 3. Anti-patterns to avoid

| Anti-pattern | Why it hurts Beef |
|--------------|-------------------|
| Settings for every scoring weight in V1 | Thresholds live in canon data; officers don’t need a slider farm pre-playtest |
| Duplicate controls (slash-only flag + GUI-only flag) | Drift and support burden |
| First-run wall of checkboxes | Guildmates alt-F4 the vibe |
| Minimap pin spam for ranks | Fights Questie; clutter complaint magnet |
| Importing “full church state” strings | Undermines officer authority |
| Hiding the main frame behind nested options | Spec failure mode: command works, nothing appears |

---

## 4. Recommended settings budget for Church of Beef

### V1 (keep tiny)

| Pref | Default | Notes |
|------|---------|-------|
| Frame position | Saved | Spec |
| Minimap button shown | On | Discoverability |
| Guild announce opt-out | Off (announces on) | Per-officer, spec §10 |
| Maybe: mute toasts | Off | Only if playtest complains |

Everything else: hardcode or canon data.

### V2+ (still gated)

| Group | Contents |
|-------|----------|
| General | Scale, lock frame, hide minimap |
| Spectacle | Toast density, announce style, footer on/off |
| Officer | Rank-index threshold, council seats (canon-backed) |
| Profiles | UI prefs only |

Use an **Advanced** subgroup for anything touched less than once per season.

---

## 5. Decision checklist (before adding a setting)

1. Does a wrong default cause real harm? If no → hardcode.
2. Is this officer policy or member cosmetic? Gate accordingly.
3. Can a preset absorb it? Prefer preset.
4. Does it belong in canon data (`Ranks.lua`) instead of UI?
5. Will streamers need it mid-broadcast? If yes, expose near `/beef`, not buried.

---

## Sources

- [AceConfig-3.0 Options Tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables)
- [AceDB-3.0 Tutorial](https://www.wowace.com/projects/ace3/pages/ace-db-3-0-tutorial)
- [`.raw/onboarding-settings-ux-deep.md`](.raw/onboarding-settings-ux-deep.md)
- Design spec §10, §13
- [04-ace3-and-libraries.md](../04-ace3-and-libraries.md)
