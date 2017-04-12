#!/usr/bin/env bash

: ' Installs PHP

    '

# bash parameters
set -e  #   errexit  - Abort script at first error, when a command exits with non-zero status (except in until or while loops, if-tests, list constructs)
set -u  #   nounset  - Attempt to use undefined variable outputs error message, and forces an exit
set -x  #   xtrace   - Enable print commands and their arguments as they are executed.

# binaries
APT_GET=$(which apt-get)

# variables
_PHP_VERSION="${PHP_VERSION}"

# define required packages
readonly PHP_PACKAGES=" \
          php5=""${_PHP_VERSION}"*" \
          "
# install required packages
"${APT_GET}" update \
&& "${APT_GET}" install \
                --no-install-recommends \
                --assume-yes \
                ${PHP_PACKAGES}

# remove apt cache in order to improve Docker image size
"${APT_GET}" clean
