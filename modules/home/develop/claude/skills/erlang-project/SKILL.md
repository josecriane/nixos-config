---
name: erlang-project
description: Scaffold and structure Erlang/OTP libraries with rebar3. Use when creating a new Erlang application, writing or reviewing rebar.config, adding a plugin, profile, alias or dependency, setting up erlfmt, xref, dialyzer, hank or ex_doc, writing the Makefile gate, or wiring CI and Hex publishing.
---

# Erlang Project Structure

The conventions that keep the libraries the same. The `erlang-otp` stack
holds the code rules. This file holds the build files.

## Layout

```
myproj/
├── rebar.config
├── rebar.lock               # committed
├── Makefile
├── README.md                # public API and usage, the ex_doc main page
├── CHANGELOG.md             # Keep a Changelog format
├── LICENSE
├── AGENTS.md
├── CONTRIBUTING.md
├── .github/workflows/ci.yml
├── include/                 # only for headers other applications include
├── src/
│   ├── myproj.app.src
│   └── *.erl
└── test/
    ├── *_SUITE.erl
    ├── support/             # helpers shared by suites
    └── conf/                # certificates and the script that makes them
```

`bench/` and `soak/` exist when the project has them. A load generator in
`soak/` is a rebar3 project of its own.

## rebar.config

```erlang
{minimum_otp_vsn, "27"}.

{erl_opts, [
    debug_info,
    warnings_as_errors,
    warn_export_vars,
    warn_shadow_vars,
    warn_obsolete_guard,
    warn_unused_import,
    warn_missing_spec_all
]}.

{deps, []}.

{project_plugins, [
    erlfmt,
    rebar3_hank,
    rebar3_ex_doc,
    rebar3_hex
]}.

{erlfmt, [
    write,
    {print_width, 100},
    {files, [
        "src/**/*.{hrl,erl,app.src}",
        "test/**/*.{hrl,erl}",
        "include/**/*.hrl",
        "rebar.config"
    ]},
    {exclude_files, ["test/*_SUITE_data/**/*.{hrl,erl}"]}
]}.

{xref_checks, [
    undefined_function_calls,
    undefined_functions,
    locals_not_used,
    deprecated_function_calls,
    deprecated_functions
]}.

{dialyzer, [
    {warnings, [error_handling, no_unknown, unmatched_returns]},
    {plt_extra_apps, []}
]}.

{hank, [{ignore, ["test/**"]}]}.

{profiles, [
    {test, [
        {deps, [{proper, "1.5.0"}]},
        {extra_src_dirs, [{"test/support", [{recursive, false}]}]},
        {erl_opts, [nowarn_missing_spec_all]},
        {cover_enabled, true},
        {cover_opts, [verbose]}
    ]}
]}.

{ct_opts, [{verbose, true}]}.

{alias, [
    {check, [compile, {fmt, "--check"}, xref, dialyzer, hank]},
    {test, [ct, cover]}
]}.

{ex_doc, [
    {source_url, <<"https://github.com/nomasystems/myproj">>},
    {extras, [<<"README.md">>, <<"CHANGELOG.md">>, <<"LICENSE">>]},
    {main, <<"readme">>},
    {filter_modules, <<"^myproj$">>}
]}.

{hex, [{doc, ex_doc}]}.
```

What each part is for:

- `project_plugins`, not `plugins`. A project plugin is a tool of this
  repository and is not pulled by a consumer of the library.
- `warn_missing_spec_all` covers private functions too. The test profile
  relaxes it for suites, and nothing else.
- `plt_extra_apps` lists every application a spec or a call refers to that
  is not in `applications` of the `.app.src`: `public_key`, `ssl`,
  `crypto`, and test-only dependencies the suites call.
- `hank` ignores `test/**`, because Common Test callbacks carry arguments
  they do not use. A `src/` file with a `proc_lib` or `sys` callback gets
  `{"src/myproj_conn.erl", [unnecessary_function_arguments]}` and the
  reason in a comment above it.
- `filter_modules` in `ex_doc` is the public surface. Every module not in
  it is implementation and stays out of the docs.
- The `check` and `test` aliases are the whole gate. `CONTRIBUTING.md`
  names them and nothing else.

## .app.src

```erlang
{application, myproj, [
    {description, "One line, what it is, which OTP it needs"},
    {vsn, "0.1.0"},
    {registered, []},
    {applications, [kernel, stdlib]},
    {env, []},
    {modules, []},
    {licenses, ["Apache-2.0"]},
    {links, [{"GitHub", "https://github.com/nomasystems/myproj"}]}
]}.
```

`applications` lists every application the code calls at runtime, in start
order. `ssl` and `crypto` are not implied. A library without a supervision
tree has no `mod` entry. `vsn` is the Hex version and moves with
`CHANGELOG.md`.

## Makefile

The Makefile is a thin shell over rebar3 so that CI and a person type the
same words:

```make
.PHONY: all compile clean check test cover doc

REBAR3 := rebar3

all: compile

compile:
	$(REBAR3) compile

clean:
	$(REBAR3) clean

check:
	$(REBAR3) check

test:
	$(REBAR3) test

cover:
	$(REBAR3) ct --cover
	$(REBAR3) cover --verbose

doc:
	$(REBAR3) ex_doc
```

## Dependencies

A dependency is a decision. Before adding one, name it, say what it buys,
and say what the OTP alternative costs, then wait for agreement
(`rules/engineering-discipline.md`). When agreed:

1. Add it to `deps` with an exact version, `{telemetry, "1.3.0"}`, not a
   range.
2. Add it to `applications` in `.app.src` when the code calls it at
   runtime.
3. Add it to `plt_extra_apps` when a spec names its types.
4. Run `rebar3 upgrade <dep>` so `rebar.lock` moves, and commit the lock
   with the config.

A test-only dependency goes in the test profile and in `plt_extra_apps`
only. `meck` is a test-only dependency and is used at a dependency
boundary only, never on a module of the project.

## CI

One workflow, a matrix of the two newest OTP releases, two steps:
`rebar3 check` and `rebar3 test`. A release tag runs `rebar3 hex publish`
with the token from the repository secrets. The cover report is uploaded as
an artifact and does not gate the build.

## New module checklist

1. `src/myproj_<name>.erl` with `-moduledoc`, specs on every function, and
   the exports grouped by purpose.
2. A `test/myproj_<name>_SUITE.erl` with `all/0` listing every case.
3. Public modules go into `filter_modules`. Every other module stays out.
4. `rebar3 check && rebar3 test` clean.
5. A `CHANGELOG.md` line under `Unreleased` when the public API changed.

## Release

1. Move the `Unreleased` section of `CHANGELOG.md` under the new version
   with the date.
2. Bump `vsn` in `.app.src`.
3. `rebar3 check && rebar3 test`.
4. One commit, `chore: release 1.4.0`, and a tag `v1.4.0`. The tag triggers
   the Hex publish. Propose the commit and the tag; do not run them.
