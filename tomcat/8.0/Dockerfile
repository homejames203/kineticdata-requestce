################################################################################
#
# Kinetic Data - Tomcat 8.0.37
#
# HOW TO BUILD
# docker build -t kineticdata/tomcat:8.0.37 -t kineticdata/tomcat:8.0 -t kineticdata/tomcat:latest .
#
################################################################################

FROM tomcat:8.0.37
MAINTAINER Kinetic Support <support@kineticdata.com>

# Configure Tomcat
RUN mv conf/server.xml conf/server.xml.bak
COPY server.xml conf/server.xml
RUN mv conf/tomcat-users.xml conf/tomcat-users.xml.bak
COPY tomcat-users.xml conf/tomcat-users.xml
RUN mv conf/web.xml conf/web.xml.bak
COPY web.xml conf/web.xml
COPY setenv.sh bin/setenv.sh
RUN chmod +x bin/setenv.sh

# Web Applications
RUN rm -rf webapps/ROOT/*; rm -rf webapps/docs; rm -rf webapps/examples
COPY ROOT.war webapps/ROOT/ROOT.war
WORKDIR $CATALINA_HOME/webapps/ROOT
RUN unzip ROOT.war && rm ROOT.war
WORKDIR $CATALINA_HOME
