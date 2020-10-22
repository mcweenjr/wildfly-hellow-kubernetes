FROM jboss/wildfly
RUN /opt/jboss/wildfly/bin/add-user.sh admin farp321 --silent
ADD target/hello-world-war-1.0.0.war /opt/jboss/wildfly/standalone/deployments/
