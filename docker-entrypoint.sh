#!/bin/bash

set +e

mkdir -p /dev/net
mknod /dev/net/tun c 10 200
chmod 600 /dev/net/tun

set -e

if [ "$DNS_SERVER_IP" ]; then
    echo "nameserver ${DNS_SERVER_IP}" > /etc/resolv.conf

    echo "DNS_SERVER_IP: ${DNS_SERVER_IP}"
fi

source $HOME/.sdkman/bin/sdkman-init.sh

exec "$@"
