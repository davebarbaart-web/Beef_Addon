# Version & protocol gates

**Track:** [48 README](README.md)  
**Related:** [14 beefnet-mapping](../14-addon-messaging-beefnet/beefnet-mapping.md), [21 schema vs protocol](../21-savedvariables-migration/schema-versioning-migration.md)

## 1. Three different “versions”

| Kind | Lives in | Purpose |
|------|----------|---------|
| **TOC / Interface** | `## Interface: 20506` | Client flavor load gate (wrong client → addon disabled) |
| **Addon package version** | `## Version:` / `@project-version@` | Human/support; Gargul-style peer compare |
| **BeefNet proto major** | First fields of every `COB` message | Wire compatibility (spec §8.2) |
| **SV schema** | `ChurchOfBeefDB.schema` | Local file shape migrations (track 21) |

Do **not** collapse these. A player can have matching Interface, new zip Version, old proto understanding, and mid-migration schema — each fails differently.

## 2. Spec-locked BeefNet behavior

From design spec §8.1–§8.2 and §11:

- `HELLO` — version ping; soft-warn on major mismatch
- Incompatible / old major versions discarded
- Soft warning UI; do not apply incompatible commits
- Framing conceptual: `TYPE:protoMajor:…` within 255-char body ([beefnet-mapping](../14-addon-messaging-beefnet/beefnet-mapping.md))

**Insight:** Protocol major is the real cross-client feature flag. Bumping major is how you stage breaking BeefNet changes without requiring perfect simultaneous guild updates — old clients ignore new commits safely.

## 3. Cousin: Gargul version check

Gargul compares addon version across the group and shows who needs to upgrade or lacks the addon (`/gl version`, `/gl ve`) ([Version Check wiki](https://github.com/papa-smurf/Gargul/wiki/Version-Check)).

**Steal for Beef (V1 light / V2 polish):**

| Capability | V1 | V2+ |
|------------|----|-----|
| Soft-warn on `HELLO` major mismatch | Required (spec) | Keep |
| Officer slash `/beef version` listing peers | Optional stub | Useful before ceremony nights |
| Block UI with “upgrade required” | Avoid (soft-lock risk) | Only if proto cannot degrade gracefully |

Players without the addon must not soft-lock guild play (spec §8.2) — version UI is advisory spectacle for officers, not a raid lockout.

## 4. When to bump what

| Change | Bump |
|--------|------|
| New toast art / V2 dashboard behind SV flag | Nothing wire-related; optional package Version |
| New optional BeefNet field ignored by old parsers | Prefer additive field + same major if old clients skip unknown safely |
| New required commit field / new semantics | **proto major** + Alpha channel cohort |
| Rename SV keys | **schema** (track 21), not proto |
| Anniversary Interface bump only | TOC Interface |

## 5. Mixed-version guild nights (playbook)

1. Officers on Alpha zip with new proto major.
2. Members on Release still send/receive old major; ignore new commits.
3. `HELLO` soft-warns both ways so humans notice skew.
4. After one clean guild night, tag Release; members update via Stable.
5. Only then enable V2 UI flags by default (or remove the flag).

If a breaking change must land mid-week: prefer **officer-only Alpha** that does not emit new majors until a critical mass of members update — or emit dual-write (old + new) for one release (costly; avoid unless needed).

## 6. Downgrade / skew edges

| Situation | Behavior |
|-----------|----------|
| New client, old peer commits | Apply if major compatible + revision rules |
| Old client, new peer commits | Soft-warn; ignore |
| SV schema newer than addon | Soft warn; do not destructive down-migrate (track 21) |
| TOC Interface too new/old | Addon fails to load — loud, preferred over silent wire bugs |

## 7. Insight

**TOC gates the client. Proto gates the guild. Schema gates the disk. Package Version gates the human support conversation.** Staged rollout of risky BeefNet features is primarily a **proto major + Alpha channel** problem, not an SV checkbox.
