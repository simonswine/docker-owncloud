FROM stackbrew/debian:wheezy
MAINTAINER Christian Simon <simon@swine.de>

# Ensure sources.list is correct
ADD ./sources.list /etc/apt/sources.list

# Add jenkins keys
ADD ./jenkins-ci.org.key /tmp/jenkins-ci.org.key
RUN apt-key add /tmp/jenkins-ci.org.key

# Upgrade/Install Packages
RUN apt-get update &&  \
    DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install vim python-setuptools nano git \
        subversion curl procps psmisc sudo build-essential wget locales jenkins \
        supervisor openjdk-7-jre-headless && \
    apt-get clean && \
    rm /var/lib/apt/lists/*_*

# Create pid dir
RUN mkdir -p /var/run/jenkins && \
    chown jenkins:jenkins /var/run/jenkins

# Set timezone
RUN echo "Europe/Berlin" > /etc/timezone  &&  dpkg-reconfigure -f noninteractive tzdata

# Copy run script
ADD ./run.sh /.docker/run.sh
RUN chmod +x /.docker/run.sh

# Command
CMD /.docker/run.sh

# Volume
VOLUME /srv

# Expose Port
EXPOSE 8080
