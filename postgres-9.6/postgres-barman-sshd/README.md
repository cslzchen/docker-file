# Docker Configuration for Barman Streaming Backup Using `rsync/ssh`

## Barman Docker

### Docerfile

```
FROM postgres:9.6

RUN apt-get update && apt-get install -y \
        barman \
 && apt-get clean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

# SSH config.
RUN mkdir /var/run/sshd
RUN mkdir /root/.ssh
COPY no-git/.ssh/* /root/.ssh/

# Barman config
COPY config/barman.conf /etc/barman.conf
COPY config/pg_osf.conf /etc/barman.d/pg_osf.conf
COPY scripts/* /root/

# Barman backup location
VOLUME ["/var/lib/barman"]

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
```

### Config

- Main Configuration: `/etc/barman.conf`

```
[barman]

barman_user = root
configuration_files_directory = /etc/barman.d
barman_home = /var/lib/barman
log_file = /var/log/barman/barman.log
log_level = INFO
compression = gzip
```

- Server Configuration: `/etc/barman.d/<server_name>/`

```
[pg_osf]

description = "<server_description>"
conninfo = host=192.168.168.167 port=6432 user=longze dbname=osf
streaming_conninfo = host=192.168.168.167 port=6432 user=streaming_barman dbname=osf
backup_method = rsync
reuse_backup = link
ssh_command = ssh postgres@192.168.168.167 -p 6022
streaming_archiver = on
slot_name = barman
```

## Postgres Docker

### Dockerfile

```
FROM postgres:9.6

RUN apt-get update && apt-get install -y \
        openssh-server \
        rsync \
 && apt-get clean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

# SSH config.
RUN mkdir /var/run/sshd
RUN mkdir /root/.ssh
COPY no-git/.ssh/* /root/.ssh/
COPY scripts/* /root/

EXPOSE 22

CMD ["postgres"]
```

### Config

- Host-based Authentication in `$PGDATA/pg_hba.conf`:

```
host osf barman 172.17.0.0/24 trust
host replication streaming_barman 172.17.0.0/24 trust
```

- Write Ahead Log, Replication and Archiving in `$PGDATA/postgresql.conf`

```
wal_level = replica

max_wal_senders = 3
max_replication_slots = 3

archive_mode = on
archive_command = 'rsync -a -e "ssh -p 7022" %p root@192.168.168.167:/var/lib/barman/pg_osf/incoming/%f'
```

## Streaming Backup

### One Time Setup

First, on the postgres server, create the `barman`(`SUPERVISOR` and `LOGIN`) and `streaming_barman` (`REPLICATION` and `LOGIN`) database roles. Run `/root/setup.sh` to configure and verify `ssh` connections to the barman server. This script also starts `sshd` for barman server to connect. Second, on the barman server, run the `/root/setup.sh` to verify the connections.


### Barman Backup

- Start Barman Cron: `barman cron`

- Trigger the Archiving Process: `barman switch-xlog --force --archive <server_name>`

- Check Barman Status: `barman check <server_name>`

- Start Backup: `barman backup <server_name>`

- View Backup: `barman list-backup <server_name>`

- Restore: `barman recover <server_name> <backup_id> <path_to_recover_dir>`
