{ config, lib, pkgs, inputs, machineOptions, host, self, ... }:

{
  imports = [
    inputs.agenix.darwinModules.default
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
        file = "${self}/secrets/id_rsa.age";
        path = "/Users/${machineOptions.username}/.ssh/id_rsa";
        mode = "600";
        owner = machineOptions.username;
        group = "staff";
      };
      
      # SSH RSA public key
      "id_rsa_pub" = {
        file = "${self}/secrets/id_rsa_pub.age";
        path = "/Users/${machineOptions.username}/.ssh/id_rsa.pub";
        mode = "644";
        owner = machineOptions.username;
        group = "staff";
      };
    };

    # Ensure agenix package is available
    environment.systemPackages = [ inputs.agenix.packages.${pkgs.system}.default ];
  };
}
