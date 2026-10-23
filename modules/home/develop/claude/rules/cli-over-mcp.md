## CLI over MCP

When both a CLI tool and an MCP server can accomplish the same task,
prefer the CLI tool. CLI tools are faster, more predictable, and
easier to debug.

Examples:
- Use `gh` CLI for GitHub operations instead of a GitHub MCP server
- Use `git` directly instead of MCP-based git tools
- Use `curl`/`wget` for HTTP requests instead of fetch MCP servers
- Use `psql`/`sqlite3` for database queries instead of database MCP servers
- Use `rg`/grep for file search instead of filesystem MCP servers

MCP servers are appropriate when:
- No CLI equivalent exists (e.g., browser automation via Playwright)
- The MCP server provides capabilities beyond what CLI offers
- The task requires persistent state that the MCP server manages
