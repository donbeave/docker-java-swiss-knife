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

# postgresql
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" >> /etc/apt/sources.list.d/pgdg.list 
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - 

# Update apt-get
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
               postgresql-client-10 \
               postgresql-10 \
               postgresql-contrib-10 \
    && rm -rf /var/lib/apt/lists/* /tmp/*
ENV PATH $PATH:/usr/lib/postgresql/$PG_MAJOR/bin
ENV POSTGRES_HOME /usr/lib/postgresql/10/
ENV PG_MAJOR 10
ENV PGDATA /var/lib/postgresql/data

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN locale-gen en_US.UTF-8

ADD locale.sh /
RUN chmod a+x /locale.sh
RUN /locale.sh

# make the sample config easier to munge (and "correct by default")
RUN mv -v "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample" /usr/share/postgresql/ \
  && ln -sv ../postgresql.conf.sample "/usr/share/postgresql/$PG_MAJOR/" \
  && sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/share/postgresql/postgresql.conf.sample

RUN mkdir -p /var/run/postgresql && chown -R postgres:postgres /var/run/postgresql && chmod 2777 /var/run/postgresql
RUN mkdir -p "$PGDATA" && chown -R postgres:postgres "$PGDATA" && chmod 777 "$PGDATA" # this 777 will be replaced by 700 at runtime (allows semi-arbitrary "--user" values)

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "local   all             all                                     trust" > /etc/postgresql/$PG_MAJOR/main/pg_hba.conf
RUN echo "host    all             all             127.0.0.1/32            trust" >> /etc/postgresql/$PG_MAJOR/main/pg_hba.conf
RUN echo "host    all             all             ::1/128                 trust" >> /etc/postgresql/$PG_MAJOR/main/pg_hba.conf
RUN echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/$PG_MAJOR/main/pg_hba.conf

COPY postgresql.conf /etc/postgresql/$PG_MAJOR/main/

COPY docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/bin/sleep", "300]
