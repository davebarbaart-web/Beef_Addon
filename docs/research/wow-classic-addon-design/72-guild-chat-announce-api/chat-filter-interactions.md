# Chat filters vs announce **send** path

**Track:** [72-guild-chat-announce-api](README.md)  
**Last updated:** 2026-07-25  

Receive-side failure modes (profanity asterisks, ignore, StreamerMode name rewrite, BadBoy/GIL) are owned by track [61 — chat-filters-and-spectacle](../61-streamer-mode-privacy/chat-filters-and-spectacle.md). This note only lists **send-path hygiene** that reduces those failures and spam-filter false positives.

```text
Send hygiene (THIS TRACK)          Receive filters (TRACK 61)
  one line / plain text     ──►      profanityFilter display
  no icon/URL spam shapes   ──►      spamFilter / GIL / BadBoy
  officer-owned cadence     ──►      Ignore of approving officer
```

---

## Send hygiene checklist (API / throttle track)

| Practice | Why | Owner |
|----------|-----|-------|
| One plain-text line, no raid target icons | Chat Filter–class addons strip markers; looks spammy | Send pipeline |
| No URLs / gold-seller punctuation | Keyword spam heuristics | Send pipeline |
| No identical line spam / retries | Duplicate filters; RTT lore ([rate-limits](rate-limits-and-ctl.md)) | Throttle + dedup |
| No item/spell links in V1 promote lines | Link spoof disconnect risk + filter noise ([constraints](sendchatmessage-guild-constraints.md)) | API constraints |
| No multi-line “header + body” like RCL Considerations | Looks like bot spam; burns CTL burst | Single-announcer |
| Do not bypass `profanityFilter` | Display-side Blizzard Social option — not ours to defeat | [61](../61-streamer-mode-privacy/) + [32](../32-microcopy-tone-voice/) smoke-test copy |
| Expect ignore of approving officer | Receiver silent ≠ send failed | [61](../61-streamer-mode-privacy/) |

---

## What the sender cannot fix

| Receiver state | Effect | Ops / product response |
|----------------|--------|------------------------|
| Ignored the approving officer | Guild line suppressed for that client ([Ignore](https://wowpedia.fandom.com/wiki/Ignore)) | Not a BeefNet bug; toast still reaches promotee if online with addon |
| `profanityFilter` on | Asterisks on **their** display only | Ceremony checklist in [61](../61-streamer-mode-privacy/); copy smoke-test in [32](../32-microcopy-tone-voice/) |
| Guild tab hidden / filtered | “Nobody reacted” | Guild-night ops ([51](../51-guild-night-playbook/)) |
| Third-party “filter everything” | Possible drop despite guild exemptions | Recommend GIL never-filter-guild ([61](../61-streamer-mode-privacy/chat-filters-and-spectacle.md)) |

Promotee awareness still needs **local toast** (spec §10 toasts; track [49](../49-officer-notifications/) for officer breadcrumb norms) — do not rely on `/g` alone for the subject player.

---

## Boundary

| Track | Owns |
|-------|------|
| **72 (this)** | Emit shapes + cadence that survive spam heuristics |
| [61](../61-streamer-mode-privacy/) | CVars, ignore, name obfuscators, receive failure modes |
| [32](../32-microcopy-tone-voice/) | Words that survive mature-language filters |
