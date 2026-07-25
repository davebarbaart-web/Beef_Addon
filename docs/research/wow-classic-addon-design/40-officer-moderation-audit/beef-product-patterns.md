# Product patterns for Beef

**Purpose:** Condense this track into V1 vs later recommendations. No implementation.

---

## V1 — ship with the Officer tab (minimal)

| Pattern | Behavior |
|---------|----------|
| **Decision row** | Pending: player, ranks, standing, short event breakdown, Approve / Reject |
| **Confirm high-risk** | Demote, standing wipe, Prophet, Council appoint → confirm + required short reason |
| **Reject clarity** | Clear suggestion; copy that points remain; optional reason enum |
| **Actor stamp** | Every official record shows `updatedBy` + time (ladder tooltip / My Standing) |
| **Recent actions** | Officer-only last N approve/reject/demote/adjust rows (local + synced commits) |
| **Compensating undo** | No delete-history; use demote / re-approve / standing adjust; link reason “correction” |
| **Announce hygiene** | Keep promote/demote guild lines; corrections get a short line when the original was public |
| **Threshold docs** | One help blurb: advisory standing, officer gate, appointed top ranks |

These map directly onto locked spec surfaces (§7.3, §10, §8.3) without new protocol types if Recent Actions is derived from applied `RANK_COMMIT`s plus local reject log.

---

## V1 — nice if cheap

| Pattern | Note |
|---------|------|
| Reject reason synced to other officers | Helps §16.5 pain |
| “Implausible standing” soft badge | Advisory only |
| Member sees last reject reason on My Standing | Cuts Discord ping loops |

---

## Explicitly later (post-V1)

| Pattern | Why later |
|---------|-----------|
| Full `/beef audit` export (CSV) | RCL-export energy; officers survive without it at launch |
| Dual-officer ack on Prophet / wipe | Four-eyes; offline officers make this painful |
| Suggestion-queue login sync | Spec open question §16.5 — do when officers miss suggests |
| Grow-only shared audit log message type | Only if local Recent Actions + commits prove insufficient |
| Auto heuristics that punish “cheaters” | Against §6.3 comedy stance |
| Binding ladder to Blizzard officer notes | CEPGP pattern; wrong for addon-layer ranks |

---

## Steal / avoid map

| Steal | From | Avoid |
|-------|------|-------|
| History row with reason + filters mindset | [RCL Loot History](https://rclootcouncil.com/wiki/Loot-History) | Mass delete, no-undo delete, loot column density |
| Undo = reverse then re-apply | [RCL↔EPGP undo GP](https://groups.google.com/g/epgp-discuss/c/cI3TwSHD3ZM) | Silent SV surgery |
| Traffic / searchable modifications | [CEPGP traffic](https://wowup.io/addons/475100) | Officer-note as database |
| Member-readable standing | CEPGP `!info` whispers | Requiring officers online for *read* |
| Before/after + actor in audit | [Stream policy audit logs](https://www.prlog.org/13138222-feature-announcement-moderation-policy-audit-logs.html) / [Flagsmith](https://www.flagsmith.com/blog/what-is-the-four-eyes-principle) | Bank-grade dual control on every Cooked Beef |
| Written rubric + public log norm | [Guild Order LC](https://guildorder.com/games/wow/guides/loot-systems-dkp-vs-epgp) | Opaque “officer discussed it” |
| Approve/reject queue IA | [01 loot](../01-ux-patterns/loot.md), [13 cousins](../13-cousin-addon-teardowns/) | RCLootCouncil voting chrome for V1 |

---

## Spec pressure points (for decisions log, if adopted)

1. **Reject audit sync** — today reject may be local-only; officers who weren’t online lack shared memory.  
2. **Announce opt-out vs stealth demote** — consider forcing audit visibility even when chat announce is off.  
3. **Reason required** on demote/wipe/Prophet — product rule, not protocol.  
4. **Correction announce** — not in V1 spec; small spectacle patch when undoing public promotes.

Do not fork policy silently: if these become locks, update the design spec decisions log per library README.

---

## One-line product doctrine

**Standing is testimony; commits are law; audit is the alibi; undo is another commit; trust is a guild process the addon can only illuminate.**
