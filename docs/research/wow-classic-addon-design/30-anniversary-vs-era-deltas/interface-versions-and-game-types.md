# Interface versions and game types (product gates)

**Last updated:** 2026-07-25  
**Scope:** Which Interface / game-type tokens gate Anniversary vs Era — as *product packaging decisions*, not a full TOC directive catalog.  
**Defer to:** [04-toc-api-performance/](../04-toc-api-performance/) (when filled) and [TOC format](https://warcraft.wiki.gg/wiki/TOC_format) for complete metadata lists.

---

## 1. Why Interface numbers are a product issue

Wrong `## Interface:` → addon marked out of date; players may not load it unless they enable “Load out of date AddOns” ([TOC format — Interface version](https://warcraft.wiki.gg/wiki/TOC_format#Interface_version)). For a guild tool, that looks like “Beef is broken” during onboarding.

**Live check (any client):** `/dump (select(4, GetBuildInfo()))`

---

## 2. Flavor → Interface snapshot (verify live)

Values from wiki LatestInterface table / patch notes as of research scrape (Jul 2026). Numbers drift every patch.

| Flavor | Game type token | Typical Interface | Notes |
|--------|-----------------|-------------------|-------|
| **TBC Classic Anniversary** | `tbc` | **`20506`** (patch 2.5.6) | V1 target; [Patch 2.5.6/API changes](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes) lists TOC `20506` |
| Classic Era / Vanilla-line | `vanilla` | `11509` (wiki table; Era also tracked near `11508` test) | SoD / Hardcore share Era-line infrastructure with patch drift |
| Cataclysm Classic | `cata` | `40402` | Multi-flavor pattern only |
| MoP Classic | `mists` | `50504` | Multi-flavor pattern only |
| Retail / Midnight | `mainline` / `standard` | `120007` etc. | Forbidden for V1 APIs |

Wiki Interface table also lists TBC Test/TBC as `20506` in the scraped local corpus; some third-party refs still say `20505` from 2.5.5-era packaging ([MSBT changelog](https://www.curseforge.com/wow/addons/mikscrollingbattletext-tbc-anniversary/files/7573212) corrected toward `20505` during 2.5.5 — do not treat that as current without `/dump`).

**Church of Beef V1 decision:** ship `## Interface: 20506` per approved plan/spec; bump when Anniversary patches raise the fourth `GetBuildInfo` return.

---

## 3. Game-type identity: Anniversary ≡ TBC, not Era

From [TOC format — client-specific TOC files](https://warcraft.wiki.gg/wiki/TOC_format#Client-specific_TOC_files) and AllowLoadGameType tables:

| Token / suffix | Loads on |
|----------------|----------|
| `tbc` / `_TBC.toc` | Burning Crusade Classic **and Classic Anniversary Edition** |
| `vanilla` / `_Vanilla.toc` | Classic Era line |
| `classic` / `_Classic.toc` | **All** Classic expansions (behavior widened; see §4) |
| `mainline` / `_Mainline.toc` | Retail |

**Product read:** There is no separate `_Anniversary.toc` suffix. Anniversary is the TBC game type. Packaging that targets Era (`vanilla` only) will miss the V1 audience.

Legacy hyphen suffixes: `-BCC` recognized historically; wiki Classic Anniversary patch notes state **`-BCC` is no longer supported** as of Patch 2.5.5 (2026-01-13) ([TOC format — Patch changes / Classic Anniversary](https://warcraft.wiki.gg/wiki/TOC_format)). Prefer `_TBC.toc`, never `-BCC`.

---

## 4. Patch 2.5.5 / 2.5.6 packaging deltas that matter

| Change | Product impact |
|--------|----------------|
| Anniversary Patch **2.5.5** (2026-01-13): `_Classic` suffix loads on **all** Classic clients; includes Classic Era changes up to 1.15.8; `-BCC` dropped ([TOC format patch notes](https://warcraft.wiki.gg/wiki/TOC_format)) | A lone `_Classic.toc` is a wide net — fine for universal Classic libraries, **wrong** as the only gate for an Anniversary-only guild product |
| Anniversary Patch **2.5.6**: TOC resource `20506`; UI shared-code update; Kaivax notes Era **1.15.9** API closely matches **2.5.6** for UI work ([Patch 2.5.6/API changes](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes); [forum thread](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408)) | UI libs can often be dual-tested on Anniversary then Era; **content** still differs |

---

## 5. Comma-Interface vs per-suffix TOC (decision pointer)

Wiki preference: comma-delimited `## Interface:` and `[AllowLoadGameType …]` over proliferating TOC files ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format)).

For Beef packaging *strategy* (when to use which), see [beef-multi-toc-packaging.md](beef-multi-toc-packaging.md). Do not duplicate the full suffix matrix beyond the Anniversary vs Era product gate above.

---

## Sources

- [TOC format](https://warcraft.wiki.gg/wiki/TOC_format)
- [Patch 2.5.6/API changes](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes) (Jul 2026)
- [User Interface Updates in Classic — Kaivax](https://us.forums.blizzard.com/en/wow/t/user-interface-updates-in-classic/2325408) (Jul 2026)
- Plan/spec: `Interface: 20506`
