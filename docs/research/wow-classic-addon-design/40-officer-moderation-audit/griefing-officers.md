# Griefing officers

**Maps to:** Spec §6.2 authority, §4.3 demotion, §10 Officer tab, §11 “Non-officer forged approve”  
**Question:** What abuse remains when the officer *is* the trusted writer — and what can product do?

---

## Threat model shift

BeefNet correctly treats **non-officer forged `RANK_COMMIT`** as invalid (sender identity is server-supplied; roster rank-index checked). That closes the “random member promotes themselves” cheat.

It does **not** close:

| Vector | Example |
|--------|---------|
| **Malicious Officer+** | Mass demote, Prophet bestowal to alt, standing wipes |
| **Compromised officer account** | Same powers as malicious officer |
| **Too-wide Officer+ threshold** | Many alts with edit-power ranks mint commits |
| **Concurrent officer race** | Two officers offline mint conflicting equal revisions ([27](../27-desync-conflict-resolution/)) |
| **Opacity grief** | Approve/reject with no announce, no reason, no shared log — gaslighting |
| **Spectacle grief** | Spam guild-chat promotion lines / cruel demotion announces |

Classic loot-council culture is explicit: the system collapses without trust; favoritism perception kills guilds ([Blizzard forum LC critique](https://us.forums.blizzard.com/en/wow/t/loot-council-is-not-a-good-system/244456); [Guild Order LC failure mode](https://guildorder.com/games/wow/guides/loot-systems-dkp-vs-epgp)).

---

## What product can mitigate (not prevent)

### 1. Narrow the pen

- Keep default Officer+ threshold tight (spec: GM + top officer rank index).  
- Document: “Beef Officer+ ≠ every raid assist.”  
- Guild process: only ranks that may edit officer notes / lead raids get the threshold.

### 2. Friction by risk tier (four-eyes lite)

From [Flagsmith — four eyes](https://www.flagsmith.com/blog/what-is-the-four-eyes-principle): risk-tier approvals; no self-approval workarounds for high-risk; emergency bypass still logged.

| Action | V1 friction | Later optional |
|--------|-------------|----------------|
| Approve rank 1→2 / 2→3 | Low (one click) | — |
| Approve into Butcher | Confirm | Second officer ack |
| Reject | Low; reason recommended | — |
| Standing wipe / large adjust | Confirm + reason required | Second officer |
| Demote / excommunicate | Confirm + reason; announce default on | Second officer |
| Council appoint / Prophet | Confirm; seat/uniqueness checks | Second officer / GM-only flag |

Full maker-checker is **not** V1 — comedy pacing and offline officers fight dual-approval. Use confirms + audit first.

### 3. Make grief visible

- Shared officer audit (who demoted whom).  
- Guild-chat announce on demote (spec already first-class) — cruel, but **visible**; silent demote is worse for trust.  
- Per-officer announce opt-out must not become “stealth demote mode”; if announce off, still write audit.

### 4. Recovery path

- Any other Officer+/GM can mint a compensating commit.  
- UI: show last N high-risk actions guild-wide so a GM can spot a rampage on login.  
- Social: remove WoW guild rank from griefer — Addon threshold then stops accepting their commits after roster updates.

### 5. Don’t give officers invisible superpowers

- No “edit history erase.”  
- No member-invisible rank for officers’ alts unless appointed through same UI.  
- Manual standing adjust should show before→after in the confirm.

---

## What product must not pretend

- Addon cannot adjudicate “officer drama” better than guild leadership.  
- Cryptographic multi-sig across clients is out of scope and culturally wrong for this project.  
- Auto-revert “suspicious” officer bursts risks griefing the *good* officers during a ceremony night.

---

## Insight

Treat Officer+ grief as **insider threat + social process**. Ship visibility and friction; keep the GM’s WoW rank as the real kill-switch.
