# 26 — Visual QA screenshot protocol (Cursor agents + CoB)

**Track:** `agent-polish-vision`  
**Date:** 2026-07-26  
**Audience:** Coding agents (and humans feeding them captures) doing Church of Beef UI polish  
**Status:** Research guidance — not product law. Spec §10 / §15, glossary 74–81, and `ui-polished-direction-for-agents.md` win on conflict.

---

## 1. Why this exists

Desktop Lua harnesses prove Core/Data. They do **not** prove:

- Opaque panels vs glass bleed through world geometry  
- Truncated rank titles at Classic auto-scale  
- Toast vs minimap / chat collision  
- Officer dual-encode (color + text)  
- Template-native chrome looking “churchy” vs ElvUI-flat  

Cursor agents with vision can **Read** image files (`.png`, `.jpg`, `.gif`, `.webp`) and critique pixels. They cannot drive the WoW client. Visual QA for CoB is therefore a **human (or script) capture → agent Read → structured critique** loop.

This is the Anniversary-facing counterpart to web “browser screenshot” visual QA: same judgment loop, different capture surface.

---

## 2. Authority & truth stack

| Layer | Role in visual QA |
|-------|-------------------|
| Spec §10 / §15 + glossary 68–71, 74–81 | Pass/fail product rules |
| `ui-polished-direction-for-agents.md` | Agent bans + V1 chrome doctrine |
| Capture + agent Read | Evidence of what the client actually drew |
| This doc | How to capture, name, and critique without lying |

**Hard rule:** A confident vision critique that contradicts locked product law is a failed critique, not a new design. Log product changes in the spec decisions log — do not fork UI religion from a screenshot comment.

**Hard rule:** Research hex / brand accents are **not law** until an Anniversary screenshot lock (glossary 78, 81). V1 expects template-native Blizzard chrome + GameFont.

---

## 3. Agent capability model (Cursor)

| Can | Cannot |
|-----|--------|
| `Read` PNGs/JPEGs/WebP and describe layout, contrast, truncation, collisions | Launch or control WoW Anniversary |
| Compare before/after pairs in one turn when both paths are provided | Guarantee sub-pixel measurement or exact hex from a JPEG |
| Apply a CoB rubric (below) to named surfaces | Prove BeefNet / sync / officer gate from pixels alone |
| Flag likely Lua/layout bugs for follow-up code edits | Replace `/console scriptErrors 1` + BugSack for Lua errors |

**Implication:** Agents must be given **file paths** (or attached images) plus a **shot ID** and **intent**. Vague “does it look good?” yields vague theater.

---

## 4. Protocol steps (copyable)

### Step 0 — Preconditions

1. Resolve `ADDON_ROOT`; install `addon/ChurchOfBeef` → `Interface/AddOns/ChurchOfBeef` (skill).  
2. Client: TBC Classic Anniversary (`Interface: 20506`).  
3. `/console scriptErrors 1` (prefer BugGrabber + BugSack).  
4. Note capture context in the shot metadata (see §6): resolution, `uiScale` profile, role (Officer+ / Member), guild loaded yes/no.

### Step 1 — Define the claim

Write one sentence before capture:

> “After this change, **[surface]** should **[observable]** without **[banned pattern]**.”

Example: “My Standing shows standing + next title as text only; no StatusBar hero meter.”

### Step 2 — Capture matrix (minimum)

Capture the **smallest set** that proves the claim. Prefer the CoB shot catalog (§5). For any UI CreateFrame change that ships:

| Priority | Shots |
|----------|--------|
| P0 | Full `/beef` main frame (active tab) + one “closed UI, world visible” for chrome opacity |
| P0 | Empty / gated state relevant to the change (no guild, not Officer+, empty queue) |
| P1 | Toast or chat spectacle if the change touches announce/toast |
| P1 | Second scale profile if layout/spacing changed (Classic default @1440p **or** pixel-perfect `768/h`) |
| P2 | Stream-safe check: toast + guild line with busy edges (optional downscale note) |

### Step 3 — Capture hygiene (WoW)

1. **Hide noise** when possible: other addon panels, WA combat packs, Details! — unless the shot’s purpose is coexistence.  
2. **Keep one busy edge** for toast/minimap shots (realistic collision).  
3. Prefer **PNG** (lossless) for UI; avoid heavy JPEG for text-critical critique.  
4. Prefer **Print Screen / client screenshot** at native resolution over phone photos of the monitor.  
5. Do **not** crop away the problem: if truncation is suspected, include the full control + padding.  
6. For before/after: same resolution, same `uiScale`, same character role, same tab, same fixture data when possible.  
7. Never paste secrets or dump `WTF/**/ChurchOfBeefDB.lua` into the shot folder “for context.”

### Step 4 — Name & store

Use the naming scheme in §6. Drop files under a **gitignored or local** capture folder unless the human explicitly wants baselines in-repo:

Suggested local layout (not required on `main`):

```text
.captures/cob-visual-qa/
  YYYY-MM-DD/<slug>/
    meta.md
    before_*.png
    after_*.png
```

`meta.md` repeats the claim, client build note, and shot list.

### Step 5 — Agent Read

In the agent turn:

1. Give absolute paths to each image.  
2. State which is before vs after (or baseline vs candidate).  
3. Paste the claim + the checklist IDs from §7 that apply.  
4. Instruct: “Read the images; do not invent UI that is not visible; mark Uncertain when text is illegible.”

### Step 6 — Structured critique (agent output)

Agents return a fixed shape (§8). No free-form “vibes only.”

### Step 7 — Act

| Verdict | Next |
|---------|------|
| Fail (product rule) | Fix Lua / layout; recapture after |
| Fail (capture quality) | Recapture; do not “fix” code for a bad crop |
| Uncertain (vision limit) | Human re-check in-client; optionally crop/zoom the disputed control |
| Pass | Note shot IDs in the PR / task checklist; do not claim V1 complete from screenshots alone |

### Step 8 — Stop conditions

- Lua errors in BugSack → fix before more polish shots.  
- Vision model invents defects that contradict intentional Classic template chrome → discard, re-anchor on glossary.  
- More than two Uncertain rounds on the same pixel claim → human visual sign-off.

---

## 5. CoB shot catalog (what to capture)

IDs are stable labels for naming and critique. Surfaces follow design spec §10.

| Shot ID | Surface | Must show | Fail if |
|---------|---------|-----------|---------|
| `S-MAIN-LADDER` | Ladder tab | Seven ranks / occupants or empty ranks; local highlight readable | Details!-dense wall; item-quality rainbow ranks; glass panel |
| `S-MAIN-STANDING` | My Standing | Points + next threshold **as text**; recent events if present | Hero StatusBar / HP-castbar progress; missing threshold copy |
| `S-MAIN-OFFICER` | Officer tab (Officer+) | Queue / actions; announce checkbox label readable | Approve path looks like member UI; color-only state with no text |
| `S-MAIN-MEMBER` | Member `/beef` | No Officer tab | Officer chrome leaked |
| `S-EMPTY-NOGUILD` | Not in guild | Empty-state ladder copy; no crash chrome | Blank frame / missing frame |
| `S-EMPTY-QUEUE` | Officer, empty queue | Empty-state IA (not a dead panel) | Placeholder “?” read as broken data |
| `S-TOAST-PROMOTE` | Private toast | Edge toast; readable name + title | Center-screen WA pulse; unreadable at default scale |
| `S-CHAT-PROMOTE` | Guild chat | One throttled recognition line | Duplicate spam; meme-only line that fails without addon |
| `S-MINIMAP` | LibDBIcon / button | Button present; toggle works (pair with open/closed) | Orphan icon; overlaps toast unreadably |
| `S-CHROME-OPACITY` | Main frame over busy world | Opaque high-contrast panel | World text bleeding through |
| `S-SCALE-STRESS` | Same tab @ second scale | Same claim holds | Truncation / overlap only on one profile |
| `S-COEXIST-ELV` | Optional | CoB + ElvUI: CoB still Classic-native | CoB “became” ElvUI-flat brand |
| `S-STREAM-EDGE` | Optional | Toast + safe-edge awareness | Must-read toast buried under webcam/alerts (note stream layout) |

**Two-client note:** Officer queue + member visibility are behavioral; capture both roles when the claim is authority/IA, not only “pretty pixels.”

---

## 6. Naming convention

```text
cob_<shotId>_<phase>_<role>_<WxH>_<scaleTag>_<YYYYMMDD>[_n].png
```

| Token | Values |
|-------|--------|
| `shotId` | From §5, lowercase with hyphens stripped or kept: `s-main-ladder` |
| `phase` | `before` \| `after` \| `baseline` \| `candidate` |
| `role` | `officer` \| `member` \| `noguild` |
| `WxH` | e.g. `2560x1440` |
| `scaleTag` | `classic` (stock auto-scale) \| `pp` (pixel-perfect `768/h`) \| `other` |
| `YYYYMMDD` | Capture date |
| `_n` | Optional sequence when multiple takes same day |

Examples:

```text
cob_s-main-standing_before_member_2560x1440_classic_20260726.png
cob_s-toast-promote_after_officer_1920x1080_classic_20260726.png
cob_s-scale-stress_candidate_member_2560x1440_pp_20260726.png
```

**meta.md fields (recommended):**

```markdown
claim: ...
addon_rev: <git sha or WIP branch>
interface: 20506
shots: [list of filenames]
fixtures: e.g. standing=120 next=Cooked; queue empty
notes: ElvUI off; BugSack clean
```

---

## 7. Before / after critique rubric (CoB)

Agents score each applicable row: **Pass / Fail / Uncertain / N/A**.

### 7.1 Product locks (hard fails)

| ID | Check |
|----|--------|
| R1 | Classic FrameXML shell — not retail glass, not ElvUI-flat-as-brand |
| R2 | Opaque high-contrast panels (see `S-CHROME-OPACITY`) |
| R3 | GameFont* family readable; no custom Media required for V1 |
| R4 | Class color on **names** only — not rainbow ranks |
| R5 | Pending / approve / reject **dual-encoded** (color + text/icon) |
| R6 | Standing = **text thresholds** only (no hero StatusBar) |
| R7 | Spectacle = edge toast + optional `/g` line — **no** center WA pulse |
| R8 | Settings budget visible only as locked: position, minimap hide, announce |
| R9 | Officer tab absent for non-officers |
| R10 | No tip jars / donation CTAs / SecureActionButton-to-open-panel smell |

### 7.2 Layout & craft (soft fails → fix before ship)

| ID | Check |
|----|--------|
| L1 | No clipped tab labels, button captions, or rank titles at claimed scale |
| L2 | Local player highlight findable in ≤2 seconds of glance |
| L3 | Toast does not fully obscure minimap button or chat edit box |
| L4 | Empty states explain next action (not a void panel) |
| L5 | Spacing consistent with Classic template rhythm (no random card grid) |
| L6 | Footer/scripture one-liner does not collide with tabs/close |

### 7.3 Before → after delta rules

When both images are present, the agent must answer:

1. **What visibly changed?** (list regions; no invented diffs)  
2. **Did the claim improve?** Pass only if the claim’s observable is better or equal with no new R* fails.  
3. **Regressions?** New truncation, contrast loss, center spectacle, color-only state, etc.  
4. **Unrelated drift?** World lighting / other addons — label as capture noise, not CoB regression.

**Pass criterion for a polish PR:** all R* applicable rows Pass; L* Fail rows either fixed or explicitly waived by a human with reason.

---

## 8. Required agent response shape

```markdown
## Visual QA — <claim>

### Inputs
- before: <path or none>
- after/candidate: <path>
- shot IDs: ...
- context: res / scale / role

### Observations (pixels only)
- ...

### Rubric
| ID | Verdict | Evidence |
|----|---------|----------|
| R1 | Pass/Fail/Uncertain/N/A | ... |

### Delta (if before+after)
- changed: ...
- improved claim: yes/no
- regressions: ...

### Vision caveats
- ...

### Recommended next action
- fix-code | recapture | human-signoff | done
```

---

## 9. Known vision-model failure modes (and CoB mitigations)

Drawn from GUI/VLM evaluation literature (GUI Knowledge Bench, UI-Lens-style display QA, mobile UI grounding studies) and practical OCR/VLM failure reports. Treat as **operational hazards**, not citations of product law.

| Failure mode | What it looks like | CoB mitigation |
|--------------|--------------------|----------------|
| **Confident OCR hallucination** | Misreads Friz/GameFont titles; invents wrong rank name | Require Uncertain when glyphs are soft; verify titles against `Data/Ranks.lua`, never “fix” copy from a misread |
| **Adjacent-text hijack** | Larger nearby chat/combat text reported as the control’s label | Crop or full-frame + ask “read only text inside the Beef panel” |
| **Phantom defects** | Intentional Classic padding called “blank bug”; `?` placeholder called missing data | Anchor on template-native doctrine; empty-state shots labeled in meta |
| **Scroll/clip confusion** | Scrollable list clip flagged as truncation bug | Note scrollable regions in meta; capture scrolled top + bottom if disputed |
| **State blindness** | Disabled button described as clickable; hidden Officer tab “present” | Pair shots with role in filename; ask “is Officer tab visible: yes/no” |
| **Task-completion hallucination** | Claims toast disappeared when a different UI element changed | Before/after must share shot ID + ask for region-level delta |
| **Hex / brand overreach** | “Should be scarlet #RRGGBB” on V1 chrome | Reject; glossary 78/81 — template-native until screenshot lock |
| **JPEG chroma smear** | False “blurry font” / wrong colors | Prefer PNG; ignore micro-fringing on 4:2:0 captures |
| **Natural-image bias** | Rates “cinematic dark glass” as nicer than Classic opaque | Rubric R1/R2 overrides taste |
| **Path amnesia** | Forgets toast should be edge, suggests center celebration | Re-state bans in the prompt every polish turn |
| **Overconfidence** | Pass with no evidence rows | Enforce §8 table; no Pass without Evidence |

**Meta-mitigation:** Vision is a **reviewer**, not an authority. Lua errors, harness results, and locked glossary beats the model’s aesthetic preference.

---

## 10. Prompt pack (paste into agent turns)

### 10.1 Single-shot critique

```text
Read the attached CoB screenshot(s). Product law: Classic opaque FrameXML shell;
text thresholds on My Standing; no center spectacle; dual-encode officer states;
class color on names only. Use docs/research/agent-polish-vision/26-visual-qa-screenshot-protocol.md
§7–§8. Claim: <CLAIM>. Mark Uncertain rather than inventing text.
```

### 10.2 Before / after polish

```text
Read before and after images (paths below). List only visible deltas.
Score §7 rubric. Pass the claim only if it improved with no new R* fails.
Do not recommend Retail glass, ElvUI-flat brand, or custom Media for V1.
Before: <path>
After: <path>
Claim: <CLAIM>
```

### 10.3 Brand hex lock session (later)

```text
Anniversary screenshot lock pass for chrome tokens only.
Compare template-native CoB panel to world + default Blizzard panels.
Do not invent hex from memory; describe relative contrast and whether
research scarlet is necessary. Spec remains law until §15 updated.
```

---

## 11. Relation to other tracks

| Track / doc | Use with this protocol |
|-------------|------------------------|
| [43-ui-scale-pixel-perfection](../wow-classic-addon-design/43-ui-scale-pixel-perfection/beef-guidance.md) | `S-SCALE-STRESS` matrix |
| [17-stream-overlay-readability](../wow-classic-addon-design/17-stream-overlay-readability/capture-safe-zones.md) | `S-STREAM-EDGE`, toast placement |
| [02-visual-language](../wow-classic-addon-design/02-visual-language/) | Steal/avoid aesthetics when judging chrome |
| [23-color-brand-tokens](../wow-classic-addon-design/23-color-brand-tokens/) | Post-lock hex; not V1 Task 7 paint |
| [70-standing-breakdown-ui](../wow-classic-addon-design/70-standing-breakdown-ui/) | Standing density anti-patterns |
| [69-officer-tab-ia](../wow-classic-addon-design/69-officer-tab-ia/) | Empty queue / evidence IA |
| Church-of-beef-dev skill | Install → reload → then capture |
| Canvas `visual-polish-acceptance-checklist` | Human gate alongside this agent loop |

---

## 12. Explicit non-goals

- Automated in-client screenshot bots or process control  
- Pixel-diff CI as a V1 gate (optional later tooling — needs human approval / `OPTIMIZATIONS.md`)  
- Replacing two-client BeefNet tests with screenshots  
- Shipping capture dumps or `.firecrawl/` noise as product truth  
- Claiming V1 complete because a vision model said “Pass”

---

## 13. One-page checklist

```text
[ ] Claim written
[ ] Install + /reload + scriptErrors clean
[ ] P0 shots captured (PNG), named per §6
[ ] meta.md filled
[ ] Agent Read with §10 prompt + §8 output shape
[ ] R* rows Pass; L* fails fixed or human-waived
[ ] Recapture after code fix (same scale/role)
[ ] No product fork from vision taste
```

---

## 14. Expansion — VLM science → CoB capture rules (2026-07-26)

**Sources:** [ScreenAI](https://arxiv.org/abs/2402.04615); [GameUIAgent quality ceiling](https://arxiv.org/html/2603.14724); [UW Vision LLMs for UI Testing](https://courses.cs.washington.edu/courses/cse503/25wi/final-reports/Using%20Vision%20LLMs%20For%20UI%20Testing.pdf) (web/Playwright — **do not** port process control to WoW); deep extract `_deep-agentic-critique.extract.md` §5; catalog [`22b`](22b-agentic-critique-sources.md).

### What VLMs are good for (CoB)

- Coarse presence: Officer tab visible? Toast near edge? Opaque panel vs world bleed?  
- Dual-encode sanity: approve/reject readable as text in greyscale crop  
- Before/after **region** deltas when shot IDs match  

### What VLMs are bad for (do not trust)

| Failure | CoB rule |
|---------|----------|
| Fine geometry (“2px border”) | Human or ignore; no pixel CI |
| Animation / fade timing | Human smoke only |
| OCR of Friz/GameFont titles | Verify against `Data/Ranks.lua`; mark Uncertain |
| “Looks fine” default | Asymmetric: treat “missing element” claims seriously; treat “pass vibes” skeptically |
| Side-by-side position bias | Prefer sequential Read with labels; or swap A/B ([MT-Bench](https://arxiv.org/abs/2306.05685)) |
| Quality-ceiling thrash | ≤2 Uncertain rounds → human sign-off ([GameUIAgent](https://arxiv.org/html/2603.14724)) |

### Capture matrix add-on

When layout/spacing changes, capture **two** scale tags (`classic` + `pp`) per claim — VLMs lose kerning/offset signal under heavy downscale (deep-research §5.4). Prefer PNG crops of the disputed control plus one full-frame context shot.

**Authority reminder:** VLM is a reviewer. Spec / glossary / BugSack / harness beat aesthetic preference.