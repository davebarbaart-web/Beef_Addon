# `pcall` / `xpcall` around APIs

**Last updated:** 2026-07-25  
**Track:** [55-graceful-degradation](README.md)

---

## 1. What `pcall` actually does in WoW Lua

[`pcall`](https://warcraft.wiki.gg/wiki/API_pcall) runs a function and returns `ok, ...`. On failure, `ok` is false and the next value is the error string — the client does not show a script error for that call unless you re-raise.

`xpcall` adds a custom error handler (better stacks). Mature UIs (e.g. ElvUI module init notes in ecosystem changelogs) use `xpcall` so one bad module does not take down the whole UI — pattern to steal for **optional** Beef modules later, not for V1 authority core.

---

## 2. When guards are right

| Situation | Guard? | Why |
|-----------|--------|-----|
| Optional texture / font / sound path | Yes | Spec §10: missing media → fallback; continue |
| Soft dependency / LibStub optional | Yes | Track 42; polish absent ≠ soft-lock |
| Unknown or flavor-conditional API | Yes | Probe + `pcall` once; cache “unsupported” |
| Serialization of untrusted peer payload | Prefer explicit validate | Shape-check first; `pcall` decode only if using a library that throws |
| Module init that can fail independently | `xpcall` per module | Isolate Gora stub vs ladder core later |
| Officer roster lookup / apply commit | **No silent swallow** | Failed verify must not become apply |
| Slash command that opens main frame | No (must surface) | Spec §10 failure mode: “command works, nothing appears” |

---

## 3. Anti-patterns

1. **`pcall` around the entire ADDON_LOADED.** Hides load bugs; BugSack never sees them; ship with a dead `/beef`.  
2. **`pcall` that ignores `ok == false` with no state change.** Degraded mode must flip a flag or show a one-line chat warning (once).  
3. **Using `pcall` as a substitute for `type()` checks.** Prefer nil/type probes for known APIs; reserve `pcall` for calls that can throw despite existing (bad args, protected, file missing).  
4. **Swallowing taint / secure errors to “keep going” into protected actions.** Beef is not a combat HUD — do not paper over lockdown; defer UI work (track 19 combat-lockdown note).

---

## 4. Recommended V1 seams (conceptual)

```
Load path
  ├─ Core (no pcall): SavedVariables, frame factory, slash, ladder model
  ├─ Net (detect + register; if fail → beefNet=false, no throw)
  ├─ Media (pcall / fallback fonts)
  └─ Optional stubs (xpcall later): Gora / ceremony chrome
```

For peer messages: validate string shape **before** mutating official state. A decode error → drop packet + optional debug log, never apply half-parsed ranks.

---

## 5. Error visibility vs resilience

Resilience is not “hide all errors.” Spec §13.1 and track 19 want `scriptErrors` / BugGrabber during playtests. Pattern:

- **Expected absence** (no custom font file) → silent fallback.  
- **Unexpected logic bug** (nil index in ladder render) → let it error in alpha; fix.  
- **Hostile / malformed peer packet** → drop; never error-loop the receive handler (guard the handler so one bad frame does not unregister the listener — here a local `pcall` around parse+dispatch is justified).

---

## 6. Mapping to spec §11

| Spec row | Guard strategy |
|----------|----------------|
| Missing media | Fallback; continue |
| BeefNet version mismatch | Soft warning; discard incompatible — no throw |
| Roster not loaded | Queue/drop — explicit branch, not `pcall` |
| Non-officer forge | Reject — explicit validation |
| Disconnect mid-ceremony | No credit — state machine, not `pcall` |
