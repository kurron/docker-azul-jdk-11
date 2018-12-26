#!/usr/bin/env bash



CMD="docker run --cpus 1 \
                --memory 1gb \
                --interactive \
                --name zulu-test \
                --rm \
                --tty \
                kurron/docker-azul-jdk-11:latest"
echo $CMD
$CMD
