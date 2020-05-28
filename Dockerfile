FROM debian:buster

MAINTAINER Alexey Zhokhov <alexey@zhokhov.com>

ENV DEBIAN_FRONTEND noninteractive

ADD scripts /scripts
RUN chmod a+x /scripts/*

RUN /scripts/install_locales_utf8.sh
RUN /scripts/install_adoptopenjdk14_hotspot.sh
RUN /scripts/install_docker.sh
RUN /scripts/install_p7zip.sh
RUN /scripts/install_xvfb.sh
RUN /scripts/install_google_chrome.sh
RUN /scripts/install_chrome_driver.sh

ADD files/xvfb_init.sh /etc/init.d/xvfb
RUN chmod a+x /etc/init.d/xvfb

ENV DISPLAY :99

# additional packages
RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
               procps \
               net-tools \
               iputils-ping \
               dnsutils \
               curl \
               wget \
               httpie \
               gnupg \
               psmisc \
               openvpn \
               unzip \
    && rm -rf /var/lib/apt/lists/* \
              /var/cache/apt/* \
              /tmp/*

ENV JAVA_HOME=/opt/java/adoptopenjdk14 \
    PATH="/opt/java/adoptopenjdk14/bin:$PATH"

CMD ["tail", "-f", "/dev/null"]
