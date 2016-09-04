FROM centos:7
MAINTAINER Steve Bargelt

# see https://bugs.debian.org/775775
# and https://github.com/docker-library/java/issues/19#issuecomment-70546872
ENV CA_CERTIFICATES_JAVA_VERSION 20140324

RUN yum makecache \
    && yum update -y \
    && yum install -y \
    wget \
    zip \
    openssh-client \
    unzip \
    java-1.8.0-openjdk \
    && yum clean all


# SET Jenkins Environment Variables
ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000
ENV JENKINS_VERSION 2.7.3
ENV JENKINS_SHA f822e70810e0d30c6fbe7935273635740faa3d89
ENV JENKINS_UC https://updates.jenkins-ci.io 
ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log
ENV JAVA_OPTS="-Xmx8192m"
ENV JENKINS_OPTS="--logfile=/var/log/jenkins/jenkins.log --webroot=/var/cache/jenkins/war"

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN groupadd -g ${gid} ${group} \
    && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME /var/jenkins_home

# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

# Install Tini
ENV TINI_VERSION 0.9.0
ENV TINI_SHA fa23d1e20732501c3bb8eeeca423c89ac80ed452

# Use tini as subreaper in Docker container to adopt zombie processes 
RUN curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static -o /bin/tini && chmod +x /bin/tini && echo "$TINI_SHA  /bin/tini" | sha1sum -c -

COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy


# Can be used to customize where jenkins.war get downloaded from
ARG JENKINS_URL=http://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war

# could use ADD but this one does not check Last-Modified header neither does it allow to control checksum 
# see https://github.com/docker/docker/issues/8331
RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha1sum -c -

# Prep Jenkins Directories
RUN chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref
RUN mkdir /var/log/jenkins
RUN mkdir /var/cache/jenkins
RUN chown -R ${user}:${group} /var/log/jenkins
RUN chown -R ${user}:${group} /var/cache/jenkins

# Expose Ports for web and slave agents
EXPOSE 8080
EXPOSE 50000

# Copy in local config files and set proper permissions
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY jenkins-support /usr/local/bin/jenkins-support
COPY plugins.sh /usr/local/bin/plugins.sh
COPY install-plugins.sh /usr/local/bin/install-plugins.sh
RUN chmod +x /usr/local/bin/jenkins-support
RUN chmod +x /usr/local/bin/plugins.sh
RUN chmod +x /usr/local/bin/install-plugins.sh
RUN chmod +x /usr/local/bin/jenkins.sh

# Copy in the Docker certs, we'll use /usr/local/etc for them
COPY certs/ca-key.pem /usr/local/etc/jenkins/certs/ca-key.pem
COPY certs/ca.pem /usr/local/etc/jenkins/certs/ca.pem
COPY certs/cert.pem /usr/local/etc/jenkins/certs/cert.pem
COPY certs/key.pem /usr/local/etc/jenkins/certs/key.pem

# Make sure cert permissions are set correctly
RUN chmod +r /usr/local/etc/jenkins/certs/ca.pem
RUN chmod +r /usr/local/etc/jenkins/certs/cert.pem
RUN chown -R jenkins:jenkins /usr/local/etc/jenkins

# Switch to the jenkins user
USER ${user}

# Tini as the entry point to manage zombie processes
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]

# Install default plugins
COPY plugins.txt /tmp/plugins.txt
RUN /usr/local/bin/plugins.sh /tmp/plugins.txt

#RUN /usr/local/bin/install-plugins.sh jclouds-jenkins yet-another-docker-plugin
#RUN /usr/local/bin/install-plugins.sh yet-another-docker-plugin

