# StaticPopupDialogs API (Classic-relevant)

**Track:** 58-staticpopup-confirms  
**Purpose:** Concrete fields and call patterns for stock confirm dialogs. Not a FrameXML dump — enough to design Beef keys without re-reading the howto every time.

Primary howto (same lineage as Wowpedia / WowWiki archive): [Creating simple pop-up dialog boxes — AddOn Studio](https://addonstudio.org/wiki/WoW:Creating_simple_pop-up_dialog_boxes). Show API: [`StaticPopup_Show`](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) → FrameXML `StaticPopup.lua` ([Townlong Yak go/StaticPopup](https://www.townlong-yak.com/framexml/go/StaticPopup)).

---

## 1. Registration

```lua
StaticPopupDialogs["UNIQUE_STRING_KEY"] = {
  text = "…",
  button1 = YES,          -- or ACCEPT / custom string
  button2 = NO,           -- or CANCEL
  OnAccept = function(self, data, data2) end,
  OnCancel = function(self, data, reason) end,  -- optional
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,     -- see preferredindex-and-slots.md
}
```

- Key must be **unique across the client** (same rule as `SlashCmdList`). Prefix with addon id: `COB_DEMOTE`, `COB_PROPHET`, etc.
- Register once at load (or lazily once). Do **not** rebuild the whole table on every click just to change the body string — use text args / `data` instead.
- Boolean fields accept any truthy/falsey Lua value; Blizzard FrameXML historically used `1` / `nil` ([howto](https://addonstudio.org/wiki/WoW:Creating_simple_pop-up_dialog_boxes)).

---

## 2. Show / hide

```text
frameOrNil = StaticPopup_Show(which [, text_arg1, text_arg2, data, insertedFrame])
StaticPopup_Hide(which)
```

| Piece | Behavior |
|-------|----------|
| `which` | Key into `StaticPopupDialogs` |
| `text_arg1`, `text_arg2` | Format `text` via `SetFormattedText` (wiki API) |
| `data` | Optional shared payload (also settable on returned frame) |
| `insertedFrame` | Optional subframe embedded in the dialog |
| Return | Popup **frame** on success, **nil** if no slot / refused |

Notes from howto:

- Show returns immediately; the dialog is not visible until the current script cycle ends — safe to assign `dialog.data` / `dialog.data2` right after a non-nil return.
- Up to **four** static popups may display at once; UI picks a free slot.
- `StaticPopup_Hide` after already hidden is harmless.
- `OnAccept` need not hide the frame; FrameXML hides it unless `OnAccept` returns a truthy value (keeps popup open — useful for incomplete edit-box validation).

---

## 3. Core fields (officer-confirm relevant)

| Field | Role for Beef |
|-------|----------------|
| `text` | Body; use `%s` for player / rank. Name the consequence in plain rite language. |
| `button1` / `OnAccept` | Commit path — call into Core / Net; never put sync logic only in UI. |
| `button2` / `OnCancel` | Abort; `reason` may be `"clicked"`, `"timeout"`, `"override"`, etc. |
| `button3` / `OnAlt` | Middle button (mouse-button mnemonic). Rare for Beef V1. |
| `timeout` | Seconds; `0` = no auto-dismiss. **High-risk Beef confirms → 0.** |
| `whileDead` | Allow while ghost — **true** so dungeon wipes don’t block demote UI. |
| `hideOnEscape` | ESC = cancel — **true** for destructive confirms. |
| `preferredIndex` | Slot preference — **required hygiene** for addon dialogs. |
| `showAlert` | “Something bad” icon — use for Prophet replace / wipe / demote. |
| `sound` | Optional play-on-show; keep quiet by default (track 20). |
| `hasEditBox` | Reason / note field; read `self.editBox:GetText()` in `OnAccept`. |
| `maxLetters` | Cap reason length when edit box present (verify Classic field name against FrameXML for target build). |
| `cancels` | Name of another popup to dismiss when this shows. |
| `exclusive` | When shown, cancels other exclusive popups (`OnCancel` reason `"override"`). |
| `notClosableByLogout` | Normally logout cancels; almost never needed for Beef. |
| `OnShow` / `OnHide` | Focus edit box, clear stale text, restore strata. |

Money / item helpers (`hasMoneyFrame`, item-link `data`) exist for Blizzard mail/loot flows — **not** Beef’s path.

---

## 4. Passing context into callbacks

Two complementary mechanisms ([howto](https://addonstudio.org/wiki/WoW:Creating_simple_pop-up_dialog_boxes)):

1. **Format args** — `StaticPopup_Show("COB_DEMOTE", playerName, fromRankTitle)` fills `%s` / `%s` in `text`.
2. **Frame data** — after show:

```text
local dialog = StaticPopup_Show("COB_DEMOTE", name, fromRank)
if dialog then
  dialog.data  = payload     -- passed to OnAccept / OnCancel / OnAlt
  dialog.data2 = extra       -- OnAccept only
end
```

`OnAccept = function(self, data, data2)` — also readable as `self.data`. Prefer a **table** payload: `{ playerKey, fromRank, toRank, announce }`.

---

## 5. Edit box pattern (reason field)

When `hasEditBox = true`:

- FrameXML exposes `self.editBox` (and `$parentEditBox` naming).
- Typical `OnShow`: clear / prefill, `SetFocus()`.
- Typical `OnAccept`: read text; if empty and reason is required, return `true` to keep the dialog open and soft-error (status text / print) — product choice.
- `EditBoxOnEnterPressed` / `EditBoxOnEscapePressed` can accept or cancel without the main buttons (see community examples such as oqueue’s ban dialog).

**Beef:** demote / Prophet / wipe want a short reason (track [40](../40-officer-moderation-audit/beef-product-patterns.md)). StaticPopup edit box is enough for V1 if validation is minimal; richer “reason enum + free text” → custom frame.

---

## 6. What StaticPopup is *not*

| Not for | Prefer |
|---------|--------|
| Dense officer queue UI | Officer tab frames |
| Multi-field forms | Custom modal |
| Combat-protected actions | N/A — Beef has none |
| Settings toggles with confirm | AceConfig `confirm` (opens StaticPopup for you) |
| Right-click menus | LibUIDropDownMenu → then open confirm ([36](../36-tooltips-menus/)) |

---

## See also

- [preferredindex-and-slots.md](preferredindex-and-slots.md)
- [custom-confirm-frames.md](custom-confirm-frames.md)
- [annotated-urls.md](annotated-urls.md)
