# 25 — UI polish critique rubric (agent self-score)

**Audience:** Coding agents reviewing their own Church of Beef UI (and reviewers scoring a PR).  
**Authority:** Design spec §10 / §15 · [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) · glossary 68–71, 74–81 · rules `wow-ui-taint-lockdown`, `wow-performance`.  
**Doctrine (one line):** *Classic Blizzard shell for process UI; brand in words (guild chat + private toasts); custom gothic/heraldry only after V1 earns it.*

This note is **guidance for critique**, not product law. If a score conflicts with the spec, **spec wins**.

---

## How to use

1. Score **each dimension independently** on a **1–5** integer (no half-points).
2. Write **one concrete evidence line** per dimension (frame name, copy ID, API call, or screenshot observation).
3. Compute **total / 40** and apply the gate below.
4. Any **hard fail** (listed under a dimension) forces that dimension to **1** and blocks “ship polish” claims regardless of total.
5. Prefer in-client Anniversary smoke (`/console scriptErrors 1` → `/reload` → `/beef`) over desktop imagination for visual scores.

### Score meanings (shared)

| Score | Label | Meaning |
|------:|-------|---------|
| **5** | Exemplary | Matches locked doctrine; would use as a teachable example |
| **4** | Solid | Ship-ready; minor nits only |
| **3** | Acceptable | Usable; clear debt; fix before calling the surface “polished” |
| **2** | Weak | Wrong direction or noisy; rework before merge if UI-facing |
| **1** | Fail | Violates doctrine, safety, or readability; do not ship |

### Gate (suggested)

| Total | Verdict |
|------:|---------|
| **32–40** | Polish-ready (still run in-client QA) |
| **24–31** | Usable; list debt before claiming polish |
| **16–23** | Rework required on weak dimensions |
| **≤15** | Reject / redesign — do not present as finished UI |

**Minimum bar for “V1 UI done” claims:** every dimension ≥ **3**, and **Taint safety** + **Performance** ≥ **4**.

---

## Scorecard template (copy into PR / agent notes)

```text
COB UI critique — <surface: MainFrame | Ladder | Standing | Officer | Toast | Minimap>
Author / agent: <id>    Client smoke: yes/no    Date: <ISO>

1 Hierarchy ............. _/5   Evidence:
2 Spacing ............... _/5   Evidence:
3 Juice ................. _/5   Evidence:
4 Lore fit .............. _/5   Evidence:
5 Classic authenticity .. _/5   Evidence:
6 Performance ........... _/5   Evidence:
7 Accessibility ......... _/5   Evidence:
8 Taint safety .......... _/5   Evidence:

Total ................... _/40
Hard fails .............. none | <list>
Verdict ................. polish-ready | usable+debt | rework | reject
Top 3 fixes .............
```

---

## 1. Hierarchy

**Question:** Does the eye land on the right thing first? Is primary action obvious? Are tabs/sections one job each?

| Score | Criteria | Example (Church of Beef) |
|------:|----------|--------------------------|
| **5** | One clear focal path; title → content → action; Officer destructive actions visually subordinate until selected; local player highlight readable without rainbow | Ladder: rank title + occupants first; Commit stays in Officer flow; player row uses mild highlight, not a neon stripe |
| **4** | Clear primary/secondary; one small clutter debt (e.g. stub buttons slightly loud) | Standing shows points + next threshold first; event log below without competing weight |
| **3** | Usable but competing headlines or equal-weight buttons; user hesitates | Officer Approve/Reject same visual weight as rare Prophet bestowal with no confirm step emphasis |
| **2** | Dashboard soup: stats, stubs, and lore fighting; wrong default tab or hidden primary | First open shows dense meter chrome / multi-column “dashboard” instead of three tabs |
| **1** | Hierarchy inverted or missing; UI awards points or invents ranks; center-screen spectacle steals focus from gameplay | WA-style center pulse on promote; Standing as hero StatusBar; tip-jar CTA above Commit |

**Hard fails:** UI grants points; Net/UI invents ranks; center-screen social pulses; tip jars / donation CTAs.

**Probe questions**

- Cover the top 40px — can you still name the surface?
- Is there exactly one primary verb on Officer for the common path (approve/reject)?
- Would removing the footer/scripture line break understanding? (If yes, hierarchy is wrong — lore is garnish.)

---

## 2. Spacing

**Question:** Are margins, gaps, and alignment Classic-tool consistent? Does density match Auctionator/Questie, not Details!?

| Score | Criteria | Example |
|------:|----------|---------|
| **5** | Consistent gutter (≈8–12 virtual units between peers); aligned columns; toast 280–360×64–96; ≥24–40 from screen edge; no overlapping regions at default scale | Ladder rows share one left inset; toast TOP/upper, clamped, not full ultrawide span |
| **4** | Mostly consistent; one off-by-a-few misalignment; still readable at Classic default scale (~0.9–1.0) | Tab content padding matches Blizzard dialog inset; one FontString 2px high |
| **3** | Crowded or sparse in patches; wraps at common resolutions; works after manual resize | Officer list tight until window stretched; toast OK at 1080p, clips at pixel-perfect 4K |
| **2** | Overlap, zero-padding stacks, or huge empty voids; ignored `UI_SCALE_CHANGED` / clamp | Text over close button; toast off-screen after monitor change |
| **1** | Unusable layout; sets global `uiScale` / `UIParent:SetScale`; unclamped drag loses the frame | Addon forces scale on login; main frame can be dragged fully off-screen with no clamp |

**Hard fails:** Calling global UI scale setters; unclamped main frame that can vanish; permanent overlap of interactive hit rects.

**Probe questions**

- Spot-check default Classic scale, then ElvUI/pixel-perfect — does type still fit without billboard growth?
- Are peer controls sharing the same left edge / baseline?
- Toast: one plate, short copy — grow copy down before growing width past ~40% of screen?

---

## 3. Juice

**Question:** Is feedback ceremonial and rare — not raid-HUD sticky? Does spectacle land where non-addon members can see it?

| Score | Criteria | Example |
|------:|----------|---------|
| **5** | Rare, meaningful feedback: private toast + throttled officer `/g` line on promote/demote; fade (not combat pulse); V1 silent SFX; stubs feel intentional, not empty | “The Church recognizes Beefina, elevated to Beef Knight.” once; private toast; announce checkbox default ON |
| **4** | Correct channels and throttle; motion slightly plain or toast timing a bit long/short | Toast shows; announce works; fade duration slightly sticky but not stacked |
| **3** | Feedback exists but weak or slightly noisy; missing dual-encode on states | Approve/reject color-only (no icon/text twin); toast fires for every minor credit without coalesce |
| **2** | Wrong juice: persistent pulses, spammy chat, stacked toasts, or silent rank changes nobody notices | Three toasts queued; duplicate `/g` from multiple officers; center flash |
| **1** | Combat-HUD spectacle, ripped Blizzard SFX, or juice that automates gameplay | Looping WA pulse; default-on loud SFX pack; bot-like announce floods |

**Hard fails:** Center-screen WA pulses for social; unthrottled guild spam; ripped Blizzard audio; juice that implies botting / protected-action bypass.

**Probe questions**

- If the recipient lacks the addon, do they still see the promotion?
- Does UI closed stay quiet (no idle animation)?
- Is motion reserved for promote / demote / Prophet — not every scroll?

---

## 4. Lore fit

**Question:** Does copy and presentation sound like the Church without forking canon numbers or turning process UI into meme sludge?

| Score | Criteria | Example |
|------:|----------|---------|
| **5** | Titles from `Data/Ranks.lua` only; thresholds shown as text from Core/Data; officer chrome procedural (“Announce promotions to guild chat”); player-facing spectacle sincere-absurd; scripture footer optional one-liner | Standing: “Next: Beef Knight (threshold from canon)” — no invented clergy; no numbers invented in UI strings |
| **4** | Canon-correct; tone slightly flat or slightly meme on Officer where it should be serious | Toast fun; Officer labels mostly procedural with one wink that doesn’t confuse |
| **3** | Mostly correct; soft lore drift or placeholder copy left in ship path | Footer lorem; “rank 3” instead of title once; still not inventing thresholds |
| **2** | Tone clash or canon fork: ElvUI-cool voice, tip-jar piety, or duplicated thresholds in prose docs/UI | Item-quality rainbow for ranks; “donate to the Church” ; hard-coded 500 points in a FontString |
| **1** | Invents ranks/titles/thresholds; faction-skinned Alliance/Horde panels against locked shared brand; lore replaces usability | Fake eighth rank; Horde-only scarlet skin; scripture wall blocking Commit |

**Hard fails:** Inventing rank ids/titles/thresholds; forking numbers into UI/copy docs; donation CTAs; faction panel skins in V1.

**Probe questions**

- Diff UI strings against `Ranks.lua` titles — any orphans?
- Would an Officer mistake Approve because of meme labeling?
- Is brand carried by **words** in V1, not custom Media?

---

## 5. Classic authenticity

**Question:** Does it read as a small Anniversary tool window (Questie/Auctionator kin), not Retail Edit Mode, ElvUI-flat brand, or WA pack?

| Score | Criteria | Example |
|------:|----------|---------|
| **5** | Inherits Classic FrameXML templates (`BasicFrameTemplate`, `UIPanelButtonTemplate`, `BackdropTemplate`, …); opaque high-contrast; GameFont*; class color on **names** only; dual-encoded pending/approve/reject; no Ace/Masque/SharedMedia hard deps; no custom Media required | `/beef` looks at home next to Blizzard character pane; missing texture falls back; still loads |
| **4** | Template-native; one mild custom backdrop still opaque; verified on Interface `20506` | Custom dark fill inside Blizzard border; no Retail-only APIs |
| **3** | Recognizably Classic but a few Retail-ish tells (over-rounding, low-alpha) that don’t break | Slightly glassy header still readable on stream |
| **2** | Wrong church: ElvUI-flat as brand, glass panels, Details!-dense roster, item-quality rank colors, Retail templates unverified on Anniversary | Flat grey skin fighting default UI; rainbow ranks |
| **1** | Retail-only APIs / Edit Mode assumptions; SecureActionButton “to open panel”; hard SharedMedia; custom Media required to load | Addon errors without LSM; compartment-only entry with no `/beef` |

**Hard fails:** Retail-only APIs; SecureActionButton for panels; hard media deps that fail load; Interface bump without intent.

**Probe questions**

- TOC `## Interface: 20506` unless intentionally bumping?
- Can a player with default UI (no ElvUI) use every control?
- Standing: text thresholds only — no hero castbar/HP metaphor?

---

## 6. Performance

**Question:** Is the social addon invisible next to WA/Details when idle? Event-driven, dirty-coalesced, combat-calm?

| Score | Criteria | Example |
|------:|----------|---------|
| **5** | UI closed → events only; no permanent `OnUpdate` for business logic; open UI ≤10 Hz dirty coalesce; combat does not full-rebuild ladder per message; SV capped; announce/sync throttled | `OnUpdate` nil when hidden; BeefNet refresh sets dirty flag; instance drip low-rate |
| **4** | Meets budget with one minor hot path documented | Full refresh on tab show only; toast uses `C_Timer` once |
| **3** | Acceptable but chatty when open; still idle when closed | Rebuilds whole list on every suggestion while Officer tab open |
| **2** | Permanent `OnUpdate`, combat storms, or unbounded SV growth | Scoring tick every frame; event log grows forever |
| **1** | Per-frame proximity/combat scans; gameplay automation loops; multi-MB SV as design | Scanning nearby players each frame for “co-play” |

**Hard fails:** Permanent business-logic `OnUpdate`; combat ladder rebuild storms; unbounded SV by design; any botting/automation loop.

**Probe questions**

- Close `/beef` — any scripts still ticking for UI?
- Flood synthetic BeefNet updates — does FPS hold vs WA?
- Are local logs capped/rotated?

---

## 7. Accessibility (a11y)

**Question:** Can color-blind and stream viewers parse state? Is type readable under Classic scale variance? Are destructive actions confirmable?

| Score | Criteria | Example |
|------:|----------|---------|
| **5** | Dual-encode all critical states (color **and** icon/text); GameFont sizes readable at default scale; toast short (title + name); confirm on demote / Prophet / Council; Officer tab hidden unless Officer+; no color-only rank legend | Pending = “Pending” text + amber mark; Reject disabled reason in words; class color on names only |
| **4** | Dual-encode on Approve/Reject/Pending; confirms present; one secondary state color-only | Credit toast text-only OK; rare status tint lacks icon |
| **3** | Readable for average user; color-blind risk on a secondary path; copy a bit long for stream | Toast three lines — still parses at 1080p, fails track-17 stream floor |
| **2** | Color-only states; tiny type; no confirm on destructive; toast dead-center over combat | Red/green only buttons; Prophet bestowal one-click |
| **1** | Unreadable chrome (glass/low-alpha); blocks input; requires non-default scale; flashes seizures-level pulses | Low-alpha panel on bright world; rapid full-screen flash |

**Hard fails:** Color-only for approve/reject/pending; no confirm on demote/Prophet/Council; setting global UI scale; seizure-style flashing.

**Probe questions**

- Screenshot in greyscale — can you still parse Officer queue states?
- Keyboard/`/beef` path works if minimap hidden?
- Does toast avoid bottom-right webcam and dead-center combat fovea?

---

## 8. Taint safety

**Question:** Is the product window fully insecure and combat-safe to toggle? Are Classic taint footguns avoided?

| Score | Criteria | Example |
|------:|----------|---------|
| **5** | Insecure `CreateFrame` under `UIParent` / Beef root; `:Show()`/`:Hide()` (not `ShowUIPanel` in combat); no `SecureActionButtonTemplate`; no parent under protected trees; avoid stock `UIDropDownMenu_*` / blind `StaticPopup_Show`; `HookScript` over overwrite; Officer+ gate for Officer tab | Own confirm frame or StaticPopup with `preferredIndex = 3`; combat can still open `/beef` |
| **4** | Correct insecure model; one deferred edge documented (e.g. won’t open Blizzard guild panel in combat) | All Beef chrome combat-safe; external Blizzard panel deferred |
| **3** | Mostly safe; risky pattern present but not on hot path | EasyMenu on rare settings only — still prefer replace |
| **2** | Known taint vectors on common path | Stock UIDropDownMenu for Officer actions; `SetScript` replaces Blizzard handler |
| **1** | Secure templates for panels; ShowUIPanel toggle; secure attribute / binding hacks; protected-action bypass | SecureActionButton “opens Standing”; SetBinding for promote |

**Hard fails:** `SecureActionButtonTemplate` / secure headers for product panels; protected-action bypass; parenting under raid/action-bar protected trees; combat-broken toggle as the only entry.

**Probe questions**

- Open `/beef` in combat — errors? taint? 
- Any secure template inheritance in `UI/**`?
- Confirm flows: own frame or carefully indexed StaticPopup?

---

## Dimension cheat sheet (anti-patterns → score ≤2)

| If you see… | Cap dimension |
|-------------|----------------|
| Details!-dense roster / dashboard soup | Hierarchy, Classic authenticity |
| Glass / low-alpha panels | Classic authenticity, a11y |
| Standing as HP/castbar | Hierarchy, Classic authenticity, lore fit |
| Item-quality rainbow ranks | Lore fit, Classic authenticity |
| Center WA pulse / stacked toasts | Juice, a11y |
| Hard-coded thresholds in FontStrings | Lore fit |
| Permanent `OnUpdate` | Performance |
| Color-only Approve/Reject | a11y |
| SecureActionButton / ShowUIPanel in combat | Taint safety |
| `uiScale` / `UIParent:SetScale` | Spacing, a11y, Classic authenticity |
| Tip jar / donate CTA | Hierarchy, lore fit |
| Custom Media required to load | Classic authenticity |

---

## Worked mini-example (illustrative)

**Surface:** Promote path (Officer Commit → toast → `/g`).

| Dim | Score | Evidence |
|-----|------:|----------|
| Hierarchy | 4 | Commit primary; Prophet behind confirm |
| Spacing | 4 | Toast 320×80, TOP, clamped |
| Juice | 5 | One toast + one officer `/g`; silent |
| Lore fit | 5 | Rank title from `Ranks.lua`; procedural announce checkbox |
| Classic authenticity | 5 | `UIPanelButtonTemplate`; GameFont; opaque |
| Performance | 5 | Dirty refresh; no OnUpdate when hidden |
| a11y | 4 | Approve/Reject text+color; toast two lines |
| Taint safety | 5 | Insecure frame; `:Show()`; own confirm |

**Total: 37/40 — polish-ready** (still smoke in-client).

---

## Related reading

| Doc | Use |
|-----|-----|
| [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) | Agent briefing + bans |
| Spec §10 / §15 | Product law |
| Track [`02-visual-language`](../wow-classic-addon-design/02-visual-language/) | Native vs flat vs WA |
| Track [`32-microcopy-tone-voice`](../wow-classic-addon-design/32-microcopy-tone-voice/) | Officer vs spectacle tone |
| Track [`43-ui-scale-pixel-perfection`](../wow-classic-addon-design/43-ui-scale-pixel-perfection/) | Toast geometry / scale |
| Rules `wow-ui-taint-lockdown`, `wow-performance` | Hard constraints |

---

## Expansion — judge robustness (2026-07-26)

**Sources:** [MT-Bench](https://arxiv.org/abs/2306.05685); [LangSmith LLM-as-judge](https://docs.langchain.com/langsmith/llm-as-judge?mode=ui); [`22b`](22b-agentic-critique-sources.md).

### Anchoring (anti–“everything is a 7”)

MT-Bench shows unanchored scales collapse toward mid/high scores. This card already anchors 1–5 with CoB examples — **keep it**. When adding axes, write the 1 / 3 / 5 rows before any scoring pass.

### Bias controls for self-score + peer score

| Bias | Mitigation in this rubric |
|------|---------------------------|
| Self-enhancement | Round 2 must be **fresh context** (or second model); may only lower/hold scores ([24](24-definition-of-done-polish.md) §5.3) |
| Verbosity / “more chrome” | Penalize density & juice restraint; Classic shell wins over gothic chrome |
| Position (A/B) | If pairwise, swap order twice ([35](35-subjective-quality-harnesses.md)) |
| Preference vs law | Hard fails force dim → **1**; taste without constitution → ignore |

### Machine-scannable sidecar (optional)

Emit alongside the 8×1–5 card:

```text
decision: pass|revise|reject
blockers: [H*/U* ids]
top_fixes: ≤5
client_smoke: yes|no|blocked
```

Aligns with evaluator-optimizer `decision` routing ([LangGraph](https://langchain-ai.github.io/langgraph/tutorials/workflows/); [Anthropic](https://www.anthropic.com/engineering/building-effective-agents)).

---

## Changelog

| Date | Note |
|------|------|
| 2026-07-26 | Initial agent self-score rubric (8×1–5, examples, gates) |
| 2026-07-26 | Expansion: MT-Bench bias controls + decision sidecar |
