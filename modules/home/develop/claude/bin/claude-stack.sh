STACKS_DIR="${CLAUDE_STACKS_DIR:-$HOME/.claude/stacks}"
MARK='<!-- claude-stack:'

die() {
  printf 'claude-stack: %s\n' "$1" >&2
  exit 1
}

usage() {
  cat <<'EOF'
Copy a shared rule stack into a project so its rules load there.

Usage:
  claude-stack list                Show every stack and its state in this project
  claude-stack add <stack>...      Copy stacks into this project
  claude-stack remove <stack>...   Delete the copies from this project
  claude-stack check [<stack>...]  Exit 1 when a copy is stale, missing or a symlink
  claude-stack sync                Refresh every stale copy in this project
  claude-stack where               Print the stacks directory

Options:
  -C <dir>    Operate on the project that contains <dir> instead of the
              current directory
  --ignore    With add or remove, also update .git/info/exclude, which is
              local to this clone and never committed

A stack is a directory of markdown rules under the stacks directory. `add`
copies each file to .claude/rules/<stack>/ and puts a marker with the hash
of the source on its first line. Claude Code reads .claude/rules/
recursively, so every copied file applies. A symlink to the stacks directory
does not load, because Claude Code treats a link outside the project as an
external import. `add` replaces such a link with a copy.
EOF
}

project_root() {
  local dir=$1 root
  if root=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null) && [ -n "$root" ]; then
    printf '%s\n' "$root"
  else
    printf '%s\n' "$(cd "$dir" && pwd)"
  fi
}

stack_names() {
  [ -d "$STACKS_DIR" ] || return 0
  find "$STACKS_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort
}

require_stack() {
  [ -d "$STACKS_DIR/$1" ] || die "no such stack '$1'. Try: claude-stack list"
}

source_files() {
  find "$STACKS_DIR/$1" -maxdepth 1 \( -type f -o -type l \) -name '*.md' -printf '%f\n' | sort
}

source_hash() {
  sha256sum <"$1" | cut -c1-16
}

has_mark() {
  [ -f "$1" ] && head -1 "$1" | grep -qF "$MARK"
}

copy_hash() {
  head -1 "$1" | grep -o 'sha256=[0-9a-f]*' | cut -d= -f2
}

git_exclude() {
  local root=$1 line=$2 mode=$3 file
  file="$root/.git/info/exclude"
  [ -d "$root/.git" ] || return 0
  case $mode in
    add)
      mkdir -p "$root/.git/info"
      touch "$file"
      grep -qxF "$line" "$file" || printf '%s\n' "$line" >>"$file"
      ;;
    remove)
      [ -f "$file" ] || return 0
      grep -vxF "$line" "$file" >"$file.tmp" || true
      mv "$file.tmp" "$file"
      ;;
  esac
}

stack_state() {
  local name=$1 dest=$2 file
  if [ -L "$dest" ]; then
    printf 'symlink, does not load, run: claude-stack add %s\n' "$name"
  elif [ ! -e "$dest" ]; then
    printf -- '-\n'
  elif [ ! -d "$dest" ]; then
    printf 'BLOCKED by a real file\n'
  else
    for file in "$dest"/*; do
      [ -e "$file" ] || continue
      has_mark "$file" || { printf 'BLOCKED by a file without marker\n'; return 0; }
    done
    while IFS= read -r file; do
      if [ ! -f "$dest/$file" ] || [ "$(copy_hash "$dest/$file")" != "$(source_hash "$STACKS_DIR/$name/$file")" ]; then
        printf 'stale\n'
        return 0
      fi
    done < <(source_files "$name")
    for file in "$dest"/*; do
      [ -e "$file" ] || continue
      [ -f "$STACKS_DIR/$name/$(basename "$file")" ] || { printf 'stale\n'; return 0; }
    done
    printf 'linked\n'
  fi
}

copy_stack() {
  local name=$1 dest=$2 file hash tmp
  mkdir -p "$dest"
  for file in "$dest"/*; do
    [ -e "$file" ] || continue
    rm -- "$file"
  done
  while IFS= read -r file; do
    hash=$(source_hash "$STACKS_DIR/$name/$file")
    tmp=$(mktemp "$dest/.$file.XXXXXX")
    {
      printf '%s %s/%s sha256=%s -->\n' "$MARK" "$name" "$file" "$hash"
      cat "$STACKS_DIR/$name/$file"
    } >"$tmp"
    mv -f "$tmp" "$dest/$file"
  done < <(source_files "$name")
}

cmd_list() {
  local root=$1 rules name
  rules="$root/.claude/rules"
  if [ -z "$(stack_names)" ]; then
    printf 'No stacks in %s\n' "$STACKS_DIR"
    return 0
  fi
  printf 'Stacks in %s\nProject %s\n\n' "$STACKS_DIR" "$root"
  while IFS= read -r name; do
    printf '  %-16s %s\n' "$name" "$(stack_state "$name" "$rules/$name")"
  done < <(stack_names)
}

cmd_add() {
  local root=$1 rules name dest target verb
  shift
  rules="$root/.claude/rules"
  for name in "$@"; do
    require_stack "$name"
    dest="$rules/$name"
    verb=copied
    if [ -L "$dest" ]; then
      target=$(readlink -- "$dest")
      case $target in
        "$STACKS_DIR"/*) ;;
        *) die "$dest points at $target, outside $STACKS_DIR. Refusing to replace it." ;;
      esac
      rm -- "$dest"
      verb='replaced symlink with a copy'
    elif [ -e "$dest" ]; then
      case $(stack_state "$name" "$dest") in
        BLOCKED*) die "$dest holds files that claude-stack did not write. Move them first." ;;
        linked) verb='already current' ;;
        stale) verb=refreshed ;;
      esac
    fi
    [ "$verb" = 'already current' ] || copy_stack "$name" "$dest"
    printf '  %-16s %s\n' "$name" "$verb"
    [ "$IGNORE" = 1 ] && git_exclude "$root" "/.claude/rules/$name" add
  done
  printf '\nStart a new session for the change to take effect.\n'
}

cmd_remove() {
  local root=$1 rules name dest target file
  shift
  rules="$root/.claude/rules"
  for name in "$@"; do
    dest="$rules/$name"
    if [ -L "$dest" ]; then
      target=$(readlink -- "$dest")
      case $target in
        "$STACKS_DIR"/*) ;;
        *) die "$dest points at $target, outside $STACKS_DIR. Refusing to remove it." ;;
      esac
      rm -- "$dest"
      printf '  %-16s unlinked\n' "$name"
    elif [ -d "$dest" ]; then
      for file in "$dest"/*; do
        [ -e "$file" ] || continue
        has_mark "$file" || die "$file has no claude-stack marker. Refusing to remove it."
      done
      for file in "$dest"/*; do
        [ -e "$file" ] || continue
        rm -- "$file"
      done
      rmdir -- "$dest"
      printf '  %-16s removed\n' "$name"
    elif [ -e "$dest" ]; then
      die "$dest is not a stack copy. Refusing to remove it."
    else
      printf '  %-16s not linked\n' "$name"
      continue
    fi
    [ "$IGNORE" = 1 ] && git_exclude "$root" "/.claude/rules/$name" remove
  done
  rmdir "$rules" 2>/dev/null || true
}

present_stacks() {
  local root=$1 rules name
  rules="$root/.claude/rules"
  while IFS= read -r name; do
    [ -e "$rules/$name" ] || [ -L "$rules/$name" ] || continue
    printf '%s\n' "$name"
  done < <(stack_names)
}

cmd_check() {
  local root=$1 rules name state status=0 names=()
  shift
  rules="$root/.claude/rules"
  if [ $# -gt 0 ]; then
    names=("$@")
  else
    mapfile -t names < <(present_stacks "$root")
  fi
  [ ${#names[@]} -gt 0 ] || { printf '%s: no stack\n' "$root"; return 0; }
  for name in "${names[@]}"; do
    require_stack "$name"
    state=$(stack_state "$name" "$rules/$name")
    printf '%s: %s %s\n' "$root" "$name" "$state"
    [ "$state" = linked ] || status=1
  done
  return $status
}

cmd_sync() {
  local root=$1 rules name state todo=()
  rules="$root/.claude/rules"
  while IFS= read -r name; do
    state=$(stack_state "$name" "$rules/$name")
    case $state in
      stale | symlink*) todo+=("$name") ;;
    esac
  done < <(present_stacks "$root")
  if [ ${#todo[@]} -eq 0 ]; then
    printf '%s: current\n' "$root"
    return 0
  fi
  cmd_add "$root" "${todo[@]}"
}

IGNORE=0
DIR=.
ARGS=()
while [ $# -gt 0 ]; do
  case $1 in
    --ignore) IGNORE=1; shift ;;
    -C) DIR=$2; shift 2 ;;
    -h | --help) usage; exit 0 ;;
    *) ARGS+=("$1"); shift ;;
  esac
done

[ ${#ARGS[@]} -eq 0 ] && { usage; exit 1; }
[ -d "$DIR" ] || die "no such directory '$DIR'"

action=${ARGS[0]}
rest=("${ARGS[@]:1}")
root=$(project_root "$DIR")

case $action in
  list) cmd_list "$root" ;;
  where) printf '%s\n' "$STACKS_DIR" ;;
  add)
    [ ${#rest[@]} -eq 0 ] && die 'add needs at least one stack name'
    cmd_add "$root" "${rest[@]}"
    ;;
  remove | rm)
    [ ${#rest[@]} -eq 0 ] && die 'remove needs at least one stack name'
    cmd_remove "$root" "${rest[@]}"
    ;;
  check) cmd_check "$root" "${rest[@]}" ;;
  sync) cmd_sync "$root" ;;
  *) die "unknown command '$action'. Try: claude-stack --help" ;;
esac
