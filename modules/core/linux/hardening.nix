{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.machine) username;

  exception = reason: {
    status = "exception";
    inherit reason;
  };

  deferred = reason: {
    status = "deferred";
    inherit reason;
  };

  notApplicable = reason: {
    status = "notApplicable";
    inherit reason;
  };
in
{
  hardening.stig = {
    enable = true;
    profile = "workstation";

    groups = {
      audit = exception "auditd stays disabled until audit-rules-nixos is verified at runtime.";
      ssh = notApplicable "No host runs an SSH server.";
      pki = exception "No smart cards, sssd or PKI infrastructure.";
      remoteLogging = exception "No remote log server.";
    };

    rules = {
      # Lockout after three failed logons
      V-268081 = exception "Console lockout is covered by the physical access policy.";
      # Graphical logon banner
      V-268084 = notApplicable "The logon manager is greetd, which has no banner.";
      # Graphical session lock after 10 minutes
      V-268086.settings = {
        method = "swayidle";
        lockCommand = "${lib.getExe' pkgs.swaylock-effects "swaylock"} -f";
      };
      # 180-day maximum password lifetime
      V-268133 = deferred "Password lifetime is set by local policy.";
      # 15-character minimum password length
      V-268134 = deferred "Password length is set by local policy.";
      # No direct root login
      V-268138 = deferred "Account management is set by local policy.";
      # Users allowed to use the Nix daemon
      V-268152.settings.allowedUsers = [ username ];
      # AIDE integrity checks
      V-268153 = deferred "AIDE is not in use.";
      # FIPS mode in the kernel
      V-268168 = exception "The kernel is not a FIPS-validated build.";
      # Default umask 077
      V-268181 = exception "Session umask is set by local policy.";
    };
  };
}
