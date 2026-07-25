# Beef V1 announce pipeline

**Track:** [72-guild-chat-announce-api](README.md)  
**Last updated:** 2026-07-25  
**Product truth:** Spec §10 — one throttled guild-chat line from the approving officer’s client; per-officer opt-out. Words from track [32](../32-microcopy-tone-voice/); wire from [14](../14-addon-messaging-beefnet/).

---

## Pipeline (happy path)

```text
Officer+ opens Officer tab / confirm (UI click)
        │
        ▼
Validate LocalIsOfficer + roster ready + suggestion/target
        │
        ▼
Apply RANK_COMMIT locally (revision++)
        │
        ├──────────────► BeefNet: SendAddonMessage RANK_COMMIT (CTL NORMAL)
        │
        ▼
Build announce string (≤255, plain text)   ◄── track 32 owns content
        │
        ▼
Guards: IsInGuild ∧ announceOptIn ∧ guildchat_speak
        │                    │
        │ fail               │ ok
        ▼                    ▼
Local warning only    ChatThrottleLib:SendChatMessage(
                      "NORMAL", "COB-ANN", line, "GUILD", …)
        │
        ▼
Local toast(s) for officer / promotee UI   ◄── always; independent of opt-out
```

Peers receiving `RANK_COMMIT`:

```text
Validate sender Officer+ + revision
  → apply ladder
  → local toasts as appropriate
  → DO NOT SendChatMessage GUILD
```

---

## Which commits get a `/g` line (V1)

| Commit kind | Announce? | Notes |
|-------------|-----------|-------|
| Threshold promote (suggestion → approve) | **Yes** | Core spectacle |
| Manual standing correction that **crosses a rank** | **Yes** | Same as promote/demote outcome |
| Manual standing correction **within** rank | **No** | Avoid chat noise |
| Demote / excommunication | **Yes** | One line; copy in [32](../32-microcopy-tone-voice/) |
| Council appoint / Prophet bestow | **Yes** | Office verb templates in 32 |
| Suggestion create / reject | **No** | Not institutional outcome |
| Gora / ceremony score credit | **No** | Toast only (spec §10) |
| Login `SYNC_STATE` / HELLO | **No** | Heal ladder silently |

---

## Ordering rules

| Rule | Why |
|------|-----|
| Announce **after** local commit accept | Never celebrate a rejected / forged approve |
| BeefNet broadcast **before or with** announce; do not wait for peer ACK | Classic delivery is best-effort; ladder heals via sync ([14](../14-addon-messaging-beefnet/sync-state-and-anti-spam.md)) |
| Dedup key stored when announce fires | Sync replay / double-click must not re-`/g` |
| Opt-out skips only chat | Commit + toast still happen |
| Not-in-guild / no speak | Skip chat; surface local reason |
| Guard with `IsInGuild()` before send | Spec §11; [constraints](sendchatmessage-guild-constraints.md) |

---

## Module sketch (research-level, not implementation)

| Concern | Suggested home (plan-aligned) |
|---------|-------------------------------|
| Approve + commit | `Core/Officer` + BeefNet |
| “Should this client announce?” | Tiny helper next to commit (ownership + opt-in + speak) |
| String build | Locale / copy table ([32](../32-microcopy-tone-voice/), [18](../18-localization-i18n/)) |
| Send | Shared CTL instance with BeefNet ([14](../14-addon-messaging-beefnet/chatthrottlelib-and-budgets.md)) |
| Dedup set | Per-character SV: last N commit ids announced |

Prefix string for CTL chat flow (e.g. `"COB-ANN"`) is only a CTL traffic class id — **not** an addon message prefix.

---

## Failure / edge table

| Situation | Behavior |
|-----------|----------|
| Officer opt-out | Silent `/g`; toast + commit OK |
| Peer applies commit | No `/g` |
| Login `SYNC_STATE` heal | No `/g` |
| Offline promotee | `/g` still fires for online flock; promotee sees ladder later |
| Two officers race-approve same suggestion | First valid revision wins; second ignored — at most one announce |
| Officer demoted mid-click | Fail closed on validate; no announce |
| CTL queue busy with sync | Announce waits in NORMAL queue — OK |
| Msg would exceed 255 | Truncate/refuse before send; fix copy in 32 |
| `guildchat_speak` false | Local error; commit still valid |

---

## Explicit non-goals for V1

- `OFFICER` channel spectacle  
- MessageQueue / HW-event wrappers for `GUILD`  
- Multi-line liturgy / raid warning  
- Designated herald alt  
- Re-announce buttons (optional V1.1 “repeat last ceremony” — out of scope)  
- Bypass of Blizzard chat filters  

---

## Acceptance hooks

| Check | How |
|-------|-----|
| Spec §13.11 | Real guild night: one promote → one `/g` line → visible reaction |
| No peer echo | Two Beef clients online; only approver’s name as chat sender |
| Opt-out | Approver disables setting → commit works, no `/g` |
| Throttle | Rapid double-approve attempt → still one line per successful commit |

Instrumentation note (track [39](../39-guild-calendar-events/)): log announce fired / skipped reason; do not log full liturgy to public debug dumps ([65](../65-debug-dumps-privacy/)).
