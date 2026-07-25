# Beef Gora challenge flows (theatrical, not PvP automation)

**Track:** 71-ceremony-gora-mechanics  
**Client focus:** TBC Classic Anniversary  
**Product baseline:** Spec §2 (no automation), §7.1 (Gora + losses pay), §10 (record-result stub), §3.2 (match theater deferred)

**Naming:** Product chrome says **Beef Gora** / “challenge record.” HC Mak’gora lexicography and “do not auto-score Duel to the Death” live in [60](../60-hardcore-doomhowl-edges/beef-scoring-ceremony-hc-rules.md) — this note does not restate that caution.

---

## 1. Design north star

Beef Gora is a **recorded sporting ritual** that feeds standing. The duel (if any) happens in the world as player theater; the addon’s job is to **capture consent + outcome for the ladder**, not to run the fight.

| Theatrical (ship) | PvP automation (reject) |
|-------------------|-------------------------|
| Human issues a challenge record (A vs B) | Addon calls `StartDuel` / `AcceptDuel` without a click |
| Humans fight (or roleplay forfeit) in-world | Addon targets, faces, or macros combat for them |
| Human records win / loss / draw | `DUEL_FINISHED` or CLEU auto-grants standing |
| Losses grant participation | Win-only scoring that makes people dodge |
| Optional soft hint: “a duel just ended — record?” | Silent score from combat log |
| Toast: “Beef Gora recorded. Standing +n” | Favor/odds/pot/betting UI ([24](../24-policy-tos-compliance/)) |

---

## 2. State machine

```
                    Challenge issued
   Idle ─────────────────────────────► Challenged
    ▲                                      │
    │                                      │ Record outcome
    │                                      │  (win / loss / draw)
    │                                      ▼
    └──────────── Recorded ────────────────┘
                      │
                      └─► standing grants (both sides per rules)
```

| Transition | Actor | Payload |
|------------|-------|---------|
| Idle → Challenged | Challenger (any member with addon) **or** Officer+ on behalf of two players | `challenger`, `opponent`, `issuedAt`, optional note |
| Challenged → Recorded | Prefer **Officer+** as official recorder in V1; allow either participant to propose + officer confirm if product wants less friction | `outcome` ∈ {challenger_win, opponent_win, draw}, `recordedBy` |
| Challenged → Idle (void) | Officer+ cancel / expire | No standing |

**V1 recommendation:** Officer+ (or a designated “Score Desk” facilitator — [51](../51-guild-night-playbook/facilitator-roles.md)) is the **record** authority. Participants can *request* a result; officers *commit* it. That mirrors suggestion → approve and keeps self-reported duel spam funny instead of ladder-true (spec §6.3).

---

## 3. Client duel APIs — use as cues only

Documented Classic-family surfaces:

| API / event | What it does | Beef use |
|-------------|--------------|----------|
| `StartDuel(unit\|name)` | Challenges a player to a duel ([Wowpedia StartDuel](https://wowpedia.fandom.com/wiki/API_StartDuel)) | **Never** call from Beef without an explicit user-owned Blizzard duel action elsewhere; do not wrap into `/beef gora` auto-start |
| `AcceptDuel()` / `CancelDuel()` | Accept or reject ([AcceptDuel](https://warcraft.wiki.gg/wiki/API_AcceptDuel)) | Do not auto-accept challenges for the player |
| `DUEL_FINISHED` | Fires when a duel ends ([DUEL_FINISHED](https://warcraft.wiki.gg/wiki/DUEL_FINISHED)) | Optional: open/focus the Record stub with last opponent prefilled; **never** alone write standing |
| `DUEL_REQUESTED` | Incoming challenge (when present on build) | Optional toast “record a Beef Gora?” — not Accept |

Anniversary verify once (`/dump` / FrameXML): event payload richness and whether winner name is available. If winner is ambiguous, **require human radio buttons** for win/loss/draw.

### Hard bans

1. Auto-`AcceptDuel` / auto-`StartDuel` from BeefNet messages.  
2. CLEU / UNIT_DIED → Gora outcome ([63](../63-combatlog-social-signals/) already steers social scoring off CLEU).  
3. Queue of automatic rematches.  
4. Any path that grants points without a human Record click.

---

## 4. Happy paths (Anniversary guild night)

### Path A — Pure stub (recommended default)

1. Officer (or member) opens **Record Gora** stub.  
2. Picks two guild members (or self + target).  
3. Optionally they duel in the world using Blizzard UI.  
4. Officer selects Win / Loss / Draw (relative to challenger or named sides).  
5. Confirm → grants → toasts → My Standing events.

No dependency on duel events. Works if they “played” rock-paper-scissors in voice.

### Path B — Soft assist from duel end

1. Players duel normally (Blizzard).  
2. On `DUEL_FINISHED`, Beef shows a **non-modal** prompt to the Officer+ on duty (or participants): “Record Beef Gora?”  
3. Prefills names if known; officer still chooses outcome.  
4. Same confirm → grants.

If no officer online: prompt can stash a **local draft** on participants’ SV; no official standing until an officer records (aligns with hybrid anti-cheat).

### Path C — Challenge card without a duel

1. Member issues challenge in stub (“I challenge X”).  
2. Status: Challenged (visible to both + officers).  
3. Outcome recorded later (including draw / forfeit).  
4. Useful for spectacle when arena/duel space is crowded.

---

## 5. Outcome → standing (mechanics contract)

Numbers live in canon / [26](../26-ladders-points-gamification/); flow rules:

| Outcome | Standing intent |
|---------|-----------------|
| Win | Highest of the three |
| Draw | Mid |
| Loss | **Must be > 0** (participation) |

Both named participants receive a grant appropriate to their side. Spectators do **not** auto-earn in V1 (deferred favor-meter — §3.2).

Anti-farm (from [26](../26-ladders-points-gamification/anti-farm-incentives.md), enforced at record time):

- Daily Gora-source cap.  
- Same-opponent diminishing returns / daily cap.  
- Reject record if either party dead/ghost locally when self-reporting (officer override via manual adjust only).

---

## 6. What V1 UI shows

| Control | Notes |
|---------|-------|
| Challenger / Opponent pickers | Guild roster filter; Anniversary same-realm names |
| Outcome radios | Win / Loss / Draw — plain labels |
| Record button | Officer+; light confirm (“Record Gora: A beat B?”) |
| Recent Gora list | Last N for My Standing / officer sanity — not Elo ladder |
| Optional rivalry line | “vs Beefina: 2–1–0” — steal DuelBook memory shape ([DuelBook](https://www.curseforge.com/wow/addons/duelbook)) |

**Not V1:** brackets, favor meter, entrance music, countdown overlays, wager pots, stream “place your bets” copy ([24 guild-point gray areas](../24-policy-tos-compliance/guild-point-systems-gray-areas.md)).

---

## 7. Edge cases

| Situation | Behavior |
|-----------|----------|
| Same player twice | Reject |
| Non-guild opponent | Reject for official Gora (keep church-scoped) |
| Duplicate record same pair within DR window | Cap / soft-reject with copy |
| Participant disagrees with outcome | Officer judgment; optional void + re-record; no PvP rematch automation |
| Draw when one player DCs mid-duel | Human chooses draw or void — never infer from disconnect alone |
| Want Elo / season ladder | Defer; personal W/L memory is enough |

---

## 8. Policy one-liners (point elsewhere)

- **No wagering product** — [24](../24-policy-tos-compliance/).  
- **No combat HUD** — [08](../08-combat-hud-alerts/), [01](../01-ux-patterns/).  
- **HC death-duel non-scoring** — [60](../60-hardcore-doomhowl-edges/) only.

---

## Related in this track

| Note | Role |
|------|------|
| [officer-close-patterns.md](officer-close-patterns.md) | Officer+ Record authority; light confirm |
| [cousin-ritual-addons.md](cousin-ritual-addons.md) | DuelBook / Gargul steal-avoid |
| [annotated-urls.md](annotated-urls.md) | Duel API + cousin URLs |
