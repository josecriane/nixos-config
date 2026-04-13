{
  config,
  lib,
  pkgs,
  machineOptions,
  ...
}:

{
  services.openvpn.servers = {
    noma = {
      autoStart = false;
      updateResolvConf = true;
      config = ''
        config ${config.age.secrets.noma-ovpn-config.path}
        auth-user-pass ${config.age.secrets.noma-ovpn-aup.path}

        # GitHub IP ranges
        route 140.82.112.0 255.255.240.0
        route 143.55.64.0 255.255.240.0
        route 185.199.108.0 255.255.252.0
        route 192.30.252.0 255.255.252.0
      '';
    };
  };
}
