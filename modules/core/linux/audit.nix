{ lib, ... }:
{
  # STIG V-268111-V-268118: Audit and journal file permissions
  systemd.tmpfiles.rules = [
    "d /var/log/audit 0700 root root -"
    "Z /var/log/audit/*.log 0600 root root -"
    "d /var/log/journal 0755 root root -"
    "Z /var/log/journal/*/*.journal 0640 root systemd-journal -"
  ];

  security.auditd.enable = lib.mkForce false;

  security.audit = {
    enable = lib.mkForce false;

    rules = [
      # STIG V-268091: Audit privileged command usage
      "-a always,exit -F arch=b64 -S execve -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged"
      "-a always,exit -F arch=b32 -S execve -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged"

      # STIG V-268094: Audit mount syscall
      "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mount"
      "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mount"

      # STIG V-268095: Audit file deletion operations
      "-a always,exit -F arch=b64 -S unlink,unlinkat,rename,renameat -F auid>=1000 -F auid!=4294967295 -k delete"
      "-a always,exit -F arch=b32 -S unlink,unlinkat,rename,renameat -F auid>=1000 -F auid!=4294967295 -k delete"

      # STIG V-268096: Audit kernel module operations
      "-a always,exit -F arch=b64 -S init_module,delete_module -k kernel_modules"
      "-a always,exit -F arch=b32 -S init_module,delete_module -k kernel_modules"
      "-w /run/current-system/sw/bin/kmod -p x -k kernel_modules"
      "-w /run/current-system/sw/bin/insmod -p x -k kernel_modules"
      "-w /run/current-system/sw/bin/rmmod -p x -k kernel_modules"
      "-w /run/current-system/sw/bin/modprobe -p x -k kernel_modules"

      # STIG V-268098: Audit unsuccessful file operation attempts
      "-a always,exit -F arch=b64 -S open,openat,creat,truncate,ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access"
      "-a always,exit -F arch=b32 -S open,openat,creat,truncate,ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access"
      "-a always,exit -F arch=b64 -S open,openat,creat,truncate,ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access"
      "-a always,exit -F arch=b32 -S open,openat,creat,truncate,ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access"

      # STIG V-268099: Audit chown system calls
      "-a always,exit -F arch=b64 -S chown,fchown,fchownat,lchown -F auid>=1000 -F auid!=4294967295 -k perm_chng"
      "-a always,exit -F arch=b32 -S chown,fchown,fchownat,lchown -F auid>=1000 -F auid!=4294967295 -k perm_chng"

      # STIG V-268100: Audit chmod system calls
      "-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_chng"
      "-a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_chng"

      "-w /etc/group -p wa -k identity"
      "-w /etc/passwd -p wa -k identity"
      "-w /etc/gshadow -p wa -k identity"
      "-w /etc/shadow -p wa -k identity"

      "-w /etc/sudoers -p wa -k sudoers"
      "-w /etc/sudoers.d/ -p wa -k sudoers"

      "-w /etc/ssh/sshd_config -p wa -k sshd"
      "-w /etc/ssh/sshd_config.d/ -p wa -k sshd"

      "-a always,exit -F arch=b64 -S sethostname,setdomainname -k system-locale"
      "-a always,exit -F arch=b32 -S sethostname,setdomainname -k system-locale"
      "-w /etc/issue -p wa -k system-locale"
      "-w /etc/hosts -p wa -k system-locale"
      "-w /etc/hostname -p wa -k system-locale"

      "-a always,exit -F arch=b64 -S adjtimex,settimeofday,clock_settime -k time-change"
      "-a always,exit -F arch=b32 -S adjtimex,settimeofday,clock_settime -k time-change"
      "-w /etc/localtime -p wa -k time-change"

      "-w /var/run/utmp -p wa -k session"
      "-w /var/log/wtmp -p wa -k session"
      "-w /var/log/btmp -p wa -k session"

      "-a always,exit -F arch=b64 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod"
      "-a always,exit -F arch=b32 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod"
    ];
  };
}
