{ config, lib, ... }:
{
  security = {
    pam = {
      services = {
        greetd.fprintAuth = lib.mkDefault config.machine.fprint;
        swaylock.fprintAuth = lib.mkDefault config.machine.fprint;
        sudo = {
          fprintAuth = lib.mkDefault config.machine.fprint;
          u2f.enable = true;
        };
      };

      u2f = {
        enable = true;
        settings.cue = true;
      };
    };

    rtkit.enable = true;
  };

  services.fprintd = {
    enable = config.machine.fprint;
  };
}
