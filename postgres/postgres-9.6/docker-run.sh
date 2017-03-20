#!/bin/bash

IMAGE_NAME="postgres-9.6"
TAG="0.10"

HOME="/home/"
POSTGRES_DATA="/var/lib/postgresql/data/"

PORT_MAPPING="192.168.168.167:6543:5432"

docker run -d -p $PORT_MAPPING -v $PWD/data/pgdata:$POSTGRES_DATA -v $PWD/data/home:$HOME $IMAGE_NAME:$TAG

