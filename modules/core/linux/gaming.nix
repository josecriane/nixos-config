{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports for Steam Remote Play
    dedicatedServer.openFirewall = false; # Not needed for client

    # Enable 32-bit libraries for Steam
    package = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          libxcursor
          libxi
          libxinerama
          libxscrnsaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
    };
  };

  # Enable GameMode system-wide
  programs.gamemode.enable = true;

  # OpenGL configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for Steam

    # Additional packages for better compatibility
    extraPackages = with pkgs; [
      mesa
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa
      vulkan-loader
    ];
  };

  # Kernel modules for controllers
  boot.kernelModules = [ "uinput" ];
  # FIXME: xpadneo no compila con kernel 6.18 (ida_simple_get deprecado)
  # hardware.xpadneo.enable = true; # Xbox controller support

  # udev rules for controllers
  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];

  # Groups for gaming
  users.groups.gamemode = { };
}
