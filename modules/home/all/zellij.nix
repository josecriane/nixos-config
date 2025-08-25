{ config, pkgs, ... }:
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
    };
  };

  stylix.targets.zellij.enable = true;

  home.shellAliases = {
    zj = "zellij";
    zja = "zellij attach";
    zjls = "zellij list-sessions";
    zjk = "zellij kill-session";
  };
}
