{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    openjdk17
    gradle
  ];

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.openjdk17}/lib/openjdk";
  };
}
