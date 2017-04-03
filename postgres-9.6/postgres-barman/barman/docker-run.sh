#!/bin/bash

IMAGE_NAME="barman"
TAG="0.50"

docker stop $IMAGE_NAME && docker rm $IMAGE_NAME
docker run --name=$IMAGE_NAME $IMAGE_NAME:$TAG

