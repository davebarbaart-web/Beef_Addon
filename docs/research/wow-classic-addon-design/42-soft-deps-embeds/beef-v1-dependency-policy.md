# Church of Beef V1 — dependency policy

**Last updated:** 2026-07-25  
**Track:** [42-soft-deps-embeds](README.md)  
**Status:** Research recommendation for implementers — promote to design-spec decisions log if adopted.  
**Aligned with:** V1 plain-frames stance; synthesis “LibDBIcon / CTL when embedding” vs “hard Dependencies that break solo load” ([00](../00-church-of-beef-implications.md)).

---

## 1. Policy one-liners

1. **Solo load is mandatory.** Church of Beef core never uses `## Dependencies:` / `RequiredDeps` in V1.
2. **Prefer zero shared libs until a concrete pain appears.** Plain frames + SavedVariables + slash/minimap can ship without LibStub.
3. **When a lib is adopted, embed it** (externals preferred; hard vendor only as a temporary/manual-zip measure). Do not ask guildies to install Ace3 / LibStub / CTL separately for core features.
4. **Soft peers are feature-detected.** OptionalDeps only for load order; never assume presence.
5. **LibStub etiquette applies the moment the first LibStub-using file is added.**
6. **nolib is opt-in later**, not part of V1 success criteria.

---

## 2. Allow / deny matrix

| Dependency | V1 policy | Notes |
|------------|-----------|-------|
| Hard `## Dependencies:` on any peer | **Deny** | Breaks solo load |
| Ace3 full stack (AceAddon/AceDB/AceConfig/…) | **Defer** | Track 03; reconsider for V2 options/profiles |
| LibStub | **Allow when embedding** | Load first; never OptionalDeps/X-Embeds for LibStub itself |
| ChatThrottleLib (or equivalent outbound queue) | **Allow / recommended before noisy BeefNet** | Spec requires CTL-style pacing; embed, don’t hard-dep |
| LibDataBroker-1.1 + LibDBIcon-1.0 | **Allow when minimap collectors bite** | Hand-rolled button OK until then ([28](../28-minimap-addon-compartment/)) |
| CallbackHandler-1.0 | **Allow as transitive** | Pulled with Ace/LDB stacks |
| LibSharedMedia / Masque | **Soft-only / V1 deny as requirement** | Optional later; never required for media |
| BugGrabber / BugSack | **Dev/QA soft peer** | Do not ship as hard dep; testers install separately ([19](../19-testing-debugging-qa/)) |
| ElvUI / other UI suites | **Never depend** | Coexistence only (track 02 / 10) |
| Standalone Ace3 addon | **Optional peer** | If Ace embeds land: OptionalDeps + X-Embeds `Ace3` |
| `.pkgmeta` `required-dependencies` | **Avoid for core** | Listing “required” Ace trains users to think Beef needs it |
| `.pkgmeta` `optional-dependencies` | **OK for soft peers** | Listing only; still feature-detect |
| `.pkgmeta` `externals:` | **Preferred** once packager exists | See [externals-vs-vendor.md](externals-vs-vendor.md) |
| Committed `Libs/` vendor | **Temporary OK** | Migrate to externals when CI lands (33) |
| nolib package | **Off by default** | Enable only with explicit dual-path QA |

---

## 3. Adoption triggers (ordered)

Do **not** embed “because cousins do.” Embed when a trigger fires:

| Order | Trigger | First embed set |
|------:|---------|-----------------|
| 0 | V1 greenfield | None |
| 1 | BeefNet outbound needs real pacing under guild load | LibStub + ChatThrottleLib **or** a tiny in-tree queue with CTL-like priorities (document which) |
| 2 | Minimap collectors / Addon Compartment friction | + LibDataBroker-1.1 + LibDBIcon-1.0 |
| 3 | Options/profiles complexity exceeds hand-rolled UI | AceDB + AceConfig stack (V2; track 03) — then OptionalDeps/X-Embeds Ace3 |
| 4 | Skinning pass | Soft OptionalDeps Masque / LSM; never hard |

---

## 4. TOC / pkgmeta templates (policy-shaped)

### V1a — no embeds

```
## Interface: 20506
## Title: Church of Beef
## Notes: …
## SavedVariables: ChurchOfBeefDB
## OptionalDeps:
## X-Embeds:

ChurchOfBeef.lua
```

(Omit empty OptionalDeps/X-Embeds lines entirely in real TOC.)

### V1b — CTL embed (illustrative metadata only)

```
## Interface: 20506
## Title: Church of Beef
## SavedVariables: ChurchOfBeefDB

embeds.xml
Core.lua
```

```yaml
# .pkgmeta (when packager exists)
externals:
  Libs/LibStub:
    url: https://repos.wowace.com/wow/libstub/trunk
    tag: latest
  Libs/ChatThrottleLib:
    url: <upstream CTL repo URL>
    tag: latest
# enable-nolib-creation: no   # explicit if using CF packager defaults
```

No `required-dependencies`. No TOC Dependencies.

### V1c — + LibDBIcon

Add LDB + LibDBIcon externals; load after LibStub in `embeds.xml`. Still no hard Dependencies. OptionalDeps/X-Embeds still unnecessary unless you also support a standalone shared-lib layout.

---

## 5. Conflict & support SLAs (process)

| Risk | Policy response |
|------|-----------------|
| “Works on my machine” missing LibStub | Clean-folder QA gate before every tagged build |
| Guildie has ancient broken embed of a shared lib | Pin Beef externals to known-good; document “disable conflicting outdated fork” only as last resort |
| Officer installs nolib by mistake | Don’t publish nolib until supported; listing copy says “full package includes libraries” |
| Someone requests hard-dep Ace3 to shrink zip | Reject for V1 — zip size is cheaper than install friction |

---

## 6. Explicit non-goals for this policy

- Choosing AceConfig control types / profile UX → **03**
- Measuring CTL CPS / BeefNet budgets → **14**
- Writing the GitHub Actions packager workflow → **33**
- Implementing embeds in the addon tree → out of research scope (no code in this folder)

---

## 7. Decision log hint

If product owners accept this matrix, add a short line to the design spec decisions log:

> V1 ships with no hard TOC Dependencies; shared libs (if any) are embedded; LibStub etiquette applies; Ace3 deferred; nolib off.

Until then, treat this file as the research recommendation.
