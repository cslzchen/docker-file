FROM postgres:9.6

RUN apt-get update && apt-get install -y \
        barman \
        net-tools \
        vim \
 && apt-get clean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

# SSH config.
RUN mkdir /var/run/sshd

# Config
COPY config/barman.conf /etc/barman.conf

EXPOSE 22

CMD ["postgres"]

