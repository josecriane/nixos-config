RULES_DIR="${CLAUDE_RULES_DIR:-$HOME/.claude/rules}"
STACKS_DIR="${CLAUDE_STACKS_DIR:-$HOME/.claude/stacks}"
DEFAULT_SECTIONS="license,ai-contributions,engineering-discipline,commits,code-comments,project-documentation,writing-style,simple-english"

die() {
  printf 'claude-contrib: %s\n' "$1" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Render CONTRIBUTING.md from the shared Claude Code rules and the language
rules of a project. Humans and agents then follow one document.

Usage:
  claude-contrib render [options] [dir]   Write or refresh CONTRIBUTING.md
  claude-contrib check [options] [dir]    Exit 1 when the rendered sections are stale
  claude-contrib detect [dir]             Print the detected stack
  claude-contrib list                     Show the shared sections and stacks

Options:
  --stack <name>       Language rules to include. Default: detected from
                       mix.exs (elixir), rebar.config (erlang), dune-project
                       (ocaml), go.mod (go), CMakeLists.txt or a Makefile
                       with .c files (c), or flake.nix (nix). --stack none
                       for no language section.
  --name <name>        Project name in the title. Default: the directory name.
  --sections <a,b,c>   Shared rule files to include, in order.
  --force              Render on a CONTRIBUTING.md that this tool did not
                       write. Its text is kept above the rendered sections.

The file has two parts. The text above the first shared heading is hand
written and survives a render. From that heading to the end of the file the
sections are copies of the rule files, and every render replaces them. A
file that holds every shared heading in order is one this tool wrote.
`check` compares the rendered part with a fresh render.

A stack is a rule file with a `paths:` front matter in the rules directory,
or a directory under the stacks directory.
EOF
}

file_mode() {
  printf '%o\n' $((0666 & ~0$(umask)))
}

project_root() {
  local dir=$1 root
  if root=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null) && [ -n "$root" ]; then
    printf '%s\n' "$root"
  else
    printf '%s\n' "$(cd "$dir" && pwd)"
  fi
}

has_c_sources() {
  local root=$1
  find "$root" "$root/src" -maxdepth 1 -name '*.c' -print -quit 2>/dev/null | grep -q .
}

detect_stack() {
  local root=$1
  if [ -f "$root/mix.exs" ]; then
    printf 'elixir\n'
  elif [ -f "$root/rebar.config" ]; then
    printf 'erlang\n'
  elif [ -f "$root/dune-project" ]; then
    printf 'ocaml\n'
  elif [ -f "$root/go.mod" ]; then
    printf 'go\n'
  elif [ -f "$root/CMakeLists.txt" ] || { [ -f "$root/Makefile" ] && has_c_sources "$root"; }; then
    printf 'c\n'
  elif [ -f "$root/flake.nix" ]; then
    printf 'nix\n'
  else
    printf 'none\n'
  fi
}

stack_files() {
  local name=$1
  [ "$name" = none ] && return 0
  if [ -f "$RULES_DIR/$name.md" ]; then
    printf '%s\n' "$RULES_DIR/$name.md"
  elif [ -d "$STACKS_DIR/$name" ]; then
    find "$STACKS_DIR/$name" -maxdepth 1 -name '*.md' | sort
  else
    die "no stack '$name' in $RULES_DIR or $STACKS_DIR"
  fi
}

section_files() {
  local list=$1 name
  for name in ${list//,/ }; do
    [ -f "$RULES_DIR/$name.md" ] || die "no rule file $RULES_DIR/$name.md"
    printf '%s\n' "$RULES_DIR/$name.md"
  done
}

strip_front_matter() {
  awk 'NR==1 && $0=="---" {skip=1; next} skip && $0=="---" {skip=0; next} !skip'
}

rule_title() {
  grep -m1 '^## ' "$1" | sed 's/^## //'
}

rewrite_references() {
  local file title name
  local script=''
  for file in "$@"; do
    name=$(basename "$file" .md)
    title=$(rule_title "$file")
    [ -n "$title" ] || continue
    script="$script s|\`rules/$name\.md\`|the \"$title\" section|g;"
    script="$script s|\`$name\.md\`|the \"$title\" section|g;"
  done
  sed -e "$script"
}

rendered_part() {
  local file
  for file in "$@"; do
    strip_front_matter <"$file"
    printf '\n'
  done | rewrite_references "$@"
}

header() {
  local name=$1
  printf '# Contributing to %s\n\n' "$name"
  cat <<EOF
Humans and coding agents follow the same rules.

## Project

Build, test and verification commands for this repository go here.

EOF
}

is_rendered() {
  local file=$1
  shift
  [ -f "$file" ] || return 1
  local titles
  titles=$(for f in "$@"; do printf '## %s\n' "$(rule_title "$f")"; done)
  awk -v want="$titles" '
    BEGIN { n = split(want, t, "\n"); i = 1 }
    i <= n && $0 == t[i] { i++ }
    END { exit (i > n) ? 0 : 1 }' "$file"
}

hand_written_part() {
  local file=$1 first=$2
  awk -v h="## $first" '$0==h {exit} {print}' "$file" | grep -v '^<!-- claude-contrib:'
}

compose() {
  local target=$1 name=$2 first=$3
  shift 3
  if [ -f "$target" ]; then
    hand_written_part "$target" "$first"
    printf '\n'
  else
    header "$name"
  fi
  rendered_part "$@"
}

cmd_render() {
  local root=$1 stack=$2 name=$3 sections=$4 force=$5
  local target="$root/CONTRIBUTING.md"
  local files=() first tmp

  mapfile -t files < <(section_files "$sections"; stack_files "$stack")
  [ ${#files[@]} -gt 0 ] || die 'nothing to render'
  if [ -f "$target" ] && ! is_rendered "$target" "${files[@]}" && [ "$force" != 1 ]; then
    die "$target was not written by this tool. Pass --force to keep its text above the rendered sections."
  fi
  first=$(rule_title "${files[0]}")

  tmp=$(mktemp "$root/.CONTRIBUTING.md.XXXXXX")
  chmod "$(file_mode)" "$tmp"
  compose "$target" "$name" "$first" "${files[@]}" | cat -s >"$tmp"
  mv -f "$tmp" "$target"
  printf '%s: stack %s, %s sections from "%s"\n' "${target#"$root"/}" "$stack" "${#files[@]}" "$first"
}

cmd_check() {
  local root=$1 stack=$2 sections=$3
  local target="$root/CONTRIBUTING.md"
  local files=() first

  [ -f "$target" ] || { printf '%s: missing\n' "$root"; return 1; }
  mapfile -t files < <(section_files "$sections"; stack_files "$stack")
  is_rendered "$target" "${files[@]}" || { printf '%s: not rendered by this tool\n' "$root"; return 1; }
  first=$(rule_title "${files[0]}")
  if diff -q <(awk -v h="## $first" '$0==h {p=1} p' "$target" | cat -s) <(rendered_part "${files[@]}" | cat -s) >/dev/null; then
    printf '%s: current\n' "$root"
  else
    printf '%s: stale\n' "$root"
    return 1
  fi
}

cmd_list() {
  local file name
  printf 'Shared sections (default order):\n'
  for name in ${DEFAULT_SECTIONS//,/ }; do
    printf '  %-24s %s\n' "$name" "$(rule_title "$RULES_DIR/$name.md" 2>/dev/null || echo '(missing)')"
  done
  printf '\nStacks:\n'
  for file in "$RULES_DIR"/*.md; do
    [ -f "$file" ] || continue
    head -1 "$file" | grep -qx -- '---' || continue
    printf '  %-24s rule with paths, %s\n' "$(basename "$file" .md)" "$(rule_title "$file")"
  done
  for file in "$STACKS_DIR"/*/; do
    [ -d "$file" ] || continue
    printf '  %-24s directory in %s\n' "$(basename "$file")" "$STACKS_DIR"
  done
}

STACK=''
NAME=''
SECTIONS=$DEFAULT_SECTIONS
FORCE=0
ARGS=()
while [ $# -gt 0 ]; do
  case $1 in
    --stack) STACK=$2; shift 2 ;;
    --name) NAME=$2; shift 2 ;;
    --sections) SECTIONS=$2; shift 2 ;;
    --force) FORCE=1; shift ;;
    -h | --help) usage; exit 0 ;;
    --) shift; ARGS+=("$@"); break ;;
    -*) die "unknown option '$1'" ;;
    *) ARGS+=("$1"); shift ;;
  esac
done

[ ${#ARGS[@]} -eq 0 ] && { usage; exit 1; }

action=${ARGS[0]}
dir=${ARGS[1]:-.}
[ -d "$dir" ] || die "no such directory '$dir'"
root=$(project_root "$dir")
[ -n "$STACK" ] || STACK=$(detect_stack "$root")
[ -n "$NAME" ] || NAME=$(basename "$root")

case $action in
  render) cmd_render "$root" "$STACK" "$NAME" "$SECTIONS" "$FORCE" ;;
  check) cmd_check "$root" "$STACK" "$SECTIONS" ;;
  detect) printf '%s\n' "$STACK" ;;
  list) cmd_list ;;
  *) die "unknown command '$action'. Try: claude-contrib --help" ;;
esac
