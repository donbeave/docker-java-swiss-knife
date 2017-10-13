#!/bin/bash

PACKAGE="java-swiss-knife"
VERSION="latest"

set -e

echo "> 1. Building Docker image"
echo ""
docker build -t donbeave/$PACKAGE:$VERSION .
