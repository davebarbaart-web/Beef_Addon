### 4.1 Frame Loop Cost

`OnUpdate` fires every render frame, ~60 Hz at 60 FPS and ~144 Hz at 144 FPS ([4_onupdate_vs_events_performance_guidance[0]] [13]). Any work inside `OnUpdate` runs at the framerate, making it the most expensive handler available.

### 4.2 Throttling Patterns

**Time accumulator throttle:**

```lua
local last = 0
frame:SetScript("OnUpdate", function(self, elapsed)
    last = last + elapsed
    if last < 0.1 then return end  -- 10 Hz max
    last = 0
    -- do work
end)
```

**`C_Timer.NewTicker` (independent of frame rate):**

```lua
local ticker = C_Timer.NewTicker(0.1, function()
    -- work
end)
-- ticker:Cancel()
```

**Animations** for visual interpolation between frames, not logic.

### 4.3 When to Use Each

| Approach | Use Case |
|---|---|
| Events (`RegisterEvent`) | Discrete state changes (combat start/end, target change, spell cast) |
| `OnUpdate` | Frame-locked visuals: cursor following, smooth interpolation, camera tracking |
| `C_Timer.NewTicker` | Fixed-interval polling (e.g., updating minimap every 0.5s) |
| `UIFrameFadeIn`/`UIFrameFadeOut` | Simple alpha animations |

### 4.4 General Guidance

- Prefer events for all game-state logic.
- Use `OnUpdate` only when you need frame-perfect visuals.
- Throttle `OnUpdate` work to ~10 Hz unless visual smoothness requires more.
- Cache globals as locals at the top of hot functions to avoid repeated table lookups.
- Avoid table allocation inside hot loops.

---