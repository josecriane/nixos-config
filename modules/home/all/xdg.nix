{ config, ... }:
{
  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;

      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/Downloads";
      music = null;
      pictures = "${config.home.homeDirectory}/tmp";
      projects = null;
      publicShare = null;
      templates = "${config.home.homeDirectory}/templates";
      videos = null;
    };

    mimeApps = {
      enable = true;

      defaultApplications = {
        # Browsers and web content
        "x-scheme-handler/http" = [ "brave-browser.desktop" ];
        "x-scheme-handler/https" = [ "brave-browser.desktop" ];
        "x-scheme-handler/about" = [ "brave-browser.desktop" ];
        "x-scheme-handler/unknown" = [ "brave-browser.desktop" ];
        "x-scheme-handler/mailto" = [ "brave-browser.desktop" ];
        "text/html" = [ "brave-browser.desktop" ];
        "x-scheme-handler/chrome" = [ "firefox.desktop" ];
        "application/xhtml+xml" = [ "firefox.desktop" ];
        "application/x-extension-htm" = [ "firefox.desktop" ];
        "application/x-extension-html" = [ "firefox.desktop" ];
        "application/x-extension-shtml" = [ "firefox.desktop" ];
        "application/x-extension-xhtml" = [ "firefox.desktop" ];
        "application/x-extension-xht" = [ "firefox.desktop" ];
        "application/pdf" = [ "firefox.desktop" ];

        # Application URL handlers
        "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
        "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
        "x-scheme-handler/discord" = [ "vesktop.desktop" ];
        "x-scheme-handler/postman" = [ "postman.desktop" ];
        "x-scheme-handler/claude-cli" = [ "claude-code-url-handler.desktop" ];

        # Files
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        "image/png" = [ "org.gnome.eog.desktop" ];
        "image/jpeg" = [ "org.gnome.eog.desktop" ];
        "image/gif" = [ "org.gnome.eog.desktop" ];
        "video/mp4" = [ "vlc.desktop" ];
        "video/x-matroska" = [ "vlc.desktop" ];
        "audio/mpeg" = [ "vlc.desktop" ];
        "text/plain" = [ "code.desktop" ];
        "text/markdown" = [ "code.desktop" ];
      };

      associations.added = {
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "text/javascript" = [ "code.desktop" ];
      };
    };
  };
}
