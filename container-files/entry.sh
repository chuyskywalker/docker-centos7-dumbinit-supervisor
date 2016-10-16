#!/usr/bin/dumb-init /bin/bash

echo "Running any available init scripts:"
find /config/init/ -name "*.sh" -print0 | while read -d $'\0' file
do
  echo " -- Running $file..."
  chmod +x $file
  $file
done

echo "Starting supervisor"
supervisord -c /config/supervisor.ini
