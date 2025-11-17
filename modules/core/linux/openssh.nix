{ pkgs, lib, ... }:
{
  # STIG SSH Hardening Configuration
  # Multiple STIG requirements for secure SSH access

  services.openssh = {
    # STIG V-268159: Protect confidentiality and integrity of transmitted info
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268159
    enable = true;

    settings = {
      # STIG V-268137: Prohibit direct SSH root login
      # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268137
      # Forces individual authentication before accessing privileged accounts
      PermitRootLogin = "no";

      # STIG V-268176: Strong authenticators for nonlocal maintenance/diagnostic sessions
      # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268176
      # Ensures PAM authentication is used for SSH
      UsePAM = true;
    };

    # STIG V-268089: DOD-approved encryption for remote access sessions
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268089
    # Only FIPS 140-3 approved ciphers
    settings.Ciphers = [
      "aes256-ctr"
      "aes192-ctr"
      "aes128-ctr"
    ];

    # STIG V-268157: Cryptographic protection for nonlocal maintenance comms
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268157
    # Only FIPS 140-3 approved MAC codes
    macs = [
      "hmac-sha2-512"
      "hmac-sha2-256"
    ];

    # STIG V-268083: DOD banner for SSH logins (INTENTIONALLY NOT FOLLOWED)
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268083
    # NOTE: DOD banner not applicable - this is not a U.S. Department of Defense system
    # Risk accepted: System is not part of USG infrastructure
    # banner = ''
    #   You are accessing a U.S. Government (USG) Information System (IS)...
    # '';

    # Additional hardening settings
    # STIG V-268142: SSH connection idle timeout
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268142
    # Terminate connections after 10 minutes of inactivity
    # ClientAliveInterval 600

    # STIG V-268143: Terminate unresponsive SSH connections
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268143
    # Terminate after 1 failed keepalive
    # ClientAliveCountMax 1
    extraConfig = ''
      ClientAliveInterval 600
      ClientAliveCountMax 1
    '';

    # STIG V-268088: Monitor remote access methods (VERBOSE SSH logging)
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268088
    # Enable verbose logging for security monitoring
    logLevel = "VERBOSE";
  };

  # STIG V-268158: DoS protection via rate-limiting for SSH
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268158
  # Protects against SSH brute-force and DoS attacks by limiting connection rates
  # Applied only when SSH server is enabled (server=true)
  networking.firewall.extraCommands = ''
    # SSH rate limiting: max 1MB/second per source IP (protects against connection floods)
    iptables -A INPUT -p tcp --dport 22 \
      -m hashlimit \
      --hashlimit-name stig_ssh_byte_limit \
      --hashlimit-mode srcip \
      --hashlimit-above 1000000b/second \
      -j REJECT --reject-with tcp-reset

    # Same for IPv6
    ip6tables -A INPUT -p tcp --dport 22 \
      -m hashlimit \
      --hashlimit-name stig_ssh_byte_limit_v6 \
      --hashlimit-mode srcip \
      --hashlimit-above 1000000b/second \
      -j REJECT --reject-with tcp-reset
  '';

  # STIG V-268081: Account lockout after 3 failed SSH login attempts
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268081
  # Locks account after 3 consecutive failed attempts within 15 minutes
  # Requires manual unlock by administrator

  # STIG V-268171: Four second delay between failed login attempts
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268171
  security.pam.services.sshd.failDelay.enable = true;
  security.pam.services.sshd.failDelay.delay = 4000000; # 4 second delay (4,000,000 microseconds)

  # Configure faillock for SSH service
  security.pam.services.sshd.text = lib.mkAfter ''
    auth required pam_faillock.so preauth deny=3 even_deny_root fail_interval=900 unlock_time=0
    auth [default=die] pam_faillock.so authfail deny=3 even_deny_root fail_interval=900 unlock_time=0
    account required pam_faillock.so
  '';
}
