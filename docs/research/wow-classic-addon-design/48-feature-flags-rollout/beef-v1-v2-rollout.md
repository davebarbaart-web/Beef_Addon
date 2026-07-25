# Church of Beef — V1→V2 staged rollout patterns

**Track:** [48 README](README.md)  
**Product sources:** Spec §10, §13–§14, §16; plan Tasks 5 / 8 / 9 / harden-debug note.

## 1. What V1 already is (the safe spine)

Ship and harden first — these are **not** behind experimental flags:

| Surface | Gate |
|---------|------|
| Ladder + My Standing | Always on for guild members |
| Thin Gora / ceremony stubs | Always on (score fuel) |
| Suggestions | Member emit; officer consume |
| Officer tab + commits | Officer+ role gate + receiver validate |
| Guild-chat promotion line | Officer+ + `ui.announce` opt-out |
| BeefNet HELLO / SYNC / RANK_COMMIT | Proto major soft-warn |
| Per-character `ChurchOfBeefDB` | Schema migrations (track 21) |

Success criterion §13.11 still applies: spectacle must be felt. Opt-out is for officers drowning in noise, not for “hide the product.”

## 2. What V2 adds (spec §14)

| V2 theme | Risk class | Recommended gate stack |
|----------|------------|------------------------|
| Ceremonial dashboard spectacle | UI noise / taint-adjacent frame complexity | SV `ui.features.ceremonialDashboard` default **off**; Alpha first |
| Confessions feed | Chat/UX spam; storage growth | SV default off; officer-only compose if applicable |
| Richer scripture | Copy/brand only | Can ship on; low risk |
| Stream contrast pass | Visual/readability; may need longer toasts | SV or streamer profile later; see track 17 |

V3/V4 (full Gora theater, Classic+ port) stay out of this track’s rollout table except as “do not premature-flag into V1.”

## 3. Phased playbook

### Phase A — V1 private guild (manual zip)

1. Officers install manually; members optional.
2. `COB.DEBUG` / debug slash **only on author machines**; strip before any wide zip.
3. Validate: member suggest → officer approve → peer sees commit → offline login sync (spec §13).
4. No V2 UI flags required yet — code can exist as no-op stubs.

### Phase B — V1 “guild live”

1. Release (or labeled stable zip) to full Dreamscythe / Doomhowl cohorts.
2. Freeze BeefNet major unless a critical fix needs a bump.
3. Threshold tuning (§16.6) via canon data / officer config — not random SV experiments on members.

### Phase C — V2 Alpha (officers + volunteers)

1. Cut Alpha builds (CurseForge tag `*-alpha*` or Discord zip).
2. Enable V2 surfaces for Alpha cohort via SV defaults **in Alpha only** *or* document `/beef features on dashboard` for testers.
3. If BeefNet grows new message types: **bump proto major**; Release clients soft-warn and ignore.
4. Keep ladder commit path identical unless the change is the point of the Alpha.

### Phase D — V2 Beta → Release

1. Beta when feature-complete; polish bugs OK.
2. Release: V2 flags default **on** only after one clean guild night; or remove flag and make V2 unconditional.
3. Changelog names the proto major if bumped.

## 4. Open questions → flag strategy (§16)

| Open question | Rollout stance |
|---------------|----------------|
| Alt linking | Keep off; future flag must not move ladder into account SV casually (track 21) |
| Council seat count | Canon/officer config — not a member feature flag |
| Standing decay / Lent reset | Officer-gated season action; Alpha the UX first |
| Instance completion flaky | Prefer scoring heuristic flag / fallback to time buckets; don’t block V1 |
| Suggestion queue login sync | Additive BeefNet; prefer same major if backward compatible |

## 5. Explicit do / don’t for Beef authors

**Do**

- Layer gates: role → proto → channel → SV (see [gate-layers](gate-layers.md))
- Default-off V2 chrome in Release until proven
- Soft-warn on HELLO mismatch; never soft-lock non-addon players
- Strip debug with `@do-not-package@` when packaging exists
- Hide Officer tab; still validate every commit

**Don’t**

- Put `RANK_COMMIT` behind `ui.features.experimental`
- Ship dual addons (`ChurchOfBeef` + `ChurchOfBeefV2`) for chrome
- Use schema bumps as feature toggles
- Assume WowUp Alpha users stay on Alpha forever ([WowUp channels](https://wowup.io/guide/my-addons/addons))
- Enable verbose sync logging in Release “just in case”

## 6. Minimal flag vocabulary (design-only)

Suggested names for later implementation plans (not code):

| Key | Default Release | Default Alpha | Meaning |
|-----|-----------------|---------------|---------|
| `ui.announce` | true | true | Officer spectacle opt-out target |
| `ui.features.ceremonialDashboard` | false | true | V2 dashboard |
| `ui.features.confessionsFeed` | false | true | V2 confessions |
| `ui.features.streamContrast` | false | true | V2 stream pass |
| `meta.protoMajor` | `1` | `1` or `2` | Mirror of wire major for UI warn copy |
| `COB.DEBUG` (memory) | false | author-only | Dev slash; not SV |

## 7. Insight

V1 already encodes the hard gates (officer + proto + announce opt-out). V2 rollout should **add soft SV flags and Alpha cohorts**, not invent a second authority model. The church stays officer-led; flags only control how loud and how theatrical the congregation’s client becomes.
