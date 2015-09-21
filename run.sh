#!/bin/bash

set -v

if [ -z "${IMAGE}" ]
    then export IMAGE="dkr-in-dkr"
fi
if [ -z "${PORT}" ]
    then export PORT="12376"
fi
if [ -z "${NAME}" ]
    then export NAME="$IMAGE"-test
fi

if [ -z "${CONTAINER_VOLUME}" ]
    then export CONTAINER_VOLUME="${HOME}/$IMAGE"
fi

export CONTAINER_VOLUME_PATH="$CONTAINER_VOLUME"/"$NAME"

docker build $1 -t $IMAGE .
docker run --privileged -v $CONTAINER_VOLUME_PATH:/var/lib/docker -d -p $PORT:2376 --name=$NAME $IMAGE $2

