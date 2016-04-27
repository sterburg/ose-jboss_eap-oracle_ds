#!/bin/sh -x

echo "Found SQL files:"
ls -l /home/jboss/source
ls /home/jboss/source/src/main/resources/sql/*.sql

cd /usr/local/flyway-4.0/sql

/usr/local/flyway-4.0/flyway -X $* \
  -user=${MY_USERNAME} \
  -password=${MY_PASSWORD} \
  -schemas=${MY_DATABASE} \
  -target=${OPENSHIFT_BUILD_REFERENCE/v/}

