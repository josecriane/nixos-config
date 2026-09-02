{
  config,
  pkgs,
  inputs,
  machineOptions,
  self,
  ...
}:
let
  username = config.machine.username;
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
    };
    users.${username} = {
      imports = [
        inputs.android-nixpkgs.hmModule
        ./../../options.nix
        ./../../home
      ];
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "26.05";
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
      "kvm"
    ];
    shell = pkgs.zsh;
  };

}
