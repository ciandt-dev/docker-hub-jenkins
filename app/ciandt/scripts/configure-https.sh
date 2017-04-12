#!/bin/bash

# bash parameters
set -u  #   nounset  - Attempt to use undefined variable outputs error message, and forces an exit
set -x  #   xtrace   - Enable print commands and their arguments as they are executed.

# binaries
KEYTOOL=$(which keytool)
OPENSSL=$(which openssl)

# get and check environment variables
_JENKINS_URL="${JENKINS_URL}"
_JENKINS_HTTPS_PORT="${JENKINS_HTTPS_PORT}"
_SSL_CERTIFICATE_COUNTRY="${SSL_CERTIFICATE_COUNTRY}"
_SSL_CERTIFICATE_STATE="${SSL_CERTIFICATE_STATE}"
_SSL_CERTIFICATE_LOCATION="${SSL_CERTIFICATE_LOCATION}"
_SSL_CERTIFICATE_ORGANIZATION="${SSL_CERTIFICATE_ORGANIZATION}"
_SSL_CERTIFICATE_PASSWORD="${SSL_CERTIFICATE_PASSWORD}"

# create folder to receive ssh keys
if [ ! -d "/var/lib/jenkins" ]; then

  mkdir --parents /var/lib/jenkins

fi

# create a ssl key pair
"${OPENSSL}" req \
              -x509 \
              -newkey rsa:4096 \
              -keyout /var/lib/jenkins/pk \
              -out /var/lib/jenkins/cert \
              -days 365 \
              -subj "/C=${_SSL_CERTIFICATE_COUNTRY}/ST=${_SSL_CERTIFICATE_STATE}/L=${_SSL_CERTIFICATE_LOCATION}/O=${_SSL_CERTIFICATE_ORGANIZATION}/OU=Org/CN=${_JENKINS_URL}" \
              -passout pass:${_SSL_CERTIFICATE_PASSWORD}

# convert ssl to pkcs12
"${OPENSSL}" pkcs12 \
              -inkey /var/lib/jenkins/pk \
              -in /var/lib/jenkins/cert \
              -passin pass:${_SSL_CERTIFICATE_PASSWORD} \
              -export \
              -out /var/lib/jenkins/pkcs12 \
              -passout pass:${_SSL_CERTIFICATE_PASSWORD}

# import pkcs12 to java keystore
"${KEYTOOL}" -importkeystore \
              -srckeystore /var/lib/jenkins/pkcs12 \
              -srcstoretype pkcs12 \
              -srcstorepass ${_SSL_CERTIFICATE_PASSWORD} \
              -destkeystore /var/lib/jenkins/jks \
              -destkeypass ${_SSL_CERTIFICATE_PASSWORD} \
              -deststorepass ${_SSL_CERTIFICATE_PASSWORD}
