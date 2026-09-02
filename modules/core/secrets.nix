{
  config,
  pkgs,
  inputs,
  machineOptions,
  self,
  ...
}:
let
  inherit (config.machine) username userGroup homeDirectory;
in
{
  imports = [
    (
      if machineOptions.os == "linux" then
        inputs.agenix.nixosModules.default
      else
        inputs.agenix.darwinModules.default
    )
  ];

  age.identityPaths = [ "/etc/agenix/agenix-key.age" ];

  age.secrets = {
    "id_rsa" = {
      file = "${self}/secrets/id_rsa.age";
      path = "${homeDirectory}/.ssh/id_rsa";
      mode = "600";
      owner = username;
      group = userGroup;
    };

    "id_rsa_pub" = {
      file = "${self}/secrets/id_rsa_pub.age";
      path = "${homeDirectory}/.ssh/id_rsa.pub";
      mode = "644";
      owner = username;
      group = userGroup;
    };
  };

  environment.systemPackages = [ inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}
