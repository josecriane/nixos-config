{ pkgs, ... }:
{
  hardware.keyboard.qmk.enable = true;

  services.udev.packages = with pkgs; [
    game-devices-udev-rules
    (writeTextFile {
      name = "rp2040-udev-rules";
      destination = "/etc/udev/rules.d/70-rp2040.rules";
      text = ''
        SUBSYSTEM=="tty", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="0001", TAG+="uaccess"
      '';
    })
  ];
}
