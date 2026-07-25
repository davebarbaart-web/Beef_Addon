# Officer vs member verbs

**Last updated:** 2026-07-25

## Spec authority (non-negotiable)

From design spec §6 / §10 / §11:

- Officer tab is **Officer+ only** (hidden for others).
- Approve / demote / Prophet / standing correction → officer UI + `RANK_COMMIT`.
- Non-officer forged approve → reject at validation.
- “Officer+” = roster **rank index** vs configurable threshold (not the string `"Officer"`).

Slash commands are not a second authority channel. They are shortcuts that must call the **same** `COB.Officer:LocalIsOfficer()` (plan) gate the UI uses. Plan also: never approve if roster unavailable.

## Verb classes

### Member (safe)

| Verb intent | Slash shape (proposal) | Notes |
|-------------|------------------------|-------|
| Open / toggle UI | `/beef` | Spec primary |
| Help | `/beef help` | Discovery |
| Jump Ladder tab | `/beef ladder` | Optional convenience |
| Jump My Standing | `/beef standing` | Optional |
| Thin Gora stub | `/beef gora` | Opens stub / records if implemented |
| Thin ceremony stub | `/beef ceremony …` | Officer may own start/close — see below |

### Officer+ (gated)

| Verb intent | Prefer UI? | If slash exists |
|-------------|------------|-----------------|
| Open Officer tab | Yes | `/beef officer` — deny if not Officer+ |
| Approve / reject suggestion | **UI first** | Slash optional later; confirm prompts essential |
| Manual standing correction | UI | Dangerous as chat typo surface |
| Demote / Prophet bestow | UI + confirm | Spec calls for confirm-class actions |
| Ceremony start/close | Thin stub | May be officer-only even if members mark attendance |
| Announce opt-out | Settings | Not a casual slash |

### Dev-only (never in public help)

| Verb | Gate | Notes |
|------|------|-------|
| `/beef debug standing N` | `COB.DEBUG == true` | Plan Task 8; remove or harden before release |
| Force-send forged commit tests | Debug builds | Plan Task 9 verification — not a user verb |

## Soft-deny vs hide

| Pattern | When | Chat |
|---------|------|------|
| **Hide from help** | Debug; destructive officer tools | Member `/beef help` omits them |
| **List + soft-deny** | `officer` tab jump | Members see `officer` listed as Officers only, or omitted entirely — pick one and stay consistent |
| **Silent no-op** | **Never for typed officer verbs** | Spec already rejects silent UI fails for main frame |

Blizzard guild culture trains soft-fail: `/o` without officer chat speak simply doesn’t work as members expect officer channels to be restricted ([slash command references](https://wowwiki-archive.fandom.com/wiki/Slash_commands)). Beef should say why when the player explicitly typed an officer verb.

## Help text split (recommended)

**Member help (default):**

```
Church of Beef:
  /beef              Toggle window
  /beef help         This text
  /beef ladder       Ladder tab
  /beef standing     My Standing tab
```

**Extra lines only if Officer+:**

```
  /beef officer      Officer queue
```

Do not print approve/demote syntax to members. Security theater matters less than reducing support noise (“I typed approve and nothing happened”).

## Roster timing edge

If slash runs before guild roster is ready:

- Treat as **not officer** for gated verbs (fail closed).
- Message: roster not ready — retry.
- Still allow bare `/beef` toggle (frame creation must work offline / no guild — empty-state ladder per §11).

## Cousin signal

Guild Recruiter documents GM-forced officer options and `/gr help` ([CurseForge](https://www.curseforge.com/wow/addons/guild-recruiter)). GRM concentrates power actions in `/grm` UI rather than a huge public slash grammar ([Guild Roster Manager](https://www.curseforge.com/wow/addons/guild-roster-manager)). Beef should bias the same way: **slash for navigation + stubs; commits in the Officer tab.**
