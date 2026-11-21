# Layer inventory

Layer paths below are relative to repository root. The configured set comes from `build/conf/bblayers.conf`.

| Layer | Responsibility evidenced by path/config | Version evidence |
|---|---|---|
| `sources/poky/meta` | OpenEmbedded core metadata and recipes | Poky checkout describes as Yocto 5.0.21, Scarthgap; `LAYERSERIES_CORENAMES` is authoritative in layer metadata |
| `sources/poky/meta-poky` | Poky distribution metadata | Same Poky checkout |
| `sources/poky/meta-yocto-bsp` | Reference BSP metadata | Same Poky checkout |
| `sources/meta-openembedded/meta-oe` | General additional OE recipes | Checkout on Scarthgap; exact commit recorded by Git |
| `sources/meta-openembedded/meta-networking` | Networking recipes | Same meta-openembedded repository |
| `sources/meta-openembedded/meta-python` | Python recipes | Same meta-openembedded repository |
| `sources/meta-raspberrypi` | Raspberry Pi machine/BSP and boot/kernel support | Checkout on Scarthgap; see its `conf/layer.conf` and machine configs |
| `sources/meta-silence` | Product distro, images, application recipes, and local appends | `conf/layer.conf` declares collection `silence-layer`, priority 4, compatibility `scarthgap`; local checkout is `feature/commutator` |

The distro file `sources/meta-silence/conf/distro/silence.conf` requires Poky's distro, includes `conf/machine/${MACHINE}-extra.conf`, configures systemd and `usrmerge`, and removes NFS. No machine-extra file exists in the current product layer, so that include is a material configuration issue to resolve before assuming the distro parses successfully.

Dependencies are declared by each layer's `conf/layer.conf` (`LAYERDEPENDS_*`) and are separate from recipe dependencies. The root bblayers list establishes which layers are supplied, but does not itself prove that every declared layer dependency is satisfied or that BitBake parsing succeeds. Inspect the corresponding layer configuration before changing the set.

`tools/layers-mngt/*.yml` defines source revisions. v0.1.0 uses Gatesgarth; v0.2.0 and v0.3.0 pin commits; v0.4.0 and `lastreleased.yml` share pins; `develop.yml` uses Scarthgap branch names and a `develop` product branch. Current clones are separate nested repositories and are not part of the root repository's tracked file list.

There is no project-owned machine configuration in `meta-silence`. The README's only explicit target is `raspberrypi0-wifi`; meta-raspberrypi supplies many upstream machine definitions, but their presence does not make them supported Silence OS targets.
