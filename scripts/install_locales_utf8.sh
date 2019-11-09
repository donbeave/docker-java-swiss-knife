#!/bin/bash
set -eux

/scripts/update.sh

apt-get install -y --no-install-recommends \
  locales

locale-gen en_US.UTF-8

sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen

echo 'LANG="en_US.UTF-8"' >/etc/default/locale

dpkg-reconfigure --frontend=noninteractive locales

update-locale LANG=en_US.UTF-8

/scripts/cleanup.sh
