# Broader market map (adjacent categories)

**Purpose:** Map who owns which job in the guild-social / loot-ops / attendance / RP-identity neighborhood so Church of Beef can position without colliding.  
**Not a tear-down:** For Attune / Gargul / TRP3–MRP screen-level UX, use [track 13](../13-cousin-addon-teardowns/).

---

## 1. Category overview

```text
                    ┌─────────────────────────────────────┐
                    │     Out-of-game guild platforms     │
                    │  GoW · softres.it · wowaudit · WCL  │
                    └─────────────────┬───────────────────┘
                                      │ RSVP / audit / SR export
        ┌─────────────────────────────┼─────────────────────────────┐
        ▼                             ▼                             ▼
 ┌──────────────┐            ┌────────────────┐            ┌────────────────┐
 │ Loot economy │            │ Roster / ops   │            │ Social identity│
 │ CLM · RCLC   │            │ GRM · GoW addon│            │ TRP3 · MRP     │
 │ WebDKP · CEPGP│           │ calendar / GEM │            │ (track 13)     │
 │ Gargul (13)  │            └────────────────┘            └────────────────┘
 └──────┬───────┘                     │
        │                             ▼
        │                    ┌────────────────┐
        │                    │ Fun / shoutouts│
        │                    │ Achieves, greet│
        │                    └────────┬───────┘
        │                             │
        └──────────────┬──────────────┘
                       ▼
              ★ WHITE SPACE ★
         Theatrical guild institution
         (rank ladder · ceremony · stream)
              Church of Beef V1
```

---

## 2. Loot economy & points ledgers

Job: award scarce raid loot fairly; keep a public score (DKP / EP / GP / SK / gold).

| Product | Role | Classic relevance | Beef overlap |
|---------|------|-------------------|--------------|
| **[Core Loot Manager](https://www.curseforge.com/wow/addons/classic-loot-manager)** (formerly Classic Loot Manager) | Current default multi-mode DKP / EPGP / SK toolkit for guilds & PUGs ([Guild Order loot guide](https://guildorder.com/games/wow/guides/loot-systems-dkp-vs-epgp); [Wago](https://addons.wago.io/addons/classiclootmanager); [GitHub org](https://github.com/CoreLootManager)) | Active; separate [TBC Anniversary project](https://www.curseforge.com/wow/addons/classic-loot-manager-tbc-anniversary); ~2.2M CF downloads on main listing | **Compete only if Beef looks like “points for gear.”** Steal: officer-trust sync, history log clarity — not loot bidding UX |
| **[RCLootCouncil Classic](https://www.curseforge.com/wow/addons/rclootcouncil-classic)** | Voting council UI; Classic port of retail RCLC ([site](https://rclootcouncil.com/); [wiki](https://github.com/evil-morfar/RCLootCouncil2/wiki)) | Flavors include Classic TBC; ~9.1M downloads; updated Jul 2026 | Officer vote queue ≈ Beef promote/reject *shape*; denser, loot-bound — avoid council-vote chrome for V1 |
| **RCLC + EPGP modules** | Bolt EP/GP standings onto council ([EPGP Classic RCLC extension](https://www.curseforge.com/wow/addons/epgp-classic-rclootcouncil-extension) linked from RCLC Classic) | Classic-family forks | Confirms “score + human decision” is a known loot pattern, not a social-brand pattern |
| **[CEPGP](https://www.curseforge.com/wow/addons/cepgp)** | EPGP standings in officer notes + ML loot moderation | Classic flavors; large historical install base; slower update cadence | Officer-note storage is a *different* persistence model than BeefNet SV |
| **[WebDKP](https://webdkp.com/addon)** | In-game DKP table + attendance + bidding; sync upload to [webdkp.com](https://webdkp.com/) | Classic compatibility called out in 4.0 notes | Closest “points + attendance” cousin in *function*; opposite brand (admin fairness vs cult theater); external sync vs Beef in-game-only |
| **[MonolithDKP](https://www.wowinterface.com/downloads/info25094-MonolithDKP.html)** | Full DKP + loot history for every guild member | Legacy Classic staple; Guild Order notes migration toward CLM | Historical competitor; don’t target its users as “switch from DKP” |
| **[Gargul](https://www.curseforge.com/wow/addons/gargul)** | SoftRes / GDKP / TMB / +1 / boosted rolls ML tool | See **track 13** for UX | Adjacent loot ops only |
| **[LootMaster Classic](https://www.curseforge.com/wow/addons/lootmaster-classic)** | ML distribution GUI lineage from EPGP Lootmaster era | Classic listing | Narrow ML utility; low Beef relevance |

**Market read:** Points systems in Classic mean *loot currency*. Any Beef copy that says “DKP-like” will be misfiled next to CLM.

---

## 3. Soft-reserve, wishlist, GDKP (web ↔ addon)

Job: pre-raid claim lists and gold-split auctions — often *outside* the addon.

| Product | Role | Beef note |
|---------|------|-----------|
| **[softres.it](https://softres.it/)** | Dominant Classic soft-reserve website (multi-edition including TBC Classic; Discord-auth option; large volume claimed on site) | Web ritual before raid — not a guild-culture ladder |
| **SoftRes addon** ([CurseForge](https://www.curseforge.com/wow/addons/softres)) | In-game soft-reserve display (older Classic/TBC builds) | Mostly superseded by Gargul import workflows |
| **Gargul SoftRes/GDKP/TMB** | Import from softres.it; GDKP multi-auction; wishlists ([GitHub](https://github.com/papa-smurf/Gargul)) | Track 13 — loot spectacle ≠ Beef Gora |

---

## 4. Attendance, calendar, Discord bridges

Job: who signed up, who showed, reminders across Discord ↔ game.

| Product | Role | Beef note |
|---------|------|-----------|
| **[Guilds of WoW](https://guildsofwow.com/)** | Recruitment + team management + event planning; Discord bot attendance; in-game addon with bidirectional RSVP; audits/spreadsheets ([install apps](https://guildsofwow.com/install-applications); [top.gg bot](https://top.gg/bot/760511701236973610)) | Owns *ops attendance*. Beef ceremony attendance is thin, brand-facing, Officer-marked — do not rebuild GoW |
| **GuildEventManager (GEM)** | In-game guild calendar / sign-ups (legacy Classic staple; see [WoWInterface GEM](https://www.wowinterface.com/downloads/info11200-GuildEventManager2.3WotLK.html) lineage via track 09 research) | Ritual cadence pattern; not a living competitor for Anniversary unless guild already runs it |
| **WebDKP attendance** | Raid attendance as first-class DKP feature ([addon page](https://webdkp.com/addon)) | Attendance as *loot eligibility* vs Beef *devotion mark* |
| **Throney / similar Discord guild bots** ([Throney WoW guild tools](https://throney.gg/tools/wow/guild-management)) | Out-of-game roster/event bots | Adjacent Discord layer; Beef stays in-game for V1 |

**Market read:** “Attendance tracker” is not an empty niche for a full product — it is a checkbox inside raid-ops stacks. Beef should treat ceremony attendance as a *score source*, not a calendar product.

---

## 5. Roster ops & guild administration

Job: alts/mains, join history, bans, mass rank macros, inactivity.

| Product | Role | Beef note |
|---------|------|-----------|
| **[Guild Roster Manager](https://www.curseforge.com/wow/addons/guild-roster-manager)** ([site](http://guildrostermanager.com/); [Wago](https://addons.wago.io/addons/guild-roster-manager)) | Officer logging, alt groups, bans, sync, mass macros; Classic & Hardcore support | Complementary — Beef ranks are *addon titles*, GRM manages *WoW guild ranks*. Coexist; don’t absorb |
| **Guild Manager / recruitment automation** | Rule-based invite/kick/promote (see track 09 cites) | Ops automation ≠ theatrical promotion |

---

## 6. Guild fun, recognition, greetings

Job: humor, belonging signals, low-stakes social glue.

| Product | Role | Beef note |
|---------|------|-----------|
| **[Guild Achieve Congratulator](https://www.curseforge.com/wow/addons/guild-achieves)** | Auto sarcastic/funny guild-chat congrats on achievements | Tiny category signal: fun exists, but no persistent ladder or officer ritual |
| **GuildGreet-class tools** | Remind greet / level-up (legacy lineage; track 09) | Greeting ritual ≠ standing |
| **Guild Bank Ledger** | Shared bank transaction history as reputation surface | Ledger transparency pattern; loot/bank domain |

**Market read:** Fun addons are fragmented and rarely branded as institutions. Beef can own “the guild’s religion/sports show” without fighting CLM for installs.

---

## 7. RP directory & immersion (adjacent only)

Job: character sheet, titles, MSP peer exchange, dialogue immersion.

| Product | Role | Beef note |
|---------|------|-----------|
| **Total RP 3 / MyRolePlay / MSP peers** | Character directory & titles | **Track 13** for UX. Beef titles are guild standing, not RP biography |
| **TRP3 Extended, Listener, Immersion, DialogueUI** | Story/emote/dialogue flavor ([track 07](../07-immersion-roleplay-flavor/)) | Tone/atmosphere borrow later; not V1 competitors |
| **Cross RP** | Cross-realm RP bridging (retail-heavy) | Out of V1 Anniversary scope |

---

## 8. Progress / attunement social cousins

| Product | Role | Beef note |
|---------|------|-----------|
| **Attune** | Shared progress trees, guild survey, raid planner | **Track 13.** Closest “guild installs addon to share status” cousin — progress, not cult ladder |

---

## 9. Out-of-game performance & audit platforms

Job: parse logs, gear audits, recruitment signals — not social theater.

| Product | Role | Beef note |
|---------|------|-----------|
| **[wowaudit](https://www.wowaudit.com/)** | Guild/team audit, often paired with loot-council context in officer guides | Performance audit ≠ standing |
| **[Raider.IO](https://raider.io/)** | Character/guild search; Classic Era / MoP tabs | Recruitment prestige metric |
| **[Warcraft Logs Classic](https://classic.warcraftlogs.com/recruitment)** | Logs + recruitment | Combat excellence culture — opposite of Beef’s non-combat mandate |
| **[Guild Order](https://guildorder.com/games/wow/guides/loot-systems-dkp-vs-epgp)** | Meta-guide comparing DKP/EPGP/LC/Wishlist tooling reality | Useful market framing source, not a guild tool |

---

## 10. Positioning matrix (job × product type)

| Job-to-be-done | Dominant owners | Beef V1 stance |
|----------------|-----------------|----------------|
| Fair raid loot | CLM, RCLC, Gargul, CEPGP, WebDKP | **Non-goal** — coexist |
| SoftRes / GDKP prep | softres.it + Gargul | **Non-goal** |
| RSVP / raid attendance ops | Guilds of WoW, GEM, WebDKP | **Thin ceremony mark only** |
| Roster hygiene | GRM | **Complement** |
| Character RP identity | TRP3 / MRP | **Complement** (different title namespace) |
| Shared progress surveys | Attune | **Steal sync habits, not trees** (track 13) |
| Funny chat reactions | Guild Achieves etc. | **Steal announce tone later** |
| Theatrical guild rank institution + stream moments | *Almost empty* | **Own** |

---

## 11. Competitive intensity summary

| Zone | Intensity | Implication |
|------|-----------|-------------|
| Loot points & ML | Very high | Listing/copy must never say “DKP/EPGP alternative” |
| SoftRes/GDKP web | High | Irrelevant to V1 feature set |
| Discord/calendar ops | High | Don’t ship a second GoW |
| Roster admin | High (GRM) | Integrate mentally, not feature-wise |
| RP directory | High (TRP3) | Titles must be clearly *guild ladder* |
| Branded social ladder + ceremony + stream | **Low** | Primary white space |
