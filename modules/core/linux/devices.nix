{ pkgs, ... }:
{
  hardware.keyboard.qmk.enable = true;

  boot.kernelModules = [ "usblp" ];

  environment.systemPackages = [ pkgs.makeidcli ];

  services.udev.packages = with pkgs; [
    game-devices-udev-rules
    (writeTextFile {
      name = "rp2040-udev-rules";
      destination = "/etc/udev/rules.d/70-rp2040.rules";
      text = ''
        SUBSYSTEM=="tty", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="0001", TAG+="uaccess"
      '';
    })
    (writeTextFile {
      name = "makeid-l1-udev-rules";
      destination = "/etc/udev/rules.d/70-makeid-l1.rules";
      text = ''
        SUBSYSTEM=="usbmisc", KERNEL=="lp*", ATTRS{idVendor}=="09c5", ATTRS{idProduct}=="0200", TAG+="uaccess"
      '';
    })
  ];
}
