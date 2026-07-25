# Hide-button norms & coexistence

**Last updated:** 2026-07-25

---

## Player norms

| Norm | Evidence | Author implication |
|------|----------|-------------------|
| Minimap fills with addon icons | Classic forum / Reddit clutter threads | One more icon is a social cost |
| Install a collector (MBB → HidingBar / MinimapButtonButton) | Curse flavors + guides | Icon may vanish into a bag |
| Turn off each addon’s minimap button; use slash | [r/classicwow](https://www.reddit.com/r/classicwow/comments/ffa99x/any_idea_of_an_addon_i_can_use_to_sort_out_the/) | Hide toggle is expected |
| LDB bar hosts launchers | Bazooka / Titan / Arcana on Classic | LDB object is free discovery for those users |
| Retail: prefer compartment over warts | [r/wow AddonCompartment](https://www.reddit.com/r/wow/comments/13a7hwf/addon_developers_please_start_using_the_new/) | Multi-flavor TOC later |

---

## Hide-minimap-button — expected API surface

LibDBIcon’s documented contract ([WowAce](https://www.wowace.com/projects/libdbicon-1-0)):

- Persist `hide` on the table passed to `Register`.
- Options toggle: set `db.hide`, then `icon:Hide(name)` or `icon:Show(name)`.

Community sample pattern (WoWInterface / WowAce Bunnies example): slash or options flips `profile.minimap.hide` and calls Hide/Show.

**Beef rule:** If hide is true, `/beef` and (if present) LDB bar click still open the frame. Never gate frame creation on the button existing.

---

## Coexistence matrix (detail)

| Player setup | Sees Beef how? | Failure if author is sloppy |
|--------------|----------------|-----------------------------|
| Stock minimap, no collector | LibDBIcon on rim | Hand-rolled button overlaps / wrong shape |
| HidingBar / MinimapButtonButton / MBB | Inside collector tray | Anonymous button not grabbed or breaks bag |
| Bazooka / Titan / Arcana | LDB launcher on bar | Missing LDB → minimap-only |
| Hide button = on | `/beef` only | Button-only open path |
| Retail compartment users | Compartment row (+ optional icon) | Anniv: compartment missing → no entry if icon also hidden |
| ElvUI square minimap | LibDBIcon respects shape helpers | Custom SetPoint hacks ignore shape |

---

## What not to do

- Do not add **extra** minimap pins for ranks / standing (fights Questie/GatherMate — already in [01 minimap.md](../01-ux-patterns/minimap.md)).
- Do not `Show()` every login if the user hid the icon.
- Do not depend on collector ignore-lists for correctness.
- Do not use compartment-only entry on Anniversary.
- Do not name the LDB object something unstable across versions (breaks SV / collector identity).

---

## Soft-test checklist (Anniversary)

Before calling launcher “done”:

1. Fresh install: icon visible; left-click toggles frame; `/beef` toggles same frame.
2. Options: hide icon → icon gone; `/beef` still works.
3. With HidingBar or MinimapButtonButton: Beef appears in bag; click still toggles.
4. Optional: Bazooka installed → launcher on bar.
5. Optional smoke: `AddonCompartmentFrame` existence — document result; do not block release if nil.

---

## Sources

- [LibDBIcon-1.0 — WowAce](https://www.wowace.com/projects/libdbicon-1-0)
- [HidingBar — CurseForge](https://www.curseforge.com/wow/addons/hidingbar)
- [MinimapButtonButton — CurseForge](https://www.curseforge.com/wow/addons/minimapbuttonbutton)
- [r/classicwow — minimap mess](https://www.reddit.com/r/classicwow/comments/ffa99x/any_idea_of_an_addon_i_can_use_to_sort_out_the/)
- [Addon compartment — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Addon_compartment)
