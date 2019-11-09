#!/bin/bash
set -eux

/scripts/update.sh

apt-get install -y \
  python3 \
  python3-pip

pip3 install awscli

/scripts/cleanup.sh
