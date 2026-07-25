# Church of Beef — Release Pipeline Recommendations

**Last updated:** 2026-07-25  
**Track:** [33-packager-ci-releases](README.md)  
**Maps to:** [V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §5, §12, §13

---

## 1. Goals (what “good” looks like)

1. Every guild-facing build is a **reproducible zip** whose root is `ChurchOfBeef/` (not the monorepo root).
2. Officers can get **alpha** builds without Discord archaeology once WowUp/CF is online ([track 19](../19-testing-debugging-qa/alpha-channels.md)).
3. **Release** tags are deliberate; they match Interface **20506** (verify live) and changelog notes officers can paste.
4. Secrets never sit in `docs/` or addon Lua.
5. Multi-flavor ports do not block V1.

---

## 2. Phased pipeline

### Phase 0 — Manual (now / early V1)

| Step | Practice |
|------|----------|
| Build | Copy or zip `addon/ChurchOfBeef/` → Anniversary `Interface/AddOns/ChurchOfBeef` |
| Version | Hand-edit `## Version:` or ignore until packager |
| Audience | Authors only |
| QA | BugSack on; scriptErrors 1 ([track 19](../19-testing-debugging-qa/)) |

Stop-gap only — no host tokens required.

### Phase 1 — Packager zip + GitHub Release (recommended next)

| Piece | Recommendation |
|-------|----------------|
| Tool | `BigWigsMods/packager@v2` |
| Workflow | `.github/workflows/release.yml` (name optional; “packager.yml” synonym OK) |
| Triggers | `workflow_dispatch` + `push.tags` |
| Args | `-t addon/ChurchOfBeef` (critical monorepo flag); omit upload secrets or pass `-d` until ready |
| PackageMeta | `.pkgmeta` beside addon root or via `-m`; `package-as: ChurchOfBeef`; ignore `docs/`, `.raw/`, research |
| Secrets | `GITHUB_OAUTH` ← `GITHUB_TOKEN` (contents write) |
| TOC | `## Interface: 20506` (verify); `## Version: @project-version@` when keywords enabled |
| Channels | Tag `v0.x.0-alpha.N` for officers; `v1.0.0` for guild night |

### Phase 2 — CurseForge / Wago alphas for officers

| Piece | Recommendation |
|-------|----------------|
| Projects | Create CurseForge (+ optional Wago) project when ready for WowUp |
| TOC ids | `X-Curse-Project-ID`, `X-Wago-ID` |
| Secrets | `CF_API_KEY`, `WAGO_API_TOKEN` |
| Branch policy | Optional: package `main` pushes as alpha; **never** auto-promote main → Release |
| Tester setup | Officers set WowUp channel to Alpha on Anniversary client only ([track 19](../19-testing-debugging-qa/alpha-channels.md)) |
| `@alpha@` | Optional BeefNet verbose logging — strip from release tags |

### Phase 3 — WoWI + multi-flavor (optional / post-V1)

| Piece | Recommendation |
|-------|----------------|
| WoWI | Separate listing if desired; `WOWI_API_TOKEN`; release tags only |
| Multi-flavor | Add `_TBC.toc` / `-S` when Era or other clients are real ports ([04](04-multi-flavor-builds.md)) |
| Listing copy | Track [31](../31-listing-copy-discovery/) — not packager’s job |

---

## 3. Suggested tag & changelog discipline

```
v0.1.0-alpha.1   # first officer pipe
v0.2.0-alpha.3   # BeefNet sync fixes
v0.9.0-beta.1    # soft guild preview
v1.0.0           # §13 success-criteria night
v1.0.1           # hot fix release
```

- Prefer **annotated** tags with a one-paragraph message officers can reuse in Discord.
- Keep `CHANGELOG.md` human-edited for Release; let packager auto-changelog feed alphas ([`.pkgmeta` manual-changelog](https://github.com/BigWigsMods/packager/wiki/Preparing-the-PackageMeta-File)).
- Bump Interface in the same commit as the tag that needs it — never tag first and fix TOC later without a new tag.

---

## 4. Monorepo layout checklist

Design spec packages from `addon/ChurchOfBeef/` ([§5](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). Before enabling upload:

- [ ] Packager `-t` (or isolated package root) points at the addon folder
- [ ] `ignore:` excludes research library and secrets
- [ ] Zip extracts to a single `ChurchOfBeef/` directory
- [ ] Case of `ChurchOfBeef.lua` / TOC matches on disk
- [ ] No `docs/canon/` duplication of `Data/Ranks.lua` numbers inside the zip (canon prose stays out)

---

## 5. Decision table (product)

| Question | Recommendation |
|----------|----------------|
| Public CurseForge in V1? | Optional — guild Discord + GitHub Release is enough to meet §13 |
| Auto-alpha on every commit? | Only after Phase 2; keep off while iterating privately |
| Embed Ace via externals? | No for V1 unless Ace already adopted (synthesis / track 03) |
| nolib packages? | Skip until real shared-lib embeds exist |
| Classic+ / Era in same zip? | Deferred; design for portability only (§3.2 / §12) |

---

## 6. Explicit non-goals for this track

- Implementing `.github/workflows/*` in-repo (research only)
- Replacing CurseForge moderation / ToS review ([track 24](../24-policy-tos-compliance/))
- Marketing blurb for the project page ([track 31](../31-listing-copy-discovery/))
- Teaching WowUp channel UX beyond the pointer to track 19
