# Bindings.xml mechanics

Primary howto: [Creating key bindings — Warcraft Wiki](https://warcraft.wiki.gg/wiki/Creating_key_bindings) (Wowpedia mirror exists). Classic-era notes still apply on Anniversary for the Bindings.xml path.

## What Bindings.xml is for

If an addon has a **fixed** list of bindable actions, declare them in `Interface\AddOns\MyAddOn\Bindings.xml`. FrameXML merges those into Blizzard’s Key Bindings UI so the player (not your options panel) assigns keys.

The client **auto-loads** `Bindings.xml` — do **not** list it in the `.toc` ([Warcraft Wiki](https://warcraft.wiki.gg/wiki/Creating_key_bindings)).

## What a binding can do

Each `<Binding>` can do **one** of:

- Run custom Lua (insecure)
- Cast a spell (`name="SPELL …"`)
- Use an item (`name="ITEM …"`)
- Run a named macro (`name="MACRO …"`)
- Securely `:Click()` a button (`name="CLICK FrameName:Button"`)

You cannot combine cast+item in one binding except via macro/click paths ([Warcraft Wiki](https://warcraft.wiki.gg/wiki/Creating_key_bindings)).

## Labels and headers

| Mechanism | Role |
|-----------|------|
| `name="FOO"` | Command token; UI label from `_G["BINDING_NAME_FOO"]` |
| `header="BAR"` | Starts a section; label from `BINDING_HEADER_BAR` |
| `description=` | Fallback label if `BINDING_NAME_*` missing ([AddOn Studio howto](https://addonstudio.org/wiki/WoW:Using_bindings.xml_to_create_key_bindings_for_your_addon)) |

If `BINDING_HEADER_*` is missing, the binding falls under the previous header. Headers cannot “hook into” another addon’s section after Bindings.xml finishes processing ([AddOn Studio](https://addonstudio.org/wiki/WoW:Using_bindings.xml_to_create_key_bindings_for_your_addon)).

Empty code blocks are ignored since 2.1 — a `-- dummy` comment is enough for spell/item/macro/click stubs ([AddOn Studio](https://addonstudio.org/wiki/WoW:Using_bindings.xml_to_create_key_bindings_for_your_addon)).

## The dangerous attribute: `default`

```xml
<Binding name="MYADDON_TOGGLE" header="MYADDON" default="SHIFT-F">
  MyAddon_Toggle()
</Binding>
```

`default` is optional and sets the **factory** key for that action (e.g. `"SHIFT-F"`) ([Warcraft Wiki](https://warcraft.wiki.gg/wiki/Creating_key_bindings)). That is how addons silently occupy chords on first bind-set load.

**Social-addon rule of thumb:** declare the action unbound (omit `default`) so Key Bindings UI shows a row the player can fill if they want one. Shipping a default is choosing a conflict for every raider who already uses that chord.

## Lua body vs secure click

Custom Lua inside `<Binding>` is insecure — fine for toggling a guild ladder frame. Prefer a named function (`ChurchOfBeef_Toggle()`) over a giant inline script; keep XML valid (`<` must be escaped or wrapped in CDATA) ([Warcraft Wiki](https://warcraft.wiki.gg/wiki/Creating_key_bindings)).

For anything that must remain secure, use `CLICK` bindings / `SetBindingClick` onto a real Button — that is Clique/action-bar territory, not Beef V1.

## Localization

Set `BINDING_HEADER_*` and `BINDING_NAME_*` in locale files the same way as other globals ([AddOn Studio](https://addonstudio.org/wiki/WoW:Using_bindings.xml_to_create_key_bindings_for_your_addon)). Names with spaces (spell/click commands) need `_G["BINDING_NAME_SPELL Foo"]` style assignment.

## Classic mental model (3.3.5-era summary)

[NeticSoul ch16](https://github.com/NeticSoul/wow-335a-addon-wiki/blob/main/chapters/ch16-key-bindings.md) restates the stack:

1. Override bindings (highest)
2. Custom / player key bindings
3. Default key bindings (lowest)

Keys → commands are many-to-one. Mouse buttons are named `BUTTON1`…`BUTTON5` with optional `SHIFT-` / `CTRL-` / `ALT-` prefixes — the same namespace Clique and bars fight over.
