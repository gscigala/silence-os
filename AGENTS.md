# Project overview

Silence OS is a Yocto-based Linux distribution for a Raspberry Pi Zero WH with Wi-Fi and a HiFiBerry DAC+ Zero, according to `README.md`. The optional product applications include a connected clock and an e-paper display application suite. The repository at its root is an orchestrator; most Yocto metadata lives in the separately cloned `sources/meta-silence` layer, alongside upstream Poky, meta-openembedded, and meta-raspberrypi.

The documented stack is Yocto Project 5.0 (Scarthgap), BitBake, systemd, ConnMan, Raspberry Pi firmware/kernel metadata, and product-specific C++/Python applications. Consult `docs/architecture/` for verified paths and limits.

# Repository navigation

- `README.md`: project description, host requirements, suggested local build settings, and image names.
- `sync.sh`, `tools/layers-mngt/*.yml`: Ansible-based source-layer synchronization; these files choose branches or commits.
- `build/conf/bblayers.conf`: configured layer paths. `build/conf/local.conf` is not present in the repository snapshot.
- `docker/`: Docker image and run scripts; `docker-entrypoint.sh` enters `sources/poky/oe-init-build-env`.
- `sources/meta-silence/`: product layer, maintained as a separate Git repository and ignored by the root repository.
- `sources/poky/`, `sources/meta-openembedded/`, `sources/meta-raspberrypi/`: upstream layers, also separate checkouts.
- `docs/architecture/`: system, layers, build, boot, and dependency maps. `docs/components/` covers product layer components. `docs/workflows/` describes build, debug, and recipe change workflows. `docs/decisions/` records only decisions visible in metadata.

For image contents, read `sources/meta-silence/recipes-core/images/`. For hardware changes, inspect the README suggested `MACHINE`, meta-raspberrypi machine configuration, the product kernel and bootfiles appends, and `docs/architecture/boot-process.md`. For a recipe change, read its `.bb`/`.bbappend`, local files and patches, then the corresponding `SRC_URI`, `DEPENDS`, and image install lists.

# Yocto development rules

- Prefer product-specific changes in `sources/meta-silence`; do not edit upstream layer metadata to implement product behavior when a recipe append or product recipe is appropriate.
- Match a `.bbappend` filename to the upstream recipe. Existing wildcard appends use `%`; inspect the applicable upstream version before changing their syntax or task behavior.
- Keep source revisions intentional. Several recipes pin `SRCREV`; some use `${AUTOREV}`. Do not silently replace pinned revisions or infer reproducibility from a moving branch.
- Keep patches in the recipe's `files/` directory and ensure the recipe applies and tracks them. The e-paper recipes explicitly apply cross-compilation patches inside `do_patch`; inspect patch context against the fetched source before updating.
- Declare build dependencies with `DEPENDS`, runtime dependencies with `RDEPENDS`, and image membership in the image recipe. Preserve the distinction between those mechanisms.
- Place machine-specific kernel/device-tree changes in the appropriate machine-scoped metadata or targeted append. The present distro includes `conf/machine/${MACHINE}-extra.conf`, but no such file exists in the current `meta-silence/conf`; verify this before selecting `DISTRO = "silence"`.
- Keep credentials out of committed metadata. The ConnMan append substitutes Wi-Fi values at configure time; the README also documents a Commutator token variable. Treat generated package/config outputs as sensitive.

# Build and validation

The documented container entry point is `docker/run.sh`; the README says to source the build environment and run `time nice ionice bitbake <image>`. The checked-in paths differ: `docker/docker-entrypoint.sh` sources `sources/poky/oe-init-build-env`, while the README mentions `layers/poky/oe-init-build-env`. Use the actual workspace paths and inspect the generated environment before building. The README's suggested values are `MACHINE = "raspberrypi0-wifi"`, `DISTRO = "silence"`, `RPI_USE_U_BOOT = "1"`, `ENABLE_SPI_BUS = "1"`, timezone, Wi-Fi fields, and a Commutator token; these are examples, not a committed `local.conf`.

Images named by the README and defined in the product layer are `silence-image`, `silence-dev-image`, and `silence-cron-connected-clock-image`. The README additionally names `silence-commutator-image`, but no recipe with that image name exists in the current layer snapshot. Do not invent a build target or assume parsing succeeds.

No project test suite or verified `bitbake-layers` validation invocation is documented in the root repository. Do not run a build unless the task requests it. The current checkout shows Scarthgap sources, while the image-building environment, target hardware, credentials, network access, and suitability of the recorded `lastreleased` revisions have not been validated here.

# Critical constraints

- Do not hand-edit generated `build/tmp`, `build/cache`, `build/sstate-cache`, `build/buildhistory`, or download contents. They are ignored build state, not sources.
- Do not edit the `sources/*` layer clones as though they were files tracked by the root project. Check the relevant nested Git status first; changes there belong to distinct repositories.
- Avoid putting Wi-Fi passphrases or service tokens in committed configuration, logs, or documentation.
- Hardware metadata changes can alter SPI, audio overlays, device trees, boot configuration, and image compatibility. Validate against the actual Raspberry Pi Zero WH and DAC+ Zero before deployment.
- Bootloader selection in the README is a local setting. No Silence OS U-Boot recipe or committed configuration proves that U-Boot is active in the current checkout.

# Working methodology

Before a change, identify the affected component, trace its layer and recipe dependencies, inspect existing local and nested Git changes, determine all affected images and machines, then describe a modification strategy.

After a change, check metadata consistency with validations available in the configured environment, report which checks could not run, and update the relevant documentation. Never claim build or hardware validation that was not performed.
