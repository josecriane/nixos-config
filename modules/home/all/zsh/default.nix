{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    meslo-lgs-nf
    zsh-powerlevel10k
  ];

  home.file.".p10k.zsh".source = ./.p10k.zsh;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 100000;
      save = 100000;
    };

    enableCompletion = true;
    completionInit = ''
      autoload -Uz compinit
      compinit
    '';

    initContent = ''
      export PATH="$PATH:$HOME/scripts"

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Completion for _rcd function
      _rcd_complete() {
        local state
        _arguments \
          '1:base directory:()' \
          '2:subdirectory:_path_files -W "$HOME/$words[2]" -/'
      }

      compdef _rcd_complete _rcd
    '';

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = "${pkgs.zsh-nix-shell}/share/zsh/plugins/zsh-nix-shell";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "colored-man-pages"
        "colorize"
      ];
    };

    sessionVariables = {
      EDITOR = "vim";
      GPG_TTY = "$(tty)";
    };
  };
}
