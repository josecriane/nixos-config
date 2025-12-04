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
  imports = [ inputs.home-manager.nixosModules.home-manager ];

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
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "25.11";
      programs.home-manager.enable = true;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "docker"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  # STIG V-268152: Restrict software installation to authorized users
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268152
  nix.settings.allowed-users = [ "${username}" ];
}
