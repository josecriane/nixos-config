{
  pkgs,
  lib,
  ...
}:
{
  # Override pinentry for macOS ARM64 compatibility
  services.gpg-agent = {
    pinentry.package = lib.mkForce pkgs.pinentry_mac;
  };
}
