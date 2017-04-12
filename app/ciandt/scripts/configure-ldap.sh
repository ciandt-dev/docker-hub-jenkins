#!/bin/bash

# bash parameters
set -u  #   nounset  - Attempt to use undefined variable outputs error message, and forces an exit
set -x  #   xtrace   - Enable print commands and their arguments as they are executed.

# binaries
CAT=$(which cat)
CP=$(which cp)
JAVA=$(which java)
XMLSTARLET=$(which xmlstarlet)

# get and check environment variables
readonly _JENKINS_URL="${JENKINS_URL}"
readonly _JENKINS_HTTPS_PORT="${JENKINS_HTTPS_PORT}"
readonly _JENKINS_HOME="${JENKINS_HOME}"
readonly _JENKINS_CONFIG_FILE=""${_JENKINS_HOME}"/config.xml"
readonly _LDAP_REALM="${LDAP_REALM}"
readonly _LDAP_SERVER="${LDAP_SERVER}"
readonly _LDAP_PORT="${LDAP_PORT}"
readonly _LDAP_USER="${LDAP_USER}"
readonly _LDAP_PASSWORD="${LDAP_PASSWORD}"
readonly _SSL_CERTIFICATE_PASSWORD="${SSL_CERTIFICATE_PASSWORD}"

# other variables
readonly KEYSTOREFILE="/var/lib/jenkins/jks"
readonly JENKINS_CLI=""${_JENKINS_HOME}"/war/WEB-INF/jenkins-cli.jar"
export JAVA_TOOL_OPTIONS="-Djavax.net.ssl.trustStore="${KEYSTOREFILE}" \
                          -Djavax.net.ssl.trustStorePassword="${_SSL_CERTIFICATE_PASSWORD}""

# backup Jenkins configuration file
"${CP}" --force \
    "${_JENKINS_CONFIG_FILE}" \
    ""${_JENKINS_CONFIG_FILE}".ldap.save"

# transform Jenkins configuration file
"${XMLSTARLET}" edit \
    --delete \
      "hudson/securityRealm/@class" \
    --delete \
      "hudson/securityRealm/enableCaptcha" \
    --delete \
      "hudson/securityRealm/disableSignup" \
    --insert \
      "hudson/securityRealm" \
      --type attr -n "class" \
      --value "hudson.plugins.active_directory.ActiveDirectorySecurityRealm" \
    --insert \
      "hudson/securityRealm" \
      --type attr -n "plugin" \
      --value "active-directory@2.0" \
    --subnode \
      "hudson/securityRealm" \
      --type elem -n "domains" \
    --subnode \
      "hudson/securityRealm/domains" \
      --type elem -n "hudson.plugins.active__directory.ActiveDirectoryDomain" \
    --subnode \
      "hudson/securityRealm/domains/hudson.plugins.active__directory.ActiveDirectoryDomain" \
      --type elem -n "name" \
    --subnode \
      "hudson/securityRealm/domains/hudson.plugins.active__directory.ActiveDirectoryDomain/name" \
      --type text -n "" \
      --value "${_LDAP_REALM}" \
    --subnode \
      "hudson/securityRealm/domains/hudson.plugins.active__directory.ActiveDirectoryDomain" \
      --type elem -n "servers" \
    --subnode \
      "hudson/securityRealm/domains/hudson.plugins.active__directory.ActiveDirectoryDomain/servers" \
      --type text -n "" \
      --value ""${_LDAP_SERVER}":"${_LDAP_PORT}"" \
    --subnode \
      "hudson/securityRealm" \
      --type elem -n "bindName" \
    --subnode \
      "hudson/securityRealm/bindName" \
      --type text -n "" \
      --value "${_LDAP_USER}" \
    --subnode \
      "hudson/securityRealm" \
      --type elem -n "bindPassword" \
    --subnode \
      "hudson/securityRealm/bindPassword" \
      --type text -n "" \
      --value "${_LDAP_PASSWORD}" \
    --subnode \
      "hudson/securityRealm" \
      --type elem -n "groupLookupStrategy" \
    --subnode \
      "hudson/securityRealm/groupLookupStrategy" \
      --type text -n "" \
      --value "RECURSIVE"\
    --subnode \
      "hudson/securityRealm" \
      --type elem -n "removeIrrelevantGroups" \
    --subnode \
      "hudson/securityRealm/removeIrrelevantGroups" \
      --type text -n "" \
      --value "false" \
    ""${_JENKINS_CONFIG_FILE}".ldap.save" \
    > "${_JENKINS_CONFIG_FILE}"

"${CAT}" << EOM

LDAP is set in your Jenkins configuration file
However, before be able to use it you need to restart Jenkins
The easiest way is to restart your Docker container

docker stop jenkins && docker start jenkins

And finally, congratulations!!
LDAP is now configured in your Jenkins!

EOM  
