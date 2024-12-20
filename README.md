# silence-os

Silence OS is a Linux distribution based on the Yocto project. Multiple usage are
available, depending of the required utilisation.

## Requirements

### Hardware

Silence OS is a Raspberry Pi Zero WH hardware based project, and to work properly a WiFi
connection is required. The sound is handled by the DAC HifiBerry DAC+ zero.

More information about the hardware here :

* [Raspberry Pi Zero WH](https://www.reichelt.com/fr/fr/raspberry-pi-zero-wh-v-1-1-1-ghz-ram-512-mo-wlan-bt-rasp-pi-zero-wh-p222531.html)
* [HifiBerry DAC+ Zero](https://www.reichelt.com/fr/fr/raspberry-pi-shield-hifiberry-dac-zero-rpi-hb-dac-zero-p191039.html?&trstct=pos_0&nbc=1)

### Software

Silence OS is based on the Yocto Project and use a Docker Engine container. You can find
Docker Engine installation procedure
[here](https://docs.docker.com/engine/install/)

To synchronize sources, ansible is required. More information
[here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

## Fetch

To fetch all project depedencies, you need to execute first the synchronization script.
This script aims to synchronize layers of silence OS in a particular configuration. To get
the lastest delivery :

	$ ./sync.sh lastreleased
	
Mutliple configurations are available:

* lastreleased : lastest release of Silence OS.
* vX.Y.Z : Silence OS vX.Y.Z release.
* develop : current development layer configuration.

All configurations can be displayed with :

	$ ./sync.sh --help

## Configure

To start the docker compilation environment, execute:

	$ docker/run.sh

To set up the compilation enviroment, you need to execute:

	$ source layers/poky/oe-init-build-env
	
When the environment is correctly setted, you can now customize the build by appending to
the file `conf/local.conf`:

	# Raspberry Pi IP compliance https://meta-raspberrypi.readthedocs.io/en/latest/ipcompliance.html
	LICENSE_FLAGS_ACCEPTED = "synaptics-killswitch"

	# The machine is a raspberry pi 0 with wifi
	MACHINE = "raspberrypi0-wifi"
	
	# The distro is defined by this project
	DISTRO = "silence"

	# Use U-Boot as bootloader
	RPI_USE_U_BOOT = "1"
	
	# Define your timezone here, based on https://git.yoctoproject.org/cgit/cgit.cgi/poky/tree/meta/recipes-extended/timezone/tzdata.bb#n127
	DEFAULT_TIMEZONE = "Europe/Paris"
	
	# Fill your wifi informations here
	# Security type is based on https://manpages.debian.org/testing/connman/connman-service.config.5.en.html#Security=
	SILENCE_WIFI_NAME = "your WiFi name here"
	SILENCE_WIFI_PASSPHRASE = "your passphrase"
	SILENCE_WIFI_SECURITY = "your security"
	
## Build

To compile silence OS, execute:

	$ time nice ionice bitbake $image
	
Where `$image` is the required image. Available images :

* silence-cron-connected-clock-image : connected-clock, started and stopped automatically
		with time.
* silence-image : minimalist image.
* silence-dev-image : image used for development.


