### 6.1 Profiler Background

Blizzard shipped an in-game Addon Profiler in patch 11.0.7 and redesigned it in 11.1. The profiler reports CPU time per addon and per module, plus memory ([6_addon_performance_fps_norms_and_limits[0]] [66]). This data is used both by Blizzard to identify outliers and by authors to find hotspots.

### 6.2 Soft Thresholds

There is no officially published FPS threshold, but community-observed norms:

| Metric | Soft Threshold | Notes |
|---|---|---|
| Total addon CPU per frame | < 5 ms | Leaves headroom in a 16.6 ms (60 FPS) frame |
| Single addon CPU per frame | < 1 ms typical; < 0.5 ms ideal | Heavy addons >5 ms are throttled historically |
| Per-addon memory | Tens of MB; >100 MB is excessive | WeakAuras and Boss mods are typical heavy users |
| Saved variable file size | A few MB max | Login cost scales with file size |
| FPS impact budget | < 5 FPS drop | Players often report 5–15 FPS gains after disabling heavy addons |

### 6.3 Observed Impact

| Scenario | Typical FPS Impact | Cause |
|---|---|---|
| Minimal addons (3–5) | Negligible | – |
| Full suite (WeakAuras, ElvUI, Details, DBM/BW) | −5 to −15 FPS at 1440p | Many OnUpdate handlers, texture redraws |
| Combat with many boss mods | −3 to −10 FPS during encounters | CLEU event volume |
| Heavy WeakAura animated textures | −10 to −25 FPS | GPU compositor load |
| Single badly-written addon | −15 to −50+ FPS | Unthrottled OnUpdate, string concatenation, table churn |

### 6.4 Practical Optimization Checklist

1. Replace `OnUpdate` work with events or `C_Timer.NewTicker` whenever possible.
2. Throttle remaining `OnUpdate` work with a time accumulator.
3. Cache globals as locals at the top of hot functions.
4. Avoid table allocation inside hot loops.
5. Unregister one-shot events after handling.
6. Use `UIFrameFadeIn`/`UIFrameFadeOut` and the AnimSystem for visual animations.
7. Check `InCombatLockdown()` before protected operations.
8. Cache `UnitName`, `UnitGUID`, `UnitClass` for the current target.
9. Use `GetTime()` for delta calculations, not real-time clock reads.
10. Minimize `SavedVariables` writes - they serialize on logout/UI reload.

---