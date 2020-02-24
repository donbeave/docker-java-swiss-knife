#!/bin/bash
set -eux

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

/scripts/update.sh

apt-get install -y \
  google-chrome-stable

/scripts/update.sh

/scripts/cleanup.sh
