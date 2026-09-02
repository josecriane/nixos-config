{
  config,
  lib,
  self,
  ...
}:
let
  inherit (config.machine) username userGroup;

  gpgKeys = {
    "gpg-nomasystems" = "info_nomasystems_com_DB345B37ADEA4D2D/private-key.age";
    "gpg-jose-cribeiro" = "jose_cribeiro_nomasystems_com_9C15882E63F2A25A/private-key.age";
    "gpg-jose-cribeiro-subkeys" = "jose_cribeiro_nomasystems_com_9C15882E63F2A25A/subkeys.age";
    "gpg-inditex" = "josecan_ext_inditex_com_27220327E40C90A2/private-key.age";
    "gpg-inditex-subkeys" = "josecan_ext_inditex_com_27220327E40C90A2/subkeys.age";
    "gpg-gmail" = "josecriane_gmail_com_7CBF06A1C0888DFC/private-key.age";
    "gpg-trust-db" = "trust-db.age";
  };

  mkGpgSecret = name: relativePath: {
    file = "${self}/secrets/gpg/${relativePath}";
    path = "/run/agenix/${name}";
    mode = "600";
    owner = username;
    group = userGroup;
  };

  mkRootSecret = relativePath: {
    file = "${self}/secrets/${relativePath}";
    mode = "600";
    owner = "root";
    group = "root";
  };
in
{
  age.secrets = lib.mapAttrs mkGpgSecret gpgKeys // {
    "noma-ovpn-config" = mkRootSecret "vpn/noma-ovpn-config.age";
    "noma-ovpn-aup" = mkRootSecret "vpn/noma-ovpn-aup.age";
  };
}
