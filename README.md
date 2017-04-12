## CI&T Jenkins Docker image(s)

This is the source code of [CI&T Jenkins Docker image(s)](https://hub.docker.com/r/ciandt/jenkins/) hosted at [Docker hub](https://hub.docker.com/).

It contents the source code for building the publicly accessible Docker image(s) and some scripts to easy maintain and update its code.

By utilizing Docker technologies, that already provides an easy way of spinning up new environments along with its dependencies. This image can speed up developers which different backgrounds and equipments to create quickly a new local environment allowing them to easily integrate in automated tests and deployment pipelines.

At this moment we have the following version(s)

## [2.19.1](#jenkins-2.19.1)

This Docker image intends to be a containerized baseline solution for Jenkins with pre-loaded plugins and scripts for easy deploy and management.

The source code is available under GPLv3 at Github in this [link](https://github.com/ciandt-dev/docker-hub-jenkins).

Basically, this image utilizes [Jenkins official Docker image](https://hub.docker.com/_/jenkins/) as a source, then installs plugins (listed below), add scripts and configure it to run only HTTPS with a self-signed SSL certificate.

* * *

## [Jenkins Plugins](#plugins)

These are the plugins bundled.

- [active-directory 2.0](http://wiki.jenkins-ci.org/display/JENKINS/Active+Directory+Plugin)
- [bouncycastle-api 2.16.0](https://wiki.jenkins-ci.org/display/JENKINS/Bouncy+Castle+API+Plugin)
- [copyartifact 1.38.1](https://wiki.jenkins-ci.org/display/JENKINS/Copy+Artifact+Plugin)
- [credentials 2.1.8](https://wiki.jenkins-ci.org/display/JENKINS/Credentials+Plugin)
- [display-url-api 0.5](https://wiki.jenkins-ci.org/display/JENKINS/Display+URL+API+Plugin)
- [git-client 2.0.0](https://wiki.jenkins-ci.org/display/JENKINS/Git+Client+Plugin)
- [git 3.0.0](https://wiki.jenkins-ci.org/display/JENKINS/Git+Plugin)
- [junit 1.19](https://wiki.jenkins-ci.org/display/JENKINS/JUnit+Plugin)
- [ldap 1.13](https://wiki.jenkins-ci.org/display/JENKINS/LDAP+Plugin)
- [mailer 1.18](https://wiki.jenkins-ci.org/display/JENKINS/Mailer)
- [mapdb-api 1.0.9.0](https://wiki.jenkins-ci.org/display/JENKINS/MapDB+API+Plugin)
- [matrix-project 1.7.1](https://wiki.jenkins-ci.org/display/JENKINS/Matrix+Project+Plugin)
- [scm-api 1.3](https://wiki.jenkins-ci.org/display/JENKINS/SCM+API+Plugin)
- [script-security 1.24](https://wiki.jenkins-ci.org/display/JENKINS/Script+Security+Plugin)
- [ssh-credentials 1.12](https://wiki.jenkins-ci.org/display/JENKINS/SSH+Credentials+Plugin)
- [structs 1.5](https://wiki.jenkins-ci.org/display/JENKINS/Structs+plugin)
- [subversion 2.7.1](https://wiki.jenkins-ci.org/display/JENKINS/Subversion+Plugin)
- [workflow-scm-step 2.2](https://wiki.jenkins-ci.org/display/JENKINS/Pipeline+SCM+Step+Plugin)
- [workflow-step-api 2.4](https://wiki.jenkins-ci.org/display/JENKINS/Pipeline+Step+API+Plugin)

* * *

### [*Quick Start*](#quickstart)

__Download the image__

```
docker pull ciandt/jenkins:2.19.1
```

__Run a container__

```
docker run \
  --name \
    myContainer \
  --detach \
    ciandt/jenkins:2.19.1
```

__Check running containers__

```
docker ps --all
```

 * * *

## [*Requirements*](#requirements)

Before proceeding please check the required packages below:

 - docker engine => 1.12
 - make
 - grep
 - curl
 - jq

* * *

## [CI&T scripts](#scripts)

There are available scripts to help customize Jenkins container:

- configure-https
- configure-ldap

Scripts are composed by two parts;

- one executable file *script-name*__.sh__
- one variables file *script-name*__.env__

The *script-name* __.env__ contains the variables that *script-name* __.sh__ requires to perform its task.

All scripts are located inside folder __/root/ciandt__ and must be declared in the *__Makefile__*. Thus, it is easy to run any of them.

Furthermore, it is possible to merge all the environment variables together and use an __env_file__ approach when running Docker, it is highly recommended!
More information about it can be found [here](https://docs.docker.com/compose/env-file/).

Since ***configure-https*** variables are already shiped in the image, you can run the container and compare environment variables with the ones in __configure-https.env__ by running:
```
export
```

Then you can run the commands to see the outcome:
```
cd /root/ciandt
make configure-https
```

It will gather required variables from environment, execute and produce the according output.

* * *

## [Running standalone](#running-standalone)

The simplest way of running the container without any modification

```
docker run ciandt/jenkins:2.19.1
```

* * *

## [Customizing](#customizing)

As intended, you can take advantage from this image to build your own and already configure everything that a project requires.

Just to have an example, a Dockerfile sample downstream this image and configuring Jenkins to use LDAP (Microsoft Active Directory) authentication.

```
FROM ciandt/jenkins:2.19.1

## configure-ldap
# define environment variables
ENV LDAP_REALM=contoso.local
ENV LDAP_SERVER=server.contoso.local
ENV LDAP_PORT=3268
ENV LDAP_USER=contoso.local\weird_admin
ENV LDAP_PASSWORD=MyStrongPassword1

# configure Sonar LDAP
RUN cd /root/ciandt && \
    make configure-ldap
```

* * *

## [Running in Docker-Compose](#running-docker-compose)

Since a project is not going to use solely Jenkins, it may need a Docker-Compose file.

Just to exercise, follow an example of __Jenkins__ running behind a __Nginx__ proxy. Create a new folder and fill with these 3 files and respective folders;

#### [__conf/jenkins.local.env__](#sonar-env)

```
## configure-ldap
LDAP_REALM=contoso.local
LDAP_SERVER=server.contoso.local
LDAP_PORT=3268
LDAP_USER=contoso.local\weird_admin
LDAP_PASSWORD=MyStrongPassword1

## Nginx proxy configuration
# https://hub.docker.com/r/jwilder/nginx-proxy/
VIRTUAL_HOST=jenkins.local
VIRTUAL_PORT=8080
VIRTUAL_PROTO=https
```

#### [__app/jenkins/Dockerfile__](#dockerfile)

```
FROM ciandt/jenkins:2.19.1

# configure Jenkins LDAP
RUN cd /root/ciandt && \
    make configure-ldap
```

#### [__docker-compose.yml__](#docker-compose)

```
jenkins:
  build: ./jenkins
  container_name: jenkins
  env_file: ../conf/jenkins.local.env

nginx:
  image: jwilder/nginx-proxy:latest
  container_name: nginx
  volumes:
    - /var/run/docker.sock:/tmp/docker.sock:ro
  ports:
    - "80:80"
    - "443:443"
```

Then just spin-up your Docker-Compose with the command:

```
docker-compose up -d
```

Inspect Nginx container IP address:

```
docker inspect --format \
              "{{.NetworkSettings.Networks.bridge.IPAddress }}" \
              "nginx"
```

Use the IP address to update __hosts__ file. Let's suppose that was 172.17.0.2.

Then, add an entry to __/etc/hosts__.
> 172.17.0.2 jenkins.local

And now, try to access in the browser
> http://jenkins.local

Voilà!
Your project now have Nginx and Jenkins up and running.
\\o/

* * *

## [User Feedback](#user-feedback)

### [*Issues*](#issues)

If you have problems, bugs, issues with or questions about this, please reach us in [Github issues page](https://github.com/ciandt-dev/docker-hub-jenkins/issues).

__Needless to say__, please do a little research before posting.

### [*Contributing*](#contributing)

We gladly invite you to contribute fixes, new features, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a GitHub issue, especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.

### [*Documentation*](#documentation)

There are __two parts__ of the documentation.

First, in the master branch, is this README.MD. It explains how this little scripts framework work and it is published on [Github page](https://github.com/ciandt-dev/docker-hub-jenkins).

Second, in each image version there is an additional README.MD file that explains how to use that specific Docker image version itself. __*Latest version*__ is always the one seen on [Docker Hub page](https://hub.docker.com/r/ciandt/jenkins).

We strongly encourage reading both!

* * *

Happy coding, enjoy!!

"We develop people before we develop software" - Cesar Gon, CEO
