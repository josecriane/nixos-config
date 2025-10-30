{ pkgs, ... }:
{
  home.packages = with pkgs; [
    meld
  ];

  programs.git.settings = {
    diff.tool = "meld";
    merge.tool = "meld";
  };
}
