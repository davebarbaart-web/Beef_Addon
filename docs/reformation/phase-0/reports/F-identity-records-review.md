# Phase 0 Lane F — Adversarial identity-records review

**Spec compliance:** PASS
**Quality:** Changes required

No Critical Bible contradiction. Rule not edited. The seven attack surfaces are closed at statement level. Holes remain that would let a later agent rebuild per-character identity or name-reuse collision without clearly tripping a banned row.

## Verdict

`.cursor/rules/identity-records.mdc` does not contradict Bible §12, §13.5, §17 or Law 7. Self-service linking, per-character-as-law, sweeps/expiry, a second Archive writer, Curtain-hiding of ritual results, an invented export format or human-id schema, and `Names.Key`-as-the-human are all banned or left uninvented.

Spec still PASSes. Quality is **Changes required** because §12.4 is implemented only as a human-link ban, Curtain is not tied to never-delete at the store, and Church rank is not nailed to the human row. Those are the paths that rebuild Audit V6.

## Critical

None. Rule not edited.

## Important

1. **`Names.Key` is banned as the human, not as the character.** (Bible §12.4; Law 7)
   - Non-negotiable: Key/Display "do **not** prove the same human or link alts."
   - Banned row: "Treating a name string (or `Names.Key`) as the human."
   - §12.4: "internal **character** identity is more than a name string." Freed names can be re-created. If Phase 1 keys Gora/character rows by `Names.Key`, the new Chuckroast inherits or collides with the tombstone. That is name reuse, not alt-linking.
   - Handoff Phase 2 says keep `Common.lua` Names.Key/Display; `addon-module-layers.mdc` still calls them "identity keys." Agents will key tables by Key unless this rule forbids it as *durable character identity*.
   - Required change: extend the ban to "do not use a name string or `Names.Key` as the durable character identity." Do not invent a replacement key (human-id / character-id schema stays out of scope).

2. **§12.2 rite shape flattened to a silent admin bind.** (Bible §12.2; Adjudication "Rite of Recognition")
   - Bible: "a thirty-second Rite of Recognition in which the alt kneels and is formally bound."
   - Adjudication: "the alt kneels, is acknowledged, and is bound."
   - Rule: "short ritualized Rite of Recognition."
   - Not self-service (still Pope or Council + logged-in character). It is the administrative Link button §12.2 exists to prevent. Restore kneel / ~thirty-second / formally bound from the Bible. Do not invent widgets.

3. **Curtain is not tied to never-delete.** (Bible §17; Law 7 / §12.3)
   - Rule correctly excepts rank, Knighting, and sanctioned Gora results from Curtain. Attack "Curtain hides ritual results" fails.
   - Curtain is never stated as display-only at the store. "Opt out of *displayed* witnessed activity" can be read as drop the row.
   - That is a departed sweep by another name. Required sentence: Curtain changes display only; the witnessed record remains.

4. **Church rank can still land on the character row.** (Bible §12.1; Audit V6; Law 7)
   - Human owns Church rank. "`SavedVariablesPerCharacter` as product law" and "alts start fresh" are banned.
   - Nothing says rank is never a character-row field, or that an unlinked alt must not be defaulted to Fresh Beef.
   - That default is per-character-as-law with better branding. Required: Church rank is stored on the human, never on the character. Do not invent unlinked-character rank display (OPEN_QUESTIONS if a later phase needs it).

## Minor

1. **Archive import console is unnamed.** (Bible §13.5; Law 5 / §13.1)
   - "Console: one-action export and restorable import" does not say Pope console. Council import-then-broadcast is a second writer.
   - Mitigated by "One writer remains the Pope's store" and "not a second writer." Say export/import are Pope-console actions; the cold mirror never imports into authority.

2. **§17 public list is incomplete.** (Bible §17)
   - Dropped: profession capabilities (self-reported), significant contributions.
   - Omission, not a hide-permission. Restore the Bible list.

3. **Archive weekly reminder has no mode.** (Law 6 / §19.1; Bible §13.5)
   - Every UI feature declares Quiet Mode or Event Mode. Reminder is Pope console, cold only, never congregation toast/pip. Say so. Do not invent widgets.

4. **Council confirmation vs one writer is unhooked.** (Bible §12.2, §13.1, §13.3; Law 3, Law 5)
   - §12.2 names Council as a confirmer. That is not a Law 3 ceremonial verb (Knighting, sanction, verdict, elevation, canonization).
   - Confirmation is not a Council-authoritative store write. Do not invent the wire. OPEN_QUESTIONS #8 already covers designated-Council configuration.

5. **Globs omit `UI/**`.** (brief frontmatter; §17 Curtain / §12.5 profile)
   - Core/Data/TOC/docs match the brief. Curtain, profile, Records Book are UI. Those edits may never load this rule.

6. **Account-level SV is cited to §12.1.** (Bible §13.1; Audit V6 / §6.3; handoff Phase 2)
   - §12.1 is hybrid identity, not a TOC key. §13.1 is per-client persistence (Pope's machine). Account-level `## SavedVariables:` is Audit/handoff packaging that serves §12.1. The ban on PerCharacter-as-law is correct; the cite should include Audit V6 so agents do not over-read §12.1 as a file-format verse.

## Confirmed (attacks closed — not findings)

| Attack | Result |
|--------|--------|
| Self-service linking | Banned. Rite only; logged-in character; no BattleNet/account-id auto-linker; same-account auto-bind in the BAD example. |
| Per-character-as-law | Account-level `ChurchOfBeefDB`; `SavedVariablesPerCharacter` / "alts start fresh" not law. (Character-row rank still a hole — Important 4.) |
| Sweeps / expiry | `SweepDeparted`, 14-day grace, prune, departed purge, record expiry, wipe-on-leave/delete/inactivity, auto-restore rank, expiry-to-keep-SV-small all banned. Tombstones / inactive flags only. |
| Second Archive writer | Cold mirror read-only DR; one writer = Pope's store; mid-ceremony Archive nag banned. |
| Curtain hiding ritual results | Rank, Knighting, sanctioned Gora results not curtainable. Banned row matches §17. |
| Invented export format or human-id schema | Out of scope. `file/string` is Bible §13.5. No encoding, no human-id key. |
| `Names.Key` treated as the human | Banned. Key/Display = spelling normalization only. (Durable *character* key still a hole — Important 1.) |

Writer report (`F-identity-records.md`): bans table matches the rule. OPEN_QUESTIONS not edited (Curtain UX already #4). No commit. No Lua edited (Phase 0 correct).

Writer concern that `build-packaging.mdc` still forbids account SV is **stale** — that keeper now states account-level `ChurchOfBeefDB`. Remaining leftovers are out of lane: `Core/Common.lua` still says Key answers "is this the same person"; `addon-module-layers.mdc` still says Common owns "identity keys."

## Sections checked

- Brief `F-identity-records.md` (must-include, do-not-invent, report contract)
- Rule `.cursor/rules/identity-records.mdc` (full)
- Report `F-identity-records.md`
- `TEN_LAWS.md` Laws 3, 5, 6, 7
- Bible §12.1–12.6, §13.1, §13.3, §13.5, §17, §18.3, §4.9, §10.9, §14.2, §19.1
- Adjudication: Sacred Archive; Curtain; Rite of Recognition
- Audit V6; Audit §6.3 (account-level SV)
- Handoff Phase 2 (store, Archive, keep Names.Key/Display)
- `OPEN_QUESTIONS.md` #4, #8
- Cross-rule: `build-packaging.mdc` SV, `wow-performance.mdc` SV cap, `pope-authority.mdc` rituals vs operations, `addon-module-layers.mdc` "identity keys", `architecture-overview.mdc` SV direction
- `Core/Common.lua` Names.Key/Display comments (not edited)
