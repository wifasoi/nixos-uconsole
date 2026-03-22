{ config, lib, ... }:
let
  cfg = config.hardware.hg.aio.sdr;

  opt = enable: value: {
    enable = lib.mkDefault enable;
    value = lib.mkDefault value;
  };
in
{
  options.hardware.hg.aio.sdr = {
    enable = lib.mkEnableOption "AIO SDR support";
    on-boot.enable = lib.mkEnableOption "Enable SDR on boot";
  };
}
