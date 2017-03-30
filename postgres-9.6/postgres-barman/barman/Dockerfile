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

