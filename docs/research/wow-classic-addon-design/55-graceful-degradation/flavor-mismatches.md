# Flavor mismatches (wrong client / TOC / API surface)

**Last updated:** 2026-07-25  
**Track:** [55-graceful-degradation](README.md)  
**Related QA procedure:** [19 multi-flavor-toc-testing](../19-testing-debugging-qa/multi-flavor-toc-testing.md) — this note is **resilience policy**, not test steps.

---

## 1. What “flavor mismatch” means for Beef

A player (or packager) lands Church of Beef in a client that is not TBC Anniversary:

| Install mistake | Typical symptom |
|-----------------|-----------------|
| Wrong game tree (Era / Retail / MoP folder) | Addon missing, grey “Out of Date,” or loads with broken APIs |
| Stale `## Interface:` | Out of Date unless “Load out of date” is checked ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format)) |
| Multi-Interface comma list includes Retail | Looks “supported” on Mainline while Classic-only assumptions explode |
| Wrong TOC suffix chosen by client | Unexpected file set loads (`_TBC` vs `_Vanilla` vs root) |

Anniversary / TBC uses the `_TBC` TOC family; Era uses `_Vanilla`; Retail uses Mainline/Standard ([TOC client-specific files](https://warcraft.wiki.gg/wiki/TOC_format)). Wiki Interface tables drift — always confirm with `/dump (select(4, GetBuildInfo()))`.

---

## 2. V1 policy: fail loud at packaging, soft at runtime

**Packaging (preferred):** Ship Anniversary-only Interface (plan `20506` — verify live). Do not advertise Retail numbers in the same TOC. Wrong-client installs should prefer “doesn’t load” over “loads broken.”

**Runtime (if it loads anyway):**

1. Read `WOW_PROJECT_ID`.  
2. If not BC Classic / Anniversary family → set `clientSupported = false`.  
3. Disable BeefNet + instance scoring that call flavor-specific APIs.  
4. Keep `/beef` frame usable as a **local** ladder viewer with a one-time chat warning: wrong client / unsupported.  
5. Never error-spam every frame.

This matches spec §12 portability isolation without promising Classic+ support in V1.

---

## 3. API divergence classes (degrade differently)

| Class | Examples | Degradation |
|-------|----------|-------------|
| **Messaging policy** | Classic `CHANNEL` banned; Retail Midnight encounter locks | Stay on `GUILD`; ignore Retail-only restrictions for V1 |
| **Namespace churn** | `C_AddOns.*` vs legacy `IsAddOnLoaded` | Probe both if needed for deps (track 42) |
| **Guild notes as DB** | CEPGP-style officer notes; Retail note write blocks (2026 forum feedback) | Beef must **not** depend on note APIs for V1 ladder |
| **Instance / map IDs** | Different IDs across expansions | Behind a thin Instance module; scoring off if probe fails |
| **Calendar / season APIs** | Missing on some Classic flavors | Out of V1; feature-detect if ever used |

---

## 4. SavedVariables are not portable across flavors

Separate install trees ⇒ separate `WTF` trees. Copying Era SV into Anniversary is undefined (track 21). Resilience implication: never treat a foreign-flavor SV file as authoritative ladder truth — schema stamp + `SYNC_REQUEST` heal.

---

## 5. CurseForge / multi-TOC caution

[Multi-TOC support](https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons) helps managers pick the right artifact. For V1 resilience, prefer **one flavor artifact** over a kitchen-sink zip that “works everywhere” with `#ifdef`-style Lua. Portability rehearsal belongs in later Classic+ work (spec §14 V4), not V1 ship.

---

## 6. Steal / avoid

**Steal:** Anniversary-only Interface; project-id gate; thin Net/Instance modules.  
**Avoid:** Comma-listing every Interface “just in case”; calling Retail `C_EncodingUtil` / encounter messaging APIs on Classic “because the wiki page exists.”
