# HUD Atlas & Urgency Without Clutter

**Last updated:** 2026-07-25  
**Audience:** Designers deciding where Church of Beef may appear relative to combat UI.

---

## 1. The modern Classic combat stack (Anniv baseline)

Anniversary roundups treat a small set of combat tools as the default “serious” stack: boss mods ([BigWigs](https://www.curseforge.com/wow/addons/big-wigs) or [DBM](https://www.curseforge.com/wow/addons/deadly-boss-mods)), [WeakAuras](https://www.curseforge.com/wow/addons/weakauras-2), [OmniCC](https://www.curseforge.com/wow/addons/omni-cc), nameplates ([Plater](https://www.curseforge.com/wow/addons/plater-nameplates)), plus optional aura/proc helpers ([ClassicAuraDurations](https://www.curseforge.com/wow/addons/classicauradurations), [ClassicSpellActivations](https://www.curseforge.com/wow/addons/classicspellactivations)) ([Overgear — TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/), [Playhub — Best Addons for TBC Classic Anniversary](https://playhub.com/blog/wow-anniversary/best-addons-873130)).

Advice repeated across guides: **start small** (boss mod + cooldown readability + nameplates) and keep the setup clean so reaction time stays high ([Overgear combat section](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)).

---

## 2. Screen-zone atlas (community convention)

Competitive UIs converge on a shared “HUD atlas.” Deviate and you fight muscle memory.

| Zone | Conventional content | Urgency |
|------|----------------------|---------|
| **Top-center** | BigWigs / DBM bars & raid-style warnings | Highest — reserved for fight-critical cues |
| **Around character / lower-center** | Action bars, class resources, proc icons (WA / PRD-style) | High — glance-down combat loop |
| **Center (world)** | Character, target, ground effects | Sacred — large persistent panels are a faux pas |
| **Upper corners** | Target casts, threat meters, some meters | Medium |
| **Edges / nameplates** | Plates, floating combat text | Ambient combat |
| **Lower corners / chat / minimap** | Social, bags, quest, guild tools | Low combat priority |

UI iteration writeups reinforce the same lesson: players constantly juggle timers; splitting eyes across four distant corners fails; **important combat info migrates toward the character**, while clutter and novelty chrome get purged ([Medium — Learning UI design through World of Warcraft](https://medium.com/@tjfroll/learning-ui-design-through-warcraft-c0ecfb825be1)).

**Rule for social addons:** live like chat / minimap / guild tools — **corners and opt-in panels**, not top-center boss lanes or lower-center rotation clusters. Deep-research synthesis for this track concurs: non-urgent guild content should not park in upper-center, dead-center, or lower-center combat lanes (see [`.raw/combat-hud-deep.md`](.raw/combat-hud-deep.md)).

---

## 3. Urgency channels (visual hierarchy)

Boss mods and WA packs teach a layered urgency model:

| Tier | Typical channels | Examples |
|------|------------------|----------|
| **Lethal / personal** | Center text / flash + distinctive sound + timer bar | Soak / run / stop-cast cues (DBM/BigWigs) |
| **Dangerous soon** | Bar + optional sound | Ability landing in N seconds |
| **Informational** | Bar or icon only | Next phase timer, soft reminders |
| **Passive enrichment** | Numbers on existing widgets | OmniCC digits on buttons |

DBM’s public positioning emphasizes **glanceability** and personal actionability: fight info that is “easy to process at a glance,” focused on “what’s happening to you, and what YOU need to do about it” ([DBM on CurseForge](https://www.curseforge.com/wow/addons/deadly-boss-mods)). BigWigs markets a **modular, lightweight, non-intrusive** approach ([BigWigs GitHub](https://github.com/BigWigsMods/BigWigs); [Legacy-WoW BigWigs listing](https://legacy-wow.com/tbc-burning-crusade-classic-wow-addons/bigwigs-bossmods/)). Community lists often frame BigWigs as the cleaner/less intrusive alternative preferred by some experienced raiders ([MMOEXP TBC Anniversary addons](https://www.mmoexp.com/News/best-wow-tbc-anniversary-addons-and-how-to-set-them-up.html)).

### Color vocabulary (steal carefully)

WoW players already treat color as urgency language (combat HUD deep research + threat-plate conventions):

| Color | Combat meaning | Social-addon implication |
|-------|----------------|--------------------------|
| Red / red-orange | Lethal / aggro / must act | Do **not** use for routine church events |
| Yellow / orange | Caution / soon | Rare “something starting” at most |
| Green | Safe / ready / off CD | Fine for “good news” standing gains |
| Gold / purple | Reward / rare | Strong fit for promotions / Prophet bestowal |
| Blue / white / gray | Neutral info | Default for ladder chatter |

Using red for “guild toast” trains ignore-or-panic; it also collides with threat-plate red and DBM lethality cues ([ThreatClassic2](https://www.curseforge.com/wow/addons/threatclassic2), [DBM](https://www.curseforge.com/wow/addons/deadly-boss-mods)).

---

## 4. Sound vs visual

| Channel | Combat HUD norm | Church of Beef implication |
|---------|-----------------|----------------------------|
| **Visual** | Default for most timers | Default for toasts / ladder changes |
| **Audio** | Paired with high-stakes boss cues; short & distinctive | Opt-in; never compete with voice / boss sounds by default |
| **Text in chat** | Raid warnings (Blizzard) for shared calls | Spec already uses throttled **guild chat** for promotions — correct social channel |

Overgear notes that group-content addons succeed by providing **clear visual and audio cues that reduce mistakes** — that is the combat job, not Beef’s ([Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)).

---

## 5. Clutter anti-patterns (what clean UIs reject)

Drawn from Anniversary “start clean” guidance ([Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)), UI iteration lessons ([Medium Froehlich](https://medium.com/@tjfroll/learning-ui-design-through-warcraft-c0ecfb825be1)), and this track’s deep research:

1. **Permanent chrome for momentary events** — alerts should fade; residue is clutter.
2. **Center-screen parking** for non-lethal content.
3. **Multiple simultaneous popups** instead of batched / throttled notices.
4. **Decorative HUD** (ovals, gradients, novelty shapes) that reduce bar readability.
5. **Competing for the boss-bar anchor** during pulls.
6. **Spam audio** that desensitizes real warnings.
7. **Dense spreadsheet panels** as always-on combat overlays (fine for out-of-combat settings).

---

## 6. Glanceable vs attentive

- **Glanceable (<~100ms):** color, icon, short number, brief pulse — the combat HUD language.
- **Attentive (seconds):** sentences, lore, officer queue detail — fine **out of combat** and in `/beef` panels.

V1 toasts ([design spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) should stay glanceable (icon + short line). Officer review UI can be attentive — it is not a combat overlay.

---

## Sources

- [Overgear — TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/) (Mar 2026)
- [Playhub — Best Addons for TBC Classic Anniversary](https://playhub.com/blog/wow-anniversary/best-addons-873130) (Jan 2026)
- [DBM — CurseForge](https://www.curseforge.com/wow/addons/deadly-boss-mods)
- [BigWigs — GitHub](https://github.com/BigWigsMods/BigWigs)
- [Medium — Learning UI design through World of Warcraft](https://medium.com/@tjfroll/learning-ui-design-through-warcraft-c0ecfb825be1) (2020)
- [`.raw/combat-hud-deep.md`](.raw/combat-hud-deep.md) — Parallel deep research
