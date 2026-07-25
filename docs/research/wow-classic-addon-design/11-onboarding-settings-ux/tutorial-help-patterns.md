# Tutorial, Help, and Empty-State Patterns

**Last updated:** 2026-07-25

---

## 1. Pattern catalog

| Pattern | Description | When to use | Evidence |
|---------|-------------|-------------|----------|
| **Installer / wizard** | Modal multi-step first login | Wrong defaults break the addon | ElvUI installer ([Tukui](https://tukui.org/elvui)); Questie first-login setup ([NoobToBoss](https://noobtoboss.com/addon/questie/)) |
| **Empty-state CTA** | Honest empty UI + one primary action | Content-driven addons | WeakAuras empty list + New/Import (*ecosystem observation*) |
| **Inline `desc` / tooltips** | Per-control help | Any options UI | AceConfig `desc` / `descStyle` ([Options Tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables)) |
| **Slash help** | `/addon help` chat card | Power users / streamers | Universal CLI habit; Ace `usage` fields |
| **Minimap tooltip** | Hover teaches click grammar | Utility apps | Questie documents click modifiers ([README](https://github.com/Questie/Questie)) |
| **In-frame footer / tip** | One-line rotating tip | Brand + soft onboarding | Spec allows one-line scripture footer ([spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| **Toast as teach** | First suggestion / first promotion toast explains the loop | Event-driven social systems | Spec toasts on suggestion/approve ([spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| **External wiki / Discord** | Deep docs out of game | Complex tools | Questie FAQ + Discord links ([README](https://github.com/Questie/Questie)) |

---

## 2. Soft vs hard interrupts

| Interrupt level | Example | Player reaction risk |
|-----------------|---------|----------------------|
| **Hard** | Blocking wizard, forced CVar rewrite | Annoyance if skip missing |
| **Soft** | Chat print once, tip banner, empty state | Low |
| **Ambient** | Tooltip, footer, toast copy | Lowest |

For a comedy guild church, **soft + ambient** matches brand. Hard wizards fit UI overhauls (ElvUI), not social ladders.

---

## 3. Help copy principles (social addons)

1. Teach the **loop**, not every option: earn standing → suggestion → officer approve → guild announce.
2. Officer help is different from member help — gate the text with the same Officer+ check as the tab.
3. Prefer verbs players already know: “Approve,” “Demote,” “Record Gora,” not internal message type names (`RANK_COMMIT`).
4. First failure modes deserve empty states: not in guild; roster not loaded; no peers for sync ([spec §11](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

---

## 4. Suggested Church of Beef help surfaces (V1)

| Surface | Content |
|---------|---------|
| Empty slash unknown | Print `/beef` / `/beef help` |
| Not-in-guild ladder | “Join a Beef guild to open the books.” |
| Fresh character | Highlight Fresh Beef + next threshold (50 → Cooked) |
| First suggestion toast | “Officers can approve your promotion in the Officer tab.” |
| Officer empty queue | “No pending suggestions. Thresholds create these automatically.” |
| Footer | One scripture line (brand), not a settings dump |
| Minimap tooltip | Open ladder + slash reminder |

Skip: multi-page tutorial frames, forced `/reload` tours, arpg-style coach marks over the game world.

---

## 5. `/help` card sketch (content only)

```text
Church of Beef
  /beef            Open the ladder
  /beef help       This message
Minimap button toggles the same window.
Standing rises from Gora, ceremonies, and shared instances.
Promotions need Officer approval.
```

---

## Sources

- [AceConfig-3.0 Options Tables](https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables)
- [Questie README](https://github.com/Questie/Questie)
- [Questie — NoobToBoss](https://noobtoboss.com/addon/questie/)
- [ElvUI — Tukui](https://tukui.org/elvui)
- Design spec §10–§11
