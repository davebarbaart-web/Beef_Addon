# Packaging build types & distribution channels

**Track:** [48 README](README.md)  
**Related:** [19 alpha-channels](../19-testing-debugging-qa/alpha-channels.md) (QA lens); this note focuses on **feature gating** via what code ships and who receives it.

## 1. Compile-time flags (packager keywords)

The Classic/Retail addon ecosystem’s real feature-flag compiler is the packager.

### BigWigsMods/packager

[Packager README — Build type keywords](https://github.com/BigWigsMods/packager) documents comment-delimited blocks:

| Keyword | Runs when | Packaged behavior |
|---------|-----------|-------------------|
| `alpha` | Untagged builds | Kept in alpha zips; commented out otherwise (line numbers preserved) |
| `debug` | **Never** in packaged builds | Only unpackaged source (dev checkout) |
| `do-not-package` | Never | **Removed** from zip (line numbers shift — put at file end) |
| `non-alpha` / etc. | Inverse logic | Block-comment form |
| `version-classic` / `version-bcc` / … | Game flavor | Multi-flavor TOC/Lua splits |

Lua form: `--@keyword@` … `--@end-keyword@` becomes long-bracket comments when inactive.

### CurseForge Automatic Packaging

[Automatic Packaging](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging):

- Untagged commits → **alpha** file type (when packaging all commits)
- Tags containing `alpha` / `beta` → that release type; otherwise release
- Alpha replacements: `--@alpha@` … `--@end-alpha@` keeps asserts in development and alpha zips, **not** in release/beta (doc example: `assert(everythingIsOkay())`)

`wow-build-tools` aims at packager parity including the same build-type tokens ([CurseForge project](https://www.curseforge.com/wow/addons/wow-build-tools)).

### What to put in which block (Beef)

| Code | Block |
|------|-------|
| `/beef debug standing` and forge helpers | `@do-not-package@` (or `@debug@` if you want them in unpackaged only) |
| Verbose BeefNet dump / sync tracing | `@alpha@` |
| Production officer gate, ladder, commits | Always packaged (no keyword) |
| Experimental V2 UI behind SV flag | Always packaged once stable enough for Alpha testers; optional `@alpha@` for extra logging only |

**Insight:** Prefer `@do-not-package@` for anything that must never exist on a streamer’s Release install — a false `COB.DEBUG` default is weaker than code absence.

## 2. Distribution channels (who gets which zip)

### CurseForge release types

Driven by tags / untagged commits as above ([Automatic Packaging](https://support.curseforge.com/support/solutions/articles/9000197281-automatic-packaging)).

### WowUp per-addon channel

[WowUp — My Addons details](https://wowup.io/guide/my-addons/addons):

- Right-click → Channel → Stable / Alpha / Beta
- Selecting Alpha means you **accept that tier or newer**, not “alpha only”
- WowUp installs the **latest** build so users are not stranded on stale alphas after authors stop cutting them
- Works for providers that publish pre-releases (WowUpHub, CurseForge called out)

### Beef distribution ladder (rollout-oriented)

| Stage | Channel / pipe | Audience | Feature-flag posture |
|-------|----------------|----------|----------------------|
| Dev checkout | Manual copy | Authors | `@debug@` paths live; `COB.DEBUG` on |
| Pre-guild night | **Alpha** | Officers + 2–3 volunteers | New proto / V2 UI flags on for testers |
| Soft launch | **Beta** | Interested members | Feature-complete; polish bugs OK |
| Guild “live” | **Release** | Everyone | Debug stripped; V2 flags default off until proven |

Manual Discord zip labeled alpha is fine before CurseForge exists — same social contract as Alpha channel (track 19).

## 3. Channel vs SV flag vs proto major

| Goal | Prefer |
|------|--------|
| Hide unfinished chrome from casual members | SV default-off **or** don’t ship file yet |
| Let officers test unfinished chrome | Alpha zip + SV on for them |
| Prevent mixed guilds from corrupting ladder | Proto major bump + ignore incompatible |
| Ensure debug slash cannot be enabled on stream | `@do-not-package@` |

## 4. Antipatterns

| Antipattern | Why |
|-------------|-----|
| Every commit tagged as Release | No staged cohort; guild eats breakage |
| Alpha-only forever with no Release | Casual members stuck or stop updating |
| Relying on WowUp “Alpha only” semantics | WowUp intentionally upgrades to newer stables ([guide](https://wowup.io/guide/my-addons/addons)) |
| Leaving `@alpha@` asserts in mental model of Release | They are stripped — don’t depend on them for production safety |

## 5. Insight

**Packaging keywords are compile-time feature flags; CurseForge/WowUp channels are cohort feature flags.** Together they approximate staged rollout without a server. Beef should use both once packaging exists; until then, Discord Alpha zip + officer cohort is the same pattern by hand.
