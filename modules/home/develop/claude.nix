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
        # Añade newline al final de archivos si no lo tienen
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
        # Notificación cuando Claude espera input
        Notification = [
          {
            matcher = "";
            hooks = [
              {
                type = "command";
                command = "${pkgs.libnotify}/bin/notify-send 'Claude Code' 'Awaiting your input' -u normal";
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
