{ config, ... }:
let
  cpuSensors = {
    amd = "k10temp/Tctl";
    intel = "coretemp/Package id 0";
    apple = "Auto";
  };
in
{
  programs.btop = {
    enable = true;
    settings = {
      show_disks = true;
      proc_sorting = "cpu direct";
      cpu_sensor = cpuSensors.${config.machine.cpuVendor};
    };
  };
}
