{
  config,
  lib,
  pkgs,
  inputs,
  machineOptions,
  self,
  ...
}:

{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  config = {
    age.identityPaths = [
      "/etc/agenix/agenix-key.age"
    ];

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

      # OpenVPN configuration
      "noma-ovpn-config" = {
        file = "${inputs.secrets}/vpn/noma-ovpn-config.age";
        mode = "600";
        owner = "root";
        group = "root";
      };

      # OpenVPN credentials
      "noma-ovpn-aup" = {
        file = "${inputs.secrets}/vpn/noma-ovpn-aup.age";
        mode = "600";
        owner = "root";
        group = "root";
      };
    };

    environment.systemPackages = [ inputs.agenix.packages.${pkgs.system}.default ];
  };
}
