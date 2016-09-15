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

# Start Tomcat in the background
RUN bin/catalina.sh start

#Configure Kinetic Task
RUN mkdir -p /usr/local/temp-space
COPY space /usr/local/temp-space
WORKDIR /usr/local/temp-space
RUN jruby -S space.rb && cd /usr/local && rm -rf temp-space
