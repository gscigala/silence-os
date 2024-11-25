#!/bin/bash -e
# SPDX-License-Identifier: (GPL-2.0+ OR MIT)
# Inspirated from Variscite Ltd. https://github.com/varigit/var-host-docker-containers

readonly FILE_SCRIPT="$(basename "$0")"
readonly DIR_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly GIT_COMMIT="$(git --git-dir=${DIR_SCRIPT}/../.git log -1 --format=%h)"

cd ${DIR_SCRIPT}

UBUNTU_VERSION="22.04"
WORKDIR="$(pwd)/.."
SCRIPT=""
INTERACTIVE="-it"
DOCKER_VOLUMES=""
PRIVLEGED=""
BUILD_CACHE=""
CPUS="0.000"
QUIRKS=""

build_image() {
    DOCKERFILE="$1"
    if [ ! -f "${DIR_SCRIPT}/${DOCKERFILE}" ]; then
        echo "${DIR_SCRIPT}/${DOCKERFILE} not found"
        exit -1
    fi
    docker build ${BUILD_CACHE} -t "silence:${DOCKER_IMAGE}" ${DIR_SCRIPT} -f ${DOCKERFILE}
}

array_contains () {
    local seeking=$1; shift
    local in=1
    for element; do
        if [[ $element == "$seeking" ]]; then
            in=0
            break
        fi
    done
    return $in
}

help() {
    echo
    echo "Usage: ${DIR_SCRIPT}/${FILE_SCRIPT} <options>"
    echo
    echo " optional:"
    echo " -b --build               Build Docker Image, includes only changes made to Dockerfile"
    echo " -f --force-build         Build Docker Image with --no-cache, will include latest from Ubuntu"
    echo " -e --env                 Docker Environment File"
    echo " -n --non-interactive     Run container and exit without interactive shell"
    echo " -w --workdir             Docker Working Directory to Mount, default is ${WORKDIR}"
    echo " -v --volume              Docker Volumes to Mount, e.g. -v /opt/yocto_downloads_docker:/opt/yocto_downloads -v /opt/yocto_sstate_docker:/opt/yocto_sstate"
    echo " -p --privledged          Run docker in privledged mode, allowing access to all devices"
    echo " --host-network           Run container with host network mode"
    echo " -c --cpus                Limit the number of CPUs available to the container, default is ${CPUS}, which will use all available CPUs"
    echo " -h --help                Display this Help Message"
    echo
    echo "Example - Run Interactive Shell In Current Directory:"
    echo "./run.sh"
    echo
    echo "Example - Run Interactive Shell In Another Directory:"
    echo "./run.sh -w ~/var-fslc-yocto"
    echo
    echo "Example - Run Interactive Shell In Another Directory, mounting directories inside Docker container"
    echo "./run.sh -w ~/var-fslc-yocto -v /opt/yocto_downloads_docker:/opt/yocto_downloads -v /opt/yocto_sstate_docker:/opt/yocto_sstate"
    echo
    exit
}

# Add a flag to determine whether to build the image
BUILD_IMAGE_FLAG=0

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                help
            ;;
            -b|--build)
                # Set the flag to build the image later
                BUILD_IMAGE_FLAG=1
                shift
            ;;
            -f|--force-build)
                BUILD_CACHE="--no-cache"
                shift
            ;;
            -n|--non-interactive)
                INTERACTIVE=""
                shift
            ;;
            -w|--workdir)
                WORKDIR="$2"
                if [ "$WORKDIR" = "" ]; then
                    help
                fi
                if [ ! -d $WORKDIR ]; then
                    echo "Error: ${WORKDIR} doesn't exist"
                    echo "Please verify path and run:"
                    echo "mkdir -p ${WORKDIR}"
                    exit -1
                fi
                shift # past argument
                shift # past value
            ;;
            -v|--volume)
                NEW_VOL="$2"
                if [ "$NEW_VOL" = "" ]; then
                    help
                fi
                DOCKER_VOLUMES="${DOCKER_VOLUMES} -v ${NEW_VOL}"
                shift # past argument
                shift # past value
            ;;
            -e|--env)
                ENV_FILE=$2
                if [ ! -f "${ENV_FILE}" ]; then
                    echo "Error: ${ENV_FILE} Not Found"
                    echo "Error: ${DIR_SCRIPT}/env/${ENV_FILE} Not Found either"
                    help
                fi
                ENV_FILE="--env-file=${ENV_FILE}"
                shift # past argument
                shift # past value
            ;;
            -p|--privledged)
                PRIVLEGED=" --privileged"
                shift
            ;;
            --host-network)
                DOCKER_HOST_NETWORK=" --network host"
                shift
            ;;
            -c|--cpus)
                CPUS="$2"
                if ! [[ "$CPUS" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
                    echo "Error: CPU limit must be a valid number."
                    exit 1
                fi
                shift
                shift
            ;;
            *)    # unknown option
                echo "Unknown option: $1"
                help
            ;;
        esac
    done
}

parse_args "$@"

readonly DOCKER_IMAGE="yocto-${UBUNTU_VERSION}-${GIT_COMMIT}"

# Verify qemu-user-static is installed
if [ ! -f /usr/bin/qemu-aarch64-static ]; then
    echo "Error: Please install qemu-user-static on host, required for debian"
    exit -1
fi

# Build container if the image does not exist, the cache needs to be rebuilt, or the build flag is set
if ! docker images | grep -q "${DOCKER_IMAGE}" \
    || [ -n "$BUILD_CACHE" ] \
    || [ $BUILD_IMAGE_FLAG -eq 1 ]; then
    build_image "Dockerfile"
fi

uid=$(id -u ${USER})
gid=$(id -g ${USER})

# .gitconfig is required by repo and git
if [ ! -f ${HOME}/.gitconfig ]; then
    echo "Error: Please create ${HOME}/.gitconfig on your host computer:"
    echo '    $ git config --global user.email "you@example.com"'
    echo '    $ git config --global user.name "Your Name"'
    exit -1
fi

docker run --rm -e HOST_USER_ID=$uid -e HOST_USER_GID=$gid \
    -v ~/.ssh:/home/vari/.ssh \
    -v ${WORKDIR}:/workdir \
    -v ~/.gitconfig:/tmp/host_gitconfig \
    -v /opt:/opt \
    -v /usr/src:/usr/src \
    -v /lib/modules:/lib/modules \
    -v /linux-kernel:/linux-kernel \
    ${DOCKER_VOLUMES} \
    ${INTERACTIVE} \
    ${ENV_FILE} \
    ${PRIVLEGED} \
    ${DOCKER_HOST_NETWORK} \
    --cpus=${CPUS} \
    ${QUIRKS} \
    silence:${DOCKER_IMAGE}
