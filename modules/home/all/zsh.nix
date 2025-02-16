{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    sessionVariables = {
      EDITOR = "vim";
      GPG_TTY = "$(tty)";
      TERM = "xterm-256color";
    };
  };
}