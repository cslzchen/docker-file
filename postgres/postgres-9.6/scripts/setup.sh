#!/bin/bash

echo "create /home/postgres"
mkdir -p /home/postgres

echo "copy /root/.ssh"
cp -R /root/.ssh /home/postgres/

echo "update permissions"
chown -R postgres:root /home/postgres

echo "test ssh as root"
ssh root@192.168.168.167 -p 7022 -C true

echo "test ssh as postgres"
su postgres -c "ssh root@192.168.168.167 -p 7022 -C true"

echo "kill ssh server daemo"
pkill -f sshd

echo "run ssh server daemon"
/usr/sbin/sshd

