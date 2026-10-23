## Data Wrangling

When inspecting, filtering, or transforming command output, logs, or
files, reach for Unix text tools before any scripting language.
Python is not installed on these machines. Do not assume it, and do
not write a temporary `.py` script to parse output.

Preferred tools (all verified present on this system):
- JSON: `jq`
- YAML: `yq`
- fields / columns / arithmetic / stats: `awk`, `cut`, `paste`, `column`
- stream edits: `sed`, `tr`
- search: `rg` (ripgrep), `grep`
- sort / dedupe / count: `sort`, `uniq`, `wc`, `comm`
- float math: `bc`
- complex one-offs: `perl` (always available, runs the statusline)

Rules:
- Build a pipeline of these tools first; compose with `|`.
- Escalate to a scripting language only when the logic genuinely
  exceeds a pipeline (multi-pass state, nested-grammar parsing). When
  you do, use `perl`, never `python`.
- If you believe you need Python, stop and verify first:
  `command -v python3 || echo absent`.
- Keep transformations in the shell; do not pull data into a REPL.
