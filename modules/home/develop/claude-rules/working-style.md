## Git

Never create commits. Do not run `git add`, `git commit`, `git push`, `git
tag`, or anything else that writes to history or to a remote. This holds even
when the task obviously ends in a commit, when a previous commit in the session
was approved, and when asked to "finish" or "ship" something.

Leave every change in the working tree and report what changed and where. The
user commits.

Reading git state is fine: `status`, `diff`, `log`, `show`, `blame`.

## Code comments

Do not add inline comments to code. No explanatory comments above a block, no
trailing comments on a line, no section banners, no comments justifying why an
approach was chosen.

Put the reasoning in the reply instead. If a piece of code needs a comment to be
understood, prefer making the code clearer.

Existing comments in a file stay as they are: do not delete or rewrite them
unless asked, and do not treat this rule as licence to strip a codebase.

Exceptions, only these: a comment the user explicitly asks for, a marker the
project's own conventions require (such as the `# STIG V-XXXXXX:` markers in
nixos-config), a licence header, or a machine-read directive that changes
behaviour (`# type: ignore`, `# noqa`, `//go:build`, `# shellcheck disable`,
`eslint-disable`).
