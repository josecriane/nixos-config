## OCaml

Applies to OCaml work. Ignore for non-OCaml projects. Assumes OCaml 5, dune,
and Eio. Read `rules/engineering-discipline.md` for the language-neutral rules
on results, tests, and verification.

### Build & Test Commands

- Build: `dune build`
- Build everything including tests and docs targets: `dune build @all`
- Clean: `dune clean`
- Format: `dune fmt`
- Check format without writing: `dune build @fmt`
- Run all tests: `dune runtest`
- Single directory: `dune runtest test/store`
- Single Alcotest case: `dune exec test/test_store.exe -- test 'store' 0`
- Accept new expect-test output: `dune promote`
- Docs: `dune build @doc`
- REPL with the project loaded: `dune utop lib`
- Coverage: `dune runtest --instrument-with bisect_ppx`, then `bisect-ppx-report summary`
- Install deps: `opam install --deps-only --with-test --with-doc .`
- Dependency tree: `opam list --required-by <pkg> --recursive`
- Profiling: `perf record` on a `--profile release` build, or `landmarks`
- Backtraces: `OCAMLRUNPARAM=b dune exec bin/main.exe`

### Project Layout

```
myproj/
├── dune-project
├── myproj.opam            # generated from dune-project, committed
├── .ocamlformat
├── lib/
│   ├── dune
│   ├── store.ml
│   ├── store.mli
│   └── error.ml
├── bin/
│   ├── dune
│   └── main.ml
└── test/
    ├── dune
    └── test_store.ml
```

One library per directory. `lib/` holds the library, `bin/` the executables,
`test/` the tests. An executable is a thin shell over a library: argument
parsing and process exit, nothing else. Logic that lives in `bin/` cannot be
tested.

### Code Style

- Format with `dune fmt`. Keep a `.ocamlformat` at the repo root pinning
  `version=` so the formatter cannot drift between machines. An otherwise
  empty file selects the default profile.
- `snake_case` for values, types, record fields, and variant arguments.
  `CamelCase` for modules and constructors.
- Every module in `lib/` has an `.mli`. The interface is the contract and the
  export list in one file. A module without an `.mli` exports its entire
  implementation.
- Write the `.mli` first. It is the design step, and it costs nothing to
  change before the `.ml` exists.
- Annotate every value in an `.mli`. Inference inside a module body is fine.
  Inference at the boundary is a contract nobody wrote down.
- Records with named fields over tuples past two elements.
- Variants over booleans. `Enabled | Disabled` reads at the call site,
  `true` does not.
- Abstract the type in the `.mli` when the representation carries an
  invariant: `type t` plus constructor functions, not `type t = {...}`.
- Labelled arguments when two parameters share a type, so `~src` and `~dst`
  cannot be swapped silently.
- Local `open` (`Module.(...)` or `let open Module in`) over top-of-file
  `open`. A file-wide `open` makes every unqualified name ambiguous to a
  reader.

### Types

Make illegal states unrepresentable. This is the highest-leverage habit in
OCaml, and it replaces most of the defensive checks other languages need.

- A record whose `code : int option` is meaningful only for one value of its
  `status` field is two variants wearing one record.
- Distinguish ids by type, not by discipline. `type user_id` and
  `type order_id` both wrap `int` and must never unify.
- Parse, do not validate. A `Validated.t` that can only be built by the
  parser means downstream code never re-checks.
- Never add `| _ ->` to a match on a variant. It turns a future compile error
  into a runtime bug. Exhaustiveness checking is free review.
- Polymorphic variants where the open set is the point, such as composable
  error unions. A plain variant everywhere else.
- Functors when a signature has several real implementations. A functor with
  one instantiation is indirection with a build cost.
- First-class modules for an implementation chosen at runtime, not for style.
- GADTs when a return type genuinely depends on an argument. Not before.

### Error Handling (The OCaml Way)

Fallible functions return `('a, 'e) result` and callers bind with `let*`.
Exceptions are for programming errors that must abort, and for control flow
that a function catches before it returns.

- Define a closed error variant per module. `string` as an error type is a
  refusal to decide what can go wrong.

  ```ocaml
  type error =
    | Not_found of string
    | Malformed of { line : int; reason : string }
    | Io of Unix.error

  val pp_error : Format.formatter -> error -> unit
  ```

- Give every error type a `pp_error`. An error the caller cannot print is an
  error the caller cannot report.
- `let*` chains over nested `match`. Open the syntax module locally.

  ```ocaml
  let load path =
    let open Result.Syntax in
    let* raw = read_file path in
    let* cfg = parse raw in
    validate cfg
  ```

- Name the raising sibling `_exn` and provide it only where a caller
  genuinely cannot continue.
- A function that raises says so in its `.mli` with `@raise`. The type does
  not carry that information, so the doc comment must.
- Convert a foreign library's exception into your error type at the call
  site that crosses the boundary, and nowhere else.
- `Fun.protect ~finally` for cleanup. A hand-written
  `try ... with e -> cleanup (); raise e` loses the backtrace.
- Never catch a bare `e ->` and continue. `Out_of_memory`, `Stack_overflow`,
  and `Eio.Cancel.Cancelled` must propagate. Match the exceptions you name
  and re-raise the rest.

Catching is for a boundary where you convert a foreign failure into a value
the caller can act on. If you cannot name that boundary, do not catch.

### Result Discipline

The general rule is in `rules/engineering-discipline.md`. The OCaml forms:

- A unit-returning call is `let () = do_thing x in`, never `ignore (do_thing x)`.
- `ignore` is allowed only with an explicit type annotation that documents
  what is being dropped, and only when dropping it is the point.
- The helper that names every variant:

  ```ocaml
  let handle_result : (unit, Store.error) result -> unit = function
    | Ok () -> ()
    | Error (Store.Not_found _) -> ()
    | Error e -> Logs.warn (fun m -> m "unexpected: %a" Store.pp_error e)
  ```

- Warning 26/27 (unused variable) and 8 (non-exhaustive match) are errors.
  Do not bind an unused result to `_x` to silence them.

### Concurrency

Do not introduce a fiber, a domain, or a mutex where a pure function works.
Do not introduce a global `ref` to avoid passing an argument.

- Eio for IO concurrency, domains for CPU parallelism. They are not
  interchangeable. A fiber that burns CPU starves every other fiber on its
  domain.
- Every fiber lives in a `Switch.t`, and the switch is the supervisor. When a
  fiber raises, the switch cancels its siblings and re-raises at the
  `Switch.run` boundary. Design the switch tree before writing fibers, the way
  you would design a supervision tree.
- Resources attach to the switch that owns them via `~sw`. Release is the
  switch's job, not a `finally` you must remember.
- `Fiber.both`, `Fiber.all`, `Fiber.first`, and `Fiber.any` state the join
  shape in the type. Reach for them before spawning into a switch by hand.
- Cancellation is delivered as `Eio.Cancel.Cancelled`. Any handler that
  swallows it breaks cancellation for the whole tree. Wrap a section that must
  finish in `Eio.Cancel.protect`, and keep it short.
- Backpressure is a bounded `Eio.Stream.t`. An unbounded stream is a mailbox
  with no flow control, which fails the same way an unbounded BEAM message
  queue does.
- Pass capabilities as arguments: `env`, `net`, `fs`, `clock`, `mono_clock`.
  A library that reaches for `Unix` or `Stdlib.stdout` directly cannot be
  tested and cannot be sandboxed. A library that takes its clock as an
  argument runs under a mock clock in tests.
- `Eio.Mutex` and `Eio.Semaphore` only for state that genuinely spans fibers.
  Prefer threading the state through the call.
- CPU work goes to `Eio.Executor_pool`. Shared mutable state across domains
  needs `Atomic` or a lock. The OCaml 5 memory model does not rescue a data
  race.

### Quality Bar

- Warnings are errors. Do not silence one with `[@warning "-8"]`, fix it.
- No `Obj.magic`. No `assert false` outside a branch the type system cannot
  see is unreachable.
- Alcotest for unit and integration tests. QCheck for properties.
  `ppx_expect` where a golden output is the clearest assertion.
- Eio code is tested with `Eio_mock` and a mock clock. A test that waits on
  real time is not deterministic.
- Every public value in an `.mli` has a doc comment, checked by
  `dune build @doc` running clean.
- Coverage measured with `bisect_ppx`, not estimated.

### Verification

`dune build @fmt` (format), `dune build @all` (compile with warnings as
errors), `dune runtest`, and `dune build @doc` when you touched an `.mli` doc
comment. Read `rules/engineering-discipline.md` for how to report the result.

`dune build @all` is the slow one on a cold cache. It is still the check that
matters, because dune builds tests and docs targets only under `@all`.

### OCaml Gotchas

- `==` is physical equality and `=` is structural. `=` on functions raises,
  and on a cyclic value it loops.
- Polymorphic compare on an abstract type ignores the type's invariants. A
  set keyed by a normalised string compares the un-normalised bytes. Define
  `compare` and pass it.
- `List.length` is O(n) and `@` is O(n) in its left argument. A fold that
  appends inside the loop is quadratic.
- The stack is finite. Prefer `List.rev_map` followed by `List.rev` over a
  non-tail-recursive map on an input whose length you do not control.
- `Bytes.unsafe_to_string` hands out a `string` that a later write to the
  original `Bytes.t` mutates underneath the holder.
- Finalisers and weak references run at unpredictable times. Never release a
  file descriptor from a finaliser.
- OCaml 5 has no global runtime lock. Code that relied on it for atomicity is
  now racy.
- An effect is not an exception. An unhandled effect raises
  `Effect.Unhandled` at the perform site, which a `try ... with` around the
  handler does not see.
- `Marshal` is neither type-safe nor stable across compiler versions. It is
  not a wire format.
- `Stdlib.exit` runs `at_exit` handlers and flushes channels. `Unix._exit`
  does not. Inside an Eio fiber, neither unwinds the switch tree.

### Documentation

Documentation lives in `(** ... *)` odoc comments. A doc comment attaches to
the item that follows it. A floating one at the top of a file documents the
module.

Doc comments belong in the `.mli`, not the `.ml`. The interface is what a
reader consults, and a copy in the implementation drifts. Every `val` in an
`.mli` carries one. Its absence is a defect.

Use the odoc tags: `@raise`, `@param`, `@return`, `@deprecated`, `@since`,
`@see`, `@before`. `@raise` on a function that raises is mandatory, because
the type does not carry that fact.

```ocaml
(** Persistent key-value store backed by a single file. *)

type t
(** A store handle. Close it with {!close}. *)

val open_ : sw:Eio.Switch.t -> Eio.Fs.dir_ty Eio.Path.t -> (t, error) result
(** [open_ ~sw path] opens the store at [path], creating it when absent.
    The handle closes when [sw] finishes.
    @raise Invalid_argument when [path] is empty. *)
```

Do not restate the type. `val length : t -> int` needs no "returns the
length as an integer".

Ordinary `(* ... *)` comments inside a function body follow
`rules/code-comments.md`. A row of asterisks, `(*** ... *)`, or `(* ---- *)` is a section
divider and is banned.

`[@@@warning]`, `[@warning]`, `[@@deprecated]`, and `[@@ocamlformat]` are
attributes, not comments. The warning-suppressing ones are still subject to
the quality bar of this rule: fix the warning instead.
