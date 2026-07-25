# GameTooltip Norms (Classic)

**Last updated:** 2026-07-25  
**Track:** [36-tooltips-menus](README.md)

---

## 1. What you actually use

There is one global named tip: `_G["GameTooltip"]`. Addons almost always borrow it for chrome hover text rather than creating a second visible tip ([UIOBJECT_GameTooltip](https://warcraft.wiki.gg/wiki/UIOBJECT_GameTooltip)).

Custom tips (rare for Beef V1):

| Template | When |
|----------|------|
| `SharedTooltipTemplate` | Minimal custom tip (fonts/textures) |
| `GameTooltipTemplate` | Tip that also needs a unit health bar |

Hidden **scanning** tips use `SetOwner(WorldFrame, "ANCHOR_NONE")` and never show to the player — cache results; scanning is a performance smell ([same wiki — Scanning tooltips](https://warcraft.wiki.gg/wiki/UIOBJECT_GameTooltip)). Beef V1 should not need scan tips for ladder/standing (prefer APIs + local SV).

---

## 2. Canonical hover cycle

```text
OnEnter → SetOwner(frame, anchor [, x, y]) → ClearLines? → AddLine / AddDoubleLine / SetText → Show()
OnLeave → Hide()
```

Facts that trip addons ([SetOwner](https://warcraft.wiki.gg/wiki/API_GameTooltip_SetOwner); [AddLine](https://warcraft.wiki.gg/wiki/API_GameTooltip_AddLine); [UIOBJECT_GameTooltip](https://warcraft.wiki.gg/wiki/UIOBJECT_GameTooltip)):

1. **`SetOwner` clears and hides**, then sets temporary owner (independent of frame parent).
2. **`AddLine` / `AddDoubleLine` do not call `Show`.** Most `Set*` helpers do. After building with `AddLine`, you must `Show()`.
3. **Resize happens in OnShow.** Calling `AddLine` on an already-visible tip leaves the new line outside the backdrop until another `Show()`.
4. **`Hide()` clears the owner.** `ClearLines()` clears text without clearing owner/anchor — useful when refreshing the same hover.
5. **Empty tip:** showing with no content hides and clears ownership.
6. **Default line color** when r,g,b omitted is gold (normal font color); first line uses larger header font unless you only `SetText` ([AddLine](https://warcraft.wiki.gg/wiki/API_GameTooltip_AddLine)).

Minimal chrome pattern (community norm):

```lua
frame:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
  GameTooltip:AddLine("Title")
  GameTooltip:AddLine("Detail", 1, 1, 1, true) -- wrap
  GameTooltip:Show()
end)
frame:SetScript("OnLeave", function()
  GameTooltip:Hide()
end)
```

([SetOwner example](https://warcraft.wiki.gg/wiki/API_GameTooltip_SetOwner); [better-addons Frames & Widgets](https://www.better-addons.com/frames-widgets))

---

## 3. Anchors that matter for social UI

| Anchor | Behavior | Beef use |
|--------|----------|----------|
| `ANCHOR_RIGHT` / `ANCHOR_LEFT` / `ANCHOR_*` | Tip relative to owner edges | Buttons, tab chrome, ladder rows |
| `ANCHOR_CURSOR` | Follows cursor (offsets ignored) | Rare; busy over dense lists |
| `ANCHOR_NONE` | No auto `SetPoint` — you position, or scanning | Hidden scanners only |
| `ANCHOR_PRESERVE` | Keeps first position until hide/re-own | Unusual for Beef |

Offsets (`ofsX`, `ofsY`) work for edge anchors; not for `ANCHOR_CURSOR` / `PRESERVE` / `NONE` ([SetOwner](https://warcraft.wiki.gg/wiki/API_GameTooltip_SetOwner)).

`IsOwned(frame)` / `GetOwner()` let you refresh safely only when your frame still owns the tip (avoids stomping another addon mid-hover).

---

## 4. Layout helpers for Beef copy

| Method | Use |
|--------|-----|
| `SetText` | Single-line / first line with color |
| `AddLine(text [, r,g,b [, wrap]])` | Body lines; wrap for long standing explanations |
| `AddDoubleLine(left, right, …)` | Rank · standing, player · points |
| `AddTexture` / `AddAtlas` | Optional icon on last line (keep V1 sparse) |

Do **not** fight ElvUI/Tooltip skinning by forcing custom backdrops on the global tip. Let skinners restyle `GameTooltip`; Beef supplies text only ([ElvUI changelog noise around tooltip skinning](https://tukui.org/elvui) — coexistence stance in track 02).

---

## 5. When not to use GameTooltip

| Need | Prefer |
|------|--------|
| Dense multi-column LDB / minimap summary | [LibQTip-1.0](https://www.wowace.com/projects/libqtip-1-0) (release tip after use) |
| Persistent instructional panel | FontString in frame, not a hover tip |
| Confirm destructive officer action | StaticPopup / Ace dialog — tips are not clickable commit surfaces |
| Item/spell identity | `SetHyperlink` / `SetItemByID` / `SetSpellByID` on the tip, not hand-rolled name strings |

LibQTip caveat: must **release** acquired tips or each holder allocates a full frame set ([LibQTip overview](https://www.wowace.com/projects/libqtip-1-0)).

---

## 6. Norms summary

1. One global tip; own it only for your hover duration.
2. Always `SetOwner` before lines; always `Show` after `AddLine` builds.
3. Always `Hide` on leave (and on frame hide if the tip might still be open).
4. Prefer `AddDoubleLine` for ladder metrics; keep tip ≤ ~6 lines for stream readability (track 17).
5. No scanning tips in V1 hot paths.
