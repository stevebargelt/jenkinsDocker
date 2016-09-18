FROM openjdk:8-jdk 
# ^^ openjdk:8-jdk  ^^ is based on buildpack-deps:jessie-scm just like...
# microsoft/dotnet:latest is
MAINTAINER Steve Bargelt

# Work around https://github.com/dotnet/cli/issues/1582 until Docker releases a
# fix (https://github.com/docker/docker/issues/20818). This workaround allows
# the container to be run with the default seccomp Docker settings by avoiding
# the restart_syscall made by LTTng which causes a failed assertion.
ENV LTTNG_UST_REGISTER_TIMEOUT 0

RUN apt-get update && apt-get install -y --no-install-recommends \
#		openssh-server \
		clang-3.5 \
        libc6 \
        libcurl3 \
        libgcc1 \
        libicu52 \
        liblttng-ust0 \
        libssl1.0.0 \
        libstdc++6 \
        libtinfo5 \
        libunwind8 \
        libuuid1 \
        zlib1g \			
	&& rm -rf /var/lib/apt/lists/*

# Install .NET Core SDK

ENV DOTNET_SDK_VERSION 1.0.0-preview2-003121
ENV DOTNET_SDK_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/preview/Binaries/$DOTNET_SDK_VERSION/dotnet-dev-win-x64.$DOTNET_SDK_VERSION.zip

# Install .NET Core SDK
ENV DOTNET_SDK_VERSION 1.0.0-preview2-003121
ENV DOTNET_SDK_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/preview/Binaries/$DOTNET_SDK_VERSION/dotnet-dev-debian-x64.$DOTNET_SDK_VERSION.tar.gz

RUN curl -SL $DOTNET_SDK_DOWNLOAD_URL --output dotnet.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Trigger the population of the local package cache  
ENV NUGET_XMLDOC_MODE skip  
RUN mkdir warmup \  
    && cd warmup \  
    && dotnet new \  
    && cd .. \  
    && rm -rf warmup \
    && rm -rf /tmp/NuGetScratch

# from docker site
#RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# # SSH login fix. Otherwise user is kicked off after login
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Create Jenkins User
RUN useradd jenkins -m -s /bin/bash

# Add public key for Jenkins login
#RUN mkdir /home/jenkins/.ssh

#COPY /files/authorized_keys /home/jenkins/.ssh/authorized_keys

#RUN mkdir /var/run/sshd
#RUN chmod 0755 /var/run/sshd

RUN chown -R jenkins /home/jenkins
RUN chgrp -R jenkins /home/jenkins
#RUN chmod 600 /home/jenkins/.ssh/authorized_keys
#RUN chmod 700 /home/jenkins/.ssh

# Add the jenkins user to sudoers
RUN echo "jenkins    ALL=(ALL)    ALL" >> etc/sudoers

# Set Name Servers
COPY /files/resolv.conf /etc/resolv.conf

# Expose SSH port and run SSHD
#EXPOSE 22
#CMD ["/usr/sbin/sshd","-D"]
