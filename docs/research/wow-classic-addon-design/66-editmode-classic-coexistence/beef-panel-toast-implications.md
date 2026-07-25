# Beef panel & toast implications (Edit Mode coexistence)

**Track:** [66-editmode-classic-coexistence](README.md)  
**Complements:** [37 — toast/panel placement](../37-movable-frames-anchors/beef-toast-panel-placement.md), [08 — combat HUD](../08-combat-hud-alerts/), [17 — stream safe zones](../17-stream-overlay-readability/), [12 — no Edit Mode branding](../12-classic-vs-retail-philosophy/rejected-from-retail.md).  
**Last updated:** 2026-07-25

---

## 1. Design verdict

Anniversary players now live in a world where **Blizzard HUD geometry is mutable** (Edit Mode since pre-patch) and **default plate/frame art drifts** (2.5.5→2.5.6). Beef must treat the screen as contested space owned by:

1. Edit Mode layouts  
2. Combat stack (WA / DBM / BigWigs / Plater)  
3. Optional full UI packs (ElvUI / DFUI)  
4. Stream overlays  

Church of Beef owns only its **Layer C** surfaces. Placement rules below refine track 37 for that contested world — they do not replace LibWindow / SV mechanics.

---

## 2. Main `/beef` panel

| Decision | Rationale under Edit Mode modernization |
|----------|----------------------------------------|
| **Independent movable frame + `ChurchOfBeefDB` position** | Spec §10; survives Edit Mode layout switches and ElvUI hiding Blizzard chrome |
| **Default first-run: `CENTER` (or slight upper-center) on `UIParent`** | Visible even if player’s Edit Mode shoved chat/bars into corners; avoids “command worked, nothing appeared” |
| **`SetClampedToScreen(true)`** | Same as Classic chat edge fights — do not require pixel-perfect edge tuck that Edit Mode itself restricts on Blizzard chat |
| **Never anchor to unit/raid/action-bar/chat/minimap Blizzard frames** | Those are exactly what Edit Mode + Jul 2026 options restyle and relocate |
| **No Edit Mode registration in V1** | Avoid dual position authority; avoid Retail-tool branding ([coexistence note](third-party-frame-coexistence.md)) |
| **Strata: above world, below modal dialogs** | Edit Mode UI itself is a modal-ish editor — Beef should not fight Escape-menu / Edit Mode chrome |
| **Copy: “move the Beef window,” never “Edit Mode”** | Anniversary Edit Mode reception is polarized ([EU thread](https://eu.forums.blizzard.com/en/wow/t/built-in-edit-mode/601446); [track 12](../12-classic-vs-retail-philosophy/rejected-from-retail.md)) |

### Zones to avoid as *defaults* (panel)

Players commonly park Edit Mode / replacement UI here:

| Screen zone | Occupied by |
|-------------|-------------|
| Bottom center / bottom third | Action bars, XP/status bars, micro/bags |
| Bottom-left | Chat (Edit Mode–sensitive) |
| Left / mid-left | Party/raid frames (Midnight-aligned options in Jul 2026) |
| Top-right | Minimap cluster, buffs, LibDBIcon buttons |
| Center / center-lower | Character, WA, boss timers |

Center-on-first-run is still correct for a **modal social window** the user opens intentionally — it is not a persistent HUD widget. After first drag, restore SV quadrant anchors (track 37).

---

## 3. Toasts (suggestion / rank / Gora credit)

| Decision | Rationale |
|----------|-----------|
| **Fixed default anchor; not movable in V1** | Toast choreography must not track Edit Mode layouts or panel drag |
| **Parent to `UIParent` (or dedicated non-movable host)** | Never to chat, raid frames, or the `/beef` panel |
| **Prefer upper-third / top-center, title-safe (~80%)** | Aligns with stream guidance (track 17) and stays above bottom Edit Mode bar fights |
| **Do not use Blizzard `RaidWarningFrame` as the Beef toast** | Combat/social confusion; that frame family sits in modernized HUD space |
| **One-at-a-time / short queue; auto-dismiss** | Avoid stacking into WA/DBM vertical columns when players shove bars upward |
| **No Edit Mode profile binding** | Layout import/share on Retail-style Edit Mode must not relocate Beef toasts |

### Toast anti-collision (Anniversary-aware)

| Avoid | Why (Edit Mode / modern UI angle) |
|-------|-----------------------------------|
| Bottom-left stack | Chat dock fights; Edit Mode edge clamps |
| Bottom-center stack | Action bars + status bars players freely drag |
| Left edge mid-screen | Compact raid frames + healer addons |
| Top-right hug | Minimap / buffs / compartment debates |
| Dead center | WA / boss mod / nameplate density after plate modernization |
| Same point as saved `/beef` | Panel drag must not redefine toast path |

---

## 4. Interaction with guild-chat spectacle

Spec prefers guild-chat announcements for ceremony/ladder theater. That path is **more robust under Edit Mode** than visual chrome:

- Chat may look ugly or be hard to edge-tuck, but `SendChatMessage` / print still delivers.
- Toasts are secondary glanceables for the acting player — not a replacement for chat records.

Do not build a persistent left-rail “activity feed” that pretends to be Edit Mode social HUD ([track 12 Discord-overlay reject](../12-classic-vs-retail-philosophy/rejected-from-retail.md)).

---

## 5. Optional V2+ (explicitly later)

Only after V1 ships and Anniversary Edit Mode stabilizes:

1. **Toast anchor preset** (Top / Bottom / Left / Right) — still Beef-owned, not Edit Mode  
2. **Unlock toast host** with LibWindow — still own SV  
3. **Soft-dep EditModeExpanded** for officers who want Beef in the blue highlighter — dual-write positions carefully or treat Expanded as override only while registered  
4. **Detect “Edit Mode active”** to suppress toasts during layout editing (nice-to-have; not required)

---

## 6. One-page placement policy (copy into design reviews)

1. Beef panel = Layer C, movable, clamped, SV, centered first run.  
2. Toasts = Layer C, fixed edge, independent, title-safe, non-combat-center.  
3. No parenting into Blizzard Edit Mode systems.  
4. No Edit Mode API / Expanded dependency in V1.  
5. No marketing language that equates Beef with Edit Mode.  
6. Survive ElvUI and default-UI-only guildies equally.
