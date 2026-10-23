## Contributions with AI tools

You can use AI tools for any part of the work. The result must meet every
rule in this document, the same as work written by hand. These rules exist
for two reasons. Respect: the people who review your work must not spend
their time on output that you did not read. Accountability: a tool cannot
be held accountable for what it generates. The person who submits it can,
and is.

### Review before you submit

- Do not open a pull request, request a review, commit, or send to anyone
  content that a tool generated and that you did not review with care. This
  covers code, tests, documentation, commit messages, pull request comments
  and chat messages. If you do not review your own work, do not expect
  others to review it for you.
- You must understand every line you submit, and you must be able to
  explain it without the tool. The engineering and design decisions in a
  change are yours. You own their consequences.
- AI assistance is assumed and needs no label. A translation that a
  speaker of the target language did not review carries the line
  "Translated from <language> using AI" at the top of a message or at the
  foot of a document.
- Do not add `Signed-off-by` from a tool. Only a person certifies a
  Developer Certificate of Origin.

### What to check in generated code

Tools make the same mistakes again and again. Check each of these before a
review:

- The code follows the architecture and the style rules of this
  repository.
- The code reuses the functions, modules and libraries that exist. Tools
  ignore what exists and write a second copy. A second copy is not
  accepted.
- The tests and the implementation of a component change in separate
  steps. Write the failing test first. Never let a tool edit a test so
  that an implementation passes.
- The code has no comments in function bodies and no commented-out code.
  Tools flood code with both. Delete them.
- Documentation and messages are short. Tools write long. Cut everything
  that carries no fact.

### Validation is deterministic

Style, format and rule checks run as scripts, in CI and in hooks, not as an
agent that reviews its own output. A tool can help to write those scripts.
The scripts then run without it.

Prefer a deterministic generator from a specification, for example an
OpenAPI generator, over code that a tool writes by hand from the same
specification.

### Unsupervised generation

Code generated without review is not accepted in this repository.
