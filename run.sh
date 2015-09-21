#!/bin/bash

set -v

if [ -z "${IMAGE}" ]
    then export IMAGE="dkr-in-dkr"
fi
if [ -z "${MYPORT}" ]
    then export MYPORT="12376"
fi
if [ -z "${CONTAINER_NAME}" ]
    then export CONTAINER_NAME="$IMAGE"-test
fi

if [ -z "${CONTAINER_VOLUME}" ]
    then export CONTAINER_VOLUME="${HOME}/$IMAGE"
fi

export CONTAINER_VOLUME_PATH="$CONTAINER_VOLUME"/"$CONTAINER_NAME"

docker build $1 -t $IMAGE .
docker run --privileged -v $CONTAINER_VOLUME:/var/lib/docker -d -p $MYPORT:2376 --name=$CONTAINER_NAME $IMAGE $2

