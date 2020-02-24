#!/bin/bash
set -eux

/scripts/update.sh

apt-get install -y \
  xvfb \
  x11vnc \
  x11-xkb-utils \
  xfonts-100dpi \
  xfonts-75dpi \
  xfonts-scalable \
  xfonts-cyrillic \
  x11-apps

/scripts/cleanup.sh
