# Build system

## Inputs and configuration

`sync.sh <configuration>` selects a YAML Ansible playbook under `tools/layers-mngt/`; the playbook checks out Poky, meta-openembedded, meta-raspberrypi, and meta-silence into `sources/`. Synchronization therefore requires Ansible and access to the configured Git remotes (as also stated in `README.md`).

`build/conf/bblayers.conf` sets `BSPDIR` relative to its location and lists eight layers: three Poky layers, three meta-openembedded layers, meta-raspberrypi, and meta-silence. No tracked `build/conf/local.conf` is present. `README.md` gives suggested local variables: `MACHINE=raspberrypi0-wifi`, `DISTRO=silence`, U-Boot selection, SPI enablement, timezone, ConnMan Wi-Fi values, and a Commutator token. The distro's include of `conf/machine/${MACHINE}-extra.conf` cannot currently be resolved from `meta-silence/conf` because the referenced file is absent there.

## Container and environment

`docker/Dockerfile` builds an Ubuntu 22.04 image with listed Yocto host packages. `docker/run.sh` builds/runs the container, mounts the project at `/workdir`, and requires host `qemu-aarch64-static` and `.gitconfig`. `docker/docker-entrypoint.sh` adjusts the container user's IDs and appends `source /workdir/sources/poky/oe-init-build-env` to its shell startup file.

The README instead says to source `layers/poky/oe-init-build-env`; that path does not match the checked-in Docker entrypoint or current tree. The entrypoint sources the environment on interactive shell startup; it does not itself invoke BitBake.

## Image recipes

- `silence-image.bb` includes Poky's `core-image-base`, removes NFS and psplash image features, adds ConnMan and timezone data, and requests a read-only root filesystem.
- `silence-dev-image.bb` includes the base image and adds debug/test/Dropbear features and product applications/tools.
- `silence-cron-connected-clock-image.bb` requires the base image and adds `connected-clock-with-cron`.
- `README.md` also lists `silence-commutator-image`, but no recipe with that name is in the inspected product layer.

The README documents `time nice ionice bitbake <image>` as the build invocation. No build is performed as part of this documentation audit. No successful parse/build evidence is available. In particular, inspect the missing machine-extra include and local configuration before treating the documented command as validated.

## Artifacts and generated state

`.gitignore` excludes `build/tmp`, `build/cache`, `build/sstate-cache`, `build/buildhistory`, `downloads`, and related build state. Build artifact format and exact deployment outputs depend on the effective machine and layer metadata; no checked-in product configuration establishes them.
