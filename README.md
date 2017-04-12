## CI&T Jenkins Docker base image

This is the source code of [CI&T Jenkins Docker image](https://hub.docker.com/r/ciandt/jenkins/) hosted at [Docker hub](https://hub.docker.com/).

It contents the source code for building the publicly accessible Docker image and some scripts to easy maintain and update its code.

Keeping it short,  this image utilizes [Jenkins official Docker image](https://hub.docker.com/_/jenkins/) as a source, then copy plugins (listed below), add scripts and configure it to run only HTTPS with a self-signed SSL certificate.

* * *

## [*Requirements*](#requirements)

Before proceeding please check the required packages below:

 - docker engine => 1.12
 - make
 - grep
 - curl
 - jq

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

## [How-to](#how-to)

There is a Makefile in the root of the repository with all actions that can be performed.

#### [Build](#how-to-build)

```
make build
```

#### [Run](#how-to-run)

```
make run
```

#### [Test](#how-to-test)

```
make test
```

#### [Debug](#how-to-debug)

```
make debug
```

#### [Shell access](#how-to-shell)

```
make shell
```

#### [Clean](#how-to-clean)

```
make clean
```

#### [Clean All](#how-to-clean-all)

```
make clean-all
```

#### [All - Build, run and test](#how-to-all)

```
make all
```

Or just

```
make
```

* * *

## [Build process](#build-process)

There are some required parameters that are already pre-defined for the build step, if you need to modify, please refer to;

> __"# receive arguments, otherwise use default"__ section in __app/Dockerfile__

Quick explanation, all of them are [ARG](https://docs.docker.com/engine/reference/builder/#/arg)s that are converted to [ENV](https://docs.docker.com/engine/reference/builder/#/env)s during Dockerfile build process.

* * *

## [.env](#env)

Thinking in a multi-stage environment, a file name __.env__ is provided at repository root and it is used to define which set of ENV variables are going to load-up during Docker run.

Default value is:

> __ENVIRONMENT="local"__

It is possible to change to any desired string value. This is just an ordinary alias to load one of configuration files that can exist in __conf__ folder.

Example, if you change it to:

> ENVIRONMENT="__dev__"

When you run the container it will load variables from:

> conf/jenkins.__dev__.env

It is an easy way to inject new variables when developing a new script.

* * *

## [Run process](#run-process)

As described in .env section, run will load environment variables from a file.
This approach is better describe in official Docker docs in the [link](https://docs.docker.com/compose/env-file/).

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
