#!/bin/bash
set -eux

/scripts/update.sh

apt-get install -y \
  p7zip \
  p7zip-full

/scripts/cleanup.sh
