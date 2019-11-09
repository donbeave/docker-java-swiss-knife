#!/bin/bash
set -eux

curl -o /usr/local/bin/mc -sSL https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x /usr/local/bin/mc
/usr/local/bin/mc --version
