FROM microsoft/aspnetcore-build:1.0.1

# This is FROM openjdk:8-jdk  
RUN apt-get update && apt-get install -y --no-install-recommends \
		bzip2 \
		unzip \
		xz-utils \
                apt-transport-https \
	&& rm -rf /var/lib/apt/lists/*

RUN echo 'deb http://deb.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list
RUN echo 'deb https://apt.dockerproject.org/repo debian-jessie main' > /etc/apt/sources.list.d/docker.list

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

ENV JAVA_VERSION 8u111
ENV JAVA_DEBIAN_VERSION 8u111-b14-2~bpo8+1

# see https://bugs.debian.org/775775
# and https://github.com/docker-library/java/issues/19#issuecomment-70546872
ENV CA_CERTIFICATES_JAVA_VERSION 20140324

RUN set -x \
	&& apt-get update \
	&& apt-get install -y \
		openjdk-8-jdk="$JAVA_DEBIAN_VERSION" \
		ca-certificates-java="$CA_CERTIFICATES_JAVA_VERSION" \
	&& rm -rf /var/lib/apt/lists/* \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]

# see CA_CERTIFICATES_JAVA_VERSION notes above
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

##### END OF THE JDK

##### START Jenkins Slave Node Config settings

# Create Jenkins User
RUN useradd jenkins -m -s /bin/bash

RUN chown -R jenkins /home/jenkins
RUN chgrp -R jenkins /home/jenkins
RUN chown -R jenkins /tmp
RUN chgrp -R jenkins /tmp

# Add the jenkins user to sudoers
RUN echo "jenkins    ALL=(ALL)    ALL" >> etc/sudoers

# Must install docker to create docker images from docker container. Inception. Head... hurts.
# container must be called with -v /var/run/docker.sock:/var/run/docker.sock
RUN apt-get install -y --no-install-recommends apt-transport-https ca-certificates
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN apt-get update && apt-get install -y --no-install-recommends \
	docker-engine \
&& rm -rf /var/lib/apt/lists/*

# This must run after the docker install 
RUN gpasswd -a jenkins docker

USER jenkins