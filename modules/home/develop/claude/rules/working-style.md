## Git

Never create commits. Do not run `git add`, `git commit`, `git push`, `git
tag`, or anything else that writes to history or to a remote. This holds even
when the task obviously ends in a commit, when a previous commit in the session
was approved, and when asked to "finish" or "ship" something.

Leave every change in the working tree and report what changed and where. The
user commits.

Reading git state is fine: `status`, `diff`, `log`, `show`, `blame`.
