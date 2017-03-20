#!/bin/bash

IMAGE_NAME="barman-2.1"
TAG="0.10"

HOME="/home/"
BARMAN_CONFIG="/etc/barman.d/"
POSTGRES_DATA="/var/lib/postgresql/data/"

PORT_MAPPING="192.168.168.167:7654:5432"

docker run -d -p $PORT_MAPPING -v $PWD/data/barman.d:$BARMAN_CONFIG -v $PWD/data/pgdata:$POSTGRES_DATA -v $PWD/data/home:$HOME $IMAGE_NAME:$TAG

