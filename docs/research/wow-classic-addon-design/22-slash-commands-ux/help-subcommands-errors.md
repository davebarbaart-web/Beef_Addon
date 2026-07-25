# Help text, subcommands, and error messaging

**Last updated:** 2026-07-25

## Community norms

Successful guild/tools addons teach a single discovery verb:

| Addon | Pattern | Source |
|-------|---------|--------|
| Gargul | `/gl` opens GUI; `/gl help` for the rest; short verbs (`sr`, `tmb`, `pm`) | [addonswow.com/gargul](https://addonswow.com/gargul) listing |
| Guild Recruiter | `/gr` or `/recruiter help` | [CurseForge Guild Recruiter](https://www.curseforge.com/wow/addons/guild-recruiter) |
| Ace WelcomeHome tutorial | empty → options GUI; else AceConfigCmd | [Ace3 Welcome Home / Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started) |

Wiki howto’s complex example: parse `cmd` + `args`; **else** print `Syntax: /yourcmd (add|remove) …` ([Wowpedia](https://wowpedia.fandom.com/wiki/Creating_a_slash_command)).

## Help text design (slash-specific)

Good Classic help in chat is:

1. **Short** — chat frame is narrow; 4–8 lines max for top-level help.
2. **Role-aware** — members see member verbs; officers get an extra section (or one tagged line).
3. **Syntax-first** — `Usage: /beef [help|ladder|standing|officer|…]`.
4. **Actionable** — each line maps to something that works *now*, not V3 lore.
5. **Branded prefix** — `|cffffaa00Church of Beef|r:` (matches plan stub tone) so messages are greppable in noisy chat.

Avoid dumping AceConfigCmd’s full nested options tree into chat for V1 (that path exists when you register options with slash aliases — [AceConfigCmd](https://www.wowace.com/projects/ace3/pages/api/ace-config-cmd-3-0); [AceConfig RegisterOptionsTable third arg](https://www.wowace.com/projects/ace3/pages/getting-started)).

## Subcommand parsing patterns

| Approach | Pros | Cons | Beef V1 |
|----------|------|------|---------|
| Exact `msg == "help"` | Simple | No args | Fine for toggles |
| `msg:match("^(%S*)%s*(.-)$")` | Standard wiki | Case / locale | **Preferred** |
| AceConsole `GetArgs` | Quotes + itemlinks | Ace dependency | Later if needed |
| AceConfigCmd `HandleCommand` | Free Tab + nested opts | Heavy; chat noise | V2+ settings |

Normalize: trim, `lower()` on the verb only; keep player names case-sensitive if ever passed as args.

Unknown verb → print help (wiki pattern), not a sarcastic meme (spectacle lives in guild announce, not error UX).

## Error messaging matrix (slash surface)

Align with design spec §11, but expressed as **chat lines** players see when they typed something:

| Situation | Slash behavior | Chat copy (intent) |
|-----------|----------------|--------------------|
| UI not ready | No toggle | Plan stub: `UI not ready yet. (version)` |
| Unknown subcommand | Show help | `Unknown command. Type /beef help.` + syntax |
| Not in a guild | Allow open; optional warn | Soft: scoring paused — don’t block frame open |
| Not Officer+ using officer verb | Soft-deny | `Officers only.` (no stack dump, no silent ignore) |
| Roster not ready for officer check | Soft-deny / retry | `Guild roster not ready; try again.` |
| Debug while `COB.DEBUG` false | Pretend unknown | Same as unknown — **do not advertise debug** |
| Debug while true | Execute + confirm | `Debug: standing set to N` (local only) |
| Thin stub (`gora` / `ceremony`) incomplete | Honest stub | `Not available yet` or open stub UI — never fake credit |

Silent no-ops are the enemy: they reproduce the historical “slash works, nothing appears” failure mode the spec explicitly fixes for the main frame.

## What not to put in slash errors

- Lua errors / `scriptErrors` dumps as the only feedback (QA track owns that).
- Officer roster details that help forgers.
- Multi-line scripture (footer belongs in the frame).
- Duplicate guild-chat spam when a slash fails (errors stay in default chat frame for the typer).
