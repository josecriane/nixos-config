{
  config,
  lib,
  pkgs,
  ...
}:
{
  # STIG V-268173: AppArmor must be enabled
  security.apparmor.enable = true;

  # STIG V-268080: Enable audit daemon
  security.auditd.enable = true;
  security.audit.enable = true;

  # STIG V-268126, V-268127, V-268128, V-268129, V-268145, V-268169, V-268170: Password complexity
  security.pam.services.passwd.text = lib.mkForce ''
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

  # STIG V-268156: Reauthentication when executing privileged commands
  security.sudo.wheelNeedsPassword = true;

  # STIG V-268155: Sudo reauthentication for privilege escalation
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=0
  '';

  # STIG V-268171: Four second delay between failed login attempts
  security.pam.services.login.failDelay.enable = true;
  security.pam.services.login.failDelay.delay = 4000000;

  # STIG V-268174: Inactive accounts disabled after 35 days
  environment.etc."default/useradd".text = lib.mkForce ''
    INACTIVE=35
  '';

  security.loginDefs.settings = {
    # STIG V-268130: SHA512 password hashing
    ENCRYPT_METHOD = "SHA512";

    # STIG V-268132: Minimum password lifetime (1 day)
    PASS_MIN_DAYS = 1;

    # STIG V-268181: UMASK 077 default file permissions
    UMASK = "077";
  };

  # STIG V-268085: Limit concurrent sessions to 10 per account
  security.pam.loginLimits = [
    {
      domain = "*";
      item = "maxlogins";
      type = "hard";
      value = "10";
    }
  ];

  security.rtkit.enable = true;

  services.fprintd = {
    enable = config.machine.fprint;
  };

  security.pam.services.greetd.fprintAuth = lib.mkDefault (config.machine.fprint);
  security.pam.services.swaylock.fprintAuth = lib.mkDefault (config.machine.fprint);
  security.pam.services.sudo.fprintAuth = lib.mkDefault (config.machine.fprint);

  security.pam.u2f = {
    enable = true;
    settings.cue = true;
  };

  security.pam.services.sudo.u2f.enable = true;
}
