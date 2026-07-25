# Beef V1 architecture recommendations

**Track:** [34-lua-module-architecture](README.md)  
**Sources of product truth:** design spec §5–§6; implementation plan Architecture + File structure + Task 1 bootstrap.  
**Sibling tracks:** Ace libs [03](../03-ace-libs-options/), TOC/API [04](../04-toc-api-performance/), BeefNet [14](../14-addon-messaging-beefnet/), SV [21](../21-savedvariables-migration/).

## Verdict

Ship V1 as a **plain-namespace, layered addon**:

- Global root `ChurchOfBeef` (`COB`)
- Folders `Data/` / `Core/` / `Net/` / `UI/`
- Bootstrap owns lifecycle; Core stays pure enough for desktop Lua tests
- **No AceAddon**, no `NewModule`, no CallbackHandler required

This matches the locked plan and the Ace/plain decision in track 03 (“No Ace for V1”) without re-litigating library catalogs here.

## Layer rules

```text
Data/Ranks.lua     → constants only (machine canon)
Core/*             → state transitions, pure-ish (WoW API only at edges: Officer roster)
Net/*              → serialize, validate, send/receive, dispatch into Core
UI/*               → frames, tabs, toasts, slash-visible surfaces
ChurchOfBeef.lua   → events, slash, calls Init hooks
```

| Rule | Rationale |
|------|-----------|
| UI never awards points | Spec §6 / §6.3 — scoring is Core; UI is spectacle + controls |
| Net never invents ranks | Commits apply through Core after officer validation |
| Core never `CreateFrame` | Keeps `tests/wow_stub.lua` + `dofile` viable |
| Data never reads SV | Canon is code; SV is cache (track 21) |
| Bootstrap never embeds policy numbers | Thresholds live in `Data/Ranks.lua` |

## Recommended `COB` table map

| Key | File | Responsibility |
|-----|------|----------------|
| `COB.Ranks` / canon | `Data/Ranks.lua` | Rank ids, titles, thresholds, seats |
| `COB.DB` | `Core/DB.lua` | SV shape, defaults, schema migrate |
| `COB.Officer` | `Core/Officer.lua` | Roster rank-index gate |
| `COB.Scoring` | `Core/Scoring.lua` | Caps, grants, anti-AFK buckets |
| `COB.Ladder` | `Core/Ladder.lua` | Records, suggestions, commits, demote |
| `COB.Gora` / `Ceremony` / `Instance` | matching Core files | Thin domain → Scoring |
| `COB.Net` | `Net/BeefNet.lua` | Prefix, send/recv, validate, dispatch |
| `COB.Sync` | `Net/Sync.lua` | `SYNC_REQUEST` / `SYNC_STATE` |
| `COB.UI` | `UI/MainFrame.lua` (+ tabs) | Shell; tabs register into UI |
| Bootstrap locals | `ChurchOfBeef.lua` | Frame, slash, event switch |

Optional later: `COB.Events` thin wrapper if bootstrap `OnEvent` grows past ~one screen — still not AceEvent.

## Lifecycle contract (implementers)

| Phase | Who runs | Must |
|-------|----------|------|
| TOC load | All files | Define methods; no SV trust; no Net send |
| `ADDON_LOADED` | `COB.DB:Init` | Bind `ChurchOfBeefDB`, migrate, defaults |
| `PLAYER_LOGIN` | `COB.UI:Init`, `COB.Net:Init` | Frames + prefix registration |
| Login settle | `COB.Sync:OnLogin` | After roster/throttle-safe delay (see track 14) |
| Gameplay | Core via events | Instance/Gora/Ceremony hooks |
| Officer approve | UI → Core.Ladder → Net | Single commit path |
| Peer apply | Net → Core → UI refresh | Ignore non-officer / bad revision |

## Coupling rules that prevent spaghetti

1. **Downward dependencies only:** UI → Core, Net → Core, Core → Data. Never Core → UI.
2. **Net may call Core apply APIs;** Core may call `Net` only from explicit “broadcast this commit” functions invoked by officer actions — not from every score tick (`SCORE_EVENT` stance in spec).
3. **Tabs are views:** `UI/LadderTab.lua` reads Core; does not own ladder tables.
4. **One officer gate:** `Core/Officer.lua` is the only roster rank-index authority for commits (spec §6.2).

## When to reconsider AceAddon (post-V1)

Adopt AceAddon / `NewModule` only if several of these become true:

- Multiple optional feature packs users disable independently (Skada-like)
- Desire for AceConfigDialog-driven options tree with profile UI (track 03)
- Multiple authors shipping Beef “plugins” that need enable/disable

Even then, prefer **keeping Core plain** and wrapping only UI/options in Ace — do not force LibStub into scoring tests.

## Explicit non-goals for this track

- Choosing ChatThrottleLib vs AceComm (track 14 / 03)
- Minimap LibDBIcon vs hand-rolled (track 28 / 03)
- Multi-flavor TOC (track 04 / 30)
- Locale table tech (track 18)

## Architecture smell checklist

| Smell | Fix |
|-------|-----|
| Points granted in `UI/Toasts.lua` | Move grant to Scoring; toast only displays |
| `ChurchOfBeef.lua` longer than Core files combined | Push logic into Core/Net/UI Inits |
| TOC lists bootstrap before Core | Reorder — methods must exist before Init runs |
| Tests require creating AceAddon | Core leaked framework dependency |
| Sync runs in `ADDON_LOADED` | Move to login settle |
| Second copy of rank thresholds in UI strings | Read titles from `Data/Ranks.lua` / L[] only |
