#!/bin/bash

DATA_DIR=/srv

CONFIG_FILE=${DATA_DIR}/default-jenkins

if [ ! -f $CONFIG_FILE ]; then
  cp /etc/default/jenkins $CONFIG_FILE
fi

source $CONFIG_FILE

JENKINS_HOME=${DATA_DIR}/jenkins
if [ ! -d $CONFIG_FILE ]; then
  mkdir -p $JENKINS_HOME
fi
chown -R $JENKINS_USER $JENKINS_HOME
chmod 700 $JENKINS_HOME

DAEMON=/usr/bin/daemon
DAEMON_ARGS="--name=$NAME --inherit --env=JENKINS_HOME=$JENKINS_HOME --output=$JENKINS_LOG --pidfile=$PIDFILE --respawn --foreground --pty"

su -l $JENKINS_USER --shell=/bin/bash -c "$DAEMON $DAEMON_ARGS -- $JAVA $JAVA_ARGS -jar $JENKINS_WAR $JENKINS_ARGS"
