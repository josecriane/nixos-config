## Code Comments

Do not add comments to code. No explanatory comments above a block, no
trailing comments on a line, no section banners, no comments justifying why an
approach was chosen. Naming and structure carry the meaning.

Put the reasoning in the reply instead. If a piece of code needs a comment to be
understood, make the code clearer.

Applies to every source file, and to configuration files written in a
programming language. Documentation files under `docs/` and `README` files
follow the project-documentation rule instead.

### Allowed

Only these:

- A comment the user explicitly asks for.
- A marker the project's own conventions require, such as the
  `# STIG V-XXXXXX:` markers in nixos-config.
- A licence header.
- Tool pragmas, which are not comments even though they look like one:
  formatter and linter directives, compiler attributes, shebangs
  (`# type: ignore`, `# noqa`, `//go:build`, `# shellcheck disable`,
  `eslint-disable`). The language section lists them.
- Type and contract declarations of the language: specs, types, callbacks,
  interface signatures. The language section lists them.
- Documentation attributes and doc comments of the language, where the
  language section asks for them.
- Doctests inside documentation attributes, where the language has them.
  These are executable tests, not comments. Never strip them.

### Not allowed

- Inline comments restating the next line.
- WHY comments, including one-liners on an override, a cast or a discarded
  result. Say why in the reply.
- Section dividers: `%% --- helpers ---`, `# ====`.
- `TODO` or `FIXME` without an issue reference in the same line.
- Commented-out code. Delete it.
- Comments referencing the current task, PR, caller, or conversation.
- Comments explaining that a comment was removed.

### Existing comments

Existing comments in a file stay as they are. Do not delete or rewrite them
unless asked, and do not treat this rule as licence to strip a codebase.
