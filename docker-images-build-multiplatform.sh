#!/bin/bash

set -euo pipefail

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

#cd ~/misc/apps/docker_infrastructure/templates/php/5.6/ || exit
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:5.6.40-production . -f production.Dockerfile --push
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:5.6.40-development . -f development.Dockerfile --push
#
#cd ~/misc/apps/docker_infrastructure/templates/php/7.0/ || exit
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.0.33-production . -f production.Dockerfile --push
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.0.33-development . -f development.Dockerfile --push
#
#cd ~/misc/apps/docker_infrastructure/templates/php/7.1/ || exit
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.1.33-production . -f production.Dockerfile --push
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.1.33-development . -f development.Dockerfile --push
#
#cd ~/misc/apps/docker_infrastructure/templates/php/7.2/ || exit
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.2.34-production . -f production.Dockerfile --push
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.2.34-development . -f development.Dockerfile --push
#
#cd ~/misc/apps/docker_infrastructure/templates/php/7.3/ || exit
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.3.33-production . -f production.Dockerfile --push
#docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.3.33-development . -f development.Dockerfile --push
#
cd ~/misc/apps/docker_infrastructure/templates/php/7.4/ || exit
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.4.33.11-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:7.4.33.1-development . -f development.Dockerfile --push

cd ~/misc/apps/docker_infrastructure/templates/php/8.0/ || exit
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.0.30.1-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.0.30.1-development . -f development.Dockerfile --push

cd ~/misc/apps/docker_infrastructure/templates/php/8.1/ || exit
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.1.34-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.1.34-development . -f development.Dockerfile --push

cd ~/misc/apps/docker_infrastructure/templates/php/8.2/ || exit
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.2.30-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.2.30-development . -f development.Dockerfile --push

cd ~/misc/apps/docker_infrastructure/templates/php/8.3/ || exit
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.3.30.1-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.3.30.1-development . -f development.Dockerfile --push

cd ~/misc/apps/docker_infrastructure/templates/php/8.4/ || exit
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.4.19-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.4.19-development . -f development.Dockerfile --push

cd ~/misc/apps/docker_infrastructure/templates/php/8.5/ || exit
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.5.4-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64 -t defaultvalue/php:8.5.4-development . -f development.Dockerfile --push

docker buildx stop phpbuilder
docker buildx rm phpbuilder
docker buildx prune --all -f
docker buildx ls