# Interface Versions and TOC Metadata

**Last updated:** 2026-07-25  
**Primary source:** [TOC format (warcraft.wiki.gg)](https://warcraft.wiki.gg/wiki/TOC_format)  
**Patch anchors:** [2.5.5/API changes](https://warcraft.wiki.gg/wiki/Patch_2.5.5/API_changes) (TOC `20505`), [2.5.6/API changes](https://warcraft.wiki.gg/wiki/Patch_2.5.6/API_changes) (TOC `20506`)

---

## 1. What `## Interface` means

- The Interface number is the client build lineage the addon claims compatibility with.
- If the addon’s Interface is older than the client’s current Interface, the addon is marked **out of date**.
- If `## Interface` is omitted, the client treats the addon as **always out of date**.
- Interface is **not** a marketing version string; it is derived from the client version by stripping periods (and following Blizzard’s Classic-line numbering).

Verify on a live client with `/dump (select(4, GetBuildInfo()))`.

---

## 2. Classic flavor Interface table (wiki template, mid-2026)

Values from the wiki’s [latest interfaces](https://warcraft.wiki.gg/wiki/TOC_format#Interface_version) table (contributor-maintained; always re-verify in-game after a patch):

| Game line | Role | Interface (wiki) |
|-----------|------|------------------|
| Classic Era / Vanilla-line (Era, Hardcore, SoD share this line with patch drift) | `vanilla` | **`11509`** (Vanilla Test `11508`) |
| **Burning Crusade Classic / TBC Anniversary** | `tbc` | **`20506`** (TBC Test also listed `20506`) |
| Wrath Classic | `wrath` | `30405` |
| Titan Reforged | Wrath-family | `38001` |
| Cataclysm Classic | `cata` | `40402` |
| MoP Classic | `mists` | `50504` |
| Retail / Midnight-line | `mainline` | `120007` (example in wiki; moves often) |

### TBC Anniversary patch ladder (confirmed)

| Patch | TOC Interface | Notes |
|-------|---------------|--------|
| 2.5.5 | `20505` | Anniversary UI modernization wave (raid frames / shared modern UI code) |
| **2.5.6** | **`20506`** | Live Anniversary bump documented 2026-07; Kaivax notes Classic shares modern UI code |

Church of Beef V1 design/plan already targets **`20506`**. That matches current wiki + 2.5.6 patch notes. Bump the TOC when Anniversary patches again.

### Season of Discovery / Era

SoD is not a separate Interface *family* in the TOC table; it rides the **Vanilla / Era** line (`115xx`). Treat SoD as a port target with Era-compatible packaging, not TBC packaging.

### Multi-client declaration

Comma-delimited Interfaces are supported:

```
## Interface: 120007, 50504, 38001, 20506, 11509
```

Wiki guidance: prefer comma-delimited Interface versions and/or per-file `[AllowLoadGameType …]` over proliferating TOC files when possible.

---

## 3. Client-specific TOC suffixes

| Suffix | Loads on |
|--------|----------|
| `_TBC.toc` | Burning Crusade Classic **and Classic Anniversary Edition** (`tbc`) |
| `_Vanilla.toc` | Classic Era line (`vanilla`) |
| `_Cata.toc` / `_Mists.toc` / `_Wrath.toc` | Named Classic expansions |
| `_Classic.toc` | **All Classic clients** (behavior changed so it is not Era-only) |
| `_Mainline.toc` | Retail |

Priority: expansion-specific suffixes beat `_Classic` / `_Mainline`. Example: both `_Cata.toc` and `_Classic.toc` → Cata client uses `_Cata.toc`.

**Anniversary note:** game type `tbc` explicitly covers Burning Crusade Classic **and** Classic Anniversary Edition. A `_TBC.toc` or a single TOC with `## Interface: 20506` is the correct V1 packaging shape.

**`_Classic` behavior change:** Cataclysm Classic patch 4.4.0 (and related Classic-line updates) changed `_Classic` so it loads on **all** Classic clients, not just Era. Do not assume `_Classic` means “Vanilla only.”

---

## 4. Essential TOC metadata (official tags)

| Directive | Purpose |
|-----------|---------|
| `## Interface:` | Compatibility / out-of-date flag |
| `## Title:` / `## Notes:` / `## Author:` / `## Version:` | AddOns list display |
| `## SavedVariables:` | Account-wide persistence globals |
| `## SavedVariablesPerCharacter:` | Per-character persistence globals |
| `## LoadSavedVariablesFirst:` | Load SV before scripts (rare) |
| `## Dependencies:` | Hard deps — addon will not load if missing |
| `## OptionalDeps:` | Soft deps — load earlier if present |
| `## LoadOnDemand:` | Defer until `LoadAddOn` / LoadWith / LoadManagers |
| `## LoadWith:` | Load when named addons load (implies LoD) |
| `## DefaultState:` | enabled / disabled |
| `## IconTexture:` / `## IconAtlas:` | AddOns list icon |
| `## X-*` | Custom metadata readable via `GetAddOnMetadata` |

### Conditional file / metadata loading

`[AllowLoadGameType …]` restricts a file (and, on newer clients, metadata) to game types such as `tbc`, `vanilla`, `cata`, `mists`, `wrath`, `mainline`, `classic`. Example from wiki:

```
VanillaOrTBC.lua [AllowLoadGameType vanilla, tbc]
```

Useful for a future Classic+ / multi-flavor port; unnecessary complexity for single-flavor V1.

---

## 5. Packaging rules that bite

1. **Folder name must match `.toc` basename** (`ChurchOfBeef/ChurchOfBeef.toc`).
2. **Files load top-to-bottom**; order in the TOC is load order.
3. Prefer **backslashes** in TOC paths for `Include` compatibility (wiki).
4. **Separate installs:** Anniversary is a distinct client tree from Classic Era. Players must install into the Anniversary `Interface/AddOns` path; Era SavedVariables/AddOns do not auto-migrate.
5. **Shared modern UI code:** Blizzard has stated Classic shares significant UI code with modern WoW (Edit Mode / raid frames / nameplates landings in 2025–2026). That does **not** mean Retail-only Lua APIs are safe — stick to Classic-available APIs; treat Retail-only surfaces as out of V1 scope (design spec §2).

---

## 6. Implications for Church of Beef packaging

| Decision | Recommendation |
|----------|----------------|
| V1 TOC | Single `ChurchOfBeef.toc` with `## Interface: 20506` |
| Multi-flavor later | Add Interface list and/or `_Vanilla.toc` / `_TBC.toc`; avoid Retail Interface in V1 |
| Install docs | Document Anniversary AddOns path explicitly (not `_classic_era_`) |
| Out-of-date after patch | Expect Interface bumps on 2.5.x maintenance; verify with `GetBuildInfo` |
