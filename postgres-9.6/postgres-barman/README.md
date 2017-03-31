# Docker Configuration for Barman Streaming Backup Without `rsync/ssh`

## Barman Docker

### Docerfile

```
FROM postgres:9.6

RUN apt-get update && apt-get install -y \
        barman \
 && apt-get clean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

# Barman config
COPY config/barman.conf /etc/barman.conf
COPY config/pg_osf.conf /etc/barman.d/pg_osf.conf
COPY scripts/* /root/

# Barman backup location
VOLUME ["/var/lib/barman"]

CMD ["postgres"]
```

### Config

- Main Configuration: `/etc/barman.conf`

```
[barman]

barman_user = <system_user_name>
configuration_files_directory = /etc/barman.d
barman_home = /var/lib/barman
log_file = /var/log/barman/barman.log
log_level = INFO
compression = gzip
```

- Server Configuration: `/etc/barman.d/<server_name>/`

```
[<server_name>]

description = "<server_description>"
conninfo = host=192.168.168.167 port=6432 user=longze dbname=<server_name>
streaming_conninfo = host=192.168.168.167 port=6432 user=streaming_barman
backup_method = postgres
streaming_archiver = on
slot_name = barman
```

## Postgres Docker

### Dockerfile

```
FROM postgres:9.6

RUN apt-get update && apt-get install -y \
 && apt-get clean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

CMD ["postgres"]
```

### Config

- Host-based Authentication in `$PGDATA/pg_hba.conf`:

```
host <server_name> barman 172.17.0.0/24 trust
host replication streaming_barman 172.17.0.0/24 trust
```

- Write Ahead Log, Replication and Archiving in `$PGDATA/postgresql.conf`

```
wal_level = replica

max_wal_senders = 3
max_replication_slots = 3
```

## Streaming Backup

### One Time Setup

On the postgres server, create the `barman`(`SUPERVISOR` and `LOGIN`) and `streaming_barman` (`REPLICATION` and `LOGIN`) database roles.

On the barman server, create a replication slot for barman by `barman receive-wal --create-slot <server_name>`. Then run `barman check <server_name>` to verify the configuration. However, there can still be a few failures after correct configuration.

```
Server pg_osf:
    WAL archive: FAILED (please make sure WAL shipping is setup)
    PostgreSQL: OK
    superuser: OK
    PostgreSQL streaming: OK
    wal_level: OK
    replication slot: FAILED (slot 'barman' not active: is 'receive-wal' running?)
    directories: OK
    retention policy settings: OK
    backup maximum age: OK (no last_backup_maximum_age provided)
    compression settings: OK
    failed backups: OK (there are 0 failed backups)
    minimum redundancy requirements: OK (have 0 backups, expected at least 0)
    pg_basebackup: OK
    pg_basebackup compatible: OK
    pg_basebackup supports tablespaces mapping: OK
    pg_receivexlog: OK
    pg_receivexlog compatible: OK
    receive-wal running: FAILED (See the Barman log file for more details)
    archiver errors: OK
```

These two failures `receive-wal running: FAILED (See the Barman log file for more details)` and `replication slot: FAILED (slot 'barman' not active: is 'receive-wal' running?)` means you don't have `receive-wal` running. To fix this, run `barman receive-wal <server_name>` or `barman cron`.

This failure `WAL archive: FAILED (please make sure WAL shipping is setup)` occurs if there is nothing in the archive when WAL segments is not full yet. Use `barman switch-xlog --force --archive <server_name>` to force a segment switch and archive.

```
root@d0973c1b310b:/# barman switch-xlog --force --archive pg_osf
The xlog file 00000001000000010000002E has been closed on server 'pg_osf'
Waiting for the xlog file 00000001000000010000002E from server 'pg_osf' (max: 30 seconds)
Processing xlog segments from streaming for pg_osf
        00000001000000010000002E
```

Take a look at `/var/lib/barman/<server_name>/wals/` and `/var/lib/barman/<server_name>/streaming/` and you will find archived WALs and the current streaming WAL.

```
root@d0973c1b310b:/# ls -la /var/lib/barman/pg_osf/wals/0000000100000001/
total 120
drwxr-xr-x 2 root root   4096 Mar 31 18:50 .
drwxr-xr-x 3 root root   4096 Mar 31 18:50 ..
-rw------- 1 root root 112314 Mar 31 18:50 00000001000000010000002E
root@d0973c1b310b:/# ls -la /var/lib/barman/pg_osf/streaming/
total 16392
drwxr-xr-x 2 root root     4096 Mar 31 18:50 .
drwxr-xr-x 7 root root     4096 Mar 31 18:19 ..
-rw------- 1 root root 16777216 Mar 31 18:50 00000001000000010000002F.partial
```

### Barman Backup

Now `barman check` should pass. Start backup with `barman backup <server_name>`. 

### More (TDB)

* Recovery
* Manage backups
* Backup the backup to Amazon S3
