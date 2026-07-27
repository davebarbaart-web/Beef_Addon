# 46 — Toast / celebration system architecture (UI layer)

**Last updated:** 2026-07-26  
**Audience:** Coding agents polishing private edge toasts and rank-ceremony feedback.  
**Status:** Research / implementer architecture — **not** product law. Spec §10 / §15, glossary rows 75–79, and [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) win on conflict.  
**Checkout note:** `.worktrees/feat-church-of-beef-v1/` was empty at authoring time; inspected live tree at [`addon/ChurchOfBeef/UI/Toasts.lua`](../../../addon/ChurchOfBeef/UI/Toasts.lua) (+ call sites in `Net/BeefNet.lua`, `UI/OfficerTab.lua`, `UI/StandingTab.lua`, harness `tests/test_ui.lua` / `tests/test_officer_ui.lua`).

**Companions:** [02 frames/juice](02-lua-vs-xml-frames.md) · [03 taint/combat](03-taint-lockdown-ux.md) · [16 timing recipes](16-timing-curves-recipes.md) · [18 color](18-color-hierarchy-readability.md) · [08 settings](08-savedvars-settings-ux.md) · track [17 duration-and-attention](../wow-classic-addon-design/17-stream-overlay-readability/duration-and-attention.md)

---

## 1. Verdict (one screen)

Keep **one** private edge toast frame owned by `COB.Toasts`. Evolve the string FIFO into a **priority queue of envelopes** (kind → hold → motion → dedupe → optional combat soft-defer). Brand spectacle stays **words** (toast copy + officer `/g` announce elsewhere). Never grant standing, never invent ranks, never WA-center pulses, never permanent `OnUpdate`.

**Doctrine:** *Display Core / Net outcomes. Queue the noise. Promote wins the screen. Combat may quiet motion, never drop authority.*

---

## 2. What exists today (baseline)

| Concern | Current behavior (`UI/Toasts.lua`) |
|---------|-----------------------------------|
| Surface | Single insecure frame `ChurchOfBeefToast`, `TOP` of `UIParent`, strata `HIGH`, ~360×40 |
| API | `Init()`, `Show(text)`, `HideAll()` |
| Queue | FIFO of **strings**, `MAX_QUEUE = 5`; overflow → `false` (drop) |
| Timing | Hold **3.5 s**; fade-in **0.15 s** (3 steps); fade-out **0.22 s** (4 steps) via `C_Timer.After` (or one-shot `OnUpdate` fallback) |
| Priority | None — second toast waits |
| Dedupe | None — identical lines can stack |
| Combat | None — shows immediately (correct for insecure frames) |
| Motion | Alpha steps only; harness skips fades when `COB._IN_TEST` |
| Kinds | Implicit in call-site copy only |
| SFX / Media | Silent; stock tooltip backdrop; no custom Media |

Call-site pattern (repeated):

```lua
local function toast(text)
  if COB.Toasts and COB.Toasts.Show then COB.Toasts:Show(text) end
end
```

Observed kinds in the wild (copy only — not typed):

| Source | Example | Implied kind |
|--------|---------|--------------|
| `Net:OnLocalSuggestion` | “Standing recognized — Cooked Beef suggested.” | `suggest` (self) |
| `Net` inbound suggestion | “X petitions for Y.” | `suggest` (officer view) |
| `Net` / officer commit path | “X is now Y.” / “Promote: X → Y” | `promote` / `demote` / `rite` |
| Standing Gora / ceremony | “Gora win: +N standing” / “Ceremony closed…” | `credit` |
| Officer refuse / dismiss | “Promote refused…” / “Petition dismissed…” | `system` |

Guild-chat spectacle is **out of scope** for this module (officer Announce path). Toasts must never `SendChatMessage`.

---

## 3. Goals / non-goals

### Goals

1. **Readable ceremony** — promote/demote always beat credit spam.  
2. **Bounded noise** — hard queue cap; dedupe bursts (sync, multi-grant).  
3. **Classic motion** — short enter/exit; hold by kind ([16](16-timing-curves-recipes.md) Card C/D).  
4. **Combat-safe UX** — insecure `:Show()` OK; optional **soft defer** of motion-heavy or low-priority juice only.  
5. **Layer purity** — UI displays; Core/Net remain authority.  
6. **Back-compat** — `Show(text)` keeps working for existing call sites.

### Non-goals

- Center-screen pulses, RaidWarning hijack, `UIFrameFlash` on Blizzard frames.  
- AceEvent toast bus, LibToast, or second toast stack.  
- Per-event announce filters / toast mute UI in V1 (glossary 75 — playtest-gated).  
- SFX in V1 (silent; later default-off).  
- Core → UI callbacks that create frames.  
- Streaming privacy masks (V1.1 SV preset).

---

## 4. Architecture

```
Call sites (Net / OfficerTab / StandingTab / future)
        │  COB.Toasts:Push(envelope)  or  :Show(text) / :Celebrate(kind, fields)
        ▼
┌───────────────────────────┐
│  Normalize → Envelope     │  kind, priority, text, dedupeKey, hold, flags
└─────────────┬─────────────┘
              ▼
┌───────────────────────────┐
│  Dedupe gate              │  same key within window → coalesce or drop
└─────────────┬─────────────┘
              ▼
┌───────────────────────────┐
│  Priority queue (≤ N)     │  insert by priority; drop lowest on overflow
└─────────────┬─────────────┘
              ▼
┌───────────────────────────┐
│  Combat soft-defer?       │  optional: hold low-priority while InCombatLockdown
└─────────────┬─────────────┘
              ▼
┌───────────────────────────┐
│  Presenter (1 frame)      │  enter → hold → exit → pump next
│  motion from kind recipe  │  C_Timer / AnimationGroup; no permanent OnUpdate
└───────────────────────────┘
```

**One presenter.** Stacked concurrent toasts are out — concurrency budget is **one visible** (+ queued envelopes). Promote may **interrupt** a showing credit; credit must **not** interrupt promote ([16](16-timing-curves-recipes.md) Card C).

---

## 5. Envelope model

```lua
-- Logical shape (not a public Core type)
{
  kind       = "promote",      -- see §6
  priority   = 80,             -- derived from kind unless overridden
  text       = "Beefina is now Cooked Beef.",
  dedupeKey  = "promote:Beefina:2",  -- nil = no dedupe
  hold       = 7.0,            -- seconds; nil → kind default
  interrupt  = true,           -- may bump a lower-priority showing toast
  deferInCombat = false,       -- soft-defer until PLAYER_REGEN_ENABLED
  motion     = "rank",         -- "edge" | "rank" | "snap" (test/harness)
  -- optional display hints (UI-only; never authority):
  accent     = "cob.state.approved",  -- token id from track 18; dual-encode in text too
}
```

Normalization rules:

1. `Show(text)` → `{ kind = "system", text = text, priority = kindDefault }`.  
2. Empty / non-string text → refuse (`false`).  
3. Unknown `kind` → `"system"`.  
4. `priority` clamped to `[0, 100]`.  
5. Truncate display text if needed for frame width (do not truncate authority copy at Core).

---

## 6. Kinds, priority, hold

Higher priority drains first. Same priority → FIFO.

| Kind | Priority | Default hold | Interrupt lower? | Defer in combat (default) | Notes |
|------|----------|--------------|------------------|---------------------------|-------|
| `promote` | **90** | **6–8 s** | yes | no | Peak ceremony; Card D title overshoot OK later |
| `demote` / `excommunicate` | **85** | **6–8 s** | yes | no | Same weight as promote for attention |
| `suggest` | **70** | **5–7 s** | yes vs credit | no | Self + officer petition lines |
| `rite` | **65** | **4–5 s** | yes vs credit | no | Standing set / council rites (officer) |
| `credit` | **40** | **3.5–5 s** | no | **yes** (optional) | Gora / ceremony payouts — noisiest |
| `system` | **30** | **3.5 s** | no | yes | Refusals, soft errors, fallbacks |
| `debug` | **10** | **2 s** | no | yes | Harness / `_IN_TEST` only |

V1 may ship with a single hold constant (3.5 s) until playtest; architecture should still **branch by kind** so promote can lengthen without a settings tree.

---

## 7. Queueing

| Rule | Behavior |
|------|----------|
| Cap | Keep `MAX_QUEUE = 5` **pending** (not counting the showing toast). |
| Insert | Binary-search or linear insert by `priority` desc, then arrival order. |
| Overflow | Drop the **lowest-priority** pending item; if tie, drop oldest low-priority. Never drop a pending `promote`/`demote` to keep a `credit` — drop credits first. |
| Interrupt | If a new envelope has higher priority **and** `interrupt`, cancel current exit/hold timers, fade-out fast (`snap` or ≤100 ms), then present the new one; re-queue the interrupted item only if its kind ≥ `suggest` (optional — V1 may simply discard interrupted credits). |
| Pump | After exit completes → pop highest pending → present. Idle → hide frame, clear `showing`. |
| HideAll | Clear pending + cancel timers + hide (existing semantics). |

Pseudo:

```
Push(e):
  e = Normalize(e)
  if DedupeReject(e) then return false, "deduped" end
  if ShouldSoftDefer(e) then deferList.push(e); return true, "deferred" end
  if showing and e.interrupt and e.priority > showing.priority then
    InterruptShowing()
  end
  if pending full then EvictLowest() end
  pending.insert(e)
  if not showing then Pump() end
  return true
```

---

## 8. Dedupe

Goal: survive login sync + double Net paths without toast storms.

| Strategy | When |
|----------|------|
| **Key + window** | If `dedupeKey` matches an entry shown or queued within `DEDUPE_WINDOW` (recommend **8–12 s**), drop or coalesce. |
| **Coalesce credit** | Same `dedupeKey` for `"gora:Name"` while pending → replace text with latest total (“Gora win: +4 standing”) rather than enqueue N lines. |
| **Promote uniqueness** | `dedupeKey = "promote:"..name..":"..rankId` — second identical promote in-window drops (Net + local officer both toasting). |
| **No key** | No dedupe (refusals may repeat). |

Call sites should pass keys; `Show(text)` alone cannot safely dedupe (hashing full text is OK as weak fallback: `dedupeKey = "text:"..text`).

**Important:** Deduping toasts must **not** suppress guild announce (different module).

---

## 9. Motion

Align with [16 Card C/D](16-timing-curves-recipes.md); migrate stepwise from today’s stepped alpha.

| Phase | Budget | Notes |
|-------|--------|-------|
| Enter | **200–300 ms**, ease-out | Fade + optional ≤12–20 px slide from top edge |
| Hold | kind table (§6) | No looping glow |
| Exit | **150–220 ms**, ease-in | Faster than enter (~25–35%) |
| Rank peak | title scale **1.04–1.08** settle | Optional post-V1; chrome frame itself never overshoots |
| Interrupt cut | ≤ **100 ms** or snap | When promote bumps credit |

Implementation prefs:

1. Prefer `C_Timer.After` or `CreateAnimationGroup` + `Alpha` / `Translation`.  
2. Nil any fallback `OnUpdate` when idle.  
3. `COB._IN_TEST` → `motion = "snap"` (instant show/hide; one timer flush advances queue — preserve harness).  
4. Cap concurrent animations at **one** toast group.  
5. Do not parent under raid/action-bar trees; stay on `UIParent`.

Visual tokens (later): opaque iron scrim α = 1.0 ([18](18-color-hierarchy-readability.md)); dual-encode state in **words** (“Recognized”, “Elevated”), not hue alone.

---

## 10. Combat deferral

Product principle from [03](03-taint-lockdown-ux.md): **combat never drops authority or spectacle; it may defer chrome that touches protected trees.**

Private edge toasts on Beef’s own insecure frame are **allowed in combat**. Do **not** block promote toasts behind `PLAYER_REGEN_ENABLED`.

Recommended policy:

| Kind | In combat |
|------|-----------|
| `promote` / `demote` / `suggest` / `rite` | Show immediately (full or snap enter). |
| `credit` / `system` | **Soft-defer** optional: enqueue to `deferList`; on `PLAYER_REGEN_ENABLED`, merge into priority queue (still deduped). |
| Motion | May force `snap` enter/exit while `InCombatLockdown()` to avoid layout thrash — content still shows. |
| Never | Create secure-template frames; `ShowUIPanel`; parent under CompactRaid*; busy-loop `OnUpdate` waiting for regen. |

Wire once in `Toasts:Init` (or UI login):

```lua
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
-- OnEvent → DrainDeferList()
```

If soft-defer is off in V1 (simplest ship), document the hook so polish agents do not invent a second defer bus.

---

## 11. API sketch (UI-only)

Public surface stays on `COB.Toasts`. No Core imports of this API.

```lua
--- Ensure frame exists. Idempotent. Returns frame or nil.
Toasts:Init()

--- Back-compat. Equivalent to Push({ kind = "system", text = text }).
--- @return ok boolean
Toasts:Show(text)

--- Preferred structured entry.
--- envelope: string|table
---   string → Show(text)
---   table  → { kind?, text=, priority?, dedupeKey?, hold?, interrupt?,
---              deferInCombat?, motion? }
--- @return ok boolean, reason string|nil
---   reason: "deduped" | "overflow" | "deferred" | "invalid" | nil
Toasts:Push(envelope)

--- Convenience for ceremony copy. Builds text + kind defaults; does not touch Core.
--- kind: "promote"|"demote"|"suggest"|"credit"|"rite"|"system"
--- fields: { name?, title?, detail?, standingDelta?, dedupeKey? }
--- @return ok boolean, reason string|nil
Toasts:Celebrate(kind, fields)

--- Cancel timers, clear pending + defer, hide.
Toasts:HideAll()

--- Test / debug helpers (no-op or restricted unless COB._IN_TEST)
Toasts:ResetForTests()          -- clear queue state
Toasts:PendingCount()           -- number
Toasts:ShowingKind()            -- string|nil
```

### `Celebrate` copy mapping (UI-owned strings)

| Kind | Suggested format |
|------|------------------|
| `promote` | `"%s is now %s."` |
| `demote` | `"%s is now %s."` (title after demote) |
| `suggest` | `"Standing recognized — %s suggested."` / `"%s petitions for %s."` |
| `credit` | `"Gora %s: %+d standing"` / ceremony summary |
| `rite` | `"%s: %d standing"` |
| `system` | `fields.detail` or `fields.text` |

Agents should gradually replace raw `Show(string.format(...))` with `Celebrate` / `Push` so priority and dedupe keys stay consistent. **Net may call UI Toasts** (already does); Net must not create frames.

### Migration path

| Step | Change | Risk |
|------|--------|------|
| 0 | Keep `Show`/`HideAll` semantics green in `test_ui.lua` | — |
| 1 | Internal envelope + priority insert; `Show` wraps `Push` | Low |
| 2 | Kind-based hold + interrupt promote→credit | Medium (timer tests) |
| 3 | `dedupeKey` at Net/Officer/Standing call sites | Low |
| 4 | Optional combat soft-defer for `credit` | Medium (needs regen stub) |
| 5 | AnimationGroup / slide; Card D title overshoot | Polish-only |

Do **not** expand TOC with a second toast file unless `Toasts.lua` exceeds maintainability — prefer extending this module.

---

## 12. Layer & safety checklist

| Rule | Toast system duty |
|------|-------------------|
| UI never awards points | No Scoring/Ladder writes |
| Net never invents ranks | Toast text from already-applied records only |
| Core never CreateFrame | No toast API in Core |
| Silent V1 | No `PlaySoundFile` |
| No WA center pulses | Edge only; no `RaidNotice_AddMessage` for brand |
| Settings starvation | No mute slider until playtest demands |
| Performance | Idle when queue empty; no permanent OnUpdate |
| Taint | Insecure Beef root only |

---

## 13. Acceptance (agent / playtest)

Desktop harness:

- [ ] Empty/nil `Show` → false  
- [ ] Queue advances on timer flush without permanent OnUpdate  
- [ ] Promote enqueued while credit showing → credit yields  
- [ ] Duplicate `dedupeKey` within window → single toast  
- [ ] Overflow drops credit before promote  
- [ ] `HideAll` drains pending + defer  

In-client (`20506`):

- [ ] `/console scriptErrors 1` — promote during trash still shows edge toast  
- [ ] Gora spam during pull does not bury a promote  
- [ ] Login sync does not fire a toast storm  
- [ ] Guild announce still one officer line (unaffected)  
- [ ] Stream capture: toast readable, opaque scrim, no glass  

---

## 14. Open questions (do not silently fork)

1. Soft-defer credits in combat — ship V1 on or off? (Recommend **off** until raid night noise proves need.)  
2. Interrupted credit — discard vs re-queue? (Recommend **discard**.)  
3. Toast mute SV — only if playtest demands (glossary 75).  
4. Officer local toast + Net peer toast for same promote — require `dedupeKey` discipline or accept rare doubles?

Log product answers in spec §15; keep this file as implementer architecture.
