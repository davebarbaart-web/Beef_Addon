# Alts and same-account identity

**Track:** 25 · **Last updated:** 2026-07-25

## 1. Spec stance (locked for V1)

- Database: `ChurchOfBeefDB` via **SavedVariablesPerCharacter** ([design spec §9](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).
- **Alts are separate characters.** New alt → Fresh Beef, zero standing. On-brand (“the flesh must prove itself anew”).
- Account-level rank merging is **open question §16.1**, not a silent implementation detail.

TOC mapping ([TOC Saved variables](https://warcraft.wiki.gg/wiki/TOC_format)):

| Directive | On-disk location |
|-----------|------------------|
| `SavedVariables` | `WTF/Account/<account>/SavedVariables/` — all chars on that account (same install tree) |
| `SavedVariablesPerCharacter` | `WTF/Account/<account>/<server>/<character>/SavedVariables/` |

Blizzard forum guidance matches this split: account-level SV for shared configs / gold aggregates; per-character SV only while that character is loaded ([Anyone know how Saved Variables work?](https://us.forums.blizzard.com/en/wow/t/anyone-know-how-saved-variables-work/1388757)).

## 2. AceDB mental model (even if Beef stays non-Ace)

[AceDB-3.0 Tutorial](https://www.wowace.com/projects/ace3/pages/ace-db-3-0-tutorial) namespaces:

| Namespace | Who shares it |
|-----------|----------------|
| `char` | One character (`"Name - Realm"` key) |
| `realm` | All of *your* chars on that realm |
| `factionrealm` | Your chars, same faction + realm |
| `global` | Entire account (this WTF tree) |
| `profile` | Whichever chars opt into that named profile |

Useful later if UI prefs move to account SV while ladder cache stays character- or guild-scoped. **Do not** put officer-authoritative ladder state only in a swappable cosmetic profile (also noted in [05-persistence-and-profiles](../05-persistence-and-profiles.md)).

## 3. What “same account” can and cannot mean

### Can (local client)

- Share UI mute/announce prefs across *your* alts via account `SavedVariables`.
- Store an optional **personal** “main character” note for yourself.
- Copy WTF folders between your own characters (manual; see rename/transfer note).

### Cannot (without new product features)

- Prove to other guild members that two roster names are the same Battle.net account.
- Auto-merge standing when an alt logs in.
- Sync alt links across Dreamscythe ↔ Doomhowl (different realms, different guilds, different BeefNet meshes).
- Share SV across Anniversary vs Era/Hardcore install trees (separate clients / WTF roots — see persistence research).

## 4. Alt policy options (for §16.1 decision)

| Option | Behavior | Pros | Cons |
|--------|----------|------|------|
| **A. Doctrine forever (V1 default)** | Each toon earns Fresh Beef alone | On-brand; simple keys; no abuse of “bank alts inherit Prophet” | Mains with many alts dilute spectacle if every alt farms suggestions |
| **B. Officer-linked alts** | Officer maps alt → main; display collapses; standing stays on main | Social truth matches streamer reality | Needs UI + sync of link table; grief if wrong link; still no Blizzard proof |
| **C. Account SV standing pool** | Points shared across alts on account | Convenient for multi-boxers in same guild | Breaks “flesh proves itself”; easy to inflate via alt army; only works for *your* client’s alts |

**Research nudge:** Prefer **A for V1**, keep **B** as the only plausible V2 if leadership wants streamer main/alt UX. Avoid **C** unless doctrine explicitly changes — it fights the hybrid officer-gate story (standings are already self-reported testimony).

## 5. Scoring / suggestion edges with alts

- Co-play credit is guildmate-in-instance, not “same account.” Two alts of the same player in one dungeon are two characters if both are present — rare, but do not special-case.
- A player who mains on Dreamscythe and parks a Doomhowl alt is in **two churches**; no shared standing by design.
- Pending suggestions are per-character SV in V1 — officer on alt does not automatically see suggestions queued while on main unless suggestion-queue sync is extended (§16.5) **and** they are online on a character that receives GUILD traffic for that guild.

## 6. Guild README implication

Document explicitly: “Alts start at Fresh Beef. This is not a bug.” Prevents support noise that looks like SV corruption.
