## Project Documentation

Document the system as it is now, declaratively. Describe architecture the
same way as any other feature: what exists, how it fits together, how to
use it. Present tense, current state only. Write as if the docs had always
described this reality.

### Allowed

- Present-tense description of components, data flow, interfaces, and
  commands as they currently work.
- Constraints and invariants that hold now. A standing "X must match Y" is
  current state, not a decision narrative.
- One short WHY for a non-obvious constraint or workaround.
- Version and platform requirements: "Requires OTP 27", "Postgres 16 for
  the `MERGE` path". These are current state.
- Deprecation of an API that carries `@deprecated` in the source. Docs
  match reality. What is banned is speculative deprecation, not factual.

### Not allowed

- Decision narrative: "we chose X over Y", "originally A, then B".
- Dates, "as of <date>", version-of-the-week framing.
- References to plans, roadmaps, tickets, PRs, or RFCs.
- Transitional status: "in progress", "being removed", "deprecated soon",
  "temporary", "WIP", "TODO".
- Changelog or history prose. Git and CHANGELOG own history.
- Future intent: "we will", "planned", "eventually".

### Files

Update existing files. Do not create new documentation files unless asked.
No `IMPLEMENTATION_SUMMARY.md`, `MIGRATION_NOTES.md`, `ARCHITECTURE_V2.md`,
or any file whose purpose is to narrate work that was just done.

Keep each file under 300 lines. If a document outgrows that, the system
probably needs splitting, not the document.

### Editing

Rewrite the affected section to describe the new reality cleanly. Delete
superseded prose rather than appending "now changed to...". Do not narrate
the edit. Do not rewrite sections you were not asked to touch.
