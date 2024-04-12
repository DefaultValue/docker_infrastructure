#!/bin/bash

set -e

docker container prune -f
docker image prune -af

DOCKER_BUILDKIT=1
docker buildx create --name phpbuilder --use
docker buildx inspect --bootstrap

cd ~/misc/apps/docker_infrastructure/templates/php/5.6/ || exit
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:5.6.40-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:5.6.40-development . -f development.Dockerfile --push

cd ~/misc/apps/docker_infrastructure/templates/php/7.0/ || exit
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:7.0.33-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:7.0.33-development . -f development.Dockerfile --push

cd ~/misc/apps/docker_infrastructure/templates/php/7.1/ || exit
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:7.1.33-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:7.1.33-development . -f development.Dockerfile --push

cd ~/misc/apps/docker_infrastructure/templates/php/7.2/ || exit
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:7.2.34-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:7.2.34-development . -f development.Dockerfile --push

cd ~/misc/apps/docker_infrastructure/templates/php/7.3/ || exit
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:7.3.33-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:7.3.33-development . -f development.Dockerfile --push

cd ~/misc/apps/docker_infrastructure/templates/php/7.4/ || exit
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:7.4.33-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:7.4.33-development . -f development.Dockerfile --push

cd ~/misc/apps/docker_infrastructure/templates/php/8.0/ || exit
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:8.0.30-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:8.0.30-development . -f development.Dockerfile --push

cd ~/misc/apps/docker_infrastructure/templates/php/8.1/ || exit
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:8.1.27-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:8.1.27-development . -f development.Dockerfile --push

cd ~/misc/apps/docker_infrastructure/templates/php/8.2/ || exit
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:8.2.18-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:8.2.18-development . -f development.Dockerfile --push

cd ~/misc/apps/docker_infrastructure/templates/php/8.3/ || exit
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:8.3.6-production . -f production.Dockerfile --push
docker buildx build --platform linux/amd64,linux/arm64,linux/arm64/v8 -t defaultvalue/php:8.3.6-development . -f development.Dockerfile --push

docker buildx stop phpbuilder
docker buildx rm phpbuilder
docker buildx prune --all -f
docker buildx ls