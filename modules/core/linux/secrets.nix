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
        file = "${self}/secrets/id_rsa.age";
        path = "/home/${machineOptions.username}/.ssh/id_rsa";
        mode = "600";
        owner = machineOptions.username;
        group = "users";
      };

      # SSH RSA public key
      "id_rsa_pub" = {
        file = "${self}/secrets/id_rsa_pub.age";
        path = "/home/${machineOptions.username}/.ssh/id_rsa.pub";
        mode = "644";
        owner = machineOptions.username;
        group = "users";
      };

      # OpenVPN configuration
      "noma-ovpn-config" = {
        file = "${self}/secrets/vpn/noma-ovpn-config.age";
        mode = "600";
        owner = "root";
        group = "root";
      };

      # OpenVPN credentials
      "noma-ovpn-aup" = {
        file = "${self}/secrets/vpn/noma-ovpn-aup.age";
        mode = "600";
        owner = "root";
        group = "root";
      };

      # GPG private keys
      "gpg-nomasystems" = {
        file = "${self}/secrets/gpg/info_nomasystems_com_DB345B37ADEA4D2D/private-key.age";
        path = "/run/agenix/gpg-nomasystems";
        mode = "600";
        owner = machineOptions.username;
        group = "users";
      };

      "gpg-jose-cribeiro" = {
        file = "${self}/secrets/gpg/jose_cribeiro_nomasystems_com_9C15882E63F2A25A/private-key.age";
        path = "/run/agenix/gpg-jose-cribeiro";
        mode = "600";
        owner = machineOptions.username;
        group = "users";
      };

      "gpg-jose-cribeiro-subkeys" = {
        file = "${self}/secrets/gpg/jose_cribeiro_nomasystems_com_9C15882E63F2A25A/subkeys.age";
        path = "/run/agenix/gpg-jose-cribeiro-subkeys";
        mode = "600";
        owner = machineOptions.username;
        group = "users";
      };

      "gpg-inditex" = {
        file = "${self}/secrets/gpg/josecan_ext_inditex_com_27220327E40C90A2/private-key.age";
        path = "/run/agenix/gpg-inditex";
        mode = "600";
        owner = machineOptions.username;
        group = "users";
      };

      "gpg-inditex-subkeys" = {
        file = "${self}/secrets/gpg/josecan_ext_inditex_com_27220327E40C90A2/subkeys.age";
        path = "/run/agenix/gpg-inditex-subkeys";
        mode = "600";
        owner = machineOptions.username;
        group = "users";
      };

      "gpg-gmail" = {
        file = "${self}/secrets/gpg/josecriane_gmail_com_7CBF06A1C0888DFC/private-key.age";
        path = "/run/agenix/gpg-gmail";
        mode = "600";
        owner = machineOptions.username;
        group = "users";
      };

      "gpg-trust-db" = {
        file = "${self}/secrets/gpg/trust-db.age";
        path = "/run/agenix/gpg-trust-db";
        mode = "600";
        owner = machineOptions.username;
        group = "users";
      };
    };

    environment.systemPackages = [ inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
