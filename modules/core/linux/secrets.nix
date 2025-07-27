{ config, lib, pkgs, inputs, machineOptions, host, self, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  config = {
    # Path to the age identity file (the private key)
    age.identityPaths = [
      # This path should be where the agenix-key.age file will be copied on each machine
      "/etc/agenix/agenix-key.age"
    ];

    # Define which secrets this host should have access to
    age.secrets = {
      # SSH RSA private key
      "id_rsa" = {
        file = "${inputs.secrets}/id_rsa.age";
        path = "/home/${machineOptions.username}/.ssh/id_rsa";
        mode = "600";
        owner = machineOptions.username;
        group = "users";
      };
      
      # SSH RSA public key
      "id_rsa_pub" = {
        file = "${inputs.secrets}/id_rsa_pub.age";
        path = "/home/${machineOptions.username}/.ssh/id_rsa.pub";
        mode = "644";
        owner = machineOptions.username;
        group = "users";
      };
    };

    # Ensure agenix package is available
    environment.systemPackages = [ inputs.agenix.packages.${pkgs.system}.default ];
  };
}
