## Erlang / OTP

Applies to Erlang work. Ignore for non-Erlang projects. Assumes OTP 27 or
later, rebar3, erlfmt, and Common Test. Read
`rules/engineering-discipline.md` for the language-neutral rules on results,
tests, and verification.

### Build & Test Commands

- Build: `rebar3 compile`
- Clean: `rebar3 clean`
- Format: `rebar3 fmt`
- Check format without writing: `rebar3 fmt --check`
- Static checks: `rebar3 check` (the alias for compile, `fmt --check`, xref,
  dialyzer, hank)
- Run all tests: `rebar3 test` (the alias for ct, then cover)
- Single suite: `rebar3 ct --suite=test/foo_SUITE`
- Single case: `rebar3 ct --suite=test/foo_SUITE --case=case_name`
- Case in a group: `rebar3 ct --suite=test/foo_SUITE --group=g --case=c`.
  Without `--group`, `init_per_group` does not run.
- EUnit: `rebar3 eunit`, one module: `rebar3 eunit --module=foo`
- Properties: `rebar3 proper` or `rebar3 triq`, whichever the project uses
- Cross reference: `rebar3 xref`
- Dialyzer: `rebar3 dialyzer`
- Dead code: `rebar3 hank`
- Coverage: `rebar3 cover --verbose`, report in `_build/test/cover/`
- Docs: `rebar3 ex_doc`
- Shell with the project loaded: `rebar3 shell`
- Dependency tree: `rebar3 tree`
- Binary construction report: `erlc +bin_opt_info -o /tmp src/foo.erl`
- Profiling: `eprof`, `fprof`, `tprof` on OTP 27 and later
- Live inspection: `observer:start()`, `recon` when the project has it

Run `rebar3 check` and `rebar3 ct` one after the other, never at the same
time. Both write to `_build`.

### Project Layout

```
myproj/
├── rebar.config
├── rebar.lock
├── Makefile
├── CHANGELOG.md
├── include/
│   └── myproj.hrl           # only when another application includes it
├── src/
│   ├── myproj.app.src
│   ├── myproj.erl           # public API
│   ├── myproj_app.erl
│   ├── myproj_sup.erl
│   └── myproj_conn.erl
└── test/
    ├── myproj_conn_SUITE.erl
    ├── support/             # helpers shared by suites
    └── conf/                # certificates and generated fixtures
```

One application per repository. `src/<app>.erl` is the public API, and
every other module is implementation. The `ex_doc` filter and the
`AGENTS.md` of the project name the public surface. A header in `include/`
exists only for another application. A record used by one module lives in
that module. `_build` and `rebar3.crashdump` are not committed. `rebar.lock`
is.

### Code Style

- Format with `rebar3 fmt`. The `erlfmt` entry in `rebar.config` pins the
  print width and the file set.
- Module layout: module attribute, `-moduledoc`, behaviour, includes,
  compile options, exports grouped by purpose, type exports, types, macros,
  records, then functions in export order. Drop a part that is empty.
- `snake_case` for functions, atoms and module names. `CamelCase` for
  variables. Module names carry the application prefix: `myproj_conn`.
- Line length under 100 characters.
- Type specs on every function, exported or not. Export every type that a
  public spec names.
- Maps over proplists unless order matters. Records for internal state with
  a fixed set of fields. Maps for data that crosses a module boundary.
- A number literal in a function body is a macro: `?RECV_TIMEOUT_MS`.
- Anonymous functions only where a named function cannot do the job.
- No `-ifdef(TEST)` under `src/`. A test reaches a private function through
  an exported caller, through the wire, or through a pure helper module
  exported for its own sake.
- No `-compile(export_all)` outside the test profile.

### Types

Make illegal states unrepresentable. Dialyzer checks only what the specs
say, so a loose spec is a check that never runs.

- Concrete types in every spec. `term()`, `any()`, `map()`, `tuple()` and
  `list()` are refusals to decide. Write the map type with `:=` for required
  keys and `=>` for optional ones, the tuple shape, the element type.

  ```erlang
  -type config() :: #{
      host := binary(),
      port := inet:port_number(),
      timeout => pos_integer()
  }.
  ```

- A closed set is a union of atoms: `-type state() :: idle | connecting |
  open | closed.` A `case` on it names every value and has no `_` clause.
- An id is its own type. `-type conn_id() :: reference().` and
  `-type pool_id() :: reference().` read differently at the call site even
  when Dialyzer unifies them.
- `-opaque` for a type whose representation belongs to one module. A caller
  that pattern-matches an opaque value gets a Dialyzer warning, which is the
  point.
- Parse, do not validate. An `opts/0` built only by `myproj_opts:parse/1`
  means the rest of the application never re-checks a field.
- `-nominal` on OTP 28 and later for types that share a representation and
  must not unify.

### Error Handling (The Erlang Way)

- Monadic style: every fallible function returns `{ok, Value}` or
  `{error, Reason}`. A constructor returns `{ok, State}` even when it cannot
  fail today. A state transformer returns `{ok, State}` or
  `{ok, State, Effect}`.
- Raw values only from pure predicates (`boolean()`), pure getters, pure
  transformers with no failure mode, and private functions.
- `Reason` is a typed term, not a string. Define
  `-type error() :: not_found | {timeout, pos_integer()} | ...` per module
  and export it. A caller cannot match on a string.
- Prefer `maybe ... else ... end` over nested `case` for error chains.
- Use `try/catch` only to wrap **external** library exceptions into
  `{error, Reason}`.
- Never use `throw/1` or `error/1` in your own code.
- Let it crash for unexpected errors: supervisors handle recovery.
- Design supervision trees before writing processes.

A supervisor exists to handle the failure you are tempted to catch. Do not:

- Add `try/catch` or `catch` to suppress a crash.
- Wrap a failing call in `catch` to make a test pass. A crash in a test is
  information.
- Add a `_ -> ok` catch-all to a `case` on a closed set of values. An
  unmatched clause raises, which is the correct outcome.

A catch is for a boundary where you convert a foreign failure into a value
the caller can act on. If you cannot name that boundary, do not catch.

### Concurrency

Do not introduce a process or a `gen_server` where a pure function works.
Do not introduce shared mutable state to avoid passing an argument. State
that outlives a request needs a supervisor and a stated restart strategy.

- Behaviours (`gen_server`, `gen_statem`, `gen_event`, `supervisor`) over
  raw `spawn`. `proc_lib` with `sys` support where a behaviour's mailbox
  discipline is the bottleneck, and the `AGENTS.md` says why.
- `gen_statem` for non-trivial state. A state machine written as a
  `gen_server` with a `state` field is a state machine without a type.
- One process, one responsibility. Functional core, process shell: pure
  functions inside, processes for state and I/O.
- Message passing over shared state. ETS for data many readers need at
  once, with one named owner process and a stated cleanup. ETS is not a
  substitute for an argument.
- Every `gen_server:call/3` has a timeout the caller chose. A timeout is a
  deadline on `erlang:monotonic_time/1`, not a counter of sleeps.
- A mailbox is unbounded. The sender applies backpressure: a `call` where a
  `cast` would pile up, a credit scheme, or a bounded queue.
- A monitor or link on every process whose death the caller must notice. A
  `Pid` held without one is a dangling pointer.
- `persistent_term` for data written at start and read on every request.
  Each write triggers a global GC scan, so it is not a cache.

### Result Discipline

The general rule is in `rules/engineering-discipline.md`. The Erlang form of
the naming helper:

```erlang
-spec handle_result(result()) -> ok.
handle_result(ok) -> ok;
handle_result({ok, _}) -> ok;
handle_result({error, not_found}) -> ok;
handle_result({error, Reason}) ->
    ?LOG_WARNING("unexpected result: ~p", [Reason]),
    ok.
```

The last call in a function is the exception: its value is the function's
own return value, which is what makes the call a proper tail call. The
Dialyzer `unmatched_returns` warning enforces the rest.

### Quality Bar

- `warnings_as_errors` and `warn_missing_spec_all` in `erl_opts`. The test
  profile may relax the spec warning for suites, nothing else.
- Dialyzer warnings are **not** allowed. `error_handling`, `no_unknown` and
  `unmatched_returns` are on.
- `rebar3 xref` clean with `undefined_function_calls`,
  `undefined_functions`, `locals_not_used`, `deprecated_function_calls` and
  `deprecated_functions`.
- `rebar3 hank` clean. An entry in `{hank, [{ignore, ...}]}` names the file
  and the rule, and carries the reason in the `rebar.config` comment.
- Common Test for behaviour at process and wire boundaries. EUnit for pure
  functions. One suite per module or area, `test/*_SUITE.erl`.
- Property tests (`proper` or `triq`) for every codec: encode then decode is
  the identity.
- No mock of a module of the project. A mock at a dependency boundary only
  when no wire path exists, with the reason in the suite.
- Test supervisor restart behaviour explicitly: kill the child, assert the
  replacement, assert the state it starts from.
- Deterministic tests. No `timer:sleep/1` to wait for a process. Wait on a
  monitor, a message, or a `sys:get_state/1` poll with a deadline.
- Coverage measured with `rebar3 cover`, 85% per module as the target, read
  in `_build/test/cover/`.

### Verification

`rebar3 check` (compile with warnings as errors, `fmt --check`, xref,
dialyzer, hank), then `rebar3 test` (ct, then cover). Read
`rules/engineering-discipline.md` for how to report the result.

Dialyzer is the slow one, and the first run builds the PLT. It is still
the check that matters, because `unmatched_returns` and the spec checks are
where result discipline is enforced. When the project has no `check` alias,
run the five commands by hand in that order.

### BEAM Gotchas

- Large binaries (over 64 bytes) are reference-counted and shared. A
  sub-binary from a pattern match keeps the whole parent alive. `binary:copy/1`
  before storing a small slice of a large message.
- Atoms are **not** garbage-collected. Never create them dynamically from
  untrusted input: `binary_to_existing_atom/2`, not `binary_to_atom/2`.
- Message queues grow unbounded. Selective receive on a long queue scans
  it on every `receive`. Keep queues short or use the reference trick that
  `gen_server:call` uses.
- ETS tables die with their owner, and `ets:tab2list/1` copies the table.
  Use `ets:select/2` with a match spec or `ets:foldl/3`.
- NIFs must stay under about 1 ms or they block a scheduler. Dirty
  schedulers for anything longer.
- Hot code loading keeps two versions. A process in a loop that calls
  itself with a local call stays on the old code and dies on the next load.
- Float keys and integer keys are different map keys: `#{1 => a}` does not
  hold `1.0`. `=:=` and `==` differ the same way.
- `++` copies its left operand. A list built with `Acc ++ [X]` in a loop is
  quadratic. Prepend and `lists:reverse/1`.
- `length/1` is O(n). A guard `when length(L) > 0` walks the list. Match
  `[_ | _]` instead.
- `iolist_to_binary/1` on a path that returns `iodata()` is a copy the
  socket did not need. Send the iolist.
- A `receive` without `after` in a `gen_server` callback blocks the process
  and every caller. Callbacks return, they do not wait.
- `erlang:now/0` is deprecated. `erlang:monotonic_time/1` for durations,
  `erlang:system_time/1` for timestamps, `erlang:unique_integer/1` for ids.
- A `gen_server` that calls itself deadlocks until the timeout.
- `string()` is a list of code points. `binary()` is bytes. `unicode:characters_to_binary/1`
  converts, `list_to_binary/1` does not for code points above 255.

### Documentation

Documentation lives in `-moduledoc` and `-doc` attributes, the ex_doc form.
EDoc comment tags are not allowed anywhere, including in new modules that
sit next to old ones that use them:

```
%% @doc      %% @spec     %% @param    %% @returns   %% @equiv
%% @see      %% @end      %% @private  %% @hidden    %% @throws
%% @type     %% @author   %% @copyright %% @since    %% @deprecated
%% @reference %% @version %% @todo      %% @headerfile
```

Contracts go in `-spec` and `-type`, never in a doc string. Hide a function
from the docs with `-doc false`. Mark deprecation with
`-doc #{deprecated => "Use foo/2 instead"}`. Attach metadata with
`-doc #{since => "1.4.0"}`.

```erlang
-doc """
Open a connection to `Host` and return a handle.

The handle is owned by the caller and released with `close/1`.
""".
-spec open(host(), opts()) -> {ok, conn()} | {error, error()}.
```

Do not restate the spec. `-spec size(t()) -> non_neg_integer().` needs no
"returns the size as a non-negative integer".

When editing a module that still carries EDoc tags, convert only the tags on
functions you are already changing. Do not migrate the whole module unless
asked.

Attributes that look like annotations and are not comments: `-spec`,
`-type`, `-opaque`, `-nominal`, `-callback`, `-dialyzer`, `-compile`.
