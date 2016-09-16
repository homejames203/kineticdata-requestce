#!/bin/sh

# start tomcat in background
/usr/local/tomcat/bin/catalina.sh start

# run the database migration script
/usr/local/jruby-1.7.26/bin/jruby -S /usr/local/kinetic-task-migration/space.rb

# Keeps the docker container running
while true; do
    echo hello world > /dev/null 2>&1;
    sleep 1;
done
