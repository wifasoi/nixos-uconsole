{ config, lib, ... }:
let
  cfg = config.hardware.hg.nvme;
in
{
  options.hardware.hg.nvme = {
    enable = lib.mkEnableOption "CM5 PCIe and NVMe support";
  };

  config = lib.mkIf cfg.enable {
    hardware.raspberry-pi.config.cm5."base-dt-params".pciex1 = {
      enable = true;
      value = null;
    };

    boot.initrd.availableKernelModules = [ "nvme" ];
  };
}
