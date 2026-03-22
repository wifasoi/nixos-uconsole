{ config, lib, ... }:
let
  cfg = config.hardware.hg.aio.lora;

  opt = enable: value: {
    enable = lib.mkDefault enable;
    value = lib.mkDefault value;
  };
in
{
  options.hardware.hg.aio.lora = {
    enable = lib.mkEnableOption "AIO LORA support";
    on-boot.enable = lib.mkEnableOption " Enable LORA on boot";
  };

  config.hardware.raspberry-pi.config = lib.mkIf cfg.enable {

    all.base-dt-params = {
      spi1-1cs = opt true null;
    };
    cm4.base-dt-params = {
      spi = opt true "on";
    };
  };
}
