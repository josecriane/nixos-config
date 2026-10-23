## Commits

### Message format

Subject line: `<type>: <subject>`, imperative mood, under 72 characters, no
trailing period.

```
feat: move connection tracking out of the supervisor
```

The subject after the prefix is imperative, as if completing "this commit
will ...". Not `feat: moved`, not `feat: moves`.

Conventional-commit prefixes are required: `feat`, `fix`, `chore`, `docs`,
`refactor`, `test`, `perf`, `build`, `ci`. A scope in parentheses is fine
when it adds information: `fix(supervisor): ...`.

Body, when the subject is not self-explanatory: plain prose, wrapped at 72
columns, explaining why rather than what. The diff shows what. Body prose
follows `rules/simple-english.md` (ASD-STE100).

### One change per commit

One logical change per commit. A bug fix is one commit. A feature is one
commit. Two features are two commits. Each commit compiles and passes the
tests on its own, so that `git bisect` always lands on a working tree.
Split a preparatory refactor from the change that needs it.

### Not allowed

- Bullet lists enumerating every file touched.
- `Co-Authored-By` trailers and `Generated with` footers. Add nothing to the
  trailer block that was not asked for.
- Emoji, and ticket numbers unless the repository already uses them. Match
  the existing log.
- Restating the diff in prose.
- Mentioning the conversation, the request, or the tooling that produced
  the change.

### Git conduct

An agent never runs a git command that writes to history, the index or a
remote. It proposes the message and the person commits. The points below
are for the person.

- Never amend, rebase or force-push a commit that is already pushed.
- Never add files to a commit that are outside the change. Check
  `git status` before staging and stage paths explicitly rather than using
  `git add -A`.
- Never modify `.gitignore` to make an unwanted file disappear from
  `git status`.

Before committing, read the diff. If it contains a change you cannot
explain in terms of the change you are making, take it out.
