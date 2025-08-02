{ config, lib, pkgs, inputs, machineOptions, host, self, ... }:

{
  imports = [
    inputs.agenix.darwinModules.default
  ];

  config = {
    age.identityPaths = [
      "/etc/agenix/agenix-key.age"
    ];

    age.secrets = {
      # SSH RSA private key
      "id_rsa" = {
        file = "${inputs.secrets}/id_rsa.age";
        path = "/Users/${machineOptions.username}/.ssh/id_rsa";
        mode = "600";
        owner = machineOptions.username;
        group = "staff";
      };
      
      # SSH RSA public key
      "id_rsa_pub" = {
        file = "${inputs.secrets}/id_rsa_pub.age";
        path = "/Users/${machineOptions.username}/.ssh/id_rsa.pub";
        mode = "644";
        owner = machineOptions.username;
        group = "staff";
      };
    };

    environment.systemPackages = [ inputs.agenix.packages.${pkgs.system}.default ];
  };
}
