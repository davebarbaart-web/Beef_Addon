# Church of Beef — diagnostics & privacy policy

**Track:** [65-debug-dumps-privacy](README.md)  
**Last updated:** 2026-07-25  
**Purpose:** Explicit product policy for `/beef debug`, logging, and support artifacts. Not Blizzard legal advice — for data-handling overlap with ToS see [24](../24-policy-tos-compliance/data-exfiltration-forbidden-apis.md).

---

## 1. Principles

1. **Minimize.** Diagnostics carry the smallest set of fields that can reproduce a bug.
2. **Local first.** V1 is fully in-game (spec §2). No HTTP telemetry, no phone-home crash reporter, no mandatory companion app.
3. **Player-triggered paste.** Support data leaves the client only when a human copies it (BugSack, status dump, optional private SV).
4. **Audience-aware.** Guild-visible ≠ GitHub-public ≠ stream-safe.
5. **Gate danger.** Verbose dumps and forge helpers stay behind `COB.DEBUG` / packager strip ([48](../48-feature-flags-rollout/); plan Task 8).

---

## 2. `/beef debug` policy (V1 intent)

| Rule | Detail |
|------|--------|
| **Default** | `COB.DEBUG = false`. Debug verbs absent from help and no-op if invoked. |
| **Release** | Strip or harden debug mutators (`standing` forge, roster dumps) before wide zips ([48 gate layers](../48-feature-flags-rollout/gate-layers.md)). |
| **Allowed debug surfaces** | Curated status: version, build, BeefNet major, flags, **self** standing, aggregate counts — [allow list](debug-dump-allow-deny.md). |
| **Forbidden debug surfaces** | Full `ChurchOfBeefDB`, full roster, officer notes, chat/whisper text, raw wire payloads, filesystem paths — [deny list](debug-dump-allow-deny.md). |
| **Chat channel** | Never emit debug dumps to guild/officer/raid chat. Local print or copy-box only. |
| **Release-safe cousin** | Optional short `/beef status` (version + sync health) with no ladder dump — product decision at implement time; must still follow deny list. |

Illustrative plan command `/beef debug standing N` is a **mutator**, not a dump: same gate, never in Release, never documented as player-facing.

---

## 3. Logging policy

| Log type | Beef may enable? | Beef may request in bugs? |
|----------|------------------|---------------------------|
| BugSack / BugGrabber (player-installed) | Soft-peer only; do not hard-dep ([42](../42-soft-deps-embeds/)) | **Yes** — one stack |
| Blizzard `/chatlog` → `WoWChatLog.txt` | **Never** | **Never** |
| Blizzard `/combatlog` → `WoWCombatLog.txt` | **Never** | **Never** |
| Third-party chat loggers (Elephant, etc.) | Do not depend | **Never** for public reports |
| Session night metrics ([39](../39-guild-calendar-events/beef-guild-night-instrumentation.md)) | Alpha/officer, session-scoped | Pasteable **summary** only; no chat text |

---

## 4. Names & redaction policy

| Rule | Detail |
|------|--------|
| Default dump | Self + aggregates; not a guild phonebook ([names-and-identifiers.md](names-and-identifiers.md)) |
| Public issues | Redact third-party character names in stacks and dumps |
| Streams | No surprise alt/officer-note dumps in default UI ([05](../05-packaging-community-antipatterns/05-implications-for-church-of-beef.md)) |
| Error strings | Authors avoid interpolating other players’ names into `error()`/`print()` |
| Account folder paths | Do not ask players to paste `WTF\Account\<id>\...` |

---

## 5. SavedVariables & export policy

| Rule | Detail |
|------|--------|
| Persistence | Per-character `ChurchOfBeefDB` (spec §9) — expected editable; not a trust boundary (§6.3) |
| Support | Prefer curated dump over SV zip |
| Private escalation | Maintainer may request SV **privately** for migration bugs; never commit player SV to git |
| Profiles / share strings | If V1+ adds import/export, export **UI prefs** carefully; never ship “whole guild ladder” share strings into public chat by default ([11](../11-onboarding-settings-ux/profiles-import-export.md) culture) |

---

## 6. BeefNet / sync diagnostics

| Rule | Detail |
|------|--------|
| Status dump may include | Protocol major, last soft-warn **code**, peer **count**, last commit age |
| Status dump must not include | Raw message bodies with names; full hello tables; other players’ standing maps |
| Throttle / spam | Debug prints must not create guild chat or addon-message storms ([14](../14-addon-messaging-beefnet/), [24](../24-policy-tos-compliance/) rule 3 harm) |

---

## 7. Data-handling bridge (track 24 only)

Reuse, do not re-litigate:

- No silent exfiltration / no unauthorized external score server ([24 data-exfiltration](../24-policy-tos-compliance/data-exfiltration-forbidden-apis.md)).
- Minimize stored guild data; BeefNet guild-scoped; no advertising telemetry.
- Chat/combat log files on disk are player-owned; Beef will not solicit them as normal bug input ([chat-logs-and-disk-artifacts.md](chat-logs-and-disk-artifacts.md)).

---

## 8. Support ask / don’t-ask (one-pager)

**Ask for**

- BugSack copy of one stack ([bugsack-safe-sharing.md](bugsack-safe-sharing.md))
- Addon version + `/dump select(4, GetBuildInfo())`
- Curated `/beef` status (when implemented)
- Repro steps; officer night-report summary fields if threshold tuning

**Don’t ask for**

- `WoWChatLog.txt` / `WoWCombatLog.txt`
- Full `!BugGrabber.lua` or whole WTF tree
- Full `ChurchOfBeefDB` on a public channel
- Screenshots of Discord/Battle.net with Real ID visible
- Other guildmates’ whispers or officer chat

---

## 9. Checklist for implementers (future code — not this folder)

- [ ] `COB.DEBUG` default false; help hides debug verbs
- [ ] Status dump follows allow/deny lists
- [ ] No `LoggingChat` / combat-log toggles
- [ ] No guild-chat debug emission
- [ ] Packager strips debug mutators on Release
- [ ] Contributor docs link this policy + BugSack paste template
- [ ] Public issue template mentions redaction

---

## 10. Related tracks

| Track | Relationship |
|-------|----------------|
| [19](../19-testing-debugging-qa/) | How to run QA / install BugSack |
| [24](../24-policy-tos-compliance/) | ToS / sandbox / minimize |
| [39](../39-guild-calendar-events/beef-guild-night-instrumentation.md) | Session metrics field list |
| [48](../48-feature-flags-rollout/) | Whether debug ships |
| [05](../05-packaging-community-antipatterns/) | Stream-safe defaults culture |
| [22](../22-slash-commands-ux/) | Slash surface map for `/beef debug` |
