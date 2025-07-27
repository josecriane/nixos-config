{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    flutter332
    android-tools
    cocoapods
  ];
}