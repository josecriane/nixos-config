{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    #zplug = {
    #  plugins = [
    #    { name = "zsh-users/zsh-autosuggestions"; }
    #    { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
    #  ];
    #};
    
    ohMyZsh = {
      enable = true;
      plugins = [
        "asdf"
        "git"
        "ssh-agent"
        "sudo"
        "colored-man-pages"
        "colorize"
      ];
      theme = "robbyrussell";
    };
  };
}
