{ pkgs, ... }:
{
  home.packages = with pkgs; [
    meld
  ];

  programs.git.extraConfig = {
    diff.tool = "meld";
    merge.tool = "meld";
  };
}
