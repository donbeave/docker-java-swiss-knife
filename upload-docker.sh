#!/usr/bin/env bash
ABSOLUTE_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "${ABSOLUTE_PATH}" || exit

set -e

# config
PACKAGE="java-swiss-knife"
VERSION="latest"
DOCKER_REPOSITORY="registry.gitlab.com/donbeave/docker-java-swiss-knife"
# @end config

printf "> \e[1;37mUploading Docker\e[0m\n\n"

if [[ -z "${DOCKER_USERNAME}" ]]; then
  printf "\e[1;91mERROR\e[0m: DOCKER_USERNAME is not set\n"
  exit 1
fi

if [[ -z "${DOCKER_PASSWORD}" ]]; then
  printf "\e[1;91mERROR\e[0m: DOCKER_PASSWORD is not set\n"
  exit 1
fi

printf "# \e[93mLogin to the registry\e[0m\n\n"

docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}" registry.gitlab.com

printf "\n> \e[1;37mUploading Docker image\e[0m\n"
printf "# Image \e[1;37m%s\e[0m\n\n" "${DOCKER_REPOSITORY}:${VERSION}"

docker push ${DOCKER_REPOSITORY}:"${VERSION}"
