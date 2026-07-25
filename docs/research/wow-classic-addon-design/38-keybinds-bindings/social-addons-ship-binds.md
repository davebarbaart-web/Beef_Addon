# Should social addons ship keybinds?

Short answer for guild / ladder / standing tools: **usually no defaults; optionally one unbound Bindings.xml row for power users.**

## What “shipping a bind” can mean

| Pattern | Example | Conflict risk |
|---------|---------|---------------|
| A. Unbound Bindings.xml action | Key Bindings UI row, empty key | Low — player opt-in |
| B. Bindings.xml with `default=` | Fresh install claims `SHIFT-F` | Medium–high |
| C. Login `SetBinding*` + `SaveBindings` | Addon writes user’s bind set | High — permanent steal |
| D. Always-on `SetOverrideBinding*` | Silent steal until clear/hide | High while active |
| E. Modifier+click on items/links | Gargul `ALT_CLICK` auction | Medium — but scoped to loot UX |
| F. No binds; slash + minimap | Spec’d Beef V1 | Lowest |

## Cousin evidence

### Gargul (loot / raid workflow)

Gargul **does** ship default *item* hotkeys:

| Action | Default |
|--------|---------|
| Roll out / Auction | `ALT_CLICK` |
| Award | `ALT_SHIFT_CLICK` |
| Mark DE | `CTRL_SHIFT_CLICK` |

Configurable under `/gl` → Shortcut Keys; onboarding (`/gl start`) walks players through hotkeys ([Gargul GitHub README](https://github.com/papa-smurf/Gargul)).

That is justified: loot masters click items constantly. It is **not** a keyboard Bindings.xml toggle for a guild standing UI, and it still collides with other modifier+click consumers — hence the settings escape hatch.

### Church of Beef (guild standing / ladder)

V1 product surfaces are:

- `/beef` → main frame ([design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10)
- Minimap / LibDBIcon toggle ([track 28](../28-minimap-addon-compartment/))
- Chat spectacle / toasts — not hotkey-driven

There is no raid-loot click loop that requires a factory chord. Pattern **F**, optionally **A** later.

### Combat / utility addons (contrast only)

Mount, bar, and click-cast addons live on patterns C/D/E by necessity. Copying them for a social tool is a category error — Beef is an **edge** tool that must not compete with center-stack input ([00 implications](../00-church-of-beef-implications.md)).

## Community hygiene (what players expect)

- Key Bindings UI sprawl is already noisy; every addon header with three defaults makes it worse.
- Players who hide minimap buttons still expect **slash** to work ([track 28](../28-minimap-addon-compartment/) hygiene notes) — that is the discoverability backstop, not a hotkey.
- When something “eats” a bind, bisect culture blames the newest non-essential addon first (Clique support history).

## Recommendation summary for social authors

1. Prefer slash + launcher icon.
2. If you add Bindings.xml, ship **zero** `default=` attributes.
3. Never silently `SetBinding` / `SaveBindings` on first run.
4. Reserve overrides for true modals you fully own and clear.
5. Document any optional bind under Key Bindings UI + `/help`, not as required setup.
