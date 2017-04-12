#!/usr/bin/env bash

: ' Installs Composer
    More information at: https://getcomposer.org/download/

    '

# bash parameters
set -e  #   errexit  - Abort script at first error, when a command exits with non-zero status (except in until or while loops, if-tests, list constructs)
set -u  #   nounset  - Attempt to use undefined variable outputs error message, and forces an exit
set -x  #   xtrace   - Enable print commands and their arguments as they are executed.

# binaries
MKDIR=$(which mkdir)
MV=$(which mv)
PHP=$(which php)
RM=$(which rm)

# variables
_COMPOSER_VERSION="${COMPOSER_VERSION}"

# create a tmp folder
"${MKDIR}" --parents /tmp/composer

# change workdir
cd /tmp/composer

# download and check Composer installer
"${PHP}" -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

# check downloaded Composer installer \
"${PHP}" -r "if (hash_file('SHA384', 'composer-setup.php') === 'aa96f26c2b67226a324c27919f1eb05f21c248b987e6195cad9690d5c1ff713d53020a02ac8c217dbf90a7eacc9d141d') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"

# install Composer \
"${PHP}" composer-setup.php --version "${_COMPOSER_VERSION}"

# move to bin \
"${MV}" composer.phar /usr/local/bin/composer

# remove Composer installer \
"${PHP}" -r "unlink('composer-setup.php');"

# remove folder
cd \
&& "${RM}" --force \
           --recursive \
           /tmp/composer
