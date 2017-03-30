#!/bin/bash

IMAGE_NAME="postgres"
TAG="0.50"

POSTGRES_DATA="/var/lib/postgresql/data/"
DOCKER_VOLUMES="${PWD}/volumes/"

PORT_POSTGRES="192.168.168.167:6432:5432"

docker run $DAEMON -p $PORT_POSTGRES -v ${DOCKER_VOLUMES}data:$POSTGRES_DATA $IMAGE_NAME:$TAG

