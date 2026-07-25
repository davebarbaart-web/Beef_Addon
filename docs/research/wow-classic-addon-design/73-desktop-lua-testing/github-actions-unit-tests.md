# GitHub Actions — unit tests vs lint vs packager

**Track:** [73-desktop-lua-testing](README.md)  
**Does not cover:** BigWigs packager release workflows → [33](../33-packager-ci-releases/).

Addon repos that automate anything usually run **three different jobs**. Mixing them causes “green release, broken math” or “failed zip because busted missing.”

---

## Job separation

| Job | Trigger | Purpose | Beef |
|-----|---------|---------|------|
| **unit** | `push` / `pull_request` | Desktop Lua asserts | `lua tests/run.lua` (or busted) |
| **lint** | `push` / `pull_request` | Luacheck globals / style | Optional; WowAddonDevGuide pattern |
| **release / packager** | tags / manual | Zip + upload | [33](../33-packager-ci-releases/) only |

Track 33 already notes Luacheck/unit tests “can live as prior steps, but they are QA … not packager config” ([02-pkgmeta-and-workflow-yml](../33-packager-ci-releases/02-pkgmeta-and-workflow-yml.md)). Prefer **separate workflow files** so a CurseForge secret problem never blocks Core tests and vice versa.

---

## Pattern 1 — zero-dep (matches Beef plan)

```yaml
name: unit
on: [push, pull_request]
jobs:
  core:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: leafo/gh-actions-lua@v10   # pin current major when implementing
        with:
          luaVersion: "5.1"
      - name: Run Core/Data tests
        run: lua tests/run.lua
```

Why Lua 5.1: WoW embeds 5.1 ([Wowpedia Introduction to Lua](https://wowpedia.fandom.com/wiki/Introduction_to_Lua); [lua-users World Of Warcraft](http://lua-users.org/wiki/WorldOfWarcraft)). Plan allows local 5.4 for pure logic; CI should still prefer 5.1.

`leafo/gh-actions-lua` + `leafo/gh-actions-luarocks` are the documented combo for Lua on Actions ([Testing Lua projects with GitHub Actions](https://leafo.net/guides/testing-lua-modules-with-github-actions.html)). Alternatives: [xpol/setup-lua](https://github.com/xpol/setup-lua) with explicit `5.1.5`.

Working directory: repo root so plan paths `addon/ChurchOfBeef/...` and `tests/...` resolve.

---

## Pattern 2 — busted via LuaRocks

From leafo’s guide:

```yaml
- uses: leafo/gh-actions-lua@v5
  with:
    luaVersion: "5.1"
- uses: leafo/gh-actions-luarocks@v2
- run: luarocks install busted
- run: busted -o utfTerminal
```

Or the first-party Action ([busted README](https://github.com/lunarmodules/busted)):

```yaml
- uses: lunarmodules/busted@v0
  with:
    args: --verbose spec
```

Use TAP/JSON output if you need a results aggregator; plain exit code is enough for V1.

---

## Pattern 3 — Luacheck (static, not unit)

WowAddonDevGuide’s lint workflow uses `nebularg/actions-luacheck` plus a `.luacheckrc` that whitelists WoW globals (`CreateFrame`, `C_ChatInfo`, …) and sets `std = "lua51"` ([Publishing & CI/CD](https://www.wowaddondev.guide/docs/publishing-cicd)). Optional generator: [Jayrgo/wow-luacheckrc](https://github.com/Jayrgo/wow-luacheckrc).

**Luacheck ≠ tests.** It will not catch a wrong Gora loss payout. Run both if you want; never replace `tests/run.lua` with lint alone.

---

## Pattern 4 — fat CLI mock (rare)

PersoLootRoll-style: `lua Test.lua` on the runner after checkout. Needs whatever system libs the mock uses (`io`, `os`, optional build path). Heavier cache; only if you adopt that harness ([ecosystem-harnesses](ecosystem-harnesses.md)).

---

## Matrix testing

leafo shows a `strategy.matrix.luaVersion: ["5.1", "5.2", …]` — useful for libraries. **Beef should pin 5.1 only** (client truth). Extra versions add noise when Core is intentionally 5.1-shaped.

---

## Failure modes

| Symptom | Likely cause |
|---------|----------------|
| `module 'wow_stub' not found` | `package.path` / cwd not repo root |
| Tests pass locally on 5.4, fail on 5.1 | `unpack` vs `table.unpack`, `#` on holes, etc. |
| Packager job red, unit green | Secrets / `.pkgmeta` — not a Core bug |
| Unit green, guild broken | Expected — transport/UI are track 19 |

---

## Steal / adapt

- **Steal:** separate `unit.yml` + `lint.yml` + `release.yml`.
- **Steal:** `luaVersion: "5.1"` from leafo’s guide.
- **Adapt for Beef:** one step `lua tests/run.lua` until busted earns its keep.
- **Avoid:** installing busted inside the BigWigs packager job.
