{ config, pkgs, ... }:

{
  programs.ssh.startAgent = true;
  
  # Agregar las claves SSH automáticamente al agente
  programs.ssh.extraConfig = ''
    AddKeysToAgent yes
  '';
  
  # Configurar systemd para agregar las claves de agenix al ssh-agent
  systemd.user.services.ssh-add-keys = {
    description = "Add SSH keys to agent";
    wantedBy = [ "default.target" ];
    after = [ "ssh-agent.service" ];
    requires = [ "ssh-agent.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.openssh}/bin/ssh-add %h/.ssh/id_rsa";
      Environment = "SSH_AUTH_SOCK=%t/ssh-agent";
    };
  };
}