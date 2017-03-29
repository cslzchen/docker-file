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

