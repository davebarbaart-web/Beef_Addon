# Confirm handoffs from the Officer tab

**Track:** 69-officer-tab-ia  
**Question:** Which Officer-tab controls leave the tab into a modal, and how does focus return?

**Dialog mechanics / recipes:** [58](../58-staticpopup-confirms/) (especially [beef-demote-prophet-confirms](../58-staticpopup-confirms/beef-demote-prophet-confirms.md)).  
**Menu → confirm:** [36](../36-tooltips-menus/03-context-menus-officer-actions.md).  
This note owns **flow / IA handoff** only.

---

## Handoff table

| Control (zone) | Leaves tab? | Confirm? | On accept | On cancel |
|----------------|-------------|----------|-----------|-----------|
| Approve (B) | No | **No** | Commit; row clears; D updates; select next | — |
| Reject (B) | No | **No** (optional inline reason) | Clear suggestion; D updates | — |
| Standing adjust small (C) | Optional light confirm | Per [58](../58-staticpopup-confirms/beef-demote-prophet-confirms.md) risk ladder | Commit / D row | Stay on C |
| Standing adjust large / wipe (C) | **Yes → modal** | Yes + reason | Commit | Return to Officer tab; no silent success |
| Demote (C) | **Yes → modal** | Yes + reason + named subject | Commit + announce policy | Return; selection unchanged |
| Council appoint (C) | **Yes → modal** | Yes + seats + reason | Commit | Return |
| Prophet bestow / replace (C) | **Yes → modal** | Yes (+ alert on replace) | Commit | Return |
| Context-menu demote ([36](../36-tooltips-menus/)) | Opens same modal | Same as Demote | Same | Same — menu must not commit |

---

## Cousin handoff shape

| Cousin | Pattern | Beef |
|--------|---------|------|
| [Gargul Award confirm](https://github.com/papa-smurf/Gargul/wiki/Awarding-Items) | Select → Award → **dialogue** → commit | Use for **rites**, not for every Cooked Beef Approve |
| [RCLC Award](https://rclootcouncil.com/wiki/Voting-Frame) | Alt-click / right-click Award (history tracked) | Prefer labeled buttons; still confirm only when nuclear |

Training risk: if Approve always pops StaticPopup, officers go Accept-blind on Prophet ([58](../58-staticpopup-confirms/beef-demote-prophet-confirms.md) §7).

---

## Focus & return rules (IA)

1. **Modal is an interrupt, not a navigation.** Officer tab stays mounted underneath; cancel restores the same selection in A/B.  
2. **Nil-show StaticPopup:** queue a re-open affordance on the Officer tab — do not pretend the rite succeeded ([58](../58-staticpopup-confirms/beef-demote-prophet-confirms.md) §9).  
3. **Do not auto-jump tabs** after confirm (Ladder spectacle is guild chat + toast, not a forced Ladder open).  
4. **Combat:** confirms may show; do not gate demote on “leave combat” ([58](../58-staticpopup-confirms/beef-demote-prophet-confirms.md)).  
5. **Subject naming:** modal body must name the player (and for Prophet replace, both names) — IA requirement before [58](../58-staticpopup-confirms/) string craft.

---

## Zone C control grouping (prevent wrong handoff)

Group rite controls so nuclear actions are **spatially separated** from Approve:

```text
C:  [ Adjust standing… ]     [ Excommunicate… ] [ Council… ] [ Prophet… ]
         (med)                      (nuclear — spaced / labeled)
```

Do not place Demote adjacent to Approve in zone B.

---

## Post-handoff success cues

| Outcome | Tab feedback |
|---------|--------------|
| Approve | Row gone; toast may already exist ([49](../49-officer-notifications/)); D gains Approved row |
| Reject | Row gone; optional reason stored; D gains Rejected row |
| Demote / Prophet | Modal closes; D gains row; guild chat may fire — tab does not need a second banner |

---

## See also

- [tab-zones.md](tab-zones.md)  
- [evidence-panel.md](evidence-panel.md)  
- [58 README](../58-staticpopup-confirms/README.md)
