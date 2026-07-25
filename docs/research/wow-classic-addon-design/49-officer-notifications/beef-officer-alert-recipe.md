# Beef officer alert recipe (V1 / later)

**Last updated:** 2026-07-25  
**Track:** [49-officer-notifications](README.md)  
**Depends on:** [alert-channel-matrix.md](alert-channel-matrix.md), [anti-spam-coalescing.md](anti-spam-coalescing.md), sound policy in [20](../20-sound-sfx-feedback/)

Concrete recommendation for Church of Beef. Research only — not an implementation plan commit.

---

## 1. V1 default AttentionKit

When coalescing says **fire AttentionKit** (pending 0→≥1, cooldown clear, not silent path):

| Step | Action | Default on? |
|------|--------|-------------|
| 1 | `print` / AddMessage: `Church of Beef: N pending approval(s) — /beef officer` | **On** |
| 2 | `RaidNotice_AddMessage(RaidWarningFrame, "Church of Beef: pending approval", ChatTypeInfo["RAID_WARNING"])` | **On** |
| 3 | `FlashClientIcon()` (no `briefly` arg on Classic until verified) | **On** |
| 4 | Soft `PlaySound` on `"SFX"` (non–Raid-Warning kit) | **Off** (or on only if global sounds enabled and category “Officer alerts” on) |
| 5 | Whisper self | **Off** |

Copy stays in the **officer-serious** register ([32](../32-microcopy-tone-voice/)): plain count + how to open the queue. No scripture joke in the RaidNotice.

### SoftUpdate (queue already non-empty)

- Update print / minimap badge count only.  
- No Flash, no RaidNotice, no sound.

### Prefs (minimum)

| Pref | Default | Notes |
|------|---------|-------|
| Officer alerts master | On | Gates AttentionKit |
| Center caution (RaidNotice) | On | |
| Flash client icon | On | |
| Sound | Off | Respects track-20 global mute |
| Whisper self | Off | |
| Quiet in combat | On | SoftUpdate still OK |

---

## 2. Explicitly out of V1 AttentionKit

| Anti-pattern | Why |
|--------------|-----|
| `SendChatMessage(..., "RAID_WARNING")` | Broadcasts to group; wrong privilege model |
| `PlaySound(8959)` / `SOUNDKIT.RAID_WARNING` as default | Combat wallpaper ([20/02](../20-sound-sfx-feedback/02-overused-sounds-and-packaging.md)) |
| Master channel | Competes with DBM/WA; stream bleed |
| Guild or officer chat “X suggested promote” | Spec reserves chat spectacle for **approved** ranks |
| Pulse / repeat until acknowledged | Spam + photosensitivity adjacent |
| Auto-popup Officer tab mid-pull | Focus steal; combat UX risk |

---

## 3. Mapping to Beef surfaces

| Surface | Role in pending awareness |
|---------|---------------------------|
| Officer tab queue | Source of truth; opening = acknowledge |
| Minimap / LibDBIcon badge (if shipped) | Persistent count while queue > 0 — silent |
| Member toast “suggestion created” | Confirms to the *member*; not an officer kit |
| Guild announce | Only after approve/demote (spec §10) |
| Audit log ([40](../40-officer-moderation-audit/)) | After action — not an alert channel |

---

## 4. Later / playtest knobs

| If officers say… | Adjust |
|------------------|--------|
| “I missed suggestions while alt-tabbed” | Keep Flash on; consider opt-in soft sound on Master *only* as advanced |
| “RaidNotice feels like a mechanic” | Default RaidNotice off; print + flash + badge only |
| “I want whisper breadcrumbs” | Enable whisper-self pref; still coalesced |
| “Offline officers miss the queue” | Product: extend sync for pending suggestions (spec §16.5) — not louder alerts for the online ones |
| “Too quiet after clearing one of many” | SoftUpdate print is enough; do not AttentionKit on every decrement→increment within cooldown |

---

## 5. Acceptance criteria (research → design)

1. Two `SUGGESTION`s in one second → **one** AttentionKit max.  
2. Third suggestion while two pending → print/badge only.  
3. Reload with three pending already in SV → **no** AttentionKit.  
4. Non-officer → no kit.  
5. Approve last item, then new suggestion after cooldown → AttentionKit may fire again.  
6. Global mute → no sound; visuals still honor their prefs.  

---

## 6. Relationship to success criterion §13.11

Guild-chat reaction on promotion night is the **spectacle** success metric. Officer AttentionKit is **ops** — it exists so an officer opens the queue and creates that announce. If AttentionKit becomes louder than the announce, the product inverted its priorities.
