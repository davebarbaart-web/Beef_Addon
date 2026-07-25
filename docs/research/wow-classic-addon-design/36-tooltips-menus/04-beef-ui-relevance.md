# Beef UI Relevance

**Last updated:** 2026-07-25  
**Track:** [36-tooltips-menus](README.md)  
**Spec:** [Church of Beef V1 design](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10–§11

---

## 1. Surfaces → widget choice

| Surface | Tooltip | Dropdown | Context menu |
|---------|---------|----------|--------------|
| Minimap / LibDBIcon | Short: open `/beef`, left/right legend | — | Optional LibDD menu: Open / Settings stubs (track 28) |
| Ladder tab rows | Rank, standing, trend, “suggested?” | Filter: All / Eligible / Rank band (LibDD or AceGUI) | Officer-only RMB shortcuts (optional) |
| Standing tab | Event breakdown on hover | — | — |
| Officer tab queue | Point breakdown on hover | Filter: Pending / All | Approve/Reject/Demote via buttons **first**; RMB optional |
| Toast | Prefer toast body text; tip only if truncated | — | — |
| Slash `/beef` | N/A | N/A | N/A (track 22) |

Church of Beef is a **guild/minimap social tool**, not a combat tooltip injector (track 01 mental model). Do not hook every unit tooltip to stamp Beef ranks in V1 — that is RP-addon territory (TRP/MRP) and fights TipTac/ElvUI. Optional V2: one line on guild-mate tooltips behind a default-off pref.

---

## 2. V1 recommendations (ship these)

1. **GameTooltip on interactive chrome** — tab buttons, disabled Officer controls (“Officers only”), truncated liturgy strings, minimap icon.
2. **Primary officer verbs as visible buttons** on the Officer tab (Approve / Reject / Demote / Adjust). Discoverable without teaching RMB.
3. **If any dropdown is needed** (queue filter): **LibUIDropDownMenu-4.0** or AceGUI — never stock FrameXML menu APIs.
4. **Confirm dialogs** for demote / Prophet / destructive standing edits.
5. **No UnitPopup injection** in V1.

## 3. Explicit non-goals for V1

| Non-goal | Why |
|----------|-----|
| LibQTip multi-column ladder tip | Global `GameTooltip` + Standing tab enough |
| Stock `EasyMenu` for speed | Taint (track 29) |
| “Approve” on target frame RMB | Authority + taint + Classic gray-menu bugs |
| Tooltip combat scanning | Irrelevant to Beef scoring |

## 4. Copy tone on tips / menus

Align with track 32 (microcopy) and brand liturgy:

- Tips: plain utility (“Standing: 420 · Rank: Beef Knight”).
- Menu titles: player name as `isTitle`.
- Destructive items: verbs like “Excommunicate…” (ellipsis → confirm), not “Demote” alone if demotion is spectacle.
- Disabled Officer items: tip or adjacent FontString explains gate; do not silent-no-op without feedback (spec §11).

## 5. Cross-track pointers

| Concern | Track |
|---------|-------|
| Taint / StaticPopup index | [29-taint-secure-ui](../29-taint-secure-ui/) |
| Officer+ roster timing | [16-guild-roster-officer-edges](../16-guild-roster-officer-edges/) |
| Slash officer verbs | [22-slash-commands-ux](../22-slash-commands-ux/) |
| Minimap button menus | [28-minimap-addon-compartment](../28-minimap-addon-compartment/) |
| Stream-readable tip length | [17-stream-overlay-readability](../17-stream-overlay-readability/) |
| Ace options widgets | [03-ace-libs-options](../03-ace-libs-options/) |
