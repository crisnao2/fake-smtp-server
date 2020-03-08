#!/bin/sh
java ${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom -jar /opt/fake-smtp-server.jar $@