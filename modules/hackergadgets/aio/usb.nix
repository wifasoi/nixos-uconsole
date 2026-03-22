{ config, lib, ... }:
{
  options.hardware.hg.aio.usb = {
    enable = lib.mkEnableOption "AIO USB support";
    on-boot.enable = lib.mkEnableOption " Enable USB on boot";
  };
}
