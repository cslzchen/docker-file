# Docker Configuration Files and Command Scripts.


## Issues, Solutions and Workarounds (OSX)

### Host-Docker and Docker-Docker Network Communication

* From Host to Docker

  Use `EXPOSE` and `--publish` (or `-p`, `-P`).

* From Docker to Host and From Docker to Docker

  Assign an unused IP to `lo0` (e.g. `sudo ifconfig lo0 alias 192.168.168.167/24`) and use this IP.

* Port

  All docker containers run at the same IP. The same service on different dockers cannot listen to the same port. The work-around is to use default ports within the dockers (e.g. `22` for SSH) and map them to `10022`, `20022`, `30022` for host.

Reference: https://docs.docker.com/docker-for-mac/networking/

### Docker with `ssh`

* Follow the configuration: https://docs.docker.com/engine/examples/running_ssh_service/.

* Generate public and private key pairs and update `.ssh/authorized_keys` and `.ssh/known_hosts`.

* Update (or double check) that `.ssh` and its contents are in the correct directory and have correct permissions.

### Docker with Postgres

* `postgres` cannot be started as `root`

  `CMD postgres` fails while `CMD ["postgres"] ` succeeds. The latter creates and uses the user `postgres` instead of `root`. However, it does not have access to `/root/.ssh`. The work-around is to create `/home/postgres/` and update permissions.

### Dockerfile `CMD` Limitation

* Only one `CMD` is allowed

  Here is the Docker Reference for CMD: https://docs.docker.com/engine/reference/builder/#cmd. The difference between `exec` mode and `shell` mode is not clear. Only the `shell` mode supports chaining command. A better solution is to use `Supervisor`: https://docs.docker.com/engine/admin/using_supervisord/.
