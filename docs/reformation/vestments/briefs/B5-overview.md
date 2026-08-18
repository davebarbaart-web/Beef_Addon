# Batch 5 — Knighting line, markers, console verbs

**Cited:** Bible §8, §9, §10.2, §18.1, §19.3; CONTINUE license 4 (stock only). Do not invent SUMMON, GuildPromote (A04), Notebook persist, extra codec kinds, or a Pope name.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B5-A | `Core/Knighting.lua`, `tests/test_knighting.lua` | Memory-only knighting **line** (not `queue` / `AdvanceQueue`) |
| B5-B | **new** `UI/Markers.lua`, `tests/test_markers.lua` | Target + raid marks; Event + Pope; fail-closed |
| B5-C | `UI/Console.lua`, `tests/test_console.lua` | Line desk, Recommend, CallForward, zone FlagMoment |
| B5-D | `UI/Toasts.lua`, `tests/test_ui.lua` | MORPHEUS headlines on theater; keep clerical copy |
| B5-E | `UI/Inputs.lua`, `tests/test_inputs.lua` | Event `Catchup()` → `Net:RequestSnapshot(target)` |

Writers do not edit TOC, `ChurchOfBeef.lua`, `tests/run.lua`, `OPEN_QUESTIONS.md`, or the log.
