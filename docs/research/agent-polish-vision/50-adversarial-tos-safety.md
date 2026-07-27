# 50 — Adversarial ToS / addon-policy safety (agent guardrails)

**Lane:** Agent polish vision — red-team pass before “juice” ships  
**Last updated:** 2026-07-26  
**Audience:** Coding agents implementing celebration, toasts, guild announce, SFX, motion, or anything that looks automated  
**Authority (product law):** `docs/superpowers/specs/2026-07-25-church-of-beef-design.md` §2, §10, §13.10–§13.11  
**Depth (do not fork here):** [`24-policy-tos-compliance/`](../wow-classic-addon-design/24-policy-tos-compliance/), [`72-guild-chat-announce-api/`](../wow-classic-addon-design/72-guild-chat-announce-api/), [`20-sound-sfx-feedback/`](../wow-classic-addon-design/20-sound-sfx-feedback/), [`14-celebration-spectacle-design.md`](14-celebration-spectacle-design.md), [`03-taint-lockdown-ux.md`](03-taint-lockdown-ux.md)  
**Repo rules:** `architecture-overview.mdc`, `verification.mdc`, `packaging-assets.mdc`, `beefnet-messaging.mdc`, `wow-ui-taint-lockdown.mdc`

---

## 0. One-screen verdict

Church of Beef is a **social announce / track / sync** addon. Polish that makes the guild feel a promotion is in-scope. Polish that **spams chat, sounds like a bot, looks like combat automation, or ships policy-illegal packaging** is out — even if it “feels epic.”

| Risk class | Policy hook | Beef failure mode |
|------------|-------------|-------------------|
| **Chat / realm impact** | UI Add-On Policy rule 3 (negatively impact other players; excessive chat) | Multi-line liturgy, peer echo `/g`, congrats-bot pile-ons |
| **Automation / cheating** | EULA bots/cheats + CoC third-party automation + secure API | Auto-cast/target/move; HW-event “fixes”; scrape-driven responders |
| **Client modification** | 2025 third-party software ban | Companion `.exe` / memory tools “for standing” |
| **Ads / donations** | UI policy rules 4–5 | Tip jars, sponsor frames, automated ad chat |
| **Audio copyright** | UI policy music note | Ripped Blizzard soundtrack in the zip |
| **Wagering / RMT** | EULA commercial / wagering | Betting UI, paid ranks, odds meters |
| **Player experience / a11y** | Rule 3 + community a11y norms | Sound spam, full-screen strobe, RAID_WARNING kit as social SFX |

**Adversarial stance for agents:** assume the next polish PR will try to “make spectacle louder.” Reject anything that fails §1 hard bans before debating taste.

---

## 1. Hard bans for agents (copy into PR review)

These are **never** “post-playtest nice-to-haves.” Stop the change; do not implement behind a feature flag without an explicit human product decision + design-spec decisions-log update.

### 1.1 Automation / ToS-shaped bans

| Ban ID | Hard ban | Why agents reach for it |
|--------|----------|-------------------------|
| **A1** | No bots, injection, protected-action bypass, auto-cast / auto-target / auto-move, or external process control | Spec §2; EULA/CoC; Classic secure model |
| **A2** | No `SecureActionButtonTemplate` / secure headers “to make the panel open in combat” or to fire macros | Looks like automation + taint/lockdown landmine |
| **A3** | No `TargetUnit` / `RunMacroText` / binding edits from events or juice timers | Hardware-event theater = ToS + API failure |
| **A4** | No companion `.exe`, AHK, pixel bot, memory read, or silent out-of-client telemetry | Client-mod / data-mining adjacency |
| **A5** | No auto guild-chat **replies**, welcome bots, or “congrats from every Beef client” | GuildCongrats-shaped spam; bot-looking |
| **A6** | No combat decision engine, rotation assist, or WeakAuras-style **gameplay** HUD as Beef juice | Wrong product; CoC unfair-advantage optics |
| **A7** | Officer Commit / Gora record / ceremony close require an **explicit human click** — never timer-auto-approve | Spec §6.3 officer anti-cheat |

### 1.2 Spectacle / chat spam bans

| Ban ID | Hard ban | Why agents reach for it |
|--------|----------|-------------------------|
| **C1** | **One** throttled plain `/g` line per institutional commit, from the **approving officer’s client only** | Spec §10; track 72 single-announcer |
| **C2** | Peers receiving `RANK_COMMIT` / sync **must not** `SendChatMessage` GUILD | N-client echo storm |
| **C3** | No multi-line liturgy walls, ASCII art, or drip-spam of flavor lines | Rule 3 + RTT disconnect culture |
| **C4** | No announce on suggestion create, reject, score ticks, login `SYNC_STATE`, or revision-ignore heals | False ceremony + spam |
| **C5** | No announce **before** local commit accept; no re-announce on double-click / replay without dedup | Lying spectacle |
| **C6** | Announce opt-out skips **chat only** — never silently skip Commit or toast as a “quiet mode” that hides authority | Spec §10 streamer/privacy lock |
| **C7** | No verbose `/beef debug` / SV dumps / officer notes / alt lists into guild chat | Privacy + rule 3 |
| **C8** | No auto-invite, auto-whisper, or ambient `/g` from media/timers | `packaging-assets.mdc` quiet-by-default |

### 1.3 Automation-looking juice bans (even if “just UI”)

| Ban ID | Hard ban | Why agents reach for it |
|--------|----------|-------------------------|
| **J1** | No center-screen WA-style pulse / full-screen tint / strobe for social promote | Combat HUD confusion + photosensitivity |
| **J2** | No permanent `OnUpdate` for scoring, net, or SV; juice OnUpdate must detach when idle | Perf + “always watching” bot optics |
| **J3** | No continuous minimap / seal pulse forever | Looks like an alert bot |
| **J4** | UI never awards points; Net never invents ranks; Core never `CreateFrame` | Layer law = trust + anti-cheat honesty |
| **J5** | No `GuildPromote` / Blizzard guild-rank APIs as celebration | Wrong authority surface |
| **J6** | No camera shake / whirling camera / fullscreen alert textures as ceremony | A11y + “hijacked client” feel |
| **J7** | Do not open Blizzard panels (`ShowUIPanel`, guild roster) as side effects of Commit juice | Taint + lockdown + surprise UX |

### 1.4 Sound spam / media bans

| Ban ID | Hard ban | Why agents reach for it |
|--------|----------|-------------------------|
| **S1** | **V1 ships silent** — no promote/credit SFX in the default path | Spec §10 / §15 |
| **S2** | Post-V1 SFX (if any): **default off**, one-shots only, cooldown, never on login sync | Track 20 spam lessons |
| **S3** | Never bundle ripped Blizzard soundtrack / VO | UI policy music copyright note |
| **S4** | Never use `SOUNDKIT.RAID_WARNING` / ready-check / boss-mod kits as default social SFX | Trains combat reflexes; stream ear fatigue |
| **S5** | Never force Master channel to defeat mute / Effects-off | Accessibility + streamer courtesy |
| **S6** | Mute SFX ≠ mute guild announce; announce opt-out ≠ global mute | Spec §10 separation |
| **S7** | No sound on co-play standing ticks or suggestion drip | Highest-frequency spam surface |

### 1.5 Packaging / monetization bans

| Ban ID | Hard ban | Why agents reach for it |
|--------|----------|-------------------------|
| **P1** | No ads, sponsor frames, tip jars, or donation CTAs in game UI or automated chat | UI policy rules 4–5 |
| **P2** | No premium / Patreon-gated core features or paid rank unlocks | UI policy rule 1 |
| **P3** | No obfuscated / encrypted Lua or binary companion required for core logic | UI policy rule 2 |
| **P4** | No wagering, buy-ins, odds meters, or real-money stakes on Gora/BG | EULA wagering / RMT adjacency |
| **P5** | No Retail-only APIs; Interface stays `20506` unless intentionally bumped | Spec §13.10 |

---

## 2. Adversarial threat model (what “helpful” agents invent)

Attack the polish prompt: *“Make promotions feel more epic.”*

| Temptation | Looks like | Policy / product hit | Replace with |
|------------|------------|----------------------|--------------|
| 3–5 `/g` lines of liturgy | Guild spam bot | Rule 3; C3 | One ≤255 plain sentence |
| Every online Beef client announces | Echo storm | C2; disconnect/RTT | Approving officer only |
| Auto “Congratulations!” from members | Congrats addon bot | A5; CoC optics | Human chat is the §13.11 win |
| Center pulse + RAID_WARNING SFX | WA / DBM alert | J1; S4 | Edge toast + `/g` text |
| Standing-tick ding every co-play second | Farm meta audio bot | S7 | Silent credit; toast coalesce |
| Timer auto-approves pending queue | Officer bot | A7 | Human Commit click |
| Secure button “so combat works” | Protected bypass | A2 | Insecure Beef frame; queue chrome |
| Tip jar “support the Church” | In-game donation | P1 | Website / CurseForge only |
| “Bet on Gora” meter for stream | Wagering UI | P4 | Theatrical record only |
| Login sync fanfare for everyone | False ceremony storm | C4; S2 | Silent heal |

**Social check (§13.11) is not a license to spam.** One visible guild reaction to one honest line beats a wall of addon noise.

---

## 3. Allowed spectacle budget (safe corridor)

Agents may implement **only** inside this corridor unless product law changes:

```text
Institutional outcome (promote / demote / Council / Prophet)
  → Officer+ human Commit succeeds locally
  → BeefNet RANK_COMMIT (CTL)
  → Optional: ONE GUILD SendChatMessage (CTL NORMAL, ≤255, plain)
       from approving officer if ui.announce
  → Local edge toast(s) for relevant clients
  → Optional: short AnimationGroup / UIFrameFlash on toast panel only
  → V1: no SFX
```

| Channel | Allowed | Cadence |
|---------|---------|---------|
| Guild chat | One plain line / commit | Officer-owned; opt-out |
| Edge toast | Opaque Beef plate on `UIParent` | Coalesce; no stack storms |
| Ladder row flash | One-shot if frame open | Not forever |
| Officer AttentionKit | Local RaidNotice / print / `FlashClientIcon` for **pending queue** | Never as member promote toast; never `SendChatMessage` RAID_WARNING |
| BeefNet | Commits + login sync | Throttled; not every score tick |
| SFX | None in V1 | Later: default off |

Depth recipes: [`14-celebration-spectacle-design.md`](14-celebration-spectacle-design.md), track [`72`](../wow-classic-addon-design/72-guild-chat-announce-api/beef-v1-announce-pipeline.md).

---

## 4. Pre-merge adversarial checklist (agents)

Run before claiming a juice / announce / SFX / motion task done:

- [ ] Diff contains **no** new `SendChatMessage` paths except the single officer announce pipeline (or none)
- [ ] Peers applying `RANK_COMMIT` cannot reach GUILD chat send
- [ ] No multi-line / looped chat; copy ≤255; CTL used
- [ ] No announce on sync heal / suggestion / score tick
- [ ] Dedup prevents double-click re-announce
- [ ] Opt-out tested: chat off, Commit + toast still on
- [ ] No center-screen / full-screen strobe; no permanent OnUpdate
- [ ] No new SFX in V1; if any sound file added later → default off + mute path
- [ ] No ripped Blizzard audio; no RAID_WARNING kit as social default
- [ ] No Secure* templates, TargetUnit, RunMacroText, ShowUIPanel side effects
- [ ] No ads / tip jars / wagering chrome
- [ ] Offline: `lua tests/run.lua` exit 0 when Core/Data/harness touched
- [ ] In-game (if UI/Net/announce touched): `/console scriptErrors 1` → `/reload` → exercise Commit path
- [ ] Two-client check for guild/net announce (officer + member): **one** `/g` line total

---

## 5. Severity rubric (how to fail a PR)

| Severity | Examples | Agent action |
|----------|----------|--------------|
| **Block merge** | A1–A7, C1–C5, C7–C8, J1/J4/J5, S3–S4, P1–P5 | Revert or rewrite; cite ban ID |
| **Must-fix before ship** | C6 mis-wired mute, toast stack storms, missing CTL, announce before commit | Fix in same PR |
| **Playtest watch** | Toast duration taste, copy tone, optional post-V1 soft SFX defaults | Human guild-night; not agent invention |
| **Out of scope** | Combat HUD parity with DBM/WA, congrats bots, betting | Refuse; point to this doc + track 24 |

Critique rubric hard-fails (aligned): [`25-ui-polish-critique-rubric.md`](25-ui-polish-critique-rubric.md) — center-screen social pulses, unthrottled guild spam, ripped audio, juice that implies botting.

---

## 6. What this note does **not** decide

- Exact announce copy (track 32 / design glossary)
- CTL byte budgets (tracks 14 / 72)
- Whether V2 ceremonial dashboard exists (deferred in spec)
- Website donation desirability (only: never in-game)

If a change would automate play, flood chat, default-on loud audio, monetize access, or wager on outcomes: **update the design-spec decisions log** after re-reading live Blizzard policy URLs in track 24 — do not silently fork policy into polish code.

---

## 7. Primary citations (re-check before distribution fights)

| Source | Use |
|--------|-----|
| [UI Add-On Development Policy (US)](https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534) | Free, visible code, no ads/donations in-game, no realm/player harm, ToU/EULA |
| [Blizzard EULA](https://www.blizzard.com/en-us/legal/fba4d00f-c7e4-4883-b8b9-1b4500a402ea/blizzard-end-user-license-agreement) | Bots, cheats, data mining, wagering, commercial ads |
| [In-Game Code of Conduct](https://us.battle.net/support/en/article/42673) | Third-party automation = cheating |
| [Prohibitions on Third-party Software (2025-08)](https://us.forums.blizzard.com/en/wow/t/prohibitions-on-third-party-software/2142972) | Client-modifying software ≠ ordinary Lua addons |
| [Secure Execution and Tainting](https://warcraft.wiki.gg/wiki/Secure_Execution_and_Tainting) | Classic cannot / must not automate combat via addon logic |

Internal synthesis: [`24-policy-tos-compliance/church-of-beef-implications.md`](../wow-classic-addon-design/24-policy-tos-compliance/church-of-beef-implications.md).

---

*Keep sticky honey on Beef frames. Keep spectacle in one officer `/g` line + private edge toasts. Keep the client quiet, human-gated, and Teen-safe. If polish looks like a bot, it is already wrong.*
