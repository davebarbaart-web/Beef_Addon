# Feature detection (capability probes)

**Last updated:** 2026-07-25  
**Track:** [55-graceful-degradation](README.md)  
**Related:** Flavor TOC QA in [19 multi-flavor](../19-testing-debugging-qa/multi-flavor-toc-testing.md); messaging API surface in [14](../14-addon-messaging-beefnet/).

---

## 1. Why detection beats “require everything”

Classic family clients (Era, Anniversary/TBC, MoP, …) share Lua but not every namespace. Spec §12 tells V1 to isolate TOC, instance APIs, and messaging. Feature detection is the runtime half of that isolation: **probe once at load / enter-world, set capability flags, degrade modules that need a missing flag.**

Hard pattern to avoid: calling `C_Something.Foo()` at file top-level so a nil namespace aborts the entire addon load.

---

## 2. Detection layers (ordered)

| Layer | Probe | Beef use |
|-------|-------|----------|
| **Project / flavor** | `WOW_PROJECT_ID` vs `WOW_PROJECT_BURNING_CRUSADE_CLASSIC` (and friends) | Gate V1 “supported client”; disable BeefNet on Mainline if ever loaded |
| **Expansion enum** | `LE_EXPANSION_LEVEL_CURRENT` | Secondary check; do not use alone for Anniversary vs Era |
| **Interface number** | `select(4, GetBuildInfo())` | Log / soft-warn if TOC Interface drifted from live build |
| **Namespace present** | `type(C_ChatInfo) == "table"` | Messaging module enable |
| **API present** | `type(C_ChatInfo.RegisterAddonMessagePrefix) == "function"` | Same |
| **Prefix registered** | Return value of `RegisterAddonMessagePrefix("COB")` + `IsAddonMessagePrefixRegistered` | BeefNet on/off |
| **Guild membership** | `IsInGuild()` | Pause scoring / BeefNet (spec §11) |
| **Roster ready** | Non-zero `GetNumGuildMembers()` after roster request / `GUILD_ROSTER_UPDATE` | Officer verify; else queue/drop commits |
| **Optional media** | Texture/font path exists or `pcall` SetTexture / CreateFont | Fallback to default UI (spec §10) |
| **Optional library** | `LibStub("AceAddon-3.0", true)` style soft require | Track 42; UI still loads without polish libs |

Primary refs: [WOW_PROJECT_ID](https://warcraft.wiki.gg/wiki/WOW_PROJECT_ID) · [Wowpedia mirror](https://wowpedia.fandom.com/wiki/WOW_PROJECT_ID) · [TOC format / GetBuildInfo](https://warcraft.wiki.gg/wiki/TOC_format) · [RegisterAddonMessagePrefix](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.RegisterAddonMessagePrefix).

---

## 3. `WOW_PROJECT_ID` cheat sheet (research snapshot)

Documented constants (verify on live clients; IDs grow as Classic flavors ship):

| Constant | Typical meaning |
|----------|-----------------|
| `WOW_PROJECT_MAINLINE` | Retail |
| `WOW_PROJECT_CLASSIC` | Classic Era / Vanilla family |
| `WOW_PROJECT_BURNING_CRUSADE_CLASSIC` | TBC Classic / Anniversary family |
| `WOW_PROJECT_WRATH_CLASSIC` | Wrath Classic |
| `WOW_PROJECT_CATACLYSM_CLASSIC` | Cataclysm Classic |
| `WOW_PROJECT_MISTS_CLASSIC` | MoP Classic |

V1 product stance: **Anniversary / BC Classic project is the supported target.** Other projects are either “don’t load” (TOC) or “load but mark unsupported / net off” if a zip is installed in the wrong tree.

---

## 4. Messaging capability specifically

1. Confirm `C_ChatInfo` exists.  
2. Call `RegisterAddonMessagePrefix("COB")` once (early, after ADDON_LOADED / VARIABLES_LOADED family — community examples register on load).  
3. Treat `false` as **BeefNet unavailable** (prefix limit or server refusal — [SO answer](https://stackoverflow.com/questions/61752395/raid-doesnt-receive-c-chatinfo-sendaddonmessage)).  
4. Never send before register; receivers without register never see peers’ traffic.  
5. Remember Classic: `CHANNEL` chatType for addon messages is disabled — detect and refuse any custom-channel design ([Kaivax 1.13.3](https://us.forums.blizzard.com/en/wow/t/wow-classic-patch-1133-lua-api-change/384543)).

---

## 5. Roster / authority readiness

Officer validation needs a loaded guild roster (spec §6.2, §11). Detection is event-shaped, not a single boolean at file load:

- Not in guild → empty ladder / scoring paused.  
- In guild but roster empty / stale → **do not** apply `RANK_COMMIT`; queue or drop.  
- After `GUILD_ROSTER_UPDATE` (or equivalent Classic event path) → drain queue with real rank-index checks.

This is feature detection over **data readiness**, not over API existence — same resilience mindset.

---

## 6. Steal for Beef module flags (conceptual)

Hold a small capability table populated once and refreshed on enter-world / guild events:

| Flag | Meaning |
|------|---------|
| `clientSupported` | Project ID matches V1 target |
| `beefNet` | Prefix registered + in guild |
| `rosterReady` | Can verify Officer+ |
| `peersLikely` | Saw HELLO / SYNC recently (optional UX badge only) |
| `mediaOk` | Custom chrome loaded; else defaults |

UI reads flags; never throws when a flag is false — see [partial-sync-mode.md](partial-sync-mode.md).
