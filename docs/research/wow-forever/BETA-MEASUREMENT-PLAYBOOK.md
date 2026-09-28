# WoW Forever beta — measurement playbook

Research only. For David. Window: **17 Sep–21 Oct 2026** (PST, official).

This file tells you what to write down in beta. It does not decide a port, invent a store schema, or authorize Forever-targeted addon work.

**Home client stays Anniversary TBC (`## Interface: 20506`).** Do not install Church of Beef into the Forever tree. Do not add a Forever TOC flavor, `AllowLoadGameType` line, `WOW_PROJECT_*` gate, or identity-schema change from anything you read here.

Sibling JSON in this folder (`wow-forever-technical.json`, `search-*.json`) is incomplete scrape. Completeness flags on the technical dump are already `false` for the fields that matter. Treat those files as a link index, not law.

---

## How to use this

One page per open question:

| Page | Question | What you are measuring |
|------|----------|------------------------|
| 1 | [#22](#page-1--22-when--whether-to-port) | Whether Forever is even a Church client, and what Appendix A still holds |
| 2 | [#23](#page-2--23-unitname--two-part-names--guid) | What a "character name" actually is on the wire and in the UI |
| 3 | [#24](#page-3--24-guilds-guild-addon-chat-one-pope-star) | Whether one guild + `GUILD` addon chat can still be the star |
| 4 | [#25](#page-4--25-interface-toc-install-folder-wtfsv) | Which folder, Interface number, and SavedVariables tree you are in |

Do **#25 first** on night one (confirm which client you launched), then **#23**, then **#24** if a guild UI exists. Repeat **#22 / Appendix A** once two clients can sit in the same social container.

Every session, write the **build number** at the top of the note. Beta can change names, Interface, and folders mid-window. A fact from 17 Sep is not a fact on 21 Oct unless you re-dump it.

### Official vs rumor

**Official (Blizzard news / shop / product page):**

- Product: [Carve a New Path…](https://news.blizzard.com/en-us/article/24302093/carve-a-new-path-with-world-of-warcraft-forever) — Forever is a permanent home *alongside* modern and Classic; launch 4 Nov 2026 15:00 PDT; beta begins 17 Sep.
- Dates and packs: [Pre-Purchase…](https://news.blizzard.com/en-us/article/24301508/pre-purchase-world-of-warcraft-forever-upgrades-and-begin-your-next-journey-in-azeroth) — beta **17 Sep–21 Oct 2026 PST**; Epic Pack and Warcraft Forever Collection include beta; Heroic does not; name reservation **27 Oct–3 Nov**.
- Systems: [Deep Dive recap](https://news.blizzard.com/en-us/article/24303313/world-of-warcraft-forever-deep-dive-panel-recap) — realmless; rulesets Normal / PvP / Roleplaying; Hardcore **after launch**; no cross-ruleset grouping; two-part region-unique names (example **"Ana Forever"**); language preference; Legacy Points account-wide except Hardcore's one-way rule.
- Marketing site: [worldofwarcraft.blizzard.com/en-us/forever](https://worldofwarcraft.blizzard.com/en-us/forever).

**Not official (do not treat as law):**

- Folder name `_forever_`, Interface `16000`, TOC suffix `_Forever`, game type `forever`.
- Pre-beta CDN lineage `wowdev2` / `1.60.0.69818` (community trackers; encrypted; not a public addon host). Internal alpha config on those trackers used `_classic_alpha_`, not `_forever_`.
- "Settings hide the secondary name" — widely reported (Wowhead / BlizzCon coverage). The Deep Dive recap confirms two-part names; it does **not** describe a toggle. Confirm in Esc → settings yourself.
- Guilds exist / do not exist; `GUILD` addon chat works; one Pope star still works.
- Midnight "addon disarmament" applying to Forever (that article is Retail Midnight).
- Forum claims that addons will be banned or Retail-restricted.
- Inven / press "beta cap 30" — verify in-game. Do not plan Church content around a rumor cap.
- Anything in `docs/research/wow-forever/*.json`.

### What "unknown" looks like

Write the word **UNKNOWN** plus the symptom. Do not fill gaps.

| Symptom | Write |
|---------|--------|
| Slash dump says `nil` for a function | `UNKNOWN: no such API` |
| Function exists, returns `nil` / `""` / `"Unknown"` | `UNKNOWN: empty or placeholder` |
| Second return missing vs empty string | Write both `type()` and the value (`nil` ≠ `""`) |
| UI control missing (no AddOns button, no Guild pane, no name-display checkbox) | `UNKNOWN: control not present` |
| Send succeeds, nobody receives | `UNKNOWN: silent drop` |
| Works on one ruleset, not another | `UNKNOWN: ruleset-scoped` — name both rulesets |
| Works today, gone after a patch | Re-dump; keep both dates |

### Safety

- Home install stays `/Applications/World of Warcraft/_anniversary_/Interface/AddOns/ChurchOfBeef`. Do not rsync Church of Beef into whatever folder Forever uses.
- Do not open, copy, or overwrite Anniversary `WTF/**/ChurchOfBeefDB.lua`.
- Measurement dumps only (`/dump`, chat, Finder). No Forever implementation in this repo.
- Custom `CHANNEL` addon chat stays forbidden even as a test (Classic-family policy). Use `GUILD` / `WHISPER` / `PARTY` only.
- Two-client tests need a second Battle.net account or a second machine. One client cannot prove the star.
- `#scriptErrors` on. Prefer BugGrabber + BugSack if you already have them on Anniversary; do not assume they load on Forever.

### Shared dump kit

Paste into chat. If a name is red / `nil`, the API is missing — that is a result.

```
/dump GetBuildInfo and {GetBuildInfo()}
/dump WOW_PROJECT_ID, WOW_PROJECT_MAINLINE, WOW_PROJECT_CLASSIC, WOW_PROJECT_BURNING_CRUSADE_CLASSIC
/dump {UnitName("player")}
/dump {UnitFullName("player")}
/dump UnitGUID("player")
/dump GetRealmName(), GetNormalizedRealmName and GetNormalizedRealmName()
/dump IsInGuild(), GetGuildInfo("player")
```

On Anniversary today, `UnitName` / `UnitFullName` return `(unitName, unitServer)`. Forever may return one token, two tokens, a space-separated full name, or something else. Record **every return**, in order, with `type()`.

---

## Page 1 — #22 when / whether to port

**Question (OPEN_QUESTIONS #22):** §3.2 now has an official Classic+ product. Unanswered: whether Church of Beef ports to Forever at all, and whether Anniversary stays the home client through TBC.

**#6 already fired (2026-09-12).** The trigger is "re-validate Appendix A and revisit §3 before further platform-dependent work" — not "start a Forever flavor." Home remains Anniversary until you say otherwise.

### Why this is a measurement page

Bible §3.2 (written when Classic+ was rumor) still binds:

> Portability principle: no system may depend on APIs or game features beyond a conservative Classic-family baseline unless the feature gracefully degrades.

And: on official announcement, **Appendix A is re-validated before further platform-dependent work.** Anniversary TBC will also drift (TBC → Wrath). Forever is a *second* product sitting *alongside* Classic, not a promised replacement for Anniversary.

Beta can tell you whether a port is *possible*. It cannot tell you the Church should *move*. That is a human call after the notes below.

### Official (do not over-read)

- Forever is a separate permanent game next to modern and Classic, not "Anniversary but plus."
- Launch access is the existing WoW sub; beta is a paid-pack window.
- Level cap at launch is presented as 60, horizontal content, no flying (Deep Dive / announce coverage). Flying being absent is **design**, not an API portability proof.
- Hardcore is a Forever *ruleset after launch*, not the Church's home. Bible §3.3 already treats HC as tournament-only on Anniversary.

### Rumor (ignore for the decision)

- "We'll just drop a `_Forever.toc` / Interface 16000." Unpublished.
- "Classic addons will load." Unpublished.
- "Midnight secret values / addon disarmament come to Forever." Different product.
- Pre-beta `wowdev2` / `1.60.0.69818`. Lineage, not a host you can author against.

### How to check

Stay in the Forever client you identified on page 4. For each Appendix A row, run the probe, write **pass / fail / unknown**, and the fallback the Bible already named.

| A | Dependent Church feature | Forever probe (human) | Already-named fallback |
|---|--------------------------|------------------------|------------------------|
| 1 | Fight HUD live bars | Target a **non-party** player; `/dump UnitHealth("target"), UnitHealthMax("target")`. Then a mob. | HUD without live health |
| 2 | Proposed verdicts / Cowardice | Duel another player. Screenshot the exact flee / victory system lines (locale + wording). Note if they appear only in range. | Pure manual verdict |
| 3 | BeefNet trust + star | Two installed clients, same social container. Send a registered-prefix addon message on `GUILD` and `WHISPER`. Record `CHAT_MSG_ADDON` **sender** (server-provided). | No star → no port of theater |
| 4 | Knight display + presence | Open guild roster. `/dump GetNumGuildMembers and GetNumGuildMembers()`. Row 1: `/dump {GetGuildRosterInfo(1)}`. Note whether Promote / Set Rank exist and who can press them. | Store-only Knighting |
| 5 | Candidate / fighter marks | In a party you lead, `/dump SetRaidTarget`. | Target-assist only |
| 6 | Console target assist | Target by clicking; note combat lock on any "target this name" button. | Manual target |
| 7 | Records / Archive | After any probe SavedVariables write, quit cleanly. Confirm a file appeared under the Forever WTF tree (page 4). Size + path. | — |
| 8 | §19.4 cues | `/dump PlaySoundFile`. One stock sound. | Silent Event Mode |
| 9 | Later Expeditions | `/dump IsInGroup(), IsInRaid(), UnitIsGroupLeader("player")` | Later-phase |
| 10 | Profession directory | Profession window; attempt a tradeskill link in chat. | Later-phase |
| 11 | Tithe recognition | Guild bank UI present? Transaction log readable? | Later-phase; TBC-home feature |
| 12 | Expedition complete | One dungeon if beta allows. What chat / encounter event fires on last boss? | Later-phase |
| 13 | Decree / snapshot timing | From cold login: when does `GetGuildInfo("player")` become non-nil? Reload once. | — |

**A3 and A4 are the port gate for ceremony.** If you cannot get a server-provided sender on a guild-wide addon channel, the §13.1 star has nowhere to sit. That is a #24 fact that answers #22.

### What unknown looks like

- API missing (`type(UnitHealth) == "nil"`) — not the same as "returns 0."
- Health returns 100/100 for every non-party player (secret-value / hidden) — write **HIDDEN**, not fail. Bible fallback already exists.
- Duel messages in a different channel or with two-part names embedded — copy the raw line; do not normalize.
- Beta content cap (if any) blocking A12 — mark **N/A this build**, retest if cap lifts.
- Hardcore ruleset absent (official: after launch) — do not infer HC memorials (§12.6) from beta Normal.

### Record (copy this block)

```
#22 / Appendix A  date: ____  build: ____  ruleset: ____  locale: ____
A1 health non-party: pass / fail / hidden / UNKNOWN
A2 duel lines (paste):
A3 GUILD sender (paste) / WHISPER sender (paste) / two-client? Y/N
A4 roster API: present / missing / UNKNOWN   promote: yes / no / UNKNOWN
A5 marks: pass / fail / UNKNOWN
A6 target assist: ____
A7 SV path + bytes: ____
A8 sound: pass / fail / UNKNOWN
A9 group APIs: ____
A10 tradeskill link: ____
A11 guild bank: present / missing / UNKNOWN
A12 dungeon complete signal: ____ / N/A
A13 login→guild-ready seconds: ____   reload behavior: ____

Port this year?  not decided
Anniversary remains home through TBC?  not decided
What would change your mind (one sentence): ____
```

### This page does not decide

Whether the Church *should* live on Forever, run both, or stay Anniversary-only. Beta evidence goes here; the call stays yours. Do not start Forever-targeted code from a green A1–A13.

---

## Page 2 — #23 UnitName / two-part names / GUID

**Question (OPEN_QUESTIONS #23):** Forever uses two-part, region-unique names; a client setting can hide the secondary. `UnitName` / roster / whisper strings are unpublished. Unanswered: how `Store:EnsureCharacterByName` and `COB.Names.Key` should treat Main vs full name vs a later GUID.

**Do not invent a schema.** §12.4 (durable character identity) stays out of scope. This page is a string museum.

### What Church of Beef assumes today (Anniversary)

These are *current home-client facts*, so you can see a mismatch. They are not Forever law.

- Four inputs already disagree: roster (`"Beefina-Whitemane"`), `CHAT_MSG_ADDON` sender (`"Beefina"`), `UnitName("player")` (`"Beefina"`), typed edit box (`"beefina"`).
- `Names.Display` keeps the token **before the first hyphen** and drops the rest (treats `-Realm` as noise).
- `Names.Key` is that display, lowercased.
- `UnitName` / `UnitFullName` on Anniversary return `(name, realm)`. Net and Console use the **first** return only.
- Store ids are integers. Names are lookup keys, not the human.

Official Forever example is a **space**: `"Ana Forever"`. If the client instead emits `"Ana-Forever"`, today's Display would throw away the secondary as if it were a realm. If it emits `("Ana", "Forever")` as two returns, today's code never sees the second half. Record which of those (or neither) is true.

### Official vs rumor

| Claim | Status |
|-------|--------|
| Two-part names, like first + last | **Official** (Deep Dive) |
| Unique per **region** | **Official** (Deep Dive) |
| Example display `"Ana Forever"` (space) | **Official** (Deep Dive) |
| Settings can hide the secondary | **Press / community** — confirm in UI |
| `UnitName` returns Main only / full name / two returns | **Unpublished** |
| Roster / whisper / addon-sender use the same string | **Unpublished** |
| GUID is the durable character id we should key on | **Not law** — do not design a GUID schema |

### How to check

Create a character whose Main and Secondary are *visibly different* (not `Test Test`). Write both parts on paper **before** you look at APIs.

**1. Character-select and world nameplates**

- Name as shown on the login character list.
- Name over your head, on the target frame, on the minimap/tooltip.
- `/who` of yourself and of a friend.
- Chat: `/s`, `/w` (outgoing header), and the incoming whisper header on the other client.

**2. Display toggle (if it exists)**

- Esc → settings. Search "name", "secondary", "last name", "full name."
- Screenshot the checkbox label **verbatim**.
- Dump the kit **twice**: toggle on, toggle off. Same target, same guild roster row.

If there is no checkbox, write `UNKNOWN: no hide-secondary control`.

**3. API kit (you, then a targeted friend)**

```
/dump {UnitName("player")}
/dump {UnitFullName("player")}
/dump UnitNameUnmodified and {UnitNameUnmodified("player")}
/dump UnitGUID("player")
/dump GetPlayerInfoByGUID and {GetPlayerInfoByGUID(UnitGUID("player"))}
/dump GetUnitName and GetUnitName("player", true), GetUnitName("player", false)
```

Repeat with `"target"` after targeting the friend.

**4. Roster vs whisper vs addon sender**

Need a second client (same ruleset). After you have a guild (page 3) or even just a whisper:

```
/dump {GetGuildRosterInfo(n)}     -- n = their row; write ALL returns
```

On the receiving client, a one-shot listener in chat (temporary; do not put this in the addon):

```
/run local f=CreateFrame("Frame") f:RegisterEvent("CHAT_MSG_ADDON") f:SetScript("OnEvent", function(_,e,prefix,text,channel,sender,...) print("ADDON",prefix,channel,sender) end)
```

Then from the other client, after registering a short prefix (16 chars max):

```
/run C_ChatInfo.RegisterAddonMessagePrefix("COBTEST")
/run print(C_ChatInfo.SendAddonMessage("COBTEST","ping","WHISPER","PASTE_THEIR_NAME_HERE"))
```

Try the whisper target as Main only, as `"Main Secondary"`, and as whatever the tooltip shows. Record which form the API accepts (`print` the result code) and which form arrives in `sender`.

If `C_ChatInfo` is missing, try `SendAddonMessage` / `RegisterAddonMessagePrefix` the same way. If both missing, stop — that is a #22 A3 / #24 result.

**5. Ambiguous cases (do these; they are the whole point)**

- Two characters who share a Main and differ only on Secondary (if the client allows it).
- Your own alt: is Secondary reused? (Forum rumor says no. Official recap is silent.)
- A name that contains a hyphen in Main or Secondary (if creation allows).
- Whisper while the other player's hide-secondary setting is opposite yours.

### What unknown looks like

- `UnitName` first return is Main, second is Secondary — **or** second is still a shard/realm, **or** second is `nil`.
- `UnitName` first return is already `"Ana Forever"` and `UnitFullName` is identical.
- GUID looks like today's `Player-<realmId>-<id>` **or** a new shape. Copy the raw string. Do not parse it into a schema.
- `GetPlayerInfoByGUID` missing, or `name` is Main while `realmName` is Secondary (or a leftover realm field that is always `""`).
- Addon `sender` is Main-only while roster is full name — today's `Names.Same` would miss.
- Hide-secondary changes `UnitName` but **not** `CHAT_MSG_ADDON` sender (or the reverse).
- `/dump` errors (`attempt to call nil`) — API absent.

### Record (copy this block)

```
#23  date: ____  build: ____  ruleset: ____
My Main / Secondary (creation screen): ____ / ____
Hide-secondary control: missing / label="____"

                 toggle ON              toggle OFF
character list:  ____                   ____
nameplate:       ____                   ____
UnitName player: (1) ____ (2) ____      (1) ____ (2) ____
UnitFullName:    (1) ____ (2) ____      (1) ____ (2) ____
UnitGUID:        ____                   ____
GetPlayerInfoByGUID name, realmName: ____ , ____

Friend Main / Secondary: ____ / ____
UnitName target: (1) ____ (2) ____
Roster GetGuildRosterInfo name field: ____
Incoming whisper header: ____
CHAT_MSG_ADDON sender (WHISPER): ____
CHAT_MSG_ADDON sender (GUILD): ____
Whisper target strings that worked: ____
Whisper target strings that failed (result code): ____

Hyphen in a name part allowed? Y/N/UNKNOWN
Two chars, same Main, different Secondary? Y/N/UNKNOWN
Alt reuses Secondary? Y/N/UNKNOWN

Schema decision: not this page
```

### This page does not decide

How `EnsureCharacterByName` or `Names.Key` should treat Main vs full name vs GUID. Bring the string museum back; do not "fix" Common.lua from a single dump.

---

## Page 3 — #24 guilds, GUILD addon chat, one-Pope star

**Question (OPEN_QUESTIONS #24):** Forever is realmless with rulesets (Normal / PvP / RP; Hardcore after launch) and no cross-ruleset grouping. Official pages do not say whether guilds, `GUILD` addon chat, or one Pope-writer star still exist across rulesets. Unanswered: can the Church remain one guild on one ruleset, or does the star need a new transport.

**Do not invent a cross-ruleset net.** Custom `CHANNEL` addon chat is still forbidden.

### Why the star cares

BeefNet today: prefix `COB`, channel **`GUILD` always** (STATE / HELLO / DECREE). Catch-up and INPUT are **WHISPER to the Pope's client**. Theatrical UI trusts only a server-provided sender that `Names.Key` matches a registered Pope character. One writer. Congregation clients are displays plus input.

If there is no guild, or `SendAddonMessage(..., "GUILD")` does not fan out to every Church character who should hear it, the star has no bus. That is a product fork, not a codec tweak.

### Official vs rumor

| Claim | Status |
|-------|--------|
| Realmless; pick a **ruleset**, not a realm list | **Official** |
| Rulesets: Normal, PvP, Roleplaying; Hardcore after launch | **Official** |
| No cross-ruleset grouping; factions stay separate | **Official** |
| Same-ruleset group / dungeon / raid | **Official** |
| Language preference (encounter others who share it) | **Official** — may split who you *see*, unpublished for guilds |
| Hardcore is enclosed; dead HC char may transfer out, including to PvP; Legacy/collections account-wide except HC's one-way rule | **Official** — likely **absent in beta** |
| Guilds exist | **Unpublished** |
| A guild spans rulesets | **Unpublished** (grouping does not) |
| `GUILD` / `OFFICER` addon chat exist and fan out | **Unpublished** |
| Whisper works across rulesets | **Unpublished** |
| Communities / clubs replace guilds | **Rumor** until you see the UI |

### How to check

Need **two clients**. Label them Pope and Congregation. Same region.

**1. Social UI inventory (one client is enough to start)**

- Social / Guild / Communities key (Anniversary: `J`). Screenshot the tabs. Write every label.
- Can you **create** a guild? Cost? Same-faction only?
- Invite flow: target, `/ginvite`, context menu.
- `/dump IsInGuild(), GetGuildInfo("player")`.
- After a roster refresh (`GuildRoster` or `C_GuildInfo.GuildRoster` if present): `/dump GetNumGuildMembers and GetNumGuildMembers()`.

No Guild tab and no `/ginvite` → write `UNKNOWN: no guild UI` and stop the guild tests. Still do whispers and party.

**2. Same-ruleset guild (the hopeful Church shape)**

Both characters on **Normal** (or both on PvP — do not mix). Same faction.

- Create / join one guild.
- Congregation sees Pope in roster? Online bit?
- `/g` typed chat both ways.
- Addon:

```
/run C_ChatInfo.RegisterAddonMessagePrefix("COBTEST")
/run print("GUILD send", C_ChatInfo.SendAddonMessage("COBTEST","ping-guild","GUILD"))
```

Congregation must have registered the same prefix **before** the send. Print `CHAT_MSG_ADDON` prefix, channel, sender (page 2 listener).

Then whisper:

```
/run print("WHISPER send", C_ChatInfo.SendAddonMessage("COBTEST","ping-w","WHISPER","NAME_THAT_WORKED_IN_23"))
```

**3. Cross-ruleset (expect failure; still measure)**

- Congregation rolls (or transfers, if offered) onto a **different** ruleset.
- `/ginvite`, `/w`, party invite, addon `GUILD` and `WHISPER`.
- Write the exact error: not in guild, player not found, cannot group, silent drop, other.

**4. Language preference**

- If a language setting exists, set Pope and Congregation **apart**. Repeat `/g`, whisper, and `GUILD` addon.
- Official text is about *encountering* players. That might be world visibility only. Do not assume it splits guilds.

**5. Officer channel**

```
/run print(C_ChatInfo.SendAddonMessage("COBTEST","ping-off","OFFICER"))
```

Congregation as a non-officer: should they receive? Record.

**6. What you must not "prove" with one client**

A successful `SendAddonMessage` return is **enqueue**, not delivery. Classic-family already silent-drops. Two clients or it did not happen.

### What unknown looks like

- Guild UI present but `IsInGuild()` stuck false after create until reload (page 1 A13).
- `SendAddonMessage` result `NotInGuild` (or numeric `10`) while `/g` works.
- `GUILD` send prints success; congregation receives `/g` but not addon (prefix not registered vs channel dead — distinguish by registering first).
- Roster names use a different spelling than addon `sender` (page 2). Star would reject the Pope.
- Cross-ruleset: invite UI lists the person, send fails — or they do not list.
- Language mismatch: you can whisper but not see them in the world, or the reverse.
- Hardcore absent — write `N/A this build`, do not invent a cross-ruleset transport for a ruleset that is not in beta.

### Record (copy this block)

```
#24  date: ____  build: ____
Social tabs visible: ____
Create guild: yes / no / UNKNOWN   notes: ____

SAME ruleset (name: ____)  faction: ____
  both in guild: Y/N
  /g both ways: Y/N
  GUILD addon delivered: Y/N   sender= ____   result= ____
  WHISPER addon delivered: Y/N  sender= ____   result= ____
  OFFICER addon: ____
  roster count / online bit: ____

CROSS ruleset (A: ____  B: ____)
  /ginvite: ____
  /w: ____
  party: ____
  GUILD addon: ____
  WHISPER addon: ____

Language mismatch: ____
Hardcore present?: N / UNKNOWN / yes (unexpected)

Church can remain one guild on one ruleset?: yes / no / UNKNOWN
Star needs a new transport?: not decided — evidence: ____
```

### This page does not decide

A new bus (whisper mesh, communities, clubs, custom channel). If same-ruleset `GUILD` works, the Church *can* stay one guild on one ruleset. That is evidence for "do not invent a net," not a port vote.

---

## Page 4 — #25 Interface, TOC, install folder, WTF/SV tree

**Question (OPEN_QUESTIONS #25):** `## Interface`, TOC suffix, `AllowLoadGameType`, Battle.net product id, install folder, and whether `ChurchOfBeefDB` is a separate WTF tree are unpublished.

**Do not assume `_forever_`, Interface `16000`, or a shared SavedVariables file with Anniversary.**

### Official vs rumor

| Claim | Status |
|-------|--------|
| Beta via Battle.net after Epic / Collection purchase | **Official** |
| Forever is a distinct product next to modern and Classic | **Official** |
| Folder is `_forever_` | **Rumor** — measure |
| Interface is `16000` because some pre-beta builds were `1.60.0.x` | **Derivation, not a measurement** |
| TOC suffix `_Forever` / game type `forever` | **Unpublished** |
| `wowdev2` / `1.60.0.69818` / `_classic_alpha_` | **Community CDN lineage**, encrypted, not a public addon host. Do not author against it. |
| Shared `ChurchOfBeefDB` with Anniversary | **Must not assume.** Default expectation on every other flavor is a **sibling** WTF tree. Prove it. |

### How to check — disk (do this before login)

**1. Battle.net identity**

- Battle.net → Forever (whatever the tile is labeled) → settings → **Show in Finder**.
- Write: tile name, version string on the tile, install path.

**2. Folder name — observe, do not predict**

From `/Applications/World of Warcraft/` (or the Windows equivalent), list **immediate** children. On this machine Anniversary is `_anniversary_`. You may also see `_retail_`, `_classic_`, `_classic_era_`, `_beta_`, `_ptr_`, `_classic_alpha_`, something new, or a name that is not underscore-wrapped.

Write the **actual** directory that contains the Forever `WowClassic.exe` / `World of Warcraft Classic.app` / whatever binary Battle.net launched. If you cannot tell, compare modification time to "I just pressed Play."

**3. Product crumbs in that folder**

Do not upload these. Just read:

- `.flavor.info`, `.product.db`, `.build.info`, `.build.info.bak` (names vary).
- Any `product` / `flavor` / `version` line. That is the Battle.net product id.
- `WTF/Config.wtf` **after first launch** — `lastAddonVersion` if present.

**4. AddOns and WTF trees**

```
<that folder>/Interface/AddOns
<that folder>/WTF/Account
```

Compare to Anniversary:

```
/Applications/World of Warcraft/_anniversary_/Interface/AddOns
/Applications/World of Warcraft/_anniversary_/WTF/Account/<ACCOUNT>/SavedVariables/ChurchOfBeefDB.lua
```

Are they **different directories**? (They should be.) Write both full paths. If you ever see `ChurchOfBeefDB.lua` under the Forever tree **without** having copied the addon there, stop and write that down — that would mean a shared or mis-pointed WTF.

**Do not copy Church of Beef to prove this.** A shared tree plus a copy would smash the live store.

### How to check — in-game

**1. Build / Interface**

```
/dump GetBuildInfo and {GetBuildInfo()}
```

Write every return, labeled by index. On Classic-family, index 4 is the Interface number authors put in `## Interface:`. If `GetBuildInfo` is missing, use `Config.wtf` `lastAddonVersion` after one session, or the AddOns list "out of date" behavior below.

```
/dump WOW_PROJECT_ID
```

If it exists, write the **number** and any `WOW_PROJECT_*` globals that are non-nil. That is a measurement. It is not permission to write a gate.

**2. AddOns list**

Character select → AddOns (if the button exists).

- Button missing: `UNKNOWN: no AddOns UI` (or addons disabled for this beta — still a result).
- Button present, list empty: client hosts addons, nothing installed. Good.
- Drop a **disposable** folder you created yourself (not this repo): e.g. `ForeverProbe/ForeverProbe.toc` with only `## Interface: 20506` and `## Title: Forever Probe`. Launch.
  - Out of date? Write the Interface the client wants, if shown.
  - Loads with 20506? Write that — still do not add 20506 to a Forever flavor in Church of Beef.
  - Does it look for `ForeverProbe_*.toc`? Put a second dummy suffix file only if you are hunting suffixes. Do not invent a suffix we then ship.

**3. TOC directives (only if a probe loaded)**

You are looking for whether *this client* documents or honors:

- comma-separated `## Interface:`
- `## AllowLoadGameType:`
- a filename suffix (`_TBC`, `_Vanilla`, `_Classic`, something new)

Wiki tables of suffixes are **contributor-maintained** and do not include Forever as of this writing. In-game behavior wins.

**4. SavedVariables isolation**

If you used a probe with `## SavedVariables: ForeverProbeDB`:

- Quit the Forever client cleanly.
- Confirm `ForeverProbeDB.lua` under **Forever** `WTF/Account/.../SavedVariables/`.
- Confirm Anniversary `ChurchOfBeefDB.lua` timestamp **did not change**.

### What unknown looks like

- Battle.net tile exists; Play does nothing until a day later — client not posted; wait. Not a folder name.
- Multiple new folders appear (`_classic_alpha_` **and** something else). Write both; mark which one `Show in Finder` opened.
- `GetBuildInfo()` return 4 is `16000`, `11500`, `20506`, or a fifth shape. Write the number. Do not "correct" it toward 16000.
- `WOW_PROJECT_ID` is `nil` (API never existed here) vs a new integer nobody has listed.
- Probe with `## Interface: 20506` loads **and** is marked out of date — client compares something other than that field.
- No `Interface/AddOns` until first login — create it yourself only for a probe; do not create it as a Church install.
- WTF account folder uses a different account-name spelling than Anniversary.

### Record (copy this block)

```
#25  date: ____
Battle.net tile label: ____
Show-in-Finder path: ____
Binary name: ____
Sibling folders under World of Warcraft/: ____
Product / flavor file lines: ____

GetBuildInfo returns: [1] ____ [2] ____ [3] ____ [4] ____ [5+] ____
WOW_PROJECT_ID: ____  other WOW_PROJECT_* : ____
Config.wtf lastAddonVersion: ____

AddOns button: present / missing
Probe TOC Interface used: ____
  result: load / out-of-date / rejected / UNKNOWN
Suffix files tried: ____ → ____
AllowLoadGameType tried: ____ → ____

Forever AddOns path: ____
Forever WTF Account path: ____
Anniversary ChurchOfBeefDB path (unchanged?): Y/N  mtime: ____
Probe SV path (if any): ____

Assumed _forever_?  NO — measured: ____
Assumed Interface 16000?  NO — measured: ____
Shared SV with Anniversary?  NO unless proven: ____
```

### This page does not decide

A Forever TOC, packager flavor, CurseForge game-version tag, or installer path. Those wait on your #22 call **and** a measured Interface + folder.

---

## Cadence

| When | Do |
|------|----|
| First successful login | #25 (paths + `GetBuildInfo`), then #23 on your character |
| Same day you can two-box | #24 same-ruleset `GUILD` + whisper |
| First week | Appendix A 1–4, 7, 13 (#22) |
| If a hide-secondary setting exists | Re-run the #23 matrix both ways |
| After any client patch | Re-dump #25 build/Interface and one #23 `UnitName` |
| Last week of beta (on/before 21 Oct) | Full re-run of all four record blocks on the **shipping-shaped** build |
| Hardcore (officially post-launch) | Out of this window unless they surprise-enable it — then a new #24 pass only |

Name reservation (27 Oct–3 Nov) is **after** beta closes. Do not treat reservation-tool names as beta API evidence.

---

## Out of scope (do not do from this file)

- Forever-targeted Church of Beef code, TOC flavors, comma-Interface, `WOW_PROJECT_*` branches, or installer paths
- A GUID- or Main/Secondary store schema (§12.4 stays closed)
- A cross-ruleset BeefNet
- Installing Church of Beef on Forever "just to see"
- Touching Anniversary `WTF/**/ChurchOfBeefDB.lua`
- Treating `docs/research/wow-forever/*.json` or Interface `16000` / `_forever_` as answers
- Claiming V1/MVP complete or a port decision

When the four record blocks are filled, bring them back. The open questions stay open until you close them.
