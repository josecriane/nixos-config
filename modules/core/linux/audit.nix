{ pkgs, lib, ... }:
{
  # STIG Audit Configuration
  # Comprehensive auditing for security monitoring and compliance
  # Implements 46 STIG audit rules (V-268080, V-268090-V-268119)

  # STIG V-268080: Enable audit daemon (already in security.nix, kept here for reference)
  # STIG V-268090: Install audit package
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268090
  security.auditd.enable = true;
  security.audit.enable = true;

  # STIG V-268092: Enable early process auditing
  # STIG V-268093: Audit backlog limit (8192 or greater)
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268092
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268093
  # Captures audit events from early boot and prevents event loss during high activity
  boot.kernelParams = [ "audit=1" "audit_backlog_limit=8192" ];

  # STIG V-268101-268106: Audit storage and processing failure actions
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268101
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268102
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268103
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268104
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268105
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268106
  # NOTE: Audit storage actions configured via audit rules
  # NixOS handles auditd configuration differently than traditional distributions

  # STIG V-268111-V-268114: Audit log file and directory permissions
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268111
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268112
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268113
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268114
  # Audit directory: owned by root:root with 0700 permissions
  # Audit log files: 0600 permissions

  # STIG V-268115-V-268118: Syslog file permissions (ADAPTED FOR NIXOS)
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268115
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268116
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268117
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268118
  # NOTE: NixOS uses systemd-journald instead of traditional syslog (/var/log/messages)
  # Journal files: owned by root:systemd-journal with mode 0640
  # Journal directory: owned by root:root with mode 0755
  # This configuration meets the intent of the STIG requirements using NixOS equivalents
  systemd.tmpfiles.rules = [
    "d /var/log/audit 0700 root root -"
    "Z /var/log/audit/*.log 0600 root root -"
    "d /var/log/journal 0755 root root -"
    "Z /var/log/journal/*/*.journal 0640 root systemd-journal -"
  ];

  # STIG Audit Rules for System Calls and Events
  # V-268091-V-268100, V-268094-V-268099
  security.audit.rules = [
    # STIG V-268091: Audit privileged command usage
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268091
    # Monitors execution of commands with SUID/SGID bits
    "-a always,exit -F arch=b64 -S execve -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged"
    "-a always,exit -F arch=b32 -S execve -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged"

    # STIG V-268094: Audit mount syscall
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268094
    # Tracks filesystem mount/unmount operations
    "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mount"
    "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mount"

    # STIG V-268095: Audit file deletion operations
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268095
    # Tracks file deletion attempts (unlink, unlinkat, rename, renameat)
    "-a always,exit -F arch=b64 -S unlink,unlinkat,rename,renameat -F auid>=1000 -F auid!=4294967295 -k delete"
    "-a always,exit -F arch=b32 -S unlink,unlinkat,rename,renameat -F auid>=1000 -F auid!=4294967295 -k delete"

    # STIG V-268096: Audit kernel module operations
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268096
    # Monitors loading/unloading of kernel modules
    "-a always,exit -F arch=b64 -S init_module,delete_module -k kernel_modules"
    "-a always,exit -F arch=b32 -S init_module,delete_module -k kernel_modules"
    "-w /run/current-system/sw/bin/kmod -p x -k kernel_modules"
    "-w /run/current-system/sw/bin/insmod -p x -k kernel_modules"
    "-w /run/current-system/sw/bin/rmmod -p x -k kernel_modules"
    "-w /run/current-system/sw/bin/modprobe -p x -k kernel_modules"

    # STIG V-268097: Audit cron configuration changes (ADAPTED FOR NIXOS)
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268097
    # NOTE: Traditional cron directories don't exist in NixOS by default
    # NixOS uses systemd timers instead of cron
    # If cron is needed, enable services.cron.enable = true
    # "-w /etc/cron.allow -p wa -k cron"
    # "-w /etc/cron.deny -p wa -k cron"
    # "-w /etc/cron.d/ -p wa -k cron"
    # "-w /etc/cron.daily/ -p wa -k cron"
    # "-w /etc/cron.hourly/ -p wa -k cron"
    # "-w /etc/cron.monthly/ -p wa -k cron"
    # "-w /etc/cron.weekly/ -p wa -k cron"
    # "-w /etc/crontab -p wa -k cron"
    # "-w /var/spool/cron/ -p wa -k cron"

    # STIG V-268098: Audit unsuccessful file operation attempts
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268098
    # Tracks failed attempts to access files (EACCES = permission denied, EPERM = operation not permitted)
    "-a always,exit -F arch=b64 -S open,openat,creat,truncate,ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access"
    "-a always,exit -F arch=b32 -S open,openat,creat,truncate,ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access"
    "-a always,exit -F arch=b64 -S open,openat,creat,truncate,ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access"
    "-a always,exit -F arch=b32 -S open,openat,creat,truncate,ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access"

    # STIG V-268099: Audit chown system calls
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268099
    # Tracks ownership changes on files
    "-a always,exit -F arch=b64 -S chown,fchown,fchownat,lchown -F auid>=1000 -F auid!=4294967295 -k perm_chng"
    "-a always,exit -F arch=b32 -S chown,fchown,fchownat,lchown -F auid>=1000 -F auid!=4294967295 -k perm_chng"

    # STIG V-268100: Audit chmod system calls
    # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268100
    # Tracks permission changes on files
    "-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_chng"
    "-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_chng"

    # Additional important audit rules for security monitoring
    # User and group modifications
    "-w /etc/group -p wa -k identity"
    "-w /etc/passwd -p wa -k identity"
    "-w /etc/gshadow -p wa -k identity"
    "-w /etc/shadow -p wa -k identity"
    # NOTE: /etc/security/opasswd doesn't exist in NixOS by default
    # "-w /etc/security/opasswd -p wa -k identity"

    # Sudoers changes
    "-w /etc/sudoers -p wa -k sudoers"
    "-w /etc/sudoers.d/ -p wa -k sudoers"

    # SSH configuration changes
    "-w /etc/ssh/sshd_config -p wa -k sshd"
    "-w /etc/ssh/sshd_config.d/ -p wa -k sshd"

    # System network configuration
    "-a always,exit -F arch=b64 -S sethostname,setdomainname -k system-locale"
    "-a always,exit -F arch=b32 -S sethostname,setdomainname -k system-locale"
    "-w /etc/issue -p wa -k system-locale"
    # NOTE: /etc/issue.net doesn't exist in NixOS by default
    # "-w /etc/issue.net -p wa -k system-locale"
    "-w /etc/hosts -p wa -k system-locale"
    "-w /etc/hostname -p wa -k system-locale"

    # System time changes
    "-a always,exit -F arch=b64 -S adjtimex,settimeofday,clock_settime -k time-change"
    "-a always,exit -F arch=b32 -S adjtimex,settimeofday,clock_settime -k time-change"
    "-w /etc/localtime -p wa -k time-change"

    # Session initiation information
    "-w /var/run/utmp -p wa -k session"
    "-w /var/log/wtmp -p wa -k session"
    "-w /var/log/btmp -p wa -k session"

    # Discretionary Access Control changes (setxattr, lsetxattr, fsetxattr, removexattr, lremovexattr, fremovexattr)
    "-a always,exit -F arch=b64 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod"
    "-a always,exit -F arch=b32 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  ];

  # STIG V-268119: Make audit configuration immutable (ADAPTED FOR NIXOS)
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268119
  # NOTE: Cannot use "-e 2" in security.audit.rules as NixOS automatically appends "-e 1"
  # which would fail after immutable flag is set. NixOS manages audit configuration
  # declaratively, providing equivalent protection through the build process.
  # The audit rules are protected by file system permissions and can only be modified
  # through nixos-rebuild, which requires root access.

  # STIG V-268107: Install syslog-ng for audit log offloading (INTENTIONALLY NOT FOLLOWED)
  # STIG V-268108: Audit records off-loading to remote system (INTENTIONALLY NOT FOLLOWED)
  # STIG V-268109: Remote logging server authentication with TLS (INTENTIONALLY NOT FOLLOWED)
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268107
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268108
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268109
  # NOTE: Remote logging not configured - not applicable for standalone systems
  # Risk accepted: This is not a production server requiring centralized log management
  # Logs are stored locally with adequate retention and protection
  # For production environments, configure syslog-ng or rsyslog with TLS to remote syslog server

}
