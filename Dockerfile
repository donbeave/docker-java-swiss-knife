FROM ubuntu:18.04

MAINTAINER Alexey Zhokhov <alexey@zhokhov.com>

ENV DEBIAN_FRONTEND noninteractive

ADD scripts /scripts
RUN chmod a+x /scripts/*

RUN /scripts/install_locales_utf8.sh
RUN /scripts/install_adoptopenjdk13_hotspot.sh
RUN /scripts/install_docker.sh

CMD ["tail", "-f", "/dev/null"]
