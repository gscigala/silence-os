# Build workflow

## Documented steps

1. Install Docker Engine and Ansible as required by `README.md`.
2. Synchronize layers with `./sync.sh lastreleased` or another configuration listed in `tools/layers-mngt/`.
3. Start the build container with `docker/run.sh`. The script requires host `qemu-aarch64-static` and a host `.gitconfig`.
4. The entrypoint sets up `sources/poky/oe-init-build-env`. The README's `layers/poky` path is inconsistent with the checked-in `sources/poky` layout.
5. Create/configure an ignored `build/conf/local.conf` using the README example as a starting point. Do not commit secrets. Confirm the `meta-silence` machine-extra include issue first.
6. The README documents `time nice ionice bitbake <image>`.

## Targets declared

`silence-image`, `silence-dev-image`, `silence-cron-connected-clock-image` exist in `sources/meta-silence/recipes-core/images/`. The README's `silence-commutator-image` target is absent from the inspected tree. No target has been tested in this audit; successful parsing and compilation are unverified.

`build/conf/bblayers.conf` references the expected source paths under `sources/`. Synchronization and actual checkout versions must agree with this config. See `docs/architecture/build-system.md` for revision and path caveats.
