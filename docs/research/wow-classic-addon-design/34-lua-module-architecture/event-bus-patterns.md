# Event bus patterns used by quality Classic addons

**Track:** [34-lua-module-architecture](README.md)  
**Does not cover:** `CHAT_MSG_ADDON` / BeefNet wire protocol → [14](../14-addon-messaging-beefnet/); AceEvent as a library shopping list → [03](../03-ace-libs-options/).

## Three buses people confuse

| Bus | Who fires | Who listens | Typical API |
|-----|-----------|-------------|-------------|
| **Blizzard events** | Client | Addon frames / AceEvent | `RegisterEvent("PLAYER_ENTERING_WORLD")` |
| **Addon messages (wire)** | Other clients (or self) via chat addon channel | `CHAT_MSG_ADDON` handlers | BeefNet / AceComm |
| **Internal pub/sub** | Own code | Own modules (or other addons) | CallbackHandler `:Fire`, AceEvent `SendMessage` |

This note is about the **internal** bus and how it relates to Blizzard events. Wire protocol stays in track 14.

## Pattern 1 — CallbackHandler registry (library-grade)

[CallbackHandler-1.0](https://www.wowace.com/projects/callbackhandler) is the standard pub/sub engine:

```text
LibStub("CallbackHandler-1.0"):New(MyLib)
→ RegisterCallback / UnregisterCallback / UnregisterAllCallbacks
MyLib.callbacks:Fire("EventName", ...)
```

Designed so **libraries** can notify interested addons without depending on AceEvent. AceEvent itself uses CallbackHandler **twice** — once for Blizzard events (`RegisterEvent`), once for fireable messages (`RegisterMessage` / `SendMessage = messages.Fire`) ([CallbackHandler overview](https://www.wowace.com/projects/callbackhandler), [AceEvent-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0)).

**When quality addons use it:** many optional modules; shared libs (LDB, etc.); cross-addon soft integration.

**Beef V1:** do not embed CallbackHandler solely for Core→UI refresh. Revisit if a V2 plugin surface appears.

## Pattern 2 — AceEvent messages (AceAddon ecosystems)

AceEvent embed gives:

- `RegisterEvent` / `UnregisterEvent` — Blizzard events, multiplexed on one hidden frame
- `RegisterMessage` / `SendMessage` — **in-process** strings any embedder can fire ([AceEvent API](https://www.wowace.com/projects/ace3/pages/api/ace-event-3-0))

Skada/Chatter-style modules often `RegisterMessage` for “display mode changed” style fan-out so displays stay decoupled from collectors.

**Caveat from CallbackHandler docs:** AceEvent messages are best when **multiple sources** can fire the same name. If one Core owns the event, a direct method call is simpler.

## Pattern 3 — Single bootstrap frame (plain Classic)

```text
CreateFrame("Frame")
  :RegisterEvent(...)
  :SetScript("OnEvent", function(_, event, ...)
      if event == "X" then COB.Instance:OnX(...) end
    end)
```

One dispatcher in bootstrap (or a thin `COB.Events` table) routes Blizzard events into Core methods. Used by nearly every non-Ace tutorial ([wiki HelloWorld](https://warcraft.wiki.gg/wiki/Create_a_WoW_AddOn_in_15_Minutes)).

**Pros:** no deps; obvious call graph; easy to stub in tests by calling Core methods directly.  
**Cons:** bootstrap `OnEvent` grows; mitigate by keeping handlers one-liners into Core.

## Pattern 4 — Direct calls / return values (no bus)

Spec §6 pipeline is inherently **call-forward**:

```text
thin UI / game event
  → Core.Scoring / Ladder
  → (optional) Net broadcast
  → UI refresh
```

Quality small addons skip pub/sub entirely: `Ladder:Commit(...)` returns; caller invokes `UI:Refresh()` and `Net:SendCommit(...)`. Failures stay local and testable.

## Pattern 5 — Hybrid (recommended mental model for Beef)

| Edge | Mechanism |
|------|-----------|
| Client → Beef | Bootstrap frame `RegisterEvent` → `COB.Instance` / `COB.Gora` / … |
| Core → Core | Direct method calls (`Scoring` → `Ladder:Suggest`) |
| Core → UI | Direct `COB.UI:OnLadderChanged(record)` (or UI polls on show) |
| Core → Net | Direct `COB.Net:BroadcastCommit(...)` after officer approve |
| Peer → Beef | `CHAT_MSG_ADDON` in Net → validate → Core apply → UI refresh |
| Future plugins | Optional CallbackHandler / AceEvent messages — not V1 |

## Anti-patterns

- **Sending AceEvent messages for every point tick.** Noisy; hard to replay in tests; invites hidden listeners.
- **UI listening to Blizzard events that Core should own.** Duplicates scoring paths; desyncs standing vs ladder.
- **Net validating payloads inside UI tabs.** Keep parse/dispatch in `Net/`; UI only renders Core state.
- **Global `RegisterAddonMessagePrefix` or chat hooks at file scope.** Bind in `Net:Init` on `PLAYER_LOGIN` (init-order note).

## Steal / adapt

| Steal | From | Adapt for Beef |
|-------|------|----------------|
| Separate Blizzard events vs fireable messages | AceEvent / CallbackHandler | Bootstrap frame for Blizzard only; no message mesh V1 |
| Module `OnEnable` registers, `OnDisable` clears | AceAddon modules | `UI:Init` / future `UI:Disable` if standby ever needed |
| One dispatcher, many handlers | Plain frame pattern | Bootstrap `OnEvent` stays thin |
| Wire bus ≠ internal bus | Every serious guild addon | BeefNet is Net-only; never overload `SendMessage` for GUILD traffic |
