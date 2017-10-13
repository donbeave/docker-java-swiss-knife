#!/bin/bash
set -e

mkdir -p /dev/net
mknod /dev/net/tun c 10 200
chmod 600 /dev/net/tun

if [ "$DNS_SERVER_IP" ]; then
    echo "nameserver ${DNS_SERVER_IP}" > /etc/resolv.conf

    echo "DNS_SERVER_IP: ${DNS_SERVER_IP}"
fi

exec "$@"
