# Silence OS architecture

## Scope and evidence

The root README identifies Silence OS as a Yocto Linux distribution for Raspberry Pi Zero WH, using Wi-Fi and a HiFiBerry DAC+ Zero. It describes connected-clock and e-paper use cases. The root repository primarily contains source synchronization, a build container, and build layer configuration; product recipes live in the separately checked out `sources/meta-silence`.

## Layers and product composition

`build/conf/bblayers.conf` includes Poky (`meta`, `meta-poky`, `meta-yocto-bsp`), OpenEmbedded (`meta-oe`, `meta-networking`, `meta-python`), `meta-raspberrypi`, and `meta-silence`. Product metadata in `sources/meta-silence/conf/distro/silence.conf` derives from Poky's distro config and selects systemd, `usrmerge`, and removes NFS from distro features.

The product layer defines three image recipes: a minimal base image, an expanded development image, and a connected-clock-with-cron variant. The README also advertises `silence-commutator-image`, but no corresponding recipe exists in the current `meta-silence` tree. See [layers](layers.md), [build system](build-system.md), and [dependencies](dependencies.md).

## Hardware and boot

The README proposes `MACHINE = "raspberrypi0-wifi"`, U-Boot, SPI, and local timezone/Wi-Fi settings in `local.conf`; these are instructions, not committed configuration. The product layer adds the HiFiBerry device-tree overlay to the kernel and appends `dtoverlay=hifiberry-dac` to Raspberry Pi boot `config.txt`. The distro includes a machine-specific `*-extra.conf`, but no extra machine file exists in the present `meta-silence/conf` directory. The actual configured machine and resulting boot chain are therefore unverified. See [boot process](boot-process.md).

## Source and release model

`sync.sh` invokes Ansible playbooks under `tools/layers-mngt/` to populate independent Git checkouts under `sources/`. Release playbooks pin specific commits; `develop.yml` follows Scarthgap branches for upstream layers and `develop` for `meta-silence`. At inspection time the source trees were on Scarthgap for Poky/OpenEmbedded/Raspberry Pi and on `feature/commutator` for `meta-silence`. The latter checkout was `v0.4.0-36-g3adc48e`, while `lastreleased.yml` pins another meta-silence commit. This is not a verified release build matrix.

## Verified, inferred, and unknown

- **Verified:** repository files, configured BBLAYERS, image recipes, distro settings, hardware-related appends, and current nested Git revisions.
- **Reasonable inference:** the product targets a Pi Zero WH with audio and optional e-paper peripheral functionality, based on the README and device-tree/boot configuration.
- **Unknown:** actual deployed machine/image, successful current build, exact installed package contents, bootloader selection, boot medium/firmware behavior, update strategy, security support policy, and hardware validation results. No OTA/update mechanism is present in the inspected product metadata.
