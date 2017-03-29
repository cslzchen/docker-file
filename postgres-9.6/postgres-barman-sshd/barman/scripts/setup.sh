#!/bin/bash

echo "clear ssh known hosts"
ssh-keygen -f "/root/.ssh/known_hosts" -R [192.168.168.167]:6022

echo "test ssh to root"
ssh root@192.168.168.167 -p 6022 -C true

echo "test ssh to postgres"
ssh postgres@192.168.168.167 -p 6022 -C true

