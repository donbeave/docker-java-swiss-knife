#!/bin/bash

if [ "$DNS_SERVER_IP" ]; then
  echo "nameserver ${DNS_SERVER_IP}" >/etc/resolv.conf

  echo "DNS_SERVER_IP: ${DNS_SERVER_IP}"
fi

exec "$@"
