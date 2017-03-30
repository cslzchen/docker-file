#!/bin/bash

echo "create /home/postgres"
mkdir -p /home/postgres

echo "update permissions"
chown -R postgres:root /home/postgres

