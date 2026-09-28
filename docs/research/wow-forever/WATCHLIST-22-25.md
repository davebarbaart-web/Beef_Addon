# Watchlist — OPEN_QUESTIONS #22–#25

**Research guidance, not product law.** Bible v1.1.1 and `docs/design/OPEN_QUESTIONS.md` win. David / the Design Lead resolve. Do not invent answers here.

**When:** Forever beta opens **17 Sep 2026** (window through **21 Oct 2026**; launch **4 Nov 2026**). This file is the re-check list for that window.

**How to measure:** sibling [BETA-MEASUREMENT-PLAYBOOK.md](BETA-MEASUREMENT-PLAYBOOK.md). Record facts; do not start Forever-targeted code from a measurement.

**Standing law (Bible §3.2):** no system may depend on APIs or features beyond a conservative Classic-family baseline unless it gracefully degrades. On official Classic+ announcement, re-validate Appendix A before further platform-dependent work. Home remains Anniversary TBC (`20506`) until David says otherwise (OPEN_QUESTIONS #6, #22).

Local dumps in this folder (`wow-forever-technical.json`, `search-identity.json`, `search-systems-beta.json`, `search-addon-api.json`) are pre-beta snapshots. Re-check the live pages, not the dumps.

---

## Still banned this pass

No Forever work until David opens it. In particular:

- No Forever TOC flavor (`_Forever`, `_forever_`, or any new suffix)
- No Forever installer path, Battle.net product-id gate, or `WOW_PROJECT_*` branch
- No comma-listed Forever `## Interface`, no `AllowLoadGameType` invented for a Forever game type
- No Lua, no schema, no cross-ruleset BeefNet, no shared-SV assumption with Anniversary
- Do not treat pre-beta lineage `wowdev2` / `1.60.0.69818` as a public addon host
- Do not assume Interface `16000`

Anniversary `ChurchOfBeef.toc` stays `## Interface: 20506`.

---

## #22 — Forever port when

**Recorded, unanswered:** whether Church of Beef ports to Forever at all, and whether Anniversary stays the home client through TBC. Beta is the measurement window, not a port license.

**Church of Beef assumption that would move:** §3.1 / #6 home client (Anniversary TBC `20506`). A port decision, or a ruling that Anniversary is no longer home, is David's. §3.2 already requires Appendix A re-validation before any platform-dependent work; that is an obligation, not a yes.

**Re-check on beta day**

| Source | What to look for |
|--------|------------------|
| [Carve a New Path — Forever announce](https://news.blizzard.com/en-us/article/24302093/carve-a-new-path-with-world-of-warcraft-forever) | Still the official Classic+ product? Dates unchanged? |
| [Forever product page](https://worldofwarcraft.blizzard.com/en-us/forever) | Client still a separate Battle.net product beside Classic / Modern? |
| [Battle.net Forever shop](https://us.shop.battle.net/en-us/product/world-of-warcraft-forever) | Beta window, launch clock, subscription vs pack entitlements |
| Bible Appendix A (live Anniversary client) | Re-validate only after David opens platform-dependent work — not from this note |

---

## #23 — Forever character identity

**Recorded:** two-part, region-unique names; a client setting can hide the secondary. **Unpublished:** `UnitName`, guild-roster, and whisper strings. **Unanswered:** how `Store:EnsureCharacterByName` and `COB.Names.Key` should treat Main vs full name vs a later GUID. §12.4 (name reuse / durable identity) stays out of scope. Do not invent a schema.

**Church of Beef assumption that would move:** identity keys are a **spelling** (`COB.Names.Key` / `Display`), not the human and not durable character identity. If the live client returns Main-only, full two-part, realm-suffixed, or a GUID in roster / whisper / `UnitName`, the key shape is a measurement — not a store rewrite.

**Re-check on beta day**

| Source | What to look for |
|--------|------------------|
| [EU forum — Character Naming](https://eu.forums.blizzard.com/en/wow/t/character-naming-wow-forever/628121) | Still two-part? Secondary unique per character or shareable across alts? Official reply or still stream-inference? |
| Official product / What's Next recap ([panel recap](https://worldofwarcraft.blizzard.com/en-us/news/24303862/world-of-warcraft-forever-whats-next-panel-recap)) | Any published name-string or GUID API note |
| Live client (playbook) | Exact `UnitName("player")`, `GetGuildRosterInfo` name field, whisper / addon-message sender, secondary-name display toggle on vs off |
| Name reservation window (shop copy: 27 Oct–3 Nov 2026) | Whether reserved names match in-game strings; do not treat reservation UX as a schema |

---

## #24 — Forever guild / BeefNet topology

**Recorded:** realmless; rulesets Normal / PvP / RP; Hardcore after launch; no cross-ruleset grouping. **Official pages do not say** whether guilds, `GUILD` addon chat, or one Pope-writer star still exist across rulesets. **Unanswered:** can the Church remain one guild on one ruleset, or does the star need a new transport. Do not invent a cross-ruleset net.

**Church of Beef assumption that would move:** Bible §13.1 star — one Pope writer; congregation display + input; state on the guild addon channel; whispers to the Pope for INPUT. If guilds are missing, `GUILD` addon chat is missing or ruleset-local, or one guild cannot span the congregation, the star's transport is in question. That is a measurement, not a new codec. Bible §3.3 already keeps Hardcore off the home client (tournament-scoped); Forever Hardcore after launch does not reopen that by itself.

**Re-check on beta day**

| Source | What to look for |
|--------|------------------|
| Forever product page + [What's Next recap](https://worldofwarcraft.blizzard.com/en-us/news/24303862/world-of-warcraft-forever-whats-next-panel-recap) | Guilds named? Ruleset isolation restated? |
| [SendAddonMessage](https://warcraft.wiki.gg/wiki/API:C_ChatInfo.SendAddonMessage) / [GetGuildRosterInfo](https://warcraft.wiki.gg/wiki/API:GetGuildRosterInfo) | Wiki still Classic-family only, or a Forever row? `GUILD` / `WHISPER` still listed? |
| [Status of Addons in Forever?](https://us.forums.blizzard.com/en/wow/t/status-of-addons-in-forever/2348036) | Official reply vs player guess (Retail lockdown is not confirmation) |
| Live client (playbook) | Can you create/join a guild on one ruleset? Does `C_ChatInfo.SendAddonMessage(..., "GUILD")` enqueue? Does a second client on another ruleset see it? (Expect no if "no cross-ruleset grouping" holds — record, do not design around it.) |

---

## #25 — Forever packaging / store tree

**Unpublished:** `## Interface`, TOC suffix, `AllowLoadGameType`, Battle.net product id, install folder, and whether `ChurchOfBeefDB` is a separate WTF tree. Pre-beta lineage is encrypted `wowdev2` / `1.60.0.69818` (not a public addon host). Do not assume `_forever_`, Interface `16000`, or a shared SV file with Anniversary.

**Church of Beef assumption that would move:** one TOC, Interface `20506`, account-level `## SavedVariables: ChurchOfBeefDB`, install under the Anniversary client tree. Classic-family convention is a **per-`game_type`** WTF root — Forever's folder name and whether that tree is shared with `_anniversary_` are unpublished. A published Interface / suffix / product id / WTF path would be packaging facts for a later David-opened pass, not a license to ship a second TOC now.

**Re-check on beta day**

| Source | What to look for |
|--------|------------------|
| [TOC format](https://warcraft.wiki.gg/wiki/TOC_format) | New game-type row? New suffix? `AllowLoadGameType` token? Forever in the Interface table? |
| [WOW_PROJECT_ID](https://wowpedia.fandom.com/wiki/WOW_PROJECT_ID) (or the warcraft.wiki.gg move) | New `WOW_PROJECT_*` constant — record only; do not gate |
| [SavedVariables](https://wowpedia.fandom.com/wiki/SavedVariables) | Whether the `_game_type_` slot has a Forever name |
| Battle.net app + live disk (playbook) | Product id, install folder, `Interface/AddOns` path, `WTF/Account/.../SavedVariables` path vs Anniversary |
| `/dump (select(4, GetBuildInfo()))` on the beta client | Interface number — do not write it into `ChurchOfBeef.toc` |

---

## Pointers

- Product law: `docs/design/Game_Design_Bible_v1.1.1.md` §3.2, §12.4, §13.1, Appendix A
- Questions: `docs/design/OPEN_QUESTIONS.md` #6, #22–#25
- Measurement steps: [BETA-MEASUREMENT-PLAYBOOK.md](BETA-MEASUREMENT-PLAYBOOK.md)
