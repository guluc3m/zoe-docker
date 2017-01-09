FROM debian:jessie

RUN apt-get update
RUN apt-get install -y rabbitmq-server netcat.openbsd

ADD start-rabbitmq /tmp

CMD /bin/bash /tmp/start-rabbitmq

