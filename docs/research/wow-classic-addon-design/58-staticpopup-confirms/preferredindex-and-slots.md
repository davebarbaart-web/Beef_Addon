# preferredIndex, slots, and confirm-path taint hygiene

**Track:** 58-staticpopup-confirms  
**Purpose:** Depth on *popup slot* practice for confirms. Full secure/taint model → [29](../29-taint-secure-ui/). Do not restate dropdown / UnitPopup guidance ([36](../36-tooltips-menus/)).

---

## 1. The slot pool

Classic FrameXML keeps a small fixed set of `StaticPopup1`…`StaticPopupN` frames (howto: **up to four** concurrent dialogs). `StaticPopup_Show` finds a free slot, applies the `StaticPopupDialogs[which]` definition, and shows that frame ([AddOn Studio](https://addonstudio.org/wiki/WoW:Creating_simple_pop-up_dialog_boxes); [`StaticPopup_Show`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show)).

Implications:

- A busy moment (Blizzard group invite + ready check + Beef demote) can return **nil** from `StaticPopup_Show`.
- Beef must handle nil: print/soft toast “could not open confirm — try again,” or fall back to an owned modal.
- Do not assume your dialog always lands on index 1.

Constant name in FrameXML / addon code: `STATICPOPUP_NUMDIALOGS` (seen in AceConfigDialog, oqueue, WeakAuras changelog notes).

---

## 2. Why `preferredIndex = 3`

Canonical comment in the community howto:

```text
preferredIndex = 3,  -- avoid some UI taint, see WowAce “how to avoid some UI taint”
```

([AddOn Studio](https://addonstudio.org/wiki/WoW:Creating_simple_pop-up_dialog_boxes); mirrored across WowWiki archive examples.)

**What this means in practice (confirm depth only):**

1. Addon code is tainted. Showing a StaticPopup runs through shared FrameXML popup machinery.
2. Preferring a **higher** slot reduces collisions with Blizzard dialogs that habitually use early indices — a long-standing community mitigation, not a formal Blizzard guarantee.
3. Mature libraries converge on the same idea:
   - **AceConfigDialog** sets `preferredIndex = STATICPOPUP_NUMDIALOGS` on its reused `ACECONFIGDIALOG30_CONFIRM_DIALOG` table before `StaticPopup_Show` ([Ace3 AceConfigDialog](https://github.com/WoWUIDev/Ace3/blob/master/AceConfig-3.0/AceConfigDialog-3.0/AceConfigDialog-3.0.lua)).
   - **WeakAuras** changelog: first `preferredIndex = 3`, later escalate to `STATICPOPUP_NUMDIALOGS` ([CurseForge file notes](https://www.curseforge.com/wow/addons/weakauras-2/files/817403)).
   - UI packs (e.g. KkthnxUI StaticPopups) stamp `preferredIndex = 3` on custom entries.

**Beef rule:** every `StaticPopupDialogs["COB_*"]` entry sets `preferredIndex = 3` **or** `STATICPOPUP_NUMDIALOGS` if that global exists on the Anniversary build. Prefer the constant when present (matches Ace); hardcode `3` as Classic-safe fallback.

---

## 3. Confirm-path hygiene checklist (only)

These are the popup-specific rules that belong here; broader taint → 29.

| Do | Don’t |
|----|-------|
| Unique `COB_*` keys | Reuse Blizzard keys or generic `"CONFIRM"` |
| `preferredIndex` on every Beef dialog | Rely on default slot 1 |
| Set `dialog.data` after successful show | Mutate shared dialog tables from other addons |
| `timeout = 0` on nuclear actions | Auto-accept demote/Prophet on timeout |
| `whileDead = true`, `hideOnEscape = true` | Block ghosts; trap ESC without cancel |
| Treat `StaticPopup_Show` nil as failure | Assume the officer clicked Accept |
| Keep OnAccept thin → Core commit | Open `ShowUIPanel(GuildFrame)` from OnAccept |

Track 29 already flags StaticPopup among social footguns and lists `preferredIndex = 3` + custom frame as the two Beef options ([social-addon-footguns](../29-taint-secure-ui/social-addon-footguns.md)). This track owns the **dialog design** that makes that checklist real.

---

## 4. Exclusive / override behavior

From the howto’s `OnCancel` reasons:

| Reason | Meaning |
|--------|---------|
| `"clicked"` | User hit Cancel / button2 |
| `"timeout"` | Nonzero `timeout` expired |
| `"override"` | Another popup cancelled this one, exclusive conflict, death/logout paths |

For Beef demote/Prophet: **do not** treat `"override"` as “user confirmed.” Only `"clicked"` Accept via `OnAccept` commits. If a Blizzard exclusive popup steals the slot, re-prompt or fall back to custom modal.

`cancels = "OTHER_KEY"` can dismiss a prior Beef confirm when a higher-priority one opens (e.g. wipe supersedes adjust) — optional V1 polish.

---

## 5. AceConfig confirm uses the same pool

When (V2+) Ace options expose destructive executes, `confirm = true` / function does **not** invent a parallel system — AceConfigDialog builds a temporary StaticPopup entry and shows it at high `preferredIndex`, often elevating strata to `"TOOLTIP"` ([source](https://github.com/WoWUIDev/Ace3/blob/master/AceConfig-3.0/AceConfigDialog-3.0/AceConfigDialog-3.0.lua)). Officer **ladder** confirms should still be first-class Beef UI (plain frames / StaticPopup), not buried only in Ace options.

---

## See also

- [29 — social-addon-footguns §2](../29-taint-secure-ui/social-addon-footguns.md) — failure mode summary
- [custom-confirm-frames.md](custom-confirm-frames.md) — escape hatch when the pool is hostile
