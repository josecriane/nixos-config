---
name: contributing
description: Move a project from CLAUDE.md to AGENTS.md plus CONTRIBUTING.md. Use when asked to prepare a repository for AGENTS.md, to generate or refresh CONTRIBUTING.md, to migrate CLAUDE.md, or to make humans and agents follow the same contribution rules.
---

# CLAUDE.md to AGENTS.md and CONTRIBUTING.md

The target layout of a project:

- `CONTRIBUTING.md` holds every rule that a change must follow. Humans and
  agents read the same file. `claude-contrib render` writes the sections from
  `## License` to the end from the shared rules and the language rules. The
  text above is hand written.
- `AGENTS.md` holds the facts of this repository: what it is, how to build,
  test and verify it, where things live. It links to `CONTRIBUTING.md`. It
  stays under 150 lines.
- `CLAUDE.md` does not exist. Claude Code reads `AGENTS.md` when no
  `CLAUDE.md` or `CLAUDE.local.md` is present in the directory or above it.

Claude Code already carries the shared rules from `~/.claude/rules/`, so
`AGENTS.md` links to `CONTRIBUTING.md` with a markdown link, not with an
`@CONTRIBUTING.md` import. An import loads the same rules twice.

## Procedure

Work in the repository root. Stop and ask when a step below says so.

1. Run `git status --short`. If the tree has changes outside this task, ask
   before continuing.
2. Run `claude-contrib render`. If it refuses because a hand-written
   `CONTRIBUTING.md` exists, run `claude-contrib render --force`. The tool
   keeps the existing text above the rendered sections. Then edit that text
   into the project sections: keep every project-specific instruction
   (branch names, issue labels, review flow, links) and drop what the
   rendered sections already say.
3. Read `CLAUDE.md`, `.claude/CLAUDE.md` and `README.md` when they exist.
   Sort every paragraph of the Claude files into one of three bins:
   - Facts about the repository: purpose, build and test commands, layout,
     architecture, process trees, protocol notes. These go to `AGENTS.md`.
   - Restatements of a shared rule: conventional commits, no dialyzer
     warnings, warnings as errors, no comments in function bodies, the
     result discipline. Drop them. The rendered sections already say it.
   - Rules specific to this repository: a coverage threshold, a `make check`
     gate, a compliance suite, a branch naming scheme, a release procedure.
     These go to the project part of `CONTRIBUTING.md`.
4. Fill the project part of `CONTRIBUTING.md`, the text above the first
   rendered heading, `## License`. Use these headings, and drop a heading
   with nothing to say:
   - `## Project`: one paragraph on what the project is.
   - `### Verification`: the exact commands that must pass before a change
     is complete, in order. The generated Erlang or OCaml section lists the
     generic pipeline. Write only what differs here, for example `make
     check` or a coverage floor.
   - `### Workflow`: branch names, issue flow, review, release steps, when
     the repository has them.
5. Create `AGENTS.md`. When `CLAUDE.md` exists, run
   `git mv CLAUDE.md AGENTS.md` first so history follows the file, then
   rewrite the content. Structure:
   - `# <project>` and one paragraph on what it is.
   - A line: `Every change follows [CONTRIBUTING.md](CONTRIBUTING.md).`
   - `## Build and test`: a table or list of commands. Prefer the `make`
     targets when a `Makefile` exists.
   - `## Layout`: directories and the main modules, one line each.
   - `## Architecture`: only what a reader cannot get from the code in a
     minute. Process trees and lifecycle sequences belong here.
   - Keep any `@path` import that pointed at a file in the repository.
   - One line for agents: the sections of `CONTRIBUTING.md` from
     `## License` to the end are rendered by `claude-contrib`. Change the
     rule source, not the file.
   - Delete prose that repeats `CONTRIBUTING.md`.
6. Copy the language rules in. Run `claude-stack list`. When the stack of
   the project is absent, a symlink or stale, run `claude-stack add <stack>`.
   Then run `claude-stack check`. The copy is committed with the rest.
7. When `.claude/CLAUDE.md` exists, fold it into `AGENTS.md` and delete it.
   When `CLAUDE.local.md` exists, say so and ask. It blocks `AGENTS.md`.
8. Run `claude-contrib check`. Run the style checks that apply to markdown
   in this repository, when the repository has them. Then read
   `CONTRIBUTING.md` from the top as a new contributor would. A sentence
   that names a tool of the maintainer machine, or a language the project
   does not use, is a defect in the rule sources. Report it. Do not patch
   the file.
9. Show `git status --short` and the diff of `AGENTS.md` and of the project
   part of `CONTRIBUTING.md`. Propose this commit message and wait:

   ```
   docs: replace CLAUDE.md with AGENTS.md and CONTRIBUTING.md
   ```

## What not to do

- Do not edit the rendered sections of `CONTRIBUTING.md`, from `## License`
  to the end. Change the rule source under the nixos flake and render again.
- Do not import `CONTRIBUTING.md` from `AGENTS.md` with `@`.
- Do not keep a `CLAUDE.md` that only imports `AGENTS.md`. The user runs
  Claude Code 2.1.277 or later everywhere.
- Do not commit. Do not push.
- Do not rewrite `README.md`.

## Batch use

Render every repository first, then run this skill per project:

```sh
for d in ~/lib/erlang/*/ ~/lib/ocaml/*/; do
  [ -d "$d/.git" ] && (cd "$d" && claude-contrib render)
done
```

Then in each project, interactively: `/contributing`. A non-interactive
form is `claude -p --permission-mode acceptEdits "/contributing"`. Read the
resulting diff before any commit.
