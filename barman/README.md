# Docker Configuration for Barman.

## Barman

### Docerfile

Requires `postgres-9.6` and `barman-2.1`.

```
FROM postgres:9.6

RUN apt-get update && apt-get install -y \
        barman \
 && apt-get clean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

CMD ["postgres"]
```

### Config

For main configuration `barman.conf`, update the `barman_user` with the current system user, or create a new system user named `barman`.

```
[barman]
barman_user = root
configuration_files_directory = /etc/barman.d
barman_home = /var/lib/barman
log_file = /var/log/barman/barman.log
log_level = INFO
compression = gzip
```

For each server configuration in `/etc/barman.d`, update connection information and `rsync/ssh` settings.

```
[pg_osf]
description = "Open Science Framework"
conninfo = host=192.168.168.167 port=6432 user=longze dbname=osf
streaming_conninfo = host=192.168.168.167 port=6432 user=streaming_barman dbname=osf
backup_method = rsync
reuse_backup = link
ssh_command = ssh root@192.168.168.167 -p 6022
streaming_archiver = on
slot_name = barman
```

## Postgres

### Dockerfile

Requires `postgres-9.6` and latest `openssh-server` and `rsync`.

```
FROM postgres:9.6

RUN apt-get update && apt-get install -y \
        openssh-server \
        rsync \
        vim \
 && apt-get clean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

CMD ["postgres"]
```

### Config

Host-based Authentication in `$PGDATA/pg_hba.conf`

```
host osf barman 172.17.0.0/24 trust
host replication streaming_barman 172.17.0.0/24 trust
```

Write Ahead Log in `$PGDATA/postgresql.conf`
```
wal_level = replica

```

Archiving in `$PGDATA/postgresql.conf`

```
archive_mode = on
archive_command = 'rsync -a -e "ssh -p 7022" %p root@192.168.168.167:/var/lib/barman/pg_osf/incoming/%f'
```

Replication in `$PGDATA/postgresql.conf`
```
max_wal_senders = 3
max_replication_slots = 3
```
