# Beef slash surface map

**Last updated:** 2026-07-25  
**Status:** Research recommendation for implementers — not a spec amendment. Spec still owns product truth; update the decisions log if this map is adopted.

## Registration (locked by plan)

| Item | Value |
|------|-------|
| `SlashCmdList` key | `CHURCHOFBEEF` |
| `SLASH_CHURCHOFBEEF1` | `/beef` |
| Handler default | Toggle `COB.UI` if present; else versioned “UI not ready” chat line |

## Proposed V1 grammar

```
/beef                      → toggle main frame (create-on-first-use)
/beef help                 → role-aware help
/beef ladder               → show frame + Ladder tab
/beef standing             → show frame + My Standing tab
/beef officer              → Officer+ : Officer tab; else soft-deny
/beef gora                 → thin Gora stub entry
/beef ceremony [start|close|…] → thin ceremony stub (gate start/close)
/beef debug …              → only if COB.DEBUG; else fall through to help
```

Anything else → help (unknown-command line + syntax).

## Mapping to V1 features

| Feature (spec) | Slash role | Primary UI |
|----------------|------------|------------|
| Ladder visibility | `ladder` / bare open | Ladder tab |
| My Standing | `standing` | My Standing tab |
| Officer queue / approve / demote / Prophet | `officer` jump only | Officer tab |
| Instance co-play scoring | None (automatic) | Standing log |
| BeefNet sync | None (automatic) | Soft warning toasts / chat if needed |
| Guild announce on promote | None (officer client on approve) | Opt-out in officer settings |
| Minimap toggle | Parallel to bare `/beef` | LibDBIcon / button |
| Toasts | Not slash-triggered | Events |

## Explicitly out of V1 slash surface

- Full options dump (`/beef profile copy …`) — AceConfig era.
- Player-name promote/demote one-liners — typo + social risk; UI confirm.
- Account-wide alt merge — open question §16.
- Classic+ flavor switches.

## Empty vs args (Ace-compatible shape without Ace)

Mirror the documented Ace pattern ([AceConfigCmd usage](https://www.wowace.com/projects/ace3/pages/api/ace-config-cmd-3-0)):

```
if input empty → Toggle UI
else → dispatch subcommand
```

Do **not** open a 200-option config on bare `/beef`.

## Error / edge copy (canonical intents)

| Code path | Message intent |
|-----------|----------------|
| Pre-UI bootstrap | `Church of Beef: UI not ready yet. (0.x.y)` |
| Unknown verb | `Unknown command. Type /beef help.` |
| Officer gate fail | `Church of Beef: Officers only.` |
| Roster unavailable | `Church of Beef: Guild roster not ready; try again.` |
| Stub not implemented | `Church of Beef: Not available yet.` |
| Debug success | `Church of Beef [debug]: …` |

## Aliases

| Alias | V1 | Rationale |
|-------|----|-----------|
| `/beef` | Yes | Brand + Tab-friendly |
| `/cob` | Optional later | Short; check collisions |
| `/churchofbeef` | No | Long; Tab-hostile |
| `/cfb` | No | Opaque |

## Success checks (slash UX only)

1. `/beef` always yields a visible frame **or** an explicit chat reason.
2. `/beef help` works with UI disabled/broken.
3. Member typing `/beef officer` cannot open officer tools or mutate ladder.
4. `COB.DEBUG` false → `/beef debug …` does not appear in help and does not mutate.
5. `/beef` still works if minimap button is hidden (future pref).

## Deferred to other tracks

| Concern | Track |
|---------|-------|
| First-open empty states, installer tone | 11 onboarding |
| BeefNet reject messaging | 14 messaging |
| Officer rank-index mechanics | 16 roster |
| Locale of help strings | 18 i18n |
| Debug QA harness | 19 testing |
