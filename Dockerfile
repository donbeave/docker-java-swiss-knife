FROM ubuntu:16.04

MAINTAINER Alexey Zhokhov <alexey@zhokhov.com>

# Update apt-get
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
               nano \
               ca-certificates \
               curl \
               wget \
               ssh \
               net-tools \
               openvpn \
               software-properties-common \
               procps \
               httpie \
               dnsutils \
               unzip \
               uchardet \
               git \
    && rm -rf /var/lib/apt/lists/* /tmp/*

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && apt-get upgrade -y && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN locale-gen en_US.UTF-8

ADD locale.sh /
RUN chmod a+x /locale.sh
RUN /locale.sh

COPY docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/bin/sleep", "300]
