---
name: erlang-verify
description: Run the Erlang check pipeline and interpret its failures. Use before reporting Erlang work complete, and when asked to verify, check, build, test, format, run dialyzer, xref, hank, or measure coverage on a rebar3 project.
---

# Erlang Verification

`rules/engineering-discipline.md` sets the rule: run the checks, report the
actual result, never claim a check passed without reading its output. This
file is the Erlang pipeline and how to read what it prints.

## Pipeline

Run in this order. Each step is cheaper than the next, and a failure early
makes the later output unreadable.

```bash
rebar3 compile              # 1. warnings_as_errors
rebar3 fmt --check          # 2. formatting, exits 1 and lists the files
rebar3 xref                 # 3. undefined and unused functions
rebar3 dialyzer             # 4. specs and success typing
rebar3 hank                 # 5. dead code
rebar3 ct                   # 6. Common Test
rebar3 cover --verbose      # 7. coverage from the ct run
```

A project with the aliases from the `erlang-project` skill runs the same
steps as two commands:

```bash
rebar3 check && rebar3 test
```

Never run `rebar3 check` and `rebar3 ct` at the same time. Both write to
`_build`, and the second one reads a half-written beam.

`rebar3 eunit` when the project has EUnit tests. `rebar3 proper` or
`rebar3 triq` when it has properties outside a suite.

## Reading the failures

### `rebar3 compile` stops on a warning

`warnings_as_errors` turns every warning into a failed build. The common
ones:

- `Warning: variable 'X' is unused`: bind it as `_X` only when the value is
  truly uninteresting, which for a result tuple it is not. Match the result.
- `Warning: missing specification for function f/1`: write the spec. Do not
  add `nowarn_missing_spec` outside the test profile.
- `Warning: function f/1 is unused`: delete it. Git remembers.
- `Warning: this clause cannot match because a previous clause always
  matches`: a `case` has a catch-all before a real clause, or a guard is
  always true.
- `Warning: the call to f/1 will fail with a 'function_clause'`: the
  compiler proved the argument never matches. The caller or the callee is
  wrong, not the warning.

### `rebar3 fmt --check` lists files

Each file differs from the formatter's output. Apply with `rebar3 fmt`, then
re-run. Never edit by hand to match. When the list holds files you did not
touch, the repository was never formatted with the pinned `erlfmt`. Report
that rather than reformatting the repository.

### `rebar3 xref` findings

- `Warning: foo:bar/2 calls undefined function baz:qux/1`: the module is
  missing from `deps` or from the `applications` list in `.app.src`, or the
  function was renamed.
- `Warning: foo:helper/1 is unused locally`: `locals_not_used`. Delete it.
- `Warning: foo:bar/1 calls deprecated function`: the message names the
  replacement.

### Dialyzer messages

Read Dialyzer as a proof. It says what the code does, and the spec or the
caller disagrees.

- `Function f/1 has no local return`: every path raises. Usually a
  `case` with no clause for a value the callee returns, or a call below it
  that has no local return. Fix the lowest one first.
- `The pattern {ok, _} can never match the type {error, _}`: the callee
  never returns `ok`. Read its spec, then its code. One of them is wrong.
- `The call foo:bar(X) will never return since it differs in the 1st
  argument from the success typing arguments`: the argument type does not
  overlap with what the callee accepts. Follow the variable to its origin.
- `Invalid type specification for function f/1. The success typing is ...`:
  the spec claims a return the code never produces, or the code produces
  one the spec omits. The success typing printed is what the code does.
- `Expression produces a value of type {ok, _} | {error, _}, but this
  value is unmatched`: `unmatched_returns`. A fallible call was dropped.
  Match it, or route it through the project's `handle_result` helper. Do
  not bind it to `_`.
- `Unknown function foo:bar/1`: `no_unknown`. The application is missing
  from `plt_extra_apps` in `rebar.config`, or the function does not exist.
- `The created fun has no local return`: the fun body raises on every path.
  Same fix as the first item.
- `Record construction #r{} violates the declared type of field x`: the
  record field has a type and the construction leaves it `undefined`. Give
  the field a default or widen the type on purpose.

The first run builds the PLT and takes minutes. A later run that is slow
again means `plt_extra_apps` or the OTP version changed. Both are fine.

### `rebar3 hank` findings

- `unused_macros`: delete the macro.
- `unnecessary_function_arguments`: an argument is never used. Remove it,
  or when a behaviour or `proc_lib` callback requires the arity, ignore
  that rule for that file in `{hank, [{ignore, [...]}]}` with the reason in
  a `rebar.config` comment.
- `unused_record_fields`, `unused_hrls`, `unused_configuration_options`:
  delete.
- `single_use_hrls`: the header has one includer. Move its content there.

### `rebar3 ct` fails

The summary line is `N tests, M failures`. The log is in
`_build/test/logs/`, and the console prints the failing case with its
reason:

- `{badmatch, {error, Reason}}`: the test matched `{ok, _}` on a call that
  returned an error. `Reason` is the finding. Read it before touching the
  test.
- `{timeout, ...}` or `{test_case_failed, ...}` from `receive ... after`:
  the process under test did not send what the test waits for. Check that
  the test waits on the right pid and the right message shape, then the
  code.
- `init_per_suite` or `init_per_group` fails: the whole suite is skipped and
  counts as failed. The fixture is the bug, not the cases. With `--case`
  and no `--group`, `init_per_group` does not run.
- `{'EXIT', {noproc, ...}}` in `end_per_testcase`: a process the test owns
  died earlier. Find the first crash in the log, not the last.
- A deleted suite still runs: it lingers in `_build/test/lib/<app>/test`
  after a dependency recompile. Delete the orphan beam.
- `undef` on a test helper: the helper lives in `test/support/` and the
  test profile lacks `{extra_src_dirs, ["test/support"]}`.

### `rebar3 cover` reports a low module

`rebar3 cover --verbose` prints a per-module table. The HTML report in
`_build/test/cover/` colors the lines that never ran. Report the measured
numbers. Do not estimate coverage, and do not add a test whose only purpose
is to touch a line.

### Property test counterexample

`proper` prints `Failed: After N test(s).` and the input, then a shrunk
version. `triq` prints `Failed with: ...` and the shrunk input. The shrunk
input is the smallest case that fails. Turn it into a plain test case
first, then fix the code.

## Reporting

State what ran and what it said:

> `rebar3 check` clean: compile, fmt, xref, dialyzer, hank. `rebar3 test`
> 4 suites, 61 cases passed. Cover 91% overall, `myproj_conn` at 83%.

When something fails and you cannot fix it, name the check and quote the
error:

> `rebar3 dialyzer` fails: `src/myproj_pool.erl` line 112, "The pattern
> `{ok, Conn}` can never match the type `{error, _}`". `checkout/2` returns
> only errors on the overflow path. Whether the pool must block or fail
> there needs a decision I do not have.

Never write "this should work", "this will now pass", or "tests are passing"
without having run the command and read its output.
