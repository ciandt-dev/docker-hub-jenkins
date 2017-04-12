FROM jenkins:2.19.1

# define Docker image label information
LABEL com.ciandt.vendor="CI&T Software SA" \
      com.ciandt.release-date="2016-11-15" \
      com.ciandt.maintainers.1="Ivan Pinatti - @ivan_pinatti" \
      com.ciandt.maintainers.2="Thomas Bryan - @thobryan"

# defines root user, to perform privileged operations
USER root

# upgrade packages, install security updates and required packages
RUN readonly PACKAGES=" \
                make \
                xmlstarlet \
                " \
    && apt-get update \
    && apt-get upgrade --assume-yes \
    && apt-get install --no-install-recommends \
                        --assume-yes \
                        ${PACKAGES} \
    # remove apt cache in order to improve Docker image size
    && apt-get clean

## receive arguments, otherwise use default
# configure-https
ARG JENKINS_URL="jenkins.local"
ARG JENKINS_HTTPS_PORT="8080"
ARG SSL_CERTIFICATE_COUNTRY="BR"
ARG SSL_CERTIFICATE_STATE="SP"
ARG SSL_CERTIFICATE_LOCATION="Campinas"
ARG SSL_CERTIFICATE_ORGANIZATION="CiandT Software SA"
ARG SSL_CERTIFICATE_PASSWORD="password"

## transform arguments in environment variables
# configure-https
ENV JENKINS_URL ${JENKINS_URL}
ENV JENKINS_HTTPS_PORT ${JENKINS_HTTPS_PORT}
ENV SSL_CERTIFICATE_COUNTRY ${SSL_CERTIFICATE_COUNTRY}
ENV SSL_CERTIFICATE_STATE ${SSL_CERTIFICATE_STATE}
ENV SSL_CERTIFICATE_LOCATION ${SSL_CERTIFICATE_LOCATION}
ENV SSL_CERTIFICATE_ORGANIZATION ${SSL_CERTIFICATE_ORGANIZATION}
ENV SSL_CERTIFICATE_PASSWORD ${SSL_CERTIFICATE_PASSWORD}

# expose ports
EXPOSE ${JENKINS_HTTPS_PORT}

# copy scripts
RUN mkdir --parents /root/ciandt
COPY ciandt /root/ciandt

# configure Jenkins to use HTTPS only
RUN cd /root/ciandt \
    && make configure-https
ENV JENKINS_OPTS  --httpPort=-1 \
                  --httpsPort=${JENKINS_HTTPS_PORT} \
                  --httpsKeyStore=/var/lib/jenkins/jks \
                  --httpsKeyStorePassword=${SSL_CERTIFICATE_PASSWORD}

# drop back to the regular jenkins user - good practice
USER jenkins

# install plugins
COPY plugins/plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
