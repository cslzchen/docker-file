# Docker Configuration Files and Command Scripts.

## Issues, Solutions and Workarounds (OSX)

### Host-Docker and Docker-Docker Network Communication

* From Host to Docker

  Use `EXPOSE` and `--publish` (or `-p`, `-P`). Personally, I use default ports within the container and map them to fixed host ports. For example, I use 10022, 20022 for `ssh` server and 15432, 25432, for `postgres` server. 

* From Docker to Host and From Docker to Docker

  For `OSX`, there are [several limitations](https://docs.docker.com/docker-for-mac/networking/#known-limitations-use-cases-and-workarounds). One is connecting from a container to a service on the host. The workaround is to assign an unused IP address to `lo0` and use this IP. Personally, I have `sudo ifconfig lo0 alias 192.168.168.167/24`. This also solves the inter-docker communication  as well. Another limitation is that all docker containers run at the same IP address. The same service on different dockers cannot listen to the same port. The workaround is to use another one and map it.

### Docker with `ssh`

* This [configuration](https://docs.docker.com/engine/examples/running_ssh_service/) is not necessary and the following should do the work.
```
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server

RUN mkdir /var/run/sshd

EXPOSE 22

CMD ["/usr/sbin/ssh", -D]
```

* Generate public and private key pairs and update `.ssh/authorized_keys` and `.ssh/known_hosts`.

* Update (or double check) that `.ssh` and its contents are in the correct directory and have correct permissions.

### Docker with Postgres

* `postgres` cannot be started as `root`

  `CMD postgres` fails while `CMD ["postgres"]` succeeds. Use the `docker-entrypoint.sh` for `postgres-9.6` (by default) or extend it with your own.

### Dockerfile `ENTRYPOINT` and `CMD`

* [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)

* [Understanding How `CMD` and `Entrypoint` Interact](https://docs.docker.com/engine/reference/builder/#understand-how-cmd-and-entrypoint-interact) 

* [Use Supervisor with Docker](https://docs.docker.com/engine/admin/using_supervisord/)

