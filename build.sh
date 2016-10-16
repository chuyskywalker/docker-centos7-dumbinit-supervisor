#!/bin/bash -eux

docker build \
 --build-arg http_proxy=http://cache.service.consul:3128 \
 --build-arg https_proxy=http://cache.service.consul:3128 \
 -t chuyskywalker/centos7-dumbinit-supervisor .
