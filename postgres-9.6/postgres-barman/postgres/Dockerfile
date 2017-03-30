FROM postgres:9.6

RUN apt-get update && apt-get install -y \
 && apt-get clean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

CMD ["postgres"]

