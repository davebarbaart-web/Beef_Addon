# Garbage patterns to avoid

**Track:** [54-memory-fps-budgets](README.md)  
**Scope:** Lua allocation / GC / handler patterns that hitch Classic FPS. Not network anti-spam (→ [14](../14-addon-messaging-beefnet/), [47](../47-login-storms-guild-scale/)).

## Why GC matters in WoW

Lua reclaims unreachable memory via garbage collection. Slow growth that later drops is often **normal** ([AddonUsage](https://www.wowinterface.com/downloads/info7362-AddonUsage.html)). Pain appears when code **allocates heavily in hot paths**, forcing GC work during gameplay — felt as hitching even if “memory” looks fine after the fact.

True leaks (retained references forever) also exist; authors historically hunted them with OptionHouse / AddonUsage watching KB/hour ([WoWInterface leak thread](https://www.wowinterface.com/forums/showthread.php?t=30520)). For Beef, both **spike alloc** and **unbounded retain** matter.

## Hot-path antipatterns

### 1. Tables created every event / every frame

```lua
-- antipattern sketch (do not ship as guidance code)
frame:SetScript("OnEvent", function(_, event, ...)
  local t = { ... }           -- new table
  local copy = { unpack(t) }  -- another
end)
```

**Prefer:** reuse a file-local scratch table; overwrite fields; avoid `unpack` copies on the hot path. Author guidance for `OnUpdate`: “Avoid table creation in the handler” ([OnUpdate performance notes](https://us.forums.blizzard.com/en/wow/t/optimizing-cpu-usage/1366572) / community OnUpdate guides citing the same rules).

### 2. Permanent `OnUpdate` that only sometimes works

`OnUpdate` fires as often as the client draws — potentially hundreds of times per second ([UIHANDLER_OnUpdate](https://wowpedia.fandom.com/wiki/UIHANDLER_OnUpdate)).

**Prefer:**

- `C_Timer.After` / `C_Timer.NewTicker` when available on the flavor, or a **hidden** frame shown only while work is pending ([Gello throttle pattern](https://us.forums.blizzard.com/en/wow/t/optimizing-cpu-usage/1366572)).
- `SetScript("OnUpdate", nil)` when idle — not an empty `if` on a forever-visible frame.
- Throttle with `elapsed` accumulators if an animation truly needs frames.

### 3. String concatenation in chatty handlers

Building display strings with `..` in loops creates many short-lived strings → GC pressure.

**Prefer:** `string.format` / `FontString:SetFormattedText` for UI labels; build announce strings once per promotion, not per roster tick.

### 4. Sorting / rebuilding full UI on every message

For BeefNet: each `CHAT_MSG_ADDON` should mutate data, set `dirty = true`, and **paint later** (on open, or coalesced 0.1–0.5 s after burst). Re-sorting the entire guild ladder and recreating rows per packet is a classic hitch source (same class of bug as bag-update spasms — [Gello](https://us.forums.blizzard.com/en/wow/t/optimizing-cpu-usage/1366572)).

### 5. Unbounded logs in SavedVariables

Appending every suggestion / every chat-adjacent event to a forever-growing SV table:

- grows memory across sessions,
- slows load/save,
- looks like a “leak” in AddonUsage.

**Prefer:** ring buffer / capped history for “My Standing”; official ladder is revisioned records, not an infinite append log ([21](../21-savedvariables-migration/)).

### 6. Texture / font / frame churn

`CreateFrame` + textures per list open without pooling retains widgets or causes spikes.

**Prefer:** row pool; hide unused rows; set text/icons in place.

### 7. Calling diagnostic Updates in product code

`UpdateAddOnMemoryUsage` / CPU update are for profilers. Running them on a ticker fights the FPS you are trying to preserve.

### 8. Forcing GC as a “fix”

`collectgarbage("collect")` (when available) can **cause** a hitch. Do not sprinkle full collections after every sync. Let the client’s incremental GC run; fix allocators instead. (Community tools that force GC are player-side experiments, not a Beef design dependency.)

## Patterns that are fine for a social addon

| Pattern | Why OK |
|---------|--------|
| Allocate while building `/beef` once on open | User-initiated; rare |
| One toast frame reused for all promotions | Tiny steady cost |
| Table for ~guild-size ladder entries | Bounded, meaningful |
| String for one guild-chat announce | Spectacle budget, infrequent |
| AceDB / nested SV tables created at load | Amortized at login |

## Frequency audit (do this before micro-optimizing)

1. Temporarily `print(event)` (or a counter) on Beef’s event handler ([Gello advice](https://us.forums.blizzard.com/en/wow/t/optimizing-cpu-usage/1366572)).
2. Note spasms: zoning, roster, addon chat during login storm.
3. Coalesce: reset a short timer on each event; run real work once after quiet.

Login-scale coalescing details → [47](../47-login-storms-guild-scale/). This track only requires: **hot handlers must not allocate proportional to spam rate**.

## Quick review checklist for Beef PRs (research criteria)

- [ ] No `OnUpdate` attached while main UI hidden / no work pending
- [ ] `CHAT_MSG_ADDON` path allocates O(1) scratch, not O(guild)
- [ ] Ladder paint is dirty-flagged / pooled
- [ ] Standing / event log capped
- [ ] No `UpdateAddOnMemoryUsage` in production tickers
- [ ] Toast / announce path timed once with `debugprofilestop` under ~few ms
