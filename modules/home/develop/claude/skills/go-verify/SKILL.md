---
name: go-verify
description: Run the Go check pipeline and interpret its failures. Use before reporting Go work complete, and when asked to verify, check, build, test, format, lint, race-test, or measure coverage on a Go module.
---

# Go Verification

`rules/engineering-discipline.md` sets the rule: run the checks, report the
actual result, never claim a check passed without reading its output. This file
is the Go pipeline and how to read what it prints.

## Pipeline

Run in this order. Each step is cheaper than the next, and a failure early
makes the later output unreadable.

```bash
gofumpt -l .               # 1. formatting, prints the files that differ
go vet ./...               # 2. static checks that find real bugs
go build ./...             # 3. compile every package
go test -race ./...        # 4. tests under the race detector
golangci-lint run          # 5. the linter set from .golangci.yml
```

`go build` does not compile `_test.go` files. `go vet` does, so a test file
that no longer compiles fails at step 2, not step 3.

To run the whole pipeline in one command and stop at the first failure:

```bash
test -z "$(gofumpt -l .)" && go vet ./... && go build ./... && go test -race ./... && golangci-lint run
```

When the repository has no `.golangci.yml`, `staticcheck ./...` covers the
most important part of step 5.

## Reading the failures

### `gofumpt -l .` prints file names

Each name is a file whose formatting differs. Apply with `gofumpt -w .`, then
re-run. Never edit by hand to match. When the list holds files you did not
touch, the repository was never formatted with `gofumpt`. Report that rather
than reformatting the repository.

### `go vet` reports `shadow` or `lostcancel`

`declaration of "err" shadows declaration` means an inner `:=` created a new
`err`, and the outer one is never checked. Use `=` on the inner assignment.
`the cancel function is not used on all paths` means a `context.WithCancel`
result leaks. `defer cancel()` right after the call.

### `go vet` reports `copylocks`

A struct that holds a `sync.Mutex` or `sync.WaitGroup` was passed or assigned
by value. The copy has its own lock and guards nothing. Pass a pointer.

### `go test` prints `(cached)`

The test did not run. The cache is keyed on the package and its inputs, so a
change to a file that the package does not import leaves the result cached.
After a code change, `go test -count=1` forces a run. A suite that "passes"
instantly is the cache, not a result.

### `WARNING: DATA RACE`

Two stack traces, one for each access, and the goroutine that created each.
Both are real. Find the shared variable, decide whether other fields must
change with it, and guard with a `sync.Mutex` or make it an `atomic` value.
Do not add `-race=false`. A race that reproduces once reproduces in
production.

### `panic: test timed out after 10m0s`

A goroutine is blocked on a channel that nobody sends to or a lock that
nobody releases. The stack dump that follows lists every goroutine. Look for
the ones in `chan receive`, `chan send`, or `sync.Mutex.Lock`, and find
which owner exited without closing or unlocking. Run with `-timeout 30s` to
fail faster while diagnosing.

### `goleak` reports a leaked goroutine

The test finished and a goroutine it started is still running. The stack
names the function. Its owner returned without waiting or cancelling. Add the
`WaitGroup` or `errgroup` that was missing, or the `ctx.Done()` case that the
loop lacks.

### `errcheck` finding

A call that returns an `error` was not checked. Handle it. Do not write
`_ = f()` unless discarding is the point, and then say why in the reply. A `defer f.Close()` on a writer is the common
case, and the fix is to capture the close error.

### `exhaustive` finding

A `switch` on an enum type misses a value. Add the case. Do not add
`default`. A missing case is the type system reporting a value the code does
not handle.

### `errorlint` finding

`err == ErrNotFound` or `err.(*ParseError)` on an error that may be wrapped.
Use `errors.Is` or `errors.As`.

### Any finding you want to silence

`//nolint:<linter> // <reason>` is allowed when the reason is a fact about the
code, such as an intentional discard in a shutdown path. `//nolint` with no
linter name or no reason is not a fix. Fix the finding.

### `go build` fails with `imported and not used`

A refactor removed the last use of an import. `goimports -w` or `gofumpt`
with the `-extra` flag removes it. Do not add `_ = pkg.Name` to keep the
import.

### Signature or interface mismatch

```
cannot use s (variable of type *Store) as Reader value in argument to run:
    *Store does not implement Reader (missing method ReadAt)
```

Read it as: concrete type first, interface second. Either the type is
missing a method or the interface asks for more than the caller needs. Prefer
shrinking the interface, and say so if you believe the interface is wrong.

## Coverage

```bash
go test -coverprofile=cover.out -covermode=atomic ./...
go tool cover -func=cover.out | tail -1
go tool cover -html=cover.out -o cover.html
```

`-covermode=atomic` is required together with `-race`. Report the measured
number. Do not estimate coverage.

## Reporting

State what ran and what it said:

> `gofumpt -l .` clean. `go vet ./...` clean. `go build ./...` clean.
> `go test -race ./...` 3 packages, 41 tests passed. `golangci-lint run`
> clean.

When something fails and you cannot fix it, name the check and quote the error:

> `go test -race ./...` fails: `internal/pool/pool.go`, line 84, data race
> between `Put` and `Len` on `p.free`. Guarding `Len` needs a decision about
> whether it must be exact or can be approximate, which I do not have.

Never write "this should work", "this will now pass", or "tests are passing"
without having run the command and read its output.
