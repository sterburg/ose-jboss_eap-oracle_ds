FROM registry.access.redhat.com/jboss-eap-6/eap64-openshift:latest

COPY s2i/bin/run   /usr/local/s2i/run
COPY s2i/bin/datasource.sh    $JBOSS_HOME/bin/launch/datasource.sh
COPY s2i/bin/tx-datasource.sh $JBOSS_HOME/bin/launch/tx-datasource.sh


ADD modules/com/    /opt/eap/modules/com/
ADD configuration/settings.xml /home/jboss/.m2/settings.xml
ADD configuration/standalone-openshift.xml $JBOSS_HOME/standalone/configuration/standalone-openshift.xml

USER 0
RUN  curl https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/4.0/flyway-commandline-4.0-linux-x64.tar.gz |tar -C/usr/local -zx; \
     chmod +x   /usr/local/flyway-4.0/flyway; \
     rm -rf /usr/local/flyway-4.0/sql; \
     ln -s /home/jboss/source/src/main/resources/sql/ /usr/local/flyway-4.0
COPY flyway.sh   /usr/local/bin/flyway
COPY flyway.conf /usr/local/flyway-4.0/conf/flyway.conf
USER 185

LABEL com.redhat.deployments-dir="/opt/eap/standalone/deployments" \
      com.redhat.dev-mode="DEBUG:true" \
      com.redhat.dev-mode.port="DEBUG_PORT:8787" \
      io.k8s.description="Platform for building and running JavaEE applications on JBoss EAP 6.4" \
      io.k8s.display-name="JBoss EAP 6.4 + Oracle JDBC Driver + Flyway" \
      io.openshift.expose-services="8080:http" \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
      io.openshift.tags="builder,javaee,eap,eap6" \
      org.jboss.deployments-dir="/opt/eap/standalone/deployments"

