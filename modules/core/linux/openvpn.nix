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
      '';
    };
  };
}