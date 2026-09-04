{ lib, pkgs, ... }:
let
  # core.hooksPath makes git ignore each repo's .git/hooks, so every hook we
  # install has to hand over to the repo-local one after doing its own work.
  chainToRepoHook = name: ''
    repoHook="$(git rev-parse --path-format=absolute --git-common-dir)/hooks/${name}"
    if [ -x "$repoHook" ]; then
      exec "$repoHook" "$@"
    fi
  '';

  mkHook = name: guard: pkgs.writeShellScript name (guard + chainToRepoHook name);

  passthroughHooks = [
    "applypatch-msg"
    "post-applypatch"
    "post-checkout"
    "post-commit"
    "post-index-change"
    "post-merge"
    "post-rewrite"
    "pre-applypatch"
    "pre-auto-gc"
    "pre-commit"
    "pre-merge-commit"
    "pre-push"
    "pre-rebase"
    "prepare-commit-msg"
    "sendemail-validate"
  ];

  rejectClaudeCoauthor = ''
    if grep -qiE '^[[:space:]]*co-authored-by:.*(claude|anthropic)' "$1"; then
      echo "commit-msg: rejected, the message carries a Claude/Anthropic Co-authored-by trailer." >&2
      echo "            remove it and commit again (--no-verify skips this check)." >&2
      exit 1
    fi
  '';

  gitHooks = pkgs.linkFarm "git-hooks" (
    {
      "commit-msg" = mkHook "commit-msg" rejectClaudeCoauthor;
    }
    // lib.genAttrs passthroughHooks (name: mkHook name "")
  );
in
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Jose E. Cribeiro Aneiros";
        email = "josecriane@gmail.com";
      };

      alias = {
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

      core.editor = "vim";
      core.hooksPath = "${gitHooks}";

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
      push.autoSetupRemote = true;

      status.submoduleSummary = true;
    };

    ignores = [
      ".DS_Store"
      ".vscode"
      "erlang_ls.config"
      "CLAUDE.md"
      ".envrc"
      ".direnv"
      ".claude"
    ];
  };

  programs.zsh.shellAliases = {
    gti = "git";
    git-clean-branch = "git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -r git branch -D";
  };
}
