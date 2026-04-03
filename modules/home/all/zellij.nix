{
  config,
  pkgs,
  lib,
  ...
}:
let
  colors = config.lib.stylix.colors;

  # Stylix provides per-channel RGB decimals: baseXX-rgb-{r,g,b}
  c = name: "${colors."${name}-rgb-r"} ${colors."${name}-rgb-g"} ${colors."${name}-rgb-b"}";

  # Generate a color group block for zellij KDL theme
  colorGroup = name: base: bg: e0: e1: e2: e3: ''
    ${name} {
      base ${c base}
      background ${c bg}
      emphasis_0 ${c e0}
      emphasis_1 ${c e1}
      emphasis_2 ${c e2}
      emphasis_3 ${c e3}
    }'';
in
{

  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "zsh";
      copy_on_select = true;
      scrollback_editor = "${pkgs.neovim}/bin/nvim";
      mouse_mode = true;
      show_startup_tips = false;
      simplified_ui = false;
      theme = "stylix";
      pane_frames = false;
      session_serialization = true;
      resurrect_dead_sessions = true;
      pane_viewport_serialization = true;

      keybinds = {
        unbind._args = [ "Ctrl g" ];
        normal._children = [
          {
            bind._args = [ "Ctrl Shift g" ];
            bind._children = [ { SwitchToMode._args = [ "locked" ]; } ];
          }
        ];
        locked._children = [
          {
            bind._args = [ "Ctrl Shift g" ];
            bind._children = [ { SwitchToMode._args = [ "normal" ]; } ];
          }
        ];
      };
    };
  };

  # Stylix's zellij target generates hex colors, but zellij 0.44+ needs RGB decimal
  stylix.targets.zellij.enable = false;

  programs.zellij.extraConfig = ''
    new_tab_template {
      pane size=1 borderless=true {
        plugin location="zellij:tab-bar"
      }
      pane
      pane size=1 borderless=true {
        plugin location="zellij:status-bar"
      }
    }

    themes {
      stylix {
    ${colorGroup "text_unselected" "base05" "base01" "base09" "base0C" "base0B" "base0F"}
    ${colorGroup "text_selected" "base05" "base04" "base09" "base0C" "base0B" "base0F"}
    ${colorGroup "ribbon_selected" "base01" "base0E" "base08" "base09" "base0F" "base0D"}
    ${colorGroup "ribbon_unselected" "base01" "base05" "base08" "base05" "base0D" "base0F"}
    ${colorGroup "table_title" "base0E" "base00" "base09" "base0C" "base0B" "base0F"}
    ${colorGroup "table_cell_selected" "base05" "base04" "base09" "base0C" "base0B" "base0F"}
    ${colorGroup "table_cell_unselected" "base05" "base01" "base09" "base0C" "base0B" "base0F"}
    ${colorGroup "list_selected" "base05" "base04" "base09" "base0C" "base0B" "base0F"}
    ${colorGroup "list_unselected" "base05" "base01" "base09" "base0C" "base0B" "base0F"}
    ${colorGroup "frame_selected" "base0E" "base00" "base09" "base0C" "base0F" "base00"}
    ${colorGroup "frame_highlight" "base08" "base00" "base0F" "base09" "base09" "base09"}
    ${colorGroup "exit_code_success" "base0B" "base00" "base0C" "base01" "base0F" "base0D"}
    ${colorGroup "exit_code_error" "base08" "base00" "base0A" "base00" "base00" "base00"}
        multiplayer_user_colors {
          player_1 ${c "base0F"}
          player_2 ${c "base0D"}
          player_3 ${c "base00"}
          player_4 ${c "base0A"}
          player_5 ${c "base0C"}
          player_6 ${c "base00"}
          player_7 ${c "base08"}
          player_8 ${c "base00"}
          player_9 ${c "base00"}
          player_10 ${c "base00"}
        }
      }
    }
  '';

  home.shellAliases = {
    zj = "zellij";
    zja = "zellij attach";
    zjls = "zellij list-sessions";
    zjk = "zellij kill-session";
  };

  # Auto-rename tabs based on current directory (respects manual renames)
  programs.zsh.initContent = lib.mkAfter ''
    if [ -n "$ZELLIJ" ]; then
      # Store the last directory we auto-named the tab for
      ZELLIJ_LAST_AUTO_DIR=""

      function _zellij_update_tab_name() {
        # If we're in the same directory, don't rename
        # This helps preserve manual renames
        if [ "$PWD" = "$ZELLIJ_LAST_AUTO_DIR" ]; then
          return
        fi

        local current_dir="''${PWD##*/}"

        # If we're in home directory, use "~"
        if [ "$PWD" = "$HOME" ]; then
          current_dir="~"
        fi

        # If we're in a git repository, use the repo name
        if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          local repo_name=$(basename $(git rev-parse --show-toplevel))
          local repo_path=$(git rev-parse --show-prefix)
          if [ -n "$repo_path" ]; then
            current_dir="$repo_name/''${repo_path%/}"
          else
            current_dir="$repo_name"
          fi
        fi

        # Update the tab name
        command zellij action rename-tab "$current_dir" 2>/dev/null || true

        # Remember this directory so we don't rename again while here
        ZELLIJ_LAST_AUTO_DIR="$PWD"
      }

      # Hook to update tab name when changing directories
      function chpwd() {
        _zellij_update_tab_name
      }

      # Update tab name on shell startup
      _zellij_update_tab_name
    fi
  '';
}
