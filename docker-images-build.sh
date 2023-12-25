#!/bin/bash
# 1. Build development and production images
# 2. Run `DOCKERIZER magento:test dockerfiles`
# 3. Push images

# Check extensions list and custom PHP configuration file
# docker exec -it $(DOCKERIZER composition:get-container-name php) php -v
# docker exec -it $(DOCKERIZER composition:get-container-name php) php -r 'var_export(get_loaded_extensions());'
# docker exec -it $(DOCKERIZER composition:get-container-name php) php -r 'var_export(get_loaded_extensions(true));'
# docker exec -it $(DOCKERIZER composition:get-container-name php) cat /usr/local/etc/php/conf.d/docker-php-xxx-custom.ini

# === MocOS ===
# Replace `docker build` with `docker build --platform linux/arm64/v8`

set -e

docker container prune -f
docker image prune -af

cd ~/misc/apps/docker_infrastructure/templates/php/5.6/ || exit
docker build -t defaultvalue/php:5.6.40-production . -f production.Dockerfile
docker build -t defaultvalue/php:5.6.40-development . -f development.Dockerfile

cd ~/misc/apps/docker_infrastructure/templates/php/7.0/ || exit
docker build -t defaultvalue/php:7.0.33-production . -f production.Dockerfile
docker build -t defaultvalue/php:7.0.33-development . -f development.Dockerfile

cd ~/misc/apps/docker_infrastructure/templates/php/7.1/ || exit
docker build -t defaultvalue/php:7.1.33-production . -f production.Dockerfile
docker build -t defaultvalue/php:7.1.33-development . -f development.Dockerfile

cd ~/misc/apps/docker_infrastructure/templates/php/7.2/ || exit
docker build -t defaultvalue/php:7.2.34-production . -f production.Dockerfile
docker build -t defaultvalue/php:7.2.34-development . -f development.Dockerfile

cd ~/misc/apps/docker_infrastructure/templates/php/7.3/ || exit
docker build -t defaultvalue/php:7.3.33-production . -f production.Dockerfile
docker build -t defaultvalue/php:7.3.33-development . -f development.Dockerfile

cd ~/misc/apps/docker_infrastructure/templates/php/7.4/ || exit
docker build -t defaultvalue/php:7.4.33-production . -f production.Dockerfile
docker build -t defaultvalue/php:7.4.33-development . -f development.Dockerfile

cd ~/misc/apps/docker_infrastructure/templates/php/8.0/ || exit
docker build -t defaultvalue/php:8.0.30-production . -f production.Dockerfile
docker build -t defaultvalue/php:8.0.30-development . -f development.Dockerfile

cd ~/misc/apps/docker_infrastructure/templates/php/8.1/ || exit
docker build -t defaultvalue/php:8.1.26-production . -f production.Dockerfile
docker build -t defaultvalue/php:8.1.26-development . -f development.Dockerfile

cd ~/misc/apps/docker_infrastructure/templates/php/8.2/ || exit
docker build -t defaultvalue/php:8.2.13-production . -f production.Dockerfile
docker build -t defaultvalue/php:8.2.13-development . -f development.Dockerfile

cd ~/misc/apps/docker_infrastructure/templates/php/8.3/ || exit
docker build -t defaultvalue/php:8.3.0-production . -f production.Dockerfile
docker build -t defaultvalue/php:8.3.0-development . -f development.Dockerfile