{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    flutter332
    cocoapods
  ];
}