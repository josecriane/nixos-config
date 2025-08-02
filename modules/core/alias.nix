{ config, pkgs, ... }:
{
  environment.shellAliases = {
    cdev = "_rcd dev";
    cdocs = "_rcd docs";
    cder = "_rcd dev erlang";
    cdl = "_rcd libs";
    cdtmp = "_rcd tmp";
    cp = "cp -r";
    cdnix = "cd ~/nixos-config";
    nixgc = "sudo nix-env --delete-generations old; sudo nix-store --gc; sudo nix-collect-garbage -d";
  };

  environment.interactiveShellInit = ''
    _rcd() {
      local base_dir="${"$"}{1:-dev}"
      local sub_dir="${"$"}{2}"
      
      if [ -z "$sub_dir" ]; then
        cd ~/"$base_dir"
      else
        cd ~/"$base_dir"/"$sub_dir"
      fi
    }
  '';
}
