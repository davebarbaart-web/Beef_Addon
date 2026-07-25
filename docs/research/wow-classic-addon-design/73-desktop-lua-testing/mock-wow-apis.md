# Mocking WoW APIs for desktop tests

**Track:** [73-desktop-lua-testing](README.md)

WoW addons are not modules with a clean `require` graph — they assume a huge `_G`. Desktop tests therefore either **avoid** needing APIs (preferred) or **stub** the few they touch.

---

## Principle: mock the edge, not the client

| Approach | Idea | Beef fit |
|----------|------|----------|
| **Pure Core** | No WoW calls inside ladder/scoring/canon | Best — plan rule “Core never CreateFrame” |
| **Dependency injection** | Pass `rosterLookup`, `now`, `sendFn` | Best for Officer / time / Net send |
| **Minimal global stub** | No-op `CreateFrame`, print chat, empty `SlashCmdList` | Enough to *load* bootstrap-adjacent files |
| **Fat mock** | Emulate frames, events, `C_*` | Only if testing load order / OnEvent |

Blizzard-forum authors describe structural testing with stubs that “take the same input and produce output that matches the output format” ([Saved Variables and LUA](https://us.forums.blizzard.com/en/wow/t/saved-variables-and-lua/1194561)) — format fidelity, not behavioral fidelity.

---

## Minimal stub (plan baseline)

From plan Task 1:

```lua
CreateFrame = CreateFrame or function()
  return {
    RegisterEvent = function() end,
    SetScript = function() end,
    Hide = function() end,
    Show = function() end,
  }
end
DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME or { AddMessage = function(_, m) print(m) end }
SlashCmdList = SlashCmdList or {}
```

**Add only when a Core file starts referencing them.** Candidates for Beef growth:

| Global | Offline use |
|--------|-------------|
| `time` / `GetTime` | Prefer inject `now` (plan Scoring already takes `now`) |
| `UnitName("player")` | Inject player name into Ladder tests |
| `GetGuildRosterInfo` | Prefer `rosterLookup` injection (plan Officer) |
| `C_ChatInfo.SendAddonMessage` | Do not call from Core; Net adapter only — stub in Net *integration* tests if any |
| `strsplit` / `wipe` | Polyfill if Net validate uses WoW helpers (or use pure Lua equivalents in Core/Net validate) |

---

## Fat stub lessons (PersoLootRoll)

[PersoLootRoll `Test.lua`](https://raw.githubusercontent.com/shrugal/PersoLootRoll/master/Test.lua) shows the ceiling of desktop mocking:

- `CreateFrame` tracks scripts/events and exposes `FireEvent` / `FireUpdate`
- Metatable default: unknown `PascalCase` methods → no-op `Fn` (stops load crashes)
- Polyfills WoW Lua extras: `wipe`, `strsplit`, `hooksecurefunc`, `C_Timer.After` (immediate)
- Constants tables (`Enum`, `RAID_CLASS_COLORS`, localized format strings)

**Warning:** Fat stubs create **false confidence**. `C_Timer.After` that runs immediately changes race behavior; `GetGuildInfo = Fn` returning nil is not a Classic roster. Use fat stubs for “does the TOC load?” — not for “is BeefNet correct?”

---

## busted spies / stubs / mocks

From [busted docs — Spies, Stubs & Mocks](https://lunarmodules.github.io/busted/):

| Tool | Behavior |
|------|----------|
| `spy.on(t, "method")` | Wrap; record calls; still invoke original |
| `stub(t, "method")` | Replace; record calls; do not invoke |
| `mock(t)` / `mock(t, true)` | Wrap all functions as spies (or stubs) |

Useful when Net dispatch calls into Core and you want `assert.spy(Core.Apply).was.called_with(...)`. With Beef’s homemade runner, the equivalent is: pass a recording fake table into the function under test.

**Gotcha:** Method calls pass `self` as first arg — `called_with` must account for it (`match.is_ref(t)` in luassert). See [SO busted thread](https://stackoverflow.com/questions/23377991/testing-lua-script-with-busted).

---

## `dofile` vs `require`

| Loader | WoW analogy | Notes |
|--------|-------------|-------|
| `dofile(path)` | TOC file load | Runs chunk in global env; Beef plan style; re-runnable if files are idempotent (`COB.X = COB.X or {}`) |
| `require(mod)` | Lua module | Needs `package.path`; good for `wow_stub` and test suites; bad for addon files that expect `(addonName, ns) = ...` |
| `loadfile(path)(name, ns)` | Private addon namespace | PersoLootRoll style; only needed if Beef adopts `local _, ns = ...` |

Beef V1 plan uses **global `ChurchOfBeef`** + `dofile` — keep tests matching that.

---

## What never belongs in the stub

- Secure/taint simulation
- Real `SendAddonMessage` / chat throttle
- Pixel layout / hit testing
- Combat lockdown truth ([19 combat-lockdown-testing](../19-testing-debugging-qa/combat-lockdown-testing.md) already: cannot fully unit-test lockdown outside the client)
- SavedVariables file I/O (test DB shape with a plain Lua table stand-in)

---

## Steal / adapt for Beef

- **Steal:** inject `now`, `rosterLookup`, optional `send` — plan already does.
- **Steal:** minimal stub only for load-time globals.
- **Avoid:** maintaining a PersoLootRoll-scale mock for V1.
- **Adapt:** if a Core file needs a WoW global, treat that as an architecture smell — push the call to Net/UI/bootstrap and inject the result ([34](../34-lua-module-architecture/beef-v1-architecture.md)).
