# Implications for Church of Beef

**Last updated:** 2026-07-25  
**Maps to:** [V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)  
**Evidence:** docs 01–04 in this folder + `.raw/` primaries.

---

## Top community / distribution insights

1. **Dual-publish is the norm, not a luxury.** CurseForge still reaches the most Classic players; Wago is the packager-native second home with explicit Burning Crusade Classic browsing. WowInterface is optional. Set `X-Curse-Project-ID` / `X-Wago-ID` early and use BigWigs packager when ready.

2. **Discovery copy must say “guild social ladder,” not “UI suite.”** Categories: Guild (+ Roleplay). English summary/description required on CurseForge. Screenshots should show an edge ladder + one ceremony moment — clean-UI culture punishes cluttered storefront shots.

3. **Quiet-by-default is a survival trait for guild addons.** 2025 forum rage at guild invite/whisper spam tooling is a warning: Beef’s officer-gated promotions are a **trust feature**. Never auto-`/g`, auto-invite, or auto-whisper. Local suggestions + officer commit matches both the spec and community consent norms.

4. **Minimap is hostile territory.** Classic players still complain about button rings. Ship one hideable icon (LibDBIcon-class pattern) and treat `/beef` as the real entry. Do not depend on retail Addon Compartment for V1.

5. **Clean UI / Hardcore minimalism is the Classic aesthetic pressure.** Church branding can be gothic and absurd **inside** a small, purposeful panel — not as a permanent center HUD. V1 deferral of ceremonial dashboard theater is correct packaging for this culture.

6. **Accessibility is mostly “test under Blizzard,” not “ship your own shaders.”** Colorblind filters + tooltip text mode exist; rank states need redundant encoding (title text / order / icon), not hue alone. Respect UI scale; avoid photosensitive full-screen flashes by default.

7. **TOC truth for Anniversary:** wiki lists TBC / Anniversary under `_TBC.toc` and Interface examples including **`20506`**, matching the project plan. Flavor-tag CurseForge files for Burning Crusade Classic; confirm Interface with `GetBuildInfo()` each patch.

8. **Streamer-event positioning raises the bar.** Defaults should be stream-safe (no surprise officer notes / alt dumps). Spectacle is content when officers choose it — not ambient chrome.

---

## Decision checklist vs V1 spec

| Spec choice | Community/distribution pressure | Verdict |
|-------------|----------------------------------|---------|
| Officer+ approve/reject | Anti-automation / anti-spam culture | Keep; advertise it |
| Per-character SavedVariables | Privacy / bloat fears | Keep; bound any roster caches |
| `/beef` + minimap | Minimap pollution complaints | Keep both; hide option soon |
| Deferred ceremony dashboard | Clean-UI trend | Keep deferred |
| BeefNet sync | Trust / “what does it send?” | Document plainly on CF/Wago |
| No combat assistance | Classic ToS anxiety | State in Summary line 1 |

---

## Packaging backlog (non-code research → future work)

When implementation packaging starts (outside this research track):

- [ ] CurseForge project draft: name, 400×400 logo, Guild/Roleplay categories, English description
- [ ] Wago project + `X-Wago-ID` in TOC
- [ ] `.pkgmeta` + packager Action secrets
- [ ] Screenshot set: ladder, suggestion toast, officer approve (clean backgrounds)
- [ ] Notes field: `/beef` + one-line purpose + “does not automate gameplay”
- [ ] Colorblind QA pass on rank color tokens
- [ ] Streamer quiet setting (addon-level), even if client streamer APIs differ

---

## What this track deliberately did not cover

- Ace3 / LibDBIcon implementation details (other library docs)
- BeefNet protocol performance
- Art direction / texture production
- Classic+ rumor port beyond TOC suffix notes
