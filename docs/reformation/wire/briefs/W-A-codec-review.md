# W-A — Codec review

**Reviewer:** `16952c2b-f8c2-4cb4-9691-ea262048b18f`
**Gate:** task-scoped (not a merge review)
**Verdict:** **PASS**

Reviewed `docs/reformation/wire/briefs/W-A-codec.diff` only. Closed types are four (`DECREE` added). Favor INPUT requires `pick`. Optional STATE / SNAPSHOT-response favor is omitted when off. HELLO stays on the transport.

## Important follow-on (integrator, before live send)

Encode now refuses an embedded newline in decree `line` (`invalid line`) and in `flavor` (`invalid flavor`) so the flavor split cannot silently rewrite a stored line. Not a spec miss; not a fifth type.
