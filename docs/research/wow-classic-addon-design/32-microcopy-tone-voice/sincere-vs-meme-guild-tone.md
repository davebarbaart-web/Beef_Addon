# Sincere vs meme — Classic guild-tool tone

**Maps to:** Spec §3.3 brand context; implications note that V1 spectacle is social reaction, not chrome.

## The spectrum

| Pole | What it sounds like | Classic examples |
|------|---------------------|------------------|
| **Sincere / procedural** | Clear verbs, player names, item/rank facts, opt-out settings | Attune surveys; Gargul loot/award announces; RCLootCouncil consideration flows |
| **Liturgical comedy** (Beef target) | Deadpan institution voice; absurd lexicon used *sincerely* | Spec announce: “The Church recognizes…” |
| **Meme / gag spam** | Random jokes, internet slang, forced punchlines every event | Standalone joke addons ([DadJokes](https://www.curseforge.com/wow/addons/dadjokes), [ChuckNorris](https://www.curseforge.com/wow/addons/chucknorris)) — *not* loot/rank machinery |

Successful guild tools cluster hard on the left. Humor, when authors want it, is productized separately — Gargul’s author ships DadJokes as a different CurseForge project that “send[s] a random dad joke to any chat channel,” not as Gargul’s default announce voice ([Gargul](https://www.curseforge.com/wow/addons/gargul); [DadJokes](https://www.curseforge.com/wow/addons/dadjokes)).

## What “sincere” looks like in practice

### Attune — earnest utility

CurseForge copy is plain: collect progress, show quest chains, survey the guild, plan raids ([Attune](https://www.curseforge.com/wow/addons/attune)). Closing blessing (“may the Earth Mother protect you all”) is author personality in the *download page*, not injected into every UI string. Blizzard-forum launch posts sell usefulness to raid leaders, not comedy ([Attune forum thread](https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832)).

**Steal:** Onboarding and officer tooling speak like a clerk: what happened, who is affected, what to do next.

### Gargul — transparent speed

Marketing and wiki emphasize walkthroughs (`/gl start`), hotkeys, soft-res/TMB facts, and **announce trades for transparency** ([Gargul on CurseForge](https://www.curseforge.com/wow/addons/gargul); [Announcing Loot in Chat](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat)). Default chat posts are loot facts + soft-reserve names; players can disable announce, raise quality threshold, or strip soft-res detail.

**Steal:** Opt-out, quality gates, one authority speaker. Voice stays factual so the raid trusts the bot-line.

### RCLootCouncil — accountable council voice

Positioned as structured voting, history, and defensible awards — “Interface for running a Loot Council” ([RCLootCouncil](https://www.curseforge.com/wow/addons/rclootcouncil)). Comparison writeups stress transparency after loot drama ([RCLootCouncil vs Gargul](https://medium.com/@rengo_wow_world_of_warcraft/rclootcouncil-vs-gargul-which-wow-loot-addon-should-you-use-f99ac760e944)). Response buttons are customizable guild *policy* labels (Mainspec/Need, etc.), not jokes.

**Steal:** Officer-facing response vocabulary is serious customizable doctrine. Comedy belongs in *guild culture*, not in default button text that confuses new officers.

### Total RP 3 — sincere about freedom, not “funny UI”

TRP3 markets simplicity and freedom to define characters, modular features, mature-content filtering — a serious RP instrument ([Total RP 3 README](https://github.com/Total-RP/Total-RP-3)). Players bring their own humor in profiles; the addon chrome does not meme at them.

**Steal for Beef:** Let the *rank titles and announce liturgy* be funny; keep settings, errors, and sync copy straight.

## Why meme-default fails guild tools

1. **Trust tax.** Loot and rank decisions invite drama. Procedural tone is the social lubricant; jokes in the critical path sound like favoritism or mockery of the loser.
2. **Spam fatigue.** Guild chat is shared attention. A joke on every standing tick trains players to `/ignore` the addon voice.
3. **Dating.** Memes age; liturgical formulas (“The Church recognizes…”) stay on-brand for years.
4. **Addon-less members.** Spec requires announces visible without Beef installed. Obscure meme references exclude half the flock.

## Implication for Church of Beef

Beef is a **comedy guild product**, so it should *not* sound like a spreadsheet — but it should borrow the **sincere delivery** of Attune/Gargul/RCLC:

- The *content* is absurd (Beef Knight, excommunication, Eternal Grazing).
- The *delivery* is institutional and confident (as if the Church believes every word).

That is **liturgical deadpan**, not **meme mode**. If officers want gag spam, that is Discord/stream culture or a future opt-in “Beef Joke” slash — not the default promotion announce.

## Quick heuristic

| Question | If yes → |
|----------|----------|
| Would an officer paste this into raid chat during loot drama? | Keep sincere |
| Does the line only work if you know last week’s meme? | Cut it |
| Is the absurdity in the *title/institution*, not in slang? | Keep |
| Is this an error, confirm, or sync warning? | Zero jokes |