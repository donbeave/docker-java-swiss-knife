FROM openjdk:11.0.3-jdk-stretch

MAINTAINER Alexey Zhokhov <alexey@zhokhov.com>

ENV DEBIAN_FRONTEND noninteractive


RUN java -version


# Locale config
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
               locales \
    && rm -rf /var/lib/apt/lists/* \
              /tmp/*

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN locale-gen en_US.UTF-8

ADD locale.sh /
RUN chmod a+x /locale.sh
RUN /locale.sh
# @end Locale config


# Install basic dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
               ca-certificates \
               apt-transport-https \
               ssh \
               net-tools \
               openvpn \
               software-properties-common \
               procps \
               dnsutils \
               unzip \
               zip \
               uchardet \
               git \
               redis-server \
               nano \
               curl \
               wget \
               httpie \
               gpg-agent \
               dirmngr \
    && rm -rf /var/lib/apt/lists/* \
              /tmp/*
# @end Install basic dependencies


# Install PostgreSQL
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
               postgresql-client-11 \
               postgresql-11 \
               postgresql-contrib-11 \
    && rm -rf /var/lib/apt/lists/* \
              /tmp/*

ENV PATH $PATH:/usr/lib/postgresql/$PG_MAJOR/bin
ENV POSTGRES_HOME /usr/lib/postgresql/11/
ENV PG_MAJOR 11
ENV PGDATA /var/lib/postgresql/data

# make the sample config easier to munge (and "correct by default")
RUN mv -v "/usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample" /usr/share/postgresql/ \
    && ln -sv ../postgresql.conf.sample "/usr/share/postgresql/$PG_MAJOR/" \
    && sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/share/postgresql/postgresql.conf.sample

RUN mkdir -p /var/run/postgresql \
    && chown -R postgres:postgres /var/run/postgresql \
    && chmod 2777 /var/run/postgresql
RUN mkdir -p "$PGDATA" \
    && chown -R postgres:postgres "$PGDATA" \
    && chmod 777 "$PGDATA" # this 777 will be replaced by 700 at runtime (allows semi-arbitrary "--user" values)

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "local   all             all                                     trust" > /etc/postgresql/$PG_MAJOR/main/pg_hba.conf
RUN echo "host    all             all             127.0.0.1/32            trust" >> /etc/postgresql/$PG_MAJOR/main/pg_hba.conf
RUN echo "host    all             all             ::1/128                 trust" >> /etc/postgresql/$PG_MAJOR/main/pg_hba.conf
RUN echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/$PG_MAJOR/main/pg_hba.conf

COPY postgresql.conf /etc/postgresql/$PG_MAJOR/main/
# @end Install PostgreSQL


# Install RabbitMQ
RUN wget -O - "https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc" | apt-key add -

RUN echo "deb https://dl.bintray.com/rabbitmq-erlang/debian stretch erlang" > /etc/apt/sources.list.d/bintray.rabbitmq.list
RUN echo "deb https://dl.bintray.com/rabbitmq/debian stretch main" >> /etc/apt/sources.list.d/bintray.rabbitmq.list

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
               rabbitmq-server \
    && rm -rf /var/lib/apt/lists/* \
              /tmp/*

RUN rabbitmq-plugins enable --offline rabbitmq_federation
RUN rabbitmq-plugins enable --offline rabbitmq_federation_management
RUN rabbitmq-plugins enable --offline rabbitmq_shovel
RUN rabbitmq-plugins enable --offline rabbitmq_shovel_management
# @end Install RabbitMQ


# Install MongoDB
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
RUN echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" >> /etc/apt/sources.list.d/mongodb-org-4.0.list

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
               mongodb-org \
    && rm -rf /var/lib/apt/lists/* /tmp/*

RUN cd /etc/init.d \
    && wget https://raw.githubusercontent.com/mongodb/mongo/master/debian/init.d -O mongod \
    && chmod a+x mongod
# Install MongoDB


# Install Docker
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
               apt-transport-https \
               ca-certificates \
               curl \
               gnupg2 \
               software-properties-common \
    && rm -rf /var/lib/apt/lists/* \
              /tmp/*
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
               docker-ce \
               docker-ce-cli \
               containerd.io \
    && rm -rf /var/lib/apt/lists/* \
              /tmp/*
# @end Install Docker


# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
               nodejs \
               gcc \
               g++ \
               make \
    && rm -rf /var/lib/apt/lists/* \
              /tmp/*
# @end Install Node.js


# Install Yarn
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y yarn \
    && rm -rf /var/lib/apt/lists/* \
              /tmp/*
# @end Install Yarn


# Install SDKMAN
RUN curl -s "https://get.sdkman.io" | bash
ENV SDKMAN_DIR=/root/.sdkman
# @end Install SDKMAN


# Install Groovy
RUN bash -c "source $SDKMAN_DIR/bin/sdkman-init.sh && sdk install groovy"
# @end Install Groovy


COPY docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["tail", "-f", "/dev/null"]
