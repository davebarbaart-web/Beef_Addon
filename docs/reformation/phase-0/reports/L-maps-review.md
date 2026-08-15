# Phase 0 Lane L — Adversarial maps review

**Lane:** README / AGENTS / skill pointer  
**Artifacts:** `README.md`, `AGENTS.md`, `.cursor/skills/church-of-beef-dev/SKILL.md`  
**Lane report:** `docs/reformation/phase-0/reports/L-maps.md`

**Spec:** PASS  
**Quality:** Changes required

No Critical wrong-product leftover in the exclusive files. Nothing edited. No commit.

## Verdict

README, AGENTS, and the skill's own law sentences describe the Bible product. They do not restore a seven-rank points ladder, standing tabs, officer approve/reject, Beef Prophet as a rank, per-character "alts start fresh," or archived specs as winners. Six §5 ranks are named; the Pope is not a rank; `/beef minimap` is documented, not invented; §22.3 is quoted and the demo is not claimed done.

Spec still PASSes. Quality is **Changes required** because the skill polish loop still deep-links research notes whose authority stack is the retired design spec and archived UI brief, and because both maps drop Law 7's identity clause after deleting "alts start fresh." Those are the paths that rebuild Audit V6 and the V1 toast ladder.

## Attack results

| Attack | Result |
|--------|--------|
| Seven-rank ladder / standing / officer-approve / Prophet / alts-fresh leftover in the maps? | **No leftover sentences.** Prophet appears only as banned. Standing appears only as "not a roster-backed standing ladder." Identity replacement clause is missing (Important 2). |
| Product law still pointing at archived specs? | **No, in the maps themselves.** Bible is sole product law; archive is historical. Residual send is via skill → research (Important 1). |
| Invented slash subcommands? | **No.** `/beef` and `/beef minimap` match `ChurchOfBeef.lua`. Unrecognized args opening the frame is existing behavior. |
| Missing six ranks or Pope treated as a rank? | **No.** Table is Fresh, Cooked, Knight, Lord, Butcher (raid-team, display-only), Council. Pope is not a rank. |
| Skill still sending agents to archived UI brief as law? | **Not as a skill-owned law sentence.** Direct `ui-polished-direction-for-agents.md` / design-spec-as-law pointers are gone. Polish-loop research links still route there (Important 1). |

## Findings

### Critical

None. Exclusive files not edited.

### Important

1. **Skill polish loop still routes agents into research that names the archived spec and UI brief as authority.** (Brief L skill pointer; Law 1, Law 6, Law 10; Bible §19.3; AGENTS "do not treat archived UI briefs as law.")
   - Skill frontmatter and §5 correctly say product law is `docs/design/`, not archived briefs. Critique is aimed at Bible §19.3 / `ui-juice-standards.mdc`. Research is labeled ≠ law.
   - The same polish loop then sends agents into notes that invert that stack:
     - [42](docs/research/agent-polish-vision/42-v1-vs-v2-juice-scope.md): authority = design spec §10/§15 + `ui-polished-direction-for-agents.md` + glossary + plan Tasks; doctrine = "guild chat + private edge toasts"; V1 = "ladder process UI + chat rite + edge toasts"; "if this note and the spec disagree, spec wins."
     - [25](docs/research/agent-polish-vision/25-ui-polish-critique-rubric.md): same UI-brief / spec §10/§15 authority; "brand in words (guild chat + private toasts); custom gothic/heraldry only after V1 earns it" (contradicts Law 10).
     - [00-SYNTHESIS.md](docs/research/agent-polish-vision/00-SYNTHESIS.md): "design spec / glossary → UI agent brief" as the authority stack; F1 = "V1 spectacle = throttled officer `/g` + private edge toast."
     - [30](docs/research/agent-polish-vision/30-writing-effective-agent-goals.md): "Spec / glossary / `Data/Ranks.lua` win over this note."
   - A fresh UI agent told to follow AGENTS → skill § Polish loop hits [42] on step 2 and is told the product is the retired ladder-plus-toasts V1. The skill no longer *states* that; it still *sends* it.
   - Required change (pointer-only, do not rewrite the loop): drop or relabel those research links as historical; do not send polish agents through [42]/[25]/[00-SYNTHESIS] until those notes are retargeted at the Bible. Out of lane to edit the research files.

2. **Law 7 identity half is absent from both maps.** (Law 7 / Bible §12; Audit V6; brief README "remove per-character alts-start-fresh"; brief AGENTS "Key don'ts: Ten Laws.")
   - README deleted "per-character `ChurchOfBeefDB`; alts start fresh" and did not state the replacement: account-level identity; rank belongs to the human; Gora records belong to the character.
   - AGENTS compresses Law 7 to "Church history is never deleted" and drops the same clause. Neither file mentions account-level SV.
   - Mitigated by `identity-records` in the AGENTS domain table. A maps-only read (README + AGENTS key don'ts) can re-default unlinked alts to Fresh Beef — per-character-as-law with better branding.
   - Required: one Law 7 identity sentence in AGENTS key don'ts (and preferably README). Do not invent linking UX.

### Minor

1. **Skill §0 still prefers `.worktrees/feat-church-of-beef-v1`.** (Brief AGENTS: addon lives at `addon/ChurchOfBeef/`; skill keep-the-loop.) Operational, not product law. Writer report already notes it. Stale checkout risk if `tests/run.lua` is missing from cwd.

2. **Skill discovery copy still leads with "toasts/announce feel."** (Law 6 / §4.8 / §19.1.) Frontmatter and the polish-loop heading advertise toast work. The loop body says Quiet Mode stays silent. Event Mode notices are legal; grant-toast polish is not. Name the mode before toast work.

3. **AGENTS Ten Laws line drops Law 3's officer clause.** "Pope holds ceremonial sovereignty" is present; "Officers/Council support operations; they do not perform rituals" is not. Live addon still has an Officer tab. `pope-authority` is in the domain table.

4. **Lane L report did not flag the research-link send path.** Removals list for the skill is otherwise accurate (UI brief, design spec §10/§15, canvas, Media/SFX V1 ban, Officer+/Member two-client, "never claim V1 complete").

## Confirmed (attacks closed — not findings)

| Check | Result |
|-------|--------|
| README product paragraph | Ceremony, Gora, Pope as performer, memory; "not another game inside WoW" (§1). Software is the stage manager. |
| Rank table | Six Law 9 / §5 titles; relationship one-liners match §5 catchphrases; Butcher display-only; no thresholds; Pope is not a rank. |
| Bans | No points/XP/currencies/dailies/streaks; no activity leaderboards; no ELO/MMR; Gora is an unmodified duel. |
| Quiet Mode | Minimap + Decree; Decree forthcoming, does not ship today. |
| Install / `/beef` / safety / tests / `20506` | Kept. `./scripts/install-anniversary.sh` exists. |
| Removed README leftovers | Standing tabs, officer approve/reject, Prophet-as-rank, alts-fresh, "no custom Media," excommunication spectacle, `docs/superpowers/specs/…` as design spec. |
| Definition of done | Exact §22.3 Gathering blockquote. "Demo is not done." Offline tests cannot prove it. |
| Design law links | Bible, Adjudication, Audit; archive historical only. |
| AGENTS workspace | `Beef_Addon` root; addon at `addon/ChurchOfBeef/`; `.worktrees/` optional isolation only. |
| AGENTS where-to-look | Bible first; Adjudication; Audit; Reformation log; archive historical; research ≠ law; Bible wins on conflict. |
| AGENTS rules table | Always-on / domain / engineering / `ui-juice-standards` match the brief. Lane C layer line present. Rank line is Bible §5 / `Data/Ranks.lua` after Phase 1. |
| Slash | No invented verbs. `/beef minimap` exists in `ChurchOfBeef.lua`. |
| Skill direct pointers | No `ui-polished-direction-for-agents.md`; no "product law stays in the UI brief + design spec"; CreateFrame prerequisite is Bible §19.3 + `ui-juice-standards.mdc`. Install/reload/test loop kept. |
| Writer do-nots | No commit. `.cursor/rules` not touched. |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` (Laws 1, 6, 7, 9, 10)
- `docs/reformation/phase-0/briefs/L-maps.md`
- `docs/reformation/phase-0/reports/L-maps.md`
- `README.md`, `AGENTS.md`, `.cursor/skills/church-of-beef-dev/SKILL.md`
- Bible §1, §5 (full rank set), §12 (identity), §19.3, §22.3
- `addon/ChurchOfBeef/ChurchOfBeef.lua` slash handler (`/beef`, `/beef minimap`)
- Skill-linked research: `00-SYNTHESIS.md`, `42-v1-vs-v2-juice-scope.md`, `25-ui-polish-critique-rubric.md`, `30-writing-effective-agent-goals.md` (authority stacks only)
- `CURSOR_REWORK_HANDOFF.md` §0, §2, §3 maps bullet
