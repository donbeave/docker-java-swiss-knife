FROM debian:buster

MAINTAINER Alexey Zhokhov <alexey@zhokhov.com>

ENV DEBIAN_FRONTEND noninteractive

ADD scripts /scripts
RUN chmod a+x /scripts/*

RUN /scripts/install_locales_utf8.sh
RUN /scripts/install_adoptopenjdk13_hotspot.sh
RUN /scripts/install_docker.sh
RUN /scripts/install_p7zip.sh

ENV JAVA_HOME=/opt/java/adoptopenjdk13 \
    PATH="/opt/java/adoptopenjdk13/bin:$PATH"

CMD ["tail", "-f", "/dev/null"]
