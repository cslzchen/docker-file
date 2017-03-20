FROM postgres:9.6

RUN apt-get update && apt-get install -y \
        barman \
        net-tools \
        vim \
 && rm -rf /var/lib/apt/lists/*

CMD ["postgres"]
