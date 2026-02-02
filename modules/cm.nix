# Compute Module Configuration
#
# Kernel parameters shared by CM4 and CM5.

{ ... }:
{
  boot.kernelParams = [
    "8250.nr_uarts=1" # Number of 8250 UARTs to register
    "console=tty1"

    # Audio driver settings
    "snd_bcm2835.enable_hdmi=1" # Enable HDMI audio output
    "snd_bcm2835.enable_headphones=1" # Enable headphone jack
  ];
}
