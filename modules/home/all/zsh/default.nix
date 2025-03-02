{ pkgs, self, ... }:
{
  home.packages = with pkgs; [
    meslo-lgs-nf
    zsh-powerlevel10k
  ];

  home.file.".p10k.zsh".source = "${self}/modules/home/all/zsh/.p10k.zsh";

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtra = ''
      export PATH="$PATH:$HOME/nixos-config/scripts"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "asdf"
        "git"
        "colored-man-pages"
        "colorize"
      ];
    };

    sessionVariables = {
      EDITOR = "vim";
      GPG_TTY = "$(tty)";
      TERM = "xterm-256color";
    };
  };
}