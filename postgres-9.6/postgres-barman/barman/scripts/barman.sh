#!/bin/bash

if [ $# != 1 ]; then
    echo "expecting one argument"
    exit 1
fi

SERVER_NAME=$1

echo "barman check"
barman check $SERVER_NAME

echo "barman cron"
barman cron

echo "barman xlog"
barman switch-xlog --force --archive $SERVER_NAME

echo "barman check"
barman check $SERVER_NAME

echo "barman replication status"
barman replication-status $SERVER_NAME

echo "barman backup"
barman backup $SERVER_NAME

echo "barman list-backup"
barman list-backup $SERVER_NAME

exit 0

