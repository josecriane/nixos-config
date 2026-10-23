# SessionStart hook. Prints the i-have-adhd skill given as $1 when the flag
# file exists, and nothing otherwise. Always exits 0.

flag="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.i-have-adhd-always"
skill=${1:-}
[ -f "$flag" ] || exit 0
[ -f "$skill" ] || exit 0

printf 'ADHD MODE ACTIVE (always-on). The ruleset below applies to every response. "stop adhd mode" turns it off for this session. Delete %s to turn always-on off.\n\n' "$flag"
awk 'NR==1 && $0=="---" {skip=1; next} skip && $0=="---" {skip=0; next} !skip' "$skill"

exit 0
