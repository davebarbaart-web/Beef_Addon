# Addon Performance Norms (2024–2026)

**Last updated:** 2026-07-25  
**Primary anchors:** [UIHANDLER OnUpdate](https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate), Blizzard forum threads on addon profiling ([example](https://us.forums.blizzard.com/en/wow/t/questions-about-new-feature-addon-profiling/2080486)), Classic UI modernization notes ([Patch 2.5.6 / Kaivax](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes)), Parallel deep research `.raw/wow-classic-toc-api-perf.md`

---

## 1. Measurement context

Retail gained a first-party **Addon Profiler** (discussed widely around patches 11.0.7 / 11.1) exposing per-addon CPU and memory. Classic clients increasingly **share modern UI code** (Edit Mode, raid frames, nameplates landings on Anniversary / Era in 2026), so player expectations for “addons should not tank FPS” track Retail discourse even when the exact profiler UI differs by flavor.

**Practical takeaway for authors:** assume players will blame any visible hitch on addons; keep social addons invisible in combat profilers.

---

## 2. Soft budgets (community norms, not Blizzard SLAs)

There is **no** official published “max ms per addon” contract. Soft targets circulating in author/player discussion (treat as design budgets, not hard API limits):

| Metric | Soft target | Why it matters |
|--------|-------------|----------------|
| Work per frame from *this* addon | ≪ 1 ms typical; spike-aware | 60 FPS ≈ 16.7 ms/frame total for everything |
| Permanent OnUpdate | Avoid; if needed, throttle ≤10–20 Hz for logic | Cost scales with FPS |
| SavedVariables file size | Prefer ≪ 1 MB for a social addon | Login deserialize hitch |
| Addon message rate | ChatThrottleLib-class pacing | Soft disconnect / spam risk |
| Combat-time UI rebuilds | Coalesce / defer | Lockdown + FPS |

Deep-research synthesis floated “&lt;5 ms total addon CPU/frame” as a community headroom idea for *all* addons combined — useful as a mental model, not a measured Church of Beef requirement.

---

## 3. What actually burns FPS in Classic stacks

Typical heavy hitters (ecosystem observation, not COB-specific):

- WeakAuras / custom triggers with tight OnUpdate
- Nameplates, boss mods, raid frames
- Chat processors scanning every line
- Aggressive map/quest trackers

Church of Beef’s competitive set is **guild/social** tools. The bar is: negligible combat cost; acceptable tiny spikes on login sync and rare promotion announcements.

---

## 4. Norms for social / guild addons

| Do | Don’t |
|----|-------|
| Event-driven scoring | Per-frame proximity scans |
| Dirty-flag UI refresh | Full ladder rebuild per net message |
| Cap and rotate local logs | Unbounded SavedVariables growth |
| Throttle guild chat spectacle | Multi-client announcement storms |
| Cache roster lookups | Re-scan entire guild every suggestion |
| Idle when UI closed | Background animations forever |

---

## 5. Classic Anniversary-specific note (2026)

Patch commentary for **2.5.6** (Anniversary) and the follow-on Era **1.15.9** wave emphasizes shared modern UI systems (raid frames / nameplates / Edit Mode). Players will run denser default UI + the same heavy addon stacks as before. A comedy church ladder that adds measurable combat cost will be disabled first.

---

## 6. Verification habits (no code — process)

1. Test with a “raid-like” addon suite enabled (Details, WA, nameplates) so COB cost is measured in a realistic stack.
2. Enter combat in a dungeon; confirm COB does not register meaningful periodic work.
3. Login with a warm BeefNet peer online; confirm sync is bursty then idle.
4. After patches, re-check `## Interface` and smoke-test `/beef` open/close in and out of combat.

---

## 7. Budget recommendation for Church of Beef V1

| Phase | Budget |
|-------|--------|
| Out of combat, UI closed | Effectively idle (events only) |
| Out of combat, UI open | Occasional layout work on interaction |
| In combat | No OnUpdate; no full UI rebuilds; data events OK |
| Net sync | Bursty, throttled; then quiet |
| Persistence | Memory mutations; disk write at logout |
