#!/bin/bash
set -eux

export LANG='en_US.UTF-8'
export LANGUAGE='en_US:en'
export LC_ALL='en_US.UTF-8'

/scripts/update.sh

apt-get install -y --no-install-recommends \
  curl \
  ca-certificates \
  fontconfig \
  locales

echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
locale-gen en_US.UTF-8

ESUM='9ddf9b35996fbd784a53fff3e0d59920a7d5acf1a82d4c8d70906957ac146cd1'
BINARY_URL='https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.1%2B7/OpenJDK14U-jdk_x64_linux_hotspot_14.0.1_7.tar.gz'

curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}
echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -
mkdir -p /opt/java/adoptopenjdk14
cd /opt/java/adoptopenjdk14
tar -xf /tmp/openjdk.tar.gz --strip-components=1

/scripts/cleanup.sh
