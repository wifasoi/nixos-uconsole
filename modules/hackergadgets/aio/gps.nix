{ config, lib, ... }:
let
  cfg = config.hardware.hg.aio.gps;

  opt = enable: value: {
    enable = lib.mkDefault enable;
    value = lib.mkDefault value;
  };
in
{
  options.hardware.hg.aio.gps = {
    enable = lib.mkEnableOption " AIO GPS support";
    on-boot.enable = lib.mkEnableOption " Enable GPS on boot";
  };

  # enable RTC as default
  config.hardware.raspberry-pi.config = lib.mkIf cfg.enable {
    # Setup gps
    cm4.options = {
      enable_uart = opt true 1;
    };
    cm5 = {
      base-dt-params = {
        uart0 = opt true null;
      };
      dt-overlays = {
        pps-gpio = {
          enable = lib.mkDefault true;
          params = {
            gpiopin = opt true 6;
          };
        };
      };
    };
  };
}
