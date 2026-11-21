# Dependencies and component relationships

## Layer graph

`build/conf/bblayers.conf` adds the Poky core, Poky distro/BSP, three meta-openembedded sublayers, meta-raspberrypi, and meta-silence. In the current checkouts, the explicit layer dependency declarations include `meta-poky` → `core`, `meta-oe` → `core`, `meta-networking` → `core`, `meta-python`, and `openembedded-layer`, and `meta-python` → `core (>= 12)` and `openembedded-layer`. `meta-raspberrypi` declares `core`. The product layer declares no `LAYERDEPENDS` in its `conf/layer.conf`; that absence is not proof that its recipes need no metadata from other layers. `meta-yocto-bsp` also has no `LAYERDEPENDS` declaration in the inspected file. `meta-silence/conf/distro/silence.conf` requires Poky's distro. These declarations were read from each configured layer's `conf/layer.conf`.

## Product images to packages

`silence-image` → ConnMan, ConnMan client/wait-online, timezone data, and inherited core-image-base contents.

`silence-dev-image` → base image plus connected-clock-with-cron, Commutator display manager and data providers, e-paper utility/library, test package group, and systemd analysis tools.

`silence-cron-connected-clock-image` → base image plus connected-clock-with-cron → connected-clock + cronie.

These are recipe declarations, not proof of successful package resolution. The README's `silence-commutator-image` is not defined in the current source tree.

## Main recipe dependencies

- Connected clock: Meson C++ source; build/runtime dependencies include GStreamer and Boost; systemd unit supplied locally.
- Commutator display manager: Meson C++ source from a Git repository with submodules; depends on Boost, sdbus-c++, pugixml, OpenCV, nlohmann-json, and bcm2835. Its recipe applies a local cross-compile patch within the source submodule and installs systemd/cron files.
- Commutator IDFM, Sytadin, and Vigicrues: Python packages from separate Git repos, using setuptools3 and systemd. Runtime deps include Python D-Bus/requests/sdnotify and provider-specific packages; recipes install systemd, cron, and some D-Bus policy files. IDFM token and Vigicrues station ID are substituted into unit files.
- E-paper utility and Waveshare library: Raspberry Pi-specific C/C++ code using bcm2835; e-paper utility has a Git submodule and local cross-build patch. Both install/compile hardware-specific assets.
- ConnMan append supplies `silence.config`; Wi-Fi name, passphrase and security are substituted from variables at configure time. Its install task writes a ConnMan service unit post-start delay and Wi-Fi enable command.
- ALSA append installs project `alsa-base.conf`; Raspberry Pi config and Linux kernel appends add the HiFiBerry DAC overlay.

All references above are in `sources/meta-silence/recipes-*`. External application source URLs and fixed `SRCREV` values are declared there; a few recipes use `${AUTOREV}` and are not fixed to an immutable revision.

## Security, update, maintenance

Wi-Fi credentials and service tokens enter recipe task inputs and can be embedded in generated configuration or systemd units. Keep them out of commits and build logs. The base image requests `read-only-rootfs`, while the development image enables `debug-tweaks` and Dropbear; confirm resulting access policy for a release image. No OTA, package feed policy, signing setup, vulnerability workflow, or product update mechanism was identified in the inspected files.
