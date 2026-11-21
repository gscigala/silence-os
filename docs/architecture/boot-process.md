# Boot process

## Evidence in this repository

The README recommends the Raspberry Pi Zero WH, sets `MACHINE = "raspberrypi0-wifi"` in an example local configuration, and suggests `RPI_USE_U_BOOT = "1"`. It does not commit a `local.conf`. `sources/meta-silence/recipes-bsp/bootfiles/rpi-config_%.bbappend` appends `dtoverlay=hifiberry-dac` to the deployed Raspberry Pi `config.txt`. `recipes-kernel/linux/linux-raspberrypi_%.bbappend` adds `overlays/hifiberry-dac.dtbo` to `KERNEL_DEVICETREE`.

The distro includes `conf/machine/${MACHINE}-extra.conf`, but the current product layer has no files in `conf/machine/`. `build/conf/bblayers.conf` includes meta-raspberrypi, which provides the upstream machine and boot recipes. These facts show intent for Raspberry Pi firmware configuration and kernel audio overlay; they do not establish a successful image or a precise bootloader chain.

## Expected high-level path (inference)

For the README's proposed target and settings, the expected path is Raspberry Pi platform boot firmware reading the generated boot partition configuration, then U-Boot if the active meta-raspberrypi configuration honors `RPI_USE_U_BOOT`, followed by the Linux kernel/device tree and a systemd userspace. The Wi-Fi service is ConnMan. This ordering is a platform-level inference; the repository does not provide a captured boot log or finalized machine configuration proving it.

## Unverified details

The active `MACHINE`, effective `RPI_USE_U_BOOT`, kernel/image artifact formats, boot partition layout, firmware version, kernel command line, root filesystem mounting, and U-Boot environment are unknown. No updater or A/B boot mechanism was found in the product layer. Validate generated deploy artifacts and actual device boot before changing boot-related metadata.
