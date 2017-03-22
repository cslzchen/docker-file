#!/bin/bash

if [ $# == 1 ] && [ $1 == "-d" ]; then
    DAEMON="-d"
else
    DAEMON=""
fi

IMAGE_NAME="barman-2.1"
TAG="0.20"

HOME="/root/"
BARMAN_CONFIG="/etc/barman.d/"
BARMAN_LIB="/var/lib/barman/"
POSTGRES_DATA="/var/lib/postgresql/data/"

PORT_POSTGRES="192.168.168.167:7432:5432"
PORT_SSH="192.168.168.167:7022:22"

docker run $DAEMON -p $PORT_POSTGRES -p $PORT_SSH -v $PWD/data/barman_lib:$BARMAN_LIB -v  $PWD/data/barman.d:$BARMAN_CONFIG -v $PWD/data/pgdata:$POSTGRES_DATA -v $PWD/data/home:$HOME $IMAGE_NAME:$TAG

