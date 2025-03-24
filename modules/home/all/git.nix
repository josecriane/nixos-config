{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;

    userName = "Jose E. Cribeiro Aneiros";
    userEmail = "josecriane@gmail.com";

    aliases = {
      amend = "commit --amend --no-edit";
      br = "branch";
      ci = "commit";
      co = "checkout";
      lg = "log --graph --format=format:'%C(bold cyan)%h%C(reset)%C(bold yellow)%d%C(reset) %C(bold green)%ar%C(reset) %C(white)%s%C(reset) %C(dim white)%an%C(reset)%C(reset)' --all";
      resetveryhard = "!git reset --hard && git clean -ffxd && git submodule foreach --recursive 'git reset --hard && git clean -ffxd'";
      st = "status";
      sup = "submodule update --init --recursive";
      tree = "log --oneline --graph --decorate --all";
    };

    extraConfig = {
      core.editor = "vim";

      credential.helper = "store";

      diff.submodule = "log";

      filter.lfs = {
          clean = "git lfs clean %f";
          required = true;
          smudge = "git lfs smudge %f";
      };

      gpg.program = "gpg";

      mergetool.keepBackup = false;

      pull.rebase = false;

      push.default = "simple";

      status.submoduleSummary = true;
    };

    ignores = [
      ".DS_Store"
      ".vscode"
      "erlang_ls.config"
    ];
  };

  programs.zsh.shellAliases = {
    gti = "git";
    git-clean-branch="git branch --merged | grep -v \\* | xargs git branch -D";
  };
}
