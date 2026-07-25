# Deep research export — Combat HUD / alerts
Run: `trun_91f36069f0964480adb0ade7702c29e3`
URL: https://platform.parallel.ai/play/deep-research/trun_91f36069f0964480adb0ade7702c29e3

---

## 1_reference_addons_how_each_one_handles_the_same_ux_problems

### OmniCC — "Add nothing new to the screen, just enrich what is already there"
- *Source:* CurseForge listing, legacy-wow.com [OmniCC entry]
- **Pattern:** OmniCC overlays a numeric countdown text on existing action-bar buttons that are on cooldown. It does *not* add a new frame, does not claim screen real estate, and does not draw on a dedicated area.
- **What it teaches a social addon:**
  - Reuse existing UI elements when possible — players tolerate overlays on familiar frames more than they tolerate new floating panels.
  - Numeric text is the lowest-cost countdown representation; do not invent a new widget if a number will do.
  - Default to *augmenting* existing UI rather than introducing a new region.

### TellMeWhen — "Grouped icons, state-driven color"
- *Source:* CurseForge TellMeWhen (legacy port to WotLK/TBC)
- **Pattern:** TellMeWhen organizes tracked cooldowns/buffs/debuffs into *configurable icon groups* (grids/rows). Each icon's appearance changes by state — ready, on cooldown, missing buff — using color, alpha, or glow.
- **What it teaches:**
  - Use **state, not new frames**, to convey status: color, alpha, glow, animation.
  - Group items logically (cooldowns together, buffs together) so the eye learns one region per category.
  - Let the user move and resize groups; configurability is expected for "anchor" UI.

### WeakAuras — "Trigger + Display" framework
- *Source:* CurseForge WeakAuras; Wago.io (community aura library); GitHub WeakAuras/WeakAuras2
- **Pattern:** Every "aura" has a **trigger** (event/combat state) and a **display** (texture, bar, icon, text, sound). Triggers can be buff presence, health threshold, combat event, custom conditions. Displays can mix (icon + progress bar + countdown text). WeakAuras absorbed Power Auras' and TellMeWhen's use cases into one system.
- **What it teaches:**
  - Separate *condition* from *presentation* — designers can iterate visuals without rewriting logic.
  - Provide **shared textures** (font, bar skins) via a media library so users expect consistent visual language.
  - The whole UI is composed of three building blocks: **icon, bar, text**. Anything beyond those (a nameplate icon, a center-screen banner) is rare and reserved for high-importance events.

### BigWigs — "Modular, lightweight, low-CPU"
- *Source:* BigWigsMods/BigWigs GitHub README; CurseForge BigWigs
- **Stated goals (verbatim):** *"a high framerate is important. We understand that every extra frame matters… the memory/CPU footprint of BigWigs is the lowest of all boss mod addons."* Modules are per-encounter; a "boss mod add-on" is split into a Core + many small encounter modules.
- **Visual pattern:** Bars and on-screen text appear in dedicated anchor zones (often top-of-screen / upper area). Sounds play for high-importance events. Some messages use flashing/color cues for lethality.
- **What it teaches:**
  - **High-importance events → audio + visual** (dual-channel). Lower-importance → visual only.
  - **Performance ceiling matters.** If your addon causes frame drops in a 25-man raid, the community rejects it. A non-combat social addon should be cheap by default.
  - Modular/per-event architecture keeps the user's UI lean (only the parts they opt into load).

### DBM ("Deadly Boss Mods")
- *Source:* CurseForge DBM
- **Stated design intent:** *"DBM aims to focus on what's happening to you, and what YOU need to do about it."*
- **Visual pattern:** Center-screen "yells" for lethal events, bars in a dedicated anchor (upper area), sounds for major cues, "flash"/screen-shake for imminent-death-level warnings.
- **What it teaches:**
  - Differentiate **lethality tiers** by visual channel: lethal → screen flash/shake/yell; dangerous → bar + sound; informational → bar/text only.
  - "Tell the player what *they* need to do" — avoid generic "something happened" alerts.

### Power Auras (legacy) / Personal Resource Display (PRD) — Resource/proc alternatives
- *Source:* Power Auras (WoWInterface/CurseForge, last updated during Mists era); PRD (CurseForge)
- **Pattern:** PRD mimics the Retail "Personal Resource Display" frame that Blizzard built into the retail UI: a small panel slightly below the center-of-screen showing your class's primary alt-resource (soul shards, holy power, combo points, chi, etc.) as discrete pips. Power Auras overlaid a colored icon + animation on the player's character when a buff/proc was active.
- **What it teaches:**
  - Place "primary resource" feedback **near the character** so glance-down works.
  - **Discrete pips** beat continuous bars for small-integer resources (combo points, holy power).
  - Use **transient animations** (a glow, a flash) for "you just gained X" — not a permanent icon.

### Nameplate threat-coloring: TidyPlates / Tidy Plates: Threat Plates / ThreatPlates / PlatesImprovements
- *Source:* Tidy Plates (CurseForge), Tidy Plates: Threat Plates (CurseForge), PlatesImprovements
- **Pattern:** Replaces Blizzard's default nameplate rendering. Color the nameplate border by **threat state** (aggro = red, caution = yellow/dark, low = green/blue). Optional health bar, target highlight, class-color text.
- **What it teaches:**
  - **Color alone is the primary signal**; the player's eye learns the threat-color code (red/yellow/green) the same way it learns WoW's own quality colors.
  - Keep nameplates small and at the **edges** so they don't crowd the screen.
  - Threat state is a *binary or tri-state* (have aggro / pulling / losing). Don't shade by percentage — players don't read it.

### Arena frames: Gladius / sArena
- *Source:** Gladius (legacy-wow.com / CurseForge), sArena (CurseForge)
- **Pattern:** Dedicated frames for arena opponents: class icon, spec, cooldown countdowns, dr (diminishing returns) timers. Placed in a predictable corner (usually upper-center or upper-mid), readable at a glance in a fast-moving fight.
- **What it teaches:**
  - In PvP, **information density at the periphery** is acceptable *because* the player must consume it between GCDs. For a social addon, peripheral info density should be lower — events are less time-critical.
  - Class/spec identification by **icon** (universally recognized) rather than text.

---

---

## 2_universal_ux_conventions_across_all_these_addons

These are the conventions that have emerged from a decade of community iteration:

### A. Screen Zones (the "HUD atlas")
Every competitive UI respects these conventions; deviating is a *faux pas* that breaks muscle memory.

| Zone | Conventional content | Why |
|------|---------------------|-----|
| **Top-center** | Boss warnings, BigWigs/DBM bars, raid warnings | High-priority, glanceable, foveal |
| **Upper corners** | Threat meters, target cast bars, minimap alerts | Peripheral but in eye-line |
| **Center** | Character + target (default Blizzard) — *no addon should park large content here* | Center is reserved for the character and combat |
| **Lower-center** | Action bars, class resources, player buffs | Near fingers, near focus |
| **Lower corners** | Bags, durability, chat | Frequently consulted, low priority |
| **Edges/periphery** | Floating combat text, nameplates, minimap | Off-focus; safe for ambient info |

**Rule for a social addon:** **Do not place anything in the upper-center, center, or lower-center zones unless it's the lowest-priority ambient info.** Social/guild communication is by definition *non-urgent*, so it should live in the corners (especially lower-right / lower-left / upper-corners).

### B. Color Urgency Hierarchy (universally understood)
| Color | Meaning (WoW convention) | When to use it |
|-------|--------------------------|----------------|
| **Red / red-orange** | Lethal, must act now | Only for life-or-death warnings (e.g., DBM center-screen flash) |
| **Yellow / orange** | Caution, action needed soon | "Boss enrage in 10s," debuff expiring |
| **Green** | Safe / ready / healthy | "Ability is off CD," "no threat" |
| **Blue** | Informational / neutral | Chat, system messages |
| **White / gray** | Passive info | Loot rolls, system chatter |
| **Gold / purple** | Reward / achievement | Rare drops, achievements |

**Implication for a social addon:** If you use *red* for "guild event starts in 1 minute," you are borrowing a color that the player's brain is hardwired to interpret as "die now." Players will desensitize to it, or worse, become anxious. Use **gold** for "reward/achievement" tones (rare drop, achievement) and **neutral colors** (teal, soft purple, white) for routine guild chatter. Reserve red for actual emergencies (raid ready check, world boss incoming, etc.).

### C. Sound vs Visual
| Channel | Best for |
|---------|----------|
| **Audio** | Out-of-sight events (you don't see them, you hear them), time-critical events that can interrupt (rare), and accessibility |
| **Visual only** | Most events — eyes are already on the screen |

In combat HUD addons, audio cues are *added* to high-stakes events (BigWigs plays a sound for incoming AoE). In social/guild contexts, **audio should be opt-in and minimal** because chat is the dominant audio channel (voice, music, dialogue from NPCs).

### D. Glanceable vs Attentive
- **Glanceable** (peripheral vision, < 100 ms): color changes, icons, light pulses, a number changing.
- **Attentive** (focused reading, seconds): full sentences, paragraphs, lore, tooltips.

BigWigs/DBM alerts are *glanceable*. Addons that demand attentive reading during combat (e.g., quest text) are universally rejected. For a social addon, anything that requires *reading* more than a word or two is fine — players are not in combat — but everything should still be **skimmable**.

### E. Anchor Philosophy
Every customizable addon uses an anchor model: pick a region (e.g., "upper-left of minimap," "center-screen above player"), drag a grip to position, lock it. The convention is **always allow per-user positioning**. Default anchors are predictable (corners) and small.

### F. Sound Design (cross-reference: BigWigs, DBM, WeakAuras)
- Sound files are **short** (<2s), **distinctive** (so they don't collide), and **categorized** (warning vs info vs success).
- Default volume per category.
- "Mute until I log in" / "do not disturb" toggles are standard.

---

---

## 3_retail_vs_classic_tbc_capabilities

| Capability | Retail | Classic / TBC Classic |
|------------|--------|----------------------|
| **Built-in Personal Resource Display** (Blizzard PRD frame) | Native since Shadowlands | **Not present**; recreated by `PersonalResourceDisplay` addon |
| **Built-in Action Bar changes** (mouseover, conditionals) | Native since Cataclysm-era | Must be added by addon (e.g., Bartender4) |
| **Blizzard Toast System** (`AddMessageFrame` / BNToast) | Yes, with `BNToastFrame` | Same (limited), but `SendChatMessage` and addon-to-addon channels are more restricted in combat |
| **Compact Unit Frames style for player/target** | Native option | No — must use an addon (e.g., ClassicCompact) |
| **Lua protected call restrictions in combat** | Yes | Same — `SendChatMessage`, hardware events, and most protected APIs blocked in combat |
| **Custom textures via SharedMedia** | Yes | Yes |
| **Ace3 / LibStub ecosystem** | Yes | Yes (same libraries work) |
| **WeakAuras** | Yes | Yes (separate "Classic" release branch on CurseForge & Wago) |
| **BigWigs/DBM** | Both available | Both available, BigWigs explicitly supports TBC Classic |

**Implication for a TBC Classic-targeted social addon:**
- You can rely on the same Lua API surface (Lua 5.1, Ace3, SharedMedia, CallbackHandler-1.0).
- Protected APIs (sending chat, sending mail, etc.) are blocked in combat, so the addon must defer any outgoing communication until combat ends. **Design accordingly.**
- WeakAuras/BigWigs/TMW-style "trigger + display" patterns can be mirrored in your alert logic — even if you don't ship a WeakAuras integration, the *mental model* (event → response) is the same.

---

---

## 4_transferable_principles_for_a_non_combat_social_guild_addon

### What to *borrow* (transferable alert design patterns)

1. **Trigger + Display separation.** Decouple "what happened" (a guild event, a birthday, a chat mention) from "how it's shown" (toast in lower-right, sound, minimap ping). This lets you re-use the same engine for many event types.
2. **Three default anchor regions** that respect WoW's HUD atlas: lower-right corner (for routine info), upper-center (for rare urgent events), lower-center (avoid — busy zone). Provide per-user positioning.
3. **Color urgency tiers.** Use the established vocabulary: green for "good" (event starting), gold for "reward/rare," blue/white for "info," and only use red for things the player genuinely must react to within seconds.
4. **Iconography > text where possible.** A small class icon, a raid icon, a calendar glyph — these are glanceable. Save text for what's actually novel (the message itself).
5. **Throttle / batch.** If 5 guildies greet the player in a row, batch into "5 guild messages — click to view" rather than five separate toasts. BigWigs' bar-stacking ("3 spells expire in 4s") is the model.
6. **Fade / dismiss gracefully.** All combat alerts fade after the moment passes. Social alerts should do the same — no permanent HUD residue.
7. **Sound layering.** Distinct, short, opt-in. Default to muted; let users pick the audio theme.
8. **Status quo: passive until opt-in.** Combat HUD addons are installed by users who want them; a guild addon should be similarly passive by default and customizable from a single config panel.

### What to **avoid** (anti-patterns that compete with combat UI)

1. **Don't park anything in the upper-center "boss warning" zone** unless it is genuinely a life-safety alert. BigWigs/DBM own that zone during combat and any other consumer there is visual noise.
2. **Don't use red or pulsing red for non-lethal events.** It trains the player's brain to ignore actual lethal warnings. Use red **only** for things that demand immediate action.
3. **Don't generate HUD elements that persist when the event is over.** A toast for a guildmate's achievement should disappear in 6–10 seconds, not stick around as a permanent icon.
4. **Don't block the screen center or the player's character.** Even with a "fade out," never anchor anything to the dead-center of the screen for non-combat content.
5. **Don't overlap the player's minimap.** That's a heavily-used zone (clock, queue pops, mailbox, etc.).
6. **Don't spam audio.** Voice-chat already owns audio; competing audio cues desensitize the player.
7. **Don't claim new screen real estate when you can use an existing region.** Reuse lower-right corner / tooltip area where the eye already scans.
8. **Don't override the Blizzard toast system.** If `BNToastFrame` is the right tool for a system message, use it. Custom floating panels are jarring unless they're necessary.

---

---

## 5_recommended_ux_pattern_set_for_church_of_beef_a_non_combat_social_guild_addon

Synthesizing the conventions above, here is a recommended design pattern kit:

### Alert delivery
- **Toast region:** Lower-right (above bags), stacked, oldest at top or bottom. Use `BNToastFrame`-style API where possible for native integration.
- **Anchor:** Default lower-right; allow drag-to-position; lockable; saved per character or per-account.
- **Display lifetime:** ~8 seconds for informational, ~12 seconds for interactive (click-to-open). Fade-out tail of 1s.
- **Color:** Background and accent color chosen by alert type; **never red** unless the alert is critical (e.g., guild bank item withdrawn, mass-teleport ready).
- **Icon:** Always show one icon (event type or guild crest) on the left edge.
- **Sound:** One subtle default per category; opt-in; user-configurable volume per category.

### Trigger model
- **Source event:** guild chat, calendar, achievement feed, mailbox, guild event, recruitment, birthday, anniversary.
- **Filter rules:** keyword/blacklist, do-not-disturb hours, per-channel, per-character.
- **State machine:** None/Queued/Displayed/Clicked/Expired/Suppressed.

### Combat-aware silence
- Detect `InCombatLockdown()` and **defer** any outgoing chat (replies, automated messages, invites) until combat ends.
- Suppress *new* toasts during combat unless they're "raid invitation" or "summons" tier — those still need to appear, but in a less obtrusive form (sound only, or short center-of-screen text that fades fast).

### Config / first-run UX
- Single landing config panel with three presets: "Quiet," "Standard," "Chatty."
- Granular controls behind a "Settings" tab — never require configuration up front.

---

---

## 6_source_list_for_citation_reference

| Source | Used for |
|--------|----------|
| BigWigs GitHub README & Wiki | BigWigs' stated design philosophy (modular, lightweight, low-footprint) and encounter-module architecture |
| BigWimsBoss Mods on CurseForge | BigWigs vs DBM overview, modular download structure |
| Deadly Boss Mods on CurseForge | DBM's "focus on what's happening to you" tagline & UI screenshot |
| WeakAuras on CurseForge / Wago.io | WeakAuras trigger+display model; community aura library at Wago.io |
| TellMeWhen on CurseForge | TMW group-of-icons / state-coloring UI model |
| OmniCC on legacy-wow & CurseForge | OmniCC's "add numbers to existing icons" overlay pattern |
| Personal Resource Display on CurseForge | PRD addon's description (mimics Retail PRD, two bars near character) |
| Tidy Plates / Threat Plates / Tidy Plates: Threat Plates / PlatesImprovements | TidyPlates threat-color rules & color philosophy |
| Gladius on legacy-wow.com & CurseForge | Gladius' enemy-frame design for PvP arenas |
| sArena Reloaded on CurseForge | sArena Reloaded feature list (dr, trinket, CC tracker) |
| Wowhead: "UI Hub" guides & "Addons" guides | Curated UI best practices and zone conventions |
| Medium / d.w. King article "Principles of UI Design in WoW" | General WoW UI principles (field of vision, hierarchy) |
| Reddit r/WoWUI (search results) | Community conventions: "Don't block the screen center," "Don't override blizzard toasts" |
| Blizzard Developer Portal (Game Data APIs) | Confirms Retail has built-in Personal Resource Display and Edit Mode since Shadowlands |
| WoW API Wiki / WoWHead API references | Confirms protected function restrictions in combat (SendChatMessage, hardware events) |

---

---

## 7_tl_dr

- The dominant WoW combat HUD design pattern is: **trigger → small peripheral display → audio cue for important events**. Every addon above follows this.
- Information density is highest in the player's eye-line (top-center, around the character) and lowest at the corners; **don't compete with combat addons in the high-density zones**.
- Color is a vocabulary: **red = lethal, yellow = warn, green = safe, gold = reward, blue/white = neutral**. Use these consistently.
- Sound is opt-in and rare; visuals are the default channel.
- **Throttle and batch**: multiple events into one toast, not five popups.
- For TBC Classic specifically: the Lua API surface is similar to retail but lacks native PRD/Edit Mode, so the social addon will need to draw its own frames and respect protected-in-combat rules (no chat sends, no secure frame manipulation during combat).
- For a social guild addon, the best practice is to live in the lower corners and tooltips, use Blizzard's toast system where possible, never block center screen, and reserve red/gold for genuinely important events.
</answer>
