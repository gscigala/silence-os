# Debugging workflow

## Build metadata

- Check the root and each nested checkout with `git status --short --branch`; the layer directories are independent Git repositories.
- Verify selected synchronization playbook in `tools/layers-mngt/`, actual commits, and configured paths in `build/conf/bblayers.conf`.
- Inspect effective local configuration (`build/conf/local.conf` is not checked in) and confirm `MACHINE`, `DISTRO`, and private variable values outside logs.
- Investigate the unresolved `include conf/machine/${MACHINE}-extra.conf` in `meta-silence/conf/distro/silence.conf` before attributing parse errors to another layer.
- For recipe issues, trace `SRC_URI`/`SRCREV`, `DEPENDS`, task overrides, patches and image package lists. Pay attention to `${AUTOREV}` and Git submodules.

## Device and boot

Capture the exact image, machine, layer commits, generated deploy files, serial console output, and systemd journal. For audio, verify `config.txt`, deployed overlay, kernel DTB/overlay, ALSA config, and physical DAC. For e-paper, verify SPI is enabled, the display model matches the source path, and `bcm2835` integration is present. The repository does not define a canonical flashing procedure or hardware test suite.

Do not report a device boot, package, or network behavior as verified from metadata alone.
