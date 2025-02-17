{ pkgs, self, ... }:
{
  home.packages = with pkgs; [
    meslo-lgs-nf
    zsh-powerlevel10k
  ];

  home.file.".p10k.zsh".source = "${self}/modules/home/all/zsh/.p10k.zsh";

  programs.zsh = {
    enable = true;

    sessionVariables = {
      EDITOR = "vim";
      GPG_TTY = "$(tty)";
      TERM = "xterm-256color";
    };
  };
}