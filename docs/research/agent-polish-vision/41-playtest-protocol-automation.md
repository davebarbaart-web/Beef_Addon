# 41 — Playtest protocol automation (agent-runnable)

**Audience:** coding agents prepping or running Church of Beef verification after Core/UI/Net/SV changes.  
**Last updated:** 2026-07-26  
**Status:** Research synthesis for polish / QA ops — **not** product law. Locked success criteria stay in the [design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md) §13 and the walkable [V1 checklist](../../phases/v1-checklist.md). Guild-night product capture stays in [guild-night-playtest.md](../../phases/guild-night-playtest.md).  
**Ops authority:** [church-of-beef-dev skill](../../../.cursor/skills/church-of-beef-dev/SKILL.md), [verification.mdc](../../../.cursor/rules/verification.mdc), [testing.mdc](../../../.cursor/rules/testing.mdc).

---

## 1. Executive rules (read first)

1. **Green harness ≠ V1 done.** Offline `lua tests/run.lua` exit `0` is required for Core/Data/harness changes; it never proves UI, BeefNet, or spectacle.
2. **Agents prep; humans (or two live clients) prove social.** Agents may resolve checkout, run harness, install, and emit a filled smoke matrix for a human to walk. Agents must not claim checklist §13.7–§13.11 / social check without dated client evidence.
3. **Never invent automation that fights ToS or safety rules.** No bots, injection, protected-action bypass, combat automation, external process control of the client, or scraping chat/combat logs for “support dumps.”
4. **Never touch player WTF** (`WTF/**/ChurchOfBeefDB.lua`) unless the user explicitly asks. Prefer fresh chars / alt SV for destructive ladder experiments.
5. **`ResetForTests` / ladder wipes stay in the harness** (`ChurchOfBeef._IN_TEST` only). Production clients are not a unit-test fixture.
6. **Two clients minimum** for BeefNet / officer / sync / forge-reject paths: Officer+ and Member, same guild, both on Anniversary `20506`.
7. **Spectacle is a subjective product pass.** Unit tests cannot score guild-chat reaction. Use the rubric in §7; tick V1 checklist #11 only after a real guild night.
8. **Research does not fork policy.** If playtest contradicts a locked decision, update the design-spec decisions log (and glossary) first — do not silently amend thresholds in this file.

### Agent capability matrix (what “run” means)

| Layer | Agent can run alone? | Agent can prep? | Needs live client(s)? |
|-------|----------------------|-----------------|------------------------|
| A. Offline Lua harness | **Yes** | Yes | No |
| B. TOC / tree truth | **Yes** (offline checks) | Yes | No |
| C. Install scripts | **Yes** (filesystem) | Yes | No (client must exist on disk) |
| D. In-game smoke (officer / member) | No (cannot drive WoW UI) | **Yes** — print matrix + install | **Yes** (1+ clients) |
| E. Two-client guild net | No | **Yes** — roles, `/run` forge snippet, expected outcomes | **Yes** (2 clients) |
| F. Spectacle subjective scoring | No | **Yes** — scorecard + watcher roles | **Yes** (guild night) |

---

## 2. Protocol stack (order of operations)

Always climb the stack; do not skip downward when the change type requires a higher rung.

```
A Offline harness  →  B TOC truth  →  C Install
        →  D Smoke matrix (role-split)
        →  E Two-client net (if Net/officer/sync)
        →  F Spectacle scorecard (if announce / promote path)
        →  V1 checklist tick (human-dated)
```

### Change → minimum rung

| Change touches | Min rung | Notes |
|----------------|----------|-------|
| `Data/**`, `Core/**`, `tests/**` | A (+ B) | Exit `0` required |
| TOC only / new Lua file | B (+ A if Core/Data) | Never list missing files; Interface `20506` |
| UI / slash / SV / minimap | C → D | Both roles if Officer tab involved |
| `Net/**`, officer Commit, Sync | C → E | Two clients; forge-reject is mandatory |
| Guild-chat announce / promote copy | C → F | Subjective; cannot auto-pass |
| “V1 complete” claim | Full stack + [v1-checklist.md](../../phases/v1-checklist.md) | Agents must refuse incomplete claims |

---

## 3. Layer A — Offline Lua harness (agent-runnable)

### Resolve `ADDON_ROOT`

Same as the skill (do not invent a third layout):

```bash
# From Beef_Addon workspace root
test -f tests/run.lua && ADDON_ROOT="$PWD"
test -z "${ADDON_ROOT:-}" && test -f .worktrees/feat-church-of-beef-v1/tests/run.lua \
  && ADDON_ROOT="$PWD/.worktrees/feat-church-of-beef-v1"
```

Or: `./scripts/run-tests.sh` (resolves worktree; may exit `0` with skip on docs-only `main` unless `REQUIRE_TESTS=1`).

### Run

```bash
cd "$ADDON_ROOT"
lua -v                 # 5.1 preferred; 5.4 OK for pure logic
lua tests/run.lua      # healthy: "Tests finished: N passed, 0 failed"
```

### Pass / fail matrix

| Check | Pass | Fail / stop |
|-------|------|-------------|
| Checkout found | `tests/run.lua` present | Tell user worktree/checkout missing |
| Lua on PATH | `lua -v` works | Install Lua 5.1 (or 5.4 for pure Core) |
| Suite result | `0 failed` | Fix code/tests; do not skip |
| Suites listed but skipped | Module not landed yet | OK until that task exists |
| `ResetForTests` in production path | Refused without `_IN_TEST` | Fix gate; never call outside harness |

### Agent report template (copy into PR / chat)

```
Harness: PASS|FAIL
Checkout: <ADDON_ROOT>
Lua: <version>
Result: <N passed, M failed>
Suites skipped (expected): <list or none>
```

---

## 4. Layer B — TOC / tree truth (agent-runnable)

| Check | How | Pass |
|-------|-----|------|
| TOC files exist | Every `ChurchOfBeef.toc` path resolves under `addon/ChurchOfBeef/` | No missing entries |
| No orphans (soft) | Every ship Lua under addon tree is listed (except intentional) | Document intentional omissions |
| Load order | `Data → Core → Net → UI → bootstrap`; MainFrame before tab registrars | Matches architecture |
| Interface | `## Interface: 20506` | Unchanged unless intentional bump |
| Safety skim | Grep for Retail-only / automation red flags in touched files | None introduced |

Agents may automate the filesystem checks; “no Retail APIs” is a best-effort static skim plus in-game BugSack (Layer D).

---

## 5. Layer C — Install scripts (agent-runnable prep)

### Preferred commands

From workspace root (skill + scripts):

```bash
# 1) Tests first when Core/Data/harness changed
./scripts/run-tests.sh
# or REQUIRE_TESTS=1 ./scripts/run-tests.sh   # fail if checkout missing

# 2) Install — set destination once per machine
export WOW_ADDONS_DIR="/path/to/.../Interface/AddOns/ChurchOfBeef"
# Script default may be a local Anniversary path; never commit usernames/secrets.
./scripts/install-anniversary.sh
```

Skill-equivalent when installing from a **worktree** checkout (note: `install-anniversary.sh` currently sources `$ROOT/addon/ChurchOfBeef` on the workspace root — if that tree is empty on `main`, agents must rsync from `ADDON_ROOT`):

```bash
test -n "${WOW_ADDONS_DIR:-}" || { echo "Set WOW_ADDONS_DIR"; exit 1; }
# If WOW_ADDONS_DIR points at .../AddOns (not ChurchOfBeef), append the folder:
# DST="$WOW_ADDONS_DIR/ChurchOfBeef"
rsync -a --delete "$ADDON_ROOT/addon/ChurchOfBeef/" "${WOW_ADDONS_DIR%/}/"
# Folder basename MUST be ChurchOfBeef (matches .toc)
```

Optional hand-out zip (no packager upload without approval):

```bash
cd "$ADDON_ROOT/addon" && zip -r ../ChurchOfBeef.zip ChurchOfBeef
```

### Install pass / fail matrix

| Symptom | Likely cause | Agent action |
|---------|--------------|--------------|
| `WOW_ADDONS_DIR` unset / wrong | Env not configured | Ask user for Anniversary `Interface/AddOns` (or full `.../ChurchOfBeef`) path |
| Missing `ChurchOfBeef.toc` at SRC | Docs-only main / wrong ADDON_ROOT | Resolve worktree; re-install from there |
| Addon missing in client | Wrong client tree / wrong folder name | Confirm Anniversary AddOns; basename `ChurchOfBeef` |
| Stale deleted files | `cp` without replace | Prefer `rsync -a --delete` |
| “Out of date” toggle needed | Interface mismatch | Fix TOC `20506` vs build — do not paper over |

### Hard don’ts

- Do not wipe `Interface/AddOns` or the WoW install.
- Do not packager-upload / publish CurseForge / Wago / WoWI without approval.
- Do not delete player SavedVariables as part of install.

---

## 6. Layer D — In-game smoke matrices (agent-prep, human/client execute)

### Shared pre-flight (both roles)

Agents print this block after a successful install; a human (or the user at the keyboard) executes.

```
Pre-flight
- [ ] Correct client: TBC Classic Anniversary (Interface ~20506)
- [ ] Church of Beef enabled in AddOns list
- [ ] BugGrabber + BugSack installed (preferred)
- [ ] /console scriptErrors 1
- [ ] /reload → no load errors in BugSack
- [ ] /beef opens a real frame (not chat-only)
- [ ] Do NOT delete WTF/**/ChurchOfBeefDB.lua unless user asked
```

### Matrix D1 — Member client smoke

| # | Action | Expect | Pass? |
|---|--------|--------|-------|
| M1 | `/beef` out of combat | Main frame opens; movable; close works | |
| M2 | Ladder tab | Seven ranks visible; local title/standing match `Data/Ranks.lua` canon | |
| M3 | My Standing | Threshold copy coherent (next title or appointed-only) | |
| M4 | Officer tab | **Hidden** (not Officer+) | |
| M5 | Attempt approve if somehow reachable | No-op; ladder unchanged | |
| M6 | Minimap button | Show/hide persists across `/reload` if settings touched | |
| M7 | Frame position | Survives `/reload` | |
| M8 | Not-in-guild (optional alt) | Empty ladder, scoring paused, no BeefNet sends, no errors | |
| M9 | Combat open `/beef` | Frame still usable; bags/character pane untainted after | |
| M10 | BugSack | Clean through session | |

### Matrix D2 — Officer+ client smoke

| # | Action | Expect | Pass? |
|---|--------|--------|-------|
| O1 | Wait `GUILD_ROSTER_UPDATE` | Officer tab **visible** | |
| O2 | Officer tab controls | Pending queue, approve/reject, announce checkbox present (if Commit announcer ships) | |
| O3 | Announce checkbox | Label procedural (“Announce promotions to guild chat”); mirrors `ChurchOfBeefDB.ui.announce`; **default ON** | |
| O4 | Seed / find a suggestion | Threshold cross → suggestion; never auto-promote; Council/Prophet not suggestion targets | |
| O5 | Approve (Commit path) | Local rank updates; toast if implemented | |
| O6 | Announce ON | One throttled guild-chat line from **this** officer client only | |
| O7 | Announce OFF | Commit still applies; **no** guild line | |
| O8 | Standing correction (if shipped) | Points change; Church title not invented by UI | |
| O9 | Combat during approve | Commit authority not dropped; chrome may defer; no taint of Blizzard bags after | |
| O10 | BugSack | Clean through session | |

### Role assignment cheat-sheet

| Role | WoW guild `rankIndex` | Addon expectation |
|------|------------------------|-------------------|
| Officer+ | `≤` configured threshold (GM = `0`) | Officer tab + Commit send |
| Member | Below threshold | Tab hidden; forge Commit ignored by peers |

---

## 7. Layer E — Two-client guild net tests (agent-prep)

**Setup:** Client A = Officer+, Client B = Member (same guild, both online, both addon-enabled unless noted). Prefer BugSack on both.

### Matrix E — BeefNet / Sync

| # | Scenario | Steps | Expect A | Expect B | Pass? |
|---|----------|-------|----------|----------|-------|
| N1 | Live Commit | A approves suggestion for target T | Local ladder shows new rank; optional guild announce | Ladder/title for T updates without `/reload` | |
| N2 | Login sync (stale) | Promote T while B offline; B logs in | — | After login sync, T matches officer ladder; no officer redo | |
| N3 | Forge reject | On **B** (member), run forge send (below) | Ladder unchanged | Peers ignore; **no** apply | |
| N4 | Revision / replay | Re-send older or equal revision Commit | Ignore | Ignore | |
| N5 | Mixed peers | Member without addon online during promote | Announce (if ON) still visible in `/g` | n/a | |
| N6 | Duplicate announce | Two officers race | Only approving officer’s client sends; no double spam | — | |
| N7 | Net errors | Soft failure / throttle | No soft-lock; BugSack clean | No soft-lock | |

**Forge send (checklist #9 — public path only; no debug slash):**

```
/run local N=ChurchOfBeef.Net N:Send(N:Encode("RANK_COMMIT","Someguildie",5,9999,999,0,UnitName("player")))
```

Replace `"Someguildie"` with a real guild name under test. Pass = peers ignore; ladders unchanged.

### Agent prep output (fill before handing to humans)

```
Net playtest card
Guild: <name>
Realm: <realm>
Client A (Officer+): <char> rankIndex=<n>
Client B (Member):   <char> rankIndex=<n>
Build / TOC: 20506
Addon rev / commit: <sha>
Announce default: ON
Harness: PASS @ <timestamp>
Install: <WOW_ADDONS_DIR>
```

---

## 8. Layer F — Spectacle subjective scoring

Unit tests and BugSack **cannot** pass V1 social check (spec §13.11). Agents prepare the scorecard; a **Spectacle Watcher** (human) scores during a real guild night. See also [guild-night-playtest.md](../../phases/guild-night-playtest.md) and research track `51-guild-night-playbook`.

### When this layer applies

| Product state | Spectacle protocol |
|---------------|--------------------|
| Commit + guild-chat announcer ships (design spec V1) | Full scorecard below; checklist #11 is in scope |
| Roster-backed amendment defers Commit announcer | Mark announce rows **N/A**; still score toast / queue visibility; do not fake a guild-chat pass |

### Scorecard (1–5 per axis; integer only)

| Axis | 1 | 3 | 5 | Score |
|------|---|---|---|-------|
| S1 Visibility | Nobody noticed the promote | Some officers noticed in UI only | Clear `/g` line seen by members **without** the addon | |
| S2 Comprehension | Line unread / confusing | Understood as a rank change | Felt like Church recognition (tone OK, not cringe spam) | |
| S3 Reaction | Silence | One emoji / short ack | Unprompted guild reaction (chat hype, congratulate, meme) | |
| S4 Stream / night fit | Interruptive noise | Neutral | Fits ceremony pacing; not drowning raid calls | |
| S5 Opt-out trust | Announce OFF still spammed / Commit blocked | Unclear | OFF silences chat only; Commit still works | |
| S6 Spam control | Multi-line / multi-officer flood | Occasional dupe | Single throttled line per promote | |

**Aggregate**

| Band | Rule | V1 social check |
|------|------|-----------------|
| Fail | Any of S1–S3 ≤ 2, or S5 ≤ 2 | Do **not** tick checklist #11 |
| Weak pass | All axes ≥ 3; S3 = 3 | Tick only with Night Lead note (“weak”) |
| Pass | Mean ≥ 3.5 and S3 ≥ 4 | Tick checklist #11 with date + characters |
| Spectacle debt | S4 ≤ 2 or S6 ≤ 2 despite pass | File polish bug; do not block mechanical V1 if Lead accepts |

### Watcher capture (no log scraping by agents)

```
Spectacle Watcher log (human-written)
Promote target: <name> → <title>
Officer announcer: <name>
Announce SV: ON|OFF
Guild line (quote once): "..."
Unprompted reactions (count / paraphrase): 
Stream note (optional): 
Scores: S1__ S2__ S3__ S4__ S5__ S6__  Band: Fail|Weak|Pass
```

Agents may remind the watcher to paste this block; agents must not scrape the client chat log to fill it.

---

## 9. End-to-end agent runbook (copy/paste)

```bash
# --- Agent-automated ---
cd /Volumes/AI_Design_Drive/Beef_Addon
./scripts/run-tests.sh          # or REQUIRE_TESTS=1 when addon expected
# TOC truth: list toc paths vs filesystem (manual or small script; no missing files)
export WOW_ADDONS_DIR="…/Interface/AddOns/ChurchOfBeef"
# If addon only in worktree:
ADDON_ROOT=".worktrees/feat-church-of-beef-v1"
rsync -a --delete "$ADDON_ROOT/addon/ChurchOfBeef/" "$WOW_ADDONS_DIR/"
# else: ./scripts/install-anniversary.sh

# --- Agent emits; human executes ---
# Print matrices D1/D2 (and E/F if Net/announce).
# Hand user: pre-flight + role cards + forge /run + spectacle scorecard.

# --- Agent must not ---
# Drive the WoW client, delete WTF, claim V1 complete, upload packager builds,
# scrape chat logs, or call ResetForTests outside tests/.
```

### Definition of done (per change)

| Claim | Required evidence |
|-------|-------------------|
| “Harness green” | `lua tests/run.lua` → `0 failed` |
| “Installed” | rsync/script success + path echoed |
| “Smoke OK” | Filled D1 and/or D2 with Pass column + character names |
| “Net OK” | Filled E matrix N1–N3 minimum |
| “Spectacle OK” | Scorecard band Pass/Weak + quote |
| “V1 complete” | Entire [v1-checklist.md](../../phases/v1-checklist.md) dated — **refuse** otherwise |

---

## 10. Failure triage (quick)

| Layer | Symptom | First fix |
|-------|---------|-----------|
| A | `cannot open tests/run.lua` | Re-resolve ADDON_ROOT / worktree |
| A | Non-zero exit | Fix Core/Data/tests; re-run |
| C | Addon not listed | Wrong AddOns dir / TOC Interface |
| D | `/beef` unknown | TOC load order / bootstrap error → BugSack |
| D | Officer tab missing | Not Officer+ or roster not ready |
| E | B never updates | Prefix/channel, online status, revision, officer gate |
| E | Forge applies | **Security bug** — stop ship; fix Net accept path |
| F | No guild reaction | Copy/pacing/opt-out — product pass, not harness |

---

## 11. Related paths (do not duplicate)

| Need | Path |
|------|------|
| Install / reload loop | `.cursor/skills/church-of-beef-dev/SKILL.md` |
| Done / safety | `.cursor/rules/verification.mdc` |
| Harness extension | `.cursor/rules/testing.mdc` |
| Walkable V1 boxes | `docs/phases/v1-checklist.md` |
| Guild-night product capture | `docs/phases/guild-night-playtest.md` |
| Taint / combat smoke | `docs/research/agent-polish-vision/03-taint-lockdown-ux.md` |
| SV / announce defaults | `docs/research/agent-polish-vision/08-savedvars-settings-ux.md` |
| Tooling backlog (hooks, make install) | `OPTIMIZATIONS.md` (needs human approval) |

---

## 12. One-line doctrine

*Agents own the offline green bar and a clean install; humans own the two-client wire and the guild-chat cheer — and no amount of Lua asserts can substitute for spectacle.*
