#!/usr/bin/env bash



CMD="docker run --cpus 1 \
                --memory 1gb \
                --interactive \
                --name zulu-test \
                --rm \
                --tty \
                docker-azul-jdk-11_azul-jdk:latest"
echo $CMD
$CMD
