#!/bin/bash

set -euo pipefail

# Absolute path to this script's own directory - lets the script run from any CWD.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Use a temporary Docker config to avoid affecting Docker Desktop login
DOCKER_CONFIG=$(mktemp -d)
export DOCKER_CONFIG
ln -s ~/.docker/cli-plugins "$DOCKER_CONFIG/cli-plugins"
trap 'docker logout 2>/dev/null; rm -rf "$DOCKER_CONFIG"' EXIT

docker login -u defaultvalue

docker container prune -f
docker image prune -af

export DOCKER_BUILDKIT=1
docker buildx create --name phpbuilder --use
docker buildx inspect --bootstrap

#cd "$SCRIPT_DIR/templates/php/5.6/" || exit
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:5.6.40-production . -f production.Dockerfile --push
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:5.6.40-development . -f development.Dockerfile --push
#
#cd "$SCRIPT_DIR/templates/php/7.0/" || exit
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.0.33-production . -f production.Dockerfile --push
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.0.33-development . -f development.Dockerfile --push
#
#cd "$SCRIPT_DIR/templates/php/7.1/" || exit
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.1.33-production . -f production.Dockerfile --push
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.1.33-development . -f development.Dockerfile --push
#
#cd "$SCRIPT_DIR/templates/php/7.2/" || exit
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.2.34-production . -f production.Dockerfile --push
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.2.34-development . -f development.Dockerfile --push
#
#cd "$SCRIPT_DIR/templates/php/7.3/" || exit
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.3.33-production . -f production.Dockerfile --push
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.3.33-development . -f development.Dockerfile --push
#
#cd "$SCRIPT_DIR/templates/php/7.4/" || exit
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.4.33.11-production . -f production.Dockerfile --push
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.4.33.1-development . -f development.Dockerfile --push
#
#cd "$SCRIPT_DIR/templates/php/8.0/" || exit
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.0.30.1-production . -f production.Dockerfile --push
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.0.30.1-development . -f development.Dockerfile --push
#
#cd "$SCRIPT_DIR/templates/php/8.1/" || exit
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.1.34-production . -f production.Dockerfile --push
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.1.34-development . -f development.Dockerfile --push

cd "$SCRIPT_DIR/templates/php/8.2/" || exit
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.2.32-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.2.32-development . -f development.Dockerfile --push

cd "$SCRIPT_DIR/templates/php/8.3/apache/" || exit
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.3.32-apache-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.3.32-apache-development . -f development.Dockerfile --push

cd "$SCRIPT_DIR/templates/php/8.3/fpm/" || exit
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.3.32-fpm-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.3.32-fpm-development . -f development.Dockerfile --push

cd "$SCRIPT_DIR/templates/php/8.4/apache/" || exit
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.4.23-apache-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.4.23-apache-development . -f development.Dockerfile --push

cd "$SCRIPT_DIR/templates/php/8.4/fpm/" || exit
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.4.23-fpm-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.4.23-fpm-development . -f development.Dockerfile --push

cd "$SCRIPT_DIR/templates/php/8.5/apache/" || exit
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.5.8-apache-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.5.8-apache-development . -f development.Dockerfile --push

cd "$SCRIPT_DIR/templates/php/8.5/fpm/" || exit
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.5.8-fpm-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.5.8-fpm-development . -f development.Dockerfile --push

docker buildx stop phpbuilder
docker buildx rm phpbuilder
docker buildx prune --all -f
docker buildx ls