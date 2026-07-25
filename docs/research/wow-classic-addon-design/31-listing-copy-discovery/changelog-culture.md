# Changelog culture (CurseForge / Wago / Classic)

**Maps to:** Per-file **Changelog** tab players open before updating — not the long Description.

## Where changelogs live

- CurseForge attaches a changelog to each **file** upload (seen under Files → Changelog) ([example DBM file page](https://www.curseforge.com/wow/addons/deadly-boss-mods/files/3901030); [BigWigs_Classic file](https://www.curseforge.com/wow/addons/bigwigs_classic/files/5629060)).
- Wago Addons exposes a **Releases** tab with version rows and supported game versions ([Gargul Wago](https://addons.wago.io/addons/gargul); [BigWigs_Classic Wago versions](https://addons.wago.io/addons/bigwigs-classic/versions)).
- Many authors mirror GitHub Releases / `CHANGELOG.md` (ElvUI keeps a public changelog link on Tukui/GitHub ([ElvUI GitHub](https://github.com/tukui-org/ElvUI); [Tukui ElvUI](https://tukui.org/elvui))).

## What megaproject culture looks like

| Pattern | Example | Player value |
|---------|---------|--------------|
| Version header + date + compare link | BigWigs: `## [v12.0.8] … Full Changelog` ([BigWigs_Classic file](https://www.curseforge.com/wow/addons/bigwigs_classic/files/5629060)) | Traceability |
| Bullet dump from commits | “Update zhCN/zhTW”, “Fix countdowns…” ([DBM file changelog](https://www.curseforge.com/wow/addons/deadly-boss-mods/files/3901030)) | Devs yes; casual skimmers no |
| Alpha vs Release education | DBM explains multiple alphas/day; set client release channel ([DBM description](https://www.curseforge.com/wow/addons/deadly-boss-mods)) | Stops “why so many updates” |
| Supported patches listed per release | Wago version tables list Retail + Classic Era + TBC patches ([BigWigs_Classic Wago](https://addons.wago.io/addons/bigwigs-classic/versions)) | Flavor confidence |
| Display Name ≠ zip name | CF allows a friendlier Display Name per file ([Creating and Submitting a Project](https://support.curseforge.com/en/support/solutions/articles/9000197241-creating-and-submitting-a-project)) | “Anniversary hotfix” vs hash zip |

## What Classic guild players actually skim for

Priority order observed from how Classic-facing projects present releases:

1. **Does it support my flavor / Interface?** (TBC Classic / Anniversary bump)
2. **Is anything broken for guild sync / officers?**
3. **New player-facing feature** (one line)
4. Localization / internal refactors (ignored)

Attune’s gallery even includes a “Summary of the latest updates” image — treating release notes as visual marketing ([Attune](https://www.curseforge.com/wow/addons/attune)).

## Recommended Beef changelog template

Use short, player-facing bullets. Prefer Keep-a-Changelog *tone* (Added / Fixed / Changed) even if not the formal standard:

```markdown
## 0.1.0 — TBC Classic Anniversary
Requires Interface 20506 (Anniversary). Install in the Anniversary AddOns folder.

### Added
- Guild ladder and My Standing (/beef)
- Officer+ approve/reject queue
- Throttled guild-chat announce on approve

### Fixed
- (none)

### Notes
- Not a combat addon. Members without the addon still see chat announces.
- Dual-listed on CurseForge and Wago — same version string on both.
```

### Interface-bump releases (most common Classic trust event)

```markdown
## 0.1.1
### Changed
- TOC Interface → 2050X for current Anniversary patch
### Fixed
- Officer queue after roster reload
```

Lead with Interface/flavor; bury commit noise.

## Release-channel culture (optional later)

- Tag experimental builds **Alpha/Beta** so default clients don’t auto-pull (DBM pattern) ([DBM](https://www.curseforge.com/wow/addons/deadly-boss-mods)).
- For V1 guild tool: prefer rare **Release** uploads; avoid daily alpha spam that trains officers to ignore updates.

## Dual-host discipline

Authors must update CF and Wago themselves; managers do not sync changelogs across hosts ([Blizzard forums](https://us.forums.blizzard.com/en/wow/t/wow-up-curse-wago/2292441)). Same version string + same changelog body on both reduces “CF says update, Wago doesn’t” Discord noise.

## Boundary with track 05

Packaging/automation (pkgmeta, packager, WowInterface auto-publish) belongs in **05**. This note only covers **what to write** in the changelog field so Classic guild players trust the update.
