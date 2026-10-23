# SessionStart hook. Prints one line per thing Claude must know about the
# rule state of the project, and nothing when all is current. Always exits 0.

root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
stack=$(claude-contrib detect "$root")
[ "$stack" = none ] && exit 0

if ! state=$(claude-stack -C "$root" check "$stack" 2>/dev/null); then
  case ${state##*"$stack" } in
    -) printf 'claude-stack: the %s stack applies here and is not copied in. Run: claude-stack add %s\n' "$stack" "$stack" ;;
    symlink*) printf 'claude-stack: the %s copy is a symlink and does not load. Run: claude-stack add %s\n' "$stack" "$stack" ;;
    *) printf 'claude-stack: the %s copy is %s. Run: claude-stack sync\n' "$stack" "${state##*"$stack" }" ;;
  esac
fi

if [ -f "$root/CONTRIBUTING.md" ]; then
  case $(claude-contrib check "$root" 2>/dev/null || true) in
    *stale) printf 'claude-contrib: CONTRIBUTING.md is stale. Run: claude-contrib render\n' ;;
  esac
fi

exit 0
