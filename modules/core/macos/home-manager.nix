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
      home.homeDirectory = "/Users/${username}";
      home.stateVersion = "25.05";
      programs.home-manager.enable = true;
    };
  };

  users.users.${username} = {
    home = "/Users/${username}"; 
    # isNormalUser = true;
    description = "${username}";
    # extraGroups = [
    #   "networkmanager"
    #   "wheel"
    # ];
    shell = pkgs.zsh;
  };

  nix.settings.trusted-users = [username];

#   nix.settings.allowed-users = [ "${username}" ];
}
