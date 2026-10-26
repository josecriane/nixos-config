{
  config,
  inputs,
  lib,
  ...
}:

{
  imports = [
    inputs.nixos-hardware.nixosModules.apple-macbook-pro
    "${inputs.nixos-hardware}/common/cpu/intel/skylake"
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  boot = {
    initrd.kernelModules = [
      "applespi"
      "spi_pxa2xx_platform"
      "intel_lpss_pci"
      "applesmc"
    ];
    kernelParams = [
      "intel_iommu=on"
      "mem_sleep_default=s2idle"
    ];
    extraModulePackages = [
      (config.boot.kernelPackages.callPackage (
        { stdenv, kernel }:
        stdenv.mkDerivation {
          pname = "thunderbolt-s2idle";
          inherit (kernel) version src;
          patches = [ ./patches/thunderbolt-keep-host-router-awake-in-s2idle.patch ];
          nativeBuildInputs = kernel.moduleBuildDependencies;
          buildPhase = ''
            make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
              M=$PWD/drivers/thunderbolt -j$NIX_BUILD_CORES modules
          '';
          installPhase = ''
            install -Dm644 drivers/thunderbolt/thunderbolt.ko \
              $out/lib/modules/${kernel.modDirVersion}/updates/thunderbolt.ko
          '';
        }
      ) { })
    ];
  };

  services = {
    libinput.enable = true;

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x106b", ATTR{device}=="0x2003", ATTR{d3cold_allowed}="0"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0x9d14|0x9d18|0x1578|0x15d3|0x15d2|0x15d4", ATTR{d3cold_allowed}="0", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x14e4", ATTR{device}=="0x43a3", ATTR{d3cold_allowed}="0", ATTR{power/control}="on"
      ACTION=="bind", SUBSYSTEM=="pci", DRIVER=="thunderbolt", ATTR{power/control}="on"
    '';

    tlp.settings.RUNTIME_PM_DENYLIST = "00:1c.4 00:1d.0 02:00.0 04:00.0 05:00.0 05:01.0 05:02.0 05:04.0 06:00.0 07:00.0";
  };

  environment.etc."libinput/local-overrides.quirks".text = ''
    [MacBook(Pro) SPI Touchpads]
    MatchName=*Apple SPI Touchpad*
    ModelAppleTouchpad=1
    AttrTouchSizeRange=200:150
    AttrPalmSizeThreshold=1100

    [MacBook(Pro) SPI Keyboards]
    MatchName=*Apple SPI Keyboard*
    AttrKeyboardIntegration=internal
  '';

  hardware.enableRedistributableFirmware = lib.mkDefault true;

  systemd.sleep.settings.Sleep = {
    AllowHibernation = "no";
  };
}
