{
  pkgs,
  self,
  lib,
  ...
}:
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

    enableCompletion = true;
    completionInit = ''
      autoload -Uz compinit
      compinit
    '';

    initContent = ''
      export PATH="$PATH:$HOME/nixos-config/scripts:$HOME/scripts"

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      ${
        if pkgs.stdenv.isDarwin then
          "[[ ! -f ~/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh"
        else
          "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh"
      }

      # Completion for _rcd function
      _rcd_complete() {
        local state
        _arguments \
          '1:base directory:(dev docs libs tmp)' \
          '2:subdirectory:_path_files -W "$HOME/$words[2]" -/'
      }

      compdef _rcd_complete _rcd

      # Auto-attach to zellij session if not already in one
      # Only run in interactive shells and when not in SSH
      if [[ -o interactive ]] && [[ -z "$ZELLIJ" ]] && [[ -z "$SSH_CONNECTION" ]]; then
        # Check if we're in a terminal that supports zellij
        if [[ -t 0 ]] && [[ -t 1 ]] && [[ -t 2 ]]; then
          # Attach to "default" session or create it if it doesn't exist
          zellij attach -c default
        fi
      fi
    '';

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "ssh-agent"
        "sudo"
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
