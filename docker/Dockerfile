# SPDX-License-Identifier: (GPL-2.0+ OR MIT)

FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y sudo openssl apt-utils

WORKDIR /workdir

# Define username and temporary uid and gid
ENV USER=silence USER_ID=1000 USER_GID=1000

# now creating user, change password to 'ubuntu'
RUN groupadd --gid "${USER_GID}" "${USER}" && \
    useradd \
      --uid ${USER_ID} \
      --gid ${USER_GID} \
      --create-home \
      --shell /bin/bash\
      --password $(openssl passwd -1 ubuntu)\
      ${USER}

#setup locale
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y locales && dpkg-reconfigure locales --frontend noninteractive && locale-gen "en_US.UTF-8" && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Yocto
RUN apt-get update && apt-get install -y \
     gawk wget git diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping libsdl1.2-dev xterm \
     autoconf libtool libglib2.0-dev libarchive-dev \
     sed cvs subversion coreutils texi2html docbook-utils \
     help2man make gcc g++ desktop-file-utils libgl1-mesa-dev libglu1-mesa-dev \
     mercurial automake groff curl lzop asciidoc u-boot-tools dos2unix mtd-utils pv \
     libncurses5 libncurses5-dev libncursesw5-dev libelf-dev zlib1g-dev bc rename \
     iproute2 zstd liblz4-tool python-is-python3

# Update to latest
RUN apt-get update && apt-get dist-upgrade -y

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
