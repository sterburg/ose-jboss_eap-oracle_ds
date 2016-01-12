FROM registry.access.redhat.com/jboss-eap-6/eap64-openshift:latest

ADD sti/bin/*   /usr/local/s2i/
ADD modules/com/    /opt/eap/modules/com/
ADD configuration/settings.xml /home/jboss/.m2/settings.xml
Add configuration/standalone-openshift.xml $JBOSS_HOME/standalone/configuration/standalone-openshift.xml

LABEL com.redhat.deployments-dir="/opt/eap/standalone/deployments" \
      com.redhat.dev-mode="DEBUG:true" \
      com.redhat.dev-mode.port="DEBUG_PORT:8787" \
      io.k8s.description="Platform for building and running JavaEE applications on JBoss EAP 6.4" \
      io.k8s.display-name="JBoss EAP 6.4 + Oracle JDBC Driver" \
      io.openshift.expose-services="8080:http" \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
      io.openshift.tags="builder,javaee,eap,eap6" \
      org.jboss.deployments-dir="/opt/eap/standalone/deployments"

