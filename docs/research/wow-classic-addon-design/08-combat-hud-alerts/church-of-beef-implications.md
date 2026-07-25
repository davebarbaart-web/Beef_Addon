# Implications for Church of Beef

**Last updated:** 2026-07-25  
**Maps to:** [design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §§1–2, 7–8, 10, 14  
**Research base:** notes in this folder + [`.raw/combat-hud-deep.md`](.raw/combat-hud-deep.md)

---

## Verdict

Church of Beef should treat the Classic combat HUD as **occupied territory**. V1 wins by being a **guild / stream social tool**: edge entry (`/beef`, minimap), glanceable toasts, throttled guild-chat spectacle — never a competitor to BigWigs/DBM, WeakAuras, OmniCC, or Plater.

---

## Top insights (actionable)

### 1. Respect the HUD atlas

Anniversary players cluster **boss bars top-center**, **rotation/resources/procs lower-center**, **plates on edges** ([Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/); [hud-atlas-and-urgency.md](hud-atlas-and-urgency.md)). Beef’s main frame and toasts should default to **peripheral** positions (lower corner / near bags / away from WA clusters), movable + clamped as already specified (§10).

### 2. Steal toast discipline, not combat channels

From OmniCC / WA / boss-mod culture:

- **Brief → fade** (≈6–12s for social toasts; no permanent residue)
- **Icon + short line** (glanceable); put paragraphs in `/beef` tabs
- **Throttle / batch** — one promotion toast + one guild-chat line beats spam (aligns with §8.2 / §10)
- **Trigger ≠ display** — scoring events can feed multiple presentations later

Do **not** use center yells, screen flash, or boss-bar style timers for ranks.

### 3. Color: gold for glory, never red for routine

Combat UIs reserve **red** for lethality / aggro ([DBM](https://www.curseforge.com/wow/addons/deadly-boss-mods), threat plates). For Beef:

| Event | Accent |
|-------|--------|
| Promotion / Prophet bestowal | Gold / ceremonial highlight |
| Standing credit / suggestion created | Green or neutral |
| Demotion / excommunication (content) | Distinct but not “you’re about to die” red flash |
| Routine UI chrome | Neutral |

### 4. Sound is opt-in and rare

Boss mods pair audio with wipe-level cues. Default Beef audio: **off or subtle**; never compete with BigWigs/DBM sounds during pulls. Guild chat + visual toast is enough for V1 spectacle (§10).

### 5. Combat-aware silence

Protected/chat constraints and pull noise both argue for:

- Deferring chat-facing automation while in combat when possible
- Suppressing non-critical toasts during boss pulls (queue for after combat), **except** officer-critical flows if ever needed
- Keeping SCORE_EVENT / standing drips out of the HUD entirely (panel + My Standing log)

### 6. Performance culture applies to social addons too

BigWigs markets lightweight modularity ([GitHub](https://github.com/BigWigsMods/BigWigs)). A comedy church addon that stutters in Karazhan will be disabled mid-raid. Prefer event-driven, coarse updates (already in BeefNet policy).

### 7. Explicit non-goals (reinforced by this track)

Do not ship: cooldown managers, resource bars, proc packs, nameplate mods, threat meters, boss timers, WeakAuras dependencies, or anything that “helps play the game” (§§1–2).

### 8. Later phases only: WA-style ceremony spectacle

V2 ceremonial dashboard may borrow **brief centered spectacle then clear** from WeakAuras culture ([weakauras-combat-packs.md](weakauras-combat-packs.md)) — still out of combat, still not in the boss-bar lane. V1 stays toast + guild announce.

---

## Checklist against V1 UI (§10)

| Spec item | Combat-HUD-informed guidance |
|-----------|------------------------------|
| `/beef` + minimap | Correct social entry points |
| Ladder / Standing / Officer tabs | Attentive UI OK — not overlays |
| Toasts (suggestion, rank, Gora/ceremony) | Peripheral, short, non-red, fade |
| Guild-chat promotion line | Best stream-friendly channel; keep throttled |
| Movable + saved position | Essential so users can dodge their WA layout |
| Missing media fallbacks | Same reliability bar as combat addons users trust |

---

## One-line design mantra

**Be OmniCC-humble and BigWigs-quiet: enrich the social layer, never occupy the combat layer.**
