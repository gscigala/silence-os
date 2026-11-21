# Product applications

The product recipes are in `sources/meta-silence/recipes-multimedia/` and `recipes-support/`. They are separate from the upstream projects fetched through `SRC_URI`.

| Component | Recipe and role | Integration |
|---|---|---|
| Connected clock | `connected-clock/connected-clock.bb`; Meson application | GStreamer/Boost, systemd service |
| Clock schedule | `connected-clock/connected-clock-with-cron.bb` | Depends on connected-clock and cronie; starts at 06:50 and stops at 00:10 via cron |
| Commutator display manager | `commutator-display-manager/commutator-display-manager.bb`; e-paper display management program | Meson, native libraries, submodule patch, systemd and cron |
| IDFM reports | `commutator-idfm-line-reports/commutator-idfm-line-reports.bb` | Python, D-Bus, requests; token substituted into service unit; systemd/cron |
| Sytadin | `commutator-sytadin/commutator-sytadin.bb` | Python, D-Bus, requests, BeautifulSoup; systemd/cron |
| Vigicrues | `commutator-vigicrues/commutator-vigicrues.bb` | Python plus `python3-pyvigicrues`; station ID substituted into service; systemd/cron |
| E-paper utility | `epaper-utility/epaper-utility.bb` | Meson, bcm2835, submodule patch, splash service and cleaning cron |
| Waveshare library | `recipes-support/waveshare-e-paper/waveshare-e-paper.bb` | Builds a 2.15-inch display program with bcm2835 and installs a bitmap |

Image inclusion is controlled by `silence-dev-image.bb` and `silence-cron-connected-clock-image.bb`. The presence of a recipe does not imply inclusion in every image. Source revisions, dependencies, files, and patch mechanics should be read directly in each recipe before edits. Some source repositories use `${AUTOREV}`; check the selected revision before reproducing a build.
