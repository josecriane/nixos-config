{
  config,
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = [ pkgs.android-tools ];
  };
}
