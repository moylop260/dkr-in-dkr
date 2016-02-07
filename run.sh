#!/bin/bash

set -v

if [ -z "${IMAGE}" ]
    then export IMAGE="dkr-in-dkr:201602"
fi
if [ -z "${PORT}" ]
    then export PORT="12376"
fi

if [ -z "${PORTS}" ]
    then export PORTS="2000-2099"
fi

if [ -z "${NAME}" ]
    then export NAME="$IMAGE"-test
fi

if [ -z "${CONTAINER_VOLUME}" ]
    then export CONTAINER_VOLUME="${HOME}/$IMAGE"
fi

export CONTAINER_VOLUME_PATH="$CONTAINER_VOLUME"/"$NAME"

docker build $1 -t $IMAGE .
docker run --privileged -m 8g --device-write-bps=/dev/sda:10mb --device-read-bps=/dev/sda:10mb --device-write-bps=/dev/md2:10mb --device-read-bps=/dev/md2:10mb --device-write-bps=/dev/sdb:10mb --device-read-bps=/dev/sdb:10mb -v $CONTAINER_VOLUME_PATH:/var/lib/docker -d -p $PORT:2376 -p ${PORTS}:${PORTS} --name=$NAME $IMAGE $2

