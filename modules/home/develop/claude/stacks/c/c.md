## C

Applies to C work. Ignore for non-C projects. Assumes C17 as the baseline,
C23 where the project pins it, GCC or Clang, and a POSIX host. Read
`rules/engineering-discipline.md` for the language-neutral rules on results,
tests, and verification.

### Build & Test Commands

The build system belongs to the project: a Makefile for one target, CMake
with Ninja for more. The commands assume CMake. Makefile targets carry the
same names.

- Configure: `cmake -S . -B build -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`
- Sanitizer configure: add `-DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS="-fsanitize=address,undefined -fno-omit-frame-pointer"`
- Build: `cmake --build build`
- Clean: `rm -rf build`
- Format: `clang-format -i $(git ls-files '*.c' '*.h')`
- Check format without writing: `clang-format --dry-run --Werror $(git ls-files '*.c' '*.h')`
- Run all tests: `ctest --test-dir build --output-on-failure`
- Single test: `ctest --test-dir build -R test_store`
- Lint: `clang-tidy -p build $(git ls-files '*.c')`
- Second opinion: `cppcheck --project=build/compile_commands.json --enable=warning,performance,portability --error-exitcode=1`
- Static analysis: `scan-build cmake --build build`, or `-fanalyzer` in `CFLAGS` under GCC
- Compilation database for a Makefile project: `bear -- make`
- Memory check without sanitizers: `valgrind --leak-check=full --error-exitcode=1 ./build/test/test_store`
- Fuzz: `clang -fsanitize=fuzzer,address,undefined -o fuzz_parse test/fuzz_parse.c src/parse.c`, then `./fuzz_parse -max_total_time=30 corpus/`
- Coverage: build with `--coverage`, run the tests, `gcov -r src/*.c`
- Profiling: `perf record -g ./build/myproj`, `perf stat -e cache-misses,branch-misses ./build/myproj`
- Debugger: `gdb --args ./build/test/test_store`
- Generated code: `gcc -O2 -S -o - src/store.c`

### Compiler Flags

Pin the standard. Compilers differ in their default, and GCC moved it to C23
in release 15, so a build without `-std=` compiles a different language on
each machine.

```
-std=c17 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wsign-conversion
-Wstrict-prototypes -Wmissing-prototypes -Wvla -Wformat=2 -Wswitch-enum
-Wnull-dereference -Werror
```

`-Wswitch-enum` reports a `switch` on an enum that misses a value, even when
it has a `default`. It is the exhaustiveness check of this stack.
`-Wmissing-prototypes` reports a non-static function with no declaration in
a header, which is a function that leaked out of its module.

Every test build adds `-fsanitize=address,undefined`. Threaded code gets a
second build with `-fsanitize=thread`. Release builds add
`-D_FORTIFY_SOURCE=3 -fstack-protector-strong`.

### Project Layout

```
myproj/
├── CMakeLists.txt
├── .clang-format
├── .clang-tidy
├── include/
│   └── myproj/
│       └── store.h
├── src/
│   ├── store.c
│   ├── store_internal.h
│   └── main.c
└── test/
    ├── check.h
    ├── test_store.c
    └── fuzz_parse.c
```

Public headers live under `include/<project>/` and are the API. One `.c`
file per public header. Headers shared between `.c` files but not exported
live in `src/`. `main.c` parses arguments, calls the library and exits,
nothing else. Logic in `main.c` cannot be tested. `build/` and
`compile_commands.json` are generated and not committed.

### Code Style

- Format with `clang-format`. Commit a `.clang-format`. Without one, use:

  ```yaml
  BasedOnStyle: LLVM
  IndentWidth: 8
  UseTab: Always
  BreakBeforeBraces: Linux
  ColumnLimit: 100
  ```

- `snake_case` for functions, variables, struct tags and fields.
  `UPPER_CASE` for macros and enum constants. Every exported identifier
  carries the module prefix: `store_open`, `STORE_MAX_KEY`, `enum store_state`.
- `static` for everything that is not declared in a header.
- No `typedef` for a struct or a pointer. `struct store *s` says what it is.
  A `typedef` is for a function pointer type or a scalar alias such as
  `typedef int32_t fixed_t`.
- Declare at first use, in the smallest scope. `const` on every pointee the
  function does not modify.
- Three levels of indentation at most. A function that needs more does too
  much.
- Happy path on the left. Return early on the error branch.
- `sizeof *p` and `sizeof var`. `sizeof(struct foo)` drifts when the type of
  `p` changes.
- No VLAs, no `alloca`, no nested functions, no statement expressions.
- A macro only where a function or `static inline` cannot do the job.
  Parenthesize every argument and the body, evaluate each argument once, and
  hide no control flow.

### Types

Make illegal states unrepresentable. C gives few tools for this, so use each
one.

- Opaque handles. `struct store;` in the header, the definition in the `.c`.
  A caller that cannot see the fields cannot depend on them.
- `size_t` for sizes, counts and indices. Fixed-width `uint32_t` and friends
  for a representation such as a wire format or a register. Plain `int` for
  a small signed count. Never `unsigned` as a stand-in for "non-negative".
- `bool` for truth values. An `int` return holds a result code, not a truth
  value.
- An enum per closed set. A `switch` on it names every value and has no
  `default`.
- A sum type is a tagged union. Read a member only after a `switch` on the
  tag.

  ```c
  struct value {
          enum value_kind kind;
          union {
                  int64_t integer;
                  struct {
                          const char *data;
                          size_t len;
                  } string;
          } u;
  };
  ```

- Flags are an `unsigned` with named bits: `#define STORE_F_SYNC (1u << 0)`.
- A string is a pointer and a length. NUL termination exists at the libc
  boundary, not inside the program.
- Never cast away `const`. Never cast the result of `malloc`.

### Error Handling (The C Way)

Errors are return values. A fallible action returns `int`: `0` on success,
a negative `errno` value such as `-EINVAL` or `-ENOMEM` on failure, with
results delivered through output parameters. A function that returns a
pointer returns `NULL` on failure. A predicate returns `bool`. Exceptions do
not exist, and `longjmp` is not an error channel.

- Mark every fallible function so the compiler rejects a dropped result.
  `[[nodiscard]]` in C23, `__attribute__((warn_unused_result))` before it,
  behind one project macro such as `MYPROJ_NODISCARD`.
- Capture `errno` on the line after the libc call that set it. Anything in
  between can overwrite it.
- Unwind with `goto`. One exit path releases resources in reverse order of
  acquisition, and each label is named for what it undoes.

  ```c
  int store_open(const char *path, struct store **out)
  {
          struct store *s;
          int rc;

          s = calloc(1, sizeof *s);
          if (!s)
                  return -ENOMEM;

          s->fd = open(path, O_RDWR);
          if (s->fd < 0) {
                  rc = -errno;
                  goto err_free;
          }

          rc = store_load_index(s);
          if (rc)
                  goto err_close;

          *out = s;
          return 0;

  err_close:
          close(s->fd);
  err_free:
          free(s);
          return rc;
  }
  ```

- `assert` states a precondition, which is a programmer error. It never
  validates input, and it stays enabled in test builds.
- Library code never calls `exit` or `abort` and never writes to `stderr`.
  Only `main` decides what a failure means for the process.

### Memory and Ownership

- Every allocation has one owner, and the header says who frees. A
  constructor pairs with a destructor, and `store_free(NULL)` is a no-op
  like `free(NULL)`.
- A function that keeps a pointer past the call says so in its doc comment.
  Otherwise the pointer is valid only during the call.
- `calloc(n, sizeof *p)` for arrays. It checks the product for overflow and
  zeroes the block. Any other size arithmetic goes through `ckd_mul` or
  `__builtin_mul_overflow` before `malloc`.
- `realloc` into a temporary. `p = realloc(p, n)` leaks `p` on failure.
- A hot path does not call `malloc`. Allocate from an arena whose lifetime
  matches the work (a request, a frame, a parse) and reset it once.
- A buffer is a pointer and a length. `snprintf` with a checked return,
  `memcpy` with a checked length. Banned: `gets`, `strcpy`, `strcat`,
  `sprintf`, `strtok`, and `strncpy` as a safe copy, since it does not
  terminate.
- `p = NULL` after `free(p)` when `p` stays in scope.

### Concurrency

- C11 `<threads.h>` or pthreads, `<stdatomic.h>` for atomics. `volatile` is
  not synchronization.
- A lock protects data, not code. The comment on the struct names which lock
  protects which fields. Take locks in one fixed order everywhere.
- Keep critical sections short. Never block while holding a lock that a hot
  path takes.
- A reference count keeps an object alive. A lock keeps it consistent. They
  are different jobs.
- Prefer one owner per thread and a bounded queue between threads over shared
  mutable state.
- Threaded code runs under `-fsanitize=thread` in the tests. A race report is
  a defect.

### Result Discipline

The general rule is in `rules/engineering-discipline.md`. `MYPROJ_NODISCARD`
is the compiler-enforced form. A `(void)` cast on a fallible call is allowed
only when the reply says why. When the caller does not care
which result it got, route it through a helper that names each one:

```c
static void log_result(const char *op, int rc)
{
        switch (rc) {
        case 0:
        case -ENOENT:
                return;
        default:
                log_warn("%s: unexpected result: %s", op, strerror(-rc));
        }
}
```

The `default` is allowed because `errno` is an open set. A `switch` on a
project enum has no `default`, and `-Wswitch-enum` reports the missing case.

### Quality Bar

- The flag set above, with `-Werror`, clean under both GCC and Clang.
- `clang-tidy` runs with a committed `.clang-tidy`. The minimum:

  ```yaml
  Checks: 'bugprone-*,cert-*,clang-analyzer-*,performance-*,portability-*,readability-*,-readability-identifier-length,-readability-magic-numbers'
  WarningsAsErrors: '*'
  ```

  A `// NOLINT(check-name): reason` names the check and carries a reason.
- One test executable per module in `test/`, registered with `add_test`.
  Assertions come from a small `check.h` of the project. No framework unless
  the project has one.
- The tests run under `-fsanitize=address,undefined` always, and under
  `-fsanitize=thread` when the module starts threads. `valgrind` covers the
  builds where a sanitizer is not available.
- A libFuzzer target (`LLVMFuzzerTestOneInput`) for every parser of external
  input, with its corpus committed.
- Deterministic by construction. A module takes its clock, its random seed and
  its I/O as arguments, so a test replays a recorded input and compares bytes.
- Coverage measured with `gcov`, not estimated.

### Verification

`clang-format --dry-run --Werror` on the tracked `.c` and `.h` files, the
sanitizer build with `-Werror`, `ctest --test-dir build --output-on-failure`,
`clang-tidy -p build`, and `cppcheck`. Read `rules/engineering-discipline.md`
for how to report the result.

The sanitizer test run is the slow one. It is still the check that matters,
because ASan and UBSan are where memory and undefined-behavior discipline is
enforced. Build with the other compiler when you changed a warning flag.

### C Gotchas

- Operands narrower than `int` are promoted first. `uint8_t a, b; a + b` is
  an `int`, and `uint16_t x; x * x` overflows `int` on a 32-bit `int`, which
  is undefined.
- Signed overflow is undefined and the compiler assumes it does not happen.
  `if (a + b < a)` is optimized away. Test before the operation, or use
  `ckd_add` from `<stdckdint.h>`.
- A shift by a negative count or by the width or more is undefined. A left
  shift of a negative value is undefined. A right shift of a negative value
  is implementation-defined.
- An array parameter is a pointer. `sizeof v` inside `void f(int v[10])` is
  the size of a pointer. An array-length macro is valid on arrays only.
- Strict aliasing. Read the bytes of an object through `memcpy` or a
  `char *`, never through a pointer to another type.
- A pointer one past the end of an array is valid to form. Two past is
  undefined without any dereference.
- Argument evaluation order is unspecified. `a[i] = i++` and
  `f(g(), h())` with side effects in both are not sequenced.
- `char` signedness is implementation-defined. The `<ctype.h>` functions take
  an `unsigned char` value or `EOF`, and `getchar` returns `int`.
- `snprintf` returns the length it wanted to write. `memcmp` on a struct
  compares padding bytes, which are unspecified. `strerror`, `localtime` and
  `strtok` return static storage.
- `errno` is set on failure only. Check the return value first, then read
  `errno`.
- The underlying type of an `enum` is implementation-defined before C23. A
  struct with an `enum` or with padding is not a wire format. Serialize the
  fields.
- A macro argument with a side effect runs once per use in the body.
- `-ffast-math` and floating-point contraction make results differ between
  compilers. Fixed-point arithmetic gives the same bits everywhere.
- Comparing pointers into different objects with `<` is undefined. `==` is
  defined.

### Documentation

Documentation lives in a `/** ... */` comment above each public declaration
in the header. The header is the contract, and a copy in the `.c` drifts.
Every public function carries one. Its absence is a defect.

The comment states what the function does, who owns each pointer that goes in
and comes out, how long an argument must stay valid, which error values the
function returns, and whether it is safe to call from several threads.

```c
/**
 * Open the store at path and create it when absent.
 *
 * The handle in *out is owned by the caller and released with store_free().
 * path is used only during the call.
 *
 * Returns 0 on success, -ENOENT when the directory does not exist, -EACCES
 * when it is not writable, and -ENOMEM on allocation failure.
 */
MYPROJ_NODISCARD int store_open(const char *path, struct store **out);
```

Do not restate the signature. `size_t store_len(const struct store *s)` needs
no "returns the length as a size_t".

Ordinary comments inside a function body follow `rules/code-comments.md`. A row of
`/* ---- */` or `// ====` is a section divider and is banned.

Include guards named `MYPROJ_STORE_H`, `#pragma`, `[[...]]` attributes,
`__attribute__` and `// NOLINT(...)` are pragmas, not comments. A
`#pragma GCC diagnostic ignored` and a `NOLINT` without a check name and a
reason are still subject to the quality bar of this rule: fix the finding
instead.
