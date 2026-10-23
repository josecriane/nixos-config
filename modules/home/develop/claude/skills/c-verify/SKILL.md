---
name: c-verify
description: Run the C check pipeline and interpret its failures. Use before reporting C work complete, and when asked to verify, check, build, test, format, lint, run under sanitizers, or measure coverage on a C project.
---

# C Verification

`rules/engineering-discipline.md` sets the rule: run the checks, report the
actual result, never claim a check passed without reading its output. This
file is the C pipeline and how to read what it prints.

## Pipeline

Run in this order. Each step is cheaper than the next, and a failure early
makes the later output unreadable. The commands assume CMake with a
sanitizer configuration in `build/`. A Makefile project carries the same
targets, and `bear -- make` produces the `compile_commands.json` that steps
4 and 5 need.

```bash
clang-format --dry-run --Werror $(git ls-files '*.c' '*.h')   # 1. formatting
cmake --build build                                           # 2. compile with -Werror
ctest --test-dir build --output-on-failure                    # 3. tests under ASan and UBSan
clang-tidy -p build $(git ls-files '*.c')                     # 4. the checks from .clang-tidy
cppcheck --project=build/compile_commands.json \
    --enable=warning,performance,portability --error-exitcode=1   # 5. second opinion
```

To run the whole pipeline in one command and stop at the first failure:

```bash
clang-format --dry-run --Werror $(git ls-files '*.c' '*.h') && cmake --build build && ctest --test-dir build --output-on-failure && clang-tidy -p build $(git ls-files '*.c') && cppcheck --project=build/compile_commands.json --enable=warning,performance,portability --error-exitcode=1
```

When `build/` does not exist, configure it first:

```bash
cmake -S . -B build -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_C_FLAGS="-fsanitize=address,undefined -fno-omit-frame-pointer"
```

Code that starts threads gets a second configuration in `build-tsan/` with
`-fsanitize=thread`, and step 3 runs there too.

## Reading the failures

### `clang-format` prints `code should be clang-formatted`

Each message names a file and line whose formatting differs. Apply with
`clang-format -i`, then re-run. Never edit by hand to match. When the list
holds files you did not touch, the repository was never formatted with the
committed `.clang-format`. Report that rather than reformatting the
repository.

### `error: implicit declaration of function`

The function has no prototype in scope. Either the header is missing from
the includes, or the function is a POSIX extension hidden by `-std=c17`.
For the second case define `_POSIX_C_SOURCE 200809L` before the first
include, or use `-std=gnu17`. Do not add a local prototype.

### `error: no previous prototype for function`

`-Wmissing-prototypes`. A non-static function has no declaration in a
header. If it is internal, make it `static`. If it is API, declare it in the
public header.

### `error: implicit conversion changes signedness` or `may change value`

`-Wconversion` and `-Wsign-conversion`. A narrowing or sign-changing
conversion happens without a cast. Fix the types so the conversion is not
needed, in most cases by using `size_t` for the index or count. A cast is
the last option, and the reply must say why, because a cast says the author
checked that the value fits.

### `error: enumeration value 'X' not handled in switch`

`-Wswitch-enum`. The `switch` misses a value. Add the case. Do not add
`default`. A missing case is the compiler reporting a value the code does
not handle.

### `==ERROR: AddressSanitizer: heap-buffer-overflow`

The report has three stacks: the access, the allocation of the block, and
for a freed block its `free`. The first frame outside the sanitizer runtime
in the first stack is the bug. `READ of size 1 ... 0 bytes after
4-byte region` says an off-by-one past the end. Fix the bound, not the
buffer size.

### `==ERROR: AddressSanitizer: heap-use-after-free`

Same three stacks. The object was freed in the third stack and used in the
first. Find the owner that freed it while another holder still had the
pointer. The fix is an ownership decision, not a `NULL` check.

### `==ERROR: AddressSanitizer: stack-use-after-return` or `stack-buffer-overflow`

A pointer to a local escaped the function, or an index went past a local
array. The variable is named in the report.

### `==ERROR: LeakSanitizer: detected memory leaks`

Each block lists its allocation stack. A leak on an error path means an
unwind label is missing. A leak on the success path means the header does
not say who frees. `ASAN_OPTIONS=detect_leaks=0` hides the report and is not
a fix.

### `runtime error: signed integer overflow`

UBSan. The expression at the given line overflowed `int` or a wider signed
type. The report prints both operands. Test before the operation, use
`ckd_add` from `<stdckdint.h>`, or use unsigned arithmetic when wrapping is
the intent.

### `runtime error: load of misaligned address` or `null pointer passed as argument`

UBSan. The first is a cast of a `char *` into a wider pointer type. Use
`memcpy`. The second is a `memcpy` or `memset` with `NULL` and length 0,
which is undefined before C2y. Guard the call with the length.

### `runtime error: member access within null pointer` or `index out of bounds`

UBSan. The pointer was `NULL` or the index exceeded a declared array bound.
The line number is exact. Look at the caller that produced the value.

### `WARNING: ThreadSanitizer: data race`

Two stack traces, one per access, with the thread that performed each and
the locks each held. Both are real. Find the shared field, decide which lock
owns it, and write that on the struct. Or make it an `_Atomic`. Do not add
`TSAN_OPTIONS` suppressions.

### `ctest` prints `Not Run` or `No tests were found`

The test was not registered with `add_test`, or `build/` was configured from
an older `CMakeLists.txt`. Re-run the configure step. A test that
"passes" because it never ran is not a result.

### `clang-tidy` prints `Error while trying to load a compilation database`

`compile_commands.json` is missing. Configure with
`-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`, or run `bear -- make` on a Makefile
project. Do not run `clang-tidy` without a database. It then sees the file
with no include paths and reports nonsense.

### `clang-tidy` finding

The check name is in brackets at the end of the line. `bugprone-*` and
`clang-analyzer-*` findings are bugs until proven otherwise. A
`// NOLINT(check-name): reason` is allowed when the reason is a fact about
the code. `// NOLINT` without a check name and a reason is not a fix.

### `cppcheck` prints `nullPointer`, `memleak`, or `uninitvar`

Each is a path through the function on which the named condition holds.
`cppcheck` is conservative, so a finding is usually real. Read the path it
describes before deciding it is a false positive, and when it is, add an
inline suppression with a reason: `// cppcheck-suppress nullPointer ; reason`.

### `valgrind` prints `Conditional jump or move depends on uninitialised value(s)`

A branch read a variable that was never written. The stack names the
branch, and `--track-origins=yes` names the allocation. `calloc` the block,
or initialize the field in the constructor.

### `valgrind` prints `definitely lost`

A leak with no remaining pointer to the block. Same fix as the
LeakSanitizer case. `still reachable` at exit is not a leak.

## Coverage

```bash
cmake -S . -B build-cov -DCMAKE_C_FLAGS="--coverage"
cmake --build build-cov
ctest --test-dir build-cov
gcov -r -o build-cov/CMakeFiles/myproj.dir/src src/*.c
```

The `.gcov` files print a per-line execution count. Report the measured
percentage from the `Lines executed` summary. Do not estimate coverage.

## Reporting

State what ran and what it said:

> `clang-format --dry-run --Werror` clean. `cmake --build build` clean.
> `ctest` 6 tests passed under ASan and UBSan. `clang-tidy -p build` clean.
> `cppcheck` clean.

When something fails and you cannot fix it, name the check and quote the
error:

> `ctest` fails: `test_store`, `AddressSanitizer: heap-use-after-free` in
> `store_close` at `src/store.c` line 84. The index still holds a pointer to
> the freed page. Which of the two owns the page needs a decision I do not
> have.

Never write "this should work", "this will now pass", or "tests are passing"
without having run the command and read its output.
