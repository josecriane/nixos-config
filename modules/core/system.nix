{ ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  environment.variables.EDITOR = "vim";

  time.timeZone = "Europe/Madrid";
}
