{ pkgs, ... }:
{
  # Self-hosted it-tools, served locally so the PWA works without internet access.
  services.nginx = {
    enable = true;

    virtualHosts."it-tools" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 8081;
        }
      ];

      root = "${pkgs.it-tools}/lib";

      # The SPA uses history mode routing, so unknown paths must fall back to index.html
      locations."/".tryFiles = "$uri $uri/ /index.html";
    };
  };
}
