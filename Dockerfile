FROM ubuntu:trusty
MAINTAINER Christian Simon <simon@swine.de>

# Ensure sources.list is correct
ADD ./sources.list /etc/apt/sources.list

# Add ownlcoud keys
ADD ./owncloud_release.key /tmp/apt.key
RUN apt-key add /tmp/apt.key && rm /tmp/apt.key

# Upgrade/Install Packages
RUN apt-get update &&  \
    DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install libapache2-mod-php5  && \
    apt-get clean && \
    rm /var/lib/apt/lists/*_*

RUN service apache2 start && \
    apt-get update &&  \
    DEBIAN_FRONTEND=noninteractive apt-get -y install owncloud libreoffice-common supervisor && \
    apt-get clean && \
    rm /var/lib/apt/lists/*_*

# Move configuration into /srv
RUN rm -rf /var/www/owncloud/config && \
    ln -s ../../../srv/config/ /var/www/owncloud/config

# Set timezone
RUN echo "Europe/Berlin" > /etc/timezone  &&  dpkg-reconfigure -f noninteractive tzdata

# Copy supervisor config
ADD ./apache.foreground.sh /etc/apache2/foreground.sh
ADD ./supervisord.apache.conf /etc/supervisor/conf.d/apache.conf

# Command
CMD supervisord -n -c /etc/supervisor/supervisord.conf

# Volume
VOLUME /srv

# Expose Port
EXPOSE 80
