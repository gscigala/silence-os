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

Silence OS is based on the Yocto Project. You need to install Yocto required packages 
first. You can found all required packages 
[here](https://docs.yoctoproject.org/ref-manual/system-requirements.html).

To synchronize sources, ansible is required. More information
[here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

## Fetch

To fetch all project depedencies, you need to execute first the synchronization script.
This script aims to synchronize layers of silence OS in a particular configuration. To get
the lastest delivery:

	$ ./sync.sh master
	
Mutliple configurations are available:

* master : lastest silence-os layer configuration delivery.
* develop : current development layer configuration.

## Configure

To set up the compilation enviroment, you need to execute:

	$ source layers/poky/oe-init-build-env
	
When the environment is correctly setted, you can now customize the build by appending to
the file `conf/local.conf`:

	# Use U-Boot as bootloader
	RPI_USE_U_BOOT = "1"

	# The distro is defined by this project
	DISTRO = "silence"
	
	# Define your timezone here, based on https://git.yoctoproject.org/cgit/cgit.cgi/poky/tree/meta/recipes-extended/timezone/tzdata.bb#n127
	DEFAULT_TIMEZONE = "Europe/Paris"
	
	# Fill your wifi informations here
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


