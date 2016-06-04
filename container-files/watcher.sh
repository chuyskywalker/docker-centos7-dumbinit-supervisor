#!/bin/bash

# Watch supervisor for any processes NOT in the "RUNNING" state.
# If any are found, kill supervisor.
#
# This is here to emulate "the docker way" in which if anything fails,
# the container exits. Otherwise supervisor would just restart a process
# all day long.

# Give everything a moment to boot up
sleep 30

while true; do
    COUNT=$(supervisorctl status | grep -cv RUNNING)
    if [ $COUNT -ne 0 ]; then
        echo "Some processes caught not running:"
        supervisorctl -c /config/supervisor.ini status
        kill `cat /var/run/supervisord.pid`
        exit 0
    fi
    sleep 5
done
