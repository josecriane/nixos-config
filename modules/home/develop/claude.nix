{
  pkgs,
  config,
  lib,
  ...
}:
let
  colors = config.lib.stylix.colors;
  toHex = color: "hex:${color}";
in
{
  home.packages = with pkgs; [
    bun
    nodejs_22
    libnotify
  ];

  programs.claude-code = {
    enable = true;

    settings = {
      # StatusLine con ccstatusline
      statusLine = {
        type = "command";
        command = "bunx ccstatusline@latest";
        padding = 0;
      };

      hooks = {
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
                      /command="claude"/ && /cwd="/ {
                        n = split($0, a, "cwd=\""); split(a[2], b, "\"");
                        if (root "/" b[1] == ENVIRON["PWD"]) { print idx; exit }
                      }')
                    ACTION=$(${pkgs.libnotify}/bin/notify-send 'Claude Code' 'Awaiting your input' -u normal \
                      --hint="string:desktop-entry:Alacritty" \
                      -A 'default=Open')
                    if [ "$ACTION" = "default" ]; then
                      # Find the Alacritty window that is our ancestor process
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
  };

  # Configuración de ccstatusline
  xdg.configFile."ccstatusline/settings.json".text = builtins.toJSON {
    version = 3;
    lines = [
      [
        {
          id = "1";
          type = "model";
          color = toHex colors.base0D;
        } # azul
        {
          id = "2";
          type = "separator";
        }
        {
          id = "3";
          type = "session-cost";
          color = toHex colors.base0B;
        } # verde
        {
          id = "4";
          type = "separator";
        }
        {
          id = "5";
          type = "context-percentage";
          color = toHex colors.base0A;
        } # amarillo
        {
          id = "6";
          type = "separator";
        }
        {
          id = "7";
          type = "git-branch";
          color = toHex colors.base0E;
        } # morado
      ]
      [ ]
      [ ]
    ];
    flexMode = "full-minus-40";
    compactThreshold = 60;
    colorLevel = 3;
    globalBold = false;
    powerline = {
      enabled = false;
      separators = [ "" ];
      separatorInvertBackground = [ false ];
      startCaps = [ ];
      endCaps = [ ];
      autoAlign = false;
    };
  };
}
