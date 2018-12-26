#!/usr/bin/env bash

# use the time as a tag
UNIXTIME=$(date +%F)

# docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
docker tag kurron/docker-azul-jdk-11:latest kurron/docker-azul-jdk-11:${UNIXTIME}
docker images

# Usage:  docker push [OPTIONS] NAME[:TAG]
docker push kurron/docker-azul-jdk-11:latest
docker push kurron/docker-azul-jdk-11:${UNIXTIME}
