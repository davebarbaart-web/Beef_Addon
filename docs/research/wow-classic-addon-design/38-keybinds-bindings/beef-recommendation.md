# Beef recommendation — keybinds

## Verdict

**V1: ship no keybinds.** No `Bindings.xml`, no `SetBinding*`, no `SetOverrideBinding*`. Entry remains `/beef` + minimap (LibDBIcon), per locked spec.

**V2 (optional, demand-driven):** at most **one** unbound Bindings.xml action — “Toggle Church of Beef” — with `BINDING_HEADER_*` / `BINDING_NAME_*` localized, **no** `default=` attribute. Never auto-assign a chord.

## Why (mapped to research)

| Constraint | Implication |
|------------|-------------|
| Spec success criteria already require `/beef` frame + minimap | Hotkey is not a discoverability requirement |
| `SetBinding` unbinds prior owners | Hostile for a guild toy |
| Overrides still steal while active | Wrong for always-available social toggle |
| Clique / bars own mouse + dual-use keys | Any factory default is a support ticket |
| Gargul-style click hotkeys serve loot | Beef has no analogous click workflow |
| Combat lockdown on bind mutation | Extra code for a non-combat feature |

## Explicit non-goals

- Do not bind officer actions to hotkeys (authority stays UI + BeefNet gates — see track 22).
- Do not click-cast on unit frames.
- Do not override `ESCAPE` / `ENTER` / movement keys.
- Do not save binds into the character/account set from addon code.

## If V2 adds an unbound Bindings.xml row

Checklist (design-only; no implementation here):

1. File at addon root: `Bindings.xml` (not in TOC).
2. Single binding name, e.g. `CHURCHOFBEEF_TOGGLE`, header `CHURCHOFBEEF`.
3. Body calls the same toggle as slash/minimap.
4. Omit `default`.
5. Mention in `/beef help`: “Optional: Key Bindings → Church of Beef.”
6. Still treat slash as primary; binding is convenience only.

## Decision log suggestion (for design spec, if accepted)

> **Keybinds:** V1 ships none. Optional V2 unbound Bindings.xml toggle only; no factory defaults; never SetBinding/SetOverrideBinding for the main UI.

Do not edit the design spec from this track unless product owners promote the decision — this note is research recommendation only.
