{
  desktop = true;
  develop = true;
  wm = "niri";
  quickshell_config_enable = true;
  os = "linux";
  username = "sito";
  hostname = "imre";
  fprint = false;
  keyboards = [
    {
      layout = "us";
      variant = "intl";
    }
  ];
  monitors = [
    {
      name = "HDMI-A-1";
      mode = "2560x1440@143.972";
      position = {
        x = 0;
        y = 500;
      };
      focusAtStartup = true;
    }
    {
      name = "DP-1";
      position = {
        x = 2560;
        y = 0;
      };
      transform = "270";
      variableRefreshRate = true;
    }
  ];
}
