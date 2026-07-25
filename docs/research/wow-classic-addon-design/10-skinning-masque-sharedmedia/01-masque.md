# Masque — Button Skinning Engine

**Last updated:** 2026-07-25  
**Primary sources:** [WowAce Masque](https://www.wowace.com/projects/masque), [CurseForge Masque](https://www.curseforge.com/wow/addons/masque), [GitHub SFX-WoW/Masque](https://github.com/SFX-WoW/Masque), [Wiki / Skin List](https://github.com/SFX-WoW/Masque/wiki/Skin-List), [API_VERSION](https://github.com/SFX-WoW/Masque/wiki/API_VERSION), [WoWInterface Masque](https://www.wowinterface.com/downloads/info12097-Masque.html).

---

## 1. What it is

[Masque](https://www.wowace.com/projects/masque) (StormFX; originally ButtonFacade by JJ Sheets) is a **library-style skinning engine for button-based addons**. It does **not** skin the default Blizzard UI by itself — another addon must opt in via Masque’s LibStub API ([WowAce overview](https://www.wowace.com/projects/masque); [legacy note that Masque does not support the default interface alone](https://legacy-wow.com/mop-addons/masque/)).

Features called out by the project:

- LibStub-accessible API, group-based skinning, independent SavedVariables
- Support for most button types/regions and third-party skins
- Load-on-demand options (`/msq`, `/masque`), global / per-addon / per-group settings
- Skin, Color, Gloss, Shadow options; profiles (per-spec profiles noted as **Retail only**) ([WowAce](https://www.wowace.com/projects/masque), [GitHub README](https://github.com/SFX-WoW/Masque))

Scale: multi-million downloads across mirrors; project ID 13592; still releasing in 2026 ([CurseForge files](https://www.curseforge.com/wow/addons/masque/files/all), [WowAce](https://www.wowace.com/projects/masque)).

---

## 2. Classic / TBC Anniversary support

Official packaging publishes separate game flavors, including **Classic**, **Classic TBC**, MoP Classic, Titan Reforged Classic, and Retail ([CurseForge Masque files](https://www.curseforge.com/wow/addons/masque/files/all)).

WoWInterface compatibility list historically includes Classic, Cataclysm Classic, WOTLK, and TBC patch lines; release notes for **12.0.5** (May 20, 2026) cite Interface updates including **Burning Crusade Classic: 20505** ([WoWInterface Masque](https://www.wowinterface.com/downloads/info12097-Masque.html)).

Church of Beef V1 planning uses **Interface 20506** for TBC Anniversary — treat Masque’s published Interface stamp as nearby and verify against the current Masque Classic TBC file at ship time (one-point Interface drift is normal across addon releases).

Private-server / older forks exist (e.g. [bkader/Masque-WoTLK](https://github.com/bkader/Masque-WoTLK)) — useful history, **not** the Anniversary install path.

---

## 3. Mental model

| Piece | Role |
|-------|------|
| **Masque core** | Engine + options UI + default skin(s) |
| **Consumer addon** | Calls `GetGroup` → `AddButton` → `ReSkin` on its own buttons |
| **Skin addon** | Separate folder (e.g. `Masque_Caith`) that registers a skin table |

Users pick skins in Masque’s GUI. Skin authors declare compatibility via `API_VERSION` on the skin table ([API_VERSION wiki](https://github.com/SFX-WoW/Masque/wiki/API_VERSION)).

Addon authors can soft-detect Masque with the optional LibStub form:

`LibStub("Masque", true)` → returns library + version, or nil if absent ([API_VERSION](https://github.com/SFX-WoW/Masque/wiki/API_VERSION)).

Typical consumer flow (ecosystem convention, not a Beef implementation):

1. Resolve Masque via LibStub (optional).
2. `GetGroup("AddonName", "GroupName")` for a settings bucket.
3. `AddButton(frame, regionMap)` mapping Icon / Normal / Pushed / Border / HotKey / Count / etc.
4. `ReSkin()` when skin or membership changes.

Region keys commonly documented in skin/default tables include Backdrop, Icon, Normal, Pushed, Disabled, Flash, HotKey, Count, Border, Cooldown (see Default-skin discussions and [bkader Default.lua reference](https://github.com/bkader/Masque-WoTLK/blob/main/Masque/Skins/Default.lua) for historical structure).

---

## 4. Popular skin packs (Classic-relevant)

StormFX maintains a family of skins as separate projects — same author as Masque, active Classic tags on GitHub:

| Skin | Notes | Links |
|------|-------|-------|
| **Caith** | Larger Apathy-inspired look; very common download | [WowAce Caith](https://www.wowace.com/projects/masque-caith), [GitHub Masque_Caith](https://github.com/SFX-WoW/Masque_Caith) |
| **Apathy** | Minimal / recessed | [WowAce Apathy](https://www.wowace.com/projects/masque-apathy), [SFX-WoW org](https://github.com/SFX-WoW) |
| **Serenity, Onyx, Cirque, Entropy** | Additional StormFX skins, still listed on WowAce action-bars catalog | [WowAce action bars listing](https://www.wowace.com/addons/action-bars) |
| **Community / suite skins** | FlatSquares-style minimal; suite-matching ornate skins | Browse [Skin List](https://github.com/SFX-WoW/Masque/wiki/Skin-List) (wiki notes list may lag) |

Historical name: **ButtonFacade** skins; Masque is the successor API ([Warmane forum discussion](https://forum.warmane.com/showthread.php?t=392895) illustrates community migration language).

**Important:** Masque skins theme *buttons that opted in*. They do not replace panel chrome for a social ladder window. For Church of Beef’s V1 ladder frame, Masque is mostly irrelevant unless V2 adds icon grids that want user theming.

---

## 5. Implications for Church of Beef

| Question | Answer |
|----------|--------|
| Hard dependency for V1? | **No.** Spec §10: plain Classic frames; missing media falls back. |
| Soft optional later? | Only if V2 exposes Masque-aware **icon buttons** (ceremony shortcuts, Gora result chips). Ladder rows are list UI, not action buttons. |
| Ship a custom Masque skin? | Optional V2+ vanity pack (`Masque_ChurchOfBeef`) — never required to use the addon. |
| ElvUI users | They already live in a skinned world; Beef should **not** fight Masque/ElvUI for global chrome — unique frame name + own backdrop ([sibling visual language note](../03-visual-language-reference.md)). |

---

## 6. Sources

- [Masque — WowAce](https://www.wowace.com/projects/masque)
- [Masque — CurseForge](https://www.curseforge.com/wow/addons/masque)
- [Masque — GitHub](https://github.com/SFX-WoW/Masque)
- [Masque Skin List](https://github.com/SFX-WoW/Masque/wiki/Skin-List)
- [Masque API_VERSION](https://github.com/SFX-WoW/Masque/wiki/API_VERSION)
- [Masque — WoWInterface](https://www.wowinterface.com/downloads/info12097-Masque.html)
- [Masque: Caith — WowAce](https://www.wowace.com/projects/masque-caith)
- [bkader/Masque-WoTLK](https://github.com/bkader/Masque-WoTLK) (historical backport only)
