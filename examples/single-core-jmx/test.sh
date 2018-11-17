#!/usr.bin/env bash

# runs a "memory leak" program that you can attach VisualVM to and watch the heap behavior
RAM=${1:-256mb}

CMD="docker run --cpus 1 \
                --interactive \
                --name single-core-jdk-jmx \
                --net host \
                --rm \
                --tty \
                --memory ${RAM} \
                --memory-swap 0 \
                single-core-jmx_single-core-jdk-jmx:latest"
echo $CMD
$CMD
