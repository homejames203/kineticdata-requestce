################################################################################
#
# Kinetic Data - N1K
#
# HOW TO BUILD
# docker build -t kineticdata/n1k:1.0.0 .
#
# HOW TO RUN
# docker run -d -p :8080 --env-file ./spaces/env-SLUG.list --name friendly_name kineticdata/n1k:1.0.0 .
#
################################################################################

FROM kineticdata/task:4.0.6
MAINTAINER Kinetic Support <support@kineticdata.com>

WORKDIR /usr/local


# JRUBY
ARG JRUBY_VER=1.7.26
ARG JRUBY_URL=https://s3.amazonaws.com/jruby.org/downloads/$JRUBY_VER/jruby-bin-$JRUBY_VER.tar.gz
ENV JRUBY_HOME /usr/local/jruby-$JRUBY_VER
ADD ${JRUBY_URL} .
RUN tar -xzvf jruby-bin-$JRUBY_VER.tar.gz && rm jruby-bin-$JRUBY_VER.tar.gz
ENV PATH $JRUBY_HOME/bin:$PATH
RUN gem install colorize rest-client:1.8.0


# Copy the Kinetic Task API SDK and necessary data files
RUN mkdir -p kinetic-task-migration
WORKDIR /usr/local/kinetic-task-migration
COPY space .
RUN rm env.list


# Copy the Entrypoint script
WORKDIR /usr/local
COPY entrypoint.sh bin
RUN chmod +x bin/entrypoint.sh


ENTRYPOINT ["/bin/sh", "/usr/local/bin/entrypoint.sh"]
