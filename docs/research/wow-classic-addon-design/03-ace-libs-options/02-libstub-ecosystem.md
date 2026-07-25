# LibStub Ecosystem

**Last updated:** 2026-07-25  
**Sources:** [LibStub on CurseForge/WowAce](https://www.curseforge.com/wow/addons/libstub), [Ace3 Getting Started — embeds](https://www.wowace.com/projects/ace3/pages/getting-started), deep-research basis in [`.raw/`](.raw/), scrapes in [`.firecrawl/libstub-curseforge.md`](.firecrawl/libstub-curseforge.md).

---

## 1. Problem LibStub solves

Many addons need the same shared libraries (Ace*, ChatThrottleLib, LibSharedMedia, LibDataBroker, LibDBIcon, CallbackHandler). Without a versioned loader:

- Duplicate globals collide
- Older embeds overwrite newer APIs
- Load order becomes tribal knowledge

**LibStub** is the de facto registry: libraries declare a major name + minor revision; consumers request by major name and get the highest registered minor.

---

## 2. Contract (conceptual)

| Operation | Meaning |
|-----------|---------|
| `NewLibrary(major, minor)` | Register or upgrade; returns `nil` if an equal-or-newer minor already exists (caller should abort redefinition) |
| `GetLibrary(major[, silent])` / `LibStub("Major-1.0")` | Fetch the active table |
| Iteration helpers | Enumerate registered libs (debug / tooling) |

Major strings look like `"AceDB-3.0"`, `"LibSharedMedia-3.0"`, `"LibStub"` itself is special-cased as the loader.

**Load order rule:** LibStub’s own Lua file must load **before** any LibStub-aware library in the TOC / embeds.xml.

---

## 3. Embedding vs OptionalDeps

| Strategy | Behavior | When used |
|----------|----------|-----------|
| **Embed** | Copy of lib ships inside the addon; works offline from other addons | Default for distribution |
| **`## OptionalDeps: Ace3`** (or similar) | Soft preference for a standalone provider’s load order | Common alongside embeds |
| **Hard Deps** | Fail/warn if missing | Rare for Ace; more common for thin “requires SharedMedia” cosmetics |

Contemporary practice for Classic utility addons: **embed the libs you need**, declare OptionalDeps for the big providers, let LibStub dedupe at runtime when multiple embeds exist.

---

## 4. Ecosystem map (CoB-adjacent)

```
LibStub
├── CallbackHandler-1.0          (AceEvent / many libs)
├── Ace3 suite                   (Addon, DB, Config, Comm, …)
├── LibSharedMedia-3.0           (fonts, statusbars, sounds, …)
├── LibDataBroker-1.1            (data objects for bars / minimap)
├── LibDBIcon-1.0                (minimap button from LDB object)
├── AceGUI-3.0-SharedMediaWidgets (optional AceConfig media pickers)
└── ChatThrottleLib              (often non-Ace; BeefNet pacing analogue)
```

Church of Beef V1 design already names ChatThrottleLib-style pacing for BeefNet. That lib is usually LibStub-or-global embedded separately from AceComm (AceComm itself integrates throttling concepts).

---

## 5. Packaging norms

Production addons (e.g. WeakAuras `.pkgmeta` pattern cited in deep research) declare **externals** so the CurseForge packager checks out library trunks into `Libs/` at build time. Authors do not hand-maintain stale copies forever.

For a knowledge-first CoB repo:

- Document which libs are allowed embeds
- Keep version pins / `.pkgmeta` as a packaging decision when distribution starts
- Do not invent a parallel loader — LibStub is the ecosystem

---

## 6. Relevance to Church of Beef

| Decision | Recommendation |
|----------|----------------|
| V1 required libs | None of Ace required by design spec |
| First soft embeds worth considering | LibStub + LibDataBroker + LibDBIcon (minimap), optionally ChatThrottleLib |
| Full Ace embed | Defer until options/profile surface justifies weight |
| Never | Custom competing stub/loader |

**Alt doctrine note:** LibStub does not change SavedVariables scope. Per-character ladder doctrine (§9 of the design spec) is a TOC / data-model choice, independent of library embedding.
