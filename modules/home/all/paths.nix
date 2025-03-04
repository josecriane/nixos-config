{ config, lib, pkgs, ... }:

{
  home.activation = {
    myCustomSetup = {
      after = [ "writeBoundary" ];
      before = [ ];
      data = ''
        bash ${./../../../setup/paths.sh}
      '';
    };
  };
}
