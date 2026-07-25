# Beef recommendation: officer / ladder UI construction

**Track:** 35 · **Last updated:** 2026-07-25  
**Maps to:** Plan Task 7 (`UI/MainFrame.lua`, tab stubs, minimap, toasts) and later Ladder / Standing / Officer tab fills.

## Recommendation (V1)

**Lua-primary `CreateFrame` UI that inherits Classic FrameXML templates for chrome. No addon-authored `.xml` in V1 unless a concrete template reuse or hybrid-scroll need appears.**

This matches the locked plan line: *“XML optional (Lua `CreateFrame` primary)”* and the spec’s *plain Classic frames* bar.

### Do

| Surface | Construction |
|---------|----------------|
| Main shell | `CreateFrame("Frame", …, UIParent, "BasicFrameTemplate")` (or Classic-verified equivalent); set size, clamp, saved position |
| Tab buttons | `CreateFrame("Button", …, main, "UIPanelButtonTemplate")` or simple checkbutton pattern; Lua `ShowTab` |
| Ladder rows | Pooled anonymous frames + FontStrings/Textures created in Lua; refresh from Core records |
| Officer queue | Same pool pattern: suggestion row + Approve / Reject buttons inheriting `UIPanelButtonTemplate` |
| Confirm friction (demote / Prophet) | Small dialog frame inheriting dialog border/header templates **or** a modal child frame built in Lua |
| Toasts | Lightweight frames; no XML |
| Minimap | LibDBIcon later if needed; otherwise button frame in Lua (track 28) |

### Don’t (V1)

- Author a full FrameXML mirror of MainFrame / tabs.
- Pull AceGUI for the ladder or officer queue.
- Depend on Retail-only templates (`DefaultPanelTemplate`, etc.) without Classic verification.
- Use secure templates.
- Put scoring / BeefNet logic inside OnClick XML blobs — call into Core / Net from Lua modules.

## Why this fits officer + ladder specifically

1. **Data-shaped UI.** Ladder standings and officer suggestion queues change every session. Imperative fill/reuse is the maintainable path ([when-xml-vs-lua](when-xml-vs-lua.md)).
2. **Thin adapter architecture.** Plan keeps Core offline-testable; UI files should only bind widgets → `COB.Ladder` / `COB.Officer`. XML trees tend to grow “smart” OnLoad scripts that blur that boundary.
3. **Native enough chrome.** Inheriting `BasicFrameTemplate` + panel buttons gives Classic-readable officer tools without theatrical art (theatrical chrome is a later visual track).
4. **Team/edit cost.** One language (Lua) for Core + UI + Net matches a small V1 codebase and the existing `tests/wow_stub.lua` culture.
5. **Escape hatch preserved.** If V2 wants a `COBRowTemplate` reused across ladder / officer / ceremony lists, add a small `UI/Templates.xml` with `virtual="true"` and switch factories to `CreateFrame(..., "COBRowTemplate")` — no rewrite of Core.

## Suggested module responsibilities (construction only)

```text
UI/MainFrame.lua   → shell CreateFrame + tab host + ESC/close + position SV
UI/LadderTab.lua   → row pool, columns (name, rank title, standing), select → Standing
UI/StandingTab.lua → detail FontStrings; not a second framework
UI/OfficerTab.lua  → suggestion pool; Approve/Reject → Core; gated Show
UI/Toasts.lua      → short-lived frames; no templates required
```

No `.xml` in the TOC until a template file earns its place.

## Classic verification checklist (before locking template names)

Run once on TBC Anniversary client (or Classic FrameXML extract for that build):

- [ ] `BasicFrameTemplate` exists and looks acceptable
- [ ] `UIPanelButtonTemplate` / close button templates exist
- [ ] Chosen dialog templates exist (if used)
- [ ] No Retail-only template slipped into code
- [ ] `/reload` after UI edits; XML errors would show at load if any XML is added later

Extract Blizzard UI / browse SharedUIPanel templates as Gello recommends ([forum](https://us.forums.blizzard.com/en/wow/t/creating-a-simple-gui-element-with-xml/1488298); [Viewing Blizzard interface code](https://wowpedia.fandom.com/wiki/Viewing_Blizzard%27s_interface_code)).

## When to revisit XML

Add addon XML if **any** of these become true:

| Trigger | Action |
|---------|--------|
| Same complex row layout copy-pasted ≥3 times | `virtual` row template in `UI/Templates.xml` |
| Hybrid scrollframe required for long ladders | Follow Blizzard hybrid pattern (often XML-assisted) |
| Designers want a declarative shell separate from Lua | One shell `.xml` + Lua tabs still OK |

Until then, stay Lua-primary.
