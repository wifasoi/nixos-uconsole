{ config, lib, ... }:
let
  cfg = config.hardware.hg.aio;
  gps = if cfg.gps.on-boot.enable then "dh" else "dl";
  lora = if cfg.lora.on-boot.enable then "dh" else "dl";
  sdr = if cfg.sdr.on-boot.enable then "dh" else "dl";
  usb = if cfg.usb.on-boot.enable then "dh" else "dl";
in
{
  options.hardware.hg.aio = {
    #enable = lib.mkEnableOption " AIO support";
    enable = lib.mkOption {
      default = builtins.any (x: x.enable) (
        with cfg;
        [
          rtc
          gps
          lora
          sdr
          usb
        ]
      );
      description = "AIO support";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.raspberry-pi.extra-config = lib.concatStringsSep "\n" [
      "[all]"
      "gpio=27=op,${gps}"
      "gpio=16=op,${lora}"
      "gpio=7=op,${sdr}"
      "gpio=23=op,${usb}"
      ""
    ];
  };
  imports = [
    ./rtc.nix
    ./gps.nix
    ./lora.nix
    ./usb.nix
    ./sdr.nix
  ];
}
