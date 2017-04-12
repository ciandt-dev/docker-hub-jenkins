#!/bin/bash

# bash parameters
set -u  #   nounset  - Attempt to use undefined variable outputs error message, and forces an exit
set -x  #   xtrace   - Enable print commands and their arguments as they are executed.

# binaries
CP=$(which cp)
XMLSTARLET=$(which xmlstarlet)

# get and check environment variables
readonly _JENKINS_HOME="${JENKINS_HOME}"
readonly _JENKINS_CONFIG_FILE=""${_JENKINS_HOME}"/config.xml"
readonly _JENKINS_EXECUTORS="${JENKINS_EXECUTORS}"

# backup Jenkins configuration file
"${CP}" --force \
  "${_JENKINS_CONFIG_FILE}" \
  ""${_JENKINS_CONFIG_FILE}".executors.save"

# transform Jenkins configuration file
"${XMLSTARLET}" edit \
    --subnode \
      "hudson/numExecutors" \
      --type text -n "" \
      --value "${_JENKINS_EXECUTORS}" \
    ""${_JENKINS_CONFIG_FILE}".executors.save" \
    > "${_JENKINS_CONFIG_FILE}"
