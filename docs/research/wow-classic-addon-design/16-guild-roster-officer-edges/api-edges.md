# Guild roster API edges (Classic / TBC Anniversary)

**Audience:** Implementers of `Core/Officer.lua` and BeefNet commit validation.  
**Stance:** Research notes only — no addon code. Spec/plan remain product truth.

---

## 1. Roster request / refresh

### APIs

| Call | Role |
|------|------|
| [`C_GuildInfo.GuildRoster()`](https://warcraft.wiki.gg/wiki/API_C_GuildInfo.GuildRoster) | Modern name; requests server roster update |
| [`GuildRoster()`](https://wowpedia.fandom.com/wiki/API_GuildRoster) | Legacy global; same semantics historically |

TBC Classic 2.5.1 documented `C_GuildInfo.GuildRoster` as replacing `GuildRoster` ([Stanzilla BCC UI changes](https://github.com/Stanzilla/WoWUIBugs/wiki/2.5.1-Consolidated-UI-Changes)). Anniversary clients follow the modernized Classic API surface; prefer `C_GuildInfo.GuildRoster` with a fallback only if a flavor lacks the namespace (verify on `Interface: 20506` before shipping).

### Throttle

Both wiki pages document: a call is **ignored completely** if the last `GuildRoster()` was **less than 10 seconds** ago ([C_GuildInfo.GuildRoster](https://warcraft.wiki.gg/wiki/API_C_GuildInfo.GuildRoster), [GuildRoster](https://wowpedia.fandom.com/wiki/API_GuildRoster)).

**Beef implication:** On `RANK_COMMIT` / `SYNC_REQUEST`, if the local roster cache is already populated from a recent update, validate against cache. Do not call GuildRoster per message. Re-request when stale, on login, after `PLAYER_GUILD_UPDATE`, or when lookup fails.

### Event

[`GUILD_ROSTER_UPDATE`](https://warcraft.wiki.gg/wiki/GUILD_ROSTER_UPDATE):

- Fires when the client guild-info cache updates after a GuildRoster request **or** after guild data changes (excluding Guild Information window edits per wiki).
- Payload: `canRequestRosterUpdate` (boolean) — use this rather than blind re-request loops.
- Added in Classic as of 1.13.2 family per wiki patch note.

Wiki detail: update means “updated (but not necessarily altered)” — the event can fire without meaningful rank changes. Debounce UI/officer-tab rebuilds.

---

## 2. Reading members

### `GetGuildRosterInfo(index)`

Primary page: [GetGuildRosterInfo](https://warcraft.wiki.gg/wiki/API_GetGuildRosterInfo).

Relevant returns for Beef:

| Return | Use |
|--------|-----|
| `name` | Character name, often **with realm** (e.g. `Arthas-Silvermoon`) |
| `rankName` | Localized/custom string — **do not gate on this** |
| `rankIndex` | **0 = Guild Master**; higher = lower authority |
| `isOnline` | Offline members still appear; zone is last-known |
| `publicNote` / `officerNote` | `""` if empty **or** if viewer lacks note permission |
| `guid` | Stable identity when available (prefer for long-lived records if present on Anniversary) |

Index range: `1` … [`GetNumGuildMembers()`](https://warcraft.wiki.gg/wiki/API_GetNumGuildMembers).

### Counts

`numTotal, numOnline = GetNumGuildMembers()` — wiki: [GetNumGuildMembers](https://warcraft.wiki.gg/wiki/API_GetNumGuildMembers).

Edges:

- May need a prior GuildRoster to be correct.
- Can return wrong values immediately after leaving a guild.
- **Maximum returned value 500** (wiki Details).
- Modern wiki notes totals are **no longer affected** by `SetGuildRosterShowOffline`; older Classic behavior historically *did* filter iteration — treat show-offline as a **Classic gotcha to verify** on Anniversary if lookups miss offline officers during tests.

### Offline members

- Offline characters remain roster rows with `isOnline == false` ([GetGuildRosterInfo](https://warcraft.wiki.gg/wiki/API_GetGuildRosterInfo)).
- Rank index for offline members is still readable once roster is loaded — useful for UI (“who is Officer+”) but **irrelevant for live commit authorship** (sender must be online to emit addon messages).
- [`SetGuildRosterShowOffline`](https://wowpedia.fandom.com/wiki/API_SetGuildRosterShowOffline): toggles UI filter; changing it can fire `GUILD_ROSTER_UPDATE`. Avoid flipping this flag as a side effect of Beef validation (can fight Blizzard guild UI / other addons).

**Beef implication:** Offline officers cannot approve until they log in. Members who were offline during a promotion rely on §8.3 login sync, not on re-reading the offline officer’s client.

---

## 3. Local player guild / rank

### `GetGuildInfo(unit)`

[GetGuildInfo](https://warcraft.wiki.gg/wiki/API_GetGuildInfo):

```
guildName, guildRankName, guildRankIndex, realm = GetGuildInfo(unit)
```

- `guildRankIndex` is **zero-based** (0 = GM).
- Documented login race: with `"player"`, returns can be **nil even when the player is in a guild** until guild data arrives. Wiki recommends treating guild readiness as `IsInGuild() and GetGuildInfo("player")`, and listening to **`GUILD_ROSTER_UPDATE` + `PLAYER_GUILD_UPDATE`**.

**Beef implication:** `LocalIsOfficer()` must return false / “unknown” until `guildRankIndex` is non-nil. Spec §11 already says hide Officer tab / no-op approve when not Officer+; extend mentally to “roster not ready” as not Officer+.

### Rank index vs GuildControl APIs

[GetGuildRosterInfo](https://warcraft.wiki.gg/wiki/API_GetGuildRosterInfo) documents: rankIndex starts at 0 for GM; **add 1** to align with `GuildControlGetRankName(index)`.

[GuildControlGetRankFlags](https://wowwiki-archive.fandom.com/wiki/API_GuildControlGetRankFlags) returns permission booleans for the *currently selected* rank via `GuildControlSetRank`. Classic example uses `GuildControlSetRank(playerrank + 1)` because control APIs are **1-based** while `GetGuildInfo` rank is **0-based**.

Flags include (among others): `invite_member`, `view_officer_note`, `edit_officer_note`, `officerchat_listen`, `officerchat_speak`, `promote`, `demote`. Important: these are **independent checkboxes** on the guild rank editor — not synonyms for “Officer+”.

---

## 4. `IsGuildOfficer` and permission proxies

### `C_GuildInfo.IsGuildOfficer()`

- Wiki: [C_GuildInfo.IsGuildOfficer](https://warcraft.wiki.gg/wiki/API_C_GuildInfo.IsGuildOfficer) — returns boolean; added Retail **8.2.5**.
- Present in Classic-family API dumps / BCC notes: [Stanzilla 2.5.1 Consolidated UI Changes](https://github.com/Stanzilla/WoWUIBugs/wiki/2.5.1-Consolidated-UI-Changes) lists it under `C_GuildInfo` additions for BC Classic.
- Wiki does **not** document the predicate (rank index? officer-chat bit? Blizzard “officer” flag?).

**Beef implication:** Safe as a fast local UX hint *only if* playtesting confirms it matches Church’s notion of Officer+. **Do not** replace the configurable `rankIndex <= OfficerRankIndexMax` check for `RANK_COMMIT` validation. Spec §6.2 explicitly requires index threshold because rank names are arbitrary; the same logic rejects opaque helpers.

### Invite ≠ Officer

[`CanGuildInvite()`](https://wowprogramming.com/docs/api/CanGuildInvite.html) — true if the player may invite to guild.

Many guilds grant invite to recruiters / trial officers / bank alts without putting them at rank index ≤ 1. **Invite permission is a false friend for Beef authority.**

### Officer notes ≠ Officer+

[`CanEditOfficerNote()`](https://wowprogramming.com/docs/api/CanEditOfficerNote.html) / `C_GuildInfo.CanEditOfficerNote` ([BCC replacement note](https://github.com/Stanzilla/WoWUIBugs/wiki/2.5.1-Consolidated-UI-Changes)) — true if the player may edit officer notes.

Historical UI pattern: some chat addons used `CanEditOfficerNote()` as a proxy for showing officer chat ([ChatBar changelog lore](https://www.wowinterface.com/downloads/info4422-ChatBar.html)). That proxy is **wrong for Beef**:

- Note edit can be granted without top rank.
- Note *view* can be opened to all members while write stays officers-only (common GRM-style setups).
- Empty string from `GetGuildRosterInfo` officer note field means “no access or empty” — cannot infer rank from notes.

**Beef implication:** Never use note or invite Can\* APIs as the approve gate. Optional: surface “you can invite but aren’t Officer+ for Beef” in settings help text if misconfiguration support tickets appear.

---

## 5. Login / reload timing (approval-critical)

Ordered mental model for Anniversary:

1. Addon loads → SavedVariables available; **roster may not be**.
2. `IsInGuild()` may be true early while `GetGuildInfo("player")` is still nil ([GetGuildInfo details](https://warcraft.wiki.gg/wiki/API_GetGuildInfo)).
3. Request roster (`C_GuildInfo.GuildRoster`) once ready to ask.
4. Wait for `GUILD_ROSTER_UPDATE` before building name→rankIndex map.
5. Only then: show Officer tab, allow local approve, validate inbound `RANK_COMMIT`.

Failure modes aligned with spec §11:

| Situation | Correct behavior |
|-----------|------------------|
| Roster not loaded, commit arrives | Queue briefly or drop; **never apply** |
| Sender not in guild roster | Reject |
| Sender rankIndex > threshold | Reject |
| Local player rank unknown | Treat as non-officer for UI actions |
| Player left guild | Spec: hide ladder row; scoring paused |

Community report pattern (roster count stuck at 0 for a long time after login) appears on older wiki talk pages — treat as rare but real: timeouts on queued commits should expire safely without applying.

---

## 6. Name matching for BeefNet senders

Spec §6.2: addon-message **sender names are server-supplied** and trustworthy as identity; validation is roster rank lookup.

Edges:

- Roster `name` may include `-Realm` ([GetGuildRosterInfo](https://warcraft.wiki.gg/wiki/API_GetGuildRosterInfo)).
- Chat/addon sender strings may be bare or realm-qualified depending on client/cross-realm (Anniversary is same-guild / same-faction realm context for V1 — still normalize).
- Build the lookup map with **normalized keys** (strip/compare realm consistently; case rules per client norms). Prefer matching on GUID if both sides expose it later; V1 plan uses name strings.

Missing from roster after normalize → fail closed (not Officer+).

---

## 7. Rank remaps and threshold configuration

Default plan/spec: `OfficerRankIndexMax = 1` → indices **0 and 1** (GM + first officer tier).

Gotchas:

- If the guild inserts a new rank *above* members but renumbers, “Officer” titled ranks can slide to index 2+ → sudden mass loss of Beef approve rights.
- If the guild grants a low rank index to a joke rank (“Alt”, “Friends”) at slot 1, those characters become Beef officers.
- Renaming ranks without reordering indices does **not** break the gate (names ignored) — good.

**Operational guidance for Church of Beef guilds:** Keep true officers in the top WoW rank slots; change `OfficerRankIndexMax` in canon/settings if the guild uses more than one officer tier below GM.

---

## 8. Classic-specific gotchas checklist (approval gates)

1. **10-second GuildRoster throttle** — don’t couple to every packet ([wiki](https://warcraft.wiki.gg/wiki/API_C_GuildInfo.GuildRoster)).
2. **Login nil guild info** — wait for events ([GetGuildInfo](https://warcraft.wiki.gg/wiki/API_GetGuildInfo)).
3. **Index base mismatch** — roster/GetGuildInfo = 0-based; GuildControl names/flags selection = +1 ([GetGuildRosterInfo](https://warcraft.wiki.gg/wiki/API_GetGuildRosterInfo), [GuildControlGetRankFlags](https://wowwiki-archive.fandom.com/wiki/API_GuildControlGetRankFlags)).
4. **Permission proxies lie** — invite / officer-note Can\* ≠ Officer+ ([CanGuildInvite](https://wowprogramming.com/docs/api/CanGuildInvite.html), [CanEditOfficerNote](https://wowprogramming.com/docs/api/CanEditOfficerNote.html)).
5. **`IsGuildOfficer` opaque** — available on Classic-family since BCC notes; not a substitute for threshold ([IsGuildOfficer](https://warcraft.wiki.gg/wiki/API_C_GuildInfo.IsGuildOfficer), [BCC UI changes](https://github.com/Stanzilla/WoWUIBugs/wiki/2.5.1-Consolidated-UI-Changes)).
6. **Offline still on roster** — online bit is not a rank bit ([GetGuildRosterInfo](https://warcraft.wiki.gg/wiki/API_GetGuildRosterInfo)).
7. **500 member cap on count API** — unlikely for Beef; know the ceiling ([GetNumGuildMembers](https://warcraft.wiki.gg/wiki/API_GetNumGuildMembers)).
8. **Show-offline filter** — don’t mutate global UI state for validation; verify Anniversary whether iteration omits offline ([SetGuildRosterShowOffline](https://wowpedia.fandom.com/wiki/API_SetGuildRosterShowOffline)).
9. **Battle.net guild REST APIs** are unrelated to in-game addon gates (forum noise about Classic web roster 403s) — ignore for V1.

---

## 9. Mapping to Church of Beef modules

| Module concern | API edge takeaway |
|----------------|-------------------|
| `COB.Officer:IsOfficerIndex` | Pure threshold; unit-testable; matches plan Task 5 |
| `rosterLookup(name)` | After GuildRoster + `GUILD_ROSTER_UPDATE`; normalized names |
| `LocalIsOfficer` | `GetGuildInfo("player")` rankIndex when ready; else false |
| BeefNet `RANK_COMMIT` | Fail closed if lookup nil / not officer |
| Officer tab visibility | Hide until local rank known **and** ≤ max |
| Login sync §8.3 | Orthogonal to offline *officers*; covers offline *receivers* |

No change recommended to spec’s anti-cheat stance (§6.3): human officers remain the gate; these edges only keep the mechanical check honest.
