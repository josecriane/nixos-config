{
  config,
  ...
}:

{
  boot.initrd.kernelModules = [
    "kvm-intel"
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
  };

  # STIG V-268144: Protect confidentiality/integrity of data at rest (LUKS encryption)
  environment.etc.crypttab.text = ''
    games UUID=efc12277-9151-4ff6-bae6-a3272f77328f /etc/cryptsetup-keys.d/games.key luks,discard,nofail
  '';

  fileSystems."/mnt/games" = {
    device = "/dev/mapper/games";
    fsType = "ext4";
    options = [
      "nofail"
      "noatime"
      "x-systemd.device-timeout=10s"
    ];
  };
}
