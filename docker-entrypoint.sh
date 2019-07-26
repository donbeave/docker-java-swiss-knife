#!/bin/bash

set +e

mkdir -p /dev/net
mknod /dev/net/tun c 10 200
chmod 600 /dev/net/tun

set -e

export DOCKER_VERSION=`docker --version`
export REDIS_VERSION=`redis-server --version`
export POSTGRESQL_VERSION=`psql --version`
export RABBITMQ_VERSION=`rabbitmqctl version`
export MONGODB_VERSION=`mongod --version`
export NODEJS_VERSION=`node --version`

echo "DOCKER"
echo ${DOCKER_VERSION}
echo ""

echo "REDIS"
echo ${REDIS_VERSION}
echo ""

echo "POSTGRESQL"
echo ${POSTGRESQL_VERSION}
echo ""

echo "RABBITMQ"
echo ${RABBITMQ_VERSION}
echo ""

echo "MONGODB"
echo ${MONGODB_VERSION}
echo ""

echo "NODEJS"
echo ${NODEJS_VERSION}
echo ""

if [ "$DNS_SERVER_IP" ]; then
    echo "nameserver ${DNS_SERVER_IP}" > /etc/resolv.conf

    echo "DNS_SERVER_IP: ${DNS_SERVER_IP}"
fi

source $HOME/.sdkman/bin/sdkman-init.sh

exec "$@"
