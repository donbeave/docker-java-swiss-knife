#!/bin/bash

set +e

DOCKER_VERSION=$(docker --version)
REDIS_VERSION=$(redis-server --version)
POSTGRESQL_VERSION=$(psql --version)
RABBITMQ_VERSION=$(rabbitmqctl version)
MONGODB_VERSION=$(mongod --version)
NODEJS_VERSION=$(node --version)

printf "\n------\n"

printf "\e[1;37m%s\e[0m %s\n" "DOCKER" "${DOCKER_VERSION}"
printf "\e[1;37m%s\e[0m %s\n" "REDIS" "${REDIS_VERSION}"
printf "\e[1;37m%s\e[0m %s\n" "POSTGRESQL" "${POSTGRESQL_VERSION}"
printf "\e[1;37m%s\e[0m %s\n" "RABBITMQ" "${RABBITMQ_VERSION}"
printf "\e[1;37m%s\e[0m %s\n" "NODEJS" "${NODEJS_VERSION}"
printf "\e[1;37m%s\e[0m %s\n" "MONGODB" "${MONGODB_VERSION}"

printf "\n------\n"

set -e

if [ "$DNS_SERVER_IP" ]; then
  echo "nameserver ${DNS_SERVER_IP}" >/etc/resolv.conf

  echo "DNS_SERVER_IP: ${DNS_SERVER_IP}"
fi

[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

exec "$@"
