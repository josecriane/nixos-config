{ ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      show_disks = true;
      proc_sorting = "cpu direct";
      cpu_sensor = "k10temp/Tctl";
    };
  };
}
