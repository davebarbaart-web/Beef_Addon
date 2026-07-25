# Single-announcer patterns (Gargul & cousins)

**Track:** [72-guild-chat-announce-api](README.md)  
**Last updated:** 2026-07-25  

Classic loot/social tools already solved “everyone installed the addon → N clients shout.” Steal **ownership**, not loot chrome. Cousin UX tear-downs: [13 Gargul](../13-cousin-addon-teardowns/gargul.md), [13 Attune](../13-cousin-addon-teardowns/attune.md).

---

## Gargul — master-looter owns chat

| Fact | Source |
|------|--------|
| Default: when **ML loots** a fresh corpse, Gargul posts drops (+ SoftRes) to **raid/party** | [Announcing Loot in Chat](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat) |
| Toggle: “Announce loot to chat” off = silence | Same |
| Quality / SoftRes content knobs reduce spam | Same |
| Product stance: **only the loot master needs Gargul** for most features; raiders optional | [Wago Gargul](https://addons.wago.io/addons/gargul); [CurseForge](https://www.curseforge.com/wow/addons/gargul) |
| SoftRes **Broadcast** restricted to masterlooters | [Importing Soft Reserves](https://github.com/papa-smurf/Gargul/wiki/Importing-Soft-Reserves) (via [13](../13-cousin-addon-teardowns/gargul.md)) |

**Mechanism of single announcer:** the event that triggers chat is **ML loot / ML action** on one client — not “every Gargul user saw the corpse.” Peers with Gargul get widgets; they do not all re-broadcast the loot list.

**Steal for Beef:**

1. **Authority client speaks** (ML ≈ approving Officer+).  
2. **Plain Blizzard chat** so non-installers see outcomes.  
3. **Opt-out + quality/content gates** (Beef: opt-out + one line only; no quality ladder).  
4. **Severity ladder** idea: quieter list vs louder decision — map to toast (self) vs `/g` (institution), not raid warning spam.

**Avoid:** corpse-loot multi-line walls; raid-warning for every promote.

---

## RCLootCouncil — ML announces awards / considerations

Documented under Master Looter → Announcements ([RCL Options wiki](https://rclootcouncil.com/wiki/Options)):

| Pattern | Notes |
|---------|-------|
| **Announce Awards** | Default **on**. ML sends when awarding; up to two channels; message “sent directly as if you wrote it yourself.” |
| **Channels** | Selectable; `"Group"` resolves to party/raid; invalid channel → local print fallback. |
| **Announce Considerations** | Default **off**. Header + **one chat line per session item** — deliberate multi-send. |
| Keyword templates | `&i` item, `&p` player, etc. — copy craft → track [32](../32-microcopy-tone-voice/), not this track. |

**Steal:** channel send is **ML-owned** and opt-outable; award announce defaults on (spectacle lives).  
**Avoid for Beef:** consideration-style fanout (N lines per ceremony). Beef stays at **one message total** per rank commit — closer to a single Award Announcement than a Considerations blast.

---

## Attune — celebrate completion, not every drip

Attune can announce attunement **complete** to chat (toggle in options) — event-gated celebration, not per-quest spam ([13 Attune](../13-cousin-addon-teardowns/attune.md); [CurseForge Attune](https://www.curseforge.com/wow/addons/attune)).

**Steal:** announce on **institutionally meaningful** events (rank commit), not every standing point.  
**Avoid:** survey-style “everyone reports” fan-in for chat (Attune surveys are pull snapshots, not N-way `/g`).

---

## Anti-patterns (all cousins agree by omission)

| Anti-pattern | Failure |
|--------------|---------|
| Every peer echoes the same promote on `RANK_COMMIT` receive | Duplicate `/g` lines; stream spam; ignore-list chaos |
| Announce from suggestion create | False ceremony; officers may reject |
| Announce from login sync heal | Offline officers “announce” stale history |
| Member client announces on toast | Spoofable spectacle; breaks authority |

---

## Mapping table → Beef

| Cousin role | Beef role |
|-------------|-----------|
| Master looter | Approving Officer+ |
| Raid/party chat | **Guild** chat |
| “Announce loot to chat” | “Announce rank changes to guild chat” |
| Min quality / omit SoftRes | V1: no extra knobs — one line or silence |
| Raiders without addon still see chat | Members without Beef still see `/g` |

Deeper UX choreography (queue → confirm → commit) stays in [13](../13-cousin-addon-teardowns/) / [58](../58-staticpopup-confirms/); this track only locks **who hits SendChatMessage**.
