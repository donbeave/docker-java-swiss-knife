#!/bin/bash

set +e

printf "\e[1;37m%s\e[0m\n" "JAVA"
java -version
echo ""

printf "\e[1;37m%s\e[0m\n" "DOCKER"
docker --version
echo ""

printf "\e[1;37m%s\e[0m\n" "REDIS"
redis-server --version
echo ""

printf "\e[1;37m%s\e[0m\n" "POSTGRESQL"
psql --version
echo ""

printf "\e[1;37m%s\e[0m\n" "RABBITMQ"
rabbitmqctl version
echo ""

printf "\e[1;37m%s\e[0m\n" "MONGODB"
mongod --version
echo ""

printf "\e[1;37m%s\e[0m\n" "NODEJS"
node --version
echo ""

set -e

if [ "$DNS_SERVER_IP" ]; then
  echo "nameserver ${DNS_SERVER_IP}" >/etc/resolv.conf

  echo "DNS_SERVER_IP: ${DNS_SERVER_IP}"
fi

[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

exec "$@"
