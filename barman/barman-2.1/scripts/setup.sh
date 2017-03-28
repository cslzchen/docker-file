#!/bin/bash

echo "test ssh to root"
ssh root@192.168.168.167 -p 6022 -C true

echo "test ssh to postgres"
ssh postgres@192.168.168.167 -p 6022 -C true

echo "kill ssh server daemo"
pkill -f sshd

echo "run ssh server daemon"
/usr/sbin/sshd
