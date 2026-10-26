{ ... }:
{
  environment.shellAliases = {
    nixrebuild = "nix-mac -s";
    nixupdate = "nix flake update";
  };
}
