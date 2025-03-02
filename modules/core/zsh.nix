{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    #zplug = {
    #  plugins = [
    #    { name = "zsh-users/zsh-autosuggestions"; }
    #    { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
    #  ];
    #};

    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };
}
