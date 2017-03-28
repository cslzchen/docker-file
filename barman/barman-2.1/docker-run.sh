#!/bin/bash

if [ $# == 1 ] && [ $1 == "-d" ]; then
    DAEMON="-d"
else
    DAEMON=""
fi

IMAGE_NAME="barman-2.1"
TAG="0.30"

HOME="/root/"
BARMAN_CONFIG="/etc/barman.d/"
POSTGRES_DATA="/var/lib/postgresql/data/"

DOCKER_VOLUMES="${PWD}/docker-volumes/"

PORT_POSTGRES="192.168.168.167:7432:5432"
PORT_SSH="192.168.168.167:7022:22"

docker run $DAEMON -p $PORT_POSTGRES -p $PORT_SSH -v ${DOCKER_VOLUMES}barman.d:$BARMAN_CONFIG -v ${DOCKER_VOLUMES}pgdata:$POSTGRES_DATA -v ${DOCKER_VOLUMES}home:$HOME $IMAGE_NAME:$TAG

