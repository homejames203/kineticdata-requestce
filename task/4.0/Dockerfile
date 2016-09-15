################################################################################
#
# Kinetic Data - Task 4.0.6
#
# HOW TO BUILD
# docker build -t kineticdata/task:4.0.6 -t kineticdata/task:4.0 -t kineticdata/task:latest .
#
################################################################################

FROM kineticdata/tomcat:8.0.37
MAINTAINER Kinetic Support <support@kineticdata.com>


ENV CATALINA_HOME /usr/local/tomcat
WORKDIR $CATALINA_HOME


ARG TASK_VER=4.0.6
#ARG TASK_URL=https://s3.amazonaws.com/kineticdata.com/downloads/kinetic-task/${TASK_VER}/kinetic-task.war
ARG TASK_URL=https://s3.amazonaws.com/kineticdata.com/downloads/kinetic-task/${TASK_VER}-docker-wip/kinetic-task.war

RUN mkdir -p ${CATALINA_HOME}/webapps/kinetic-task
WORKDIR ${CATALINA_HOME}/webapps/kinetic-task
ADD ${TASK_URL} kinetic-task.war
RUN unzip kinetic-task.war && rm kinetic-task.war

# Start Tomcat to deploy kinetic-task so the consumer can be copied in
WORKDIR ${CATALINA_HOME}
RUN bin/catalina.sh start && sleep 10
ARG CONSUMER_URL=https://community.kineticdata.com/@api/deki/files/11377/kinetic_request_ce_consumer.rb
WORKDIR ${CATALINA_HOME}/webapps/kinetic-task/WEB-INF/consumers
ADD ${CONSUMER_URL} kinetic_request_ce_consumer.rb


#-------------
# JRUBY
#-------------
ARG JRUBY_VER=1.7.26
ENV JRUBY_HOME /usr/local/jruby-$JRUBY_VER
WORKDIR /usr/local
ADD https://s3.amazonaws.com/jruby.org/downloads/$JRUBY_VER/jruby-bin-$JRUBY_VER.tar.gz .
RUN tar -xzvf jruby-bin-$JRUBY_VER.tar.gz && rm jruby-bin-$JRUBY_VER.tar.gz
ENV PATH $JRUBY_HOME/bin:$PATH
RUN gem install colorize rest-client:1.8.0
WORKDIR ${CATALINA_HOME}
