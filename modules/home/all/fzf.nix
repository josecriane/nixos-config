{ ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    defaultCommand = "fd --type f --hidden --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--border"
      "--layout=reverse"
    ];

    fileWidget = {
      command = "fd --type f --hidden --exclude .git";
      options = [ "--preview 'head -200 {}'" ];
    };

    changeDirWidget = {
      command = "fd --type d --hidden --exclude .git";
      options = [ "--preview 'tree -C {} | head -200'" ];
    };
  };
}
