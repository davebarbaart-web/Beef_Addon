# 32 — Human-in-the-loop checkpoints (agent → playtester handoff)

**Audience:** Coding agents running hands-off Church of Beef development who must pause for a human with a TBC Classic Anniversary client.  
**Last updated:** 2026-07-26  
**Status:** Research / ops protocol for polish & V1 delivery — **not** product law. Product gates stay in the [design spec](../../superpowers/specs/2026-07-25-church-of-beef-design.md) §13 and [`docs/phases/v1-checklist.md`](../../phases/v1-checklist.md).  
**Authority stack (do not invert):**

1. `.cursor/rules/verification.mdc` + `AGENTS.md` — what “done” means; agent must-nots  
2. `.cursor/skills/church-of-beef-dev/SKILL.md` — install / reload / offline loop  
3. This doc — when to interrupt a human, what to prepare, artifact packs, smoke scripts  
4. [`docs/phases/guild-night-playtest.md`](../../phases/guild-night-playtest.md) + track [51](../wow-classic-addon-design/51-guild-night-playbook/) — full guild-night ops (larger than a checkpoint)  
5. Research scrapes / LLM self-critique — never a substitute for a green harness or client smoke  

---

## 1. Why humans are in the loop

Agents can run `lua tests/run.lua`, keep TOC honest, and reason about Lua. They **cannot** prove:

| Gap | Why offline fails |
|-----|-------------------|
| Frame load / slash / SV persist | Needs Anniversary client + `/reload` |
| Combat lockdown / taint side effects | Needs bags/character pane after Beef UI mid-trash |
| BeefNet / officer Commit | Needs **two** clients (Officer+ and Member) |
| Guild-chat spectacle | Social pass — unit tests cannot prove reaction |
| Threshold pacing (Fresh→Cooked) | Needs a real guild dungeon night |

**Doctrine:** Agents stay hands-off until an offline gate is green, then hand a **thin, complete artifact pack** to a human. Do not ping a playtester with “please try `/beef`” and a branch name alone.

---

## 2. Checkpoint types (pick one before you ask)

Ask for the **smallest** human gate that unblocks the work. Name the type in the handoff message.

| ID | Name | When | Human cost | Min clients |
|----|------|------|------------|-------------|
| **H0** | Install sanity | TOC / bootstrap / slash / first frame after UI or packaging change | ~5 min | 1 |
| **H1** | Single-client smoke | UI, SV, settings, My Standing, toasts, combat open/close | ~15 min | 1 |
| **H2** | Two-client net | BeefNet, Rank Commit, sync, forged-commit reject, officer tab visibility | ~30–45 min | 2 (Officer+ + Member) |
| **H3** | Spectacle / social | One real promote → guild-chat line + unprompted reaction | one short guild moment | 2+ in guild |
| **H4** | Guild-night field | Threshold pacing, caps, source mix, sync storm | full evening | guild + facilitators |
| **H5** | V1 walk | Entire [`v1-checklist.md`](../../phases/v1-checklist.md) dated | multi-session | 2+ |

**Mapping to verification.mdc**

| verification.mdc item | Checkpoint |
|-----------------------|------------|
| Offline `lua tests/run.lua` → 0 | Agent-only; **never** skip before H0+ when Core/Data/harness touched |
| TOC truth + Interface `20506` | Agent-only; re-check before every handoff |
| In-game UI / Net / SV / slash | H0–H1 |
| Guild/net two clients | H2 |
| Guild-chat spectacle | H3 (product) |
| Do not claim V1 complete | H5 only |

**Do not escalate** H0 bugs to a guild night. Fix install/load first.

---

## 3. Agent preflight (must be true before pinging a human)

Copy this block into the handoff. Every box is agent-owned unless marked human.

### 3.1 Offline & packaging (always)

```
- [ ] ADDON_ROOT resolved (tests/run.lua present — often .worktrees/feat-church-of-beef-v1/)
- [ ] lua tests/run.lua → exit 0  (required if Core/Data/harness changed; still preferred before UI handoffs)
- [ ] ChurchOfBeef.toc lists only existing files; load order Data → Core → Net → UI → bootstrap
- [ ] ## Interface: 20506 unless intentionally bumping (say so if bumping)
- [ ] No Retail-only APIs; no bots / injection / protected-action bypass / combat automation
- [ ] Layer rules: UI never awards points; Net never invents ranks; Core never CreateFrame
```

### 3.2 Install artifact ready

```
- [ ] Installable folder or zip: ChurchOfBeef/ at archive root (not monorepo root)
- [ ] Install command or path note for Anniversary Interface/AddOns (never invent _classic_* folder names)
- [ ] Branch / commit SHA / worktree path recorded
- [ ] Optional: rsync one-liner if WOW_ADDONS_DIR is already set on the playtester machine
```

Zip (from addon checkout):

```bash
cd "$ADDON_ROOT/addon" && zip -r ../ChurchOfBeef.zip ChurchOfBeef
```

**No packager upload / CurseForge / Wago / WoWI without human approval** (`verification.mdc`).

### 3.3 Agent self-review before human time

```
- [ ] Change summary: what shipped, what intentionally deferred
- [ ] Exact smoke script for this checkpoint (see §5) — not a vague “try the addon”
- [ ] Known risks / open questions listed (see §6) — no hiding
- [ ] Pass / fail criteria in one sentence each
- [ ] How to report back (BugSack text, screenshot, “pass H1”, dated checklist tick)
- [ ] Agents did NOT touch WTF/**/ChurchOfBeefDB.lua, force-push, wipe AddOns, or call ResetForTests outside harness
```

If any 3.1–3.3 box is false: **do not ask a human yet** — fix or document a blocker that only they can clear (e.g. `WOW_ADDONS_DIR` unknown).

---

## 4. Artifact packs (what to attach)

One pack per handoff. Prefer a short markdown note in chat **or** a dated file under the worktree (e.g. `tmp/handoff-H2-YYYYMMDD.md`) — do not commit secrets or player WTF dumps.

### 4.1 Pack skeleton

| Artifact | Required for | Contents |
|----------|--------------|----------|
| **Build ID** | All | Branch, SHA, `ADDON_ROOT`, TOC Interface |
| **Delta** | All | Bullet list of user-visible / net-visible changes |
| **Install** | All | Zip path or `rsync`/`cp` instructions; folder must be `ChurchOfBeef` |
| **Smoke script** | All | Numbered steps from §5 for the chosen Hx |
| **Expected** | All | What “pass” looks like (frames, chat lines, ranks) |
| **Risks** | All | From §6 subset that applies |
| **Harness log** | H0+ if Core/Data touched | Last line of `lua tests/run.lua` (passed / failed counts) |
| **Two-client roles** | H2+ | Which toon is Officer+, which is Member; guild name/realm if relevant |
| **Capture sheet** | H3–H4 | Metrics from guild-night checklist / track 51 |
| **Rollback** | All | How to remove or revert the install (`rsync` previous zip / disable addon) — **never** delete player SV unless human asks |

### 4.2 What never goes in a pack

- Full `ChurchOfBeefDB.lua` from a live account (privacy + accidental wipe risk)  
- Combat log / chat scrapes “for support”  
- Packager API tokens, `.firecrawl/`, research `.raw/` dumps  
- Instructions that clear ladder state outside `ChurchOfBeef._IN_TEST`  
- “Just approve everything on CurseForge”

### 4.3 Example handoff blurb (H1)

```text
Checkpoint: H1 Single-client smoke
Build: feat-church-of-beef-v1 @ <sha>
Install: ChurchOfBeef.zip → Interface/AddOns/ChurchOfBeef/
Offline: lua tests/run.lua → N passed, 0 failed
Please run smoke script H1 below with BugGrabber+BugSack and scriptErrors 1.
Pass = /beef opens Ladder + Standing; position survives /reload; no BugSack errors.
Risks: <…>
Reply: "H1 pass" or paste BugSack + which step failed.
```

---

## 5. Smoke scripts (copy into the handoff)

Human preconditions for all scripts:

1. Correct **TBC Classic Anniversary** client.  
2. Addon enabled in AddOns list as **Church of Beef**.  
3. `/console scriptErrors 1` — prefer **BugGrabber + BugSack**.  
4. Do **not** delete `WTF/**/ChurchOfBeefDB.lua` unless the handoff explicitly asks and you agree.

### H0 — Install sanity (~5 min)

```
1. Install / replace Interface/AddOns/ChurchOfBeef/
2. Full client restart if TOC metadata changed; else /reload is enough for Lua-only
3. Confirm addon listed without needing "Load out of date"
4. /console scriptErrors 1
5. /reload
6. /beef  → real frame (not chat-only stub failure)
7. Close frame; /beef again
Pass: no Lua errors; frame toggles. Fail: paste BugSack / error text.
```

### H1 — Single-client smoke (~15 min)

```
1. Complete H0
2. Fresh feel (optional alt or note "existing SV"): Ladder shows seven ranks; own title/standing visible
3. My Standing: text thresholds / next-title copy readable (no hero XP bar expected in V1)
4. Drag frame; /reload → position restored
5. Settings budget only: minimap hide/show; announce opt-out if exposed — each persists across /reload
6. Enter combat (any mob): /beef open + close; update standing text if possible
7. After combat: open bags + character pane — must work (taint check)
8. Logout/login once: ChurchOfBeefDB still sensible; no soft-lock
Pass: steps 2–8 clean. Fail: step number + BugSack.
```

### H2 — Two-client net (~30–45 min)

```
Client A = Officer+   Client B = Member   (same guild, both with addon)
1. Both: H0 + scriptErrors + BugSack
2. B: cross a suggestion threshold OR use a safe officer-visible pending path from the handoff
3. A: Officer tab visible; Member on B: Officer tab hidden
4. A: Approve (Commit) a pending suggestion
5. B (online): ladder/title updates without /reload (or after documented refresh — note which)
6. Opt-out check (A): announce off → Commit still applies; no /g line
7. Announce on (A): Commit → one guild-chat promote line from A's client
8. Forged commit (B only) — handoff must paste the exact /run from v1-checklist criterion 9;
   A and B ladders must ignore forged RANK_COMMIT
9. Sync: park C offline during a Commit; C logs in later → rank repaired without re-Approve
Pass: 4–9 hold; no soft-locks for peers. Fail: which step + both clients' BugSack.
```

### H3 — Spectacle / social (short)

```
1. Preconditions: H2 Commit path already known good
2. During live guild presence: Officer Approves one real promotion with announce ON
3. Spectacle Watcher: note whether guild chat shows the brand line AND any unprompted reaction
Pass: visible reaction (emoji, reply, voice callout). Soft-fail: line sent, silence — product concern, not necessarily a Lua bug.
```

### H4 — Guild night

Do **not** invent a parallel runbook. Point the human at:

- [`docs/phases/guild-night-playtest.md`](../../phases/guild-night-playtest.md)  
- Track [51](../wow-classic-addon-design/51-guild-night-playbook/) (roles, instrumentation, retune → `Data/Ranks.lua` only)

Agent still attaches Build ID, install zip, and known risks.

### H5 — V1 walk

Walk [`docs/phases/v1-checklist.md`](../../phases/v1-checklist.md) top to bottom; tick with `— YYYY-MM-DD, character`. Agent must not mark V1 complete.

---

## 6. Known risks (disclose in every pack)

Agents list only the rows that apply; humans treat these as watch items, not as excuses to skip smoke.

### 6.1 Always-on (Anniversary social addon)

| Risk | Symptom | Mitigation |
|------|---------|------------|
| Wrong client / AddOns tree | Missing addon or "out of date" | Confirm Anniversary; TOC `20506`; basename `ChurchOfBeef` |
| Stale install after file deletes | Ghost Lua / missing modules | Prefer `rsync -a --delete` |
| `scriptErrors` off | Silent failure | Force console + BugSack |
| Taint from EasyMenu / ShowUIPanel / Secure* | Bags/options break after Beef UI | See polish note [03](03-taint-lockdown-ux.md); fail H1 step 7 |
| Combat lockdown on protected chrome | Cannot open Blizzard panels mid-fight | Beef frames must stay insecure |
| Guild roster not ready | Officer tab missing / false negative | Wait for `GUILD_ROSTER_UPDATE`; recheck rank |
| CTL / login storms | Delayed BeefNet; chaty noise if misbuilt | H2 under load; no multi-line liturgy walls |
| Peer without addon | Must not soft-lock guildmates | H2 + no-addon observer if possible |
| SV wipe temptation | Lost standing / officer queue | Never delete WTF unless human explicitly asks |
| Threshold fiction | UI copy disagrees with ladder | Canon only in `Data/Ranks.lua` |

### 6.2 Product / ops (H3–H4)

| Risk | Symptom | Mitigation |
|------|---------|------------|
| Announce opt-out left off | No spectacle proof | Officer checkbox default ON for social check |
| Pacing wrong | Nobody hits Cooked, or half hit Knight | H4 Score Desk → retune `Ranks.lua` |
| Suggestion inbox empty while officers offline | Missed petitions | Spec V1: local + live fanout; V1.1 only if playtest proves gap |
| Dreamscythe vs Doomhowl mixed | “Desync” that is two ladders | Separate nights / expectations |
| Instance completion flaky | Bonus never fires | Spec: combat-gated drip primary; completion optional |

### 6.3 Agent process risks

| Risk | Bad pattern | Correct |
|------|-------------|---------|
| Premature ping | “Can you test?” with no zip/script | Complete §3 + §4 |
| Over-ask | Full guild night for a slash typo | Use H0/H1 |
| Under-ask | Claiming Net done after one client | H2 minimum |
| Self-grade as V1 done | Ticking human boxes from harness green | Only humans date `v1-checklist.md` |
| Policy fork | Playtest note silently changes ranks in canon prose | Spec §15 / glossary first; numbers in `Ranks.lua` |

---

## 7. After the human replies

| Result | Agent action |
|--------|----------------|
| **Pass** | Record checkpoint ID + date in PR/notes; continue next task; do not widen scope |
| **Fail (Lua/BugSack)** | Reproduce from step number; fix; re-run offline gate; new handoff with **delta since last pack** |
| **Fail (product taste)** | Do not “fix” in research-only notes — log decision in spec §15 / glossary if policy changes |
| **Soft-fail spectacle** | Treat as product pass failure; keep Commit path green; schedule H3/H4 |
| **Blocked (env)** | Ask only for the missing env fact (`WOW_ADDONS_DIR`, second account) — not a full retest |

**Feedback loop:** one checkpoint → one fix wave → one re-smoke. Avoid stacking three unrelated asks in one human session.

---

## 8. Hands-off development rhythm

```text
Agent implements
    → offline + TOC + self-review (§3)
    → choose Hx (§2)
    → ship artifact pack (§4) + smoke script (§5)
    → WAIT (no parallel speculative Net/UI until H0/H1 green for that surface)
Human returns pass/fail
    → agent fixes or advances
    → escalate H2 → H3 → H4 only when prior gate is green
H5 only when shipping V1 claim
```

Agents may keep coding **unrelated** surfaces while waiting **if** they do not invalidate the in-flight install (e.g. do not rewrite BeefNet mid-H2). When in doubt, wait.

---

## 9. Master handoff checklist (copy and tick)

```
CHECKPOINT
- [ ] Type chosen: H0 / H1 / H2 / H3 / H4 / H5
- [ ] One-sentence goal for the human
- [ ] Pass / fail criteria stated

AGENT PREFLIGHT
- [ ] ADDON_ROOT + lua tests/run.lua (as required) green
- [ ] TOC truth; Interface 20506 (or intentional bump called out)
- [ ] Safety: no automation / Retail-only / layer violations
- [ ] Install zip or rsync path ready; archive root = ChurchOfBeef/
- [ ] Branch + SHA recorded
- [ ] No WTF wipe / no packager upload / no ResetForTests outside harness

ARTIFACT PACK
- [ ] Delta (user-visible)
- [ ] Smoke script pasted (matching Hx)
- [ ] Expected results
- [ ] Known risks (applicable rows from §6)
- [ ] Rollback note
- [ ] H2+: Officer+ / Member roles named
- [ ] H3–H4: link guild-night + capture expectations
- [ ] H5: point at v1-checklist.md (human dates ticks)

HUMAN ASK (message)
- [ ] Client Anniversary + BugSack + scriptErrors called out
- [ ] Time estimate honest
- [ ] Reply format specified ("H1 pass" / step+BugSack)

POST
- [ ] Result filed; next agent step unblocked or re-handoff queued
```

---

## 10. Where to deepen (do not duplicate)

| Need | Path |
|------|------|
| Done / safety must-nots | [`.cursor/rules/verification.mdc`](../../../.cursor/rules/verification.mdc), [`AGENTS.md`](../../../AGENTS.md) |
| Install / reload / zip | [`.cursor/skills/church-of-beef-dev/SKILL.md`](../../../.cursor/skills/church-of-beef-dev/SKILL.md) |
| V1 dated success criteria | [`docs/phases/v1-checklist.md`](../../phases/v1-checklist.md) |
| Guild-night ops | [`docs/phases/guild-night-playtest.md`](../../phases/guild-night-playtest.md), [track 51](../wow-classic-addon-design/51-guild-night-playbook/) |
| Taint / combat smoke extras | [03-taint-lockdown-ux.md](03-taint-lockdown-ux.md) |
| SV / settings persistence | [08-savedvars-settings-ux.md](08-savedvars-settings-ux.md) |
| UI polish bans | [`docs/superpowers/ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) |
| Tooling backlog (needs approval) | [`OPTIMIZATIONS.md`](../../../OPTIMIZATIONS.md) |

---

## 11. One-line doctrine

*Green harness unlocks a human ask; a complete artifact pack + Hx smoke script respects their time; only a dated v1-checklist walk claims V1.*
