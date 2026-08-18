# B3-D — Console proposed bout + stipulation (stock)

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Gora, Toasts. Do not commit. Console stays **stock-pragmatic**. No parchment. No jokes.

## Law

Batch 2 Console ask: a **proposed bout** slot above SANCTION (`Name vs Name`) plus a one-line **STIPULATION** `InputBoxTemplate`. `Console:Sanction()` already forwards a 3rd arg — read `frame.Stipulation:GetText()` when the arg is omitted.

```lua
Console:GetProposedBout()  -- { fighterA, fighterB, label } or empty
```

`label` is `"NameA vs NameB"` from Store names when both ids are selected; else `""`. Refresh paints `frame.ProposedBout`.

Do not call Net. Do not add a winner picker. Isolation under `if standalone then`.

## Tests

Select two fighters → GetProposedBout has both ids. Sanction() with text in the stipulation box reaches Gora (result.stipulation trimmed). Empty box omits / nil stipulation. Existing favor/decree/free-ruling pins stay green.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B3-D-console-bout-report.md` + diff.
