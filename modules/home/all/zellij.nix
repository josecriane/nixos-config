{
  config,
  pkgs,
  lib,
  ...
}:
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

  stylix.targets.zellij.enable = true;

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
