{
  pkgs,
  inputs,
  host,
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
    
    extraSpecialArgs = { inherit inputs host machineOptions self; };
    users.${username} = {
      imports = [
        ./../../home
      ];
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "24.11";
      programs.home-manager.enable = true;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  nix.settings.allowed-users = [ "${username}" ];
}
