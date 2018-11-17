# Overview
This project is a simple Docker image that provides access to the [Azul Systems JDK](http://www.azul.com/downloads/zulu/).  It is intended for **running** JVM applications, not building and testing them. If you need to build a JVM application, [look at this project](https://github.com/kurron/docker-azul-jdk-11-build).


# Prerequisites
* a working [Docker](http://docker.io) engine
* a working [Docker Compose](http://docker.io) installation

# Building
Type `./build.sh` to build the image.

# Installation
Docker will automatically install the newly built image into the cache.

# Tips and Tricks

## Launching The Image
Use `./test.sh` to exercise the image.  

## Example Usage
There are samples on how to use the image in the `examples` folder and we will highlight some options here as well.

The basic idea is to use a Bash script to launch the JVM so you can apply the appropriate switches that are useful in a containerized environment.  You should copy that script into your image and make the script the entrypoint to your image.

The `Dockerfile`:
```
FROM kurron/docker-azul-jdk-11:latest

MAINTAINER Ron Kurr <kurr@kurron.org>

ADD launch-jvm.sh /home/microservice/launch-jvm.sh
RUN chmod a+x /home/microservice/launch-jvm.sh
ADD Hello.class /home/microservice/Hello.class

# Switch to the non-root user
USER microservice

# Run the simple program
ENTRYPOINT ["/home/microservice/launch-jvm.sh", "Hello"]
```
Example `Bash` script:
```
#!/usr/bin/env bash

PERCENTAGE_RAM_FOR_HEAP=${1:-80}
JVM_DNS_TTL=${2:-30}

CMD="${JAVA_HOME}/bin/java \
    -XX:+UseContainerSupport \
    -XX:MaxRAMPercentage=${PERCENTAGE_RAM_FOR_HEAP}
    -server \
    -Dsun.net.inetaddr.ttl=${JVM_DNS_TTL} \
    $*"

echo ${CMD}
exec ${CMD}
```

Please note that it is **very important to use `exec` to launch your script** or you will have signal issues.

You can control how much CPU and RAM the container see via Docker's `--cpus`, `--memory` and `--memory-swap` switches.

## Controlling JVM Memory
JDK 11 greatly simplifies controlling JVM heap size when combined with Docker.  The basic idea is that you tell Docker how much RAM the container can use and tell the JVM what percentage of that RAM can be used for heap.  Here is an example where Docker is told to limit the container to 1 GB of RAM and the JVM is told that it can use 80% of that for heap.

```
docker run  --memory 1gb --rm  azul/zulu-openjdk:11 sh -c 'exec java  -XX:+PrintFlagsFinal -XX:+UseContainerSupport -XX:MaxRAMPercentage=80 -version | grep -Ei "maxheapsize"'
```

## Example Code
If you are interested to see the new heap management in action, run the sample in `examples/single-core-jmx`.  Attach VisualVM to the process and you should see the heap set to 80% of the RAM allocated by Docker. Eventually, all the heap is consumed and the program crashes but you can see how the JVM behaves.

# Troubleshooting

# License and Credits
This project is licensed under the
[Apache License Version 2.0, January 2004](http://www.apache.org/licenses/).

* [JVM Memory Settings in a Container Environment: The Bare Minimum You Should Know Before Going Live](https://medium.com/adorsys/jvm-memory-settings-in-a-container-environment-64b0840e1d9e)
* [Guidance for Docker Image Authors](http://www.projectatomic.io/docs/docker-image-author-guidance/)
* [Java RAM Usage in Containers: Top 5 Tips Not to Lose Your Memory](http://blog.jelastic.com/2017/04/13/java-ram-usage-in-containers-top-5-tips-not-to-lose-your-memory/)
* [Java and Memory Limits in Containers: LXC, Docker and OpenVZ](http://blog.jelastic.com/2016/05/03/java-and-memory-limits-in-containers-lxc-docker-and-openvz/)
* [OpenJDK and Containers](https://developers.redhat.com/blog/2017/04/04/openjdk-and-containers/)
* [Java VM Options You Should Always Use in Production](http://blog.sokolenko.me/2014/11/javavm-options-production.html)
* [Exec form ENTRYPOINT example](https://docs.docker.com/engine/reference/builder/#exec-form-entrypoint-example)
* [Java SE support for Docker CPU and memory limits](https://blogs.oracle.com/java-platform-group/java-se-support-for-docker-cpu-and-memory-limits)

# List of Changes

* initial release
