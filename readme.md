# Centos 7 + DumbInit + Supervisor

A simple way to run a PID-1 safe container with multiple processes.

## Usage

Build your container from this, and add any startup programs into `/config/init` along with supervisor ini files into `/config/supervisor/` and you're good to go.

## Watcher

There is a default program called `watcher` which will keep an eye on supervisor'ed processes. If any of them go into a non-`RUNNING` state, it will kill `supervisord`. This makes the container, overall, behave like a single process container. If you do not want this behavior, simply overwrite the file `/config/supervisor/watcher.ini` with something empty.

