{
  config,
  lib,
  pkgs,
  ...
}:
{
  security = {
    # STIG V-268173: AppArmor must be enabled
    apparmor.enable = true;

    # STIG V-268080: Enable audit daemon
    auditd.enable = true;
    audit.enable = true;

    sudo = {
      # STIG V-268156: Reauthentication when executing privileged commands
      wheelNeedsPassword = true;

      # STIG V-268155: Sudo reauthentication for privilege escalation
      extraConfig = ''
        Defaults timestamp_timeout=0
      '';
    };

    pam = {
      services = {
        # STIG V-268126, V-268127, V-268128, V-268129, V-268145, V-268169, V-268170: Password complexity
        passwd.text = lib.mkForce ''
          # Password complexity requirements (without minlen and maxdays)
          password requisite ${pkgs.libpwquality.lib}/lib/security/pam_pwquality.so \
            ucredit=-1 \
            lcredit=-1 \
            dcredit=-1 \
            ocredit=-1 \
            difok=8 \
            dictcheck=1 \
            enforce_for_root \
            retry=3

          # SHA512 hashing
          password required ${config.security.pam.package}/lib/security/pam_unix.so sha512 shadow use_authtok
        '';

        # STIG V-268171: Four second delay between failed login attempts
        login.failDelay = {
          enable = true;
          delay = 4000000;
        };

        greetd.fprintAuth = lib.mkDefault config.machine.fprint;
        swaylock.fprintAuth = lib.mkDefault config.machine.fprint;
        sudo = {
          fprintAuth = lib.mkDefault config.machine.fprint;
          u2f.enable = true;
        };
      };

      # STIG V-268085: Limit concurrent sessions to 10 per account
      loginLimits = [
        {
          domain = "*";
          item = "maxlogins";
          type = "hard";
          value = "10";
        }
      ];

      u2f = {
        enable = true;
        settings.cue = true;
      };
    };

    loginDefs.settings = {
      # STIG V-268130: SHA512 password hashing
      ENCRYPT_METHOD = "SHA512";

      # STIG V-268132: Minimum password lifetime (1 day)
      PASS_MIN_DAYS = 1;
    };

    rtkit.enable = true;
  };

  # STIG V-268174: Inactive accounts disabled after 35 days
  environment.etc."default/useradd".text = lib.mkForce ''
    INACTIVE=35
  '';

  services.fprintd = {
    enable = config.machine.fprint;
  };
}
