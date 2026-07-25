# LibStub etiquette and version conflicts

**Last updated:** 2026-07-25  
**Track:** [42-soft-deps-embeds](README.md)  
**Primary sources:** [LibStub — CurseForge](https://www.curseforge.com/wow/addons/libstub), [LibStub — Wowpedia](https://wowpedia.fandom.com/wiki/LibStub), [Embedded Library Woes — Blizzard UI forum](https://us.forums.blizzard.com/en/wow/t/embedded-library-woes/1610075), [“forgot to embed LibStub” field reports](https://www.reddit.com/r/wow/comments/v9hlho/please_help_me_figure_out_this_lua_error/).

Ace *module* APIs live in track **03** — this note is only about versioning / sharing rules that govern every embed.

---

## 1. What LibStub is for

LibStub is a tiny public-domain major/minor registry:

- `LibStub:NewLibrary(major, minor)` → library table to fill, or **nil** if an equal/newer minor is already registered.
- `LibStub(major)` / `GetLibrary(major [, silent])` → the **one** live instance for that major.
- Multiple addons embed the same major; **highest minor wins for everyone**.

It is not a per-addon private sandbox. Forum consensus (2023 Embedded Library Woes): LibStub returns the shared upgraded table, not “your folder’s copy of the code.”

---

## 2. Include etiquette (authoritative checklist)

From LibStub project docs (CurseForge / WowAce guidance mirrored in research `.raw/libstub.md`):

### Libraries that use LibStub

| Do | Don’t |
|----|-------|
| Point `.pkgmeta` externals at LibStub (or copy `LibStub.lua` next to the lib) | Load LibStub from the library’s **embed** XML (the host addon loads LibStub) |
| Load LibStub from the library’s **standalone** `.toc` if the lib can ship alone | Set LibStub as `X-Embeds` or OptionalDeps |
| Disable nolib for pure library projects when appropriate (`enable-nolib-creation: no`) | Assume the user’s other addons already provided LibStub during *your* testing |

### Addons that embed libraries

| Do | Don’t |
|----|-------|
| Load `LibStub.lua` first via TOC or `embeds.xml` | List LibStub in OptionalDeps / X-Embeds |
| Ship LibStub inside your package (external or vendor) | Forget LibStub because “my other addons had it” — classic support failure mode |
| Treat missing LibStub as a packaging bug | Hard-`Dependencies:` LibStub as a separate addon |

---

## 3. Library author pattern (conflict-safe)

Canonical shape:

```lua
local MAJOR, MINOR = "MyLib-1.0", 5
local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then
  return -- equal or newer already loaded; do not redefine
end

-- only mutate `lib` after the nil check
```

Bump **minor** when behavior/API surface changes in a compatible way. Bump **major** (`MyLib-2.0`) when you break callers — old and new majors can coexist as separate registry keys.

---

## 4. Conflict realities (what actually breaks)

| Situation | Outcome | Mitigation |
|-----------|---------|------------|
| Addon A embeds lib minor 3; B embeds minor 5; B loads later | Everyone uses minor 5 | Keep minors monotonic; don’t ship ancient forks |
| A embeds minor 5; B embeds broken minor 6 | Everyone may get the broken one | Prefer packager externals pinned to known-good tags; watch upstream |
| Two “same” libs without LibStub (raw globals) | Last loader wins, silently | Never ship shared libs without LibStub (or an equivalent) |
| Lib holds **addon-private** state in the shared table | Second consumer sees/clobbers first’s data | Store per-addon data on the addon object / private table; lib stays stateless or keyed by addon |
| Author tests with full UI suite, forgets to embed LibStub | Works for author; fails for clean installs | Clean Interface/AddOns smoke test with *only* Beef |

Major-version forks (`AceAddon-3.0` vs hypothetical `-4.0`) are intentional coexistence; do not “fix” conflicts by renaming majors casually.

---

## 5. Embed vs standalone Ace3 (load interaction)

When users keep a standalone Ace3 addon **and** Beef embeds Ace pieces:

1. `OptionalDeps: Ace3` helps Ace3 load first if present.
2. LibStub still upgrades to the **newer** minor among standalone + embeds.
3. Your embeds must remain compatible with that upgrade path — another reason to pull Ace via packager externals (`tag: latest` or a pinned known-good tag) rather than a forever-frozen vendored tree you never refresh.

If Beef V1 embeds **no** Ace, this interaction is moot until options work lands.

---

## 6. Beef-specific rules

1. **Do not invent a second versioning system** for shared code other addons might also embed.
2. **ChatThrottleLib / LibDBIcon / LDB** — if embedded, go through LibStub majors they already use; don’t rewrite them into Beef globals.
3. **BeefNet protocol tables and SV** — first-party; never registered via LibStub unless intentionally publishing a reusable library (out of V1 scope).
4. **Clean-install QA gate:** one client with only Church of Beef (+ BugSack optional) must load without “LibStub nil” / “LibDBIcon nil” errors. See track 19 for QA process; the *dependency* criterion lives here.

---

## Related

- TOC soft/hard pairing: [toc-soft-hard-deps.md](toc-soft-hard-deps.md)
- How libs enter the zip: [externals-vs-vendor.md](externals-vs-vendor.md)
