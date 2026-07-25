# Context Menus & Officer Actions

**Last updated:** 2026-07-25  
**Track:** [36-tooltips-menus](README.md)

---

## 1. Context menu = dropdown in `"MENU"` mode

Coding difference from a list-box dropdown is small ([Using UIDropDownMenu — Creating context menus](https://warcraft.wiki.gg/wiki/Using_UIDropDownMenu)):

1. `UIDropDownMenu_Initialize(frame, initFn, "MENU")` (or LibDD equivalent)
2. On right-click: `ToggleDropDownMenu(1, nil, frame, "cursor", 3, -3)`

`EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU")` builds the same thing from a table ([EasyMenu](https://warcraft.wiki.gg/wiki/API_EasyMenu)). For Beef, use **LibUIDropDownMenu’s EasyMenu equivalent** (library wraps EasyMenu.lua) — never stock `EasyMenu`.

Typical menu shape for a ladder/officer row:

```text
[PlayerName]          (isTitle)
Approve suggestion
Reject suggestion
─────────────
Adjust standing…
Demote / Excommunicate…
Appoint Council       (disabled if seats full)
Bestow Prophet        (disabled if occupied / not Officer+)
```

Use `isTitle`, `disabled`, `notCheckable`, separators (`UIDropDownMenu_AddSeparator` / LibDD), and `func` + `arg1 = playerKey`. Nested `hasArrow` only if standing adjust needs a submenu — prefer opening a small dialog instead (wiki: deep menus are bad UX).

---

## 2. UnitPopup (target / portrait / chat right-click)

Classic guild / social addons historically inject into Blizzard’s unit menu via `UnitPopupButtons["MyKey"] = { text = …, dist = 0 }` and hooks on `UnitPopup_OnClick` / menu show. That path is **fragile on Classic**:

- Community reports of custom entries **stuck grayed out** ([BlackList addon thread](https://us.forums.blizzard.com/en/wow/t/wow-classic-blacklist-addon/346193)).
- Retail has moved toward newer menu APIs (`MenuUtil` / secure `UnitPopup_ShowMenu` discussions on [WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=60000)); Classic Anniversary still lives closer to the old UnitPopup world — do not assume Retail recipes.

**Beef V1 recommendation:** do **not** add Church actions to the global unit right-click menu. Reasons:

1. Authority UX belongs behind the Officer tab (spec §10 / §11: tab hidden; actions no-op for non-officers).
2. UnitPopup shares Blizzard’s menu stack → taint risk (track 29).
3. Members without Beef still see nothing useful; officers already have `/beef` officer queue.

V2 optional: “Open in Church” on guild roster / unit menu that only **opens the Beef frame focused on that player** (navigation), never commits ranks from the popup.

---

## 3. Officer action inventory (spec → UI affordance)

| Action | Spec | Primary V1 control | Context-menu? |
|--------|------|--------------------|---------------|
| Approve suggestion | §6 / §10 | Officer tab button | Optional row RMB via LibDD |
| Reject suggestion | §6 | Officer tab button | Optional |
| Manual standing correct | §6 | Dialog from Officer tab | Optional submenu → dialog |
| Demote / excommunicate | §6.1 first-class | Confirm popup | Optional; never one-click silent |
| Council appoint | §4 seat-limited | Officer tab + confirm | Optional |
| Prophet bestowal | §4 unique | Officer tab + confirm | Optional |
| Ceremony start/close | thin stub | Officer / ceremony stub | No |
| Guild-chat announce | §10 | Automatic on commit; per-officer opt-out in settings | No |

Gates (every path):

1. Local player is Officer+ (roster rank-index, track 16) **before** enabling menu items.
2. BeefNet rejects forged `RANK_COMMIT` even if UI is spoofed (spec §6.2 / §8).
3. Soft-deny copy if somehow invoked: “Officers only” — do not hard-error spam (track 22).

---

## 4. Click vs confirm

| Risk | Pattern |
|------|---------|
| Approve / reject suggestion | Direct click OK if label is clear; optional undo is V2 |
| Demote, standing wipe, Prophet replace | **StaticPopup** (or Ace) with player name in body; `preferredIndex = 3` (track 29) |
| Menu click that opens dialog | `func` closes menu (`CloseDropDownMenus` / LibDD) then shows dialog |

Do not put the only copy of “what will happen” exclusively in a tooltip on a disabled menu item — disabled rows can omit tips unless `tooltipWhileDisabled` is set ([AddButton keys](https://warcraft.wiki.gg/wiki/API_UIDropDownMenu_AddButton)).

---

## 5. Right-click on Beef-owned rows (safe pattern)

If V1 wants row context menus at all:

1. Register `Button` mouse button `"RightButton"` on **Beef list rows only**.
2. Build menu with **LibUIDropDownMenu** `"MENU"` mode.
3. Disable items by role and by row state (no pending suggestion → Approve disabled).
4. Never hook `UnitPopup_*` for V1.
5. Left-click still selects / opens Standing detail — RMB is additive.

This keeps authority gestures inside Church chrome and off Blizzard unit frames.
