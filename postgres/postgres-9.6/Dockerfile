FROM postgres:9.6

RUN apt-get update && apt-get install -y \
        net-tools \
        openssh-server \
        rsync \
        vim \
 && apt-get clean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

# SSH config.
RUN mkdir /var/run/sshd

EXPOSE 22

CMD ["postgres"]

