# Beef Guidance — UI Scale & Resolution

**Track:** [43-ui-scale-pixel-perfection](README.md)  
**Maps to:** design spec §10, §13.11; stream readability track 17

---

## Product decisions (research → V1)

1. **Beef is a guest on the player’s scale.** Never set `uiScale` CVars or `UIParent:SetScale` for Church of Beef. Pixel-perfect is the player’s (or ElvUI’s) job.

2. **Parent to `UIParent`, clamp, save.** Matches locked spec: movable `/beef` frame, clamped to screen, saved position. Apply the same clamp math to toast anchors.

3. **Author toast defaults for Classic auto-scale, verify under pixel-perfect.** Classic’s ~0.90@1440p default is the common guild path; ElvUI/`768/h` is the stress path. Both must keep rank titles readable.

4. **Use the right resolution API.** Layout → `GetScreenWidth/Height` + `UIParent`. Physical diagnostics / future per-monitor defaults → `GetPhysicalScreenSize()`. Never branch “if wide screen” off GetScreenWidth alone.

5. **No eyefinity / ultrawide special case in V1.** Wider virtual width is enough; saved positions + clamp handle 21:9. Revisit only if officers report toasts stuck in bezel dead zones.

6. **Optional later (not V1 blockers):** local border snap (`mult`), user toast scale slider, saved toast point, Blizzard `PixelUtil` if present on Anniversary.

7. **QA matrix (physical × scale):**

   | Physical | Scale profile |
   |----------|----------------|
   | 1920×1080 | Classic default |
   | 2560×1440 | Classic default (~0.9) |
   | 2560×1440 | Pixel-perfect `768/1440` |
   | 3440×1440 | Default + dragged toast |
   | 3840×2160 | Perfect + common modifier (~1.25–1.5) if available |

8. **Spectacle still wins via guild chat.** Scale-perfect toasts help addon users and streamers; members without the addon only see the chat line — do not over-invest in pixel grids for V1 chrome.

---

## Explicit non-goals

| Non-goal | Why |
|----------|-----|
| Ship PixelPerfectUIScale / fork ElvUI PixelPerfect | Wrong product; license/ownership fights |
| Require pixel-perfect for “correct” Beef | Excludes stock Classic players |
| Per-resolution art atlases | Spec allows plain Classic frames + media fallback |
| Match WeakAura sub-pixel placement culture | Combat HUD problem; Beef is edge social UI |

---

## Cross-links

- Stream type sizes / safe zones: [17-stream-overlay-readability](../17-stream-overlay-readability/)
- Visual coexistence with ElvUI: [02-visual-language](../02-visual-language/) (when filled)
- Spec UI surface list: [`2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10
