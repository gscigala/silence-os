# Hardware integration

Hardware intent is described in root `README.md`: Raspberry Pi Zero WH, Wi-Fi, and HiFiBerry DAC+ Zero. The README suggests `raspberrypi0-wifi`, enables `RPI_USE_U_BOOT` and SPI in a local configuration example, but there is no committed `local.conf`.

Product-specific audio integration is visible in:

- `sources/meta-silence/recipes-kernel/linux/linux-raspberrypi_%.bbappend`: adds `overlays/hifiberry-dac.dtbo` to `KERNEL_DEVICETREE`.
- `sources/meta-silence/recipes-bsp/bootfiles/rpi-config_%.bbappend`: adds `dtoverlay=hifiberry-dac` to deployed boot config.
- `sources/meta-silence/recipes-bsp/alsa-state/alsa-state.bbappend` and its `alsa-state/` files: installs project ALSA/modprobe configuration.

The e-paper recipes use `bcm2835` and describe a Waveshare 2.15-inch G display. `ENABLE_SPI_BUS = "1"` is only documented as a local setting; no project-level machine file sets it. Confirm the exact board revision, wiring, display variant, SPI configuration, device tree, and ALSA behavior on hardware. Do not infer compatibility with other Raspberry Pi models from upstream machine files.
