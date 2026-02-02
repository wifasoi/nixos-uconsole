# Compute Module Configuration
#
# Kernel parameters for CM4 and CM5.
# Audio params are CM4-only (BCM2835 audio driver doesn't exist on CM5/BCM2712).
#
# Requires `isCM4` to be passed via specialArgs or direct import.

{
  lib,
  isCM4,
  ...
}:
{
  boot.kernelParams =
    [
      "8250.nr_uarts=1" # Number of 8250 UARTs to register
      "console=tty1"
    ]
    ++ (
      if isCM4 then
        [
          # BCM2835 audio driver settings (CM4 only)
          "snd_bcm2835.enable_hdmi=1"
          "snd_bcm2835.enable_headphones=1"
        ]
      else
        [ ]
    );
}
