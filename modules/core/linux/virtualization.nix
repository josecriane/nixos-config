{ config, pkgs, machineOptions, ... }:
{
  virtualisation = {
    docker.enable = true;

    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
      enableKvm = true;
      addNetworkInterface = false;
    };
  };

  users.extraGroups.vboxusers.members = [ machineOptions.username ];

  # VirtualBox global configuration
  environment.etc."vbox/VirtualBox.xml".text = ''
    <?xml version="1.0"?>
    <VirtualBox xmlns="http://www.virtualbox.org/" version="1.12-linux">
      <Global>
        <SystemProperties defaultMachineFolder="/home/${machineOptions.username}/docs/vm"/>
      </Global>
    </VirtualBox>
  '';
}
