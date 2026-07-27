# 44 — Officer Commit flow UX juice

**Lane:** Agent polish vision  
**Date:** 2026-07-26  
**Maps to:** [Church of Beef V1 design](../../superpowers/specs/2026-07-25-church-of-beef-design.md) §6–§8, §10–§11, §13 · [ladder-authority](../../../.cursor/rules/ladder-authority.mdc) · [officer-guild-roster](../../../.cursor/rules/officer-guild-roster.mdc) · [scoring-coplay](../../../.cursor/rules/scoring-coplay.mdc)  
**Cousins:** [69 Officer tab IA](../wow-classic-addon-design/69-officer-tab-ia/) · [58 confirms](../wow-classic-addon-design/58-staticpopup-confirms/) · [72 announce](../wow-classic-addon-design/72-guild-chat-announce-api/) · [03 taint/lockdown UX](03-taint-lockdown-ux.md) · [18 color hierarchy](18-color-hierarchy-readability.md) · [12 social loops](12-social-progression-loops.md)  
**Status:** Research guidance for UI polish — **not product law**. Spec + Core APIs win. UI never invents ranks or awards points.

---

## 1. Verdict

Officer **Commit** is the only moment advisory standing becomes **official church state**. Juice must make that clergy judgment feel deliberate, readable, and spectacular — without letting the UI pretend it scored anyone.

| Layer | Owns | UI may |
|-------|------|--------|
| Scoring | Capped local grants → `MaybeSuggest` | Show standing / events / petition badge |
| Officer gate | Roster `rankIndex ≤ OfficerRankIndexMax` | Hide tab; disable; clear deny copy |
| Ladder Commit | Official rank/standing + `revision++` | Call Core; refresh; toast; trigger announce policy |
| BeefNet | Validate sender Officer+; replicate | Never invent commits; never peer-`/g` |
| Announce | One throttled `/g` from approving officer | Show opt-out; never celebrate before Commit succeeds |

**Doctrine:** *Process chrome is Classic; brand lives in words (toast + guild line). Anticipation is selection + evidence, not a fake XP bar. Fanfare is post-Core success only.*

---

## 2. Authority boundary (non-negotiable)

```text
Member events → Core Scoring (local standing + caps)
              → Ladder.MaybeSuggest          -- NEVER auto-promote
              → Officer+ UI selection
              → Ladder:Commit (+ revision)   -- Core only
              → Net RANK_COMMIT
              → peers: validate Officer+ → ApplyRemoteCommit → UI refresh
              → (approving client) optional GUILD announce
```

### UI must never

- Call scoring grant helpers or invent standing deltas on Approve  
- Set `rankId` / bump `revision` locally outside `Ladder:Commit` / remote apply path  
- Treat “I am Officer+” from a UI flag as wire truth (receivers re-check roster)  
- Open Blizzard GuildFrame as a side effect of Commit  
- Auto-accept nuclear StaticPopup on timeout  
- Fire guild announce before local Commit accepts  

### UI may

- Read queue / evidence / gate state from Core  
- Disable or hide controls when not Officer+ or roster unknown  
- Show anticipation chrome (selection, preview titles, button press states)  
- After successful Core return: `RefreshLadder`, Recent Actions row, private toast, announce helper  

**Reject clears suggestion only** — standing remains unless officer corrects via Core.

---

## 3. Risk ladder → confirm friction

Locked (glossary 70 / track 58 / Officer IA):

| Action | Modal? | Juice focus |
|--------|--------|-------------|
| Approve suggestion → Commit | **No** | Anticipation in evidence; instant commit fanfare |
| Reject suggestion | **No** (clear label) | Soft settle; no spectacle |
| Standing adjust (small) | Optional light confirm | Procedural success toast |
| Standing adjust (large / wipe) | **Yes** + named subject | Nuclear cadence |
| Demote / Council / Prophet | **Yes** + named subject | Anticipation in modal; heavier fanfare |

Approve stays one-click after selection so promotion night stays scannable. Nuclear rites steal Gargul “confirm before award” friction — never put that modal on every Approve.

---

## 4. Officer-gate clarity

Gate is **roster rank index**, not rank name, invite rights, or a sticky UI boolean.

| Situation | Surface | Copy tone |
|-----------|---------|-----------|
| Not Officer+ | Hide Officer tab entirely | No teaser admin chrome |
| Roster not yet known | Hide / treat as not Officer+ | Soft: “Guild roster loading…” if `/beef` open mid-login |
| Was Officer+, demoted | Tab vanishes next refresh; buttons no-op | One procedural line if they click a stale control |
| In guild, Officer+, queue empty | Zones A/B empty; C+D remain | Quiet empty — teach, don’t shame |
| Not in guild | Empty ladder; scoring/net paused | Spec §11 empty-state; no Commit path |

**Hard validate before mutate and before send** (track 48). Soft UI is courtesy; Core + BeefNet are the real gate.

Dual-encode officer affordances (scarlet pip / tab structure) — never color-only “you may Commit.”

---

## 5. Interaction storyboard

Primary happy path: **threshold suggestion → Approve → Commit**. Nuclear rites share the success/error grammar with a modal Act inserted.

### Cast & surfaces

| Actor | Surface |
|-------|---------|
| Approving officer | Officer tab zones A–D, private edge toast, optional `/g` |
| Promotee (online, addon) | Private toast + Ladder / My Standing refresh via BeefNet |
| Flock (no addon OK) | One guild-chat liturgy line |
| Peers with addon | Ladder refresh + toast; **no** second `/g` |

### Beat sheet (Approve → Commit)

```text
T+0.00  IDLE
        Officer tab open. Zone A shows FIFO petitions.
        Oldest auto-selected (IA default). Approve/Reject idle.

T+0.00  SELECT (anticipation — cheap)
        Click petition row (or keep auto-select).
        • Row: selected highlight + dual-encoded “Pending”
        • Zone B: name (class color), current → suggested titles (canon strings),
          standing, source breakdown, last-N events
        • Preview line: “Recognize {Name} as {SuggestedTitle}”
        • Approve enabled only if LocalIsOfficer ∧ roster ready ∧ selection valid
        Juice: 80–120ms selection ease; no center pulse; no SFX in V1

T+0.00  HOVER / PRESS (anticipation — tactile)
        Approve: brief pressed inset (template button), label stays procedural
        “Approve” / “Recognize” — not meme obscurity (lore bible)
        Optional 1-frame scarlet underline on preview titles (post–hex lock only)

T+0.00  CLICK APPROVE (authority handoff)
        UI disables Approve/Reject for this row (anti double-click)
        Shows micro status on evidence footer: “Committing…”
        Calls Core only — no standing math in UI

T+0..1  CORE COMMIT (truth)
        Ladder:Commit → revision++ → SV path as designed
        On nil/err → jump to ERROR beats (no toast success, no announce)

T+0..1  REPLICATE
        BeefNet SendRankCommit(record)  -- best-effort; do not block fanfare on ACK

T+0..1  ANNOUNCE POLICY (side effect of success)
        If opt-in ∧ IsInGuild ∧ speak: one GUILD line (CTL), ≤255 plain
        If skip/fail: local warning only; Commit still stands

T+0.05–0.15  SUCCESS FANFARE (private, edge)
        Officer toast: check + “Recognized” + {Name} → {Title}
        Promotee toast (if online): title hero line, short
        Dual-encode teal/check — never Uncommon neon green alone
        Edge toast AnimationGroup: fade+slide ~200–350ms; hold ~3–4s
        NO center-screen WA pulse; NO SFX V1

T+0.10–0.25  INSTITUTIONAL SETTLE
        Refresh Ladder (occupant move / highlight)
        Remove petition from A; auto-advance to next oldest
        Zone D: append Recent Action (actor / Recognize / before→after)
        Clear “Committing…”; re-enable controls for new selection

T+social  SPECTACLE
        Guild chat line visible to flock → §13.11 success criterion
        Stream-readable; one line only
```

### Beat sheet (Reject)

```text
SELECT → evidence loaded (same anticipation)
CLICK Reject → Core clears suggestion (standing untouched)
SOFT SETTLE: dusty-rose “Rejected” + X on toast OR inline row flash
Recent Actions: Reject row (no /g, no ladder rank change)
Advance selection; no fanfare stagger
```

### Beat sheet (Nuclear rite — Demote / Council / Prophet)

```text
Rites zone C → named subject chosen
MODAL OPEN (anticipation + friction)
  Named subject + named consequence + escape cancels + timeout=0
  showAlert when demote / Prophet replace / wipe
CONFIRM Accept → same CORE → REPLICATE → ANNOUNCE → FANFARE grammar
  Fanfare copy uses rite verbs: elevate / seat / anoint / return / excommunicate
CANCEL / ESC → no Core call; soft return to rites
```

### Timing budget (V1 juice, silent)

| Phase | Target | Cap |
|-------|--------|-----|
| Selection highlight | 80–120ms | 200ms |
| Commit disable / “Committing…” | Immediate | — |
| Edge toast in | 200–350ms | 500ms |
| Toast hold | 3–4s | 5s |
| Ladder row settle | with refresh | no multi-second choreography |
| Stagger officer toast → ladder | 50–150ms | avoid waiting on `/g` RTT |

Announce may lag CTL; **never** delay private recognition on chat send.

---

## 6. Confirmation patterns (detail)

### 6.1 Approve — confirm without a modal

Anticipation **is** the confirm:

1. Selected subject always visible in B  
2. Preview consequence line (from → to title)  
3. Evidence before the button (breakdown + events)  
4. Button label = judgment verb, not “OK”  
5. Brief disabled “Committing…” prevents fat double Commit  

If playtest proves accidental Approves, add **optional** “Hold Shift to Approve” later — do not silently add a modal (would fight glossary 70).

### 6.2 Nuclear modal contract

Reuse track 58:

- Named `%s` subject + consequence  
- `hideOnEscape`, `timeout = 0`, `whileDead = true`  
- Officer+ gated **before** show  
- OnAccept → Core Commit only  
- Nil `StaticPopup_Show` → soft toast “could not open confirm”; never treat as Accept  
- Prefer `preferredIndex = 3` or own insecure confirm frame  

---

## 7. Success fanfare (what “juice” means here)

Fanfare is a **bundle of truth displays**, not a second scoring system.

| Channel | Who | Content |
|---------|-----|---------|
| Private edge toast | Officer + promotee clients | Dual-encoded Recognized / rite verb + titles |
| Ladder refresh | All addon clients after apply | Occupancy / self highlight |
| Recent Actions | Approving officer | Audit alibi |
| Guild chat | Whole guild (incl. no addon) | One liturgy line from approver only |

**Intensity by rite**

| Rite | Toast weight | `/g` | Extra |
|------|--------------|-----|-------|
| Points promote (Approve) | Standard | Yes | Auto-advance queue |
| Council appoint | Standard+ | Yes | Seat count in evidence/modal |
| Prophet bestow | Highest private copy | Yes | Still no center pulse |
| Demote | Standard, deep-rose encode | Yes | Never soft-hide |
| Reject | Soft only | No | — |
| Standing tweak in-band | Minimal | No | — |

V1 remains **silent** (no SFX). Post-V1 optional one-shots default off; never ripped Blizzard audio.

---

## 8. Error & degraded states

Procedural voice; sacred jokes never on sync/permission failures (lore bible).

| Failure | Player-visible | Commit? | Announce? |
|---------|----------------|---------|-----------|
| Not Officer+ / gate fail | Hide tab or “Officers only.” | No | No |
| Roster stale / unknown | “Guild roster loading…”; Approve disabled | No | No |
| Core Commit rejects input | “Could not recognize — try again.” + keep selection | No | No |
| Suggestion already cleared (race) | “Petition no longer pending.” refresh queue | No | No |
| BeefNet send fails | Toast success still OK; optional “sync may be delayed” | Yes (local) | Per policy |
| Announce opt-out | Silent `/g` | Yes | No |
| Announce muted / not in guild | Local warning only | Yes | No |
| Peer forged RANK_COMMIT | Ignored at validate | — | No |
| StaticPopup slot busy | Soft fail open; no Accept | No | No |
| Combat | Insecure `/beef` OK; never Secure* | Same rules | Same rules |
| Double-click Approve | Second click no-ops while disabled | Once | Once (dedup) |

**Ordering rule:** celebrate only after Core accepts. Partial success (Commit yes, `/g` no) still shows private fanfare + honest announce warning.

---

## 9. Copy bank (procedural / sacred split)

| Beat | Prefer | Avoid |
|------|--------|-------|
| Preview | “Recognize Beefina as Cooked Beef” | “Level up!” |
| Committing | “Committing…” | “Anointing the flesh…” on a spinner |
| Success toast | “Recognized” + titles | Multi-line jokes over HUD |
| Reject | “Rejected” / “Petition dismissed” | “Git gud” |
| Gate deny | “Officers only.” | Silent dead button |
| Announce fail | “Rank saved; guild chat unavailable.” | Blaming the player |
| `/g` | Track 32 liturgy templates | Protocol dumps, member echoes |

Use exact canon titles from `Data/Ranks.lua` — never paraphrase.

---

## 10. Implementer checklist

- [ ] Approve/Reject live in evidence footer (zone B); no modal  
- [ ] Nuclear rites in zone C with named confirms  
- [ ] All mutations go `Ladder:Commit` / Core reject — UI has zero grant paths  
- [ ] Gate: hide Officer tab when not Officer+; disable while roster unknown  
- [ ] Disable row actions from click until Core returns  
- [ ] Success → refresh ladder + Recent Actions + edge toast  
- [ ] Announce only after Commit; opt-out skips chat only  
- [ ] Peers never `/g` on apply  
- [ ] Dual-encode pending / recognized / rejected  
- [ ] No center WA pulse, no SFX V1, no GuildFrame side effects  
- [ ] In-game: Officer+ Approve → member sees ladder; non-officer forge fails  

---

## 11. Open questions (do not silently fork)

1. Optional Shift-to-Approve if fat-fingers appear in playtest.  
2. Reject reason enum (optional later) — keep out of V1 happy path.  
3. Roster-backed ladder amendment ([spec](../../superpowers/specs/2026-07-25-roster-backed-ladder-design.md)) would replace Approve→Commit with Blizzard roster rites — **this juice doc assumes approved Commit-authority V1** until product law moves.  
4. Post-V1 SFX / seal art: only after Media packaging rules; default off.

---

## 12. Confirm friction — industry mapping

Officer Commit mixes **high-frequency** Approves (promotion night) with **low-frequency nuclear** rites (demote / Council / Prophet). Confirmation UX research is explicit: overusing modals causes habituation; underusing them causes disasters ([NN/g — Confirmation Dialogs](https://www.nngroup.com/articles/confirmation-dialog/); [NN/g — Modal & Nonmodal Dialogs](https://www.nngroup.com/articles/modal-nonmodal-dialog/); [Microsoft Win32 — Confirmations](https://learn.microsoft.com/en-us/windows/win32/uxguide/mess-confirm); [UX Psychology — destructive action modals](https://uxpsychology.substack.com/p/how-to-design-better-destructive)).

| Industry rule | CoB Commit application |
|---------------|------------------------|
| Confirm irreversible / high-cost actions | StaticPopup for demote / appoint / wipe — named subject + consequence |
| Do **not** confirm routine, recoverable actions | Approve suggestion stays one-click after evidence preview (glossary 70) |
| Specific copy beats “Are you sure?” | “Recognize Beefina as Cooked Beef” / “Demote {Name} to …” |
| Progressive disclosure for details | Evidence zone B = details; modal stays brief |
| Feedforward before action | Selection + preview line = anticipation ([Interaction Frogger](https://doi.org/10.1145/1013115.1013140); [IxDF anticipation](https://www.interaction-design.org/literature/article/the-12-principles-of-animation-for-ux-and-ui-design)) |
| Celebrate after truth | Fanfare only post-`Ladder:Commit` success ([CHI 2024 success-dependent juice](https://dl.acm.org/doi/10.1145/3613904.3642656)) |

Cousin Classic pattern: Gargul-style “confirm before award” for scarce loot, not for every click ([Gargul wiki — announcing loot](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat); loot-council overview [RCLootCouncil Features](https://rclootcouncil.com/wiki/Features-Overview)).

### 12.1 Juice for judgment (not for scoring)

| Beat | Juice goal | Anti-pattern |
|------|------------|--------------|
| Select petition | Make subject + consequence obvious | Fake XP bar filling toward Approve |
| Approve press | Tactile template press; disable double-fire | Center pulse “LEVEL UP” |
| Core success | Edge toast + ladder settle | Toast before Core returns |
| `/g` announce | One liturgy line for flock | Officer toast that implies chat already fired when muted |
| Reject | Soft settle; standing untouched | Red “error” flash that looks like system failure |

Guild-culture reminder: promotions are **social recognition**, not meter ticks ([Acheron — Useful Guild Ranks](https://www.acheron-guild.com/guild-relations-archive/guild-creation-activities-and-leadership-guides/creating-useful-guild-ranks-a-faq/); [Eight Years in Azeroth — Meritocracy](https://eightyearsinazeroth.blogspot.com/2013/06/3-11.html)).

---

## 13. One-line doctrine

**Select to anticipate, Commit in Core to authorize, toast to confirm, guild chat to celebrate — and never let the UI award the beef.**

---

## External sources

Research guidance only — **not** product law. Spec §§6–8, 10–11, 13 + Core APIs win on conflict.

1. [NN/g — Confirmation Dialogs Can Prevent User Errors](https://www.nngroup.com/articles/confirmation-dialog/) — when to confirm; habituation risk.  
2. [NN/g — Modal & Nonmodal Dialogs](https://www.nngroup.com/articles/modal-nonmodal-dialog/) — interrupt only for irreversible cost.  
3. [Microsoft Win32 UX — Confirmations](https://learn.microsoft.com/en-us/windows/win32/uxguide/mess-confirm) — specific copy; progressive disclosure.  
4. [UX Psychology — How to design better destructive action modals](https://uxpsychology.substack.com/p/how-to-design-better-destructive) — affirmative destructive patterns.  
5. [DesignSystems.one — Confirmations & destructive actions](https://www.designsystems.one/design-systems/patterns/confirmations) — consequence preview patterns.  
6. [Wensveen et al. — Interaction Frogger (DIS 2004)](https://doi.org/10.1145/1013115.1013140) — feedforward / feedback coupling.  
7. [IxDF — 12 Principles of Animation for UX/UI](https://www.interaction-design.org/literature/article/the-12-principles-of-animation-for-ux-and-ui-design) — anticipation & follow-through.  
8. [CHI 2024 — How does Juicy Game Feedback Motivate?](https://dl.acm.org/doi/10.1145/3613904.3642656) — success-dependent amplification.  
9. [Jonasson & Purho — Juice It or Lose It](https://www.youtube.com/watch?v=Fy0aCDmgnxg) — juice after action, not instead of clarity.  
10. [Gargul — Announcing Loot in Chat](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat) — officer-gated chat spectacle cousin.  
11. [RCLootCouncil — Features Overview](https://rclootcouncil.com/wiki/Features-Overview) — council judgment UX cousin.  
12. [Acheron — Creating Useful Guild Ranks FAQ](https://www.acheron-guild.com/guild-relations-archive/guild-creation-activities-and-leadership-guides/creating-useful-guild-ranks-a-faq/) — rank privilege culture.  
13. [Eight Years in Azeroth — Meritocracy](https://eightyearsinazeroth.blogspot.com/2013/06/3-11.html) — peer recognition rituals.  
14. [StudyAround — Toast Notification Design Guide](https://studyaround.blog/toast-notification-design-guide) — dwell / single-toast norms.  
15. [Twitch — Celebrate your community with alerts](https://blog.twitch.tv/en/2023/07/25/celebrate-your-community-your-way-with-twitch-s-alerts/) — tiered public celebration (map carefully; chat remains CoB jumbotron).  
)
