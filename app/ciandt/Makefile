# define phony targets
.PHONY: all configure-https configure-ldap configure-executors install-composer install-docker install-drush install-php install-python

# define behavior for; make AND make all
all: configure-https configure-ldap install-composer install-docker install-drush install-php install-python

# configure Jenkins to use HTTPS only
configure-https:
	/root/ciandt/scripts/configure-https.sh

# configure Jenkins to use Microsoft Active Directory auth
configure-ldap:
	/root/ciandt/scripts/configure-ldap.sh

# configure Jenkins executors
configure-executors:
	/root/ciandt/scripts/configure-executors.sh

# install Composer and its components
install-composer: install-php
	/root/ciandt/scripts/composer/install-composer.sh

# install Docker and its components
install-docker:
	/root/ciandt/scripts/docker/install-docker.sh

# install Drush and its components
install-drush: install-composer
	/root/ciandt/scripts/drush/install-drush.sh

# install PHP and its components
install-php:
	/root/ciandt/scripts/php/install-php.sh

# install Python and its components
install-python:
	/root/ciandt/scripts/python/install-python.sh
