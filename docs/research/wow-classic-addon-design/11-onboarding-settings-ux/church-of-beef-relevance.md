# Church of Beef — Onboarding & Settings Implications

**Last updated:** 2026-07-25  
**Maps to:** [design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §9–§11, §13  
**Track index:** [README.md](README.md)

---

## Top insights (executive)

1. **Zero-config fits V1.** Wizards are for ElvUI/Questie-scale “wrong guess breaks the product.” Beef’s safe defaults (Fresh Beef, scoring paused out of guild, Officer tab gated) mean skip the installer; teach via empty states + first toast.
2. **Minimum discoverability stack:** short slash (`/beef`) + minimap button + (later) Blizzard AddOns entry. Spec already locks the first two; empty slash must open a **real frame**.
3. **LibDBIcon is the ecosystem default** for minimap launchers (`hide` in SV, collector-friendly). Hand-rolled is acceptable for V1 if tested; prefer LibDBIcon when embedding libs.
4. **One options source of truth.** AceConfig’s power is GUI + slash sharing handlers — copy the rule even without Ace. Don’t invent parallel slash flags.
5. **Profiles are for cosmetics, never ladder authority.** AceDBOptions copy/reset/import patterns are great for frame prefs; officer-committed ranks stay on BeefNet revisions.
6. **Starve the settings tree.** Spectacle succeeds when promotions are felt, not when announce pitch has five sliders. V1 settings budget: position, minimap hide, officer announce opt-out (± toast mute).
7. **Confirm destructive officer acts.** Ace `confirm` is the pattern; demote / Prophet / standing wipe need a modal even in plain frames.
8. **Help is ambient.** Minimap tooltip, `/beef help`, not-in-guild empty copy, and toast text beat a blocking tutorial — on-brand for a comedy church.

---

## V1 checklist (design acceptance)

| Item | Status vs ecosystem norm |
|------|---------------------------|
| `/beef` opens/toggles main UI | Required (spec); matches empty-input → GUI |
| `/beef help` chat card | Recommended add |
| Minimap left-click = same toggle | Required (spec) |
| Minimap tooltip teaches slash | Recommended |
| First-run wizard | **Skip** |
| One-time soft chat tip | Optional (`firstRunDone`) |
| AceConfig / AceDB | **Not required** for V1 |
| Bliz Interface Options page | Defer unless prefs grow |
| Profile import/export | **Out of V1** |
| Hide-minimap pref | Add when settings surface exists; default shown |
| Officer announce opt-out | Spec §10 |

---

## Suggested information architecture

```text
/beef  →  Main frame
            ├─ Ladder
            ├─ My Standing
            ├─ Officer (gated)
            └─ (V2) Settings   ← tiny: General / Spectacle / Officer policy
Minimap → same as /beef
```

Do not put ladder occupants inside AceConfig rows. Custom frame for product; options only for prefs.

---

## Phase gating

| Phase | Onboarding / settings work |
|-------|----------------------------|
| **V1** | Discoverability + empty states + tiny prefs; plain frames |
| **V2** | Optional AceConfig + `AddToBlizOptions`; UI profiles; presets (Default / Streamer / Quiet) |
| **Later** | Share-string for *cosmetic* packs only; never for official standing |

---

## Open questions (do not block V1)

1. Should the soft first-run tip be chat, footer, or both?
2. Right-click minimap → Settings vs Help?
3. When (if ever) to add Bliz Options for announce opt-out discoverability on alts?

---

## Sources

Synthesized from this track’s notes and:

- [Ace3 Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started)
- [AceConfig Options Tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables)
- [LibDBIcon-1.0](https://www.wowace.com/projects/libdbicon-1-0)
- [Questie README](https://github.com/Questie/Questie)
- [Ace3 for Dummies](https://warcraft.wiki.gg/wiki/Ace3_for_Dummies)
- Design spec §9–§13
- [annotated-urls.md](annotated-urls.md)
