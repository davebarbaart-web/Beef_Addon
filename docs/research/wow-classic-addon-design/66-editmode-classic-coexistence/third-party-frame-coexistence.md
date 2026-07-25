# Third-party frame coexistence with Edit Mode

**Track:** [66-editmode-classic-coexistence](README.md)  
**Last updated:** 2026-07-25  
**Audience:** Beef UI design — what to own vs what Blizzard/Edit Mode owns.

---

## 1. Ownership model (three layers)

```text
┌─────────────────────────────────────────────────────────────┐
│  Layer A — Blizzard Edit Mode systems                       │
│  Blue-highlighted HUD: unit frames, action bars, chat,      │
│  bags/menu, minimap cluster, objective/status bars,         │
│  raid/party frames (as offered), etc.                       │
│  Positions/settings stored in Edit Mode layouts.            │
├─────────────────────────────────────────────────────────────┤
│  Layer B — Full UI replacements                             │
│  ElvUI, Dragonflight UI Classic, Bartender/Dominos,         │
│  Plater, etc. Often hide/replace Layer A entirely.          │
├─────────────────────────────────────────────────────────────┤
│  Layer C — Independent addon chrome                         │
│  Custom frames on UIParent with own SavedVariables.         │
│  Invisible to Edit Mode unless author registers them.       │
│  ← Church of Beef V1 lives here                             │
└─────────────────────────────────────────────────────────────┘
```

Retail Edit Mode basics (blue selection, drag, layouts): [Wowhead HUD Edit Mode guide](https://www.wowhead.com/guide/ui/ui-and-hud-edit-mode-guide). Anniversary inherited the **tool family**, not necessarily Retail’s full system list ([EU Built-in Edit Mode](https://eu.forums.blizzard.com/en/wow/t/built-in-edit-mode/601446)).

---

## 2. Rules for Layer C addons (normative for Beef)

### Do

1. **Parent to `UIParent` (or a Beef-owned host), never to Edit Mode–managed Blizzard frames.** Anchoring into `CompactRaidFrame…`, chat dock, main menu bar, or player/target frames means the player’s next Edit Mode drag or layout switch relocates or breaks you.
2. **Persist position in your own SavedVariables.** Spec already requires per-character UI prefs + frame position ([track 37](../37-movable-frames-anchors/)). Do not rely on Edit Mode layout files or Blizzard layout cache alone.
3. **Stay out of combat HUD real estate by default.** Raid frames, nameplates, center WA/DBM zone, bottom action bars — players rearrange these constantly under Edit Mode *and* under replacements ([track 08](../08-combat-hud-alerts/)).
4. **Tolerate Layer B replacements.** ElvUI/DFUI users will not see “default Classic” chrome; your frame must still open via `/beef` and minimap toggle without assuming Blizzard bag/micro positions.
5. **Expect Blizzard shared-UI patches to break combat/unit addons first.** Kaivax warned of third-party errors on 2.5.6 / 1.15.9 ([UI Updates](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408)). Social edge UIs survive if they avoid nameplate/raid-frame hooks.

### Don’t

1. **Don’t require Edit Mode registration for core UX.** Optional power-user integration is a later concern; V1 must work with Edit Mode never opened.
2. **Don’t fight Edit Mode on chat.** Anniversary players report main chat is Edit Mode–gated and edge-clamped ([Built-in Edit Mode](https://eu.forums.blizzard.com/en/wow/t/built-in-edit-mode/601446)). Guild-chat *announcements* (text) remain fine; overlaying the chat frame is not.
3. **Don’t skin or replace Blizzard raid frames / nameplates.** That is Plater/Grid/ElvUI territory and the exact surface Blizzard is restyling (2.5.5→2.5.6).
4. **Don’t brand as “Edit Mode for X.”** Players already associate Classic Edit Mode with incomplete QoL and addon breakage ([track 12](../12-classic-vs-retail-philosophy/rejected-from-retail.md)).
5. **Don’t assume a Classic preset restores a safe sandbox.** Preset ≠ 2007 UI; shared code still drifts ([Blizzard Watch](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)).

---

## 3. Opt-in Edit Mode registration (ecosystem fact — not a V1 plan)

Some authors bridge Layer C → Layer A via libraries:

| Project | Role | Relevance |
|---------|------|-----------|
| [Edit Mode Expanded](https://www.curseforge.com/wow/addons/edit-mode-expanded) (+ [GitHub](https://github.com/teelolws/EditModeExpanded)) | Moves extra Blizzard pieces; ships **EditModeExpanded-1.0** so other addons can register custom frames into Edit Mode (position/size per Edit Mode profile) | Proves third-party frames are **not** in Edit Mode by default; ships Classic TBC builds (2026) |
| [Library usage wiki](https://github.com/teelolws/EditModeExpanded/wiki/Authors:-Library-Usage) | `RegisterFrame(frame, localizedName, db, …)` after SVs load; optional resize/hide/minimap pinnable | Documents the integration cost (embed, SV table, LibStub) |
| [FerrozEditModeLib](https://www.curseforge.com/wow/addons/ferrozeditmodelib) | Lightweight Retail-oriented Register helper | Same pattern: opt-in, not automatic |

**Beef V1 stance:** Document awareness only. Independent drag + AceDB/SV (track 37) already satisfies movable/clamped/saved. Edit Mode registration would:

- Add a soft dependency and dual position stores (Edit Mode profile vs `ChurchOfBeefDB`)
- Couple Beef visibility to Edit Mode sessions
- Pull product language toward Retail HUD authorship

Revisit only if guild officers explicitly demand “move Beef inside Edit Mode” *and* Expanded (or a first-party API) is stable on Anniversary `20506`.

---

## 4. Conflict patterns already observed on Anniversary

| Pattern | What happened | Addon lesson |
|---------|---------------|--------------|
| Built-in Edit Mode vs DFUI / MoveAnything | Players say third-party movers did the job better; built-in “messed that up” | Prefer coexistence (own frame) over competing to own Blizzard bars |
| Chat dock restrictions | Edge tuck blocked; tab bleed | Never parent toasts/panels to chat frames |
| Raid frame stacking / healer UX | Default modern frames disliked; healers reinstall unit-frame addons | Beef is not a unit frame — stay clear of that real estate |
| Shared-UI patch breakage | Authors must update for 2.5.6 / 1.15.9 | Avoid fragile FrameXML name assumptions under raid/nameplate trees |
| “Disable Edit Mode” demand | No full off-switch | Design for Edit Mode **present** in the client even when unused |

Sources: [Built-in Edit Mode](https://eu.forums.blizzard.com/en/wow/t/built-in-edit-mode/601446), [Fix Edit Mode](https://eu.forums.blizzard.com/en/wow/t/fix-edit-mode/602113), [Kaivax](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408).

---

## 5. Programmatic respect for Edit Mode (advanced — out of V1)

Retail authors sometimes write/activate Edit Mode layout objects to place Blizzard systems ([US UI forum example](https://us.forums.blizzard.com/en/wow/t/programmatically-modifying-the-ui-while-respecting-edit-mode/2036818)). That pattern:

- Targets **Blizzard** systems, not arbitrary addon frames
- Is picky about load order (`Blizzard_PlayerChoice` / Edit Mode internals)
- Is the opposite of Beef’s need (Beef should not rewrite the player’s HUD)

**Do not** ship layout injection for V1. If anything, *read* nothing from Edit Mode; *write* nothing to it.

---

## 6. Checklist: “Will this survive Edit Mode + ElvUI?”

| Question | Pass criteria |
|----------|---------------|
| Does `/beef` work with all Blizzard unit frames hidden? | Yes |
| Does position survive switching Edit Mode layouts? | Yes (own SV) |
| Does a toast appear if chat is moved/resized? | Yes (not parented to chat) |
| Does anything break if CompactRaidFrames move left↔right? | No dependency |
| Does copy mention Edit Mode? | No |
| Soft-dep on EditModeExpanded? | No for V1 |
