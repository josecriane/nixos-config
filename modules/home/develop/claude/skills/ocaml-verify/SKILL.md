---
name: ocaml-verify
description: Run the OCaml check pipeline and interpret its failures. Use before reporting OCaml work complete, and when asked to verify, check, build, test, format, lint, or measure coverage on an OCaml or dune project.
---

# OCaml Verification

`rules/engineering-discipline.md` sets the rule: run the checks, report the
actual result, never claim a check passed without reading its output. This file
is the OCaml pipeline and how to read what it prints.

## Pipeline

Run in this order. Each step is cheaper than the next, and a failure early
makes the later output unreadable.

```bash
dune build @fmt        # 1. formatting, writes nothing
dune build @all        # 2. compile everything, warnings as errors
dune runtest           # 3. tests
dune build @doc        # 4. only when an .mli doc comment changed
```

`dune build` on its own builds the default alias. It skips test executables and
doc targets, so it passes on code that `@all` rejects. Use `@all`.

To run the whole pipeline in one command and stop at the first failure:

```bash
dune build @fmt && dune build @all && dune runtest
```

Inside an opam switch that is not the current one, prefix with
`opam exec --`.

## Reading the failures

### `dune build @fmt` fails

It prints a diff. Apply it with `dune fmt`, then re-run. Never edit the file by
hand to match. If the diff touches files you did not change, the local
ocamlformat version differs from the pinned `version =` in `.ocamlformat`.
Report that rather than reformatting the repository.

### Warning 8, non-exhaustive match

The compiler lists the unmatched value. Add the missing branch. Do not add
`| _ -> ...` and do not add `[@warning "-8"]`. An unmatched constructor is the
type system reporting a case the code does not handle.

### Warning 26 or 27, unused variable

A bound value is never used. Usually it means a result was captured and
forgotten, which `rules/engineering-discipline.md` treats as a defect. Fix the
logic. Renaming to `_x` to silence it hides the same bug.

### Warning 32, unused value

A value is defined and never used, and is not exported by the `.mli`. Either it
belongs in the `.mli` or it is dead code. Delete dead code.

### Signature mismatch

```
Error: The implementation lib/store.ml does not match the interface lib/store.mli:
       Values do not match:
         val get : t -> string -> string
       is not included in
         val get : t -> string -> string option
```

Read it as: implementation first, interface second. The interface is the
contract. Change the implementation unless the contract itself is wrong, and
say so explicitly if you believe it is.

### `dune runtest` prints nothing and exits 0

Dune caches test results. A passing test that has not changed does not re-run.
Force it with `dune runtest --force`. A suite that "passes" instantly after an
edit to unrelated files is the cache, not a result.

### Alcotest failure

Alcotest prints the failing test name, the expected value, and the actual
value, then writes the full log path. Read the log before changing anything.
`dune exec test/test_store.exe -- test 'suite name' 3` re-runs one case.

### Expect test failure

`ppx_expect` prints a diff between the recorded and the actual output. Accept
it with `dune promote` only after reading the diff and agreeing that the new
output is correct. `dune promote` is not a fix.

### Eio test hangs

A fiber is waiting on something no other fiber will provide. Almost always a
missing `Switch.run` scope, a stream nobody reads, or a real clock in a test.
Run under `Eio_mock.Backend.run` with a mock clock, per the `ocaml` rule stack.

### Stack overflow in a test

A non-tail-recursive function met an input longer than the test author
expected. This is a real defect, not a test-only problem. Fix the recursion.

## Coverage

```bash
dune runtest --instrument-with bisect_ppx --force
bisect-ppx-report summary
bisect-ppx-report html && xdg-open _coverage/index.html
```

Requires `(instrumentation (backend bisect_ppx))` in the library stanza. Report
the measured number. Do not estimate coverage.

## Reporting

State what ran and what it said:

> `dune build @fmt` clean. `dune build @all` clean. `dune runtest` 41 passed.
> Skipped `@doc`, no `.mli` doc comments changed.

When something fails and you cannot fix it, name the check and quote the error:

> `dune build @all` fails: `lib/store.ml`, line 84, warning 8, the match does
> not handle `Corrupt _`. The handler needs a decision about whether a corrupt
> record is fatal, which I do not have.

Never write "this should work", "this will now pass", or "tests are passing"
without having run the command and read its output.
