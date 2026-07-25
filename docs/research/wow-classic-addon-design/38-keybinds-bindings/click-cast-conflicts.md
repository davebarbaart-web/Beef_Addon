# Click-cast & mouse-chord conflicts

Church of Beef will sit in the same addon folders as healers’ Clique configs and everyone’s bar mods. Binding policy must assume that stack is present.

## What Clique owns

[Clique](https://www.wowinterface.com/downloads/info5108-Clique.html) (Classic-compatible builds exist) lets players bind **any mouse or keyboard combination** to spells/macros on unit frames and in the world ([Wago Clique](https://addons.wago.io/addons/clique); [CurseForge Clique](https://www.curseforge.com/wow/addons/clique)).

Documented player-facing truths:

- Bindings are set from the spellbook Clique tab or `/clique`; **cannot change binds in combat** (API limits) ([Wago](https://addons.wago.io/addons/clique)).
- Clique bindings **override** whatever was already on the frame (including default target / unit menu). Authors tell users to rebind those actions if they overwrite them ([Wago](https://addons.wago.io/addons/clique)).
- Players intentionally **reuse** the same keys for action-bar damage and Clique heals to save keybind slots ([WoWInterface Clique comments](https://www.wowinterface.com/downloads/info5108-Clique.html) — Midnight mouseover discussion).

That reuse means a “harmless” `SHIFT-R` or `BUTTON4` default from a social addon is not harmless — it is competing for scarce dual-use chords.

## Conflict surfaces relevant to Beef

| Surface | Why it hurts |
|---------|----------------|
| `BUTTON1` / `BUTTON2` (+ mods) | Core click-cast and unit-frame targeting/menu |
| Extra mouse buttons (`BUTTON3`–`5`) | Common Clique / bar overflow binds |
| Modifier+letter that healers dual-use | Same key on bars + Clique hovercast |
| Priority `SetOverrideBinding*` | Sits above Clique/normal binds while active ([NeticSoul stacking](https://github.com/NeticSoul/wow-335a-addon-wiki/blob/main/chapters/ch16-key-bindings.md)) |
| Permanent `SetBinding` of those keys | Unbinds the previous owner until the player fixes Key Bindings UI |

Historical Clique support threads are full of “another addon is conflicting” bisect advice ([WoWInterface Clique archive](https://www.wowinterface.com/forums/archive/index.php/t-7106.html)) — social tools that steal clicks get blamed fast.

## Clique vs global keybinds vs frame clicks

Three different mechanisms, one user experience:

1. **Global key bindings** — Key Bindings UI / Bindings.xml / `SetBinding*` — fire regardless of mouse focus (mostly).
2. **Override bindings** — temporary global steals owned by a frame.
3. **Click-cast on unit frames** — Clique attributes / secure click handlers on frames under the cursor.

Beef’s UI is a ladder frame, not a unit frame. The realistic conflict is (1)/(2): stealing a key the player also uses for Clique *when not over a unit frame*, or shipping mouse-button defaults that confuse muscle memory. Do not also register for clicks on Blizzard/party frames.

## Safe coexistence rules

1. **No default mouse-button bindings** — ever.
2. **No default modifier+click “hotkeys”** for opening Beef (that is Gargul’s loot niche, not ours — see [social-addons-ship-binds.md](social-addons-ship-binds.md)).
3. **If a Bindings.xml toggle exists later**, leave it unbound; document “Key Bindings → Church of Beef” in help text, not a factory chord.
4. **Never `SetOverrideBinding` a combat-relevant key** for a social toggle.
5. **Do not wrap or replace unit-frame `OnClick`** — out of product scope and Clique’s domain.

## Related failure modes (bars)

Bar addons (Dominos, Bartender, etc.) own profile-scoped action-button binds; Classic players already hit bind-sync bugs across patches ([Dominos #781](https://github.com/tullamods/Dominos/issues/781)). Adding another addon that writes binds increases “who ate my 1–0 keys?” support load. Stay out of that fight.
