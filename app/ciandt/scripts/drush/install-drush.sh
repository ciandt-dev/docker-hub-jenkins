#!/usr/bin/env bash

: ' Installs Drush
    More information at: https://www.drupal.org/node/1248790

    '

# bash parameters
set -e  #   errexit  - Abort script at first error, when a command exits with non-zero status (except in until or while loops, if-tests, list constructs)
set -u  #   nounset  - Attempt to use undefined variable outputs error message, and forces an exit
set -x  #   xtrace   - Enable print commands and their arguments as they are executed.

# binaries
APT_GET=$(which apt-get)
COMPOSER=$(which composer)
LN=$(which ln)

# variables
_DRUSH_VERSION="${DRUSH_VERSION}"

# define required packages
readonly DRUSH_PACKAGES=" \
          mysql-client \
          openssh-client \
          rsync \
          "
# install required packages
"${APT_GET}" update \
&& "${APT_GET}" install \
                --no-install-recommends \
                --assume-yes \
                ${DRUSH_PACKAGES}

# remove apt cache in order to improve Docker image size
"${APT_GET}" clean

# install Drush through Composer
"${COMPOSER}" global require drush/drush:${_DRUSH_VERSION}

# create a link for drush
"${LN}" --force \
        --symbolic \
        /root/.composer/vendor/drush/drush/drush \
        /usr/local/bin/drush
