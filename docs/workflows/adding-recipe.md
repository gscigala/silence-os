# Adding or changing a recipe

1. Put product-owned recipes and appends in `sources/meta-silence/recipes-*`; identify the exact upstream recipe before adding a `.bbappend`.
2. Read the existing image recipes and decide which image should install the package. A recipe is not automatically part of an image.
3. Declare build-time dependencies in `DEPENDS` and runtime dependencies in `RDEPENDS:${PN}`. Use existing `inherit` classes where they match the build system, and define installation and packaging explicitly.
4. Pin external Git sources with an intentional `SRCREV` where reproducibility is required. If an existing recipe uses `${AUTOREV}`, document that moving-source behavior and resolve the selected revision during validation.
5. Keep patches and service/config files beside the recipe in `files/` or its existing source directory. Check patch applicability against the fetched upstream revision. Submodule recipes may have custom `do_patch` code; preserve task ordering and inspect source submodule layout.
6. Treat credentials substituted into configuration or units as secrets. Avoid storing them in versioned metadata, logs, and generated artifacts that may be distributed.
7. Inspect impact on all three image recipes and the target machine. Hardware-specific changes need Raspberry Pi validation.
8. Run only metadata checks/builds available and authorized for the task. This repository snapshot has no documented test suite; record unperformed build and hardware checks.

Relevant examples are `connected-clock.bb` (Meson/systemd), Commutator Python recipes (setuptools3/systemd), `epaper-utility.bb` (submodule and patch handling), and `linux-raspberrypi_%.bbappend` (machine hardware customization).
