{
  lib,
  pkgs,
  config,
  ...
}:
let
  ruleToolInputs = with pkgs; [
    coreutils
    diffutils
    findutils
    gawk
    git
    gnugrep
    gnused
  ];

  claudeStack = pkgs.writeShellApplication {
    name = "claude-stack";
    runtimeInputs = ruleToolInputs;
    text = builtins.readFile ./bin/claude-stack.sh;
  };

  claudeContrib = pkgs.writeShellApplication {
    name = "claude-contrib";
    runtimeInputs = ruleToolInputs;
    text = builtins.readFile ./bin/claude-contrib.sh;
  };

  sessionCheckHook = pkgs.writeShellApplication {
    name = "claude-session-check";
    runtimeInputs = [
      pkgs.git
      claudeStack
      claudeContrib
    ];
    text = builtins.readFile ./hooks/session-check.sh;
  };

  adhdAlwaysOnHook = pkgs.writeShellApplication {
    name = "claude-adhd-always-on";
    runtimeInputs = with pkgs; [ gawk ];
    text = builtins.readFile ./hooks/adhd-always-on.sh;
  };

  goplsWithGo = pkgs.writeShellApplication {
    name = "gopls";
    runtimeInputs = with pkgs; [
      go
      gopls
    ];
    text = ''
      exec gopls "$@"
    '';
  };
in
{
  home.packages = with pkgs; [
    nodejs_22
    libnotify
    claudeStack
    claudeContrib
  ];

  programs.claude-code = {
    enable = true;
    context = ./global-context.md;
    rulesDir = ./rules;
    agentsDir = ./agents;
    skills = ./skills;
    lspServers = {
      nix = {
        command = lib.getExe pkgs.nixd;
        extensionToLanguage = {
          ".nix" = "nix";
        };
      };
      rust = {
        command = lib.getExe pkgs.rust-analyzer;
        extensionToLanguage = {
          ".rs" = "rust";
        };
      };
      erlang = {
        command = lib.getExe' pkgs.erlang-language-platform "elp";
        args = [ "server" ];
        extensionToLanguage = {
          ".erl" = "erlang";
          ".hrl" = "erlang";
          ".escript" = "erlang";
        };
      };
      go = {
        command = lib.getExe goplsWithGo;
        extensionToLanguage = {
          ".go" = "go";
        };
      };
      elixir = {
        command = lib.getExe' pkgs.elixir-ls "elixir-ls";
        extensionToLanguage = {
          ".ex" = "elixir";
          ".exs" = "elixir";
          ".heex" = "phoenix-heex";
        };
      };
    };
  };

  home.file.".claude/stacks" = {
    source = ./stacks;
    recursive = true;
  };

  # Write settings.json as a mutable copy instead of a read-only nix store symlink,
  # so Claude Code can write runtime changes (effort level, etc.)
  home.activation.claudeCodeSettings =
    let
      settingsFile = (pkgs.formats.json { }).generate "claude-code-settings.json" {
        "$schema" = "https://json.schemastore.org/claude-code-settings.json";
        statusLine = {
          type = "command";
          command = "${lib.getExe pkgs.perl} ${./statusline.pl} ${lib.getExe pkgs.git}";
          padding = 0;
        };
        hooks = {
          SessionStart = [
            {
              matcher = "";
              hooks = [
                {
                  type = "command";
                  command = "${sessionCheckHook}/bin/claude-session-check";
                }
                {
                  type = "command";
                  command = "${adhdAlwaysOnHook}/bin/claude-adhd-always-on ${./skills/i-have-adhd/SKILL.md}";
                }
              ];
            }
          ];
          PreToolUse = [
            {
              matcher = "Write|Edit|NotebookEdit|Bash";
              hooks = [
                {
                  type = "command";
                  command = "${pkgs.perl}/bin/perl ${./hooks/style-gate.pl}";
                }
              ];
            }
          ];
          PostToolUse = [
            {
              matcher = "Edit|Write";
              hooks = [
                {
                  type = "command";
                  command = ''
                    file_path=$(jq -r '.tool_input.file_path // empty'); if [ -n "$file_path" ] && [ -f "$file_path" ] && [ -n "$(tail -c 1 "$file_path")" ]; then echo >> "$file_path"; fi
                  '';
                }
              ];
            }
          ];
          Notification = [
            {
              matcher = "";
              hooks = [
                {
                  type = "command";
                  command = ''
                    (
                      ZELLIJ_TAB_INDEX=$(zellij action dump-layout 2>/dev/null | awk '
                        /^[[:space:]]*cwd "/ && root == "" { split($0, a, "\""); root = a[2]; next }
                        /^[[:space:]]*tab / { idx++ }
                        /command=.*claude/ && /cwd="/ {
                          n = split($0, a, "cwd=\""); split(a[2], b, "\"");
                          if (root "/" b[1] == ENVIRON["PWD"]) { print idx; exit }
                        }')
                      ACTION=$(${pkgs.libnotify}/bin/notify-send 'Claude Code' 'Awaiting your input' -u normal \
                        --hint="string:desktop-entry:Alacritty" \
                        -A 'default=Open')
                      if [ "$ACTION" = "default" ]; then
                        ALACRITTY_WINDOWS=$(niri msg --json windows | ${pkgs.jq}/bin/jq -r '.[] | select(.app_id == "Alacritty") | "\(.pid) \(.id)"')
                        WALK_PID=$$
                        WINDOW_ID=""
                        while [ "$WALK_PID" -gt 1 ] && [ -z "$WINDOW_ID" ]; do
                          WINDOW_ID=$(echo "$ALACRITTY_WINDOWS" | awk -v p="$WALK_PID" '$1 == p {print $2}')
                          WALK_PID=$(awk '{print $4}' /proc/$WALK_PID/stat 2>/dev/null || break)
                        done
                        [ -n "$WINDOW_ID" ] && niri msg action focus-window --id "$WINDOW_ID"
                        if [ -n "$ZELLIJ_TAB_INDEX" ] && [ -n "$ZELLIJ_SESSION_NAME" ]; then
                          zellij --session "$ZELLIJ_SESSION_NAME" action go-to-tab "$ZELLIJ_TAB_INDEX"
                        fi
                      fi
                    ) &
                  '';
                }
              ];
            }
          ];
        };
      };
    in
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.claude"
      rm -f "$HOME/.claude/settings.json"
      cp "${settingsFile}" "$HOME/.claude/settings.json"
      chmod u+w "$HOME/.claude/settings.json"
    '';
}
