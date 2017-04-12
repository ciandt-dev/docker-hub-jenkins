#!/usr/bin/env bash

: ' Tests a running Docker container

    TODO: Improve tests, maybe try to use Behat as testing tool
    '

# bash parameters
set -u  #   nounset  - Attempt to use undefined variable outputs error message, and forces an exit
set -e  #   errexit  - Abort script at first error, when a command exits with non-zero status (except in until or while loops, if-tests, list constructs)
#set -x  #   xtrace   - Enable print commands and their arguments as they are executed.

# binaries
DOCKER=$(which docker)
CURL=$(which curl)
JQ=$(which jq)

# test start message
echo "  _______________________________________________________________________________"
echo -e "\n  -- Docker Test - SonarQube\n\n  Performing simple login test\n  Please wait..."

# get container ip address
readonly DOCKER_CONTAINER_IP=$("${DOCKER}" inspect --format \
                          "{{ .NetworkSettings.Networks.bridge.IPAddress }}" \
                          "${DOCKER_CONTAINER_NAME}" \
                          )

# get container jenkins https port
readonly DOCKER_JENKINS_HTTPS_PORT=$("${DOCKER}" exec "${DOCKER_CONTAINER_NAME}"\
                            bash -c 'echo "${JENKINS_HTTPS_PORT}"' \
                            )

# get admin password
readonly DOCKER_JENKINS_ADMIN_PASSWORD=$("${DOCKER}" exec "${DOCKER_CONTAINER_NAME}"\
                                bash -c 'cat /var/jenkins_home/secrets/initialAdminPassword' \
                                )

# create a tmp file for cookie-jar
COOKIE_JAR=$(mktemp)

# create a tmp output file
OUTPUT_FILE=$(mktemp)

# disable bash errexit
set +e

# tries to log in
"${CURL}" --insecure \
          --silent \
          --retry 5 \
          --retry-delay 0 \
          --retry-max-time 60 \
          --cookie-jar "${COOKIE_JAR}" \
          --cookie "${COOKIE_JAR}" \
          --location \
          --user "admin":"${DOCKER_JENKINS_ADMIN_PASSWORD}" \
          --output "${OUTPUT_FILE}" \
          https://"${DOCKER_CONTAINER_IP}":"${DOCKER_JENKINS_HTTPS_PORT}"/me/api/json?pretty=true
          > /dev/null

# check if login was OK and exit
if [ $("${JQ}" -r .id "${OUTPUT_FILE}") == "admin" ]; then

  echo -e "\n  Jenkins simple login test was successful!"
  echo -e "\n  _______________________________________________________________________________\n"

else

  echo -e "\n  ERROR! Jenkins simple login test was unsuccessful!"
  echo -e "\n  _______________________________________________________________________________\n"
  exit 1

fi
