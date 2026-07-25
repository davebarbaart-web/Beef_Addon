# SetBinding vs SetOverrideBinding — caution

Bindings.xml is the *static* path. Lua APIs are for *dynamic* claims. For Beef, both dynamic families are usually the wrong tool.

## Permanent path: `SetBinding*`

Family: `SetBinding`, `SetBindingSpell`, `SetBindingItem`, `SetBindingMacro`, `SetBindingClick` ([Warcraft Wiki — Creating key bindings](https://warcraft.wiki.gg/wiki/Creating_key_bindings)).

Critical behaviors:

- Binding a key that already has an action **unbinds the previous action** on that key ([Warcraft Wiki](https://warcraft.wiki.gg/wiki/Creating_key_bindings)).
- Changes are not durable until `SaveBindings(type)` (`1` account / `2` character) ([Wowpedia SetBinding](https://wowpedia.fandom.com/wiki/API_SetBinding); [NeticSoul ch16](https://github.com/NeticSoul/wow-335a-addon-wiki/blob/main/chapters/ch16-key-bindings.md)).
- There is **no** API to bind “run arbitrary Lua” permanently except via `SetBindingClick` → your Button’s `OnClick` ([Warcraft Wiki](https://warcraft.wiki.gg/wiki/Creating_key_bindings)).
- “Clearing” a `SetBinding` does **not** restore the old action — it empties the key. Restoring means remembering the previous command or rebinding intentionally ([WoWInterface — dynamic key bindings](https://www.wowinterface.com/forums/showthread.php?t=57596)).

**Beef implication:** Never call `SetBinding*` on install/login to “give the user a hotkey.” That permanently displaces bar/macro binds if saved.

## Temporary path: `SetOverrideBinding*`

Family: `SetOverrideBinding`, `SetOverrideBindingSpell`, `SetOverrideBindingItem`, `SetOverrideBindingMacro`, `SetOverrideBindingClick`, plus `ClearOverrideBindings(owner)` ([Warcraft Wiki](https://warcraft.wiki.gg/wiki/Creating_key_bindings)).

Critical behaviors:

- Takes an **owner frame**, a **priority** flag, a key string, and an action.
- Priority overrides beat non-priority overrides; both beat normal Key Bindings UI bindings ([Warcraft Wiki](https://warcraft.wiki.gg/wiki/Creating_key_bindings); [NeticSoul ch16](https://github.com/NeticSoul/wow-335a-addon-wiki/blob/main/chapters/ch16-key-bindings.md)).
- Intended for temporary / contextual steals; community guidance is “use override + clear to get reversible bindings” ([WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=57596)).
- Modern hygiene example: TOGTools documents binding via `SetOverrideBindingClick` on a private owner so user saved binds are never overwritten, with `GetBindingAction` heads-up on conflict ([CurseForge TOGTools changelog excerpt](https://www.curseforge.com/wow/addons/togtools/files/8444187)).
- MountMe-style addons clear and re-apply overrides on `UPDATE_BINDINGS` / login so they track the user’s real DISMOUNT key ([MountMe Addon.lua](https://github.com/phanx-wow/MountMe/blob/master/Addon.lua)) — still a steal while active.

**Beef implication:** An always-on “press X to open Beef” override is still stealing X from bars/Clique for the whole session. Only consider overrides for short-lived modal UIs (none planned in V1), and always `ClearOverrideBindings` when done.

## Combat lockdown

Setting/clearing bindings from insecure code is **protected in combat** ([Warcraft Wiki](https://warcraft.wiki.gg/wiki/Creating_key_bindings); [Wowpedia SetBinding](https://wowpedia.fandom.com/wiki/API_SetBinding)). In-combat rebinding requires restricted environment / SecureHandler paths (`frame:SetBinding*` / state drivers) — complexity Beef does not need for a guild ladder.

If any future code applies binds, defer to `PLAYER_REGEN_ENABLED` (TOGTools pattern).

## Decision matrix (social UI)

| Goal | Prefer | Avoid |
|------|--------|-------|
| Optional user-assigned toggle | Unbound `Bindings.xml` row | `default=` chords |
| Open UI | `/beef` + minimap | `SetBinding` on login |
| Modal temporary steal | `SetOverrideBinding*` + clear | Saving overrides via `SetBinding` |
| Never touch keyboard | Slash + LibDBIcon only | Both API families |

V1 recommendation lives in [beef-recommendation.md](beef-recommendation.md): **neither path**.
