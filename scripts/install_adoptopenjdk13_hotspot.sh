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

ESUM='2226366d7dffb3eb4ec3d14101f4ddb4259195aa43bb319a93810447b8384930'
BINARY_URL='https://github.com/AdoptOpenJDK/openjdk13-binaries/releases/download/jdk-13.0.1%2B9/OpenJDK13U-jdk_x64_linux_hotspot_13.0.1_9.tar.gz'

curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}
echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -
mkdir -p /opt/java/adoptopenjdk13
cd /opt/java/adoptopenjdk13
tar -xf /tmp/openjdk.tar.gz --strip-components=1

/scripts/cleanup.sh
