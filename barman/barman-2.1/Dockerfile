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

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Config
COPY config/barman.conf /etc/barman.conf

EXPOSE 22

CMD ["postgres"]

