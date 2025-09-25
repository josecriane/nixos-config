{ config, ... }:
{
  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;

      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/Downloads";
      music = null;
      pictures = "${config.home.homeDirectory}/tmp";
      publicShare = null;
      templates = "${config.home.homeDirectory}/templates";
      videos = null;
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        "application/pdf" = [ "firefox.desktop" ];
        "image/png" = [ "org.gnome.eog.desktop" ];
        "image/jpeg" = [ "org.gnome.eog.desktop" ];
        "image/gif" = [ "org.gnome.eog.desktop" ];
        "video/mp4" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "audio/mpeg" = [ "mpv.desktop" ];
        "text/plain" = [ "code.desktop" ];
      };
    };
  };
}
