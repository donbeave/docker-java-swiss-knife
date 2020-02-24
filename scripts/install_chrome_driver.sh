#!/bin/bash
set -eux

CHROMEDRIVER_VERSION=$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE)
mkdir -p /opt/chromedriver-"$CHROMEDRIVER_VERSION"
curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/"$CHROMEDRIVER_VERSION"/chromedriver_linux64.zip
unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-"$CHROMEDRIVER_VERSION"
rm /tmp/chromedriver_linux64.zip
chmod +x /opt/chromedriver-"$CHROMEDRIVER_VERSION"/chromedriver
ln -fs /opt/chromedriver-"$CHROMEDRIVER_VERSION"/chromedriver /usr/local/bin/chromedriver

/scripts/cleanup.sh
