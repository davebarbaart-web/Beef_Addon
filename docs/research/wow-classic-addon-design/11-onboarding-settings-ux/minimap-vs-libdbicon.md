# Minimap Buttons vs LibDBIcon

**Last updated:** 2026-07-25

---

## 1. Why this matters for onboarding

Minimap icons are the **default visual teach** for Classic utility addons: “what did I just install?” Players who never read CurseForge descriptions find the addon by the new button. Slash alone is insufficient for casual guild installs.

Church of Beef V1 **requires** a minimap button that toggles the same frame as `/beef` ([spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

---

## 2. Three approaches

| Approach | Pros | Cons |
|----------|------|------|
| **LibDBIcon-1.0 + LibDataBroker** | Position/radius/`hide` in SV; `Hide`/`Show` API; plays with collectors; tiny embed | Extra libs (LibStub + LDB + LibDBIcon) |
| **Hand-rolled Minimap child** | No deps | Breaks collectors; reinvent drag/hide; higher complaint rate |
| **No minimap button** | Cleaner chrome | Onboarding tax; must nail slash + Bliz options |

Primary LibDBIcon contract ([WowAce LibDBIcon-1.0](https://www.wowace.com/projects/libdbicon-1-0); [CurseForge](https://www.curseforge.com/wow/addons/libdbicon-1-0)):

1. Create LDB data object (`type`, `text`, `icon`, `OnClick`, …).
2. `icon:Register("MyLDB", myLDB, savedVarTable)`.
3. SV table holds `hide` plus position metadata; library auto-hides when `hide = true`.
4. Runtime: `icon:Hide("MyLDB")` / `icon:Show("MyLDB")`.

Canonical AceDB nesting in the upstream example:

```text
profile.minimap = { hide = false }
icon:Register("Bunnies", bunnyLDB, self.db.profile.minimap)
```

Library still actively released across Classic flavors (CurseForge file list includes Classic / Classic TBC; project updated July 2026 per CurseForge listing).

---

## 3. Click grammar (exemplar)

Questie documents a rich minimap grammar ([Questie README](https://github.com/Questie/Questie)):

| Input | Action |
|-------|--------|
| Left-click (Journey paths) | Product windows / journey |
| Shift + left-click | Configuration (`/questie`) |
| Right-click | Alternate surfaces (zone list / search — README variants) |

**Steal for Beef (keep simpler):**

| Input | Action |
|-------|--------|
| Left-click | Toggle main `/beef` frame |
| Right-click | Optional: Settings or help tooltip menu |
| Modifier | Not required in V1 |

Always ship a **Hide minimap button** toggle once settings exist; slash must remain sufficient ([01-ux-patterns/minimap.md](../01-ux-patterns/minimap.md)).

---

## 4. Collectors and clutter

Guild UIs often run MinimapButtonBag / MBB-style collectors. LibDBIcon-backed buttons are the path of least resistance for those tools (*ecosystem observation*; aligns with WowAce purpose statement). Hand-rolled icons frequently float outside collectors or double-register.

Do **not** add rank pins on the minimap — that competes with Questie / gathering addons ([minimap UX note](../01-ux-patterns/minimap.md)).

---

## 5. When to skip the button

Skip only if the addon is:

- Purely silent (rare alerts), or
- Entirely embedded in another host UI, or
- Combat HUD with no “app” metaphor

Church of Beef is a **guild social app** — button belongs.

---

## 6. Church of Beef relevance

| Phase | Recommendation |
|-------|----------------|
| **V1** | Spec-compliant button toggling main frame. Hand-rolled OK if tested with a collector; **LibDBIcon preferred** when ready to embed libs ([04-ace3](../04-ace3-and-libraries.md)). |
| **Prefs** | `minimap.hide` in SV; default **shown** for first-run discoverability. |
| **Icon art** | Distinct silhouette (church / steak / cow mark) — post-V1 art pass; placeholder icon fine for scaffolding. |
| **Tooltip** | “Church of Beef — Left-click: ladder · `/beef`” |

---

## Sources

- [LibDBIcon-1.0 — WowAce](https://www.wowace.com/projects/libdbicon-1-0)
- [LibDBIcon-1.0 — CurseForge](https://www.curseforge.com/wow/addons/libdbicon-1-0)
- [Questie README](https://github.com/Questie/Questie)
- [01-ux-patterns/minimap.md](../01-ux-patterns/minimap.md)
- Design spec §10
