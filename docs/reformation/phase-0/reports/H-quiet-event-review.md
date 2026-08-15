# Phase 0 Lane H — Adversarial review (quiet-event-modes)

**Lane:** H — Quiet Mode / Event Mode  
**Artifacts:** `.cursor/rules/quiet-event-modes.mdc`, `docs/reformation/phase-0/reports/H-quiet-event.md`, brief `docs/reformation/phase-0/briefs/H-quiet-event.md`  
**Law:** Bible §4.8, §14.1–14.2, §19.1–19.5, §24 filters 8–9; Ten Laws Law 6; Audit V9  
**Rule edited:** no (no Critical Bible contradiction)

| Axis | Verdict |
|------|---------|
| **Spec** | **PASS** |
| **Quality** | **Changes required** |

The Quiet/Event contract, Decree hard bound, mode-declaration requirement, sound lock, and onboarding silence are present and Bible-aligned. The five assigned attacks do not refute conformance. Two holes would still let a later UI agent rebuild Audit V9 under other names.

---

## Attacks (assigned)

### A1 — Extra Quiet Mode surface — does not land (Critical)

Rule Quiet Mode is contractual: at most minimap presence + the active Decree (§4.8, §19.1). Ambient list includes feeds, dashboards, toasts, pips, sound, “now playing,” activity panels, bars, standing tabs, points-history, grant/suggestion toasts, grant pips, and “just a small always-visible panel.”

`Player-opened identity/history may exist (§14.2)` is not an invented surface. Brief required §14.2; Bible §14.2 allows browsable profile/records on a Tuesday. The rule forbids treating that as always-visible chrome or a feed.

Onboarding parchment is Bible §19.5, first-launch only. Not a standing Quiet feature.

No Decree deputy chrome, calendar widget, or usability panel was added.

**Residual (Quality, not Spec):** the allowed Quiet set is not closed. See F2.

### A2 — Decree unbound (calendar / RSVP) — does not land

§14.1 is restated: one active proclamation; once-per-login parchment banner; thereafter minimap; “that is the entire feature.” Hard bound is complete: no calendar, RSVP, reminders, recurring events, attendance tracking. Deputy UX is forbidden, not specified. Authorship correctly left on existing `OPEN_QUESTIONS.md` item 5 / Bible Appendix B.

### A3 — Toasts / pips / sound in Quiet — lands as Major wording leak, not Critical

Quiet list bans toasts, pips, and sound. Quiet is silent absolutely (§19.4). Sound is Event Mode only; cue names are the §19.4 set only (Sanction bell, Verdict, Elevation, Knighting, Cowardice Recorded; later Canonization). Grant pips and grant/suggestion toasts are named as Audit V9.

The leak is the toast-engine carve-out (rule “Notices and onboarding”): Event Mode **or** a **rare system notice** (`e.g.` version-mismatch, §13.4 / §20.3). See F1.

That carve-out is authorized by the Lane H brief and Audit §4 (re-aim toast engine at Event consequence + rare Quiet system notices) and by Bible’s own “gentle update notice” while dropped to Quiet Mode. It is not an invented toast kind. It is still an open class that Law 6 / §4.8 / §19.1 do not grant.

Pips and ceremonial sound in Quiet are not licensed.

### A4 — Invented deputy UX — does not land

No deputy poster, deputy roster, or Decree-authoring widget. “Do not invent Decree deputy UX” only. Report does not resolve authorship.

### A5 — Failure to require mode declaration — does not land (Critical)

Opening law: exactly two presentation states; every UI feature **must declare** Quiet or Event before it is built; undeclared surfaces are rejected (§4.8, §19.1, §24 filter 8). Filter 9 is present.

**Residual (Quality):** the rule does not say *how* a feature declares a mode, and two surfaces it introduces are not labeled (F3).

---

## Findings

### F1 — Major — Open Quiet “system notice” class (Law 6, §4.8, §19.1 vs §13.4)

Rule: toast-engine may fire in Quiet for a “rare system notice” (`e.g.` version-mismatch).

Bible §4.8 / §19.1 and Law 6: no toasts in Quiet. Bible §13.4 / §20.3: one gentle update notice when a stale client drops to Quiet — a *notice*, not a toast-kind family.

`e.g.` plus “rare” lets an agent ship Quiet toasts for archive nag, sync/roster wait, petition waiting, version warn chip, or demo `system` kinds and still claim conformance. Demo `UI/Toasts.lua` already has `system` / `suggest` / `credit`; this sentence is the rebuild path for V9.

**Required change (rule text, not product invention):** name the single Bible exception (version-mismatch drop to Quiet, §13.4 / §20.3). State that it is not a standing feed and that no other Quiet toast kinds exist. Do not keep an open “rare system notice” class.

Not Critical: the exception itself is Bible-required and brief-authorized. The defect is the unbound class.

### F2 — Major — Quiet allowed-set not closed (§4.8, §14.1–14.2, §19.1; Audit V9)

Ambient bans are strong; the positive set is not.

- Minimap is licensed as presence + Decree access (§14.1). Click target is unspecified. Current `UI/Minimap.lua` opens the full `/beef` shell (Ladder / Standing / Officer) and still has a petition pip. An agent can keep that IA as “player-opened identity.”
- “Player-opened identity/history” (§14.2) is not bounded to profile/records. A Standing tab or points-history feed can be relabeled “My Record.”
- `/beef` MainFrame, Status chip, and hover tooltips are undeclared. §19.1 “no bars” / “no dashboards” sits next to §14.2 browsing without a closed list.

**Required change:** state that unbidden Quiet chrome is only minimap presence + the active Decree; player-opened Quiet is only identity/history (profile / records) per §14.2; minimap click reaches the Decree (and may open that identity/history); Ladder / Standing / Officer / grant pip / petition pip / always-on chip are rejected. Do not invent Director Console UX here (Lane E / §18).

### F3 — Minor — Surfaces introduced without a mode label (§4.8, §19.1, §19.5)

Onboarding parchment and the version-mismatch notice are not marked Quiet Mode or Event Mode. Declaration has no required form (comment, brief line, reject-if-absent).

**Required change:** label both as Quiet Mode one-shots; say undeclared work is rejected in the change itself.

### F4 — Minor — Event chrome not required to die on return to Quiet (§4.8, §19.2, §20)

Enter/exit only via ceremony runtime (§20) is correct. The rule does not say Event toasts, HUD, favor, cards, or cues must end when the machine returns to QUIET. A consequence toast that outlives the event is a Quiet toast.

**Required change:** Event theater and toast-engine output end when the runtime exits to QUIET. Lane G owns the machine; this rule owns the presentation consequence.

### F5 — Minor — Lane report overclaims

`H-quiet-event.md` says ambient surfaces are banned and nothing extra was invented. It does not record F1–F2. Frontmatter/globs match the brief; citations are otherwise fair (§13.4, §18.5, §20 are supporting, not invention). No OPEN_QUESTIONS append was required.

---

## What holds (attacks failed)

| Contract | Rule |
|----------|------|
| Two states; declare or reject | Opening paragraph; §24 filter 8 |
| Quiet ≤ minimap + Decree; no always-visible panel | Quiet Mode section; §4.8, §19.1 |
| Decree hard bound; no deputy UX | Decree section; §14.1 |
| Event theatrical; enter/exit via §20; named rhythm | Event Mode section; §19.2 |
| Sound Event-only; §19.4 cues only; Quiet silent | Sound section |
| Onboarding: one parchment, then silence | Notices; §19.5 |
| Filter 9 present | Scope filters |
| Frontmatter | `alwaysApply: false`; UI + bootstrap globs |

No Critical Bible contradiction. Rule not edited.

---

## Verdict

**Spec PASS. Quality: Changes required.**

Close F1 (single §13.4 notice, not a Quiet toast class) and F2 (closed Quiet allowed-set, including minimap click) before treating Lane H as gate-clean. F3–F5 are wording/report nits. The assigned attacks do not justify Spec FAIL.
