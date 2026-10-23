## Go

Applies to Go work. Ignore for non-Go projects. Assumes Go 1.25 or later,
modules, and the standard toolchain. Read `rules/engineering-discipline.md`
for the language-neutral rules on results, tests, and verification.

### Build & Test Commands

- Build: `go build ./...`
- Vet: `go vet ./...`
- Format: `gofumpt -w .` (a superset of `gofmt`)
- Check format without writing: `gofumpt -l .`
- Run all tests: `go test ./...`
- With the race detector: `go test -race ./...`
- Single package: `go test ./internal/store`
- Single test or subtest: `go test -run 'TestStore/missing_key' ./internal/store`
- Bypass the test cache: `go test -count=1 ./...`
- Shuffle test order: `go test -shuffle=on ./...`
- Lint: `golangci-lint run`
- Static analysis alone: `staticcheck ./...`
- Coverage: `go test -coverprofile=cover.out ./...`, then `go tool cover -func=cover.out`
- Benchmarks: `go test -bench . -benchmem ./internal/store`
- Fuzz: `go test -fuzz FuzzParse -fuzztime 30s ./internal/parser`
- Tidy and verify modules: `go mod tidy`, `go mod verify`
- Docs: `go doc ./internal/store`, `go doc -all ./internal/store`
- Profiling: `go test -cpuprofile cpu.out`, then `go tool pprof cpu.out`
- Debugger: `dlv test ./internal/store`, `dlv debug ./cmd/myproj`

### Project Layout

```
myproj/
├── go.mod
├── go.sum
├── .golangci.yml
├── cmd/
│   └── myproj/
│       └── main.go
└── internal/
    ├── store/
    │   ├── doc.go
    │   ├── store.go
    │   └── store_test.go
    └── server/
        ├── server.go
        └── server_test.go
```

`go.mod` sits at the repository root. `cmd/<name>/main.go` parses flags, wires
dependencies and exits, nothing else. Logic in `main` cannot be imported by a
test. Everything not meant for import by other modules lives under
`internal/`. The compiler enforces that boundary.

No `pkg/`, no `src/`, no `util`, `common`, or `helpers` package. A package is
named for what it provides, and the name equals the directory. Start flat and
split a package when it grows two unrelated concerns, not before.

### Code Style

- Format with `gofumpt`. Its rules are a strict superset of `gofmt`, so
  `gofmt` never disagrees with the result.
- `MixedCaps` for everything. Initialisms keep their case: `userID`,
  `HTTPServer`, `parseJSON`.
- Package names are short, lowercase, one word, no underscores. A name does
  not repeat the package: `store.New`, not `store.NewStore`.
- Receiver names are one or two letters and the same on every method of a
  type. Receivers of one type are all pointers or all values.
- Happy path on the left. Return early on the error branch instead of nesting
  the success branch inside an `else`.
- Accept interfaces, return structs. Define the interface where it is
  consumed, with one or two methods. An interface with five methods is a
  struct wearing a costume.
- Make the zero value useful. `var b bytes.Buffer` works without a
  constructor, and your types must too when they can.
- `context.Context` is the first parameter, named `ctx`, never stored in a
  struct field.
- No `Get` prefix on a getter. `c.Name()`, not `c.GetName()`.
- Functional options only when a constructor has more than three optional
  settings. A config struct covers the rest.

### Types

Make illegal states unrepresentable. Go has fewer tools for this than OCaml,
so use every one it has.

- Distinguish ids by named type. `type UserID string` and `type OrderID string`
  do not unify, and a swapped argument fails to compile.
- An enum is a named type, a block of `const` with `iota` and a `String()`
  method. A `switch` on it names every value and has no `default`. The
  `exhaustive` linter enforces that.
- `any`, never `interface{}`. They are the same type and one is readable.
- Generics for containers and algorithms that repeat across types. Not for
  indirection, and not to avoid writing three lines twice.
- Embedding is composition, not inheritance. An embedded type promotes its
  methods and nothing else. Do not embed to satisfy an interface by accident.
- A struct with a field that is meaningful only when another field holds one
  value is two types wearing one struct. Split it or use an interface with a
  sealed method.
- Parse, do not validate. A `Validated` type built only by the parser means
  downstream code never re-checks.

### Error Handling (The Go Way)

Errors are values. A fallible function returns `error` as its last result and
the caller checks it at once. Exceptions do not exist. `panic` is for a
programmer error that must abort the process.

- Wrap with `fmt.Errorf("open config: %w", err)`. The prefix names the
  operation, not the function, and the chain reads as a story from the
  outside in.
- Sentinel errors for conditions: `var ErrNotFound = errors.New("store: not found")`.
  Typed errors for data:

  ```go
  type ParseError struct {
      Line   int
      Reason string
  }

  func (e *ParseError) Error() string {
      return fmt.Sprintf("line %d: %s", e.Line, e.Reason)
  }
  ```

- Inspect with `errors.Is` and `errors.As`. Never compare `err.Error()`
  strings and never compare with `==` against a wrapped sentinel.
- Handle an error once. Log it or return it, not both. A returned error that
  was also logged shows up twice in the journal with no extra information.
- Error strings are lowercase and carry no trailing punctuation. They get
  wrapped into longer sentences.
- `errors.Join` for a function that collects several failures before
  returning.
- `panic` only in package initialization, inside a function named `MustX`,
  for a programming error such as an invalid constant regexp.
- `recover` only at the boundary of a goroutine that the package owns, and
  only to turn the panic into an error or a crash report. A library never
  recovers on behalf of its caller.

A `recover` is for a boundary where you convert a foreign failure into a value
the caller can act on. If you cannot name that boundary, do not recover.

### Result Discipline

The general rule is in `rules/engineering-discipline.md`. The Go forms:

- `_ = f()` on a call that returns an error is banned. When dropping the error
  is the point, say why in the reply.
- `defer w.Close()` on a writer discards a write error. Name a `closeErr` or
  wrap the close in a function that returns it.
- The helper that names every variant:

  ```go
  func handleResult(err error) {
      switch {
      case err == nil:
      case errors.Is(err, store.ErrNotFound):
      default:
          slog.Warn("unexpected result", "err", err)
      }
  }
  ```

- `errcheck` and `errorlint` in the linter set catch the rest. Do not silence
  either with `//nolint`.

### Concurrency

Do not start a goroutine where a function call works. Do not share memory to
avoid passing an argument. A goroutine that nobody waits for is a leak with
a delay.

- Every goroutine has an owner and a known exit. Start it in an
  `errgroup.Group` or under a `sync.WaitGroup`, and give it a `context` that
  the owner cancels. The owner waits before returning.
- Channels transfer ownership of data. A mutex guards state that several
  goroutines read and write. Do not use a channel as a lock.
- Every loop that can block selects on `ctx.Done()`. A `select` without it
  ignores cancellation for the whole tree above it.
- A bounded channel is backpressure. An unbounded queue built from a slice
  and a mutex fails the same way an unbounded BEAM message queue does.
- `atomic.Int64`, `atomic.Bool` and the other typed atomics. The function
  forms `atomic.AddInt64` accept a misaligned or unguarded field silently.
- Maps are not safe for concurrent use. `sync.Map` is for caches with
  write-once keys, not a general replacement.
- `go vet` flags a copied lock. A struct that holds a `sync.Mutex` is passed
  by pointer.
- `time.Sleep` in production code is a design smell. In a test it is a
  flaky test. Use `testing/synctest` for time-dependent code.
- The race detector is not optional. `go test -race` runs in CI on every
  package, and a race report is a defect, not a warning.

### Quality Bar

- `go vet ./...` is clean.
- `golangci-lint` runs with a committed `.golangci.yml`. The minimum set is
  `errcheck`, `errorlint`, `exhaustive`, `gocritic`, `govet`, `revive`,
  `staticcheck`, `unused`. A `//nolint` directive names the linter and
  carries a reason.
- Standard `testing` package. Table tests with `t.Run`, `t.Parallel` where
  the cases are independent, `t.Helper` in every assertion helper,
  `t.Cleanup` and `t.TempDir` for resources.
- `go-cmp` for structural diffs. No assertion framework, no mock generator.
  Interfaces defined at the consumer make a hand-written fake three lines.
- `httptest`, `fstest` and `iotest` for boundaries.
- `FuzzX` functions for every parser of external input. `b.Loop` for
  benchmarks.
- `goleak` in the test main of any package that starts goroutines.
- Coverage measured with `-coverprofile`, not estimated.

### Verification

`gofumpt -l .` (format), `go vet ./...`, `go build ./...`,
`go test -race ./...`, and `golangci-lint run`. Read
`rules/engineering-discipline.md` for how to report the result.

`golangci-lint run` is the slow one on a cold cache. It is still the check
that matters, because `errcheck` and `exhaustive` are where result discipline
is enforced.

### Go Gotchas

- An interface holding a typed nil pointer is not nil. Return a bare `nil`,
  not a `(*T)(nil)`, from a function whose result type is an interface.
- `append` writes into the backing array of its argument when capacity
  allows. A slice handed out of a function is shared state.
  `slices.Clone` before returning a sub-slice of internal storage.
- Map iteration order is random by design. A test that depends on it passes
  once.
- `defer` evaluates its arguments at the `defer` line, not at return.
  `defer log(t.Elapsed())` logs zero.
- `:=` inside an `if` or `for` shadows an outer `err`. The `govet` shadow
  check finds it.
- `range` over a slice of structs copies each element. Mutating the copy
  does nothing.
- `http.Client{}` has no timeout. `http.DefaultClient` has no timeout. Set
  one, or use a `context` deadline on every request.
- Every `http.Response.Body` must be closed, also on the error path.
- `time.Time` carries a monotonic reading. `==` compares it, `Equal` does
  not. Use `Equal`.
- The `go` directive in `go.mod` selects language semantics per module,
  including the loop-variable scoping fix from Go 1.22. An old directive
  keeps the old bug.
- A `string` is bytes. `len` counts bytes, `range` yields runes, and an
  index yields a byte.
- `select` with several ready cases picks one at random. Do not rely on
  case order.
- JSON ignores unexported fields silently. A struct that round-trips to an
  empty object usually has lowercase field names.

### Documentation

Documentation lives in doc comments, the `//` block that touches the
declaration. A doc comment starts with the name of the thing it documents.
The package comment is `// Package store ...` in `doc.go`. Every exported
identifier carries a doc comment. Its absence is a defect.

Use the doc comment syntax: `[Name]` and `[pkg.Name]` for links, a paragraph
that starts with `Deprecated:` for deprecation, and an indented block for
code. An `ExampleX` function in a `_test.go` file is executable
documentation and runs under `go test`.

```go
// Package store is a persistent key-value store backed by a single file.
package store

// Store is a handle on one file. Close it with [Store.Close].
type Store struct {
    // contains filtered or unexported fields
}

// Open opens the store at path and creates it when absent.
// It returns [ErrLocked] when another process holds the file.
func Open(ctx context.Context, path string) (*Store, error)
```

Do not restate the signature. `func (s *Store) Len() int` needs no "returns
the length as an integer".

Ordinary `//` comments inside a function body follow `rules/code-comments.md`.
A row of `// ----` or `// ====` is a section divider and is banned.

`//go:build`, `//go:generate`, `//go:embed`, `//go:noinline` and
`//nolint:<linter> // <reason>` are pragmas, not comments. `//nolint` without
a linter name and a reason is still subject to the quality bar of this rule:
fix the finding instead.
