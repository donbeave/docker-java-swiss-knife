#!/usr/bin/env bash
ABSOLUTE_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "${ABSOLUTE_PATH}" || exit

set -e

# config
PACKAGE="java-swiss-knife"
VERSION=${1:-"openjdk11"}
DOCKER_REPOSITORY="donbeave/$PACKAGE"
DOCKERFILE="Dockerfile-${VERSION}"
# @end config

printf "> \e[1;37mBuilding Docker\e[0m\n"

printf "\n# Image \e[1;37m%s\e[0m\n\n" "${DOCKER_REPOSITORY}:${VERSION}"

docker build -f "${DOCKERFILE}" -t ${DOCKER_REPOSITORY}:"${VERSION}" ./