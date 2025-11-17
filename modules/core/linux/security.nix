{
  pkgs,
  machineOptions,
  lib,
  ...
}:
{
  # STIG V-268173: AppArmor must be enabled
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268173
  # Provides mandatory access control framework that restricts application permissions at kernel level
  security.apparmor.enable = true;

  # STIG V-268080: Enable audit daemon
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268080
  # Tracks account creation and system changes for security monitoring and forensics
  security.auditd.enable = true;
  security.audit.enable = true;

  # STIG V-268138: Prevent direct root login
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268138
  # Forces individual authentication before accessing privileged accounts
  # Ensures accountability and traceability of administrative actions
  # TODO: Implement this properly with SSH keys or hashed passwords configured declaratively
  # users.mutableUsers = false;

  # STIG V-268131: Remove telnet client
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268131
  # Telnet is inherently insecure (unencrypted) and should not be present
  # NixOS does not include telnet by default - verified compliant

  # STIG V-268130: SHA512 password hashing
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268130
  # Use SHA512 for password hashing to prevent brute-force attacks

  # STIG V-268132: Minimum password lifetime (1 day)
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268132
  # Prevents users from changing password multiple times to circumvent history

  # STIG Password Quality Requirements (7 rules implemented, 2 deferred)
  # V-268126: Uppercase requirement
  # V-268127: Lowercase requirement
  # V-268128: Numeric requirement
  # V-268145: Special character requirement
  # V-268129: 50% character change from old password
  # V-268169-170: Dictionary checking
  # V-268134: Minimum 15 characters - DEFERRED (current passwords don't meet requirement)
  # V-268133: Maximum 60 days - DEFERRED (forced rotation not desired)
  security.pam.services.passwd.text = lib.mkForce ''
    # SHA512 hashing with minimum password lifetime (1 day)
    password required pam_unix.so sha512 shadow mindays=1

    # Password complexity requirements (without minlen and maxdays)
    password requisite pam_pwquality.so \
      ucredit=-1 \
      lcredit=-1 \
      dcredit=-1 \
      ocredit=-1 \
      difok=8 \
      dictcheck=1 \
      enforce_for_root \
      retry=3
  '';

  # STIG V-268156: Reauthentication when executing privileged commands
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268156
  # Requires password authentication for sudo access
  security.sudo.wheelNeedsPassword = true;

  # STIG V-268155: Sudo reauthentication for privilege escalation
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268155
  # Forces reauthentication on every sudo command (no cached credentials)
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=0
  '';

  # STIG V-268081: Account lockout after 3 failed login attempts (ADAPTED FOR PHYSICAL ACCESS)
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268081
  # NOTE: Faillock NOT configured for local console login
  # Risk accepted: Users with physical access to the machine should not be locked out
  # This prevents legitimate users from being locked out if they mistype their password
  # SSH faillock is configured in openssh.nix to protect against remote brute-force attacks

  # STIG V-268171: Four second delay between failed login attempts
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268171
  # Still apply delay to slow down physical access brute-force attempts
  security.pam.services.login.failDelay.enable = true;
  security.pam.services.login.failDelay.delay = 4000000; # 4 second delay (4,000,000 microseconds)

  # STIG V-268181: UMASK 077 default file permissions
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268181
  # Ensures newly created files are only readable/writable by owner (privacy by default)
  # UMASK 077 = Owner: rwx (7), Group: --- (0), Others: --- (0)
  environment.etc."login.defs".text = lib.mkForce ''
    DEFAULT_HOME yes

    SYS_UID_MIN 400
    SYS_UID_MAX 999
    UID_MIN 1000
    UID_MAX 29999

    SYS_GID_MIN 400
    SYS_GID_MAX 999
    GID_MIN 1000
    GID_MAX 29999

    TTYGROUP tty
    TTYPERM 0620

    # UMASK 077 - Privacy for newly created files and home directories
    UMASK 077
  '';

  # STIG V-268085: Limit concurrent sessions to 10 per account
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268085
  # Prevents resource exhaustion and helps detect anomalous activity
  security.pam.loginLimits = [
    {
      domain = "*";
      item = "maxlogins";
      type = "hard";
      value = "10";
    }
  ];

  # STIG V-268177: Multifactor authentication for network access (INTENTIONALLY NOT FOLLOWED)
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268177
  # NOTE: MFA not configured - requires PIV/CAC smart card or hardware token (YubiKey)
  # Risk accepted: Hardware tokens (YubiKey, smart cards) not available
  # This is a personal/development system, not a production or government system
  # Alternative mitigations: Strong passwords, SSH key authentication, faillock protection
  # For production use, implement with: security.pam.p11.enable = true (requires smart card)
  # or security.pam.u2f.enable = true (requires YubiKey)
  # security.pam.p11.enable = false;

  # STIG V-268179: PKI-based authentication with CRL caching (INTENTIONALLY NOT FOLLOWED)
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268179
  # NOTE: PKI authentication not configured - requires smart card infrastructure
  # Risk accepted: PKI/smart card hardware and infrastructure not available
  # Requires: pam_pkcs11 with cert_policy including crl_auto for certificate revocation checking
  # This control is intended for government/enterprise environments with PKI infrastructure
  # Alternative mitigations: SSH key-based authentication with passphrase protection
  # security.pam.p11.enable = false;

  # STIG V-268139: USBGuard for USB device control (INTENTIONALLY NOT FOLLOWED)
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268139
  # NOTE: USBGuard not enabled - would be too restrictive for desktop/laptop usage
  # Risk accepted: Personal workstation frequently connects various USB devices (keyboards, mice, storage, peripherals)
  # USBGuard would require manual authorization for each new device, impacting productivity
  # Alternative mitigations: Physical security, user awareness, antivirus scanning
  # services.usbguard.enable = false;

  security.rtkit.enable = true;

  # Habilitar fprintd para autenticación por huella dactilar
  services.fprintd = {
    enable = machineOptions.fprint or false;
  };

  # Habilitar autenticación por huella para GDM y swaylock si fprint está habilitado
  security.pam.services.gdm.fprintAuth = lib.mkDefault (machineOptions.fprint or false);
  security.pam.services.gdm-password.fprintAuth = lib.mkDefault (machineOptions.fprint or false);
  security.pam.services.swaylock.fprintAuth = lib.mkDefault (machineOptions.fprint or false);
  security.pam.services.sudo.fprintAuth = lib.mkDefault (machineOptions.fprint or false);
}
