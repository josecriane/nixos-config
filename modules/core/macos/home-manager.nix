{
  pkgs,
  inputs,
  machineOptions,
  self,
  ...
}:
let
  username = machineOptions.username;
in
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    backupFileExtension = "bak";

    extraSpecialArgs = {
      inherit
        inputs
        machineOptions
        self
        ;
      host = machineOptions.hostname;
    };

    users.${username} = {
      imports = [
        ./../../home
      ];
      home.username = "${username}";
      home.homeDirectory = "/Users/${username}";
      home.stateVersion = "25.05";
      programs.home-manager.enable = true;
    };
  };

  users.users.${username} = {
    home = "/Users/${username}";
    description = "${username}";

    shell = pkgs.zsh;
  };

  nix.settings.trusted-users = [ username ];
}
