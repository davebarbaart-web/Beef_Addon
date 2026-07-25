# Cousin ritual addons — steal / avoid for Ceremony & Gora

**Track:** 71-ceremony-gora-mechanics  
**Focus:** What Classic-family tools already do for **challenge logs, attendance marks, officer decisions, and skip-friendly spectacle** — mapped to thin V1 rites.  
**Not a teardown of loot economies** — that stays in [13](../13-cousin-addon-teardowns/) / [26](../26-ladders-points-gamification/).

---

## Pattern map

| Cousin | Ritual job | Offline / authority behavior | Closest Beef surface |
|--------|------------|------------------------------|----------------------|
| **DuelBook** / duel log demand | Personal W/L vs opponents | Local SV; no guild official | Gora outcome labels + optional rivalry memory |
| **DuelTracker** | Duel outcome logging | Personal | Soft `DUEL_FINISHED` → Record prompt (hint only) |
| **Gargul** | ML decision + note + confirm Award | Session authority online | Officer Close / Record density |
| **RCLootCouncil** | Live council session; Award Later | Pending is raid-night live | Do **not** copy voting parliament for rites |
| **Guild Raid Attendance (GRA)** | Admin attendance sheet + save | Admin edits; send-to-raid optional | Ceremony attendance picker on Close |
| **Group / Guild Calendar** | Schedule + RSVP categories | Sync among guild addon users | Cadence only — **not** credit ([39](../39-guild-calendar-events/)) |
| **Immersion** / **Dialogue UI** | Skip-friendly dialogue pacing | Player-local | Ceremony stub must finish in seconds |
| **Emote Splitter** | Long paste / macro spectacle | Chat-native | Out-of-band liturgy; Beef announces stay short |
| **Listener / Snooper** | Attention in crowded nights | Player-local | Coexist; no Beef chat HUD |
| **Attune** | Survey / readiness | Offline peers blank | Rites are live-session, not survey catch-up |

---

## 1. Duel ledgers — rivalry memory, not score authority

### DuelBook

- **Job:** Register Classic duels; record outcome vs opponents; `/duelbook` history (name, class, win, loss) ([CurseForge — DuelBook](https://www.curseforge.com/wow/addons/duelbook); [GitHub — HotChilly/DuelBook](https://github.com/HotChilly/DuelBook)).
- **Demand signal:** Classic players still ask for duel W/L logs when ports lag ([EU forums — Duel logs addon](https://eu.forums.blizzard.com/en/wow/t/duel-logs-addon/154534)).
- **Related:** [DuelTracker](https://kevinlocke.name/programs/dueltracker) — same “log the fight” instinct.

| Steal | Avoid |
|-------|-------|
| Explicit **challenge → win/loss** vocabulary | Auto-logging as *official* Beef standing |
| Per-opponent rivalry line on My Standing | Elo / ratio hero UI as the ladder |
| Small personal history list | Guild-wide duel leaderboard product (private-server wishlist noise — signal only) |

**Beef read:** Cousins prove players want rivalry memory. Official Gora standing still requires **Officer+ Record** ([gora-challenge-flows.md](gora-challenge-flows.md)). Personal auto-log (if ever soft-dep) must never mint ladder points alone.

---

## 2. Gargul — decision density for Close / Record

- **Job:** Fast ML awards with note field, roll list, and **confirm on Award** ([Gargul CurseForge](https://www.curseforge.com/wow/addons/gargul); [Awarding Items wiki](https://github.com/papa-smurf/Gargul/wiki/Awarding-Items); tear-down [13/gargul](../13-cousin-addon-teardowns/gargul.md)).
- **Philosophy:** Single authority, soft dependency (raiders need not install for core), speed over parliament ([RCL vs Gargul](https://medium.com/@rengo_wow_world_of_warcraft/rclootcouncil-vs-gargul-which-wow-loot-addon-should-you-use-f99ac760e944)).

| Steal | Avoid |
|-------|-------|
| One screen: subjects + action + short note + confirm | GDKP / SoftRes / PackMule gravity |
| Soft dependency — non-installers still participate in the *world* rite | Requiring every attendee to run Beef for ceremony credit |
| Award-confirm friction **scaled to risk** | Nuclear StaticPopup on every 5-minute liturgy Close |

**Beef read:** Ceremony Close and Gora Record should feel like Gargul Award — **human click, named subjects, light confirm** — not like RCL voting frames ([officer-close-patterns.md](officer-close-patterns.md)).

---

## 3. RCLootCouncil — contrast, not template

- **Job:** Live loot council session; optional Award Later bag; Synchronizer for settings/history ([RCLootCouncil](https://rclootcouncil.com/); [Synchronizer wiki](https://github.com/evil-morfar/RCLootCouncil2/wiki/Synchronizer)).
- **Ritual analogy:** Pending votes assume the council is *present* for the moment.

| Steal | Avoid |
|-------|-------|
| “Rites are live-session objects” | Multi-voter council UI for Gora outcomes |
| Award Later mindset for *deferral owned by authority* | Guild-wide ceremony inbox sync in V1 ([67](../67-offline-officer-suggestion-sync/)) |

**Beef read:** If no Officer+ is online, ceremonies/Gora do not close themselves. That is culturally normal for Classic session tools.

---

## 4. Guild Raid Attendance — attendance editor energy

- **Job:** In-game attendance sheet for the person who tracks raids; manual editor; save; optional send-to-raid; optional EPGP module ([CurseForge — Guild Raid Attendance](https://www.curseforge.com/wow/addons/guild-raid-attendance)).
- **Admin flow:** Assign admin → import members → track raid → edit attendance → save.

| Steal | Avoid |
|-------|-------|
| Officer **edits then saves** attendance before credit sticks | Full raid-log / CSV / EPGP stack inside Beef |
| Explicit “OK / Save” as the gate | Auto-credit from “was in raid snapshot” alone |
| Compact sheet for a small attendee set | Season-long attendance % product |

**Beef read:** Ceremony Close’s checklist is a **tiny GRA Attendance Editor** for one rite id — not a raid-season ledger ([thin-v1-ceremony-stubs.md](thin-v1-ceremony-stubs.md)).

---

## 5. Group / Guild Calendar — cadence cousin, credit anti-pattern

- **Job:** Schedule events, attendance categories, invite tools; Classic ports note single-guild sync after channel limits ([Group / Guild Calendar for Classic](https://www.curseforge.com/wow/addons/group-calendar-for-classic)).
- **Beef boundary:** Already locked in [39](../39-guild-calendar-events/) — Discord/calendar own RSVP; Beef owns officer close credit.

| Steal | Avoid |
|-------|-------|
| Weekly rhythm language for guild nights | Calendar Accept → standing |
| Trust settings (who may create events) as a *metaphor* for Officer+ | Bidirectional calendar sync in V1 |

---

## 6. Immersion stack — skip-friendly liturgy

| Addon | Steal for rites | Avoid |
|-------|-----------------|-------|
| [Immersion](https://www.curseforge.com/wow/addons/immersion) | Officer can finish Start→Close without fuss; dual-speed (spectacle vs skip) | Forced talking-head cutscenes for every ceremony |
| [Dialogue UI](https://www.curseforge.com/wow/addons/dialogueui) | Quest-length pacing if V2 ever presents liturgy text | Hard dependency; gossip hook fights |
| [Emote Splitter Classic](https://www.curseforge.com/wow/addons/emote-splitter-classic) | Officers paste long voice/scripture *outside* Beef | Shipping macro theater / multi-line `/g` spam as V1 spectacle |
| [Listener](https://www.curseforge.com/wow/addons/listener) | Crowded Gora night attention is player-side | Always-on Beef chat HUD |

Catalog depth: [07 addon-catalog](../07-immersion-roleplay-flavor/addon-catalog.md).

**Beef read:** Thin stubs win because Immersion’s culture already trained officers: **immersive when you want it, out of the way when you don’t.**

---

## 7. Composite steal / avoid (V1 lock)

### Steal

1. **Gargul Award density** for Close / Record.  
2. **GRA edit-then-save** for ceremony attendance.  
3. **DuelBook outcome labels** + optional per-opponent memory on My Standing.  
4. **Immersion skip-friendly** time budget (~60s UI for a full ceremony).  
5. **RCL/Gargul soft dependency** — world theater works without every client installed.

### Avoid

1. Auto-score from duel APIs / CLEU.  
2. Elo / season duel ladder as hero UI.  
3. Calendar RSVP as attendance.  
4. Loot-council voting for Gora.  
5. EPGP/CSV attendance product scope.  
6. V3 match theater / favor / wager chrome ([24](../24-policy-tos-compliance/), spec §3.2).  
7. Restating HC Mak’gora naming — [60](../60-hardcore-doomhowl-edges/) only.

---

## 8. One-line product synthesis

> **Gargul-sized officer decision + GRA-sized attendance tick + DuelBook-sized outcome vocabulary + Immersion-sized time budget — and none of the loot/calendar/PvP-automation gravity.**
