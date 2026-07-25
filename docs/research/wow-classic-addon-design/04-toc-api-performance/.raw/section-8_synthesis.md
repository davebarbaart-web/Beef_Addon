### Unifying Patterns

1. **TOC multi-targeting is the standard**: Cataclysm Classic, TBC Anniversary, and Classic Era all use distinct Interface numbers. Shipping suffixed TOCs with matching `## Interface` values is the canonical cross-client pattern.

2. **Combat lockdown is a feature, not a bug**: Protected functions exist to prevent addons from automating gameplay. The `RunOrQueue` deferral pattern is the idiomatic solution; addons that fail to defer will silently fail or trigger taint.

3. **OnUpdate is reserved for rendering**: All game-state logic belongs on events or timers. `OnUpdate` is for cursor-following widgets, smooth interpolation, and visual effects.

4. **AceDB data-types mirror the SavedVariables tree**: `char` -> per-char, `account`/`global` -> account-wide, `realm` -> server-shared. Using these scopes correctly avoids manual file management.

5. **The in-game profiler changed the conversation**: Since patch 11.0.7/11.1, addon CPU is transparent. The community norm is <5 ms total addon CPU per frame on mid-spec hardware. Addons exceeding this budget are profiled and refactored.

### Divergences and Trade-offs

| Dimension | Retail | Classic Branches |
|---|---|---|
| API surface | Largest, frequent additions | Frozen per expansion |
| Combat lockdown | Same engine | Same engine |
| SavedVariables tree | Same | Same |
| Addon Profiler data | Available | Same engine, same data |
| TOC versioning | Single Interface line | Multiple Interface lines required |

### Failure Modes to Avoid

- **Ignoring `InCombatLockdown()`**: Protected API calls during combat are silently blocked or trigger "Action forbidden" errors.
- **Hot `OnUpdate` with no throttle**: Each frame triggers GC pressure; even cheap work adds up at 144 Hz.
- **Global table pollution**: Storing addon state in `_G` causes taint when shared with Blizzard or other addons.
- **Excessive SavedVariables writes**: Serialization happens on logout and UI reload; large or complex tables slow login.
- **Hardcoded API versions**: Bumping the Interface number manually rather than tracking per-client changes causes "out of date" warnings.

---