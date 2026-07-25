# False positives, AFK, offline, cross-realm

**Track:** 59 · **Last updated:** 2026-07-25  
**Pairs with:** [detection-methods.md](detection-methods.md), track [15](../15-instance-completion-events/) (instance/combat inputs).

---

## 1. False positives (would grant credit wrongly)

| Scenario | Why it looks like co-play | Mitigation |
|----------|---------------------------|------------|
| Grouped with guildmate in city / open world | Valid group + guild | Track 15: require `instanceType ∈ {party,raid,pvp}` ([spec §7.2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) |
| Standing at portal / entrance with guildmate | Same instance + group | Combat sticky per bucket (track 15 / §7.2) — **not** `UnitIsAFK` alone |
| Solo in instance but still in a home raid parked outside | Dual HOME/INSTANCE groups; wrong category query | Explicit category for content type ([IsInGroup](https://warcraft.wiki.gg/wiki/API_IsInGroup)) |
| BG filled with strangers; home guild friend online elsewhere | `GetNumGroupMembers()` huge on INSTANCE | Require guildmate **in the active category group**, not “any friend online” |
| Offline guildie still listed on raid roster | Slot exists | Require `online` / `UnitIsConnected` ([GetRaidRosterInfo](https://wowwiki-archive.fandom.com/wiki/API_GetRaidRosterInfo)) |
| Pet / partypet tokens | Can look like units | Only iterate player `partyN`/`raidN`; never pets ([UnitId](https://wowwiki-archive.fandom.com/wiki/UnitId)) |
| Counting `"player"` as the guildmate | `UnitIsInMyGuild("player")` is true | Exclude self via `UnitIsUnit` |
| Same guild name on another realm (theoretical) | String guild-name compare | Prefer `UnitIsInMyGuild` / roster GUID-or-name set — not free-text guild title equality |
| Login /reload inside instance with guildmate AFK at door | PEW starts session | Track 15: no bucket pay without combat; no completion on PEW |
| Name collision without realm normalize | Two `Beefina` keys | Track [25](../25-multi-toon-realm-edges/) canonical keys |

**Officer backstop:** Implausible suggestions (all instance points, empty combat log) → reject / adjust (§6.3; track [26](../26-ladders-points-gamification/anti-farm-incentives.md)).

---

## 2. False negatives (would deny honest co-play)

| Scenario | Cause | Mitigation |
|----------|-------|------------|
| Guildmate out of portrait range; only used `GetGuildInfo` | Proximity-limited API ([GetGuildInfo](https://warcraft.wiki.gg/wiki/API_GetGuildInfo)) | Prefer `UnitIsInMyGuild` + roster match |
| Queried HOME while in BG INSTANCE raid | Default category mismatch | Category matrix in detection-methods |
| Roster not loaded yet | Login race (track 16) | Treat guildmate unknown → **no pay** until roster ready; then catch up on next bucket |
| Realm suffix mismatch on roster vs `UnitName` | `Name-Realm` vs bare / spaced forms | One `NormalizePlayerKey` (track 25) |
| `IsInGroup()` false while grouped | Rare community report ([WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=56146)) | Also check `GetNumGroupMembers(cat) > 0` |
| Guildmate without addon | Mistaken product assumption | Spec: peer addon not required — do not wait for BeefNet |

---

## 3. AFK and “idle in instance”

### Spec authority

§7.2: bucket pays only if **the scoring player** entered combat during the bucket. Standing at entrance with a guildmate earns nothing.

### What `UnitIsAFK` can (and cannot) do

[`UnitIsAFK(unit)`](https://wowwiki-archive.fandom.com/wiki/API_UnitIsAFK): returns whether the unit has the AFK flag (friendly units).

| Use | Verdict |
|-----|---------|
| Optional UI chip (“guildmate AFK”) | Fine |
| Hard requirement that guildmate is not AFK | **Weak** — flag is voluntary; AFK farming clears it with a step |
| Hard requirement that player is not AFK | Still weaker than combat; combat already covers the abuse |

**Infer:** Do **not** make `UnitIsAFK` a V1 pay gate. Combat + caps carry anti-AFK. Optional: skip counting a guildmate who is AFK **and** not affecting combat — nice-to-have only.

### Connected vs AFK vs dead

| State | API | Count as co-play partner? |
|-------|-----|---------------------------|
| Online, not AFK | `UnitIsConnected`, not `UnitIsAFK` | Yes |
| Online, AFK flag | `UnitIsAFK` | Yes for V1 (player combat still required) |
| Offline / DC | `online` nil / not connected | **No** |
| Dead | `UnitIsDead` / roster `isDead` | **Yes** — still running content |
| Ghost running back | connected | Yes |

---

## 4. Cross-realm edges

### Product law (Church of Beef)

- Dreamscythe Alliance and Doomhowl Horde are **independent churches** — no shared ladder / BeefNet (track [25](../25-multi-toon-realm-edges/); spec §15–16).
- Anniversary / Era PvE grouping is overwhelmingly **same-realm guild** play. Cross-realm guilds are a Retail/TWW story, not V1 Classic church topology ([Wowhead cross-realm guilds](https://www.wowhead.com/news/cross-realm-guilds-coming-in-the-war-within-expansion-unrestricted-cross-realm-335897) — Retail context only).

### Where cross-realm still appears: battlegrounds

[GetRaidRosterInfo](https://wowwiki-archive.fandom.com/wiki/API_GetRaidRosterInfo): in cross-realm BGs, names return `"Name-Server"` for other-realm players.

| Case | Credit? |
|------|---------|
| Same-guild, same-realm friend in your BG raid | **Yes** if `UnitIsInMyGuild` / roster match |
| Other-realm pug in INSTANCE raid | **No** — not guild |
| Guildmate on your realm in HOME party while you are in BG alone | **No** — not in the active INSTANCE group |
| Future connected-realm weirdness | Normalize realm; still require guild membership |

**Infer:** Never treat “faction mate in BG” as guildmate. Guild predicate is mandatory for `pvp` the same as for `party`/`raid`.

### Classic community stance (context only)

Players historically resist Classic cross-realm PvE for server identity reasons ([Blizzard MoP Classic thread](https://us.forums.blizzard.com/en/wow/t/cross-realm-partiesgroupingraiding/974655)). Beef should not invent cross-realm church credit even if a future Classic patch softens grouping — ladder scope stays guild-local until product revises track 25.

---

## 5. Abuse patterns specific to guildmate detection

| Abuse | Why it works without guards | Guard |
|-------|----------------------------|-------|
| Two guildies sit in RFC forever | Instance + group true | Combat buckets + daily caps + same-map DR (track 26) |
| Multibox “guildmate” alt in group AFK | Second client is real guild member | Combat on **scoring** character; officer laughter; caps |
| Invite guildie, leave them outside instance | May still be in HOME group | Qualifying instance check on **player**; optional: guildmate also `IsInInstance` / same instance ID (**Prototype** — stronger, not required if combat+caps suffice) |
| Edit SavedVariables | Always possible | Officer approval (§6.3) |

**Prototype recommendation:** If playtests show “invite guildie to party, park them in Stormwind, farm instance alone” works because HOME group still lists them while player is instanced — add `UnitIsInMyGuild` **and** guildmate unit also reports in-instance (or same `GetInstanceInfo` instanceID when available). Document as hardening, not day-one blocker if combat+instance-type already limits value.

---

## 6. Quick decision table

| Signal | False-positive risk | V1 role |
|--------|---------------------|---------|
| Guildmate in HOME/INSTANCE group | Medium without instance filter | Core predicate |
| Qualifying instance type | Low | Input from track 15 |
| Player combat in bucket | Low | Anti-AFK authority |
| `UnitIsAFK` | High if used as sole gate | Telemetry only |
| Proximity / `UnitInRange` | High false negatives | Out |
| Roster zone match | Medium | Out |
| BeefNet peer presence | N/A (wrong tool) | Out |
