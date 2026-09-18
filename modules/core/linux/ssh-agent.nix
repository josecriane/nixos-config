{ config, pkgs, ... }:

{
  programs.ssh.startAgent = true;

  programs.ssh.extraConfig = ''
    AddKeysToAgent yes
  '';

  systemd.user.services.ssh-add-keys = {
    description = "Add SSH keys to agent";
    wantedBy = [ "default.target" ];
    after = [ "ssh-agent.service" ];
    requires = [ "ssh-agent.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = "${pkgs.coreutils}/bin/test -f %h/.ssh/id_rsa";
      ExecStart = "${pkgs.openssh}/bin/ssh-add %h/.ssh/id_rsa";
      Environment = "SSH_AUTH_SOCK=%t/ssh-agent";
    };
  };
}
