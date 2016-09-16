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
ARG TASK_URL=https://s3.amazonaws.com/kineticdata.com/downloads/kinetic-task/${TASK_VER}/kinetic-task.war

RUN mkdir -p ${CATALINA_HOME}/webapps/kinetic-task
WORKDIR ${CATALINA_HOME}/webapps/kinetic-task
ADD ${TASK_URL} kinetic-task.war
RUN unzip kinetic-task.war && rm kinetic-task.war
WORKDIR ${CATALINA_HOME}
