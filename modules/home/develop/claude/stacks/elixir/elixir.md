## Elixir

Applies to Elixir work. Read `rules/engineering-discipline.md` for the
language-neutral rules on results, tests, and verification.

### Build & Test Commands

- Build: `mix compile --warnings-as-errors`
- Format: `mix format`
- Run all tests: `mix test`
- Single file: `mix test test/foo_test.exs`
- Single test: `mix test test/foo_test.exs:42`
- Lint: `mix credo --strict`
- Dialyzer: `mix dialyzer`
- Coverage: `mix test --cover`
- Docs: `mix docs`

### Code Style

- Format with `mix format`. Keep `.formatter.exs` in the repository.
- `snake_case` for functions and variables, `CamelCase` for modules.
- `@spec` on every public function. `@type` for every shape a module
  exports.
- Maps over keyword lists unless order matters.
- Pattern match in function heads when the branches are on the arguments.

### Error Handling

- Every fallible function returns `{:ok, value} | {:error, reason}`. A `!`
  variant raises and exists only beside the tuple form.
- `with` chains over nested `case` for error chains.
- `try/rescue` only at a boundary that converts a foreign exception into
  `{:error, reason}`. Never to suppress a crash. Never to make a test pass.
  A crash in a test is information.
- Do not convert a `!` call to its tuple-returning sibling to dodge an
  exception unless the caller handles both branches.
- Do not add a `_ -> :ok` catch-all to a `case` on a closed set of values.
  An unmatched clause raises, which is the correct outcome.
- Let it crash for unexpected errors. Supervisors handle recovery.

### Concurrency

Do not introduce a process, `Task`, `GenServer`, or `Agent` where a pure
function works. Do not introduce shared mutable state to avoid passing an
argument. State that outlives a request needs a supervisor and a stated
restart strategy. Use `GenServer`, `:gen_statem` and `Supervisor` over a
raw `spawn`.

### Result Discipline

The general rule is in `rules/engineering-discipline.md`. The Elixir form:
match one uninteresting result exactly, `:ok = do_thing(x)`. Route several
shapes through a helper that names every variant and returns `:ok`.

### Documentation and comments

- `@moduledoc` on every module, `@doc` on every public function, `@typedoc`
  on every public type. `@moduledoc false` hides an internal module.
- Doctests inside `@doc` and `@moduledoc` are executable tests. Never strip
  them.
- Attributes that are not comments: `@spec`, `@type`, `@typep`, `@opaque`,
  `@callback`, `@deprecated`, `@dialyzer`, `@compile`.
- Tool pragmas that look like comments and are not:
  `# credo:disable-for-next-line`, `# styler:sort`, `# sobelow_skip`,
  `# coveralls-ignore-start`.

### Verification

`mix format --check-formatted`, `mix compile --warnings-as-errors`,
`mix test`, `mix credo --strict`, `mix dialyzer`.

Dialyzer is slow. Run it when you changed a spec, a struct, or a return
shape.
