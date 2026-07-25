# Install paths and client trees

**Last updated:** 2026-07-25  
**Scope:** Where Church of Beef must be installed on player machines; how Anniversary differs from Era and other Classic trees.

---

## 1. Mental model: one Battle.net install, many client roots

Blizzard ships multiple Classic client directories under the same `World of Warcraft` install. AddOns and WTF are **per client root**. Copying nothing is the default — players who “already have Questie on Era” still need an Anniversary install unless they manually copy ([Blizzard forum — BCC addons thread](https://us.forums.blizzard.com/en/wow/t/the-burning-crusadeaddons/2226408); [Mythic-Store](https://mythic-store.com/us/blog/best-tbc-anniversary-addons-full-guide-for-2025)).

| Client root (folder name) | Typical content | Beef V1 relevance |
|---------------------------|-----------------|-------------------|
| `_anniversary_` | TBC Classic Anniversary Edition | **Required install target** |
| `_classic_era_` | Classic Era, SoD, Hardcore (Era-line) | Not V1; separate tree |
| `_classic_` | Progression Classic (historically TBC/Wrath/Cata line in older guides) | Do not assume = Anniversary |
| Retail / mainline folders | Retail | Out of scope |

Exact disk location varies (Battle.net custom library paths). Relative paths below are what matter.

---

## 2. Canonical Anniversary AddOns path

Documented by multiple Anniversary-specific sources:

**Windows:** `…/World of Warcraft/_anniversary_/Interface/AddOns/`  
**macOS:** `…/World of Warcraft/_anniversary_/Interface/AddOns/`

Cited:

- [Mythic-Store — Best TBC Anniversary Addons (2026)](https://mythic-store.com/us/blog/best-tbc-anniversary-addons-full-guide-for-2025) — explicit `_anniversary_` paths for Win/Mac; notes copying from `_classic_era_` → `_anniversary_` as a migration tip.
- [MikScrollingBattleText (TBC Anniversary) file 5.0.4](https://www.curseforge.com/wow/addons/mikscrollingbattletext-tbc-anniversary/files/7573212) — author install: extract into `World of Warcraft/_anniversary_/Interface/AddOns/`.
- [Sportskeeda — BCC Anniversary CurseForge tab](https://www.sportskeeda.com/mmo/best-wow-tbc-anniversary-addons-set) — seed CurseForge detection by placing an addon under **Anniversary → Interface → AddOns**, then reload the app.
- [MMOEXP mirror of same workflow](https://www.mmoexp.com/News/best-wow-tbc-anniversary-addons-and-how-to-set-them-up.html).

Beef packaged folder name remains `ChurchOfBeef` (matches `.toc` basename) → full path:

`…/_anniversary_/Interface/AddOns/ChurchOfBeef/`

---

## 3. Era path (contrast only)

Classic Era / SoD / Hardcore commonly use:

`…/World of Warcraft/_classic_era_/Interface/AddOns/`

([Mythic-Store](https://mythic-store.com/us/blog/best-tbc-anniversary-addons-full-guide-for-2025); community “copy Interface + WTF from classic era to anniversary” posts on [Blizzard forums](https://us.forums.blizzard.com/en/wow/t/the-burning-crusadeaddons/2226408).)

**Implication:** Guild Discord onboarding that says “put it in your Classic AddOns folder” is ambiguous and will land Beef in the wrong client for Anniversary mains.

---

## 4. Misleading guides (support debt)

Several Anniversary *listicles* still tell players to install into `_classic_era_` or generic `_classic_` ([Overgear FAQ](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/) states `_classic_era_` for Anniversary; older progression guides often cite `_classic_`). Treat those as **wrong for Anniversary** unless the author’s screenshot shows `_anniversary_`.

Support triage order when “addon doesn’t show”:

1. Confirm client is Anniversary (realm/client selection), not Era.
2. Confirm folder is `_anniversary_/Interface/AddOns/ChurchOfBeef`.
3. Confirm `ChurchOfBeef.toc` exists and `## Interface` matches live Anniversary build.
4. Character select → AddOns → enable + load out-of-date if testing a stale Interface.

---

## 5. WTF / SavedVariables isolation

Per-character SavedVariables live under that client’s WTF tree (`WTF/[account]/[realm]/[character]/SavedVariables`), not under AddOns ([TOC SavedVariables docs](https://warcraft.wiki.gg/wiki/TOC_format#Saved_variables)).

Beef V1: `SavedVariablesPerCharacter: ChurchOfBeefDB` — so:

- Ladder state on an Era alt does **not** appear on Anniversary.
- Dreamscythe Alliance and Doomhowl Horde are separate realms/guilds (spec §5); each character’s WTF is already separate.
- Copying WTF from Era → Anniversary (community workaround at TBC pre-patch) can pull stale Era profiles into Anniversary; fine for UI packs, risky for Beef if someone later dual-ships flavors without a schema guard.

---

## 6. Addon managers

| Manager | Anniversary reality (Jan–Jul 2026 community) |
|---------|-----------------------------------------------|
| CurseForge app | Needs a **BCC Anniversary** / TBC Anniversary game tab; often appears after logging into Anniversary once or seeding `Interface/AddOns` under `_anniversary_` ([Sportskeeda](https://www.sportskeeda.com/mmo/best-wow-tbc-anniversary-addons-set); [Blizzard forum](https://us.forums.blizzard.com/en/wow/t/the-burning-crusadeaddons/2226408)) |
| WowUp | Guides recommend it alongside CurseForge for Anniversary detection ([Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/); [MMOGAH](https://www.mmogah.com/news/tbc-classic-anniversary/best-addons-for-tbc-anniversary-setup-fixes-and-must-have-tools)) |

**Beef packaging note:** Distribute as a normal Classic TBC / Anniversary zip. Do not instruct users to install via the Era CurseForge tab.

---

## Sources

- [Mythic-Store — Best TBC Anniversary Addons](https://mythic-store.com/us/blog/best-tbc-anniversary-addons-full-guide-for-2025) (Feb 2026)
- [MSBT TBC Anniversary — install path](https://www.curseforge.com/wow/addons/mikscrollingbattletext-tbc-anniversary/files/7573212) (Feb 2026)
- [Sportskeeda — CurseForge BCC Anniversary tab](https://www.sportskeeda.com/mmo/best-wow-tbc-anniversary-addons-set) (Jan 2026)
- [Blizzard forums — The burning crusade/addons](https://us.forums.blizzard.com/en/wow/t/the-burning-crusadeaddons/2226408) (Jan 2026)
- [TOC format — Saved variables](https://warcraft.wiki.gg/wiki/TOC_format#Saved_variables)
