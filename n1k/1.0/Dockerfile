################################################################################
#
# Kinetic Data - N1K
#
# HOW TO BUILD
# docker build -t kineticdata/n1k:1.0.0 .
#
################################################################################

FROM kineticdata/task:4.0.6
MAINTAINER Kinetic Support <support@kineticdata.com>


ENV CATALINA_HOME /usr/local/tomcat
WORKDIR $CATALINA_HOME

# Start Tomcat
RUN bin/catalina.sh run

#-------------------------------------------------------------------------------
# Configure Kinetic Task
#
# - Modify database configuration
# - Add Sources
# - Add Policy Rules
# - Add Categories
# - Add Users
# - Add Groups
# - Add Handlers and configure
# - Add Routines and configure
# - Add Trees
#-------------------------------------------------------------------------------
