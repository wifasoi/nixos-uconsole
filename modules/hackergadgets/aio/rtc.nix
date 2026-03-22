{ config, lib, ... }:
let
  cfg = config.hardware.hg.aio.rtc;

  opt = enable: value: {
    enable = lib.mkDefault enable;
    value = lib.mkDefault value;
  };
in
{
  options.hardware.hg.aio.rtc = {
    enable = lib.mkEnableOption " AIO RTC support";
  };

  # enable RTC as default
  config.hardware.raspberry-pi.config = lib.mkIf cfg.enable {
    cm4 = {
      base-dt-params.i2c_arm = opt true "on";
      dt-overlays.i2c-rtc = {
        enable = lib.mkDefault true;
        params.pcf85063a = opt true null;
      };
    };
    cm5 = {
      # disable the CM5 internal RTC
      base-dt-params.rtc = opt true "off";
      # i2c_csi_dsi0, remap the i2c0 to GPIO38/39 on CM5
      dt-overlays.i2c-rtc = {
        enable = lib.mkDefault true;
        params = {
          pcf85063a = opt true null;
          i2c_csi_dsi0 = opt true null;
        };
      };
    };
  };
}
