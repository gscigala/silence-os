# Architecture decisions visible in metadata

This page records implementation choices visible in files. It does not infer historical rationale or claim that the choices were validated.

| Visible choice | Evidence | Rationale/history |
|---|---|---|
| Raspberry Pi Zero WH is the documented target | `README.md` hardware section and suggested `MACHINE` | Not recorded |
| Product distro derives from Poky and uses systemd + usrmerge | `sources/meta-silence/conf/distro/silence.conf` | Not recorded |
| Base image requests a read-only root filesystem | `sources/meta-silence/recipes-core/images/silence-image.bb` | Not recorded |
| ConnMan is installed and configured with a product Wi-Fi service | image recipe and ConnMan append/config | Not recorded |
| HiFiBerry DAC overlay is added to kernel and deployed boot config | Linux and rpi-config appends | Not recorded |
| Layers are synchronized using Ansible playbooks with branches or commit pins | `sync.sh`, `tools/layers-mngt/*.yml` | Not recorded |
| Containerized Ubuntu 22.04 build host is provided | `docker/Dockerfile`, `docker/run.sh` | Not recorded |

Open configuration questions: distro references a machine-extra include absent from the current product layer; README suggests U-Boot/SPI but these settings are not committed; there is no update/signing policy in the inspected files.
