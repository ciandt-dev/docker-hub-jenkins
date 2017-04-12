#!/usr/bin/env bash

: ' Installs docker-engine and docker-composer

    '

# bash parameters
set -e  #   errexit  - Abort script at first error, when a command exits with non-zero status (except in until or while loops, if-tests, list constructs)
set -u  #   nounset  - Attempt to use undefined variable outputs error message, and forces an exit
set -x  #   xtrace   - Enable print commands and their arguments as they are executed.

# binaries
APT_GET=$(which apt-get)
CHMOD=$(which chmod)
CURL=$(which curl)

# get and check environment variables
readonly _DOCKER_ENGINE_VERSION="${DOCKER_ENGINE_VERSION}"
readonly _DOCKER_COMPOSER_VERSION="${DOCKER_COMPOSER_VERSION}"

# define required packages
readonly PACKAGES=" \
            apt-transport-https \
            ca-certificates \
            "

# update apt-get
"${APT_GET}" update

# install required packages
"${APT_GET}" install \
              --no-install-recommends \
              --assume-yes \
              ${PACKAGES}

# check apt-key binary
APT_KEY=$(which apt-key)

# add docker repo to apt
"${APT_KEY}" adv \
    --keyserver hkp://p80.pool.sks-keyservers.net:80 \
    --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list

# update apt-get with new repo
"${APT_GET}" update

# install docker-engine
"${APT_GET}" install \
              --no-install-recommends \
              --assume-yes \
              docker-engine=""${_DOCKER_ENGINE_VERSION}"-*"

# install docker compose
# more information at: https://github.com/docker/compose/releases/tag/1.8.1
"${CURL}" --location \
            https://github.com/docker/compose/releases/download/"${_DOCKER_COMPOSER_VERSION}"/docker-compose-`uname -s`-`uname -m` \
            > /usr/local/bin/docker-compose
"${CHMOD}" +x /usr/local/bin/docker-compose

# remove apt cache in order to improve Docker image size
"${APT_GET}" clean
