# `/beef debug` dump allow / deny lists

**Track:** [65-debug-dumps-privacy](README.md)  
**Last updated:** 2026-07-25  
**Purpose:** Decide what pasteable diagnostics include — without redefining QA tooling ([19](../19-testing-debugging-qa/)) or ToS ([24](../24-policy-tos-compliance/)).

Names like `/beef debug status` / `/beef dump` are illustrative (plan uses `/beef debug standing`; track [39](../39-guild-calendar-events/beef-guild-night-instrumentation.md) sketches `/beef night report`). Policy applies to any copy-paste support surface.

---

## 1. Design goal

A dump answers: *which build, which client, which local church state, what failed* — in a paste small enough for Discord and boring enough for a stream overlay glance.

It does **not** answer: *give me your guild’s database*.

Built-in cousin: Blizzard `/dump` pretty-prints a value to chat via `DevTools_Dump` ([World of Warcraft API — Debugging](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API)). Authors often ask for `/dump select(4, GetBuildInfo())` ([Getting the current interface number](https://warcraft.wiki.gg/wiki/Getting_the_current_interface_number)). Beef dumps should be curated strings, not recursive dumps of `ChurchOfBeefDB`.

---

## 2. Allow list (safe by default)

| Category | Examples | Why |
|----------|----------|-----|
| **Build identity** | Addon `Version` / TOC metadata; `select(4, GetBuildInfo())`; flavor note (Anniversary TBC) | Repro without opening WTF |
| **Protocol** | BeefNet major/minor; last soft-warn reason code (enum, not raw payload) | Sync bugs |
| **Gate snapshot** | `COB.DEBUG` on/off; announce opt-out boolean; officer UI visible yes/no | Explains missing verbs |
| **Self state** | Reporter standing, title, pending self-suggestion count | Ladder bugs about *you* |
| **Aggregate guild cache** | Online addon peers count; ladder size; pending suggestion *count*; commit revision id | Scale/sync without a roster dump |
| **Error pointer** | Last BugGrabber error id + truncated message (≤1 stack) if Beef-attributed | Links to BugSack paste |
| **Session metrics summary** | Night report: deltas by source, approve/reject counts, social-check yes/no ([39](../39-guild-calendar-events/beef-guild-night-instrumentation.md)) | Threshold tuning |
| **Timestamps** | Session start/stop wall clock; “seconds since last RANK_COMMIT seen” | Ordering bugs |

Optional one-liner footer: “Do not paste SavedVariables or chat logs.”

---

## 3. Deny list (never in a default dump)

| Category | Examples | Why |
|----------|----------|-----|
| **Full SavedVariables** | Entire `ChurchOfBeefDB` serialized to chat/Discord | Alts, history, UI prefs, cache of others; WeakAuras-scale privacy ([WA template](https://github.com/WeakAuras/WeakAuras2/blob/main/.github/ISSUE_TEMPLATE/bug_report.yml) only asks for SV as last resort) |
| **Full roster tables** | Every guild member name + standing + rank | Third-party PII to public channels; stream-unsafe |
| **Officer notes / suggestion rationales** | Free-text officer comments, confession-like notes | Spec streamer positioning + guild trust ([05 implications](../05-packaging-community-antipatterns/05-implications-for-church-of-beef.md)) |
| **Chat / whisper text** | Guild lines, tells, officer chat excerpts | See [chat-logs-and-disk-artifacts.md](chat-logs-and-disk-artifacts.md) |
| **Combat log** | `WoWCombatLog.txt` excerpts | Wrong product; noisy; names + ability spam |
| **Wire payloads** | Raw `SendAddonMessage` bodies, full peer hello tables with names | Protocol archaeology belongs in private alpha Discord, redacted |
| **Filesystem paths** | `WTF\Account\<id>\...` | Account folder IDs are not character names; do not teach players to paste them |
| **Other addons’ DBs** | ElvUI / Altoholic / BugGrabber full SV | Out of scope; BugGrabber file is a multi-addon error archive |
| **Continuous telemetry** | Auto-append every login to a growing public paste | Privacy + SV bloat ([39 skip list](../39-guild-calendar-events/beef-guild-night-instrumentation.md)) |

---

## 4. Conditional allow (officer / private only)

These may appear in **officer-private** Discord or alpha channels after an explicit ask — never as a default `/beef` print to guild chat, never auto-posted.

| Item | Condition |
|------|-----------|
| Single other player’s standing row | Officer debugging a specific suggestion; redact on public GitHub |
| Truncated BeefNet message hex / length | Protocol bug; no character names in the blob |
| Night-log JSON slice | Alpha instrumentation; strip free-text notes first |
| Screenshot of Officer tab | Crop Discord/Battle.net overlays; blur non-involved names if streaming |

---

## 5. Channel rules for dumps

| Surface | Allowed dump |
|---------|--------------|
| Guild chat | **None.** No `/beef debug` spam to `/g`. |
| Player’s default chat frame | Short status / debug (local print) |
| Clipboard / Discord #bugs (private) | Allow-list paste + one BugSack stack |
| Public GitHub Issues | Allow-list + redacted stack; no SV zip by default |
| Stream overlay | Avoid verbose debug; use silent clipboard if possible |

`print` / chat-frame output can land in a viewer’s chat log buffer and in `WoWChatLog.txt` if `/chatlog` is on ([MACRO chatlog](https://warcraft.wiki.gg/wiki/MACRO_chatlog)). Prefer a dedicated editbox “Copy” for long dumps (BugSack pattern) over flooding chat.

---

## 6. Implications for Church of Beef

1. Ship (when implemented) a **curated** status dump, not `DevTools_Dump(ChurchOfBeefDB)`.
2. Keep forge/standing mutators and verbose dumps behind `COB.DEBUG` / packager strip ([48](../48-feature-flags-rollout/)).
3. Document the allow/deny lists in contributor/tester README later — this research is the source of truth for that copy.
4. Align night-report fields with [39](../39-guild-calendar-events/beef-guild-night-instrumentation.md): counts and booleans, not chat text.
