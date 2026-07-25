# Track 38 — Keybinds & binding conflicts

**Track id:** `38-keybinds-bindings`  
**Last updated:** 2026-07-25  
**Sole focus:** How Classic addons declare and steal key/mouse bindings (`Bindings.xml`, `SetBinding*`, `SetOverrideBinding*`), how that collides with click-casting stacks (Clique et al.), and whether a social guild tool should ship any binds at all.  
**Out of scope:** Slash-command UX (track 22), minimap/LDB launchers (track 28), secure/taint combat UI (track 29) except where binding APIs are protected. No addon implementation in this folder.

## Product truth (from V1 spec + plan)

| Locked / planned | Value |
|------------------|-------|
| Primary entry | `/beef` opens / toggles main frame |
| Parallel entry | Minimap button → same frame |
| Combat HUD | Explicitly out of scope — edge social tool |
| Keybinds | **Not** in V1 success criteria |

Sources: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10 / success criteria; [track 22](../22-slash-commands-ux/); [track 28](../28-minimap-addon-compartment/).

## Index

| Note | Covers |
|------|--------|
| [bindingxml-mechanics.md](bindingxml-mechanics.md) | `Bindings.xml` load rules, headers, `default=`, Key Bindings UI |
| [setbinding-vs-override.md](setbinding-vs-override.md) | Permanent `SetBinding*` vs reversible `SetOverrideBinding*`; combat lockdown |
| [click-cast-conflicts.md](click-cast-conflicts.md) | Clique / mouse-chord / unit-frame click conflicts |
| [social-addons-ship-binds.md](social-addons-ship-binds.md) | Cousin patterns (Gargul click-hotkeys vs keyboard Bindings.xml) |
| [beef-recommendation.md](beef-recommendation.md) | Concrete V1 / V2 Beef policy |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **V1 needs zero default keybinds.** Spec already locks discoverability to `/beef` + minimap. Shipping a `default="…"` chord is pure conflict surface with action bars, Dominos/Bartender, and Clique.

2. **`Bindings.xml` is optional power-user chrome, not an entry strategy.** It is the only clean way onto Blizzard’s Key Bindings UI ([Creating key bindings — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Creating_key_bindings)). If Beef ever ships a toggle binding, leave it **unbound** (no `default=`).

3. **Never use `SetBinding*` to “claim” a key for a social UI.** `SetBinding` **unbinds** whatever was previously on that key ([same wiki](https://warcraft.wiki.gg/wiki/Creating_key_bindings); [WoWInterface thread](https://www.wowinterface.com/forums/showthread.php?t=57596)). That is hostile behavior for a guild ladder addon.

4. **`SetOverrideBinding*` is still a steal — just a temporary one.** Overrides sit above normal binds; they are the right tool for *modal* tools that clear on hide, not for always-on social toggles. Priority overrides fight other addons’ overrides ([NeticSoul ch16](https://github.com/NeticSoul/wow-335a-addon-wiki/blob/main/chapters/ch16-key-bindings.md)).

5. **Click-cast stacks own mouse chords.** Clique binds mouse/keyboard combos over unit frames and warns that Clique bindings override frame defaults ([Wago Clique docs](https://addons.wago.io/addons/clique)). Healers deliberately reuse the same keys for bars + Clique. Beef must not ship `BUTTON*` or modifier+click keyboard defaults.

6. **Loot cousins ≠ social cousins.** Gargul ships *item* modifier-clicks (`ALT_CLICK` etc.), configurable under Shortcut Keys ([Gargul README](https://github.com/papa-smurf/Gargul)) — justified by raid loot workflow. A standing ladder has no equivalent need.

## Boundary with sibling tracks

| Track | Owns |
|-------|------|
| [22-slash-commands-ux](../22-slash-commands-ux/) | `/beef` verbs, help, Tab completion |
| [28-minimap-addon-compartment](../28-minimap-addon-compartment/) | LibDBIcon / collectors as the non-keyboard launcher |
| [29-taint-secure-ui](../29-taint-secure-ui/) | Combat lockdown / secure templates (bindings are protected in combat) |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Warcraft Wiki / Wowpedia / AddOn Studio / WoWInterface / cousin READMEs over listicles.
