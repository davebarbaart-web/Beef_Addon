# Secure handlers and templates

**Track:** 29-taint-secure-ui  
**Purpose:** How protected frames, SecureTemplates, SecureHandlers, RestrictedEnvironment, and SecureStateDriver fit together — and why Beef should mostly avoid them.

## Protected frames (combat lockdown surface)

Introduced with the 2.0 security model: out of combat they behave like normal frames; **in combat** they cannot be programmatically shown, hidden, resized, re-anchored, or have attributes changed from tainted code ([wiki](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting); [AddOn Studio](https://addonstudio.org/wiki/WoW:Secure_Execution_and_Tainting)).

Key properties:

- Once declared protected, a frame **cannot be made unprotected**.
- Protection usually comes from inheriting **SecureTemplates** (2.0) or **SecureHandlers** (3.0+) ([wiki](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)).
- Lockdown restrictions also apply to **parents** and **frames they are anchored to**. Anchoring a secure button under your social window can protect the whole parent chain; re-parent/re-anchor *out of combat* releases temporary propagation ([wiki](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting); [Blizzard forum — Gello](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762)).

Configure secure templates with `frame:SetAttribute(...)` **only outside combat**. Guard with `InCombatLockdown()` ([wiki](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)).

## SecureTemplates (attribute-driven protected actions)

Family of FrameXML templates that expose some protected functionality via attributes ([SecureTemplates](https://warcraft.wiki.gg/wiki/SecureTemplates)):

| Template | Role |
|----------|------|
| `SecureActionButtonTemplate` | Cast / use item / macro / other protected actions from attributes |
| `SecureUnitButtonTemplate` | Unit-frame click targeting |
| `SecureGroupHeaderTemplate` / party / pet headers | Raid/party child management |
| `SecureAuraHeaderTemplate` | Aura button management |

Inherited secure handlers stay secure **unless the inheriting frame overrides them** ([wiki — Protected frames](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)).

`SecureActionButtonTemplate` is the canonical way addons perform protected actions with **human clicks** — attributes set out of combat, click in combat ([SecureActionButtonTemplate](https://warcraft.wiki.gg/wiki/SecureActionButtonTemplate)). There is also `InsecureActionButtonTemplate` (Retail 7.2+) for out-of-combat-only protected actions; still create the button out of combat or `SetAttribute` can become unusable ([same page](https://warcraft.wiki.gg/wiki/SecureActionButtonTemplate)).

**Beef stance:** V1 forbids gameplay automation and protected-action circumvention. Do **not** ship SecureActionButtons for cast/target/use. Social click-to-whisper / open URL patterns should use normal buttons or confirmed slash flows, not secure action types.

## SecureHandlers (restricted snippets in combat)

Patch 3.0 templates that run **string snippets** inside the **RestrictedEnvironment** — a limited API subset — so some protected UI mutations can happen in combat when driven by secure attribute/handler paths ([SecureHandlers](https://warcraft.wiki.gg/wiki/SecureHandlers); [archive SecureHandlers](https://wowwiki-archive.fandom.com/wiki/SecureHandlers)).

### Methods on `SecureHandlerBaseTemplate`

| Method | Role |
|--------|------|
| `Execute(body)` | Run a restricted snippet |
| `WrapScript(header, script, preBody [, postBody])` | Wrap widget scripts with restricted pre/post bodies |
| `UnwrapScript(frame, script)` | Remove outermost wrap |
| `SetFrameRef(id, refFrame)` | Expose another frame to snippets via handle |

([wiki](https://warcraft.wiki.gg/wiki/SecureHandlers); [`SecureHandlerWrapScript`](https://warcraft.wiki.gg/wiki/API_SecureHandlerWrapScript))

### Handler templates → attribute snippets

| Template | Attribute(s) | When |
|----------|--------------|------|
| Base | _(methods only)_ | — |
| Attribute | `_onattributechanged` | Any attribute change |
| Click | `_onclick` | Click |
| DoubleClick | `_ondoubleclick` | Double-click |
| Drag | `_ondragstart`, `_onreceivedrag` | Drag |
| MouseUpDown | `_onmouseup`, `_onmousedown` | Mouse up/down |
| MouseWheel | `_onmousewheel` | Wheel |
| EnterLeave | `_onenter`, `_onleave` | Hover |
| ShowHide | `_onshow`, `_onhide` | Visibility |
| State | `_onstate-<id>` | `state-*` attribute changes |

([wiki](https://warcraft.wiki.gg/wiki/SecureHandlers); [SecureHandlerStateTemplate](https://wowpedia.fandom.com/wiki/SecureHandlerStateTemplate))

Canonical combat pattern from Gello: replace `SetScript("OnClick", function() child:Show() end)` with `SecureHandlerClickTemplate` + `SetFrameRef` + `_onclick` snippet that shows the child — required **only after** a secure child made the parent protected ([forum](https://us.forums.blizzard.com/en/wow/t/showing-elements-in-combat-lockdown/614762)).

Authoritative deep dive (PDF): [Iriel’s Field Guide to Secure Handlers (4.0 r1)](http://www.iriel.org/wow/docs/SecureHeadersGuide-4.0-r1.pdf) (linked from wiki SecureHandlers / WrapScript pages).

## RestrictedEnvironment

Snippets are not full addon Lua. Available surface is a curated allow-list (macro parse, unit existence/dead/ghost, stealth, combat, group type, limited action info, state-driver registration, etc.) plus **restricted tables** and **frame handles** — not arbitrary `_G` access ([RestrictedEnvironment](https://wowwiki-archive.fandom.com/wiki/RestrictedEnvironment)).

Implication: you cannot “cheat” the sandbox by putting Beef ladder logic inside `_onclick`. Snippets are for narrow UI state machines (show/hide, swap unit attribute, page bars), not guild score math.

## SecureStateDriver / AttributeDriver

Mechanism to evaluate **macro conditionals** and push results into attributes (or show/hide) securely, including in combat ([SecureStateDriver](https://warcraft.wiki.gg/wiki/SecureStateDriver)):

- `RegisterAttributeDriver(frame, attribute, conditional)` / `UnregisterAttributeDriver`
- Legacy aliases: `RegisterStateDriver` / `UnregisterStateDriver` (prepend `state-`)
- `RegisterUnitWatch(frame [, asState])` for unit existence

Special attribute `state-visibility` (via state id `visibility`) maps conditional results `show`/`hide` to secure Show/Hide ([wiki](https://warcraft.wiki.gg/wiki/SecureStateDriver)).

Evaluation: throttled OnUpdate (~0.2s) plus immediate re-eval on a fixed event list (target/focus/regen/stealth/shapeshift/etc.) ([wiki — Notes](https://warcraft.wiki.gg/wiki/SecureStateDriver)).

Pair with `SecureHandlerStateTemplate` + `_onstate-*` for restricted responses ([SecureHandlerStateTemplate](https://wowpedia.fandom.com/wiki/SecureHandlerStateTemplate)).

**Beef stance:** state drivers shine for action bars / unit frames. For a ladder panel, prefer ordinary Show/Hide on **insecure** frames driven by events — not RegisterStateDriver.

## Decision tree for Beef UI authors

```
Need to cast / target / use item / change bindings?
  → Spec forbids. Stop.

Need a clickable unit frame or raid header?
  → Out of V1 scope. If ever: SecureUnitButton / GroupHeader only.

Need show/hide of OUR window during dungeon combat?
  → Keep ALL children insecure (no Secure* templates).
  → Then normal :Show()/:Hide() works (Gello).

Accidentally added a SecureActionButton as a child?
  → Entire parent chain is now protected in combat.
  → Either remove the secure child, or adopt SecureHandler* snippets
     + create/configure out of combat only.

Need options / dropdowns / confirm dialogs?
  → See social-addon-footguns.md (not SecureHandlers).
```

## Classic / Anniversary note

TBC Classic Anniversary inherits the post-2.0 secure stack (SecureTemplates exist; SecureHandlers exist on Wrath+ vintage and on modern Classic clients that share FrameXML). Design against the wiki trail, not Vanilla 1.12 assumptions ([wiki — Classic uses modern API](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting)). Retail-only topics (Secret Values, Midnight CLEU changes) are out of V1 scope — linked on the wiki trail for contrast only.